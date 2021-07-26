Page 52092424 "Training Schedule List"
{
    CardPageID = "Training Schedule";
    Editable = false;
    PageType = List;
    SourceTable = "Training Schedule Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(ObjectiveTheme;"Objective/Theme")
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
                field(Duration;Duration)
                {
                    ApplicationArea = Basic;
                }
                field(BudgetAmount;"Budget Amount")
                {
                    ApplicationArea = Basic;
                }
                field(EstimatedCost;"Estimated Cost")
                {
                    ApplicationArea = Basic;
                }
                field(ActualCost;"Actual Cost")
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
            group("<Action1000000015>")
            {
                Caption = 'Training Schedule';
                action("<Action1000000016>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(Database::"Training Schedule Header",0,Code);
                        ApprovalEntries.Run;
                    end;
                }
            }
        }
        area(processing)
        {
            group("Function")
            {
                action(TrainingEvaluation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Evaluation';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Training Evaluation";
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("<Action1000000013>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("<Action1000000014>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Enabled = OpenApprovalEntriesExist;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance
    end;

    var
        RecRef: RecordRef;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExist: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

