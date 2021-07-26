Page 52092380 "Interview Result Factbox"
{
    Caption = 'Interview Info';
    PageType = CardPart;
    SourceTable = "Interview Header";

    layout
    {
        area(content)
        {
            field(NotoInterview;"No. to Interview")
            {
                ApplicationArea = Basic;
            }
            field(NoInterviewed;"No. Interviewed")
            {
                ApplicationArea = Basic;
            }
            field(NoShortListed;"No. Short-Listed")
            {
                ApplicationArea = Basic;
            }
            field(NoPassed;"No. Passed")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }
}

