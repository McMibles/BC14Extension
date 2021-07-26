Table 52092138 "NAV Mobile User Setup"
{

    fields
    {
        field(1;"Mobile Administrator ID";Code[50])
        {
        }
        field(2;"Record ID to Approve";RecordID)
        {
            Caption = 'Record ID to Approve';
        }
        field(3;"Mobile User ID";Code[50])
        {
        }
    }

    keys
    {
        key(Key1;"Mobile Administrator ID","Record ID to Approve")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

