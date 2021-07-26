Page 52092342 Courses
{
    PageType = List;
    SourceTable = Course;
    SourceTableView = where("Record Type"=const(Course));

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

