Codeunit 52092229 "Payment-Get Outst. Cash Advanc"
{
    TableNo = "Payment Header";

    trigger OnRun()
    begin
        TestField("Document Type", "document type"::Retirement);
        TestField(Status, Status::Open);
        TestField("Payee No.");

        OutCashAdvances.SetCurrentkey("Payee No.", "Entry Status", "Retirement Status");
        OutCashAdvances.SetRange("Payee No.", "Payee No.");
        OutCashAdvances.SetRange("Entry Status", "entry status"::Posted);
        OutCashAdvances.SetRange("Retirement Status", OutCashAdvances."retirement status"::Open);
        OutCashAdvances.SetRange("Currency Code", "Currency Code");

        Clear(CashAdvAttachments);
        CashAdvAttachments.SetTableview(OutCashAdvances);
        CashAdvAttachments.LookupMode := true;
        CashAdvAttachments.SetPaymentHeader(Rec);
        CashAdvAttachments.RunModal;
    end;

    var
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
        OutCashAdvances: Record "Posted Payment Header";
        CashAdvAttachments: Page "Cash Advance Attachments";


    procedure SetPaymentHeader(var PaymentHeader2: Record "Payment Header")
    begin
        PaymentHeader.Get(PaymentHeader2."Document Type", PaymentHeader2."No.");
        PaymentHeader.TestField("Document Type", PaymentHeader."document type"::Retirement);
    end;


    procedure CreateRetirementLines(var CashAdvToRetire: Record "Posted Payment Header")
    begin
        with CashAdvToRetire do begin
            SetRange("Retirement No.", PaymentHeader."No.");
            if Find('-') then begin
                PaymentLine.LockTable;
                PaymentLine.SetRange("Document Type", PaymentHeader."Document Type");
                PaymentLine.SetRange("Document No.", PaymentHeader."No.");
                PaymentLine."Document Type" := PaymentHeader."Document Type";
                PaymentLine."Document No." := PaymentHeader."No.";
                repeat
                    CashAdvToRetire.InsertRetLineFromAdvLine(PaymentLine);
                until CashAdvToRetire.Next = 0;
            end;
        end;
    end;
}

