Report 52092167 "Recalculate Payroll Lines"
{
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Payslip Line"; "Payroll-Payslip Line")
        {
            RequestFilterFields = "Payroll Period", "Employee No.", "E/D Code", "Employee Category";
            RequestFilterHeading = 'Month End';
            column(ReportForNavId_4449; 4449)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Payroll Period");

                ProllPayslipHeader.Get("Payroll Period", "Employee No.");
                if ProllPayslipHeader.Closed then
                    CurrReport.Skip;

                ProllEmployee.Get("Employee No.");
                if FromDate <> 0D then
                    if ProllEmployee."Employment Date" < FromDate then CurrReport.Skip;

                if ToDate <> 0D then
                    if ProllEmployee."Employment Date" > ToDate then CurrReport.Skip;

                Window.Update(2, "Employee No.");
                Window.Update(3, "E/D Code");

                xAmount := Amount;

                case SetFlagOption of
                    1:
                        Validate(Flag, true);
                    2:
                        Validate(Flag, false);
                    3:
                        Validate(Flag, not Flag);
                    else
                        "Payroll-Payslip Line".ReCalculateAmount;
                end; /*end case*/
                "Payroll-Payslip Line".CalcAmountLCY;
                Modify;

                if (xAmount = Amount) then
                    CurrReport.Skip;

                CalcCompute("Payroll-Payslip Line", Amount, false, "E/D Code");
                CalcFactor1("Payroll-Payslip Line");
                ChangeOthers := false;
                ChangeAllOver("Payroll-Payslip Line", false);
                ResetChangeFlags("Payroll-Payslip Line");

            end;

            trigger OnPreDataItem()
            begin
                UserSetup.Get(UserId);
                if not (UserSetup."Payroll Administrator") then begin
                    FilterGroup(2);
                    SetFilter("Employee Category", UserSetup."Personnel Level");
                    FilterGroup(0);
                end;


                Window.Open('Current Period   #1#####\' +
                            'Current Employee  #2####\' +
                            'Current E/D       #3###\');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Window.Close;
        Message('FUNCTION COMPLETED!');
    end;

    var
        PayrollLine: Record "Payroll-Payslip Line";
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        EDFileRec: Record "Payroll-E/D";
        ProllEmployee: Record Employee;
        UserSetup: Record "User Setup";
        xAmount: Decimal;
        FromDate: Date;
        ToDate: Date;
        PayrollType: Option " ","First Half","Month End";
        SetFlagOption: Option " ",On,Off,Change;
        Window: Dialog;
}

