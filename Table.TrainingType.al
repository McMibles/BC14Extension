Table 52092212 "Training Type"
{
    DrillDownPageID = "Training Type";
    LookupPageID = "Training Type";

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[50])
        {
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
}

