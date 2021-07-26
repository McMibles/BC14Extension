Page 52092133 "Sharing Setup"
{
    PageType = List;
    SourceTable = "Sharing Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(AccountType;"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field(AccountNo;"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(Share;"Share %")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code;"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code;"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(DimensionSetID;"Dimension Set ID")
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

