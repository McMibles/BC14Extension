Page 52092336 "Job Title List"
{
    CardPageID = "Job Title Card";
    Editable = false;
    PageType = List;
    SourceTable = "Job Title";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RefNo;"Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(TitleDescription;"Title/Description")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(JobTitle)
            {
                Caption = 'Job Title';
                action(Skills)
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    Image = Skills;
                    RunObject = Page "Skill Entry";
                    RunPageLink = "Record Type"=const("Job Title"),
                                  "No."=field("Ref. No.");
                }
                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    RunObject = Page "Job/Vacancy Qualifications";
                    RunPageLink = "Record Type"=const("Job Title"),
                                  "No."=field("Ref. No.");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then
          CurrPage.Editable := false;
    end;
}

