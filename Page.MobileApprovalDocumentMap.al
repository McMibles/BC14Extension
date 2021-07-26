Page 52092137 "Mobile Approval Document Map"
{
    PageType = List;
    SourceTable = "Mobile Approval Document Map";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PageID;"Page ID")
                {
                    ApplicationArea = Basic;
                }
                field(PageName;"Page Name")
                {
                    ApplicationArea = Basic;
                }
                field(ReportID;"Report ID")
                {
                    ApplicationArea = Basic;
                }
                field(ReportName;"Report Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control8;Outlook)
            {
            }
            systempart(Control9;Notes)
            {
            }
            systempart(Control10;MyNotes)
            {
            }
            systempart(Control11;Links)
            {
            }
        }
    }

    actions
    {
    }
}

