Page 52092187 "ED Conditions"
{
    PageType = Card;
    SourceTable = "ED Condition";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Value;Value)
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

