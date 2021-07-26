PageExtension 52000051 pageextension52000051 extends "Employee Ledger Entries" 
{
    layout
    {
        addafter("Document Type")
        {
            field("Entry Type";"Entry Type")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Document No.")
        {
            field("Cash Advance Doc. No.";"Cash Advance Doc. No.")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

