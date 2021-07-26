Table 52092359 "Bank LC Limit Details"
{
    Caption = 'Bank LC Limit Details';

    fields
    {
        field(1; "Bank No."; Code[20])
        {
            Caption = 'Bank No.';
            TableRelation = "Bank Account"."No.";
        }
        field(2; "From Date"; Date)
        {
            Caption = 'From Date';
        }
        field(3; Amount; Decimal)
        {
            Caption = 'Amount';

            trigger OnValidate()
            begin
                TestField("From Date");
                TestField("To Date");
                CalcFields("Amount Utilised", "Amount Utilised Amended");
                if "Amount Utilised Amended" = 0 then
                    "Remaining Amount" := Amount - "Amount Utilised"
                else
                    "Remaining Amount" := Amount - "Amount Utilised Amended";
            end;
        }
        field(5; "Amount Utilised"; Decimal)
        {
            // CalcFormula = sum("LC Detail"."LC Value LCY" where ("Issuing Bank"=field("Bank No."),
            //                                                    "Date of Issue"=field("Date Filter")));
            Caption = 'Amount Utilised';
            FieldClass = FlowField;
        }
        field(6; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(7; "Amount Utilised Amended"; Decimal)
        {
            //CalcFormula = sum("LC Detail"."Latest Amended Value" where("Issuing Bank" = field("Bank No."),
            //                                                                        "Date of Issue" = field("Date Filter")));
            Caption = 'Amount Utilised Amended';
            FieldClass = FlowField;
        }
        field(8; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(9; "To Date"; Date)
        {
            Caption = 'To Date';

            trigger OnValidate()
            begin
                if "From Date" > "To Date" then
                    Error('To Date cannot be less than From Date.');
            end;
        }
    }

    keys
    {
        key(Key1; "Bank No.", "From Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

