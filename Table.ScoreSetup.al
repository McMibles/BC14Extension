Table 52092228 "Score Setup"
{
    DrillDownPageID = "Score List";
    LookupPageID = "Score List";

    fields
    {
        field(1;"Record Type";Option)
        {
            OptionCaption = 'Recruitment Score,Appraisal Score';
            OptionMembers = "Recruitment Score","Appraisal Score";
        }
        field(2;"Code";Code[10])
        {
        }
        field(3;Description;Text[30])
        {
        }
        field(4;"Score %";Decimal)
        {
        }
        field(5;Mark;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Record Type","Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

