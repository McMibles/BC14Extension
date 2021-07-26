Report 52092162 "Amounts for one E/D"
{
    // This report totals the amounts for the required E/D in the selected periods
    // The amounts are listed per Employee. Employees without this E/D within the
    // selected period will not be listed in the report
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Amounts for one ED.rdlc';


    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(ReportForNavId_2; 2)
            {
            }
            column(Today; Today)
            {
            }
            column(CompanyData_Name; CompanyData.Name)
            {
            }
            column(HeadingText; HeadingText)
            {
            }
            column(UserId; UserId)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(ReportOrder; ReportOrder)
            {
            }
            column(IsClosedPeriod; IsClosedPeriod)
            {
            }
            dataitem(Employee; "Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                RequestFilterFields = "Payroll Period", "ED Filter", "Salary Group", "Employee No.", "Global Dimension 1 Code";
                RequestFilterHeading = 'Period and E/D Code ';
                column(ReportForNavId_7528; 7528)
                {
                }
                column(Employee_AmountED; DelChr(GetFilter("ED Filter"), '<>') + '   in Period: ' + GetFilter("Payroll Period"))
                {
                }
                column(Employee__Global_Dimension_1_Code_; Employee."Global Dimension 1 Code")
                {
                }
                column(Employee__Global_Dimension_1_Code__Caption; Employee.FieldCaption("Global Dimension 1 Code"))
                {
                }
                column(Employee__Employee_Name_; Employee."Employee Name")
                {
                }
                column(Employee__Employee_No_; Employee."Employee No.")
                {
                }
                column(Employee__ED_Amount_; "ED Amount")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(Grade_Level; CopyStr(Employee."Salary Group", 1, 8))
                {
                }
                column(EmpCount; EmpCount)
                {
                }
                column(Employee_Payroll_Period; "Payroll Period")
                {
                }
                column(Employee_Name_Caption; Employee.FieldCaption("Employee Name"))
                {
                }
                column(Employee_No_Caption; Employee.FieldCaption("Employee No."))
                {
                }

                trigger OnAfterGetRecord()
                begin

                    CalcFields("ED Amount");
                    if ("ED Amount" = 0) then
                        CurrReport.Skip;
                    if ShowAmtBelow <> 0 then begin
                        if "ED Amount" > ShowAmtBelow then
                            CurrReport.Skip;
                    end;
                    EmpCount := EmpCount + 1;
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

                    case ReportOrder of
                        0:
                            SetCurrentkey("Global Dimension 1 Code", "Employee No.", "Employee Category");
                        1:
                            SetCurrentkey("Payroll Period", "Employee No.");
                    end; /*end case*/

                    // CurrReport.CreateTotals("ED Amount");

                end;
            }
            dataitem(ClosedPayslip; "Closed Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                DataItemTableView = sorting("Payroll Period", "Employee No.");
                column(ReportForNavId_24; 24)
                {
                }
                column(ClosedPayslip_AmountED; DelChr(GetFilter("ED Filter"), '<>') + '   in Period: ' + GetFilter("Payroll Period"))
                {
                }
                column(ClosedPayslip__Global_Dimension_1_Code_; ClosedPayslip."Global Dimension 1 Code")
                {
                }
                column(ClosedPayslip__Global_Dimension_1_Code__Caption; ClosedPayslip.FieldCaption("Global Dimension 1 Code"))
                {
                }
                column(ClosedPayslip__Employee_Name_; ClosedPayslip."Employee Name")
                {
                }
                column(ClosedPayslip__Employee_No_; ClosedPayslip."Employee No.")
                {
                }
                column(ClosedPayslip__ED_Amount_; "ED Amount")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(ClosedPayslip_Grade_Level; CopyStr(ClosedPayslip."Salary Group", 1, 8))
                {
                }
                column(ClosedPayslip_EmpCount; EmpCount)
                {
                }
                column(ClosedPayslip_Payroll_Period; "Payroll Period")
                {
                }
                column(ClosedPayslip_Name_Caption; ClosedPayslip.FieldCaption("Employee Name"))
                {
                }
                column(ClosedPayslip_Employee_No_Caption; ClosedPayslip.FieldCaption("Employee No."))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("ED Amount");
                    if ("ED Amount" = 0) then
                        CurrReport.Skip;
                    if ShowAmtBelow <> 0 then begin
                        if "ED Amount" > ShowAmtBelow then
                            CurrReport.Skip;
                    end;
                    EmpCount := EmpCount + 1;
                end;

                trigger OnPreDataItem()
                begin
                    if not (IsClosedPeriod) then
                        CurrReport.Break;

                    UserSetup.Get(UserId);
                    if not (UserSetup."Payroll Administrator") then begin
                        FilterGroup(2);
                        SetFilter("Employee Category", UserSetup."Personnel Level");
                        FilterGroup(0);
                    end else
                        SetRange("Employee Category");
                    ClosedPayslip.SetView(Employee.GetView);

                    case ReportOrder of
                        0:
                            SetCurrentkey("Global Dimension 1 Code", "Employee No.", "Employee Category");
                        1:
                            SetCurrentkey("Payroll Period", "Employee No.");
                    end; /*end case*/


                    //CurrReport.CreateTotals("ED Amount");

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
                field(HeadingText; HeadingText)
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Title';
                }
                field(ReportOrder; ReportOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Report Sorting Order';
                }
                field(ShowAmtBelow; ShowAmtBelow)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Only Amount Below';
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
        EmpCount := 0;
        if Employee.GetFilter(Employee."Payroll Period") = '' then
            Error(Text001)
        else
            if Employee.GetFilter("ED Filter") = '' then
                Error(Text002);

        StaffNo := Employee.GetFilter("Employee No.");
        PayrollPeriod.Get(Employee.GetFilter(Employee."Payroll Period"));
        IsClosedPeriod := PayrollPeriod.Closed;
    end;

    var
        CompanyData: Record "Company Information";
        UserSetup: Record "User Setup";
        PayrollPeriod: Record "Payroll-Period";
        HeadingText: Text[150];
        EmpCount: Integer;
        SerialNo: Integer;
        ReportOrder: Option Department,"Payroll No.";
        NewPagePerDept: Boolean;
        IsClosedPeriod: Boolean;
        ShowAmtBelow: Decimal;
        StaffNo: Text[150];
        Text001: label 'Payroll Period must be specified';
        Text002: label 'ED Filter must be specified';
}

