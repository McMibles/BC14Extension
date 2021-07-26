Page 52092464 "Travel List - Admin"
{
    CardPageID = "Travel Request-Admin";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Travel Header";
    SourceTableView = where(Closed=const(false),
                            Status=const(Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Beneficiary;Beneficiary)
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
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
                field(DocumentDate;"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Ticketed;Ticketed)
                {
                    ApplicationArea = Basic;
                }
                field(VoucherNo;"Voucher No.")
                {
                    ApplicationArea = Basic;
                }
                field(VoucherFollowupStatus;"Voucher Follow-up Status")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        UserSetup: Record "User Setup";
}

