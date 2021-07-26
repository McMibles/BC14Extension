Table 52092239 "Employee Travel Setup"
{

    fields
    {
        field(1;"Employee Catgory";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(2;"Travel Type";Option)
        {
            OptionCaption = ' ,Local,International';
            OptionMembers = " ","Local",International;
        }
        field(3;"Travel Group";Code[10])
        {
            TableRelation = "Travel Group";
        }
        field(4;"Travel Cost Code";Code[10])
        {
            TableRelation = "Travel Cost Group";
        }
        field(5;Amount;Decimal)
        {
        }
        field(6;"Currency Code";Code[10])
        {
            TableRelation = Currency;
        }
        field(8;Description;Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Employee Catgory","Travel Type","Travel Group","Travel Cost Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        TravelCostGroup: Record "Travel Cost Group";
}

