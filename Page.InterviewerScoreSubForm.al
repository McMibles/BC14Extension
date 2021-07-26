Page 52092376 "Interviewer Score SubForm"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Interviewer Score Details";

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
                field(Remarks;Remarks)
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

