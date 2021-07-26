Report 52092188 "Recalculate Emp Grp. Lines"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Employee Group Line";"Payroll-Employee Group Line")
        {
            RequestFilterFields = "Employee Group","E/D Code";
            RequestFilterHeading = 'Month End';
            column(ReportForNavId_4811; 4811)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"Employee Group");
                Window.Update(2,"E/D Code");
                
                xAmount := "Default Amount";
                
                "Payroll-Employee Group Line".RecalculateAmount;
                
                Modify;
                
                if (xAmount = "Default Amount") then
                  CurrReport.Skip;
                
                /* If this new entry contributes in computing another, then compute that value
                  for that computed entry and insert it appropriately*/
                  CalcCompute ("Payroll-Employee Group Line", "Default Amount", false);
                /*BDC*/
                
                  /* If this new entry is a contributory factor for the value of another line,
                    then compute that other line's value and insert it appropriately */
                  CalcFactor1 ("Payroll-Employee Group Line");
                
                  /* The two functions above have used this line to change others */
                  ChangeOthers := false;
                
                  /* Go through all the lines and change where necessary */
                  ChangeAllOver ("Payroll-Employee Group Line", false);
                
                  /* Reset the ChangeOthers flag in all lines */
                  ResetChangeFlags("Payroll-Employee Group Line");

            end;

            trigger OnPreDataItem()
            begin
                Window.Open ('Current Employee Grp.  #1##############\'+
                            'Current E/D       #2###\');
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
        xAmount: Decimal;
        FromDate: Date;
        ToDate: Date;
        PayrollType: Option " ","First Half","Month End";
        SetFlagOption: Option " ",On,Off,Change;
        Window: Dialog;
}

