Page 52092348 "Leave Setup"
{
    DataCaptionFields = "Record Type";
    PageType = List;
    SourceTable = "Leave Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(AbsenceCode;"Absence Code")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysAllowed;"No. of Days Allowed")
                {
                    ApplicationArea = Basic;
                }
                field(Allowance;"Allowance %")
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

