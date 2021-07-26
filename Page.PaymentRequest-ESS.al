Page 52092663 "Payment Request - ESS"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Payment Request Header";
    SourceTableView = where("Document Type" = const("Cash Account"));

    layout
    {
        area(content)
        {
            group(General)
            {
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

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        if "Document Date" <> 0D then
                            ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Document Date")
                        else
                            ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = Action::OK then begin
                            Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.Update;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeOnAfterValidate;
                    end;
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
                field(CreatedfromExternalPortal; "Created from External Portal")
                {
                    ApplicationArea = Basic;
                    HideValue = true;
                    Visible = false;
                }
                field(MobileUserID; "Mobile User ID")
                {
                    ApplicationArea = Basic;
                    HideValue = true;
                    Visible = false;
                }
                field(PortalID; "Portal ID")
                {
                    ApplicationArea = Basic;
                    HideValue = true;
                    Visible = false;
                }
                field(ResponsibilityCenter; "Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
            }
            part(PaymentReqLines; "Payment Request SubForm-ESS")
            {
                SubPageLink = "Document Type" = field("Document Type"),
                              "Document No." = field("No.");
            }
            group(Payee)
            {
                field(Beneficiary; Beneficiary)
                {
                    ApplicationArea = Basic;
                }
                field(BeneficiaryName; "Beneficiary Name")
                {
                    ApplicationArea = Basic;
                }
                field(PreferredPmtMethod; "Preferred Pmt. Method")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        OnAfterValidatePmtMethod;
                    end;
                }
                field(PreferredBankCode; "Preferred  Bank Code")
                {
                    ApplicationArea = Basic;
                    Editable = AcctDetailsEditable;
                }
                field(PayeeBankAccountNo; "Payee Bank Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = AcctDetailsEditable;
                }
                field(PayeeBankAccountName; "Payee Bank Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = AcctDetailsEditable;
                }
            }
        }
        area(factboxes)
        {
            // part(Control1000000000;"Req. Line Budget Stats FactBox")
            // {
            //     Caption = 'Request Line Budget Statistics';
            //     Provider = PaymentReqLines;
            //     SubPageLink = "Document No."=field("Document No."),
            //                   "Line No."=field("Line No.");
            // }
            systempart(Control39; Links)
            {
                Visible = false;
            }
            systempart(Control38; Notes)
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
                RunPageLink = "Table Name" = const("Payment Request"),
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
                    ApprovalEntries.Setfilters(Database::"Payment Request Header", 6, "No.");
                    ApprovalEntries.Run;
                end;
            }
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
                end;
            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = const(60200),
                                  "Document No." = field("No.");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                }
            }
            group(Release)
            {
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocument: Codeunit "Release Documents";
                    begin
                        CheckEntryForApproval;
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocument: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformManualReopen(RecRef);
                    end;
                }
            }
            group("Request Approval")
            {
                action("Send &Approval Request")
                {
                    ApplicationArea = Basic;
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                        PaymentHeader: Record "Payment Request Header";
                        RecRef: RecordRef;
                    begin
                        CheckEntryForApproval;
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                            ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }
            }
            group(Functions)
            {
                action(GetReimbursementEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Reimbursement Entries';
                    Image = GetEntries;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PaymentReqMgt: Codeunit "Payment Request Mgt";
                    begin
                        TestField("Request Type", "request type"::"Float Reimbursement");
                        PaymentReqMgt.GetPaymentRquest(Rec);
                    end;
                }
                separator(Action41)
                {
                }
                action("Void Document")
                {
                    ApplicationArea = Basic;
                    Image = VoidCheck;

                    trigger OnAction()
                    var
                        PaymentReqMgt: Codeunit "Payment Request Mgt";
                    begin
                        PaymentReqMgt.VoidRequest(Rec);
                    end;
                }
            }
            group("&Print")
            {
                Image = Print;
                action("Payment Request")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableFields;
        SetControlAppearance
    end;

    trigger OnInit()
    begin
        AcctDetailsEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Document Type" := "document type"::"Cash Account";
    end;

    trigger OnOpenPage()
    begin
        SetDocNoVisible;
        EnableFields
    end;

    var
        UserSetup: Record "User Setup";
        ChangeExchangeRate: Page "Change Exchange Rate";
        [InDataSet]
        AcctDetailsEditable: Boolean;
        CalledFromApproval: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        DocNoVisible: Boolean;
        CreateVoucher: Codeunit "Payment Request Mgt";
        ArchiveManagement: Codeunit ArchiveManagement;

    local procedure CurrencyCodeOnAfterValidate()
    begin
        CurrPage.PaymentReqLines.Page.UpdateForm(true);
    end;


    procedure EnableFields()
    begin
        AcctDetailsEditable := "Preferred Pmt. Method" = "preferred pmt. method"::"E-Payment";
        CurrPage.Editable(Status <> Status::"Pending Approval");
    end;


    procedure OnAfterValidatePmtMethod()
    begin
        EnableFields
    end;


    procedure SetCalledFromApproval()
    begin
        CalledFromApproval := true;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(Doctype::Order, "No.");
    end;
}

