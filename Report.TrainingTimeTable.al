Report 52092357 "Training Time Table"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Training Time Table.rdlc';

    dataset
    {
        dataitem("Training Schedule Line";"Training Schedule Line")
        {
            DataItemTableView = sorting("Schedule Code","Line No.");
            RequestFilterFields = "Training Code","Start Date","Internal/External","Global Dimension 2 Code";
            column(ReportForNavId_9740; 9740)
            {
            }
            dataitem("Training Time Table";"Training Time Table")
            {
                DataItemLink = "Schedule Code"=field("Schedule Code"),"Line No."=field("Line No.");
                DataItemLinkReference = "Training Schedule Line";
                DataItemTableView = sorting("Schedule Code","Line No.","Entry No.");
                column(ReportForNavId_6383; 6383)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if TrainingFacility.Get(TrainingFacility.Type::Facilitator,Facilitator) then
                      FacilitatorName := TrainingFacility.Description;

                    if TrainingFacility.Get(TrainingFacility.Type::Venue,"Venue Code") then
                       venue := TrainingFacility.Description;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        TimeTableFilter := "Training Schedule Line".GetFilters;
    end;

    var
        TrainingFacility: Record "Training Facility";
        TimeTableFilter: Text[250];
        FacilitatorName: Text[40];
        venue: Text[40];
}

