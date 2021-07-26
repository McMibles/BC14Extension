Table 52092131 "Token Setup"
{

    fields
    {
        field(1;"Primary Key";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Base Url";Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = URL;
        }
        field(3;"User Group";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;Realm;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5;"Requester ID";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"File Path";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(7;"Url UserName";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(8;"Url Password";Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(9;"Login Method";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10;"Global Login Pin";Text[20])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(11;"Use Global Pin";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Use Token Login";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Trigger Challenge Method";Text[100])
        {
        }
        field(14;"Validate Token Method";Text[100])
        {
        }
        field(15;Counter;Integer)
        {
        }
        field(16;"Windows Client";Boolean)
        {
        }
        field(17;"Web Client";Boolean)
        {
        }
        field(18;"Mobile App Client";Boolean)
        {
        }
        field(19;"Use Default Token Option";Boolean)
        {
        }
        field(20;"Default Token Option";Option)
        {
            OptionCaption = 'SMS,EMail,TOTP,HOTP';
            OptionMembers = SMS,EMail,TOTP,HOTP;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

