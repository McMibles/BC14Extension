Table 52092136 "Mobile Approval Setup"
{
    Caption = 'Mobile Approval Setup';

    fields
    {
        field(1;"Primary Key";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Base url";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Send Approval Request Method";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(4;"Enforce Multi. Fact. Auth";Boolean)
        {
            Caption = 'Enforce Multifactor Authentication';
            DataClassification = ToBeClassified;
            Description = 'Enforce Multifactor Authentication';
        }
        field(5;"Same E-Mail on User Setup";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Mobile Approval Administrator";Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup" where ("Approval Administrator"=filter(true));
        }
        field(7;"Log In User Name";Text[50])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                //MailManagement.ValidateEmailAddressField("Log In User Name");
            end;
        }
        field(8;Password;Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(9;"Get Token Method";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(10;TenantID;Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Login Http Request Type";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Multi Factor Auth PIN";Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(13;"Multi Factor Auth PIN To Prior";Option)
        {
            Caption = 'Multi Factor Auth PIN To Priority';
            DataClassification = ToBeClassified;
            Description = 'Multi Factor Auth PIN To Priority';
            OptionCaption = 'User PIN,Setup PIN';
            OptionMembers = "User PIN","Setup PIN";
        }
        field(14;"Temp Folder Path";Text[150])
        {
            DataClassification = ToBeClassified;
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

    var
        MailManagement: Codeunit "Mail Management";
}

