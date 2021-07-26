Page 52092178 "Payroll External Loan Card"
{
    Caption = 'Loan Card';
    DeleteAllowed = false;
    PageType = Card;
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    SourceTable = "Payroll-Loan";
    SourceTableView = where("Loan Type" = const(External));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(LoanID; "Loan ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeNo; "Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = EditEmployeeNo;
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
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Booking)
            {
                Caption = 'Booking';
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
                    Editable = LoanAmountEditable;
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
                    Editable = EditRemainingAmtAdjt;
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
            group(Application)
            {
                Caption = '&Application';
                action(LoanEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Entries';
                    RunObject = Page "Payroll-Loan Entries";
                    RunPageLink = "Loan ID" = field("Loan ID");
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(Register)
                {
                    ApplicationArea = Basic;
                    Caption = 'Register';
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
                        CreateProllLoanEntry('', "Loan E/D", 0, Date, 0, "Loan Amount", 0);
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
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Open(Y/N)" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Loan Type" := 1;
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
        Text002: label 'Voucher No. %2 already created!';
        Text003: label 'Voucher No. %2 Successfully Created!';
        Text005: label 'Do you really want to cancel this loan?';
        Text006: label 'Remaining Amount cannot be greater than the Loan Amount!';
        [InDataSet]
        LoanTypeEditable: Boolean;
        [InDataSet]
        "Originated ByEditable": Boolean;
        [InDataSet]
        LoanAmountEditable: Boolean;
        [InDataSet]
        EditEmployeeNo: Boolean;
        Text007: label 'Voucher already raised';
        [InDataSet]
        EditRemainingAmtAdjt: Boolean;
        Text008: label 'You are about changing the Remaining Amt to Zero, Are you absolutely sure you want to continue?';
        Text009: label 'You are about changing the Remaining Amt to %1, Are you absolutely sure you want to continue?';


    procedure EditEmployeeNoField()
    begin
    end;
}

