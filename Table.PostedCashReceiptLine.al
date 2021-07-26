Table 52092302 "Posted Cash Receipt Line"
{

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
        }
        field(4; "Source No."; Code[20])
        {
        }
        field(5; "Source Name"; Text[100])
        {
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(7; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(8; Amount; Decimal)
        {
        }
        field(9; "Amount (LCY)"; Decimal)
        {
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
        field(16; "Loan ID"; Code[20])
        {
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
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
            SumIndexFields = Amount, "Amount (LCY)";
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit 408;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', 'Receipt Line', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;
}

