Page 52092409 "HR Appraisal List"
{
    Caption = 'Appraisal List';
    CardPageID = "Appraisal - HR";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Appraisal Header";
    SourceTableView = where("Appraisal Ready"=const(true),
                            "Recommendation Applied?"=const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AppraisalPeriod;"Appraisal Period")
                {
                    ApplicationArea = Basic;
                }
                field(AppraisalType;"Appraisal Type")
                {
                    ApplicationArea = Basic;
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
}

