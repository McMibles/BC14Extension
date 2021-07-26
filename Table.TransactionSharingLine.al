Table 52092134 "Transaction Sharing Line"
{

    fields
    {
        field(2;"Document Type";Option)
        {
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(3;"Document No.";Code[20])
        {
        }
        field(4;"Line No.";Integer)
        {
        }
        field(5;"Account Type";Option)
        {
            OptionCaption = 'G/L Account,IC Partner';
            OptionMembers = "G/L Account","IC Partner";
        }
        field(6;"Account No.";Code[20])
        {
            TableRelation = if ("Account Type"=const("G/L Account")) "G/L Account"
                            else if ("Account Type"=const("IC Partner")) "IC Partner";
        }
        field(7;Amount;Decimal)
        {
        }
        field(8;"Bal. Account No.";Code[20])
        {
        }
        field(9;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(10;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(11;"Dimension Set ID";Integer)
        {
            Editable = false;
        }
        field(12;"Posting Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Document Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(14;Description;Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

