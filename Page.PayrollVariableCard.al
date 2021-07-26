Page 52092198 "Payroll Variable Card"
{
    DelayedInsert = true;
    PageType = Document;
    SourceTable = "Payroll Variable Header";
    SourceTableView = where(Processed=const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(PayrollPeriod;"Payroll Period")
                {
                    ApplicationArea = Basic;
                }
                field(PeriodName;"Period Name")
                {
                    ApplicationArea = Basic;
                }
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(PayslipText;"Payslip Text")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(UserId;"User Id")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control12;"Payroll Variable Subform")
            {
                SubPageLink = "Payroll Period"=field("Payroll Period"),
                              "E/D Code"=field("E/D Code");
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
                    Visible = OpenApprovalEntriesExistForCurrUser;
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
                        CurrPage.Update;
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
                        CurrPage.Update;
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
                        RecRef: RecordRef;
                        ApprovalMgt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalMgt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalMgt.OnSendGenericDocForApproval(RecRef);
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
                        ApprovalMgt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalMgt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'F&unctions';
                action(GetLeave)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Leave';
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        HRSetup.Get;
                        PayrollSetup.Get;
                        HRSetup.TestField("Leave Allowance Payment Option",HRSetup."leave allowance payment option"::Payroll);
                        PayrollSetup.TestField("Leave ED Code");
                        if "E/D Code" <> PayrollSetup."Leave ED Code" then
                          Error(Err001);

                        PayrollMgt.GetLeave(Rec);
                    end;
                }
                action(ImportfromExcel)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import from Excel';
                    Ellipsis = true;
                    Image = ImportExcel;

                    trigger OnAction()
                    var
                        ImportPayVarfromExcel: Report "Import Payroll Var.- Excel";
                    begin
                        TestField("Payroll Period");
                        TestField("E/D Code");
                        ImportPayVarfromExcel.SetParameters("Payroll Period","E/D Code");
                        ImportPayVarfromExcel.RunModal;
                        CurrPage.Update(true);
                    end;
                }
                action(ApplytoPayslip)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply to Payslip';
                    Image = ApplyEntries;

                    trigger OnAction()
                    begin
                        ImplementEntries;
                    end;
                }
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        TestField(Status,Status::Open);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        TestField(Status,Status::Open);
    end;

    var
        HRSetup: Record "Human Resources Setup";
        PayrollSetup: Record "Payroll-Setup";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        PayrollMgt: Codeunit "Payroll-Management";
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        Err001: label 'This acn only be done for annual leave';
}

