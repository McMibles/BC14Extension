Page 52092343 "Courses List"
{
    DataCaptionFields = "Record Type";
    Editable = false;
    PageType = List;
    SourceTable = Course;

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

