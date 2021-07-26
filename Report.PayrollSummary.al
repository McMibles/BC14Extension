Report 52092200 "Payroll Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Summary.rdlc';

    dataset
    {
        dataitem("Payroll Statistical Group";"Payroll Statistical Group")
        {
            DataItemTableView = sorting(Code);
            column(ReportForNavId_5902; 5902)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if StatisticalGrpCounter < ArrayLen(StatisticalGrp) then begin
                  StatisticalGrpCounter := StatisticalGrpCounter + 1;
                  StatisticalGrp[StatisticalGrpCounter] :=  "Payroll Statistical Group".Code;
                end;
            end;
        }
        dataitem(EmployeeCategory;"Employee Category")
        {
            column(ReportForNavId_1000000003; 1000000003)
            {
            }
            column(Payroll_Employee_Category;Code)
            {
            }
            column(Employee_Category_Desc;Description)
            {
            }
            column(No_of_Employees;GetNoOfEmployees(EmployeeCategory.Code,ReqPeriods."Period Code"))
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = where(Number=const(1));
                column(ReportForNavId_1575; 1575)
                {
                }
                column(CompanyData_Name;COMPANYNAME)
                {
                }
                column(ColumnName_StatisticalGrp_1;GetColumnName(StatisticalGrp[1]))
                {
                }
                column(ColumnName_StatisticalGrp_2;GetColumnName(StatisticalGrp[2]))
                {
                }
                column(ColumnName_StatisticalGrp_3;GetColumnName(StatisticalGrp[3]))
                {
                }
                column(ColumnName_StatisticalGrp_4;GetColumnName(StatisticalGrp[4]))
                {
                }
                column(ColumnName_StatisticalGrp_5;GetColumnName(StatisticalGrp[5]))
                {
                }
                column(ColumnName_StatisticalGrp_6;GetColumnName(StatisticalGrp[6]))
                {
                }
                column(ColumnName_StatisticalGrp_7;GetColumnName(StatisticalGrp[7]))
                {
                }
                column(ColumnName_StatisticalGrp_8;GetColumnName(StatisticalGrp[8]))
                {
                }
                column(ColumnName_StatisticalGrp_9;GetColumnName(StatisticalGrp[9]))
                {
                }
                column(ColumnName_StatisticalGrp_10;GetColumnName(StatisticalGrp[10]))
                {
                }
                column(ColumnName_StatisticalGrp_11;GetColumnName(StatisticalGrp[11]))
                {
                }
                column(ColumnName_StatisticalGrp_12;GetColumnName(StatisticalGrp[12]))
                {
                }
                column(CurrentPeriod_Amount1;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[1]))
                {
                }
                column(CurrentPeriod_Amount2;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[2]))
                {
                }
                column(CurrentPeriod_Amount3;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[3]))
                {
                }
                column(CurrentPeriod_Amount4;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[4]))
                {
                }
                column(CurrentPeriod_Amount5;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[5]))
                {
                }
                column(CurrentPeriod_Amount6;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[6]))
                {
                }
                column(CurrentPeriod_Amount7;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[7]))
                {
                }
                column(CurrentPeriod_Amount8;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[8]))
                {
                }
                column(CurrentPeriod_Amount9;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[9]))
                {
                }
                column(CurrentPeriod_Amount10;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[10]))
                {
                }
                column(CurrentPeriod_Amount11;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[11]))
                {
                }
                column(CurrentPeriod_Amount12;GetAmount(EmployeeCategory.Code,ReqPeriods."Period Code",StatisticalGrp[12]))
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PAYROLLPERIOD;ReqPeriods."Period Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'PAYROLL PERIOD';
                    TableRelation = "Payroll-Period";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Report_Title = 'Payroll Summary';
    }

    var
        StatisticalGrp: array [12] of Code[10];
        NetPayStatsGrpCode: Code[10];
        NetPayStatsGrpNo: Integer;
        StatisticalGrpCounter: Integer;
        CompanyData: Record "Company Information";
        ReqPeriods: Record "Payroll-Period";
        PaySlip: Record "Payroll-Payslip Header";
        ClosedPayslip: Record "Closed Payroll-Payslip Header";
        PayrollSetup: Record "Payroll-Setup";
        UserSetup: Record "User Setup";
        PayrollPeriod: Record "Payroll-Period";
        IsClosedPeriod: Boolean;
        DimMgt: Codeunit "Format No. to Text";
        Text001: label 'Period Filter must be specified.';


    procedure GetAmount(EmployeeCategoryFilter: Code[20];PeriodCode: Code[20];GroupFilter: Code[10]): Decimal
    begin
        PayrollPeriod.Get(PeriodCode);
        PayrollPeriod.SetRange("Statistics Group Filter",GroupFilter);
        PayrollPeriod.SetRange("Employee Category Filter",EmployeeCategoryFilter);
        PayrollPeriod.CalcFields("ED Amount","ED Closed Amount");
        if not(PayrollPeriod.Closed) then
          exit(PayrollPeriod."ED Amount")
        else
          exit(PayrollPeriod."ED Closed Amount");
    end;

    local procedure GetNoOfEmployees(EmployeeCategoryFilter: Code[20];PeriodCode: Code[20]): Integer
    begin
        PayrollPeriod.Get(PeriodCode);
        PayrollPeriod.SetRange("Employee Category Filter",EmployeeCategoryFilter);
        PayrollPeriod.CalcFields("No. of Entries","No. of Entries Closed");
        if not(PayrollPeriod.Closed) then
          exit(PayrollPeriod."No. of Entries")
        else
          exit(PayrollPeriod."No. of Entries Closed");
    end;


    procedure GetColumnName(ColumnCode: Code[10]): Code[30]
    var
        PayrollStatsGrp: Record "Payroll Statistical Group";
    begin
        if ColumnCode <> '' then begin
          PayrollStatsGrp.Get(ColumnCode);
          exit(PayrollStatsGrp.Description);
        end else
          exit('')
    end;
}

