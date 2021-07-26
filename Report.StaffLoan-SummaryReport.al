Report 52092176 "Staff Loan - Summary Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Staff Loan - Summary Report.rdlc';

    dataset
    {
        dataitem(Employee; "Payroll-Employee")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_7528; 7528)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(UserId; UserId)
            {
            }
            column(EmployeeFilter; EmployeeFilter)
            {
            }
            column(ProllLoanFilter; ProllLoanFilter)
            {
            }
            column(Balance_at_____FORMAT_CurrDate_; 'Balance at ' + Format(CurrDate))
            {
            }
            column(LoanBalance; LoanBalance)
            {
            }
            column(Staff_LoanCaption; Staff_LoanCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Loan_Summary_ReportCaption; Loan_Summary_ReportCaptionLbl)
            {
            }
            column(Payroll_Loans__Employee_No__Caption; "Payroll-Loan".FieldCaption("Employee No."))
            {
            }
            column(Payroll_Loans__Employee_Name_Caption; "Payroll-Loan".FieldCaption("Employee Name"))
            {
            }
            column(Payroll_Loans_DescriptionCaption; "Payroll-Loan".FieldCaption(Description))
            {
            }
            column(Payroll_Loans__Loan_Amount_Caption; "Payroll-Loan".FieldCaption("Loan Amount"))
            {
            }
            column(Payroll_Loans__Monthly_Repayment_Caption; "Payroll-Loan".FieldCaption("Monthly Repayment"))
            {
            }
            column(SerialNoCaption; SerialNoCaptionLbl)
            {
            }
            column(Repaid_AmountCaption; Repaid_AmountCaptionLbl)
            {
            }
            column(Payroll_Loans__Deduction_Starting_Date_Caption; "Payroll-Loan".FieldCaption("Deduction Starting Date"))
            {
            }
            column(LoanBalanceCaption; LoanBalanceCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            dataitem("Payroll-Loan"; "Payroll-Loan")
            {
                CalcFields = "Remaining Amount", "Repaid Amount";
                DataItemLink = "Employee No." = field("No.");
                DataItemTableView = sorting("Employee No.", "Loan E/D");
                RequestFilterFields = "Loan ID", "Loan E/D";
                column(ReportForNavId_7474; 7474)
                {
                }
                column(Payroll_Loans__Employee_No__; "Employee No.")
                {
                }
                column(Payroll_Loans__Employee_Name_; "Employee Name")
                {
                }
                column(Payroll_Loans_Description; Description)
                {
                }
                column(Payroll_Loans__Loan_Amount_; "Loan Amount")
                {
                }
                column(Payroll_Loans__Monthly_Repayment_; "Monthly Repayment")
                {
                }
                column(LoanBalance_Control32; LoanBalance)
                {
                }
                column(SerialNo; SerialNo)
                {
                }
                column(Loan_Amount____LoanBalance; "Loan Amount" - LoanBalance)
                {
                }
                column(Payroll_Loans__Deduction_Starting_Date_; "Deduction Starting Date")
                {
                }
                column(Payroll_Loans_Loan_ID; "Loan ID")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ("Posting Date for Loan" > CurrDate) then
                        CurrReport.Skip;

                    CalcFields("Repaid Amount", "Remaining Amount");
                    LoanBalance := "Remaining Amount";
                    if (LoanBalance = 0) and (not InclZeroBalance) then
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    "Payroll-Loan".SetRange("Date Filter", 0D, CurrDate);
                    //CurrReport.CreateTotals(LoanBalance);
                    if not (IncludeNonPostedLoan) then
                        SetRange(Posted, true);
                end;
            }

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals(LoanBalance);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(InclZeroBalance; InclZeroBalance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Include Loan with Zeo Balance';
                }
                field(IncludeNonPostedLoan; IncludeNonPostedLoan)
                {
                    ApplicationArea = Basic;
                    Caption = 'Include Non-Posted Loans';
                }
                field(CurrDate; CurrDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance at Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        EmployeeFilter := Employee.GetFilters;
        ProllLoanFilter := Employee.GetFilters;
    end;

    var
        PayrollPeriod: Record "Payroll-Period";
        CurrPeriodCode: Code[10];
        LoanBalance: Decimal;
        SerialNo: Integer;
        InclZeroBalance: Boolean;
        IncludeNonPostedLoan: Boolean;
        EmployeeFilter: Text[150];
        ProllLoanFilter: Text[150];
        CurrDate: Date;
        Staff_LoanCaptionLbl: label 'Staff Loan';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Loan_Summary_ReportCaptionLbl: label 'Loan Summary Report';
        SerialNoCaptionLbl: label 'S/N';
        Repaid_AmountCaptionLbl: label 'Repaid Amount';
        LoanBalanceCaptionLbl: label 'GRAND TOTAL';
}

