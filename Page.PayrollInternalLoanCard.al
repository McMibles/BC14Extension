Page 52092176 "Payroll Internal Loan Card"
{
    Caption = 'Loan Card';
    PageType = Card;
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    SourceTable = "Payroll-Loan";
    SourceTableView = where("Loan Type" = const(Internal),
                            "Request Location" = const(HR));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field(LoanID; "Loan ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeNo; "Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName; "Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(LoanED; "Loan E/D")
                {
                    ApplicationArea = Basic;
                }
                field(Guarantor; Guarantor)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PreferredPmtMethod; "Preferred Pmt. Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PreferredBankCode; "Preferred  Bank Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BankAccount; "Bank Account")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BankAccountName; "Bank Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
                    Editable = false;
                }
            }
            group(Booking)
            {
                Caption = 'Booking';
                Editable = false;
                field(AccountType; "Account Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(AccountNo; "Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SourceDocumentType; "Source Document Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceDocumentNo; "Source Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CounterAcctType; "Counter Acct. Type")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field(CounterAcctNo; "Counter Acct. No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Control1901254101)
            {
                Caption = 'Status';
                field(LoanAmount; "Loan Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(NumberofPayments; "Number of Payments")
                {
                    ApplicationArea = Basic;
                }
                field(MonthlyRepayment; "Monthly Repayment")
                {
                    ApplicationArea = Basic;
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
                }
                field(OpenYN; "Open(Y/N)")
                {
                    ApplicationArea = Basic;
                }
                field(SuspendedYN; "Suspended(Y/N)")
                {
                    ApplicationArea = Basic;
                }
                field(SuspensionEndingDate; "Suspension Ending Date")
                {
                    ApplicationArea = Basic;
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
                field(RemainingAmtAdjustment; "Remaining Amt Adjustment")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Interest)
            {
                Caption = 'Interest';
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
                field(InterestChargeableAmount; "Interest Chargeable Amount")
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
        area(navigation)
        {
            action(LoanEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Loan Entries';
                Image = Entries;
                RunObject = Page "Payroll-Loan Entries";
                RunPageLink = "Loan ID" = field("Loan ID");
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
                    ApprovalEntries.Setfilters(Database::"Payroll-Loan", 6, "Loan ID");
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
                        TestField(Status, Status::Approved);

                        if "Voucher No." <> '' then
                            Error(Text002, "Voucher No.");

                        CreatePaymentVoucher;

                        Message(Text003, "Voucher No.");

                        CurrPage.Update(false);
                    end;
                }
                separator(Action1000000000)
                {
                }
                action(ChangeRemainingAmt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Change Remaining Amt.';
                    Image = Edit;

                    trigger OnAction()
                    var
                        RemainingAmt: Decimal;
                        NewRemainingAmt: Decimal;
                        RemainingAmtDiff: Decimal;
                    begin
                        TestField("Loan E/D");
                        TestField(Status, Status::Open);
                        RemainingAmtDiff := 0;
                        NewRemainingAmt := 0;
                        RemainingAmt := 0;
                        if "Remaining Amt Adjustment" = 0 then
                            if not Confirm(Text008, false) then
                                exit;
                        if "Remaining Amt Adjustment" <> 0 then
                            if not Confirm(Text009, false, "Remaining Amt Adjustment") then
                                exit;

                        NewRemainingAmt := "Remaining Amt Adjustment";
                        if NewRemainingAmt > "Loan Amount" then
                            Error(Text006);

                        CalcFields("Remaining Amount");

                        RemainingAmt := "Remaining Amount";
                        RemainingAmtDiff := NewRemainingAmt - "Remaining Amount";
                        if (RemainingAmtDiff <> 0) then
                            CreateProllLoanEntry('', "Loan E/D", 4, WorkDate, 0, RemainingAmtDiff, 0);

                        CalcFields("Remaining Amount");
                        "Open(Y/N)" := "Remaining Amount" <> 0;
                        "Remaining Amt Adjustment" := 0;
                        Modify;
                    end;
                }
                action(CancelLoan)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Loan';
                    Image = Cancel;

                    trigger OnAction()
                    begin
                        if not Confirm(Text005, false) then
                            exit;
                        CancelLoan;
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
                action(CalculateMonthlyInterest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate Monthly Interest';
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Open(Y/N)" := true;
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        "Loan Type" := 0;
    end;

    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if not (UserSetup."Payroll Administrator") then begin
            FilterGroup(2);
            SetFilter("Employee Category", UserSetup."Personnel Level");
            FilterGroup(0);
        end else
            SetRange("Employee Category");
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
        Text002: label 'Voucher No. %1 already created!';
        Text003: label 'Voucher No. %1 Successfully Created!';
        Text005: label 'Do you really want to cancel this loan?';
        Text006: label 'Remaining Amount cannot be greater than the Loan Amount!';
        Text007: label 'Voucher already raised';
        Text008: label 'You are about changing the Remaining Amt to Zero, Are you absolutely sure you want to continue?';
        Text009: label 'You are about changing the Remaining Amt to %1, Are you absolutely sure you want to continue?';
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

