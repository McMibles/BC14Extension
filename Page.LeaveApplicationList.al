Page 52092357 "Leave Application List"
{
    Caption = 'Leave Application List';
    CardPageID = "Leave Application Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Leave Application";
    SourceTableView = where("Entry Type"=const(Application),
                            Status=const(Approved));

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
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(CauseofAbsenceCode;"Cause of Absence Code")
                {
                    ApplicationArea = Basic;
                }
                field(FromDate;"From Date")
                {
                    ApplicationArea = Basic;
                }
                field(ToDate;"To Date")
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

    var
        UserSetup: Record "User Setup";
}

