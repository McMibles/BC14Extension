Page 52092334 "Grade Level List"
{
    CardPageID = "Grade Level Card";
    PageType = List;
    SourceTable = "Grade Level";

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
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                }
                field(Step;Step)
                {
                    ApplicationArea = Basic;
                }
                field(NoofEmployee;"No. of Employee")
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

