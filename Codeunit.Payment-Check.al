Codeunit 52092228 "Payment - Check"
{
    TableNo = "Payment Header";

    trigger OnRun()
    begin
        RunCheck(Rec);
    end;

    var
        Text001: label 'Cash Advances must be attached for retirement';
        Text002: label 'Account type cannot be %1 when payment type is %2';
        Text003: label 'must have the same sign as %1';
        ICPartner: Record "IC Partner";
        Text004: label 'This voucher must be applied to an invoice';
        Text014: label 'This option %1 is not allowed! for this type of document %2';


    procedure RunCheck(var PaymentHeader: Record "Payment Header")
    var
        PaymentLine: Record "Payment Line";
    begin
        with PaymentHeader do begin
            if "Document Type" in [0] then
                TestField("Payment Source");
            if "Document Type" = "document type"::Retirement then begin
                if not (PaymentHeader.AttachmentExists) then
                    Error(Text001);
            end;
            TestField("Document Date");
            TestField("Posting Description");
            with PaymentLine do begin
                PaymentLine.SetRange("Document Type", PaymentHeader."Document Type");
                PaymentLine.SetRange("Document No.", PaymentHeader."No.");
                if PaymentLine.FindSet then begin
                    repeat
                        PaymentLine.TestField("Account No.");
                        if "Document Type" <> "document type"::Retirement then
                            PaymentLine.TestField(Amount);
                        PaymentLine.TestField(Description);

                        case PaymentHeader."Payment Type" of
                            PaymentHeader."payment type"::"Supp. Invoice":
                                begin
                                    if not (PaymentLine."WHT Line") then begin
                                        PaymentLine.TestField("Account Type", PaymentLine."account type"::Vendor);
                                        if (PaymentLine."Applies-to Doc. No." = '') and (PaymentLine."Applies-to ID" = '') then
                                            Error(Text004);
                                    end;
                                end;
                            PaymentHeader."payment type"::"Cust. Refund":
                                PaymentLine.TestField("Account Type", PaymentLine."account type"::Customer);
                            PaymentHeader."payment type"::"Cash Advance":
                                begin
                                    if PaymentLine."Account Type" in [1, 2, 3] then
                                        Error(Text002, Format(PaymentLine."Account Type"), Format(PaymentHeader."Payment Type"));
                                end;
                        end;

                        if PaymentLine.Amount * PaymentLine."Amount (LCY)" < 0 then
                            PaymentLine.FieldError(PaymentLine."Amount (LCY)", StrSubstNo(Text003, PaymentLine.FieldCaption(PaymentLine.Amount)));

                        if PaymentLine."Job No." <> '' then
                            PaymentLine.TestField("Job Task No.");
                        if PaymentLine."Account Type" = PaymentLine."account type"::"Fixed Asset" then begin
                            PaymentLine.TestField("FA Posting Type");
                            if PaymentLine."FA Posting Type" = PaymentLine."fa posting type"::Maintenance then
                                PaymentLine.TestField("Maintenance Code");
                        end;
                        if (PaymentLine."Loan ID" <> '') then
                            PaymentLine.TestField(PaymentLine."Account Type", PaymentLine."account type"::Customer);

                        PaymentLine.CalcFields(PaymentLine."Schedule Amount");
                        if PaymentLine."Schedule Amount" <> 0 then
                            TestField(PaymentLine.Amount, PaymentLine."Schedule Amount");

                        if "Account No." <> '' then
                            case "Account Type" of
                                "account type"::"G/L Account":
                                    begin
                                        if ("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or
                                           ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')
                                        then
                                            TestField("Gen. Posting Type");
                                    end;
                                "account type"::Customer, "account type"::Vendor:
                                    begin
                                        TestField("Gen. Posting Type", 0);
                                        TestField("Gen. Bus. Posting Group", '');
                                        TestField("Gen. Prod. Posting Group", '');
                                        TestField("VAT Bus. Posting Group", '');
                                        TestField("VAT Prod. Posting Group", '');

                                    end;
                                "account type"::"Bank Account":
                                    begin
                                        TestField("Gen. Posting Type", 0);
                                        TestField("Gen. Bus. Posting Group", '');
                                        TestField("Gen. Prod. Posting Group", '');
                                        TestField("VAT Bus. Posting Group", '');
                                        TestField("VAT Prod. Posting Group", '');
                                        TestField("Job No.", '');
                                    end;
                                "account type"::"IC Partner":
                                    begin
                                        ICPartner.Get("Account No.");
                                        ICPartner.CheckICPartner;
                                    end;
                            end;
                    until PaymentLine.Next = 0;
                end;
            end;
            CheckDim;
        end;
    end;
}

