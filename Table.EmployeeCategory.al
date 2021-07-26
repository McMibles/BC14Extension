Table 52092186 "Employee Category"
{
    DrillDownPageID = "Employee Category";
    LookupPageID = "Employee Category";

    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[50])
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

    var
        AbsenceSetup: Record "Leave Setup";


    procedure GetLeaveDays(AbsenceCode: Code[20]): Decimal
    begin
        if AbsenceSetup.Get(AbsenceSetup."record type"::Category,Code,AbsenceCode) then
          exit(AbsenceSetup."No. of Days Allowed");
    end;


    procedure GetAllowance(AbsenceCode: Code[20]): Decimal
    begin
        if AbsenceSetup.Get(AbsenceSetup."record type"::Category,Code,AbsenceCode) then
          exit(AbsenceSetup."Allowance %");
    end;
}

