Page 52092364 "Applicant Qualifications"
{
    SourceTable = "Other Qualification";
    SourceTableView = where("Record Type"=const(Applicant));

    layout
    {
        area(content)
        {
            repeater(Control1000000013)
            {
                field(QualificationCode;"Qualification Code")
                {
                    ApplicationArea = Basic;
                }
                field(CourseCode;"Course Code")
                {
                    ApplicationArea = Basic;
                }
                field(CourseGrade;"Course Grade")
                {
                    ApplicationArea = Basic;
                }
                field(FromDate;"From Date")
                {
                    ApplicationArea = Basic;
                }
                field(ToDate;"To Date")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(ExpirationDate;"Expiration Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(InstitutionCompany;"Institution/Company")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000001;Links)
            {
                Visible = false;
            }
            systempart(Control1000000000;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Record Type" := "record type"::Applicant;
    end;
}

