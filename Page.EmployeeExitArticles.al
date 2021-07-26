Page 52092468 "Employee Exit Articles"
{
    PageType = List;
    SourceTable = "Employee Exit Article";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(MiscArticleCode;"Misc. Article Code")
                {
                    ApplicationArea = Basic;
                }
                field(StaffDebtor;"Staff Debtor")
                {
                    ApplicationArea = Basic;
                }
                field(StaffCreditor;"Staff Creditor")
                {
                    ApplicationArea = Basic;
                }
                field(StaffGratuity;"Staff Gratuity")
                {
                    ApplicationArea = Basic;
                }
                field(OutstandingCashAdvance;"Outstanding Cash Advance")
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
                field(RequestCode;"Request Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000002;Links)
            {
                Visible = false;
            }
            systempart(Control1000000004;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

