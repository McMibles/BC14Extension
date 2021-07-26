Table 52092167 "Employee Amount"
{

    fields
    {
        field(1;"Employee No.";Code[20])
        {
        }
        field(2;"ED Code";Code[20])
        {
        }
        field(20;Amount;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","ED Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

