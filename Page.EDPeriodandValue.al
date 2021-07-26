Page 52092188 "ED Period and Value"
{
    PageType = Card;
    SourceTable = "ED Period and Value";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(EffectivePeriod;"Effective Period")
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

