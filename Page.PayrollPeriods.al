Page 52092148 "Payroll Periods"
{
    PageType = List;
    SourceTable = "Payroll-Period";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(PeriodCode;"Period Code")
                {
                    ApplicationArea = Basic;
                }
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Publish;Publish)
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
        area(navigation)
        {
            action("Open Period Approvals")
            {
                ApplicationArea = Basic;
                Caption = 'Approvals';
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.Setfilters(Database::"Payroll-Period",6,"Period Code");
                    ApprovalEntries.Run;
                end;
            }
            action("Closed Period Approvals")
            {
                AccessByPermission = TableData "Posted Approval Entry"=R;
                ApplicationArea = Suite;
                Caption = 'Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalsMgmt.ShowPostedApprovalEntries(RecordId);
                end;
            }
        }
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
            }
            group(Release)
            {
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocument: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocument: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformManualReopen(RecRef);
                    end;
                }
            }
            group("Request Approval")
            {
                action("Send &Approval Request")
                {
                    ApplicationArea = Basic;
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgt: Codeunit "Approvals Hook";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalsMgt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalsMgt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
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
            group(Functions)
            {
                Caption = 'Functions';
                action(CreatePeriod)
                {
                    ApplicationArea = Basic;
                    Caption = '&Create Period';
                    Ellipsis = true;
                    Image = CreateYear;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Report "Create Payroll Periods";
                }
                action(ClosePeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Close Period';
                    Image = CloseYear;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        PayrollCheck.Run(Rec);
                        ClosePeriod.Run(Rec);
                    end;
                }
                separator(Action28)
                {
                }
                action(MonthlyVariables)
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Variables';
                    Image = PeriodEntries;
                    RunObject = Page "Payroll Variable List";
                    RunPageLink = "Payroll Period"=field("Period Code");
                }
            }
            group(Payrolls)
            {
                Caption = 'Payrolls';
                action("Test Close Payroll")
                {
                    ApplicationArea = Basic;
                    Image = TestReport;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PayrollCheck.SetShowMessage;
                        PayrollCheck.Run(Rec);
                        Clear(PayrollCheck);
                    end;
                }
                action("Open Payroll")
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Payroll';
                    Image = WageLines;
                    RunObject = Page "Payslip List";
                    RunPageLink = "Payroll Period"=field("Period Code");
                }
                action("Closed Payroll")
                {
                    ApplicationArea = Basic;
                    Caption = 'Monthly Payroll';
                    Image = WageLines;
                    RunObject = Page "Closed Payslip List";
                    RunPageLink = "Payroll Period"=field("Period Code");
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance
    end;

    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ReleaseDocument: Codeunit "Release Documents";
        PayrollCheck: Codeunit "Payroll Period Check";
        ClosePeriod: Codeunit "Close Payroll Period";
        RecRef: RecordRef;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        DocNoVisible: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
    end;
}

