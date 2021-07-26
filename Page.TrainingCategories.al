Page 52092419 "Training Categories"
{
    PageType = List;
    SourceTable = "Training Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(DescriptionTitle;"Description/Title")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
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
            group(Training)
            {
                Caption = 'Training';
                action(Skillstoacquire)
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills to acquire';
                    RunObject = Page "Skill Entry";
                    RunPageLink = "Record Type"=const("Training Category"),
                                  "No."=field(Code);
                }
            }
        }
    }
}

