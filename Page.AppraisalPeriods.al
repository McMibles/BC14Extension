Page 52092407 "Appraisal Periods"
{
    Caption = 'Performance Periods';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Appraisal Period";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PeriodCode;"Period Code")
                {
                    ApplicationArea = Basic;
                }
                field(PerformanceType;"Appraisal Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Type';
                }
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(PeriodDescription;"Period Description")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field(SearchName;"Search Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

