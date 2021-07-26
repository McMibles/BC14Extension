Page 52092447 "Employee Query Register"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Employee Query Entry";
    SourceTableView = where(Status=const(Closed));

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
                field(Offence;Offence)
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(QueriedBy;"Queried By Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Queried By';
                }
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                }
                field("Action";Action)
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

