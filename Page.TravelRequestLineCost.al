Page 52092461 "Travel Request Line Cost"
{
    PageType = ListPart;
    SourceTable = "Travel Cost";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CostCode;"Cost Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(InLieu;"In Lieu")
                {
                    ApplicationArea = Basic;
                }
                field(NoofNights;"No. of Nights")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(UnitAmount;"Unit Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(AmountLCY;"Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

