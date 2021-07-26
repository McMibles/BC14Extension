Page 52092396 "Appraisal Score"
{
    Caption = 'Performance Score';
    PageType = List;
    SourceTable = "Score Setup";
    SourceTableView = where("Record Type"=const("Appraisal Score"));

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
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Mark;Mark)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Record Type" := "record type"::"Appraisal Score";
    end;
}

