Table 52092219 "Employee Category Rating Setup"
{

    fields
    {
        field(1;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(2;"Rating type";Option)
        {
            OptionMembers = " ",Grading,Percentage;
        }
        field(3;"Max%";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Employee Category")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

