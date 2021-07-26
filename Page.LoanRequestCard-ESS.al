Page 52092182 "Loan Request Card - ESS"
{
    Caption = 'Loan Request Card';
    PageType = Card;
    Permissions = TableData Customer = rimd,
                  TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    SourceTable = "Payroll-Loan";
    SourceTableView = where("Loan Type" = const(Internal));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = PageEditable;
                field(LoanID; "Loan ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeNo; "Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeName; "Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PortalID; "Portal ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MobileUserID; "Mobile User ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SystemCreatedEntry; "System Created Entry")
                {
                    ApplicationArea = Basic;
                    HideValue = false;
                    Visible = false;
                }
                field(CreatedfromExternalPortal; "Created from External Portal")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LoanED; "Loan E/D")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(Guarantor; Guarantor)
                {
                    ApplicationArea = Basic;
                }
                field(PreferredPmtMethod; "Preferred Pmt. Method")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        EnableFields;
                    end;
                }
                field(PreferredBankCode; "Preferred  Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field(BankAccount; "Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field(BankAccountName; "Bank Account Name")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory; "Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field(GradeLevel; "Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control1901254101)
            {
                Caption = 'Status';
                Editable = PageEditable;
                field(LoanAmount; "Loan Amount")
                {
                    ApplicationArea = Basic;
                }
                field(NumberofPayments; "Number of Payments")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(MonthlyRepayment; "Monthly Repayment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(RemainingAmount; "Remaining Amount")
                {
                    ApplicationArea = Basic;
                }
                field(RepaidAmount; "Repaid Amount")
                {
                    ApplicationArea = Basic;
                }
                field(DeductionStartingDate; "Deduction Starting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(OpenYN; "Open(Y/N)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field(SuspendedYN; "Suspended(Y/N)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SuspensionEndingDate; "Suspension Ending Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SuspendedBy; "Suspended By")
                {
                    ApplicationArea = Basic;
                }
                field(CancelledBy; "Cancelled By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Interest)
            {
                Caption = 'Interest';
                Editable = false;
                field(InterestCalculationMethod; "Interest Calculation Method")
                {
                    ApplicationArea = Basic;
                }
                field(InterestRate; "Interest Rate (%)")
                {
                    ApplicationArea = Basic;
                }
                field(InterestAmount; "Interest Amount")
                {
                    ApplicationArea = Basic;
                }
                field(InterestDateFormula; "Interest Date Formula")
                {
                    ApplicationArea = Basic;
                }
                field(InterestStartingDate; "Interest Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(InterestRepaidAmount; "Interest Repaid Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(InterestRemainingAmount; "Interest Remaining Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000000>")
            {
                Caption = 'Request';
                action("<Action1000000001>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send to HR';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        SendToHR;
                        CurrPage.Update(false);
                    end;
                }
                action("<Action1000000003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recall from HR';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if "Voucher No." <> '' then
                            Error(Text007);
                        RecallFromHR;

                        CurrPage.Update(false);
                    end;
                }
            }
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
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                            ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
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
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableFields;
        SetControlAppearance
    end;

    trigger OnInit()
    begin
        PageEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        LoanRec."Loan Type" := 0;
        "Account Type" := "account type"::Customer;
        UserSetup.Get(UserId);
        "Account No." := UserSetup."Employee No.";
    end;

    var
        LoanRec: Record "Payroll-Loan";
        CustLedgEntry: Record "Cust. Ledger Entry";
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        ProllPayslipLine: Record "Payroll-Payslip Line";
        ProllLoanEntry: Record "Payroll-Loan Entry";
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        CustLedgEntryList: Page "Customer Ledger Entries";
        ProllPayslipLineList: Page "Payslip Lines";
        ProllRecalculate: Report "Recalculate Payroll Lines";
        StaffNo: Code[20];
        RemainingAmt: Decimal;
        AmtToApply: Decimal;
        Window: Dialog;
        Text000: label 'Voucher Type must not be %1 on Loan %2!';
        Text001: label 'Do you want to create %1?';
        Text002: label '%1 No. %2 already created!';
        Text003: label 'Payment Voucher %1 No. %2 Successfully Created!';
        Text005: label 'Do you really want to cancel this loan?';
        Text006: label 'Remaining Amount cannot be greater than the Loan Amount!';
        Text007: label 'Voucher already raised';
        [InDataSet]
        PageEditable: Boolean;
        CalledFromApproval: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        DocNoVisible: Boolean;


    procedure EnableFields()
    begin
        PageEditable := Status = Status::Open;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

