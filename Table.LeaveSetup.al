Table 52092194 "Leave Setup"
{

    fields
    {
        field(1;"Record Type";Option)
        {
            OptionCaption = 'Employee,Category,Grade Level';
            OptionMembers = Employee,Category,"Grade Level";
        }
        field(2;"No.";Code[20])
        {
            TableRelation = if ("Record Type"=const(Employee)) Employee."No."
                            else if ("Record Type"=const(Category)) "Employee Category".Code
                            else if ("Record Type"=const("Grade Level")) "Grade Level".Code;
        }
        field(3;"Absence Code";Code[10])
        {
            TableRelation = "Cause of Absence";

            trigger OnValidate()
            begin
                if "Absence Code" <> '' then begin
                  CauseOfAbsence.Get("Absence Code");
                  "No. of Days Allowed" := CauseOfAbsence."No. of Days Allowed";
                end else begin
                  "No. of Days Allowed" := 0;
                  "Allowance %" := 0;
                end;
            end;
        }
        field(4;"No. of Days Allowed";Decimal)
        {
            DecimalPlaces = 0:2;
        }
        field(5;"Allowance %";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Record Type","No.","Absence Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        CauseOfAbsence: Record "Cause of Absence";
}

