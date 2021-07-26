Table 52092163 "ED Period and Value"
{

    fields
    {
        field(1;"ED Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(2;"Effective Period";Code[20])
        {
            TableRelation = "Payroll-Period";
        }
        field(3;Amount;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"ED Code","Effective Period",Amount)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

