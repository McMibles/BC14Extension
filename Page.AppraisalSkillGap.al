Page 52092410 "Appraisal Skill Gap"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Appraisal Skill Gap";

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
                field(SkillDescription;"Skill Description")
                {
                    ApplicationArea = Basic;
                }
                field(TrainingRequired;"Training Required")
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

