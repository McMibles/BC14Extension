Page 52092441 "Exit Card"
{
    PageType = Card;
    SourceTable = "Employee Exit";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate;"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExitDate;"Exit Date")
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
                field(GradeLevel;"Grade Level")
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
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(GroundsforExit;"Grounds for Exit")
                {
                    ApplicationArea = Basic;
                }
                field(ExitReason;"Exit Reason")
                {
                    ApplicationArea = Basic;
                }
                field(EmploymentDate;"Employment Date")
                {
                    ApplicationArea = Basic;
                }
                field(LengthofService;"Length of Service")
                {
                    ApplicationArea = Basic;
                }
                field(LengthofServiceText;"Length of Service Text")
                {
                    ApplicationArea = Basic;
                }
                field(MiscellaneousArticles;"Miscellaneous Articles")
                {
                    ApplicationArea = Basic;
                }
            }
            group(FinalPaymentComputation)
            {
                Caption = 'Final Payment Computation';
                field(UnusedLeaveDays;"Unused Leave Days")
                {
                    ApplicationArea = Basic;
                }
                field(UnearnedLeaveDays;"Unearned Leave Days")
                {
                    ApplicationArea = Basic;
                }
                field(GratuityAmount;"Gratuity Amount")
                {
                    ApplicationArea = Basic;
                }
                field("13thMonthSalary";"13th Month Salary")
                {
                    ApplicationArea = Basic;
                }
                field(LeaveAllowance;"Leave Allowance")
                {
                    ApplicationArea = Basic;
                }
                field(EntitledLeaveAllowance;"Entitled Leave Allowance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(OutStandingLoanAmount;"OutStanding Loan Amount")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeDebtorsBalance;"Employee Debtor's Balance")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCreditorsBalance;"Employee Creditor's Balance")
                {
                    ApplicationArea = Basic;
                }
                field(AssetsinEmployeePossession;"Assets in Employee Possession")
                {
                    ApplicationArea = Basic;
                }
                field(UnearnedLeave;"Unearned Leave")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(OutstandingCashAdvance;"Outstanding Cash Advance")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control4;"Employee Exit Subform")
            {
                Caption = 'Exit Lines';
                SubPageLink = "Exit No."=field("No."),
                              "Employee No."=field("Employee No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID"=const(60200),
                                  "Document No."=field("No.");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(Database::"Employee Exit",6,"No.");
                        ApprovalEntries.Run;
                    end;
                }
            }
            group(ActionGroup1)
            {
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
                        if "Outstanding Cash Advance" <> 0 then
                          Error(CashAdvErr);

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
                Caption = 'Request Approval';
                action("<Action1000000013>")
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
                        if "Outstanding Cash Advance" <> 0 then
                          Error(CashAdvErr);

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
            group("Function")
            {
                Caption = 'Function';
                action("<Action1000000022>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Discontinue';
                    Image = Pause;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        DiscontinueExit;
                    end;
                }
                action("Process Exit")
                {
                    ApplicationArea = Basic;
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ProcessExit;
                    end;
                }
                action(CreateBenefitVoucher)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Benefit Voucher';
                    Enabled = ExitProcessed;
                    Image = CreateDocument;
                    Visible = ExitProcessed;

                    trigger OnAction()
                    begin
                        //CreateTerminalVoucher;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance
    end;

    trigger OnOpenPage()
    begin
        if Status = Status::Processed then
          ExitProcessed := true
        else
          ExitProcessed := false;
    end;

    var
        CalledFromApproval: Boolean;
        UserSetup: Record "User Setup";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CashAdvErr: label 'Kindly ensure you retire all your cash advances before you proceed';
        ExitProcessed: Boolean;


    procedure SetCalledFromApproval()
    begin
        CalledFromApproval := true;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

