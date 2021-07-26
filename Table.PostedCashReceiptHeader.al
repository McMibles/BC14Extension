Table 52092301 "Posted Cash Receipt Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(3; "Mode of Payment"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,Draft,Teller,Bank Transfer';
            OptionMembers = " ",Cash,Cheque,Draft,Teller,"Bank Transfer";
        }
        field(4; "Payment Document No."; Code[20])
        {
        }
        field(5; "Posting Description"; Text[100])
        {
        }
        field(8; "Last Modified By ID"; Code[50])
        {
        }
        field(9; Amount; Decimal)
        {
            CalcFormula = sum("Posted Cash Receipt Line".Amount where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Document Date"; Date)
        {
        }
        field(11; "No. Printed"; Integer)
        {
        }
        field(12; Void; Boolean)
        {
        }
        field(13; "Document Bank Name"; Text[50])
        {
        }
        field(14; Status; Option)
        {
            OptionCaption = 'Open,Approved,Pending Approval,Posted';
            OptionMembers = Open,Approved,"Pending Approval",Posted;
        }
        field(15; "User ID"; Code[50])
        {
        }
        field(16; "Document Bank Code"; Code[10])
        {
            TableRelation = Bank;
        }
        field(17; "No. Series"; Code[10])
        {
        }
        field(18; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(19; "Account No."; Code[20])
        {
            TableRelation = if ("Mode of Payment" = filter(<> " ")) "Bank Account";
        }
        field(20; "Currency Code"; Code[10])
        {
        }
        field(21; "Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Posted Cash Receipt Line"."Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Currency Factor"; Decimal)
        {
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
        }
        field(25; "Dimension Set ID"; Integer)
        {
        }
        field(26; "WHT Amount"; Decimal)
        {
            CalcFormula = sum("Posted Cash Receipt Line"."WHT Amount" where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(27; "WHT Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Posted Cash Receipt Line"."WHT Amount (LCY)" where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(28; "Payer Type"; Option)
        {
            OptionCaption = 'Customer,Vendor,Employee,Others';
            OptionMembers = Customer,Vendor,Employee,Others;
        }
        field(29; "Payer No."; Code[20])
        {
            TableRelation = if ("Payer Type" = const(Customer)) Customer
            else
            if ("Payer Type" = const(Vendor)) Vendor
            else
            if ("Payer Type" = const(Employee)) Employee;
        }
        field(30; "Transaction Time"; Time)
        {
        }
        field(31; "Last Date-Time Modified"; DateTime)
        {
        }
        field(32; "Voided By"; Code[50])
        {
        }
        field(33; "Applying Entry Exist"; Boolean)
        {
        }
        field(34; "External Document No."; Code[20])
        {
        }
        field(35; "Date Lodged"; Date)
        {
        }
        field(36; "Bank Lodged"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(37; "Date-Time Voided"; DateTime)
        {
        }
        field(38; "Confirmation Date"; Date)
        {
        }
        field(39; "Creation Date"; Date)
        {
        }
        field(40; "Posting Date"; Date)
        {
        }
        field(41; Payee; Text[100])
        {
        }
        field(42; "Payment Document Date"; Date)
        {
        }
        field(43; "Entry Status"; Option)
        {
            Editable = false;
            OptionCaption = ',Voided,Posted,Financially Voided';
            OptionMembers = ,Voided,Posted,"Financially Voided";
        }
        field(44; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error(Text009, TableCaption);
    end;

    trigger OnRename()
    begin
        Error(Text010, TableCaption);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        Bank: Record "Bank Account";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[20];
        CurrencyDate: Date;
        NoSeriesMgt: Codeunit 396;
        DimMgt: Codeunit 408;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text000: label 'Account selection is not allowed for %1.';
        Text001: label 'Do you want to update the exchange rate?';
        Text002: label 'You have modified %1.\\';
        Text003: label 'Do you want to update the lines?';
        Text006: label 'If you change %1, the existing receipt lines will be deleted and new receipt lines based on the new information on the header will be created.\\';
        Text007: label 'Do you want to change %1?';
        Text008: label 'You must delete the existing receipt lines before you can change %1.';
        Text009: label 'You can''t delete a %1.';
        Text010: label 'You can''t rename a %1.';
        Text012: label 'Receipt has already been issued on the document %1.';
        Text022: label 'Your action will change the default cash account. Are you sure you want to continue?';
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text065: label 'New receipt number cannot be created because There is no line created for %1. Press Escape to use the number.';
        Text080: label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text081: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text082: label 'The dimensions used in %1 %2 are invalid. %3';
        Text083: label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;


    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;


    procedure PrintReceipt()
    var
        PostedReceiptHeader: Record "Posted Cash Receipt Header";
    begin
        Clear(PostedReceiptHeader);
        PostedReceiptHeader.SetRange("No.", "No.");
        Report.RunModal(Report::"Posted Payment - Receipt", true, false, PostedReceiptHeader)
    end;


    procedure CalcNetAmount(LCY: Boolean): Decimal
    begin
        CalcFields("Amount (LCY)", Amount, "WHT Amount", "WHT Amount (LCY)");
        if LCY then
            exit("Amount (LCY)" - "WHT Amount (LCY)")
        else
            exit(Amount - "WHT Amount")
    end;
}

