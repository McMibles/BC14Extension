Page 52092373 "Interview Schedule SubForm"
{
    AutoSplitKey = true;
    DelayedInsert = true;
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
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Time;Time)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Score;"Score %")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(Performance;Performance)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(Selection;Selection)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(Response;Response)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(ReasonforSelection;"Reason for Selection")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(ReasonforResponse;"Reason for Response")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

