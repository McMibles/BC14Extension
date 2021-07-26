Page 52092177 "Payroll Internal Loans"
{
    CardPageID = "Payroll Internal Loan Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Payroll-Loan";
    SourceTableView = where("Loan Type"=const(Internal),
                            "Request Location"=const(HR));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LoanID;"Loan ID")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(AccountNo;"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(LoanED;"Loan E/D")
                {
                    ApplicationArea = Basic;
                }
                field(DeductionStartingDate;"Deduction Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(OpenYN;"Open(Y/N)")
                {
                    ApplicationArea = Basic;
                }
                field(LoanType;"Loan Type")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(VoucherNo;"Voucher No.")
                {
                    ApplicationArea = Basic;
                }
                field(LoanAmount;"Loan Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(MonthlyRepayment;"Monthly Repayment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RemainingAmount;"Remaining Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RepaidAmount;"Repaid Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Balance;Balance)
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
            action(LoanEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Loan Entries';
                Image = Entries;
                RunObject = Page "Payroll-Loan Entries";
                RunPageLink = "Loan ID"=field("Loan ID");
                ShortCutKey = 'Ctrl+F7';
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.Setfilters(Database::"Payroll-Loan",6,"Loan ID");
                    ApprovalEntries.Run;
                end;
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(CreatePaymentVoucher)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create &Payment Voucher';
                    Image = Voucher;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        TestField("Loan ID");
                        TestField("Employee No.");
                        TestField(Description);
                        TestField("Account No.");
                        TestField("Loan Amount");
                        TestField("Number of Payments");
                        TestField("Monthly Repayment");
                        TestField("Loan E/D");
                        TestField("Loan Type","loan type"::Internal);
                        TestField(Status,Status::Approved);

                        if "Voucher No." <> '' then
                          Error(Text002,"Voucher No.");

                        CreatePaymentVoucher;

                        Message(Text003,"Voucher No.");

                        CurrPage.Update(false);
                    end;
                }
                separator(Action1000000010)
                {
                }
            }
            group("Request Approval")
            {
                Caption = 'Request';
                action("<Action1000000001>")
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

                        CurrPage.Update(false);
                    end;
                }
                action("<Action1000000003>")
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
                        if "Voucher No." <> '' then
                          Error(Text007);

                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);

                        CurrPage.Update(false);
                    end;
                }
            }
            group(Request)
            {
                action(RejectRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject Request';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        RejectRequest;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance
    end;

    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if not(UserSetup."Payroll Administrator") then begin
          FilterGroup(2);
          SetFilter("Employee Category",UserSetup."Personnel Level");
          FilterGroup(0);
        end else
          SetRange("Employee Category");
    end;

    var
        Text001: label 'Do you want to create %1?';
        Text002: label 'Voucher  No. %1 already created!';
        Text003: label 'Payment Voucher No. %1  Successfully Created!';
        Text005: label 'Do you really want to cancel this loan?';
        Text006: label 'Remaining Amount cannot be greater than the Loan Amount!';
        Text007: label 'Voucher already raised';
        Text008: label 'You are about changing the Remaining Amt to Zero, Are you absolutely sure you want to continue?';
        Text009: label 'You are about changing the Remaining Amt to %1, Are you absolutely sure you want to continue?';
        UserSetup: Record "User Setup";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

