Page 52092395 "Employee Queries"
{
    CardPageID = "Query Register Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Employee Query Entry";

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

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        SetRange("Queried By",UserSetup."Employee No.");
        FilterGroup(0);
    end;

    var
        UserSetup: Record "User Setup";
}

