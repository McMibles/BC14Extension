Table 52092294 "Posted Payment Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Payment Voucher,Cash Advance,Retirement';
            OptionMembers = "Payment Voucher","Cash Advance",Retirement;
        }
        field(3; "Posting Description"; Text[100])
        {
        }
        field(4; "Currency Code"; Code[10])
        {
        }
        field(5; "Currency Factor"; Decimal)
        {
        }
        field(6; "Document Date"; Date)
        {
        }
        field(7; "User ID"; Code[50])
        {
            Editable = false;
        }
        field(8; "Payment Date"; Date)
        {
        }
        field(9; "Payment Method"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,E-Payment';
            OptionMembers = " ",Cash,Cheque,"E-Payment";
        }
        field(10; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(11; "System Created Entry"; Boolean)
        {
            Editable = false;
        }
        field(12; "Payment Type"; Option)
        {
            OptionCaption = 'Supp. Invoice,Cust. Refund,Cash Advance,Retirement,Others';
            OptionMembers = "Supp. Invoice","Cust. Refund","Cash Advance",Retirement,Others;
        }
        field(13; "Source No."; Code[20])
        {
        }
        field(14; "Requested By"; Code[50])
        {
        }
        field(15; "Payment Request No."; Code[20])
        {
            Editable = false;
            TableRelation = "Payment Request Header";
        }
        field(16; "Cheque Entry No."; Integer)
        {
            Editable = false;
        }
        field(17; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(18; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(19; "Voided By"; Code[50])
        {
            Editable = false;
        }
        field(20; "Date-Time Voided"; DateTime)
        {
            Editable = false;
        }
        field(21; "Last Date Modified"; Date)
        {
            Editable = false;
        }
        field(22; "Last Modified By"; Code[50])
        {
            Editable = false;
        }
        field(23; "Payment Source"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(24; "Bal. Account Type"; Option)
        {
            OptionCaption = 'Vendor,Bank Account';
            OptionMembers = Vendor,"Bank Account";
        }
        field(25; "Bal. Account No."; Code[20])
        {
            TableRelation = if ("Bal. Account Type" = const(Vendor)) Vendor
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account";
        }
        field(26; "No. Series"; Code[10])
        {
        }
        field(27; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(28; "Creation Time"; Time)
        {
            Editable = false;
        }
        field(29; "Payee No."; Code[20])
        {
            TableRelation = if ("Payment Type" = const("Supp. Invoice")) Vendor
            else
            if ("Payment Type" = const("Cust. Refund")) Customer
            else
            if ("Payment Type" = const("Cash Advance")) Employee;
        }
        field(30; Payee; Text[100])
        {
        }
        field(31; "Payee Bank Code"; Code[20])
        {
            TableRelation = if ("Payment Type" = const("Supp. Invoice")) "Vendor Bank Account".Code where("Vendor No." = field("Payee No."))
            else
            if ("Payment Type" = const("Cust. Refund")) "Customer Bank Account".Code where("Customer No." = field("Payee No."));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(32; "Payee Bank Account Name"; Text[80])
        {
        }
        field(33; "Payee Bank Account"; Text[30])
        {
        }
        field(36; "Retirement No."; Code[20])
        {
        }
        field(37; "Retirement Date"; Date)
        {
        }
        field(38; "Retirement Amount"; Decimal)
        {
            CalcFormula = sum("Posted Payment Line"."Cash Advance Amount" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Retirement Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Posted Payment Line"."Cash Advance Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "External Document No."; Code[20])
        {
        }
        field(41; "Due Date"; Date)
        {
        }
        field(42; "Entry Status"; Option)
        {
            OptionCaption = ',Voided,Posted,Financially Voided';
            OptionMembers = ,Voided,Posted,"Financially Voided";
        }
        field(43; "No. Printed"; Integer)
        {
            Editable = false;
        }
        field(44; "Employee Posting Group"; Code[10])
        {
            TableRelation = "Employee Posting Group";
        }
        field(46; "Voucher No."; Code[20])
        {
        }
        field(47; "Responsibility Center"; Code[10])
        {
        }
        field(49; "Source Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Travel,Leave';
            OptionMembers = Travel,Leave;
        }
        field(100; "Dimension Set ID"; Integer)
        {
        }
        field(101; Amount; Decimal)
        {
            CalcFormula = sum("Posted Payment Line".Amount where("Document No." = field("No."),
                                                                  "Document Type" = field("Document Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; "Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Posted Payment Line"."Amount (LCY)" where("Document No." = field("No."),
                                                                          "Document Type" = field("Document Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(103; "WHT Amount"; Decimal)
        {
            CalcFormula = sum("Posted Payment Line"."WHT Amount" where("Document No." = field("No."),
                                                                        "Document Type" = field("Document Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(104; "WHT Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Posted Payment Line"."WHT Amount (LCY)" where("Document No." = field("No."),
                                                                              "Document Type" = field("Document Type")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(200; "Retirement Status"; Option)
        {
            OptionCaption = 'Open,Returned,Retired,Partially Retired';
            OptionMembers = Open,Returned,Retired,"Partially Retired";
        }
        field(50000; "Check No"; Code[20])
        {
            CalcFormula = lookup("Check Ledger Entry"."Check No." where("Check Entry No." = field("Cheque Entry No.")));
            FieldClass = FlowField;
        }
        field(70000; "Portal ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Mobile User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "Created from External Portal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Created from External Portal such as Retail';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
        key(Key2; "Payee No.", "Entry Status", "Retirement Status")
        {
        }
    }

    fieldgroups
    {
    }

    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        PmtVoucherHeader: Record "Payment Header";
        PaymentVoucherLine: Record "Payment Line";
        Employee: Record Employee;
        Vendor: Record Vendor;
        Customer: Record Customer;
        CurrencyCode: Code[20];
        CurrencyDate: Date;
        NoSeriesMgt: Codeunit 396;
        DimMgt: Codeunit 408;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text001: label 'Do you want to update the exchange rate?';
        Text002: label 'You have modified %1.\\';
        Text003: label 'Do you want to update the lines?';
        Text004: label 'Voided payment voucher cannot be modified.';
        Text006: label 'If you change %1, the existing payment lines will be deleted and new payment lines based on the new information on the header will be created.\\';
        Text007: label 'Do you want to change %1?';
        Text008: label 'You must delete the existing payment voucher lines before you can change %1.';
        Text012: label 'Are you sure you want to Void payment voucher %1?';
        Text013: label 'This option is not allowed!';
        Text023: label 'Changing the source type will cause the system to delete the lines\ Do you want to continue?';
        Text029: label 'You can only retire a cash advance ';
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text065: label 'New voucher number cannot be created because There is no line created for %1. Press Escape to use the number.';


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;


    procedure InsertRetLineFromAdvLine(var PaymentLine: Record "Payment Line")
    var
        PaymentLine2: Record "Posted Payment Line";
        TempPaymentLine: Record "Payment Line";
        NextLineNo: Integer;
    begin
        PaymentLine2.SetRange("Document Type", "Document Type");
        PaymentLine2.SetRange("Document No.", "No.");
        PaymentLine2.SetRange("Retirement No.", '');

        TempPaymentLine := PaymentLine;
        if PaymentLine.Find('+') then
            NextLineNo := PaymentLine."Line No." + 10000
        else
            NextLineNo := 10000;

        if PaymentLine2.Find('-') then
            repeat
                PaymentLine.TransferFields(PaymentLine2);
                PaymentLine."Document Type" := TempPaymentLine."Document Type";
                PaymentLine."Document No." := TempPaymentLine."Document No.";
                PaymentLine."Line No." := NextLineNo;
                PaymentLine."Cash Advance Amount" := PaymentLine2.Amount;
                PaymentLine."Cash Advance Amount (LCY)" := PaymentLine2."Amount (LCY)";
                PaymentLine."Attached Doc. No." := PaymentLine2."Document No.";
                PaymentLine."Attached Line No." := PaymentLine2."Line No.";
                PaymentLine.Amount := 0;
                PaymentLine."Amount (LCY)" := 0;
                PaymentLine.Insert;
                NextLineNo := NextLineNo + 10000;
            until PaymentLine2.Next = 0;

        PaymentLine2.ModifyAll("Retirement No.", TempPaymentLine."Document No.");
    end;


    procedure GetRetiredAmount(var AdvanceAmount: Decimal; var ActualAmount: Decimal; var AdvanceAmountLCY: Decimal; var ActualAmountLCY: Decimal)
    var
        PaymentLine: Record "Payment Line";
    begin
        if "Retirement No." <> '' then begin
            PaymentLine.SetCurrentkey("Attached Doc. No.");
            PaymentLine.SetRange("Document Type", "document type"::Retirement);
            PaymentLine.SetRange("Document No.", "Retirement No.");
            PaymentLine.SetRange("Attached Doc. No.", "No.");
            PaymentLine.CalcSums(PaymentLine."Cash Advance Amount", PaymentLine.Amount, PaymentLine."Cash Advance Amount (LCY)",
              PaymentLine."Amount (LCY)");
            AdvanceAmount := PaymentLine."Cash Advance Amount";
            AdvanceAmountLCY := PaymentLine."Cash Advance Amount (LCY)";
            ActualAmount := PaymentLine.Amount;
            ActualAmountLCY := PaymentLine."Amount (LCY)";
        end else begin
            AdvanceAmount := 0;
            AdvanceAmountLCY := 0;
            ActualAmount := 0;
            ActualAmountLCY := 0;
        end;
    end;


    procedure GetPostedRetiredAmount(var AdvanceAmount: Decimal; var ActualAmount: Decimal; var AdvanceAmountLCY: Decimal; var ActualAmountLCY: Decimal)
    var
        PaymentLine: Record "Posted Payment Line";
    begin
        if "Retirement No." <> '' then begin
            PaymentLine.SetCurrentkey("Attached Doc. No.");
            PaymentLine.SetRange("Document Type", "document type"::Retirement);
            PaymentLine.SetRange("Document No.", "Retirement No.");
            PaymentLine.SetRange("Attached Doc. No.", "No.");
            PaymentLine.CalcSums(PaymentLine."Cash Advance Amount", PaymentLine.Amount, PaymentLine."Cash Advance Amount (LCY)",
              PaymentLine."Amount (LCY)");
            AdvanceAmount := PaymentLine."Cash Advance Amount";
            AdvanceAmountLCY := PaymentLine."Cash Advance Amount (LCY)";
            ;
            ActualAmount := PaymentLine.Amount;
            ActualAmountLCY := PaymentLine."Amount (LCY)";
        end else begin
            AdvanceAmount := 0;
            AdvanceAmountLCY := 0;
            ActualAmount := 0;
            ActualAmountLCY := 0;
        end;
    end;


    procedure GetAmountRefundable(LCY: Boolean) RefundableAmount: Decimal
    var
        PostedRetirementLine: Record "Posted Payment Line";
    begin
        if "Retirement No." <> '' then begin
            PostedRetirementLine.SetCurrentkey("Attached Doc. No.");
            PostedRetirementLine.SetRange("Document Type", "document type"::Retirement);
            PostedRetirementLine.SetRange("Document No.", "Retirement No.");
            PostedRetirementLine.SetRange("Attached Doc. No.", "No.");
            PostedRetirementLine.CalcSums(PostedRetirementLine."Cash Advance Amount", PostedRetirementLine.Amount, PostedRetirementLine."Cash Advance Amount (LCY)",
              PostedRetirementLine."Amount (LCY)");
            if LCY then
                RefundableAmount := PostedRetirementLine."Cash Advance Amount (LCY)" - PostedRetirementLine."Amount (LCY)"
            else
                RefundableAmount := PostedRetirementLine."Cash Advance Amount" - PostedRetirementLine.Amount;
        end else
            RefundableAmount := 0;
        exit(RefundableAmount);
    end;


    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Payment Date", "No.");
        NavigateForm.Run;
    end;
}

