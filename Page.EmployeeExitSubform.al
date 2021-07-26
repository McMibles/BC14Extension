Page 52092469 "Employee Exit Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Employee Exit Article Entry";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(MiscArticleCode;"Misc. Article Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(SerialNo;"Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(DebitAmount;"Debit Amount")
                {
                    ApplicationArea = Basic;
                }
                field(CreditAmount;"Credit Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibleManager;"Responsible Manager")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(UserID;"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(ModifiedDate;"Modified Date")
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

