Report 52092159 "Bank Advice"
{
    // This report prints the payment schedules to banks.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Advice.rdlc';


    dataset
    {
        dataitem(Bank; Bank)
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(BankCode_PayrollBank; Code)
            {
                IncludeCaption = true;
            }
            column(BankName_PayrollBank; Name)
            {
                IncludeCaption = true;
            }
            column(BranchCode_PayrollBank; "Branch Code")
            {
                IncludeCaption = true;
            }
            column(Text1; Text001)
            {
            }
            column(IsClosedPeriod; IsClosedPeriod)
            {
            }
            dataitem("Payroll-Payslip Header"; "Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                DataItemLink = "CBN Bank Code" = field(Code);
                DataItemTableView = sorting("CBN Bank Code", "Global Dimension 1 Code", "Global Dimension 2 Code") order(ascending);
                RequestFilterFields = "Payroll Period", "Employee Category";
                column(ReportForNavId_1000000001; 1000000001)
                {
                }
                column(EmployeeNo_PayrollPayslipHeader; "Employee No.")
                {
                    IncludeCaption = true;
                }
                column(EmployeeName_PayrollPayslipHeader; "Employee Name")
                {
                    IncludeCaption = true;
                }
                column(EDAmount_PayrollPayslipHeader; "ED Amount")
                {
                }
                column(BankAccount_PayrollPayslipHeader; "Bank Account")
                {
                }
                column(PaymentDescription; PaymentDescription)
                {
                }
                column(PaymentDate; PaymentDate)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    case PrintBy of
                        Printby::"Net Salary":
                            begin
                                PayrollSetup.TestField("Net Pay E/D Code");
                                "Payroll-Payslip Header".SetFilter("ED Filter", PayrollSetup."Net Pay E/D Code");
                                "Payroll-Payslip Header".CalcFields("ED Amount");
                            end;
                        Printby::"Net Reimbursable":
                            begin
                                PayrollSetup.TestField(PayrollSetup."Reimbursable Pay E/D Code");
                                "Payroll-Payslip Header".SetFilter("ED Filter", PayrollSetup."Reimbursable Pay E/D Code");
                                "Payroll-Payslip Header".CalcFields("ED Amount");
                            end;
                        Printby::"Total Net Pay":
                            begin
                                PayrollSetup.TestField(PayrollSetup."Total Net Pay E/D");
                                "Payroll-Payslip Header".SetFilter("ED Filter", PayrollSetup."Total Net Pay E/D");
                                "Payroll-Payslip Header".CalcFields("ED Amount");
                            end;
                    end;
                    if "Payroll-Payslip Header"."ED Amount" = 0 then
                        CurrReport.Skip;

                    if "Payroll-Payslip Header"."ED Amount" < 0 then
                        Error(Text003, "Payroll-Payslip Header"."Employee No.");

                    TotalAmt := TotalAmt + "ED Amount";

                    if (TotalAmt > MaximumAmt) and (MaximumAmt <> 0) then
                        Error(Text013);
                end;

                trigger OnPostDataItem()
                begin
                    if (TotalAmt > MaximumAmt) and (MaximumAmt <> 0) then
                        Error(Text013);
                end;

                trigger OnPreDataItem()
                begin
                    if IsClosedPeriod then
                        CurrReport.Break;

                    UserSetup.Get(UserId);
                    if not (UserSetup."Payroll Administrator") then begin
                        FilterGroup(2);
                        if UserSetup."Personnel Level" <> '' then
                            SetFilter("Employee Category", UserSetup."Personnel Level")
                        else
                            SetRange("Employee Category");
                        FilterGroup(0);
                    end else
                        SetRange("Employee Category");
                end;
            }
            dataitem(ClosedPayroll; "Closed Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                DataItemLink = "CBN Bank Code" = field(Code);
                DataItemTableView = sorting("CBN Bank Code", "Global Dimension 1 Code", "Global Dimension 2 Code") order(ascending);
                column(ReportForNavId_7; 7)
                {
                }
                column(EmployeeNo_ClosedPayroll; ClosedPayroll."Employee No.")
                {
                    IncludeCaption = true;
                }
                column(EmployeeName_ClosedPayroll; ClosedPayroll."Employee Name")
                {
                    IncludeCaption = true;
                }
                column(EDAmount_ClosedPayroll; ClosedPayroll."ED Amount")
                {
                }
                column(BankAccount_ClosedPayroll; ClosedPayroll."Bank Account")
                {
                }
                column(PaymentDescriptionClosedPayroll; PaymentDescription)
                {
                }
                column(PaymentDateClosedPayroll; PaymentDate)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    case PrintBy of
                        Printby::"Net Salary":
                            begin
                                PayrollSetup.TestField("Net Pay E/D Code");
                                ClosedPayroll.SetFilter("ED Filter", PayrollSetup."Net Pay E/D Code");
                                ClosedPayroll.CalcFields("ED Amount");
                            end;
                        Printby::"Net Reimbursable":
                            begin
                                PayrollSetup.TestField(PayrollSetup."Reimbursable Pay E/D Code");
                                ClosedPayroll.SetFilter("ED Filter", PayrollSetup."Reimbursable Pay E/D Code");
                                ClosedPayroll.CalcFields("ED Amount");
                            end;
                        Printby::"Total Net Pay":
                            begin
                                PayrollSetup.TestField(PayrollSetup."Total Net Pay E/D");
                                ClosedPayroll.SetFilter("ED Filter", PayrollSetup."Total Net Pay E/D");
                                ClosedPayroll.CalcFields("ED Amount");
                            end;
                    end;
                    if ClosedPayroll."ED Amount" = 0 then
                        CurrReport.Skip;

                    if ClosedPayroll."ED Amount" < 0 then
                        Error(Text003, ClosedPayroll."Employee No.");

                    TotalAmt := TotalAmt + "ED Amount";

                    if (TotalAmt > MaximumAmt) and (MaximumAmt <> 0) then
                        Error(Text013);
                end;

                trigger OnPostDataItem()
                begin
                    if (TotalAmt > MaximumAmt) and (MaximumAmt <> 0) then
                        Error(Text013);
                end;

                trigger OnPreDataItem()
                begin
                    if not (IsClosedPeriod) then
                        CurrReport.Break;

                    ClosedPayroll.SetView("Payroll-Payslip Header".GetView);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PrintBy; PrintBy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print By';
                }
                field(PaymentDescription; PaymentDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Description';
                }
                field(PaymentDate; PaymentDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Date';
                }
                field(MaximumAmt; MaximumAmt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Limit Amount';
                }
                field(IsClosedPeriod; IsClosedPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Is Closed Period';
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
        PayrollSetup.Get;
        if "Payroll-Payslip Header".GetFilter("Payroll Period") = '' then
            Error(Text002);

        PeriodRec.Get("Payroll-Payslip Header".GetFilter("Payroll Period"));
        IsClosedPeriod := PeriodRec.Closed;
        UserSetup.Get(UserId);
    end;

    var
        Text001: label 'Please credit the following Account(s) with the amount(s}\indicated against them.';
        CompanyData: Record "Company Information";
        EDCode: Record "Payroll-E/D";
        PeriodRec: Record "Payroll-Period";
        PayrollSetup: Record "Payroll-Setup";
        Text002: label 'Payroll Period must be specified!';
        UserSetup: Record "User Setup";
        PaymentDescription: Text;
        PaymentDate: Date;
        MaximumAmt: Decimal;
        TotalAmt: Decimal;
        PrintBy: Option "Net Salary","Net Reimbursable","Total Net Pay";
        //DimMgt: Codeunit DimensionManagement;
        Text003: label 'Amount for employee %1 cannot be correct.';
        Text004: label 'STAFF ACCOUNT NUMBER';
        Text005: label 'COMPANY ACCOUNT NO.';
        Text006: label 'DATE OF PAYMENT';
        Text007: label 'DESCRIPTION OF PAYMENT';
        Text008: label 'BANK NAME';
        Text009: label 'EMPLOYEE CODE';
        Text010: label 'EMPLOYEE NAME';
        Text011: label 'STAFF GRADE LEVEL';
        Text012: label 'PERIOD';
        Text013: label 'Selected number of employee will produce amount greater than the maximum amount limit. Set filter to export within the limit.';
        IsClosedPeriod: Boolean;
}

