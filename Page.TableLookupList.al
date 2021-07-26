Page 52092166 "Table Lookup-List"
{
    CardPageID = "Table Lookup";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll-Lookup Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(TableId; TableId)
                {
                    ApplicationArea = Basic;
                }
                field(Type; Type)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(SearchName; "Search Name")
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

