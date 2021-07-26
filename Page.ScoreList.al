Page 52092446 "Score List"
{
    DataCaptionFields = "Record Type";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Score Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RecordType;"Record Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    HideValue = true;
                    Visible = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Score;"Score %")
                {
                    ApplicationArea = Basic;
                }
                field(Mark;Mark)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    HideValue = true;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

