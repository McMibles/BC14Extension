Table 52130423 "WHT Posting Group"
{

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"WithHolding Tax %";Decimal)
        {
        }
        field(4;"Purchase WHT Tax Account";Code[20])
        {
            TableRelation = Vendor;
        }
        field(5;"WHT Authority";Option)
        {
            OptionCaption = ' ,State,Federal';
            OptionMembers = " ",State,Federal;
        }
        field(6;"Sales WHT Tax Account";Code[20])
        {
            TableRelation = Customer;
        }
        field(10;"WHT Calculation Type";Option)
        {
            Caption = 'WHT Calculation Type';
            Editable = false;
            OptionCaption = 'Normal WHT,Full WHT';
            OptionMembers = "Normal WHT","Full WHT";
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

    var
        GLSetup: Record "General Ledger Setup";

    local procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
          GLAcc.Get(AccNo);
          GLAcc.CheckGLAcc;
        end;
    end;


    procedure "GetWHTTax%"(): Decimal
    begin
        exit("WithHolding Tax %");
    end;


    procedure GetSalesWHTTaxAccount(): Code[20]
    begin
        TestField("Sales WHT Tax Account");
        exit("Sales WHT Tax Account");
    end;


    procedure GetPurchWHTTaxAccount(): Code[20]
    begin
        TestField("Purchase WHT Tax Account");
        exit("Purchase WHT Tax Account");
    end;
}

