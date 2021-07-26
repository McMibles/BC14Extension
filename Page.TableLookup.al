Page 52092165 "Table Lookup"
{
    PageType = Card;
    SourceTable = "Payroll-Lookup Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TableId;TableId)
                {
                    ApplicationArea = Basic;
                    Lookup = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(SearchName;"Search Name")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000000;"Table Lookup Subform")
            {
                SubPageLink = TableId=field(TableId);
            }
            group(Details)
            {
                Caption = 'Details';
                field(MaxExtractAmount;"Max. Extract Amount")
                {
                    ApplicationArea = Basic;
                }
                field(MinExtractAmount;"Min. Extract Amount")
                {
                    ApplicationArea = Basic;
                }
                field(InputFactor;"Input Factor")
                {
                    ApplicationArea = Basic;
                }
                field(OutputFactor;"Output Factor")
                {
                    ApplicationArea = Basic;
                }
                field(RoundingPrecision;"Rounding Precision")
                {
                    ApplicationArea = Basic;
                }
                field(RoundingDirection;"Rounding Direction")
                {
                    ApplicationArea = Basic;
                }
                field(MaxExtractPercentage;"Max. Extract Percentage")
                {
                    ApplicationArea = Basic;
                    Caption = 'Min. Extract Amount';
                }
                field(MinExtractPercentage;"Min. Extract Percentage")
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

