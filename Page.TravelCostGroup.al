Page 52092457 "Travel Cost Group"
{
    PageType = List;
    SourceTable = "Travel Cost Group";

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
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(AccountCode;"Account Code")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentRequestType;"Payment Request Type")
                {
                    ApplicationArea = Basic;
                }
                field(PerNight;"Per Night")
                {
                    ApplicationArea = Basic;
                }
                field(Accommodation;Accommodation)
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

