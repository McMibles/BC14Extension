Page 52092340 "Local Govts"
{
    PageType = List;
    SourceTable = State;
    SourceTableView = where("Record Type"=const(LG));

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

