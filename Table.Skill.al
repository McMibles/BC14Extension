Table 52092196 Skill
{
    DrillDownPageID = Skills;
    LookupPageID = Skills;

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[40])
        {
        }
        field(3;"Default Qualification";Code[10])
        {
            TableRelation = Qualification;
        }
        field(4;"Default Training";Code[10])
        {
        }
        field(5;"No. of Employee";Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(6;"No. of Applicant";Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(7;"Empl. Status Filter";Option)
        {
            Editable = false;
            FieldClass = FlowFilter;
            OptionMembers = Active,Inactive,Terminated;
        }
        field(8;"Applicant Status Filter";Option)
        {
            Editable = false;
            FieldClass = FlowFilter;
            OptionMembers = Option1,Option2;
        }
        field(9;"Vacancy Filter";Code[10])
        {
        }
        field(10;"Default Institution";Text[30])
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
}

