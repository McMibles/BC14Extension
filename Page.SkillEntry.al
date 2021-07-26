Page 52092386 "Skill Entry"
{
    DataCaptionFields = "Record Type";
    PageType = List;
    SourceTable = "Skill Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SkillCode;"Skill Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(InstitutionCompany;"Institution/Company")
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
                field(AcquisitionMethod;"Acquisition Method")
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

