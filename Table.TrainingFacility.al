Table 52092210 "Training Facility"
{
    DataCaptionFields = "Code",Description,Type;

    fields
    {
        field(1;Type;Option)
        {
            OptionMembers = Equipment,Venue,Facilitator;
        }
        field(2;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(3;Description;Text[40])
        {
        }
        field(4;Address;Text[30])
        {
        }
        field(5;"Address 2";Text[30])
        {
        }
        field(6;Contact;Text[30])
        {
        }
        field(7;"Phone No.";Code[20])
        {
        }
        field(8;"Responsible Employee";Code[20])
        {
            TableRelation = Employee;
        }
        field(9;"In-House/External";Option)
        {
            OptionMembers = "In-House",External;
        }
        field(10;Quantity;Integer)
        {
        }
        field(11;Status;Option)
        {
            OptionMembers = "In Order","Out-of Order","Not Available";
        }
        field(12;"Equip. In Use?";Boolean)
        {
            CalcFormula = exist("Training Schedule Line" where ("Equipment Code"=field(Code)));
            FieldClass = FlowField;
        }
        field(13;"Venue In Use?";Boolean)
        {
            CalcFormula = exist("Training Schedule Line" where ("Venue Code"=field(Code)));
            FieldClass = FlowField;
        }
        field(14;"Facilitator In Use?";Boolean)
        {
            CalcFormula = exist("Training Schedule Line" where (Facilitator=field(Code)));
            FieldClass = FlowField;
        }
        field(15;"Serial No.";Code[20])
        {
        }
        field(16;"Costing Method";Option)
        {
            OptionMembers = "Fixed",Participant,Day,Hour;
        }
        field(17;Amount;Decimal)
        {
        }
        field(18;"Max. Duration";Code[10])
        {
            DateFormula = true;
        }
    }

    keys
    {
        key(Key1;Type,"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

