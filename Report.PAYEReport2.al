Report 52092196 "PAYE Report 2"
{
    // This report prints a PAYE TAX schedule for employees. The user should enter
    // the Payroll period and if necessary also the specific Employee number(s) that
    // are required to appear in the report. The Periods that are to appear in the
    // schedule MUST be entered.(In this revised edition default EDs have been entered.
    // The schedule is a matrix of employees on the vertical axis and the required
    // E/Ds in the Horizontal axis.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PAYE Report 2.rdlc';


    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(ReportForNavId_20; 20)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
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
            column(IsClosePeriod; IsClosePeriod)
            {
            }
            dataitem(Employee; "Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                DataItemTableView = sorting("Global Dimension 1 Code", "Global Dimension 2 Code");
                RequestFilterFields = "Payroll Period", "Global Dimension 1 Code", "Employee No.", "Tax State";
                RequestFilterHeading = 'Employee';
                column(ReportForNavId_7528; 7528)
                {
                }
                column(Employee_Global_Dimension_1_Code_; "Global Dimension 1 Code")
                {
                }
                column(Employee_Employee_No_; Employee."Employee No.")
                {
                }
                column(Employee_Employee_Name_; Employee."Employee Name")
                {
                }
                column(TaxPaidAmount; TaxPaidAmount)
                {
                }
                column(TaxPayAmount; TaxPayAmount)
                {
                }
                column(Employee__Employee_No_Caption; FieldCaption("Employee No."))
                {
                }
                column(Employee_NAMECaption; FieldCaption("Employee Name"))
                {
                }
                column(Employee__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code"))
                {
                }
                column(Employee_TaxState; Employee."Tax State")
                {
                }
                column(Employee_Payroll_Period; "Payroll Period")
                {
                }
                column(EmpCount; EmpCount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //Get Tax Deducted
                    SetRange("ED Filter", PAYECode);
                    CalcFields("ED Amount");
                    TaxPaidAmount := "ED Amount";
                    if TaxPaidAmount = 0 then
                        CurrReport.Skip;

                    //Get Taxable Pay
                    TaxPayAmount := 0;
                    SetRange("ED Filter", GrossPAYECode);
                    CalcFields("ED Amount");
                    TaxPayAmount := "ED Amount";

                    EmpCount := EmpCount + 1
                end;

                trigger OnPreDataItem()
                begin
                    if IsClosePeriod then
                        CurrReport.Break;

                    case ReportOrder of
                        0:
                            SetCurrentkey("Global Dimension 1 Code", "Global Dimension 2 Code");
                        1:
                            SetCurrentkey("Employee No.");
                    end;
                    UserSetup.Get(UserId);
                    if not (UserSetup."Payroll Administrator") then begin
                        FilterGroup(2);
                        SetFilter("Employee Category", UserSetup."Personnel Level");
                        FilterGroup(0);
                    end else
                        SetRange("Employee Category");
                end;
            }
            dataitem(ClosedPayslip; "Closed Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                DataItemTableView = sorting("Global Dimension 1 Code", "Global Dimension 2 Code");
                column(ReportForNavId_19; 19)
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
                column(ClosedPayslip_TaxPaidAmount; TaxPaidAmount)
                {
                }
                column(ClosedPayslip_TaxPayAmount; TaxPayAmount)
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

                trigger OnAfterGetRecord()
                begin
                    //Get Tax Deducted
                    SetRange("ED Filter", PAYECode);
                    CalcFields("ED Amount");
                    TaxPaidAmount := "ED Amount";
                    if TaxPaidAmount = 0 then
                        CurrReport.Skip;

                    //Get Taxable Pay
                    TaxPayAmount := 0;
                    SetRange("ED Filter", GrossPAYECode);
                    CalcFields("ED Amount");
                    TaxPayAmount := "ED Amount";

                    EmpCount := EmpCount + 1
                end;

                trigger OnPreDataItem()
                begin
                    if not (IsClosePeriod) then
                        CurrReport.Break;

                    case ReportOrder of
                        0:
                            SetCurrentkey("Global Dimension 1 Code", "Global Dimension 2 Code");
                        1:
                            SetCurrentkey("Employee No.");
                    end;
                    ClosedPayslip.SetView(Employee.GetView);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(PAYECode; PAYECode)
                {
                    ApplicationArea = Basic;
                    Caption = 'PAYE ED Code';
                    TableRelation = "Payroll-E/D";
                }
                field(GrossPAYECode; GrossPAYECode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Taxable Earning ED Code';
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
        Report_Label = 'TAX REMITTANCE FOR';
    }

    trigger OnPreReport()
    begin
        CompanyData.Get;
        if Employee.GetFilter("Payroll Period") = '' then
            Error(Text002);

        PeriodRec.Get(Employee.GetFilter("Payroll Period"));

        IsClosePeriod := PeriodRec.Closed;
    end;

    var
        CompanyData: Record "Company Information";
        PeriodRec: Record "Payroll-Period";
        PayrollSetup: Record "Payroll-Setup";
        EDCode: Record "Payroll-E/D";
        UserSetup: Record "User Setup";
        GrossPAYECode: Code[20];
        PAYECode: Code[10];
        TaxPayAmount: Decimal;
        Text001: label 'Request Form not properly completed!';
        Text002: label 'Payroll Period cannot be blank!';
        Text003: label 'Schedule for All Employees.';
        TaxPaidAmount: Decimal;
        ReportOrder: Option "Global Dimension 1 Code","Payroll No.";
        EmpCount: Integer;
        IsClosePeriod: Boolean;
}

