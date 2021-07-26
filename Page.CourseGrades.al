Page 52092344 "Course Grades"
{
    PageType = List;
    SourceTable = Course;
    SourceTableView = where("Record Type"=const(Grade));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

