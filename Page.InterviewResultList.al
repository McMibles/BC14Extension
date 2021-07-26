Page 52092378 "Interview Result List"
{
    CardPageID = "Interview Result Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Interview Header";
    SourceTableView = where(Status=filter(Invited|Hired),
                            "Interview Closed"=const(false));

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
                field(DocumentDate;"Document Date")
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
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Level;Level)
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
}

