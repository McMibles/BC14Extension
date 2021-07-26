Page 52092474 "Additional Reviewers- Appraisa"
{
    PageType = List;
    SourceTable = "Additional Reviewer";

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
                field(AppraisalPeriodCode;"Appraisal Period Code")
                {
                    ApplicationArea = Basic;
                }
                field(AppraisalType;"Appraisal Type")
                {
                    ApplicationArea = Basic;
                }
                field(AppraiseeEmployeeNo;"Appraisee Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
                field(AdditionalComment;"Additional Comment")
                {
                    ApplicationArea = Basic;
                }
                field(AppraisalTemplateCode;"Appraisal Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(MarkAsCompleted;"Mark As Completed")
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

