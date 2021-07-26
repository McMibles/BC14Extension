Page 52092816 "Delivery Tolerances"
{
    PageType = List;
    SourceTable = "Delivery Tolerance";

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
                field(OverdeliveryTolerance;"Overdelivery Tolerance %")
                {
                    ApplicationArea = Basic;
                }
                field(OverdeliveryRelationalQty;"Overdelivery Relational Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(UnderdeliveryTolerance;"Underdelivery Tolerance %")
                {
                    ApplicationArea = Basic;
                }
                field(UnderdeliveryRelationalQty;"Underdelivery Relational Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(ChangeQuantity;"Change Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(CalculateNewPrice;"Calculate New Price")
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

