Page 52092353 "Leave Schedule List -ESS"
{
    CardPageID = "Leave Schedule Header -ESS";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Leave Schedule Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(YearNo;"Year No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
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
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
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
        HRSetup.Get;
        FilterGroup(2);
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        SetRange("Employee No.",UserSetup."Employee No.");
        SetRange("Absence Code",HRSetup."Annual Leave Code");
        FilterGroup(0);
    end;

    var
        UserSetup: Record "User Setup";
        HRSetup: Record "Human Resources Setup";
}

