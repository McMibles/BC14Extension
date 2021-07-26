Table 52092233 "Event Due"
{

    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Document Date"; Date)
        {
        }
        field(3; "Due Date"; Date)
        {
        }
        field(4; "Reference Code"; Code[10])
        {
        }
        field(5; Description; Text[30])
        {
        }
        field(6; "Responsible Empl. No."; Code[20])
        {
            TableRelation = Employee;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if Employee.Get("Responsible Empl. No.") then
                    "Employee Name" := Employee.FullName;
            end;
        }
        field(7; Venue; Text[40])
        {
        }
        field(8; "Start Date"; Date)
        {
        }
        field(9; "End date"; Date)
        {
        }
        field(10; "Start Time"; Time)
        {
        }
        field(11; "End Time"; Time)
        {
        }
        field(12; Priority; Option)
        {
            OptionMembers = Normal,Low,High;
        }
        field(13; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const(5),
                                                                     "Table Line No." = field("Entry No.")));
            FieldClass = FlowField;
        }
        field(14; Closed; Boolean)
        {
        }
        field(15; Confirmation; Option)
        {
            OptionMembers = " ",Confirm,"Ext. Probation",Terminate;
        }
        field(16; "Ext. Period"; DateFormula)
        {
        }
        field(17; "Grounds for Termination"; Code[10])
        {
            TableRelation = "Grounds for Termination";
        }
        field(18; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(19; "Entry Type"; Option)
        {
            OptionMembers = General,Personal,Confirmation;
        }
        field(20; "User ID"; Code[10])
        {
        }
        field(21; "Employment Date"; Date)
        {
        }
        field(22; "Employee Name"; Text[100])
        {
        }
        field(23; "Venue Code"; Code[10])
        {

            trigger OnValidate()
            begin
                if VenueRec.Get(1, "Venue Code") then
                    Venue := VenueRec.Description;
            end;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Entry Type")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        HRCommentLine.SetRange(HRCommentLine."Table Name", HRCommentLine."table name"::"Misc. Article Information");
        HRCommentLine.SetRange(HRCommentLine."Table Line No.", "Entry No.");
        HRCommentLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if EventDue.Find('+') then
            "Entry No." := EventDue."Entry No." + 1
        else
            "Entry No." := 1;
    end;

    var
        Employee: Record Employee;
        EventDue: Record "Event Due";
        HRCommentLine: Record "Human Resource Comment Line";
        VenueRec: Record "Training Facility";
}

