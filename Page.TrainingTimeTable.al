Page 52092427 "Training Time Table"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Training Schedule Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
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
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(VenueCode;"Venue Code")
                {
                    ApplicationArea = Basic;
                }
                field(Facilitator;Facilitator)
                {
                    ApplicationArea = Basic;
                }
                field(ExpectedNoofParticipant;"Expected No. of Participant")
                {
                    ApplicationArea = Basic;
                }
                field(NoofNomination;"No. of Nomination")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000011;"Training Time Table Subform")
            {
                SubPageLink = "Schedule Code"=field("Schedule Code"),
                              "Line No."=field("Line No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000013>")
            {
                Caption = 'Functions';
                action("<Action1000000014>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Time-Table';

                    trigger OnAction()
                    var
                        TrainingTimeTable: Report "Training Time Table";
                        TrainingScheduleLine: Record "Training Schedule Line";
                    begin
                        TrainingScheduleLine.SetRange(TrainingScheduleLine."Schedule Code",
                                                      "Schedule Code");
                        TrainingScheduleLine.SetRange(TrainingScheduleLine."Line No.","Line No.");
                        TrainingTimeTable.SetTableview(TrainingScheduleLine);
                        TrainingTimeTable.Run;
                    end;
                }
            }
        }
    }
}

