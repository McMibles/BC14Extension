Page 52092379 "Interview Result SubForm"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Interview Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ApplicantNo;"Applicant No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Performance;Performance)
                {
                    ApplicationArea = Basic;
                }
                field(Score;"Score %")
                {
                    ApplicationArea = Basic;
                }
                field(Selection;Selection)
                {
                    ApplicationArea = Basic;
                }
                field(ReasonforSelection;"Reason for Selection")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(Response;Response)
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(ReasonforResponse;"Reason for Response")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(ExpressedDateofResumption;"Expressed Date of Resumption")
                {
                    ApplicationArea = Basic;
                }
                field(Show;Show)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show On Appointment';
                    Visible = true;

                    trigger OnValidate()
                    begin
                        Applicant.Get("Applicant No.");
                        if Applicant."Closed?" then
                          Error(Text001)
                        else if Applicant.Status <> Applicant.Status::Hired then
                          Error(Text002)
                        else begin
                          Applicant.Show := Show;
                          Applicant.Modify;
                        end;
                        CurrPage.Update;
                    end;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(GradeLevelCode;"Grade Level Code")
                {
                    ApplicationArea = Basic;
                }
                field(ProbationPeriod;"Probation Period")
                {
                    ApplicationArea = Basic;
                }
                field(SalaryGroup;"Salary Group")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
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

    trigger OnAfterGetRecord()
    begin
        Applicant.SetRange("No.","Applicant No.");
        if Applicant.Find('-') then
          Show := Applicant.Show
        else
          Show := false;
    end;

    var
        Applicant: Record Applicant;
        Show: Boolean;
        Text001: label 'Applicant appointment  already processed';
        Text002: label 'Applicant not Hired';
}

