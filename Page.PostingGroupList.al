Page 52092172 "Posting Group List"
{
    CardPageID = "Posting Group";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll-Posting Group Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(PostingGroupCode;"Posting Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(SearchName;"Search Name")
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

