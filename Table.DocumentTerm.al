Table 52092342 "Document Term"
{

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Receipt,Posted Invoice,Posted Credit Memo,Posted Return Shipment';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Posted Invoice","Posted Credit Memo","Posted Return Shipment";
        }
        field(2;"Document No.";Code[20])
        {
        }
        field(3;Type;Option)
        {
            OptionCaption = ' ,Payment,Delivery';
            OptionMembers = " ",Payment,Delivery;
        }
        field(4;"Line No.";Integer)
        {
        }
        field(5;Description;Text[250])
        {
        }
        field(6;"User ID";Code[20])
        {
            Editable = false;
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(7;Date;Date)
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.",Type,"Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := UserId;
        Date := Today;
    end;
}

