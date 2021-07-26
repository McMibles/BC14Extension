Page 52092337 "Job/Vacancy Qualifications"
{
    AutoSplitKey = true;
    DataCaptionFields = "No.";
    SourceTable = "Other Qualification";

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
                field(Description;Description)
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

