Page 52092370 "Employee Req. List"
{
    CardPageID = "Employee Requisition Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Employee Requisition";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(JobTitleCode;"Job Title Code")
                {
                    ApplicationArea = Basic;
                }
                field(OpenDate;"Open Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoRequired;"No. Required")
                {
                    ApplicationArea = Basic;
                }
                field(EmploymentStatus;"Employment Status")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
            group(EmpRequistion)
            {
                Caption = 'Emp. Requistion';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(Database::"Employee Requisition",0,"No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("<Action1000000036>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    Image = Skills;
                    RunObject = Page "Skill Entry-Others";
                    RunPageLink = "Record Type"=const(Vacancy),
                                  "No."=field("No.");
                }
                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    RunObject = Page "Job/Vacancy Qualifications";
                    RunPageLink = "Record Type"=const(Vacancy),
                                  "No."=field("No.");
                }
            }
        }
    }
}

