Page 52092197 Banks
{
    PageType = List;
    SourceTable = Bank;

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
                field(SearchName;"Search Name")
                {
                    ApplicationArea = Basic;
                }
                field(SortCode;"Sort Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control8;Links)
            {
                Visible = false;
            }
            systempart(Control7;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

