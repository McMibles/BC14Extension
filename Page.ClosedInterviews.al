Page 52092382 "Closed Interviews"
{
    CardPageID = "Closed Interview Card";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Interview Header";
    SourceTableView = where(Status=const(Hired),
                            "Interview Closed"=const(true));

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
            }
        }
    }

    actions
    {
    }
}

