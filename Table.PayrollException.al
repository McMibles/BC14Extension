Table 52092172 "Payroll Exception"
{

    fields
    {
        field(1;"Employee No.";Code[20])
        {
        }
        field(2;Remark;Text[50])
        {
        }
        field(3;"ED Code";Code[20])
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

