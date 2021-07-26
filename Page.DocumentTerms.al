Page 52092802 "Document Terms"
{
    AutoSplitKey = true;
    DataCaptionFields = Type;
    PageType = List;
    SourceTable = "Document Term";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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


    procedure GetCaption(): Text[50]
    begin
        if GetFilter(Type) <> '' then
          exit(GetFilter(Type) + '' + 'Terms')
        else
          exit('Terms');
    end;
}

