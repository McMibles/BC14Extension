Table 52092162 "ED Condition"
{

    fields
    {
        field(1;Type;Option)
        {
            OptionCaption = ' ,Job Title,Department';
            OptionMembers = " ","Job Title",Department;
        }
        field(2;Value;Code[20])
        {
            TableRelation = if (Type=const("Job Title")) "Job Title"."Ref. No."
                            else if (Type=const(Department)) "Dimension Value".Code where ("Dimension Code"=filter('DEPARTMENT'));
        }
        field(3;"ED Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(4;Mandatory;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"ED Code",Type,Value)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if Type = 0 then
          Error(Text001)
    end;

    trigger OnModify()
    begin
        if Type = 0 then
          Error(Text001)
    end;

    var
        Text001: label 'Type must not be blank';
}

