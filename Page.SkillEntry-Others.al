Page 52092385 "Skill Entry-Others"
{
    Caption = 'Skill Entry';
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
            }
        }
    }

    actions
    {
    }

    var
        "Training Required Show": Boolean;


    procedure GetCaptionExpression(): Text[50]
    begin
    end;
}

