Table 52092173 "Gratuity Ledger Entry"
{
    DrillDownPageID = "Gratuity Ledger Entry";
    LookupPageID = "Gratuity Ledger Entry";

    fields
    {
        field(1;"Employee No.";Code[20])
        {
            TableRelation = "Payroll-Employee";
        }
        field(2;"Period End Date";Date)
        {
        }
        field(3;"Current Amount";Decimal)
        {
        }
        field(4;"Basic Salary";Decimal)
        {
        }
        field(5;"Period Length";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Period End Date")
        {
            Clustered = true;
            SumIndexFields = "Current Amount";
        }
    }

    fieldgroups
    {
    }
}

