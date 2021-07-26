Page 52092173 "Factor Lookup"
{
    PageType = Card;
    SourceTable = "Payroll-Factor Lookup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(TableId;"Table Id")
                {
                    ApplicationArea = Basic;
                    Lookup = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(SearchName;"Search Name")
                {
                    ApplicationArea = Basic;
                }
                field(CalculationType;"Calculation Type")
                {
                    ApplicationArea = Basic;
                }
                field(ComparismDirection;"Comparism Direction")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000000;"Factor Lookup Subform")
            {
                SubPageLink = "Table Id"=field("Table Id");
            }
            group(Details)
            {
                Caption = 'Details';
                field(InputFactor;"Input Factor")
                {
                    ApplicationArea = Basic;
                }
                field(MaxExtractAmount;"Max. Extract Amount")
                {
                    ApplicationArea = Basic;
                }
                field(RoundingPrecision;"Rounding Precision")
                {
                    ApplicationArea = Basic;
                }
                field(OutputFactor;"Output Factor")
                {
                    ApplicationArea = Basic;
                }
                field(MinExtractAmount;"Min. Extract Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Min. Extract Amount';
                }
                field(RoundingDirection;"Rounding Direction")
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

