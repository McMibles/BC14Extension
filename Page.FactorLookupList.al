Page 52092175 "Factor Lookup List"
{
    CardPageID = "Factor Lookup";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll-Factor Lookup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(TableId;"Table Id")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(MaxExtractAmount;"Max. Extract Amount")
                {
                    ApplicationArea = Basic;
                }
                field(MinExtractAmount;"Min. Extract Amount")
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

