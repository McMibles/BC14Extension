Page 52092180 "Payroll-Loan Entries"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "Payroll-Loan Entry";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(EntryNo;"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType;"Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(CustLedgerEntryNo;"Cust. Ledger Entry No.")
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

