Report 52092347 "Applicant List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Applicant List.rdlc';

    dataset
    {
        dataitem(Applicant; Applicant)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", City;
            trigger OnAfterGetRecord()
            begin
                if StaffRequisition.Get(Applicant."Position Desired") then
                    PositionDesired := StaffRequisition.Description;
            end;
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
        ApplicantFilter := Applicant.GetFilters;
    end;

    var
        StaffRequisition: Record "Employee Requisition";
        PositionDesired: Text[40];
        ApplicantFilter: Text[120];
}

