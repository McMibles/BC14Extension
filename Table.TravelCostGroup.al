Table 52092235 "Travel Cost Group"
{
    DrillDownPageID = "Travel Cost Group";
    LookupPageID = "Travel Cost Group";

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[100])
        {
        }
        field(3;"Account Code";Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                if "Account Code" <> '' then begin
                  GLAccount.Get("Account Code");
                  "Account Name" := GLAccount.Name;
                end else
                  "Account Name" := '';
            end;
        }
        field(4;"Per Night";Boolean)
        {
        }
        field(5;"Payment Request Type";Option)
        {
            OptionCaption = 'Direct Expense,Cash Advance';
            OptionMembers = "Direct Expense","Cash Advance";
        }
        field(7;Accommodation;Boolean)
        {
        }
        field(8;"Account Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        TestField("Account Code");
    end;

    var
        GLAccount: Record "G/L Account";
}

