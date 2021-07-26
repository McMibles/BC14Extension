Table 52092242 "Employee Exit Article Entry"
{

    fields
    {
        field(1;"Exit No.";Code[20])
        {
            NotBlank = true;
            TableRelation = "Employee Exit";
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(3;"Misc. Article Code";Code[10])
        {
            TableRelation = "Employee Exit Article";
        }
        field(4;"Debit Amount";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Debit Amount';

            trigger OnValidate()
            begin
                Amount := "Debit Amount";
                "Credit Amount" := 0;
            end;
        }
        field(5;"Credit Amount";Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Credit Amount';

            trigger OnValidate()
            begin
                Amount := -"Credit Amount";
                "Debit Amount" := 0;
            end;
        }
        field(6;"Confirmed By";Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Responsible Manager" = '' then
                  "Responsible Manager" := "Confirmed By";
            end;
        }
        field(7;Status;Option)
        {
            OptionCaption = ' ,Retained by Staff,Return to Company,Affect Final Benefit';
            OptionMembers = " ","Retained by Staff","Return to Company","Affect Final Benefit";
        }
        field(8;"Global Dimension 1 Code";Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1),
                                                          "Dimension Value Type"=filter(Standard));
        }
        field(9;"Global Dimension 2 Code";Code[10])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2),
                                                          "Dimension Value Type"=filter(Standard));
        }
        field(10;Quantity;Integer)
        {
            BlankZero = true;
            MinValue = 1;
        }
        field(11;"Responsible Manager";Code[20])
        {
            Caption = 'Responsible Employee';
            TableRelation = Employee;
        }
        field(12;"Serial No.";Text[30])
        {
            Caption = 'Serial No.';
        }
        field(13;Description;Text[30])
        {
            Caption = 'Description';
        }
        field(14;Amount;Decimal)
        {
            Editable = false;
        }
        field(15;"Staff Debtor";Boolean)
        {
        }
        field(16;"Staff Creditor";Boolean)
        {
        }
        field(17;"Staff Gratuity";Boolean)
        {
        }
        field(18;"Outstanding Cash Advance";Boolean)
        {
        }
        field(20;"User ID";Code[50])
        {
            Editable = false;
        }
        field(21;"Modified Date";Date)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Exit No.","Employee No.","Misc. Article Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "User ID" := UserId;
        "Modified Date" := Today;
    end;
}

