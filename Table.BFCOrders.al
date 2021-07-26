Table 52092365 "BFC Orders"
{
    Caption = 'LC Orders';

    fields
    {
        field(1;"BFC No.";Code[20])
        {
            Caption = 'BFC No.';
            Editable = false;
        }
        field(3;"Issued To/Received From";Code[20])
        {
            Caption = 'Issued To/Received From';
            Editable = false;
            TableRelation = Vendor;
        }
        field(4;"Order No.";Code[20])
        {
            Caption = 'Order No.';
            Editable = false;
        }
        field(5;"Shipment Date";Date)
        {
            Caption = 'Shipment Date';
            Editable = false;
        }
        field(6;"Order Value";Decimal)
        {
            Caption = 'Order Value';
            Editable = false;
        }
        field(8;Renewed;Boolean)
        {
            Caption = 'Renewed';
            Editable = false;
        }
        field(9;"Received Bank Receipt No.";Boolean)
        {
            Caption = 'Received Bank Receipt No.';
        }
    }

    keys
    {
        key(Key1;"BFC No.","Order No.")
        {
            Clustered = true;
        }
        key(Key2;Renewed,"BFC No.","Order No.")
        {
            SumIndexFields = "Order Value";
        }
    }

    fieldgroups
    {
    }
}

