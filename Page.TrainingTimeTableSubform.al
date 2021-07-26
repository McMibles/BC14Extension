Page 52092428 "Training Time Table Subform"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Training Time Table";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DescriptionTitle;"Description/Title")
                {
                    ApplicationArea = Basic;
                }
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(BeginTime;"Begin Time")
                {
                    ApplicationArea = Basic;
                }
                field(EndTime;"End Time")
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

