PageExtension 52000029 pageextension52000029 extends "Bank Acc. Reconciliation" 
{
    layout
    {
        addafter(BankAccountNo)
        {
            field("Bank Account Name";"Bank Account Name")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter(NotMatched)
        {
            action(Matched)
            {
                ApplicationArea = Basic;
                Caption = 'Show Matched';
                Image = Add;

                trigger OnAction()
                begin
                    CurrPage.StmtLine.Page.ShowMatched;
                    CurrPage.ApplyBankLedgerEntries.Page.ShowMatched;
                end;
            }
        }
    }
}

