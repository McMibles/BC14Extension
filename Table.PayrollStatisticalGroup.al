Table 52092165 "Payroll Statistical Group"
{
    DrillDownPageID = "Payroll Statistical Groups";
    LookupPageID = "Payroll Statistical Groups";

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[30])
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

