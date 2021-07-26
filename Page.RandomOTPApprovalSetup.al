Page 52092130 "Random OTP Approval Setup"
{
    PageType = List;
    SourceTable = "Random OTP Approval Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TableID;"Table ID")
                {
                    ApplicationArea = Basic;
                }
                field(TableName;"Table Name")
                {
                    ApplicationArea = Basic;
                }
                field(MinimumAmountLCY;"Minimum Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(LastDateModified;"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field(Enable;Enable)
                {
                    ApplicationArea = Basic;
                }
                field(ModifiedBy;"Modified By")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13;Notes)
            {
            }
            systempart(Control14;Links)
            {
            }
        }
    }

    actions
    {
    }
}

