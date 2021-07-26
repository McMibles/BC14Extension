Page 52092436 "Training Evaluation-ESS"
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
                field(NoofNomination;"No. of Nomination")
                {
                    ApplicationArea = Basic;
                }
                field(HighlyRelevant;"Highly Relevant?")
                {
                    ApplicationArea = Basic;
                }
                field(ActualCost;"Actual Cost")
                {
                    ApplicationArea = Basic;
                }
                field(Comprehensiveness;Comprehensiveness)
                {
                    ApplicationArea = Basic;
                }
                field(AdequateTime;"Adequate Time")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000011;"Training Evaluation Subform-ES")
            {
                Caption = 'Training Evaluation Lines';
                SubPageLink = "Schedule Code"=field("Schedule Code"),
                              "Line No."=field("Line No.");
            }
            group(Facilitator)
            {
                Caption = 'Facilitator';
                field(FacilitatorCompetence;"Facilitator Competence")
                {
                    ApplicationArea = Basic;
                }
                field(DeliveryMode;"Delivery Mode")
                {
                    ApplicationArea = Basic;
                }
                field(LogicalFormat;"Logical Format")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000018;"Evaluation FactBox")
            {
                Caption = 'Facilitator Evaluation Scores';
                SubPageLink = "Schedule Code"=field("Schedule Code"),
                              "Line No."=field("Line No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000020>")
            {
                Caption = 'Functions';
                group(Process)
                {
                    Caption = 'Process';
                    action("<Action1000000021>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Evaluate';
                        Image = Evaluate;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        begin
                            TrainingMgt.ProcessTrainingEvaluation(Rec);
                            CurrPage.Update(false);
                        end;
                    }
                    action("<Action1000000023>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'FeedBack';
                        Image = "Action";
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        begin
                            TrainingMgt.ProcessTrainingFeedback(Rec);
                            CurrPage.Update(false);
                        end;
                    }
                }
            }
        }
    }

    var
        TrainingMgt: Codeunit TrainingManagement;
}

