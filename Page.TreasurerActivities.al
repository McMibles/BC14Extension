Page 52092688 "Treasurer Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Finance Cue";

    layout
    {
        area(content)
        {
            cuegroup(Payables)
            {
                Caption = 'Payables';
                field(PurchaseDocumentsDueToday; "Purchase Documents Due Today")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vendor Ledger Entries";
                }
                field(VendorsPaymentonHold; "Vendors - Payment on Hold")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Vendor List";
                }
                field(ApprovedPaymentRequest; "Approved Payment Request")
                {
                    ApplicationArea = Basic;
                    //DrillDownPageID = "Payment Request List";
                }
                field(ApprovedPaymentVouchers; "Approved Payment Vouchers")
                {
                    ApplicationArea = Basic;
                    //DrillDownPageID = "Payment Voucher List";
                }
                field(ApprovedCashAdvances; "Approved Cash Advances")
                {
                    ApplicationArea = Basic;
                    //DrillDownPageID = "Cash Advance List";
                }
                field(ApprovedCashAdvRetirement; "Approved Cash Adv. Retirement")
                {
                    ApplicationArea = Basic;
                    //DrillDownPageID = "Cash Advance Retirement List";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;

        SetFilter("Due Date Filter", '<=%1', WorkDate);
        SetFilter("Overdue Date Filter", '<%1', WorkDate);
    end;
}

