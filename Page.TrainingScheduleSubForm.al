Page 52092423 "Training Schedule SubForm"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Training Schedule Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(Duration;Duration)
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
                field(VenueCode;"Venue Code")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(Facilitator;Facilitator)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(EquipmentCode;"Equipment Code")
                {
                    ApplicationArea = Basic;
                }
                field(InternalExternal;"Internal/External")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ExpectedNoofParticipant;"Expected No. of Participant")
                {
                    ApplicationArea = Basic;
                }
                field(EstimatedCost;"Estimated Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000018>")
            {
                Caption = 'Functions';
                action(Nominations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nominations';

                    trigger OnAction()
                    begin
                        TrainingSchHeader.Get("Schedule Code");
                        TrainingSchHeader.TestField(Status,TrainingSchHeader.Status::"Pending Approval");
                        TrainingSchLine.SetRange(TrainingSchLine."Schedule Code","Schedule Code");
                        TrainingSchLine.SetRange(TrainingSchLine."Line No.","Line No.");
                        TrainingNominationPage.SetTableview(TrainingSchLine);
                        TrainingNominationPage.SetRecord(Rec);
                        TrainingNominationPage.RunModal;
                        Clear(TrainingNominationPage);
                    end;
                }
                action(TimeTable)
                {
                    ApplicationArea = Basic;
                    Caption = 'Time Table';

                    trigger OnAction()
                    begin
                        TrainingSchLine.SetRange(TrainingSchLine."Schedule Code","Schedule Code");
                        TrainingSchLine.SetRange(TrainingSchLine."Line No.","Line No.");
                        TrainingTimeTablePage.SetTableview(TrainingSchLine);
                        TrainingTimeTablePage.SetRecord(Rec);
                        TrainingTimeTablePage.RunModal;
                        Clear(TrainingTimeTablePage);
                    end;
                }
            }
        }
    }

    var
        TrainingSchLine: Record "Training Schedule Line";
        TrainingSchHeader: Record "Training Schedule Header";
        TrainingNominationPage: Page "Training Nominations";
        TrainingTimeTablePage: Page "Training Time Table";
}

