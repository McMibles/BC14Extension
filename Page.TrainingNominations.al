Page 52092425 "Training Nominations"
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
                field(ScheduleCode; "Schedule Code")
                {
                    ApplicationArea = Basic;
                }
                field(ReferenceNo; "Reference No.")
                {
                    ApplicationArea = Basic;
                }
                field(TrainingCode; "Training Code")
                {
                    ApplicationArea = Basic;
                }
                field(DescriptionTitle; "Description/Title")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Type)
                {
                    ApplicationArea = Basic;
                }
                field(VenueCode; "Venue Code")
                {
                    ApplicationArea = Basic;
                }
                field(Facilitator; Facilitator)
                {
                    ApplicationArea = Basic;
                }
                field(ExpectedNoofParticipant; "Expected No. of Participant")
                {
                    ApplicationArea = Basic;
                }
                field(NoofNomination; "No. of Nomination")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000011; "Training Nomination Subform")
            {
                SubPageLink = "Schedule Code" = field("Schedule Code"),
                              "Line No." = field("Line No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(SuggestLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest Lines';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        TrainingScheduleLine.Copy(Rec);
                        TrainingScheduleLine.SetRecfilter;
                        SuggestNomination.SetTableview(TrainingScheduleLine);
                        SuggestNomination.RunModal;
                        Clear(SuggestNomination);
                        CurrPage.Update(false);
                    end;
                }
                action("<Action1000000015>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Invitation Letter';
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        TrainingScheduleLine.SetRange(TrainingScheduleLine."Schedule Code",
                                                      "Schedule Code");
                        TrainingScheduleLine.SetRange(TrainingScheduleLine."Line No.", "Line No.");
                        // TrainingInivation.SetTableview(TrainingScheduleLine);
                        // TrainingInivation.Run;
                    end;
                }
            }
        }
    }

    var
        TrainingScheduleLine: Record "Training Schedule Line";
        SuggestNomination: Report "Suggest Training Nominations";
    //TrainingInivation: Report "Invitation for Training";
}

