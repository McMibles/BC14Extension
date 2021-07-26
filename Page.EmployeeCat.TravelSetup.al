Page 52092462 "Employee Cat. Travel Setup"
{
    PageType = List;
    SourceTable = "Employee Travel Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TravelType;"Travel Type")
                {
                    ApplicationArea = Basic;
                }
                field(TravelGroup;"Travel Group")
                {
                    ApplicationArea = Basic;
                }
                field(TravelCostCode;"Travel Cost Code")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode;"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
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

