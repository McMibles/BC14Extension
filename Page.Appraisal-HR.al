Page 52092404 "Appraisal - HR"
{
    Caption = 'Performance';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Appraisal Header";
    SourceTableView = where("Appraisal Ready" = const(true),
                            "Recommendation Applied?" = const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
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
                field(EmployeeCategory; "Employee Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category';
                }
                field(PerformanceType; "Appraisal Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Type';
                    Editable = false;
                }
                field(AppraisedBy; "Appraised By")
                {
                    ApplicationArea = Basic;
                }
                field(DateAppraised; "Date Appraised")
                {
                    ApplicationArea = Basic;
                }
                field(SectionalWeightScore; "Sectional Weight Score")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Recommendations)
            {
                field(Recommendation; Recommendation)
                {
                    ApplicationArea = Basic;
                }
                field(RecommendedCode; "Recommended Code")
                {
                    ApplicationArea = Basic;
                }
                field(RecommendedSalIncrease; "Recommended Sal % Increase")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000013; "Appraisal SubForm")
            {
                Caption = 'Performance Lines';
                Editable = false;
                SubPageLink = "Appraisal Period" = field("Appraisal Period"),
                              "Appraisal Type" = field("Appraisal Type"),
                              "Employee No." = field("Appraisee No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                Caption = 'Function';
                action("<Action1000000026>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Performance';
                    Image = Apply;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApplyAppraisal: Report "Apply Appraisal";
                    begin
                        Clear(ApplyAppraisal);
                        Employee.SetRange("No.", "Appraisee No.");
                        ApplyAppraisal.SetTableview(Employee);
                        ApplyAppraisal.RunModal;
                        Clear(ApplyAppraisal);
                        CurrPage.Update(true);
                    end;
                }
                // action(ApplyRecommendation)
                // {
                //     ApplicationArea = Basic;
                //     Caption = 'Apply Recommendation';
                //     Image = Apply;
                //     Visible = false;

                //     trigger OnAction()
                //     var
                //         AppraisalHeader: Record "Appraisal Header";
                //         ApplyRecommendation: Report "Apply Recommendations";
                //     begin
                //         Clear(ApplyRecommendation);
                //         AppraisalHeader.SetRange("Appraisee No.","Appraisee No.");
                //         ApplyRecommendation.SetTableview(AppraisalHeader);
                //         ApplyRecommendation.Run;
                //         Clear(ApplyRecommendation);
                //         CurrPage.Update(true);
                //     end;
                // }
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
        UserSetup: Record "User Setup";
        YearNo: Integer;
        AppraisalType: Option " ","Mid-Year","Year-End";
        Window: Dialog;
        "SubForm Editable": Boolean;
        CurrPeriod: Code[20];
}

