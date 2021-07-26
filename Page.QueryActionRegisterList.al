Page 52092387 "Query Action Register List"
{
    CardPageID = "Query Action Register Card";
    Editable = false;
    PageType = List;
    SourceTable = "Employee Query Entry";
    SourceTableView = where(Status=const(Answered));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(QueryRefNo;"Query Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(DateofQuery;"Date of Query")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(QueriedBy;"Queried By Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Queried By';
                }
                field(CauseofQueryCode;"Cause of Query Code")
                {
                    ApplicationArea = Basic;
                }
                field(Offence;Offence)
                {
                    ApplicationArea = Basic;
                }
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Action";Action)
                {
                    ApplicationArea = Basic;
                }
                field(SuspensionDuration;"Suspension Duration")
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

