Page 52092191 "Employee Bank Account Card"
{
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Employee Bank Account";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field(Address2;"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(CBNBankCode;"CBN Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field(BankName;"Bank Name")
                {
                    ApplicationArea = Basic;
                }
                field(BankBranch;"Bank Branch")
                {
                    ApplicationArea = Basic;
                }
                field(BankAccountName;"Bank Account Name")
                {
                    ApplicationArea = Basic;
                }
                field(BankAccountNo;"Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(UseforPayroll;"Use for Payroll")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                }
                field(PhoneNo;"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(EMail;"E-Mail")
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

