Page 52092179 "Payroll External Loans"
{
    CardPageID = "Payroll External Loan Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Payroll-Loan";
    SourceTableView = where("Loan Type"=const(External));

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
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(Register)
                {
                    ApplicationArea = Basic;
                    Caption = 'Register';

                    trigger OnAction()
                    begin
                        if not Confirm(Text001,false,"Loan ID") then
                          Error(Text002);
                        Register;
                        Message(Text003)
                    end;
                }
            }
        }
    }

    var
        Text001: label 'Do you want to register this loan %1?';
        Text002: label 'Loan registration aborted';
        Text003: label 'Registration Completed';
}

