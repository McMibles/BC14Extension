Page 52092371 "Interview Schedule List"
{
    CardPageID = "Interview Schedule Card";
    Editable = false;
    PageType = List;
    SourceTable = "Interview Header";
    SourceTableView = where("Schedule Closed"=const(false));

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
                field(EmpRequisitionCode;"Emp. Requisition Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(InternalExternal;"Internal/External")
                {
                    ApplicationArea = Basic;
                }
                field(ModeofInterview;"Mode of Interview")
                {
                    ApplicationArea = Basic;
                }
                field(InterviewClosed;"Interview Closed")
                {
                    ApplicationArea = Basic;
                }
                field(InterviewingOfficers;"Interviewing Officers")
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

