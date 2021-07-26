Page 52092438 "Evaluations-ESS"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Training Schedule Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ScheduleCode;"Schedule Code")
                {
                    ApplicationArea = Basic;
                }
                field(ReferenceNo;"Reference No.")
                {
                    ApplicationArea = Basic;
                }
                field(TrainingCode;"Training Code")
                {
                    ApplicationArea = Basic;
                }
                field(DescriptionTitle;"Description/Title")
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
        area(creation)
        {
            action(Evaluation)
            {
                ApplicationArea = Basic;
                Caption = 'Evaluation';
                Image = Evaluate;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Training Evaluation-ESS";
                RunPageLink = "Schedule Code"=field("Schedule Code"),
                              "Line No."=field("Line No.");
            }
        }
    }
}

