Table 52092451 "Absence Registration"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(3;"Employee Name";Text[60])
        {
            Editable = false;
        }
        field(4;"Absence Date";Date)
        {
        }
        field(5;"From  Date";Date)
        {
        }
        field(6;"To Date";Date)
        {
        }
        field(7;"Entry Type";Option)
        {
            OptionMembers = Auto,Manual;
        }
        field(8;"Cause Of Absence";Code[20])
        {
            TableRelation = "Cause of Absence".Code;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*IF "Entry No." = 0 THEN BEGIN
          IF AbsenceReg.FIND('+') THEN
            "Entry No." := AbsenceReg."Entry No." + 1
          ELSE
            "Entry No." := 1;
        END;
        */

    end;
}

