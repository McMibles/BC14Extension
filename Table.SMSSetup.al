Table 52092129 "SMS Setup"
{

    fields
    {
        field(1;"Primary Key";Code[10])
        {
        }
        field(2;"URL SMS User ID";Text[50])
        {
        }
        field(3;"URL SMS Password";Text[50])
        {
        }
        field(4;"Email SMS ID";Text[50])
        {
        }
        field(5;"Email SMS Password";Text[50])
        {
        }
        field(6;"Email SMS Extension";Text[30])
        {
        }
        field(7;"Send SMS By";Option)
        {
            OptionMembers = URLSMS,EMailSMS;
        }
        field(8;"SMS URL";Text[150])
        {
            ExtendedDatatype = URL;
        }
        field(9;"SMS Sender";Text[50])
        {
        }
        field(10;"Test Message";Text[125])
        {
        }
        field(11;"Resolve BVN Url";Text[100])
        {
        }
        field(12;"Resolve BVN Method";Text[100])
        {
        }
        field(13;"Resolve BVN BearerToken";Text[100])
        {
        }
        field(14;"Resolve BVN First Name";Text[20])
        {
        }
        field(15;"Resolve BVN Last Name";Text[20])
        {
        }
        field(16;"Resolve BVN Phone Number";Text[15])
        {
        }
        field(17;"Resolve Date Of Birth";Text[30])
        {
        }
        field(18;"Resolve BVN";Text[30])
        {
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

