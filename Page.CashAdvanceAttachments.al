Page 52092655 "Cash Advance Attachments"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Posted Payment Header";
    SourceTableView = where("Document Type"=const("Cash Advance"),
                            "Entry Status"=const(Posted),
                            "Retirement Status"=const(Open));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDescription;"Posting Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CurrencyCode;"Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DocumentDate;"Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PaymentDate;"Payment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PayeeNo;"Payee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
            group(Control16)
            {
                field(AttachedAmount;AttachedAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Attached Amount';
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control19;Links)
            {
                Visible = false;
            }
            systempart(Control18;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                action("Attach Cash Advance")
                {
                    ApplicationArea = Basic;
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        PaymentHeader.TestField(Status,PaymentHeader.Status::Open);

                        if  "Retirement No." <> '' then
                          TestField("Retirement No.",PaymentHeader."No.");

                        "Retirement No." := PaymentHeader."No." ;

                        Modify;
                        CalcAttachedAmnt;
                    end;
                }
                action("Undo Attachment")
                {
                    ApplicationArea = Basic;
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PaymentLine: Record "Payment Line";
                        PostedPaymentLine: Record "Posted Payment Line";
                    begin
                        PaymentHeader.TestField(Status,PaymentHeader.Status::Open);
                        if not Confirm(Text001,false) then
                          exit;

                        "Retirement No." := '';
                        Modify;

                        PaymentLine.SetRange("Document Type",PaymentHeader."Document Type");
                        PaymentLine.SetRange("Document No.",PaymentHeader."No.");
                        PaymentLine.SetRange("Attached Doc. No.","No.");
                        PaymentLine.DeleteAll;

                        PostedPaymentLine.SetRange("Document Type","Document Type");
                        PostedPaymentLine.SetRange("Document No.","No.");
                        PostedPaymentLine.ModifyAll("Retirement No.",'');

                        CalcAttachedAmnt;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        CalcAttachedAmnt;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          CreateLines;
    end;

    var
        PaymentHeader: Record "Payment Header";
        GetCashOutAdvances: Codeunit "Payment-Get Outst. Cash Advanc";
        Text001: label 'Do you want to remove the attached cash advance?';
        AttachedAmount: Decimal;


    procedure CalcAttachedAmnt()
    var
        PaymentHeader2: Record "Posted Payment Header";
    begin
        AttachedAmount := 0;
        PaymentHeader2.SetRange("Retirement No.",PaymentHeader."No.");
        if PaymentHeader2.FindSet then
          repeat
            PaymentHeader2.CalcFields(Amount);
            AttachedAmount := AttachedAmount + PaymentHeader2.Amount;
          until PaymentHeader2.Next = 0;
    end;


    procedure SetPaymentHeader(var PaymentHeader2: Record "Payment Header")
    begin
        PaymentHeader.Get(PaymentHeader2."Document Type",PaymentHeader2."No.");
        PaymentHeader.TestField("Document Type",PaymentHeader."document type"::Retirement);
    end;


    procedure CreateLines()
    begin
        CurrPage.SetSelectionFilter(Rec);
        GetCashOutAdvances.SetPaymentHeader(PaymentHeader);
        GetCashOutAdvances.CreateRetirementLines(Rec);
    end;
}

