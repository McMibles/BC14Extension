Page 52092194 "Pension Administrator List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Pension Administrator";

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
                field(Name;Name)
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

