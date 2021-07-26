Report 52092191 "Payroll Monthly Variance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Monthly Variance.rdlc';

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
                  if "Payroll Statistical Group".Code = PayrollSetup."Net Pay Statistical Group Code" then
                    NetPayStatsGrpNo := StatisticalGrpCounter;
                end;
            end;

            trigger OnPreDataItem()
            begin
                PayrollSetup.Get;
                PayrollSetup.TestField("Net Pay Statistical Group Code");
            end;
        }
        dataitem("Payroll-Payslip Header";"Payroll-Payslip Header")
        {
            DataItemTableView = sorting("Global Dimension 1 Code","Employee No.","Employee Category");
            RequestFilterFields = "Global Dimension 1 Code","Employee No.","Employee Category";
            column(ReportForNavId_1575; 1575)
            {
            }
            column(CompanyData_Name;CompanyData.Name)
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
            column(Payroll_Employee__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(DimMgt_ReturnDimName_1__Payroll_Employee___Global_Dimension_1_Code__;DimMgt.ReturnDimName(1,"Global Dimension 1 Code"))
            {
            }
            column(Payroll_Employee_No__;"Payroll-Payslip Header"."Employee No.")
            {
            }
            column(Payroll_Employee_Name_;"Payroll-Payslip Header"."Employee Name")
            {
            }
            column(CurrentPeriod_Amount1;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[1]))
            {
            }
            column(CurrentPeriod_Amount2;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[2]))
            {
            }
            column(CurrentPeriod_Amount3;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[3]))
            {
            }
            column(CurrentPeriod_Amount4;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[4]))
            {
            }
            column(CurrentPeriod_Amount5;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[5]))
            {
            }
            column(CurrentPeriod_Amount6;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[6]))
            {
            }
            column(CurrentPeriod_Amount7;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[7]))
            {
            }
            column(CurrentPeriod_Amount8;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[8]))
            {
            }
            column(CurrentPeriod_Amount9;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[9]))
            {
            }
            column(CurrentPeriod_Amount10;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[10]))
            {
            }
            column(CurrentPeriod_Amount11;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[11]))
            {
            }
            column(CurrentPeriod_Amount12;GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[12]))
            {
            }
            column(ReqPeriodsArray_1___Period_Code_;ReqPeriodsArray[1]."Period Code")
            {
            }
            column(ReqPeriodsArray_2___Period_Code_;ReqPeriodsArray[2]."Period Code")
            {
            }
            column(PreviousPeriod_Amount12;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[12]))
            {
            }
            column(PreviousPeriod_Amount11;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[11]))
            {
            }
            column(PreviousPeriod_Amount10;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[10]))
            {
            }
            column(PreviousPeriod_Amount9;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[9]))
            {
            }
            column(PreviousPeriod_Amount8;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[8]))
            {
            }
            column(PreviousPeriod_Amount7;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[7]))
            {
            }
            column(PreviousPeriod_Amount6;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[6]))
            {
            }
            column(PreviousPeriod_Amount5;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[5]))
            {
            }
            column(PreviousPeriod_Amount4;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[4]))
            {
            }
            column(PreviousPeriod_Amount3;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[3]))
            {
            }
            column(PreviousPeriod_Amount2;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[2]))
            {
            }
            column(PreviousPeriod_Amount1;GetPreviousAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[1]))
            {
            }
            column(VarianceAmount;GetDiff(GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[NetPayStatsGrpNo]),GetAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[NetPayStatsGrpNo])))
            {
            }
            column(VariancePercent;GetDiffPercent(GetAmount("Employee No.",ReqPeriodsArray[1]."Period Code",StatisticalGrp[NetPayStatsGrpNo]),GetAmount("Employee No.",ReqPeriodsArray[2]."Period Code",StatisticalGrp[NetPayStatsGrpNo])))
            {
            }
            column(Payroll_Employee__Global_Dimension_1_Code_Caption;FieldCaption("Global Dimension 1 Code"))
            {
            }

            trigger OnPreDataItem()
            begin
                UserSetup.Get(UserId);
                if not(UserSetup."Payroll Administrator") then begin
                  FilterGroup(2);
                  SetFilter("Employee Category",UserSetup."Personnel Level");
                  FilterGroup(0);
                end
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CURRENTPERIOD;ReqPeriodsArray[1]."Period Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'CURRENT PERIOD';
                    TableRelation = "Payroll-Period";

                    trigger OnValidate()
                    begin
                        if ReqPeriodsArray[1]."Period Code" = '' then
                          exit;

                        PayPeriodRec.Reset;
                        PayPeriodRec.SetFilter(PayPeriodRec."Period Code",'<%1',ReqPeriodsArray[1]."Period Code");
                        PayPeriodRec.Find('+');
                        ReqPeriodsArray[2]."Period Code" := PayPeriodRec."Period Code";
                    end;
                }
                field(PREVIOUSPERIOD;ReqPeriodsArray[2]."Period Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'PREVIOUS PERIOD';
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
        Report_Title = 'Payroll Monthly Variance Report';
    }

    trigger OnPreReport()
    begin
        CompanyData.Get;
    end;

    var
        StatisticalGrp: array [12] of Code[10];
        NetPayStatsGrpCode: Code[10];
        NetPayStatsGrpNo: Integer;
        StatisticalGrpCounter: Integer;
        CompanyData: Record "Company Information";
        ReqPeriodsArray: array [6] of Record "Payroll-Period";
        PayPeriodRec: Record "Payroll-Period";
        PaySlip: Record "Payroll-Payslip Header";
        ClosedPayslip: Record "Closed Payroll-Payslip Header";
        PayrollSetup: Record "Payroll-Setup";
        UserSetup: Record "User Setup";
        DimMgt: Codeunit "Dimension Hook";
        Text001: label 'Net Pay Statistical Group Code must be specified.';
        Report_print_date_CaptionLbl: label 'Report print date:';
        PAYROLL_MONTHLY_VARIANCE_REPORTCaptionLbl: label 'PAYROLL MONTHLY VARIANCE REPORT';


    procedure GetAmount(EmployeeNo: Code[20];PeriodCode: Code[20];GroupFilter: Code[10]): Decimal
    begin
        if (PaySlip.Get(PeriodCode,EmployeeNo)) and (GroupFilter <> '') then begin
          PaySlip.SetRange("Statistical Group Filter",GroupFilter);
          PaySlip.CalcFields("Misc. Amount");
          exit(PaySlip."Misc. Amount");
        end else
          exit(0);
    end;


    procedure GetPreviousAmount(EmployeeNo: Code[20];PeriodCode: Code[20];GroupFilter: Code[10]): Decimal
    begin
        if (ClosedPayslip.Get(PeriodCode,EmployeeNo)) and (GroupFilter <> '') then begin
          ClosedPayslip.SetRange("Statistical Group Filter",GroupFilter);
          ClosedPayslip.CalcFields("Misc. Amount");
          exit(ClosedPayslip."Misc. Amount");
        end else
          exit(0);
    end;


    procedure GetDiff(Current: Decimal;Previous: Decimal) Diff: Decimal
    begin
        Diff := Current - Previous;
        exit(ROUND(Diff));
    end;


    procedure GetDiffPercent(Current: Decimal;Previous: Decimal): Decimal
    begin
        if  Current = 0 then
          exit(0);
        exit(ROUND(((Current - Previous)/Current)*100));
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

