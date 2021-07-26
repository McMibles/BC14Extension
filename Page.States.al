Page 52092339 States
{
    PageType = List;
    SourceTable = State;
    SourceTableView = where("Record Type"=const(State));

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
            }
        }
    }

    actions
    {
    }
}

