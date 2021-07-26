Table 52092241 "Employee Exit Article"
{

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
            Caption = 'Description';
        }
        field(3;"Misc. Article Code";Code[10])
        {
            TableRelation = "Misc. Article";
        }
        field(4;"Staff Debtor";Boolean)
        {
        }
        field(5;"Staff Creditor";Boolean)
        {
        }
        field(6;"Staff Gratuity";Boolean)
        {
        }
        field(7;"Global Dimension 1 Code";Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1),
                                                          "Dimension Value Type"=filter(Standard));
        }
        field(8;"Global Dimension 2 Code";Code[10])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2),
                                                          "Dimension Value Type"=filter(Standard));
        }
        field(9;"Request Code";Code[20])
        {
            TableRelation = "Payment Request Code";

            trigger OnValidate()
            var
                LineType: Integer;
            begin
            end;
        }
        field(10;"Outstanding Cash Advance";Boolean)
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

