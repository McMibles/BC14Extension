Table 52092295 "Posted Payment Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Document Type"; Option)
        {
            OptionCaption = 'Payment Voucher,Cash Advance,Retirement';
            OptionMembers = "Payment Voucher","Cash Advance",Retirement;
        }
        field(3; "Line No."; Integer)
        {
        }
        field(6; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(7; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";
        }
        field(8; Description; Text[100])
        {
        }
        field(9; "Currency Code"; Code[10])
        {
        }
        field(10; "Payment Type"; Option)
        {
            OptionCaption = 'Supp. Invoice,Cust. Refund,Cash Advance,Retirement,Others';
            OptionMembers = "Supp. Invoice","Cust. Refund","Cash Advance",Retirement,Others;
        }
        field(11; "Source Code"; Code[20])
        {
        }
        field(12; "Loan ID"; Code[20])
        {
        }
        field(13; "Loan Interest Amount"; Decimal)
        {
        }
        field(14; "IC Partner Code"; Code[20])
        {
            TableRelation = "IC Partner";
        }
        field(15; "IC Partner G/L Acc. No."; Code[20])
        {
            TableRelation = "IC G/L Account";
        }
        field(16; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(17; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(18; "Dimension Set ID"; Integer)
        {
        }
        field(19; "Job No."; Code[20])
        {
            TableRelation = Job;
        }
        field(20; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(21; "Maintenance Code"; Code[20])
        {
            TableRelation = Maintenance;
        }
        field(22; "FA Posting Type"; Option)
        {
            OptionCaption = ' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance';
            OptionMembers = " ","Acquisition Cost",Depreciation,"Write-Down",Appreciation,"Custom 1","Custom 2",Disposal,Maintenance;
        }
        field(23; "Payment Req. Line No."; Integer)
        {
        }
        field(24; "Consignment PO No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
        }
        field(25; "Consignment Code"; Code[20])
        {
        }
        field(26; "Consignment Charge Code"; Code[20])
        {
        }
        field(27; "Depreciation Book Code"; Code[10])
        {
        }
        field(28; "Account Name"; Text[100])
        {
            Editable = false;
        }
        field(40; "Check Entry No."; Integer)
        {
        }
        field(97; "Interest Amount"; Decimal)
        {
        }
        field(98; "Interest Amount (LCY)"; Decimal)
        {
        }
        field(99; "Request Amount"; Decimal)
        {
            Editable = false;
        }
        field(100; Amount; Decimal)
        {
        }
        field(101; "Amount (LCY)"; Decimal)
        {
        }
        field(102; "WHT Posting Group"; Code[10])
        {
        }
        field(103; "WHT%"; Decimal)
        {
        }
        field(104; "WHT Amount"; Decimal)
        {
        }
        field(105; "WHT Amount (LCY)"; Decimal)
        {
        }
        field(106; "Applies-to Doc. Type"; Option)
        {
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(107; "Applies-to Doc. No."; Code[20])
        {
        }
        field(108; "Applies-to ID"; Code[20])
        {
        }
        field(109; "Vendor Entry No."; Integer)
        {
        }
        field(110; "Source PO No."; Code[20])
        {
        }
        field(111; "Applied to Entry No."; Integer)
        {
        }
        field(112; "Cash Advance Amount"; Decimal)
        {
            Editable = false;
        }
        field(113; "Cash Advance Amount (LCY)"; Decimal)
        {
            Editable = false;
        }
        field(114; "Attached Doc. No."; Code[20])
        {
            TableRelation = "Posted Payment Header"."No." where("Document Type" = const("Cash Advance"),
                                                                 "Entry Status" = const(Posted),
                                                                 "Retirement Status" = const(Open));
        }
        field(115; "Attached Line No."; Integer)
        {
        }
        field(200; "Retirement No."; Code[20])
        {
        }
        field(201; "Retirement Line No."; Integer)
        {
        }
        field(5000; "Request No."; Code[20])
        {
        }
        field(5001; "Request Line No."; Integer)
        {
        }
        field(5002; "WHT Line"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Attached Doc. No.")
        {
            SumIndexFields = "Cash Advance Amount", "Cash Advance Amount (LCY)", Amount, "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    var
        PaymentVouchHeader: Record "Payment Header";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Job: Record Job;
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        Bank: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        ICGLAccount: Record "IC G/L Account";
        FASetup: Record "FA Setup";
        FADeprBook: Record "FA Depreciation Book";
        StatusCheckSuspended: Boolean;
        DimMgt: Codeunit 408;
        Text000: label 'Vendor %1 has been blocked from payment. Contact your Payable Officer for Assistance.';
        Text001: label 'Fixed Asset %1 has not been properly set up. Depreciation book must be established for the asset.';
        Text005: label 'Function not available. Contact your System Administrator for Assistance.';
        Text006: label '%1 must not be specified when the document is not an intercompany transaction.';
        CurrencyDate: Date;


    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', TableCaption, "Document No.", "Line No."));
    end;
}

