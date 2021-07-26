Report 52092173 "Copy E/D From Payroll Payroll"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Payslip;"Payroll-Payslip Line")
        {
            RequestFilterFields = "Payroll Period","Employee No.","E/D Code","Employee Category";
            column(ReportForNavId_4449; 4449)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"Payroll Period");
                Window.Update(2,"Employee No.");
                Window.Update(3,"E/D Code");
                
                // get previous e/d
                if not PayslipLine.Get(PreviousPeriod,"Employee No.","E/D Code") then
                  CurrReport.Skip;
                
                InitialAmount := Amount;
                
                Quantity := PayslipLine.Quantity;
                Flag := PayslipLine.Flag;
                Amount := PayslipLine.Amount;
                "Loan ID" := PayslipLine."Loan ID";
                Modify;
                
                if Amount <> InitialAmount then begin
                
                /* If this new entry contributes in computing another, then compute that value
                  for that computed entry and insert it appropriately*/
                  CalcCompute (Payslip, Amount, false, "E/D Code");
                /*BDC*/
                
                  /* If this new entry is a contributory factor for the value of another line,
                    then compute that other line's value and insert it appropriately */
                  CalcFactor1 (Payslip);
                
                  /* The two functions above have used this line to change others */
                  ChangeOthers := false;
                
                  /* Go through all the lines and change where necessary */
                  ChangeAllOver (Payslip, false);
                
                  /* Reset the ChangeOthers flag in all lines */
                  ResetChangeFlags(Payslip);
                end;

            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message('FUNCTION COMPLETED!');
            end;

            trigger OnPreDataItem()
            begin
                Window.Open ('Current Period   #1#####\' +
                            'Current Employee  #2####\'+
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

    trigger OnPreReport()
    begin
        if not PayrollPeriod.Get(Payslip.GetFilter(Payslip."Payroll Period")) then
          Error('Payroll Period Filter must be specified!');

        if PreviousPeriod = '' then begin
          PayrollPeriod.SetRange(PayrollPeriod."Employee Category",PayrollPeriod."Employee Category");
          if PayrollPeriod.Next(-1) = 0 then
            Error('Previous period does not exist!');
          PreviousPeriod := PayrollPeriod."Period Code";
        end else
          PayrollPeriod.Get(PreviousPeriod);
    end;

    var
        PayrollPeriod: Record "Payroll-Period";
        PayslipLine: Record "Payroll-Payslip Line";
        PreviousPeriod: Code[10];
        InitialAmount: Decimal;
        Window: Dialog;
}

