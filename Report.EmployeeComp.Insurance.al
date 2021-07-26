Report 52092179 "Employee Comp. Insurance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Comp. Insurance.rdlc';

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(ReportForNavId_22; 22)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(PeriodRec_Name; PeriodRec.Name)
            {
            }
            column(CompanyData_Name; CompanyData.Name)
            {
            }
            column(CompanyData_Address; CompanyData.Address)
            {
            }
            column(CompanyData_Address2; CompanyData."Address 2")
            {
            }
            column(ReportOrder; ReportOrder)
            {
            }
            column(IsClosedPeriod; IsClosedPeriod)
            {
            }
            dataitem(Payslip; "Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                DataItemTableView = sorting("Global Dimension 1 Code", "Global Dimension 2 Code");
                RequestFilterFields = "Payroll Period", "Global Dimension 1 Code", "Employee No.", "Tax State";
                RequestFilterHeading = 'Employee';
                column(ReportForNavId_7528; 7528)
                {
                }
                column(Payslip_Global_Dimension_1_Code_; "Global Dimension 1 Code")
                {
                }
                column(Payslip_Employee_No_; Payslip."Employee No.")
                {
                }
                column(Payslip_Employee_Name_; Payslip."Employee Name")
                {
                }
                column(InsAmount; InsAmount)
                {
                }
                column(GrossAmount; GrossAmount)
                {
                }
                column(Payslip__Employee_No_Caption; FieldCaption("Employee No."))
                {
                }
                column(Payslip_NAMECaption; FieldCaption("Employee Name"))
                {
                }
                column(Payslip__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code"))
                {
                }
                column(Payslip_TaxState; Payslip."Tax State")
                {
                }
                column(Payslip_Payroll_Period; "Payroll Period")
                {
                }
                column(EmpCount; EmpCount)
                {
                }
                column(Employee_Birth_Date; Employee."Birth Date")
                {
                }
                column(Employee_Gender; Employee.Gender)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //Get Insurance Amount
                    SetRange("ED Filter", InsEDCode);
                    CalcFields("ED Amount");
                    InsAmount := "ED Amount";
                    if InsAmount = 0 then
                        CurrReport.Skip;

                    //Get Gross Pay
                    GrossAmount := 0;
                    SetRange("ED Filter", GrossPAYECode);
                    CalcFields("ED Amount");
                    GrossAmount := "ED Amount";

                    EmpCount := EmpCount + 1;
                    Employee.Get(Payslip."Employee No.");
                end;

                trigger OnPreDataItem()
                begin
                    if IsClosedPeriod then
                        CurrReport.Break;

                    case ReportOrder of
                        0:
                            SetCurrentkey("Global Dimension 1 Code", "Global Dimension 2 Code");
                        1:
                            SetCurrentkey("Employee No.");
                    end;
                end;
            }
            dataitem(ClosedPayslip; "Closed Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                DataItemTableView = sorting("Global Dimension 1 Code", "Global Dimension 2 Code");
                column(ReportForNavId_21; 21)
                {
                }
                column(ClosedPayslip_Global_Dimension_1_Code_; "Global Dimension 1 Code")
                {
                }
                column(ClosedPayslip_Employee_No_; ClosedPayslip."Employee No.")
                {
                }
                column(ClosedPayslip_Employee_Name_; ClosedPayslip."Employee Name")
                {
                }
                column(ClosedPayslip_InsAmount; InsAmount)
                {
                }
                column(ClosedPayslip_GrossAmount; GrossAmount)
                {
                }
                column(ClosedPayslip__Employee_No_Caption; FieldCaption("Employee No."))
                {
                }
                column(ClosedPayslip_NAMECaption; FieldCaption("Employee Name"))
                {
                }
                column(ClosedPayslip__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code"))
                {
                }
                column(ClosedPayslip_TaxState; ClosedPayslip."Tax State")
                {
                }
                column(ClosedPayslip_Payroll_Period; "Payroll Period")
                {
                }
                column(ClosedPayslip_EmpCount; EmpCount)
                {
                }
                column(ClosedPayslip_Employee_Birth_Date; Employee."Birth Date")
                {
                }
                column(ClosedPayslip_Employee_Gender; Employee.Gender)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //Get Insurance Amount
                    SetRange("ED Filter", InsEDCode);
                    CalcFields("ED Amount");
                    InsAmount := "ED Amount";
                    if InsAmount = 0 then
                        CurrReport.Skip;

                    //Get Gross Pay
                    GrossAmount := 0;
                    SetRange("ED Filter", GrossPAYECode);
                    CalcFields("ED Amount");
                    GrossAmount := "ED Amount";

                    EmpCount := EmpCount + 1;
                    Employee.Get(ClosedPayslip."Employee No.");
                end;

                trigger OnPreDataItem()
                begin
                    if not (IsClosedPeriod) then
                        CurrReport.Break;

                    case ReportOrder of
                        0:
                            SetCurrentkey("Global Dimension 1 Code", "Global Dimension 2 Code");
                        1:
                            SetCurrentkey("Employee No.");
                    end;
                    ClosedPayslip.SetView(Payslip.GetView);
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
                field(InsEDCode; InsEDCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Compensation Insurance Code';
                    TableRelation = "Payroll-E/D";
                }
                field(GrossPAYECode; GrossPAYECode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Gross Pay Code';
                    TableRelation = "Payroll-E/D";
                }
                field(ReportOrder; ReportOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Report sorting Order';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Report_Label = 'EMPLOYEE COMPENSATION INSURANCE FOR';
    }

    trigger OnPreReport()
    begin
        CompanyData.Get;
        if Payslip.GetFilter("Payroll Period") = '' then
            Error(Text002);
        PeriodRec.Get(Payslip.GetFilter("Payroll Period"));
        IsClosedPeriod := PeriodRec.Closed;
    end;

    var
        CompanyData: Record "Company Information";
        PeriodRec: Record "Payroll-Period";
        PayrollSetup: Record "Payroll-Setup";
        EDCode: Record "Payroll-E/D";
        Employee: Record "Payroll-Employee";
        GrossPAYECode: Code[20];
        InsEDCode: Code[20];
        InsAmount: Decimal;
        Text001: label 'Request Form not properly completed!';
        Text002: label 'Payroll Period cannot be blank!';
        Text003: label 'Schedule for All Employees.';
        GrossAmount: Decimal;
        ReportOrder: Option "Global Dimension 1 Code","Payroll No.";
        EmpCount: Integer;
        IsClosedPeriod: Boolean;
}

