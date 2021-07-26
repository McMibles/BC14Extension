Page 52092149 "Payroll Periods List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Payroll-Period";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(PeriodCode;"Period Code")
                {
                    ApplicationArea = Basic;
                }
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }


    procedure GetSelectionFilter(): Code[80]
    var
        ProllPeriod: Record "Payroll-Period";
        FirstAcc: Text[20];
        LastAcc: Text[20];
        SelectionFilter: Code[80];
        ProllPeriodCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(ProllPeriod);
        ProllPeriod.SetCurrentkey(ProllPeriod."Period Code");
        ProllPeriodCount := ProllPeriod.Count;
        if ProllPeriodCount > 0 then begin
          ProllPeriod.Find('-');
          while ProllPeriodCount > 0 do begin
            ProllPeriodCount := ProllPeriodCount - 1;
            ProllPeriod.MarkedOnly(false);
            FirstAcc := ProllPeriod."Period Code";
            LastAcc := FirstAcc;
            More := (ProllPeriodCount > 0);
            while More do
              if ProllPeriod.Next = 0 then
                More := false
              else
                if not ProllPeriod.Mark then
                  More := false
                else begin
                  LastAcc := ProllPeriod."Period Code";
                  ProllPeriodCount := ProllPeriodCount - 1;
                  if ProllPeriodCount = 0 then
                    More := false;
                end;
            if SelectionFilter <> '' then
              SelectionFilter := SelectionFilter + '|';
            if FirstAcc = LastAcc then
              SelectionFilter := SelectionFilter + FirstAcc
            else
              SelectionFilter := SelectionFilter + FirstAcc + '..' + LastAcc;
            if ProllPeriodCount > 0 then begin
              ProllPeriod.MarkedOnly(true);
              ProllPeriod.Next;
            end;
          end;
        end;
        exit(SelectionFilter);
    end;
}

