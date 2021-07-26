Page 52092478 "Leave Resumption List-ESS"
{
    CardPageID = "Leave Resumption Card-ESS";
    PageType = List;
    SourceTable = "Leave Resumption";
    SourceTableView = where(Status=filter(Open|"Pending Approval"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo;"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(CauseofAbsenceCode;"Cause of Absence Code")
                {
                    ApplicationArea = Basic;
                }
                field(YearNo;"Year No.")
                {
                    ApplicationArea = Basic;
                }
                field(LeaveStartDate;"Leave Start Date")
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
    }

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        SetRange("Employee No.",UserSetup."Employee No.");
        FilterGroup(0);
    end;

    var
        UserSetup: Record "User Setup";
}

