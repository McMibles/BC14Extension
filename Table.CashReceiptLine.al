Table 52092300 "Cash Receipt Line"
{
    Permissions = TableData "Posted Payment Header" = rimd,
                  TableData "Posted Payment Line" = rimd;

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Source Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,,Employee Cash Adv. Refund';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",,"Employee Cash Adv. Refund";

            trigger OnValidate()
            begin
                CheckLineSourceTypeWithHeader;
                if "Source Type" <> xRec."Source Type" then begin
                    "Source No." := '';
                    "Source Name" := '';
                end;
                if (not ("Source Type" in ["source type"::"G/L Account"]))
                  then begin
                    Validate("Gen. Posting Type", "gen. posting type"::" ");
                    Validate("Gen. Bus. Posting Group", '');
                    Validate("Gen. Prod. Posting Group", '');
                end;
                case "Source Type" of
                    "source type"::"Employee Cash Adv. Refund":
                        begin
                            GetReceiptHeader;
                            Validate("Employee No.", ReceiptHeader."Payer No.");
                        end;
                    "source type"::Customer, "source type"::Vendor:
                        begin
                            GetReceiptHeader;
                            Validate("Source No.", ReceiptHeader."Payer No.");
                        end;
                end;
            end;
        }
        field(4; "Source No."; Code[20])
        {
            TableRelation = if ("Source Type" = const("G/L Account")) "G/L Account"
            else
            if ("Source Type" = const(Customer)) Customer
            else
            if ("Source Type" = const(Vendor)) Vendor
            else
            if ("Source Type" = const("Bank Account")) "Bank Account"
            else
            if ("Source Type" = const("IC Partner")) "IC Partner"
            else
            if ("Source Type" = const("Employee Cash Adv. Refund")) "Posted Payment Header"."No." where("Document Type" = const("Cash Advance"),
                                                                                                                            "Entry Status" = const(Posted),
                                                                                                                            "Retirement Status" = filter("Partially Retired"),
                                                                                                                            "Payee No." = field("Employee No."));

            trigger OnValidate()
            begin
                if "Source No." <> '' then
                    CheckLineSourceNoWithHeader;

                if CurrFieldNo = FieldNo("Source No.") then begin
                    "Source Name" := '';
                    "Loan ID" := '';
                end;

                if xRec."Source No." <> '' then
                    ClearPostingGroups;

                GetReceiptHeader;
                "Currency Code" := ReceiptHeader."Currency Code";
                "Source Name" := CheckAccountNoValidity("Source Type", "Source No.");
                if not ("Source Type" in [4, 5]) then
                    CreateDim(DimMgt.TypeToTableID1("Source Type"), "Source No.",
                            Database::Job, '');

                case "Source Type" of
                    "source type"::"Employee Cash Adv. Refund":
                        begin
                            CashAdvance.Get(CashAdvance."document type"::"Cash Advance", "Source No.");
                            "Source Name" := 'Cash Advance Retirement';
                            "Dimension Set ID" := CashAdvance."Dimension Set ID";
                            AdvanceAmount := 0;
                            ActualAmount := 0;
                            CashAdvance.GetPostedRetiredAmount(AdvanceAmount, ActualAmount, AdvanceAmountLCY, ActualAmountLCY);
                            if (AdvanceAmount > ActualAmount) then
                                Validate(Amount, AdvanceAmount - ActualAmount)
                            else
                                Error(StrSubstNo(Text002, AdvanceAmount, ActualAmount));
                            Validate("Global Dimension 1 Code", CashAdvance."Shortcut Dimension 1 Code");
                            Validate("Global Dimension 2 Code", CashAdvance."Shortcut Dimension 2 Code");
                        end;

                end;
            end;
        }
        field(5; "Source Name"; Text[100])
        {
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(8; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";

            trigger OnValidate()
            begin
                if CurrFieldNo <> 0 then
                    TestStatusOpen;

                GetReceiptHeader;

                if CurrFieldNo = FieldNo(Amount) then begin
                    ReceiptHeader.TestField("Mode of Payment");

                    case "Source Type" of
                        "source type"::Vendor:
                            begin
                                CashAdvance.Get(CashAdvance."document type"::"Cash Advance", "Source No.");
                                AdvanceAmount := 0;
                                ActualAmount := 0;
                                CashAdvance.GetPostedRetiredAmount(AdvanceAmount, ActualAmount, AdvanceAmountLCY, ActualAmountLCY);
                                if Amount <> (AdvanceAmount - ActualAmount) then
                                    Error(Text003, AdvanceAmount - ActualAmount);
                            end;
                    end;
                end;
                if "Currency Code" = '' then
                    "Amount (LCY)" := Amount
                else
                    "Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        ReceiptHeader."Document Date", "Currency Code",
                        Amount, ReceiptHeader."Currency Factor"));

                Amount := ROUND(Amount, Currency."Amount Rounding Precision");
            end;
        }
        field(9; "Amount (LCY)"; Decimal)
        {
            Editable = false;
        }
        field(10; "Currency Code"; Code[10])
        {
        }
        field(11; Description; Text[100])
        {
        }
        field(13; "Dimension Set ID"; Integer)
        {
        }
        field(14; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(16; "Loan ID"; Code[20])
        {
            TableRelation = if ("Source Type" = const(Customer)) "Payroll-Loan"."Loan ID" where("Employee No." = field("Source No."));
        }
        field(41; "Applies-to ID"; Code[20])
        {
        }
        field(42; "Applies-to Doc. Type"; Option)
        {
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(43; "Applies-to Doc. No."; Code[20])
        {

            trigger OnLookup()
            var
                AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
                AccNo: Code[20];
            begin
                GetAccTypeAndNo(AccType, AccNo);
                Clear(CustLedgEntry);
                Clear(VendLedgEntry);

                case AccType of
                    Acctype::Customer:
                        LookUpAppliesToDocCust(AccNo);
                    Acctype::Vendor:
                        LookUpAppliesToDocVend(AccNo);
                end;
            end;

            trigger OnValidate()
            begin
                if "Applies-to Doc. No." <> '' then
                    TestField("Applies-to ID", '');
            end;
        }
        field(44; "Gen. Posting Type"; Option)
        {
            OptionCaption = ' ,Purchase,Sale,Settlement';
            OptionMembers = " ",Purchase,Sale,Settlement;
        }
        field(45; "VAT Bus. Posting Group"; Code[10])
        {
            TableRelation = "VAT Business Posting Group";
        }
        field(46; "VAT Prod. Posting Group"; Code[10])
        {
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin
                if (not ("Source Type" in ["source type"::"G/L Account"])) then
                    TestField("VAT Prod. Posting Group", '');
            end;
        }
        field(47; "Full VAT"; Boolean)
        {
        }
        field(48; "Vat Calculation Type"; Option)
        {
            OptionCaption = 'Normal VAT,Reverse Charge VAT,Full VAT,Sales Tax';
            OptionMembers = "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        }
        field(49; "Gen. Bus. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Business Posting Group";
        }
        field(50; "Gen. Prod. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(102; "WHT Posting Group"; Code[10])
        {
            TableRelation = "WHT Posting Group";

            trigger OnValidate()
            begin
                if CurrFieldNo <> 0 then
                    TestStatusOpen;
                if "Source Type" in ["source type"::Customer, "source type"::Vendor, "source type"::"Bank Account"] then
                    TestField("WHT Posting Group", '');

                "WHT%" := 0;

                "WHT%" := 0;
                WHTPostingGrp.Get("WHT Posting Group");
                "WHT%" := WHTPostingGrp."WithHolding Tax %";

                Validate("WHT%");
            end;
        }
        field(103; "WHT%"; Decimal)
        {

            trigger OnValidate()
            begin
                GetReceiptHeader;
                if CurrFieldNo = FieldNo("WHT%") then begin
                    TestStatusOpen;
                    TestField("WHT Posting Group");
                    WHTPostingGrp.Get("WHT Posting Group");
                    if "WHT%" <> 0 then
                        WHTPostingGrp.GetSalesWHTTaxAccount;
                end;

                "WHT Amount" := ROUND(Amount * ("WHT%" / 100), Currency."Amount Rounding Precision");
                if ReceiptHeader."Posting Date" <> 0D then
                    CurrencyDate := ReceiptHeader."Posting Date"
                else
                    CurrencyDate := WorkDate;

                if "Currency Code" = '' then
                    "WHT Amount (LCY)" := "WHT Amount"
                else
                    "WHT Amount (LCY)" :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          CurrencyDate, ReceiptHeader."Currency Code",
                          "WHT Amount", ReceiptHeader."Currency Factor"));
            end;
        }
        field(104; "WHT Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            Editable = false;

            trigger OnValidate()
            begin
                GetReceiptHeader;

                if CurrFieldNo <> 0 then
                    TestStatusOpen;

                if ReceiptHeader."Posting Date" <> 0D then
                    CurrencyDate := ReceiptHeader."Posting Date"
                else
                    CurrencyDate := WorkDate;

                if "Currency Code" = '' then
                    "WHT Amount (LCY)" := "WHT Amount"
                else
                    "WHT Amount (LCY)" :=
                      ROUND(
                        CurrExchRate.ExchangeAmtFCYToLCY(
                          CurrencyDate, ReceiptHeader."Currency Code",
                          "WHT Amount", ReceiptHeader."Currency Factor"));
            end;
        }
        field(105; "WHT Amount (LCY)"; Decimal)
        {
            Editable = false;
        }
        field(50000; "WHT Line"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ReceiptHeader: Record "Cash Receipt Header";
        CashAdvance: Record "Posted Payment Header";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLAcc: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Bank: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        ICGLAccount: Record "IC G/L Account";
        WHTPostingGrp: Record "WHT Posting Group";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        StatusCheckSuspended: Boolean;
        FromCurrencyCode: Code[10];
        ToCurrencyCode: Code[10];
        DimMgt: Codeunit DimensionManagement;
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        CustEntrySetApplID: Codeunit "Cust. Entry-SetAppl.ID";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        WHTMgt: Codeunit "WHT Management";
        CurrencyDate: Date;
        Text001: label 'Amount returned must be equal to the amount collected';
        AdvanceAmount: Decimal;
        ActualAmount: Decimal;
        Text002: label 'Fatal error! Advance Amount %1 must not be less than actual amount %2 for this transaction';
        AdvanceAmountLCY: Decimal;
        ActualAmountLCY: Decimal;
        Text003: label 'Amount to refund must be %1';
        Text004: label 'The %1 in the %2 cannot be changed from %3 to %4';
        Text005: label 'The update has been interrupted to respect the warning.';
        Text006: label 'Combination of payer type %1 and source type %2 is not allowed';
        Text007: label 'Source No. must be the same as the Payer No.';
        Text009: label 'LCY';
        Text020: label 'The %1 option can only be used internally in the system.';


    procedure GetReceiptHeader()
    begin
        TestField("Document No.");
        if ("Document No." <> ReceiptHeader."No.") then begin
            ReceiptHeader.Get("Document No.");
            if ReceiptHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                ReceiptHeader.TestField("Currency Factor");
                Currency.Get(ReceiptHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetReceiptHeader;
        ReceiptHeader.TestField(Status, ReceiptHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', 'Receipt Line', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        /*TableID[3] := Type3;
        No[3] := No3;*/
        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        GetReceiptHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, '',
            "Global Dimension 1 Code", "Global Dimension 2 Code",
            ReceiptHeader."Dimension Set ID", Database::"Bank Account");
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");

    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure CheckAccountNoValidity(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]): Text[50]
    begin
        if AccountNo = '' then
            exit('');
        case AccountType of
            0:
                begin                            // g/l account
                    GLAcc.Get(AccountNo);
                    GLAcc.TestField("Account Type", GLAcc."account type"::Posting);
                    GLAcc.TestField(Blocked, false);
                    GLAcc.TestField("Direct Posting", true);
                    GLAcc.CheckGLAcc;
                    "Gen. Posting Type" := GLAcc."Gen. Posting Type";
                    "Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
                    "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                    "VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
                    Validate("VAT Prod. Posting Group", GLAcc."VAT Prod. Posting Group");

                    exit(GLAcc.Name);
                end;
            1:
                begin                            // customer
                    Customer.Get(AccountNo);
                    Customer.TestField("Customer Posting Group");
                    //Customer.TESTFIELD(Status,Customer.Status::Approved);
                    Customer.TestField(Blocked, 0);
                    ClearPostingGroups;
                    exit(Customer.Name);
                end;
            2:
                begin                            // vendor
                    Vendor.Get(AccountNo);
                    Vendor.TestField("Vendor Posting Group");
                    Vendor.TestField(Blocked, 0);
                    //Vendor.TESTFIELD(Status,Vendor.Status::Approved);
                    ClearPostingGroups;
                    exit(Vendor.Name);
                end;
            3:
                begin                            // bank
                    Bank.Get(AccountNo);
                    Bank.TestField("Bank Acc. Posting Group");
                    Bank.TestField(Blocked, false);
                    ClearPostingGroups;
                    exit(Bank.Name);
                end;
        end; /*end case*/

    end;


    procedure ApplyEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        ApplyCustEntries: Page "Apply Customer Entries";
        ApplyVendEntries: Page "Apply Vendor Entries";
        AccNo: Code[20];
        CurrencyCode2: Code[10];
        OK: Boolean;
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        Text000: label 'You must specify %1 or %2.';
        Text001: label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text002: label 'Do you wish to continue?';
        Text003: label 'The update has been interrupted to respect the warning.';
        Text005: label 'The %1  must be Customer or Vendor.';
        Text006: label 'All entries in one application must be in the same currency.';
        Text007: label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
    begin
        GetReceiptHeader;
        TestStatusOpen;
        TestField("Applies-to Doc. No.", '');
        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", '');
        GenJnlLine.SetRange("Journal Batch Name", '');
        GenJnlLine.SetRange("Document No.", "Document No.");
        GenJnlLine.SetRange("Line No.", 10000);
        GenJnlLine.DeleteAll;

        GenJnlLine.Init;
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Posting Date" := ReceiptHeader."Document Date";
        GenJnlLine."Line No." := "Line No.";
        GenJnlLine.Validate("Account Type", "Source Type");
        GenJnlLine.Validate("Account No.", "Source No.");
        GenJnlLine.Amount := Amount;
        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";

        if GenJnlLine."Account Type" = GenJnlLine."account type"::Customer then
            GenJnlLine."Document Type" := GenJnlLine."document type"::Payment
        else
            GenJnlLine."Document Type" := GenJnlLine."document type"::Refund;
        if GenJnlLine.Insert then;
        GenJnlLine.Amount := Amount;
        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";

        Commit;
        AccType := GenJnlLine."Account Type";
        AccNo := GenJnlLine."Account No.";
        case AccType of
            Acctype::Customer:
                begin
                    CustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                    CustLedgEntry.SetRange("Customer No.", AccNo);
                    CustLedgEntry.SetRange(Open, true);
                    if "Applies-to ID" = '' then
                        "Applies-to ID" := "Document No.";
                    if "Applies-to ID" = '' then
                        Error(
                          Text000,
                          FieldCaption("Document No."), FieldCaption("Applies-to ID"));
                    GenJnlLine."Applies-to ID" := "Applies-to ID";
                    ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
                    ApplyCustEntries.SetRecord(CustLedgEntry);
                    ApplyCustEntries.SetTableview(CustLedgEntry);
                    ApplyCustEntries.LookupMode(true);
                    OK := ApplyCustEntries.RunModal = Action::LookupOK;
                    Clear(ApplyCustEntries);
                    if not OK then
                        exit;
                    WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Cash Receipt Line");
                    "WHT Amount" := 0;
                    "WHT Amount (LCY)" := 0;
                    CustLedgEntry.Reset;
                    CustLedgEntry.SetCurrentkey("Customer No.", Open, Positive);
                    CustLedgEntry.SetRange("Customer No.", AccNo);
                    CustLedgEntry.SetRange(Open, true);
                    CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                    if CustLedgEntry.Find('-') then begin
                        CurrencyCode2 := CustLedgEntry."Currency Code";
                        if Amount = 0 then begin
                            repeat
                                PaymentToleranceMgt.DelPmtTolApllnDocNo(GenJnlLine, CustLedgEntry."Document No.");
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, CustLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Customer, true);

                                CustLedgEntry.CalcFields("Remaining Amount");
                                CustLedgEntry."Remaining Amount" :=
                                  CurrExchRate.ExchangeAmount(
                                    CustLedgEntry."Remaining Amount",
                                    CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                CustLedgEntry."Remaining Amount" :=
                                  ROUND(CustLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                                CustLedgEntry."Remaining Pmt. Disc. Possible" :=
                                  CurrExchRate.ExchangeAmount(
                                    CustLedgEntry."Remaining Pmt. Disc. Possible",
                                    CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                CustLedgEntry."Remaining Pmt. Disc. Possible" :=
                                  ROUND(CustLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");

                                WHTMgt.GetCustWHTAmount(CustLedgEntry, GenJnlLine, Database::"Cash Receipt Line");
                                CustLedgEntry."Amount to Apply" :=
                                  CurrExchRate.ExchangeAmount(
                                    CustLedgEntry."Amount to Apply",
                                    CustLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                CustLedgEntry."Amount to Apply" :=
                                  ROUND(CustLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");

                                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) and
                                   (Abs(CustLedgEntry."Amount to Apply") >=
                                    Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible"))
                                then
                                    Amount := Amount - (CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                                else
                                    Amount := Amount - (CustLedgEntry."Amount to Apply");
                            until CustLedgEntry.Next = 0;
                            Validate(Amount);
                        end else
                            repeat
                                //CheckAgainstApplnCurrency(CurrencyCode2,CustLedgEntry."Currency Code",AccType::Customer,TRUE);
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, CustLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Customer, true);

                                WHTMgt.GetCustWHTAmount(CustLedgEntry, GenJnlLine, Database::"Cash Receipt Line");
                            until CustLedgEntry.Next = 0;
                        if GenJnlLine."Currency Code" <> CurrencyCode2 then
                            if Amount = 0 then begin
                                if not
                                   Confirm(
                                     Text001 +
                                     Text002, true,
                                     FieldCaption("Currency Code"), TableCaption, GenJnlLine."Currency Code",
                                     CustLedgEntry."Currency Code")
                                then
                                    Error(Text003);
                                GenJnlLine."Currency Code" := CustLedgEntry."Currency Code"
                            end else
                                //CheckAgainstApplnCurrency("Currency Code",CustLedgEntry."Currency Code",AccType::Customer,TRUE);
                                GenJnlApply.CheckAgainstApplnCurrency(
                      GenJnlLine."Currency Code", CustLedgEntry."Currency Code",
                      GenJnlLine."account type"::Customer, true);

                        "Applies-to Doc. Type" := 0;
                        "Applies-to Doc. No." := '';
                    end else
                        "Applies-to ID" := '';
                    Modify;
                    // Check Payment Tolerance
                    if Rec.Amount <> 0 then
                        if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then
                            exit;
                    WHTMgt.CreateWHTCashReceiptLine(Rec, 1);
                end;
            Acctype::Vendor:
                begin
                    VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                    VendLedgEntry.SetRange("Vendor No.", AccNo);
                    VendLedgEntry.SetRange(Open, true);
                    if "Applies-to ID" = '' then
                        "Applies-to ID" := "Document No.";
                    if "Applies-to ID" = '' then
                        Error(
                          Text000,
                          FieldCaption("Document No."), FieldCaption("Applies-to ID"));
                    GenJnlLine."Applies-to ID" := "Applies-to ID";
                    ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to ID"));
                    ApplyVendEntries.SetRecord(VendLedgEntry);
                    ApplyVendEntries.SetTableview(VendLedgEntry);
                    ApplyVendEntries.LookupMode(true);
                    OK := ApplyVendEntries.RunModal = Action::LookupOK;
                    Clear(ApplyVendEntries);
                    if not OK then
                        exit;
                    WHTMgt.ResetWHTDocBuffer("Document No.", "Line No.", Database::"Cash Receipt Line");
                    "WHT Amount" := 0;
                    "WHT Amount (LCY)" := 0;
                    VendLedgEntry.Reset;
                    VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive);
                    VendLedgEntry.SetRange("Vendor No.", AccNo);
                    VendLedgEntry.SetRange(Open, true);
                    VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
                    if VendLedgEntry.Find('-') then begin
                        CurrencyCode2 := VendLedgEntry."Currency Code";
                        if Amount = 0 then begin
                            repeat
                                PaymentToleranceMgt.DelPmtTolApllnDocNo(GenJnlLine, VendLedgEntry."Document No.");
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, VendLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Customer, true);

                                //CheckAgainstApplnCurrency(CurrencyCode2,VendLedgEntry."Currency Code",AccType::Vendor,TRUE);
                                VendLedgEntry.CalcFields("Remaining Amount");
                                VendLedgEntry."Remaining Amount" :=
                                  CurrExchRate.ExchangeAmount(
                                    VendLedgEntry."Remaining Amount",
                                    VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                VendLedgEntry."Remaining Amount" :=
                                  ROUND(VendLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
                                VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                                  CurrExchRate.ExchangeAmount(
                                    VendLedgEntry."Remaining Pmt. Disc. Possible",
                                    VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                                  ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
                                WHTMgt.GetVendWHTAmount(VendLedgEntry, GenJnlLine, Database::"Cash Receipt Line");
                                VendLedgEntry."Amount to Apply" :=
                                  CurrExchRate.ExchangeAmount(
                                    VendLedgEntry."Amount to Apply",
                                    VendLedgEntry."Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                                VendLedgEntry."Amount to Apply" :=
                                  ROUND(VendLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");

                                if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, false) and
                                   (Abs(VendLedgEntry."Amount to Apply") >=
                                    Abs(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible"))
                                then
                                    Amount := Amount - (VendLedgEntry."Amount to Apply" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                                else
                                    Amount := Amount - VendLedgEntry."Amount to Apply";

                            until VendLedgEntry.Next = 0;
                            Validate(Amount);
                        end else
                            repeat
                                //CheckAgainstApplnCurrency(CurrencyCode2,VendLedgEntry."Currency Code",AccType::Vendor,TRUE);
                                GenJnlApply.CheckAgainstApplnCurrency(
                                  CurrencyCode2, VendLedgEntry."Currency Code",
                                  GenJnlLine."account type"::Vendor, true);
                                WHTMgt.GetVendWHTAmount(VendLedgEntry, GenJnlLine, Database::"Cash Receipt Line");
                            until VendLedgEntry.Next = 0;
                        if GenJnlLine."Currency Code" <> CurrencyCode2 then
                            if Amount = 0 then begin
                                if not
                                   Confirm(
                                     Text001 +
                                     Text002, true,
                                     FieldCaption("Currency Code"), TableCaption, GenJnlLine."Currency Code",
                                     VendLedgEntry."Currency Code")
                                then
                                    Error(Text003);
                                "Currency Code" := VendLedgEntry."Currency Code"
                            end else
                                //CheckAgainstApplnCurrency("Currency Code",VendLedgEntry."Currency Code",AccType::Vendor,TRUE);
                                GenJnlApply.CheckAgainstApplnCurrency(
                      GenJnlLine."Currency Code", VendLedgEntry."Currency Code",
                      GenJnlLine."account type"::Vendor, true);

                        "Applies-to Doc. Type" := 0;
                        "Applies-to Doc. No." := '';
                    end else
                        "Applies-to ID" := '';
                    Modify;
                    // Check Payment Tolerance
                    if Rec.Amount <> 0 then
                        if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then
                            exit;
                    WHTMgt.CreateWHTCashReceiptLine(Rec, 0);
                end;
            else
                Error(
                  Text005,
                  FieldCaption("Source Type"));
        end;
        Validate(Amount, Abs(Amount));
        Modify;
    end;


    procedure LookUpAppliesToDocCust(AccNo: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line" temporary;
        ApplyCustEntries: Page "Apply Customer Entries";
    begin
        GetReceiptHeader;
        TestStatusOpen;

        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", '');
        GenJnlLine.SetRange("Journal Batch Name", '');
        GenJnlLine.SetRange("Document No.", "Document No.");
        GenJnlLine.SetRange("Line No.", 10000);
        GenJnlLine.DeleteAll;

        GenJnlLine.Init;
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Posting Date" := ReceiptHeader."Document Date";
        GenJnlLine."Line No." := 10000;
        case "Source Type" of
            "source type"::Customer, "source type"::Vendor:
                begin
                    GenJnlLine.Validate("Bal. Account Type", Rec."Source Type");
                    GenJnlLine.Validate("Bal. Account No.", Rec."Source No.");
                end;
            else
                exit
        end;
        GenJnlLine.Amount := Rec.Amount;
        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";

        if "Source Type" = "source type"::Customer then
            GenJnlLine."Document Type" := GenJnlLine."document type"::Payment
        else
            GenJnlLine."Document Type" := GenJnlLine."document type"::Refund;
        if GenJnlLine.Insert then;

        Clear(CustLedgEntry);
        CustLedgEntry.SetCurrentkey("Customer No.", Open, Positive, "Due Date");
        if AccNo <> '' then
            CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if CustLedgEntry.IsEmpty then begin
                CustLedgEntry.SetRange("Document Type");
                CustLedgEntry.SetRange("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "applies-to doc. type"::" " then begin
            CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange("Document Type");
        end;
        if Amount <> 0 then begin
            CustLedgEntry.SetRange(Positive, Amount < 0);
            if CustLedgEntry.IsEmpty then
                CustLedgEntry.SetRange(Positive);
        end;
        ApplyCustEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to Doc. No."));
        ApplyCustEntries.SetTableview(CustLedgEntry);
        ApplyCustEntries.SetRecord(CustLedgEntry);
        ApplyCustEntries.LookupMode(true);
        if ApplyCustEntries.RunModal = Action::LookupOK then begin
            ApplyCustEntries.GetRecord(CustLedgEntry);
            if AccNo = '' then begin
                AccNo := CustLedgEntry."Customer No.";
                if GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::Customer then
                    Validate("Source No.", AccNo)
                else
                    Validate("Source No.", AccNo);
            end;
            if GenJnlLine."Currency Code" <> CustLedgEntry."Currency Code" then
                if Amount = 0 then begin
                    FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                    ToCurrencyCode := GetShowCurrencyCode(CustLedgEntry."Currency Code");
                    Error(Text004, FieldCaption("Currency Code"), ReceiptHeader.TableCaption, FromCurrencyCode, ToCurrencyCode);
                end else
                    GenJnlApply.CheckAgainstApplnCurrency(
                      GenJnlLine."Currency Code", CustLedgEntry."Currency Code",
                      GenJnlLine."account type"::Customer, true);
            if Amount = 0 then begin
                CustLedgEntry.CalcFields("Remaining Amount");
                if CustLedgEntry."Amount to Apply" <> 0 then begin
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) then begin
                        if Abs(CustLedgEntry."Amount to Apply") >=
                           Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                        then
                            Amount := -(CustLedgEntry."Remaining Amount" -
                                        CustLedgEntry."Remaining Pmt. Disc. Possible")
                        else
                            Amount := -CustLedgEntry."Amount to Apply";
                    end else
                        Amount := -CustLedgEntry."Amount to Apply";
                end else begin
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(GenJnlLine, CustLedgEntry, 0, false) then
                        Amount := -(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        Amount := -CustLedgEntry."Remaining Amount";
                end;
                if "Source Type" in ["source type"::Customer, "source type"::Vendor] then
                    Amount := -Amount;
                Validate(Amount);
            end;
            "Applies-to Doc. Type" := CustLedgEntry."Document Type";
            "Applies-to Doc. No." := CustLedgEntry."Document No.";
            "Applies-to ID" := '';
        end;
    end;


    procedure LookUpAppliesToDocVend(AccNo: Code[20])
    var
        GenJnlLine: Record "Gen. Journal Line";
        ApplyVendEntries: Page "Apply Vendor Entries";
    begin
        GetReceiptHeader;
        TestStatusOpen;

        GenJnlLine.Reset;
        GenJnlLine.SetRange("Journal Template Name", '');
        GenJnlLine.SetRange("Journal Batch Name", '');
        GenJnlLine.SetRange("Document No.", "Document No.");
        GenJnlLine.SetRange("Line No.", 10000);
        GenJnlLine.DeleteAll;

        GenJnlLine.Init;
        GenJnlLine."Document No." := "Document No.";
        GenJnlLine."Posting Date" := ReceiptHeader."Document Date";
        GenJnlLine."Line No." := 10000;
        case "Source Type" of
            "source type"::Customer, "source type"::Vendor:
                begin
                    GenJnlLine.Validate("Bal. Account Type", Rec."Source Type");
                    GenJnlLine.Validate("Bal. Account No.", Rec."Source No.");
                end;
            else
                exit
        end;
        GenJnlLine.Amount := Rec.Amount;
        GenJnlLine."Currency Code" := ReceiptHeader."Currency Code";

        if "Source Type" = "source type"::Customer then
            GenJnlLine."Document Type" := GenJnlLine."document type"::Payment
        else
            GenJnlLine."Document Type" := GenJnlLine."document type"::Refund;
        if GenJnlLine.Insert then;

        Commit;

        Clear(VendLedgEntry);
        VendLedgEntry.SetCurrentkey("Vendor No.", Open, Positive, "Due Date");
        if AccNo <> '' then
            VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange(Open, true);
        if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if VendLedgEntry.IsEmpty then begin
                VendLedgEntry.SetRange("Document Type");
                VendLedgEntry.SetRange("Document No.");
            end;
        end;
        if "Applies-to ID" <> '' then begin
            VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Applies-to ID");
        end;
        if "Applies-to Doc. Type" <> "applies-to doc. type"::" " then begin
            VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Document Type");
        end;
        if "Applies-to Doc. No." <> '' then begin
            VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
            if VendLedgEntry.IsEmpty then
                VendLedgEntry.SetRange("Document No.");
        end;
        if Amount <> 0 then begin
            VendLedgEntry.SetRange(Positive, Amount < 0);
            if VendLedgEntry.IsEmpty then;
            VendLedgEntry.SetRange(Positive);
        end;
        ApplyVendEntries.SetGenJnlLine(GenJnlLine, GenJnlLine.FieldNo("Applies-to Doc. No."));
        ApplyVendEntries.SetTableview(VendLedgEntry);
        ApplyVendEntries.SetRecord(VendLedgEntry);
        ApplyVendEntries.LookupMode(true);
        if ApplyVendEntries.RunModal = Action::LookupOK then begin
            ApplyVendEntries.GetRecord(VendLedgEntry);
            if AccNo = '' then begin
                AccNo := VendLedgEntry."Vendor No.";
                if "Source Type" = "source type"::Vendor then
                    Validate("Source No.", AccNo)
                else
                    Validate("Source No.", AccNo);
            end;
            if "Currency Code" <> VendLedgEntry."Currency Code" then
                if Amount = 0 then begin
                    FromCurrencyCode := GetShowCurrencyCode("Currency Code");
                    ToCurrencyCode := GetShowCurrencyCode(VendLedgEntry."Currency Code");
                    if not
                       Confirm(
                         Text003, true, FieldCaption("Currency Code"), TableCaption, FromCurrencyCode, ToCurrencyCode)
                    then
                        Error(Text005);
                    Validate("Currency Code", VendLedgEntry."Currency Code");
                end else
                    GenJnlApply.CheckAgainstApplnCurrency(
                      "Currency Code", VendLedgEntry."Currency Code", GenJnlLine."account type"::Vendor, true);
            if Amount = 0 then begin
                VendLedgEntry.CalcFields("Remaining Amount");
                if VendLedgEntry."Amount to Apply" <> 0 then begin
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, false) then begin
                        if Abs(VendLedgEntry."Amount to Apply") >=
                           Abs(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                        then
                            Amount := -(VendLedgEntry."Remaining Amount" -
                                        VendLedgEntry."Remaining Pmt. Disc. Possible")
                        else
                            Amount := -VendLedgEntry."Amount to Apply";
                    end else
                        Amount := -VendLedgEntry."Amount to Apply";
                end else begin
                    if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(GenJnlLine, VendLedgEntry, 0, false) then
                        Amount := -(VendLedgEntry."Remaining Amount" -
                                    VendLedgEntry."Remaining Pmt. Disc. Possible")
                    else
                        Amount := -VendLedgEntry."Remaining Amount";
                end;
                if "Source Type" in
                   ["source type"::Customer, "source type"::Vendor]
                then
                    Amount := -Amount;
                Validate(Amount);
            end;
            "Applies-to Doc. Type" := VendLedgEntry."Document Type";
            "Applies-to Doc. No." := VendLedgEntry."Document No.";
            "Applies-to ID" := '';
        end;
    end;


    procedure GetShowCurrencyCode(CurrencyCode: Code[10]): Code[10]
    begin
        if CurrencyCode <> '' then
            exit(CurrencyCode);

        exit(Text009);
    end;

    local procedure GetAccTypeAndNo(var AccType: Option; var AccNo: Code[20])
    begin
        if "Source Type" in
           ["source type"::Customer, "source type"::Vendor]
        then begin
            AccType := "Source Type";
            AccNo := "Source No.";
        end else begin
            AccType := "Source Type";
            AccNo := "Source No.";
        end;
    end;


    procedure CheckLineSourceTypeWithHeader()
    begin
        GetReceiptHeader;
        with ReceiptHeader do begin
            case ReceiptHeader."Payer Type" of
                "payer type"::Customer:
                    begin
                        if not ("Source Type" in [0, 1]) then
                            Error(Text006, ReceiptHeader."Payer Type", "Source Type");

                    end;
                "payer type"::Vendor:
                    begin
                        if not ("Source Type" in [0, 2]) then
                            Error(Text006, ReceiptHeader."Payer Type", "Source Type");
                    end;
            end;
        end;
    end;


    procedure CheckLineSourceNoWithHeader()
    begin
        GetReceiptHeader;
        with ReceiptHeader do begin
            case ReceiptHeader."Payer Type" of
                "payer type"::Customer:
                    begin
                        if ("Source Type" = "source type"::Customer) and ("Source No." <> "Payer No.") then
                            Error(Text007);
                    end;
                "payer type"::Vendor:
                    begin
                        if ("Source Type" = "source type"::Vendor) and ("Source No." <> "Payer No.") then
                            Error(Text007);
                    end;
            end;
        end;
    end;


    procedure ClearCustVendApplnEntry()
    var
        TempCustLedgEntry: Record "Cust. Ledger Entry";
        TempVendLedgEntry: Record "Vendor Ledger Entry";
        CustEntryEdit: Codeunit "Cust. Entry-Edit";
        VendEntryEdit: Codeunit "Vend. Entry-Edit";
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        AccNo: Code[20];
    begin
        GetAccTypeAndNo(AccType, AccNo);
        case AccType of
            Acctype::Customer:
                if "Applies-to ID" <> '' then begin
                    if FindFirstCustLedgEntryWithAppliesToID(AccNo) then begin
                        ClearCustApplnEntryFields;
                        CustEntrySetApplID.SetApplId(CustLedgEntry, TempCustLedgEntry, '');
                    end
                end else
                    if "Applies-to Doc. No." <> '' then
                        if FindFirstCustLedgEntryWithAppliesToDocNo(AccNo) then begin
                            ClearCustApplnEntryFields;
                            CustEntryEdit.Run(CustLedgEntry);
                        end;
            Acctype::Vendor:
                if "Applies-to ID" <> '' then begin
                    if FindFirstVendLedgEntryWithAppliesToID(AccNo) then begin
                        ClearVendApplnEntryFields;
                        VendEntrySetApplID.SetApplId(VendLedgEntry, TempVendLedgEntry, '');
                    end
                end else
                    if "Applies-to Doc. No." <> '' then
                        if FindFirstVendLedgEntryWithAppliesToDocNo(AccNo) then begin
                            ClearVendApplnEntryFields;
                            VendEntryEdit.Run(VendLedgEntry);
                        end;
        end;
    end;

    local procedure ClearCustApplnEntryFields()
    begin
        CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        CustLedgEntry."Amount to Apply" := 0;
    end;

    local procedure ClearVendApplnEntryFields()
    begin
        VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        VendLedgEntry."Amount to Apply" := 0;
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToID(AccNo: Code[20]): Boolean
    begin
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentkey("Customer No.", "Applies-to ID", Open);
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
        CustLedgEntry.SetRange(Open, true);
        exit(CustLedgEntry.FindFirst)
    end;

    local procedure FindFirstCustLedgEntryWithAppliesToDocNo(AccNo: Code[20]): Boolean
    begin
        CustLedgEntry.Reset;
        CustLedgEntry.SetCurrentkey("Document No.");
        CustLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
        CustLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
        CustLedgEntry.SetRange("Customer No.", AccNo);
        CustLedgEntry.SetRange(Open, true);
        exit(CustLedgEntry.FindFirst)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToID(AccNo: Code[20]): Boolean
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Vendor No.", "Applies-to ID", Open);
        VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange("Applies-to ID", "Applies-to ID");
        VendLedgEntry.SetRange(Open, true);
        exit(VendLedgEntry.FindFirst)
    end;

    local procedure FindFirstVendLedgEntryWithAppliesToDocNo(AccNo: Code[20]): Boolean
    begin
        VendLedgEntry.Reset;
        VendLedgEntry.SetCurrentkey("Document No.");
        VendLedgEntry.SetRange("Document No.", "Applies-to Doc. No.");
        VendLedgEntry.SetRange("Document Type", "Applies-to Doc. Type");
        VendLedgEntry.SetRange("Vendor No.", AccNo);
        VendLedgEntry.SetRange(Open, true);
        exit(VendLedgEntry.FindFirst)
    end;

    local procedure ClearPostingGroups()
    begin
        "Gen. Posting Type" := "gen. posting type"::" ";
        "Gen. Bus. Posting Group" := '';
        "Gen. Prod. Posting Group" := '';
        "VAT Bus. Posting Group" := '';
        "VAT Prod. Posting Group" := '';
        "WHT Posting Group" := '';
    end;
}

