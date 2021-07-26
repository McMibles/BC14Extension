Page 52092381 "Appointment List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = Applicant;
    SourceTableView = sorting("Position Desired")
                      where("Closed?" = const(false),
                            Status = const(Hired),
                            Show = const(true));

    layout
    {
        area(content)
        {
            field("Vacancy Code"; VacancyCode)
            {
                ApplicationArea = Basic;
                TableRelation = "Employee Requisition"."No." where("Employment Status" = filter("Accepted Offer"));

                trigger OnValidate()
                begin
                    FilterOnVacancyCode
                end;
            }
            repeater(Group)
            {
                field(VacancyCode; "Empl. Job Ref. No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vacancy Code';
                }
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }
                field(FirstName; "First Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(MiddleName; "Middle Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(LastName; "Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Designation; "Job Applied For")
                {
                    ApplicationArea = Basic;
                    Caption = 'Designation';
                    Editable = false;
                }
                field(FinalInterviewRefNo; "Final Interview Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(ManagerNo; "Manager No.")
                {
                    ApplicationArea = Basic;
                }
                field(DateAssumed; "Date Assumed")
                {
                    ApplicationArea = Basic;
                }
                field(ProbationPeriod; "Probation Period")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GradeLevelCode; "Grade Level Code")
                {
                    ApplicationArea = Basic;
                }
                field(ConfirmedYN; "Confirmed (Y/N)")
                {
                    ApplicationArea = Basic;
                }
                field(Closed; "Closed?")
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
            group(Functions)
            {
                Caption = 'Functions';
                action(Apply)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply';
                    Image = Apply;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Applicant.CopyFilters(Rec);
                        RecruitmentMgt.ApplyAppointment(Applicant);
                        CurrPage.Update;
                    end;
                }
                action("<Action1000000009>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment Letter';
                    Image = Print;
                    Visible = false;

                    trigger OnAction()
                    begin
                        Applicant.CopyFilters(Rec);
                        // EmploymentLetter.SetTableview(Applicant);
                        // EmploymentLetter.Run;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        FilterOnVacancyCode
    end;

    var
        Applicant: Record Applicant;
        Employee: Record Employee;
        RecruitmentMgt: Codeunit RecruitmentManagement;
        //EmploymentLetter: Report "Employment Letter";
        VacancyCode: Code[20];


    procedure FilterOnVacancyCode()
    begin
        if VacancyCode <> '' then
            SetRange("Empl. Job Ref. No.", VacancyCode)
        else
            SetRange("Empl. Job Ref. No.");
        CurrPage.Update(false);
    end;
}

