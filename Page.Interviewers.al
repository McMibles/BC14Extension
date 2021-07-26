Page 52092374 Interviewers
{
    PageType = List;
    SourceTable = Interviewer;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeCode;"Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(EMail;"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field(MobileNo;"Mobile No.")
                {
                    ApplicationArea = Basic;
                }
                field(InterviewDate;"Interview Date")
                {
                    ApplicationArea = Basic;
                }
                field(InterviewTime;"Interview Time")
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
            group(Interviewer)
            {
                Caption = 'Interviewer';
                action(ScoreCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Score Card';
                    RunObject = Page "Interviewer Score Card";
                    RunPageLink = "Schedule Code"=field("Schedule Code"),
                                  "Employee Code"=field("Employee Code");
                }
            }
        }
    }
}

