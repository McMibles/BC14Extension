Page 52092192 "Employee Bank Account List"
{
    CardPageID = "Employee Bank Account Card";
    Editable = false;
    PageType = List;
    SourceTable = "Employee Bank Account";

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
                field(BankName;"Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field(BankAccountNo;"Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(SWIFTCode;"SWIFT Code")
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

