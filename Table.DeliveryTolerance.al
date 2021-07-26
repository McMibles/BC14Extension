Table 52092347 "Delivery Tolerance"
{
    DrillDownPageID = "Delivery Tolerances";
    LookupPageID = "Delivery Tolerances";

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"Overdelivery Tolerance %";Decimal)
        {
        }
        field(4;"Overdelivery Relational Qty.";Option)
        {
            OptionCaption = 'Quantity,Outstanding Quantity';
            OptionMembers = Quantity,"Outstanding Quantity";
        }
        field(5;"Underdelivery Tolerance %";Decimal)
        {
        }
        field(6;"Underdelivery Relational Qty.";Option)
        {
            OptionCaption = 'Quantity,Outstanding Quantity';
            OptionMembers = Quantity,"Outstanding Quantity";
        }
        field(7;"Change Quantity";Option)
        {
            OptionCaption = 'Question,Always';
            OptionMembers = Question,Always;
        }
        field(8;"Calculate New Price";Boolean)
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

