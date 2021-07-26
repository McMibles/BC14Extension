Page 52092449 "HR Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "HR Cue";

    layout
    {
        area(content)
        {
            cuegroup(DocumentApprovals)
            {
                Caption = 'Document Approvals';
                field(LeaveAppPendingApproval;"Leave App. Pending Approval")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Leave Applications";
                    LookupPageID = "Leave Applications";
                }
                field(ExitDocPendingApproval;"Exit Doc. Pending Approval")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
            }
            cuegroup(ReadyforProcessing)
            {
                Caption = 'Ready for Processing';
                field(ApprovedLeaveApplication;"Approved Leave Application")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Leave Applications";
                    LookupPageID = "Leave Applications";
                }
                field(ApprovedEmpReq;"Approved Emp. Req.")
                {
                    ApplicationArea = Basic;
                }
                field(ApprovedExitDoc;"Approved Exit Doc.")
                {
                    ApplicationArea = Basic;
                }
                field(QueryAwaitingAction;"Query Awaiting Action")
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
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;
}

