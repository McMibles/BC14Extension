Page 52092430 "Training Evaluation Subform"
{
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Training Attendance";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Attendance;"Attendance (%)")
                {
                    ApplicationArea = Basic;
                }
                field(ParticipationLevel;"Participation Level")
                {
                    ApplicationArea = Basic;
                }
                field(AssessmentScore;"Assessment Score (%)")
                {
                    ApplicationArea = Basic;
                }
                field(Relevance;Relevance)
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
                field(TransferSkills;"Transfer Skills")
                {
                    ApplicationArea = Basic;
                }
                field(Recommendation;Recommendation)
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

