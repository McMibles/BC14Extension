Table 52092358 "LC Setup"
{
    Caption = 'LC Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Detail Nos."; Code[10])
        {
            Caption = 'Detail Nos.';
            TableRelation = "No. Series";
        }
        field(3; "Amended Nos."; Code[10])
        {
            Caption = 'Amended Nos.';
            TableRelation = "No. Series";
        }
        field(4; "LC Expiration Alert Start Day"; Integer)
        {
        }
        field(5; "Bills for Collection Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(23; "Send LC Expiration To"; Text[100])
        {
            Caption = 'Send First Warning To';
        }
        field(24; "Send Form M Expiration To"; Text[100])
        {
        }
        field(25; "Form M Expir. Alert Start Day"; Integer)
        {
        }
        field(26; "LC Maturity Alert Start Day"; Integer)
        {
        }
        field(27; "Send LC Maturity To"; Text[100])
        {
            Caption = 'Send First Warning To';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

