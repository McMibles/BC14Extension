Page 52092411 "Appraisal List- ESS"
{
    Caption = 'Performancee List-Employee';
    CardPageID = "Appraisal - ESS";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Appraisal Header";
    SourceTableView = where(Closed=const(false),
                            Location=const(Appraisee));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PerformancePeriod;"Appraisal Period")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Period';
                }
                field(PerformanceType;"Appraisal Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Type';
                }
                field(AppraiseeNo;"Appraisee No.")
                {
                    ApplicationArea = Basic;
                }
                field(FirstName;"First Name")
                {
                    ApplicationArea = Basic;
                }
                field(LastName;"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(PerformanceScore;"Performance Score")
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
        SetRange("Appraisee No.",UserSetup."Employee No.");
        FilterGroup(0);
    end;

    var
        UserSetup: Record "User Setup";
}

