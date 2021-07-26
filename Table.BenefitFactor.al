Table 52092171 "Benefit Factor"
{
    LookupPageID = "Benefit Factor";

    fields
    {
        field(1;"Lower Limit";Integer)
        {
        }
        field(2;"Upper Limit";Integer)
        {
        }
        field(3;"Min. Age";Integer)
        {
        }
        field(4;"Factor %";Decimal)
        {
        }
        field(5;Basis;Option)
        {
            OptionMembers = "Monthly Basic","Total Emolument";
        }
        field(6;"Code";Code[10])
        {
        }
    }

    keys
    {
        key(Key1;"Code","Lower Limit","Upper Limit","Min. Age")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

