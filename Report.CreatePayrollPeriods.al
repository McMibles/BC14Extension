Report 52092192 "Create Payroll Periods"
{
    Caption = 'Create Fiscal Year';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate;PayrollYearStartDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field(NoOfPeriods;NoOfPeriods)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Periods';
                    }
                    field(PeriodLength;PeriodLength)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Length';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if NoOfPeriods = 0 then begin
              NoOfPeriods := 12;
              Evaluate(PeriodLength,'<1M>');
            end;
            if PayrollPeriod.Find('+') then
              PayrollYearStartDate := PayrollPeriod."Start Date";
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PayrollPeriod."Start Date":= PayrollYearStartDate;
        PayrollPeriod.TestField("Start Date");
        
        if PayrollPeriod.Find('-') then begin
          FirstPeriodStartDate := PayrollPeriod."Start Date";
          FirstPeriodLocked := PayrollPeriod.Closed;
          if (PayrollYearStartDate < FirstPeriodStartDate) and FirstPeriodLocked then
            if not
               Confirm(
                 Text000 +
                 Text001)
            then
              exit;
          if PayrollPeriod.Find('+') then
            LastPeriodStartDate := PayrollPeriod."Start Date";
        end else
          if not
             Confirm(
               Text002 +
               Text003)
          then
            exit;
        
        PayrollYearStartDate2 := PayrollYearStartDate;
        
        for i := 1 to NoOfPeriods + 1 do begin
          if (PayrollYearStartDate <= FirstPeriodStartDate) and (i = NoOfPeriods + 1) then
            exit;
        
          if FirstPeriodStartDate <> 0D then
            if (PayrollYearStartDate >= FirstPeriodStartDate) and (PayrollYearStartDate < LastPeriodStartDate) then
              Error(Text004);
          PayrollPeriod.Init;
          PayrollPeriod."Period Code" := Format(Date2dmy(PayrollYearStartDate,3)) +'-'+ Format(PayrollYearStartDate,0,'<Month,2>');
          PayrollPeriod."Start Date" := PayrollYearStartDate;
          PayrollPeriod.Validate("Start Date");
          PayrollPeriod."End Date" := CalcDate('cm',PayrollYearStartDate);
          /*IF (i = 1) OR (i = NoOfPeriods + 1) THEN BEGIN
            AccountingPeriod."New Fiscal Year" := TRUE;
            InvtSetup.GET;
            AccountingPeriod."Average Cost Calc. Type" := InvtSetup."Average Cost Calc. Type";
            AccountingPeriod."Average Cost Period" := InvtSetup."Average Cost Period";
          END;*/
          /*IF (FirstPeriodStartDate = 0D) AND (i = 1) THEN
            AccountingPeriod."Date Locked" := TRUE;
          IF (AccountingPeriod."Starting Date" < FirstPeriodStartDate) AND FirstPeriodLocked THEN BEGIN
            AccountingPeriod.Closed := TRUE;
            AccountingPeriod."Date Locked" := TRUE;
          END;*/
          if not PayrollPeriod.Find('=') then
            PayrollPeriod.Insert;
          PayrollYearStartDate := CalcDate(PeriodLength,PayrollYearStartDate);
        end;

    end;

    var
        Text000: label 'The new payroll year begins before an existing Payroll year, so the new year will be closed automatically.\\';
        Text001: label 'Do you want to create and close the payroll year?';
        Text002: label 'Once you create the new payroll year you cannot change its starting date.\\';
        Text003: label 'Do you want to create the payrolll year?';
        Text004: label 'It is only possible to create new payroll years before or after the existing ones.';
        PayrollPeriod: Record "Payroll-Period";
        NoOfPeriods: Integer;
        PeriodLength: DateFormula;
        PayrollYearStartDate: Date;
        PayrollYearStartDate2: Date;
        FirstPeriodStartDate: Date;
        LastPeriodStartDate: Date;
        FirstPeriodLocked: Boolean;
        i: Integer;


    procedure InitializeRequest(NewNoOfPeriods: Integer;NewPeriodLength: DateFormula;StartingDate: Date)
    begin
        NoOfPeriods := NewNoOfPeriods;
        PeriodLength := NewPeriodLength;
        if PayrollPeriod.FindLast then
          PayrollYearStartDate := PayrollPeriod."Start Date"
        else
          PayrollYearStartDate := StartingDate;
    end;
}

