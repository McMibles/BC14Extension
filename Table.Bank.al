Table 52092177 Bank
{
    DrillDownPageID = Banks;
    LookupPageID = Banks;

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Name;Text[30])
        {
        }
        field(3;"Search Name";Text[30])
        {
        }
        field(4;"Branch Code";Code[20])
        {
        }
        field(5;"Sort Code";Code[20])
        {
        }
        field(60000;"Default Payment Platform";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'NIBSSPayPlus,RTGS,UBA';
            OptionMembers = NIBSSPayPlus,RTGS,UBA;
        }
        field(60001;"Mode Upload to Platform";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'API,E-Mail';
            OptionMembers = API,"E-Mail";
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

