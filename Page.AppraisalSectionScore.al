Page 52092398 "Appraisal Section Score"
{
    Caption = 'Performance Ratings';
    PageType = List;
    SourceTable = "Appraisal Section Score";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SectionCode;"Section Code")
                {
                    ApplicationArea = Basic;
                }
                field(ScoreCode;"Score Code")
                {
                    ApplicationArea = Basic;
                }
                field(ScoreDescription;"Score Description")
                {
                    ApplicationArea = Basic;
                }
                field(Marks;Marks)
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

