Page 52092190 "Benefit Factor"
{
    PageType = List;
    SourceTable = "Benefit Factor";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(LowerLimit;"Lower Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UpperLimit;"Upper Limit")
                {
                    ApplicationArea = Basic;
                }
                field(MinAge;"Min. Age")
                {
                    ApplicationArea = Basic;
                }
                field(Factor;"Factor %")
                {
                    ApplicationArea = Basic;
                }
                field(Basis;Basis)
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

