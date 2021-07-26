Page 52092690 "Payment Request Archive"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Payment Request Header Archive";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; "Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; "Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDescription; "Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field(CreationDate; "Creation Date")
                {
                    ApplicationArea = Basic;
                }
                field(CreationTime; "Creation Time")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(RequestType; "Request Type")
                {
                    ApplicationArea = Basic;
                }
                field(NoPrinted; "No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Amount';
                }
            }
            // part(PaymentReqLines; "Payment Request Line Archive")
            // {
            //     Editable = false;
            //     //SubPageLink = "Document No."=field("No.");
            // }
            group(Payee)
            {
                field(Beneficiary; Beneficiary)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BeneficiaryName; "Beneficiary Name")
                {
                    ApplicationArea = Basic;
                }
                field(PreferredPmtMethod; "Preferred Pmt. Method")
                {
                    ApplicationArea = Basic;
                }
                field(PreferredBankCode; "Preferred  Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field(PayeeBankAccountNo; "Payee Bank Account No.")
                {
                    ApplicationArea = Basic;
                }
                field(PayeeBankAccountName; "Payee Bank Account Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            // part(Control1000000001; "Req. Line Budget Stats FactBox")
            // {
            //     Caption = 'Request Line Budget Statistics';
            //     Provider = PaymentReqLines;
            //     SubPageLink = "Document No." = field("Document No."),
            //                   "Line No." = field("Line No.");
            // }
            systempart(Control43; Links)
            {
                Visible = false;
            }
            systempart(Control42; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Image = Dimensions;

                trigger OnAction()
                begin
                    ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
            action(Comments)
            {
                ApplicationArea = Basic;
                Image = ViewComments;
                RunObject = Page "Payment Comment Sheet";
                RunPageLink = "Table Name" = const("Archived Payment Request"),
                              "No." = field("No.");
            }
            action(Approvals)
            {
                ApplicationArea = Basic;
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.Setfilters(Database::"Payment Request Header Archive", 6, "No.");
                    ApprovalEntries.Run;
                end;
            }
        }
    }
}

