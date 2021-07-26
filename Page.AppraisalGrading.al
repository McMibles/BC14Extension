Page 52092400 "Appraisal Grading"
{
    Caption = 'Performance Grading';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Appraisal Grading";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LowerScore;"Lower Score")
                {
                    ApplicationArea = Basic;
                }
                field(UpperScore;"Upper Score")
                {
                    ApplicationArea = Basic;
                }
                field(GradeCode;"Grade Code")
                {
                    ApplicationArea = Basic;
                }
                field(Percentage;"Percentage %")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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

