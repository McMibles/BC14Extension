Page 52092341 "Public Holidays"
{
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Public Holiday";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(Duration;Duration)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        FilterOnDate
    end;

    var
        Year: Integer;
        FromDate: Date;
        ToDate: Date;


    procedure FilterOnDate()
    begin
        if Year <> 0 then begin
          FromDate := Dmy2date(1,1,Year);
          ToDate := Dmy2date(31,12,Year);
          SetRange(Date,FromDate, ToDate);
        end else
          SetRange(Date);

        CurrPage.Update(false);
    end;
}

