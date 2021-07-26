Page 52092641 "Payment Voucher"
{
    PageType = Document;
    SourceTable = "Payment Header";
    SourceTableView = where("Document Type" = const("Payment Voucher"));

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
                    Editable = DocDateEditable;
                }
                field(PaymentType; "Payment Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        OnAfterValidatePmtType
                    end;
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
                }
                field(PostingDescription; "Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentMethod; "Payment Method")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        OnAfterValidatePmtMethod;
                    end;
                }
                field(PaymentSource; "Payment Source")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentDate; "Payment Date")
                {
                    ApplicationArea = Basic;
                    Visible = PaymentDateVisible;
                }
                field(ShortcutDimension1Code; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension2Code; "Shortcut Dimension 2 Code")
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
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
                field(PaymentRequestNo; "Payment Request No.")
                {
                    ApplicationArea = Basic;
                }
                field(NoPrinted; "No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic;
                }
                field(AmountLCY; "Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(WHTAmount; "WHT Amount")
                {
                    ApplicationArea = Basic;
                }
                field(WHTAmountLCY; "WHT Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Payee)
            {
                field(PayeeNo; "Payee No.")
                {
                    ApplicationArea = Basic;
                    Editable = PayeeDetailsEditable;
                }
                field("Payee Name"; Payee)
                {
                    ApplicationArea = Basic;
                    Editable = PayeeDetailsEditable;
                }
                field(PayeeBankCode; "Payee Bank Code")
                {
                    ApplicationArea = Basic;
                    Editable = AcctDetailsEditable;
                }
                field(PayeeCBNBankCode; "Payee CBN Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field(PayeeBankAccountName; "Payee Bank Account Name")
                {
                    ApplicationArea = Basic;
                    Editable = AcctDetailsEditable;
                }
                field(PayeeBankAccountNo; "Payee Bank Account No.")
                {
                    ApplicationArea = Basic;
                    Editable = AcctDetailsEditable;
                }
            }
            group(Payroll)
            {
                Enabled = EnablePayroll;
                field(PayrollPeriod; "Payroll Period")
                {
                    ApplicationArea = Basic;
                }
                field(PayrollEDCode; "Payroll-E/DCode")
                {
                    ApplicationArea = Basic;
                }
                field(PayrollEDDescription; "Payroll E/D Description")
                {
                    ApplicationArea = Basic;
                }
                field(ClosedPayrollYesNo; "Closed Payroll(Yes/No)")
                {
                    ApplicationArea = Basic;
                }
                field(PensionAdministrator; "Pension Administrator")
                {
                    ApplicationArea = Basic;
                }
            }
            //     part(Control6;"Payment Voucher Subform")
            //     {
            //         Caption = 'Lines';
            //         SubPageLink = "Document No."=field("No."),
            //                       "Document Type"=field("Document Type");
            //     }
            // }
            // area(factboxes)
            // {
            //     part(Control1000000001;"Pmt Line Budget Stats FactBox")
            //     {
            //         Caption = 'Payment Voucher Budget Statistics';
            //         Provider = Control6;
            //         SubPageLink = "Document No."=field("Document No."),
            //                       "Document Type"=field("Document Type");
            //     }
            part(Control52; "Pending Approval FactBox")
            {
                SubPageLink = "Table ID" = const(60202),
                              "Document Type" = const(6),
                              "Document No." = field("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control51; "Approval FactBox")
            {
                SubPageLink = "Table ID" = const(60202),
                              "Document Type" = const(6),
                              "Document No." = field("No.");
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
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
                RunPageLink = "Table Name" = const("Payment Voucher"),
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
                    ApprovalEntries.Setfilters(Database::"Payment Header", 6, "No.");
                    ApprovalEntries.Run;
                end;
            }
            action("Payment Request")
            {
                ApplicationArea = Basic;
                Image = Archive;
                RunObject = Page "Payment Request Archive";
                RunPageLink = "No." = field("Payment Request No.");
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
                    RunPageLink = "Table ID" = const(60202),
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
                        PaymentCheck.Run(Rec);
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformanualManualDocRelease(RecRef);
                        EnableFields;
                        CurrPage.Update;
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
                        if "Check Entry No." <> 0 then
                            Error(Text002);
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformManualReopen(RecRef);
                        EnableFields;
                        CurrPage.Update;
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
                        RecRef: RecordRef;
                        ApprovalMgt: Codeunit "Approvals Hook";
                    begin
                        PaymentCheck.Run(Rec);
                        RecRef.GetTable(Rec);
                        if ApprovalMgt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                            ApprovalMgt.OnSendGenericDocForApproval(RecRef);
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
                        ApprovalMgt: Codeunit "Approvals Hook";
                    begin
                        if "Check Entry No." <> 0 then
                            Error(Text002);

                        RecRef.GetTable(Rec);
                        ApprovalMgt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }
            }
            group(Void)
            {
                Caption = 'Void';
                action("Void Voucher")
                {
                    ApplicationArea = Basic;
                    Image = VoidCheck;

                    trigger OnAction()
                    var
                        PaymentMgt: Codeunit PaymentManagement;
                    begin
                        PaymentMgt.VoidPayment(Rec);
                    end;
                }
            }
            group("&Print")
            {
                Image = Print;
                action("Payment Voucher")
                {
                    ApplicationArea = Basic;
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PaymentVoucher: Record "Payment Header";
                    begin
                        PaymentCheck.Run(Rec);
                        PaymentVoucher := Rec;
                        PaymentVoucher.SetRecfilter;
                        Report.Run(Report::"Payment Document", true, true, PaymentVoucher)
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PaymentPost.Run(Rec)
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ShowWorkflowStatus := CurrPage.WorkflowStatus.Page.SetFilterOnWorkflowRecord(RecordId);
    end;

    trigger OnAfterGetRecord()
    begin
        EnableFields;
        SetControlAppearance;
    end;

    trigger OnInit()
    begin
        AcctDetailsEditable := true;
        PaymentDateVisible := false;
        DocDateEditable := true;
        PayeeDetailsEditable := true;
    end;

    trigger OnOpenPage()
    begin
        if UserSetupMgt.GetTreasuryFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserSetupMgt.GetTreasuryFilter);
            FilterGroup(0);
        end else
            SetRange("Responsibility Center");

        EnableFields
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        [InDataSet]
        AcctDetailsEditable: Boolean;
        [InDataSet]
        PaymentDateVisible: Boolean;
        [InDataSet]
        DocDateEditable: Boolean;
        [InDataSet]
        PayeeDetailsEditable: Boolean;
        CalledFromApproval: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        EnablePayroll: Boolean;
        PaymentCheck: Codeunit "Payment - Check";
        PaymentPost: Codeunit "Payment Post (Yes/No)";
        Text001: label 'Do you want to post this voucher?';
        Text002: label 'Document already attached to a check, action not allowed';
        Text004: label 'This can only be done by the requestor';
        UserSetupMgt: Codeunit "User Setup Management5700";
        PayrollPayment: Boolean;


    procedure EnableFields()
    begin
        AcctDetailsEditable := "Payment Method" = "payment method"::"E-Payment";
        if Status = Status::Approved then
            PaymentDateVisible := true
        else
            PaymentDateVisible := false;

        DocDateEditable := "Payment Request No." = '';
        PayeeDetailsEditable := "Payment Request No." = '';

        if "Payment Type" <> "payment type"::Salary then
            EnablePayroll := false
        else
            EnablePayroll := true;
    end;


    procedure OnAfterValidatePmtMethod()
    begin
        EnableFields
    end;


    procedure OnAfterValidatePmtType()
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
}

