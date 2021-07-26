Page 52092684 "Commitment Entries"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Commitment Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo;"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentLineNo;"Document Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate;"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(AnalysisViewCode;"Analysis View Code")
                {
                    ApplicationArea = Basic;
                }
                field(BusinessUnitCode;"Business Unit Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AccountNo;"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Dimension1ValueCode;"Dimension 1 Value Code")
                {
                    ApplicationArea = Basic;
                }
                field(Dimension2ValueCode;"Dimension 2 Value Code")
                {
                    ApplicationArea = Basic;
                }
                field(Dimension3ValueCode;"Dimension 3 Value Code")
                {
                    ApplicationArea = Basic;
                }
                field(Dimension4ValueCode;"Dimension 4 Value Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
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

