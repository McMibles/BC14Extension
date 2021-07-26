Table 52092154 "Payroll-Factor Lookup Line"
{

    fields
    {
        field(1;"Table Id";Code[20])
        {
        }
        field(2;"E/D Code";Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                EDRec.Get("E/D Code");
                Description := EDRec.Description;
                "Commision Report Text" := EDRec."Reimburseable Report Text";
            end;
        }
        field(3;"Add/Subtract";Option)
        {
            OptionMembers = Add,Subtract;
        }
        field(4;"Min. Amount";Decimal)
        {
            DecimalPlaces = 0:9;
        }
        field(5;"Max. Amount";Decimal)
        {
            DecimalPlaces = 0:9;
        }
        field(6;Percentage;Decimal)
        {
            DecimalPlaces = 0:9;
        }
        field(7;"Entry Type";Option)
        {
            OptionMembers = Actual,Cummulative,Previous,Annual,"First Half";
        }
        field(8;Description;Text[40])
        {
        }
        field(9;Amount;Decimal)
        {
        }
        field(10;Factor;Decimal)
        {
            DecimalPlaces = 0:5;
            InitValue = 1;
            NotBlank = true;
        }
        field(11;Projection;Option)
        {
            OptionMembers = " ","Current Month",Annual;
        }
        field(12;"Cummulative Period";Option)
        {
            OptionMembers = "Current Period","Previous Period","Balance at Previous",All;
        }
        field(13;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(14;"Incl. Special Payroll";Boolean)
        {
        }
        field(53;"Commision Report Text";Text[50])
        {
        }
        field(54;"Use Arrears Amount";Boolean)
        {
        }
        field(5000;"Line No";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(5001;"Cummulative Start Period";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Beginning of Year,Arrear Effective Date';
            OptionMembers = "Beginning of Year","Arrear Effective Date";
        }
        field(5002;"Factor Basis";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Static,Nos Of Arrears';
            OptionMembers = Static,"Nos Of Arrears";
        }
    }

    keys
    {
        key(Key1;"Table Id","Employee Category","E/D Code","Line No")
        {
            Clustered = true;
        }
        key(Key2;"E/D Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        EDRec: Record "Payroll-E/D";
}

