Codeunit 52092136 "Period to Text"
{

    trigger OnRun()
    begin
    end;

    var
        nTotalDays: Decimal;
        nTotalMonth: Integer;
        nYear: Integer;
        nMonth: Integer;
        nDays: Integer;


    procedure GetPeriodText(FromDate: Date;ToDate: Date) PeriodText: Text[50]
    begin

        nTotalDays :=  ROUND(((Date2dmy(ToDate,3) - Date2dmy(FromDate,3)) * 365 +
                     (Date2dmy(ToDate,2) - Date2dmy(FromDate,2))* 30.41 +
                     (Date2dmy(ToDate,1) - Date2dmy(FromDate,1))),0.00001);
        nTotalMonth :=  nTotalDays DIV 30.42;
        nYear :=  nTotalMonth DIV 12;
        nMonth := nTotalMonth MOD 12;
        nDays := ROUND(nTotalDays MOD 30.42,1,'<');
        if nYear <> 0 then
          PeriodText := Format(nYear)+'Year(s)';
        if nMonth <> 0 then begin
          if PeriodText  <> '' then
            PeriodText  := PeriodText  +','+Format(nMonth) +'Month(s)'
          else
            PeriodText  :=  Format(nMonth) +'Month(s)';
        end;
        if nDays <> 0 then begin
          if PeriodText  <> '' then
            PeriodText  := PeriodText  +','+Format(nDays) +'Day(s)'
          else
            PeriodText  :=  Format(nDays) +'Day(s)';
        end;
        exit(PeriodText);
    end;
}

