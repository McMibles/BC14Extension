Page 52092432 "Training Attendance List"
{
    Editable = false;
    PageType = List;
    SourceTable = "Training Attendance";

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
                field(TrainingCode;"Training Code")
                {
                    ApplicationArea = Basic;
                }
                field(ReferenceNo;"Reference No.")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
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
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
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

