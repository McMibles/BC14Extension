Page 52092412 "Appraisal - ESS"
{
    Caption = 'Performance';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Appraisal Header";
    SourceTableView = where(Closed = const(false),
                            Location = const(Appraisee));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(AppraisalPeriod; "Appraisal Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    HideValue = true;
                    Visible = false;
                }
                field(AppraiseeNo; "Appraisee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(FirstName; "First Name")
                {
                    ApplicationArea = Basic;
                }
                field(LastName; "Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(MiddleName; "Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field(Initials; Initials)
                {
                    ApplicationArea = Basic;
                }
                field(Designation; Designation)
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory; "Employee Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category';
                }
                field(GradeLevelCode; "Grade Level Code")
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
                field(AppraisalType; "Appraisal Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DateAppraised; "Date Appraised")
                {
                    ApplicationArea = Basic;
                }
                field(Location; Location)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    HideValue = true;
                    Visible = false;
                }
                field(Closed; Closed)
                {
                    ApplicationArea = Basic;
                    HideValue = true;
                    Visible = false;
                }
                field(AppraiseeSectionalWeight; "Appraisee Sectional Weight")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000013; "Appraisal SubForm-ESS")
            {
                Caption = 'Performance Lines';
                SubPageLink = "Appraisal Period" = field("Appraisal Period"),
                              "Appraisal Type" = field("Appraisal Type"),
                              "Employee No." = field("Appraisee No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Skill Gaps and Training")
            {
                ApplicationArea = Basic;
                Image = Skills;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Appraisal Skill Gap";
                RunPageLink = "Appraisal Period" = field("Appraisal Period"),
                              "Appraisal Type" = field("Appraisal Type"),
                              "Employee No." = field("Appraisee No.");
            }
        }
        area(processing)
        {
            group("Function")
            {
                Caption = 'Function';
                action("<Action1000000016>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Submit';
                    Image = SendTo;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        Submit;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        Grading: Record "Appraisal Grading";
        Employee: Record Employee;
        AppraisalLine: Record "Appraisal Lines";
        StaffRatingSetup: Record "Employee Category Rating Setup";
        AppraisalSection: Record "Appraisal Section";
        AppraisalHeader1: Record "Appraisal Header";
        AppraisalHeader2: Record "Appraisal Header";
        AppraisalGrading: Record "Appraisal Grading";
        UserSetup: Record "User Setup";
        YearNo: Integer;
        AppraisalType: Option " ","Mid-Year","Year-End";
        Window: Dialog;
        Text001: label 'Appraisal Type cannot be blank!';
        Text002: label 'Entry already submitted';
        Text003: label 'Complete the scoring before submitting';
        Text004: label 'Are you sure you want to submit this entry?';
        Text005: label 'Entry successfully submitted';
        CurrPeriod: Code[20];
        Text006: label 'Recommendation already applied. Contact HR';
        Text007: label 'This will recall the entries, continue anyway?';
}

