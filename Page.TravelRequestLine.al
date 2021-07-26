Page 52092459 "Travel Request Line"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Travel Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TravelGroup;"Travel Group")
                {
                    ApplicationArea = Basic;
                }
                field(FromDestination;"From Destination")
                {
                    ApplicationArea = Basic;
                }
                field(ToDestination;"To Destination")
                {
                    ApplicationArea = Basic;
                }
                field(StartDate;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndDate;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoofNights;"No. of Nights")
                {
                    ApplicationArea = Basic;
                }
                field(JobNo;"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(JobTaskNo;"Job Task No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AccommodationProvided;"Accommodation Provided")
                {
                    ApplicationArea = Basic;
                }
                field(TotalCostLCY;"Total Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000010>")
            {
                ApplicationArea = Basic;
                Caption = 'Request Cost';
                RunObject = Page "Travel Request Cost";
                RunPageLink = "Document No."=field("Document No."),
                              "Line No."=field("Line No.");
            }
            action(Dimension)
            {
                ApplicationArea = Basic;
                Caption = 'Dimension';

                trigger OnAction()
                begin
                    ShowDimensions;
                end;
            }
        }
    }
}

