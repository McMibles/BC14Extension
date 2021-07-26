Page 52092697 "Payment Request Archive List"
{
    CardPageID = "Payment Request Archive";
    Editable = false;
    PageType = List;
    SourceTable = "Payment Request Header Archive";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentType;"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDescription;"Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate;"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(BeneficiaryName;"Beneficiary Name")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentDate;"Payment Date")
                {
                    ApplicationArea = Basic;
                }
                field(RetirementStatus;"Retirement Status")
                {
                    ApplicationArea = Basic;
                }
                field(RetirementNo;"Retirement No.")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(AmountLCY;"Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          CreateLines;
    end;

    var
        PaymentRequest: Record "Payment Request Header";


    procedure SetPaymentReqHeader(var lPaymentRequest: Record "Payment Request Header")
    begin
        PaymentRequest.Get(lPaymentRequest."Document Type",lPaymentRequest."No.");
    end;


    procedure CreateLines()
    var
        PaymentRequestMgt: Codeunit "Payment Request Mgt";
    begin
        CurrPage.SetSelectionFilter(Rec);
        PaymentRequestMgt.SetPaymentReqHeader(PaymentRequest);
        PaymentRequestMgt.CreatePayReqLines(Rec);
    end;
}

