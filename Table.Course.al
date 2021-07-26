Table 52092191 Course
{
    DrillDownPageID = "Courses List";
    LookupPageID = "Courses List";

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Description;Text[50])
        {
        }
        field(3;"Record Type";Option)
        {
            OptionCaption = 'Course,Grade';
            OptionMembers = Course,Grade;
        }
    }

    keys
    {
        key(Key1;"Record Type","Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Description)
        {
        }
    }
}

