Page 52092442 "Exit List"
{
    CardPageID = "Exit Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Employee Exit";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate;"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(DepartmentCode;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Department Code';
                }
                field(UnitCode;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Code';
                }
                field(ExitDate;"Exit Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(ExitReason;"Exit Reason")
                {
                    ApplicationArea = Basic;
                }
                field(NoSeries;"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(GratuityAmount;"Gratuity Amount")
                {
                    ApplicationArea = Basic;
                }
                field(OutStandingLoanAmount;"OutStanding Loan Amount")
                {
                    ApplicationArea = Basic;
                }
                field(MiscellaneousArticles;"Miscellaneous Articles")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Release)
            {
                Caption = 'Release';
                action("<Action1000000019>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocs: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocs.PerformanualManualDocRelease(RecRef);
                    end;
                }
                action("<Action1000000018>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocs: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocs.PerformManualReopen(RecRef);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("<Action1000000017>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }
            }
            group(ActionGroup2)
            {
                Caption = 'General';
                action("<Action1000000022>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Discontinue';
                    Image = Pause;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance
    end;

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
    end;

    trigger OnOpenPage()
    begin
        /*IF NOT (CalledFromApproval) THEN BEGIN
          FILTERGROUP(2);
          UserSetup.GET(USERID);
          UserSetup.TESTFIELD("Employee No.");
          SETRANGE("Employee No.",UserSetup."Employee No.");
          FILTERGROUP(0);
        END;
         */

    end;

    var
        OpenApprovalEntriesExist: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

