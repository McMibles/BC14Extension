Page 52092167 "Posting Group"
{
    PageType = Card;
    SourceTable = "Payroll-Posting Group Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PostingGroupCode;"Posting Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(SearchName;"Search Name")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000000;"Posting Group Subform")
            {
                SubPageLink = "Posting Group"=field("Posting Group Code");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(CopyLinesfromanothergroup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Lines from another group';
                    Ellipsis = false;
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CurrentPostingHeader: Record "Payroll-Posting Group Header";
                        CopyGroup: Report "Copy Posting Group Lines";
                    begin
                        CurrentPostingHeader := Rec;
                        CurrentPostingHeader.SetRecfilter;
                        CopyGroup.SetTableview(CurrentPostingHeader);
                        CopyGroup.Run;
                        CurrPage.Update(true);
                    end;
                }
            }
        }
    }
}

