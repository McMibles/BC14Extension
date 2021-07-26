Page 52092335 "Job Title Card"
{
    PageType = Card;
    SourceTable = "Job Title";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(RefNo;"Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(TitleDescription;"Title/Description")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category';
                }
                field(GradeLevelCode;"Grade Level Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                field(MinWorkingExperience;"Min. Working Experience")
                {
                    ApplicationArea = Basic;
                }
                field(NoofEmployee;"No. of Employee")
                {
                    ApplicationArea = Basic;
                }
                field(ApprovedEstablishment;"Approved Establishment")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(JobTitle)
            {
                Caption = 'Job Title';
                action(Skills)
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    Image = Skills;
                    RunObject = Page "Skill Entry-Others";
                    RunPageLink = "Record Type"=const("Job Title"),
                                  "No."=field("Ref. No.");
                }
                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    RunObject = Page "Job/Vacancy Qualifications";
                    RunPageLink = "Record Type"=const("Job Title"),
                                  "No."=field("Ref. No.");
                }
            }
        }
    }
}

