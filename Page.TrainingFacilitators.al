Page 52092421 "Training Facilitators"
{
    PageType = List;
    SourceTable = "Training Facility";
    SourceTableView = where(Type=const(Facilitator));

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
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field(Address2;"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                }
                field(PhoneNo;"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(InHouseExternal;"In-House/External")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(CostingMethod;"Costing Method")
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

