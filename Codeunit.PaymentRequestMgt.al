Codeunit 52092220 "Payment Request Mgt"
{
    Permissions = TableData Vendor = rim;
    TableNo = "Payment Request Header";

    trigger OnRun()
    var
        PaymentVoucherHeader: Record "Payment Header";
        PaymentVoucherLine: Record "Payment Line";
        PaymentReqLine: Record "Payment Request Line";
        Employee: Record Employee;
        PaymentReqHeader: Record "Payment Request Header";
        PaymentPost: Codeunit "Payment - Post";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        RecordLinkManagement: Codeunit "Record Link Management";
    begin
        if not Confirm(Text000, false) then
            exit;

        Window.Open('#1########################################');

        Window.Update(1, Text001);
        TestField(Status, Status::Approved);
        case "Request Type" of
            "request type"::"Cash Advance", "request type"::"Direct Expense":
                TestField(Beneficiary);
        end;
        PaymentReqHeader := Rec;
        PmtMgtSetup.Get;

        Window.Update(1, Text002);
        PaymentVoucherHeader.Init;
        PaymentVoucherHeader."No." := '';
        PaymentVoucherHeader."System Created Entry" := true;
        case "Request Type" of
            "request type"::"Direct Expense":
                begin
                    PaymentVoucherHeader."Document Type" := PaymentVoucherHeader."document type"::"Payment Voucher";
                    PaymentVoucherHeader."Payment Type" := PaymentVoucherHeader."payment type"::Others;
                    PaymentVoucherHeader."Bal. Account No." := '';
                end;
            "request type"::"Cash Advance":
                begin
                    PaymentVoucherHeader."Document Type" := PaymentVoucherHeader."document type"::"Cash Advance";
                    PaymentVoucherHeader."Payment Type" := PaymentVoucherHeader."payment type"::"Cash Advance";
                    PaymentVoucherHeader."Bal. Account Type" := PaymentVoucherHeader."bal. account type"::Employee;
                    PaymentVoucherHeader.Status := PaymentVoucherHeader.Status::Approved;
                    PaymentVoucherHeader.Validate("Payee No.", Beneficiary)
                end;
            "request type"::"Float Reimbursement":
                begin
                    PaymentVoucherHeader."Document Type" := PaymentVoucherHeader."document type"::"Payment Voucher";
                    PaymentVoucherHeader."Payment Type" := PaymentVoucherHeader."payment type"::Others;
                    PaymentVoucherHeader."Payment Source" := "Float Account";
                end;
        end;
        PaymentVoucherHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
        PaymentVoucherHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        PaymentVoucherHeader."Dimension Set ID" := "Dimension Set ID";
        PaymentVoucherHeader."Currency Code" := "Currency Code";
        PaymentVoucherHeader."Currency Factor" := "Currency Factor";
        PaymentVoucherHeader."Payment Request No." := "No.";
        PaymentVoucherHeader."Posting Description" := "Posting Description";
        PaymentVoucherHeader."Payment Method" := "Preferred Pmt. Method";
        PaymentVoucherHeader."Payee No." := Beneficiary;
        PaymentVoucherHeader.Payee := "Beneficiary Name";
        PaymentVoucherHeader."Payee Bank Code" := "Preferred  Bank Code";
        PaymentVoucherHeader."Payee Bank Account Name" := "Payee Bank Account Name";
        PaymentVoucherHeader."Payee Bank Account No." := "Payee Bank Account No.";
        PaymentVoucherHeader."Employee Posting Group" := "Employee Posting Group";
        PaymentVoucherHeader.Insert(true);
        RecordLinkManagement.CopyLinks(Rec, PaymentVoucherHeader);

        Window.Update(1, Text003);
        PaymentReqLine.SetRange("Document No.", "No.");
        if PaymentReqLine.FindSet then begin
            repeat
                PaymentVoucherLine."Document No." := PaymentVoucherHeader."No.";
                PaymentVoucherLine."Document Type" := PaymentVoucherHeader."Document Type";
                PaymentVoucherLine."Line No." := PaymentReqLine."Line No.";
                PaymentVoucherLine.Description := PaymentReqLine.Description;
                PaymentVoucherLine.Validate("Account Type", PaymentReqLine."Account Type");
                PaymentVoucherLine.Validate("Account No.", PaymentReqLine."Account No.");
                PaymentVoucherLine."Payment Type" := PaymentVoucherHeader."Payment Type";
                PaymentVoucherLine."Shortcut Dimension 1 Code" := PaymentReqLine."Shortcut Dimension 1 Code";
                PaymentVoucherLine."Shortcut Dimension 2 Code" := PaymentReqLine."Shortcut Dimension 2 Code";
                PaymentVoucherLine."Dimension Set ID" := PaymentReqLine."Dimension Set ID";
                PaymentVoucherLine."Job No." := PaymentReqLine."Job No.";
                PaymentVoucherLine."Job Task No." := PaymentReqLine."Job Task No.";
                PaymentVoucherLine."Maintenance Code" := PaymentReqLine."Maintenance Code";
                PaymentVoucherLine."Request No." := PaymentReqLine."Document No.";
                PaymentVoucherLine."Payment Req. Line No." := PaymentReqLine."Line No.";
                PaymentVoucherLine."Request Amount" := PaymentReqLine.Amount;
                PaymentVoucherLine.Amount := PaymentReqLine.Amount;
                PaymentVoucherLine."Amount (LCY)" := PaymentReqLine."Amount (LCY)";
                PaymentVoucherLine.Insert;
                RecordLinkManagement.CopyLinks(PaymentReqLine, PaymentVoucherLine);
                with PaymentVoucherLine do begin
                    if ("Account Type" = "account type"::"G/L Account") and (PmtMgtSetup."Budget Expense Control Enabled") then
                        if BudgetControlMgt.ControlBudget("Account No.") then
                            BudgetControlMgt.UpdateCommitment("Document No.", "Line No.", PaymentVoucherHeader."Document Date",
                              "Amount (LCY)", "Account No.", "Dimension Set ID");
                end;

            until PaymentReqLine.Next = 0;
        end;

        VoucherNo := PaymentVoucherHeader."No.";

        OnCreatePaymentDocument(Rec, PaymentVoucherHeader);

        if "Request Type" in ["request type"::"Cash Advance", "request type"::"Float Reimbursement"] then begin
            PaymentVoucherHeader."Create Voucher" := true;
            PaymentVoucherHeader."Payment Date" := Today;
            PaymentVoucherHeader.Modify;
            PaymentPost.SetShowMessage(false);
            PaymentPost.Run(PaymentVoucherHeader);
            VoucherNo := PaymentPost.GetVoucherNo;
            UpdatePostedFloat(Rec);
        end;

        //Alert Requestor
        Employee.Get(PaymentReqHeader.Beneficiary);
        if (PmtMgtSetup."Alert on Voucher Creation") and (Employee."Company E-Mail" <> '') then begin
            UserSetup.Get(UpperCase(UserId));
            UserSetup.TestField("E-Mail");
            Subject := Text101;
            Body := StrSubstNo(Text102, PaymentVoucherHeader."Payment Request No.");
            SMTP.CreateMessage(COMPANYNAME, UserSetup."E-Mail", Employee."Company E-Mail", Subject, Body, true);
            Body := StrSubstNo('<p class="MsoNormal"><font face="Arial">%1</font></p>', StrSubstNo(Text103, VoucherNo));
            SMTP.AppendBody(Body);
            if SMTP.TrySend then;
        end;

        ArchivePaymentRequest(Rec);

        Message(Text004, VoucherNo);

        Commit;
        UpdateAnalysisView.UpdateAll(0, true);
    end;

    var
        Text000: label 'Do you want to convert the payment request to a payment voucher?';
        PaymentComment: Record "Payment Comment Line";
        PaymentComment2: Record "Payment Comment Line";
        Employee: Record Employee;
        PmtMgtSetup: Record "Payment Mgt. Setup";
        UserSetup: Record "User Setup";
        VendPostingGrp: Record "Vendor Posting Group";
        PaymentReqHeader: Record "Payment Request Header";
        Window: Dialog;
        Text001: label 'Checking Payment Request';
        Text002: label 'Creating Payment Voucher Header';
        Text003: label 'Creating Payment Voucher Lines';
        Text004: label 'Payment Voucher %1 successfully created';
        BudgetControlMgt: Codeunit "Budget Control Management";
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        SMTP: Codeunit "SMTP Mail";
        Subject: Text[80];
        Body: Text[150];
        Text005: label 'Nothing to post';
        Text006: label 'Posting Cash Advance';
        Text007: label 'Do you want to convert the payment request to a cash advance?';
        Text101: label 'Payment Request Processing Alert';
        Text102: label 'This is to notify you that your payment request %1 is now being processed by accounts.';
        Text103: label 'A payment voucher %1 has been created for the payment.';
        VoucherNo: Code[20];
        Text104: label 'Do you want to post this request?';
        Text105: label 'Payment Request successfully posted';
        VoidText: label 'Do you want to void this request?';


    procedure ArchivePaymentRequest(PaymentRequest: Record "Payment Request Header")
    var
        PaymentReqLine: Record "Payment Request Line";
        PaymentReqHeaderArchive: Record "Payment Request Header Archive";
        PaymentReqLineArchive: Record "Payment Request Line Archive";
    begin
        with PaymentRequest do begin
            PaymentReqHeaderArchive.TransferFields(PaymentRequest);
            PaymentReqHeaderArchive.Insert;

            PaymentReqHeaderArchive.CopyLinks(PaymentRequest);
            CopyCommentLines(
              0, 5,
              "No.", PaymentReqHeaderArchive."No.");

            ApprovalMgt.PostApprovalEntries(RecordId, PaymentReqHeaderArchive.RecordId, PaymentReqHeaderArchive."No.");
            ApprovalMgt.DeleteApprovalEntries(RecordId);

            PaymentReqLine.SetRange("Document No.", "No.");
            if PaymentReqLine.FindSet then
                repeat
                    PaymentReqLineArchive.TransferFields(PaymentReqLine);
                    PaymentReqLineArchive.Insert;

                    if PaymentReqLine.HasLinks then
                        PaymentReqLine.DeleteLinks;
                    with PaymentReqLine do begin
                        if ("Account Type" = "account type"::"G/L Account") and (PmtMgtSetup."Budget Expense Control Enabled") then
                            BudgetControlMgt.DeleteCommitment("Document No.", "Line No.", "Account No.");
                    end;
                until PaymentReqLine.Next = 0;

            PaymentReqLine.DeleteAll;
            PaymentComment.SetRange("Table Name", PaymentComment."table name"::"Payment Request");
            PaymentComment.SetRange("No.", "No.");
            if not PaymentComment.IsEmpty then
                PaymentComment.DeleteAll;

            if HasLinks then
                DeleteLinks;
            Delete;
        end;
    end;

    local procedure CopyCommentLines(FromDocumentType: Option "Payment Request","Payment Voucher","Cash Advance","Cash Adv. Retirement","Cash Receipt","Archived Payment Request","Posted Payment Voucher","Posted Cash Advance","Posted Retirement","Posted Cash Receipt"; ToDocumentType: Option "Payment Request","Payment Voucher","Cash Advance","Cash Adv. Retirement","Cash Receipt","Archived Payment Request","Posted Payment Voucher","Posted Cash Advance","Posted Retirement","Posted Cash Receipt"; FromNumber: Code[20]; ToNumber: Code[20])
    begin
        PaymentComment.SetRange("Table Name", FromDocumentType);
        PaymentComment.SetRange("No.", FromNumber);
        if PaymentComment.FindSet then
            repeat
                PaymentComment2.TransferFields(PaymentComment);
                PaymentComment2."Table Name" := ToDocumentType;
                PaymentComment2."No." := ToNumber;
                PaymentComment2.Insert;
            until PaymentComment.Next = 0;
    end;


    procedure VoidRequest(var PaymentRequest: Record "Payment Request Header")
    var
        PaymentReqHeaderArchive: Record "Payment Request Header Archive";
        PaymentReqLineArchive: Record "Payment Request Line Archive";
    begin
        if not Confirm(VoidText, false) then
            exit;
        CheckFloatReimbment(PaymentRequest);
        PaymentRequest.Status := PaymentRequest.Status::Voided;
        PaymentRequest."Voided By" := UserId;
        PaymentRequest.Modify;
        ArchivePaymentRequest(PaymentRequest);
    end;


    procedure GetPaymentRquest(var PaymentRequest: Record "Payment Request Header")
    var
        PPaymentRequest: Record "Payment Request Header Archive";
        PPaymentRequestList: Page "Payment Request Archive List";
    begin
        PaymentRequest.TestField(Status, PaymentRequest.Status::Open);
        PPaymentRequest.SetRange("Document Type", PPaymentRequest."document type"::"Float Account");
        PPaymentRequest.SetRange(Status, PPaymentRequest.Status::Approved);
        PPaymentRequest.SetRange("Retirement Status", PPaymentRequest."retirement status"::Open);
        PPaymentRequest.SetFilter("Retirement No.", '%1', '');

        Clear(PPaymentRequestList);
        PPaymentRequestList.LookupMode := true;
        PPaymentRequestList.SetTableview(PPaymentRequest);
        PPaymentRequestList.SetPaymentReqHeader(PaymentRequest);
        PPaymentRequestList.RunModal;
    end;


    procedure SetPaymentReqHeader(lPaymentReqHeader: Record "Payment Request Header")
    begin
        PaymentReqHeader := lPaymentReqHeader;
    end;


    procedure CreatePayReqLines(var PPaymentReqHeader: Record "Payment Request Header Archive")
    var
        PaymentReqLine: Record "Payment Request Line";
    begin
        with PPaymentReqHeader do begin
            PaymentReqLine.SetRange("Document Type", PaymentReqHeader."Document Type");
            PaymentReqLine.SetRange("Document No.", PaymentReqHeader."No.");
            PaymentReqLine."Document Type" := PaymentReqHeader."Document Type";
            PaymentReqLine."Document No." := PaymentReqHeader."No.";
            if PPaymentReqHeader.FindSet then
                repeat
                    PPaymentReqHeader.InsertReqLineFromArchLine(PaymentReqLine);
                    PPaymentReqHeader."Retirement No." := PaymentReqHeader."No.";
                    PPaymentReqHeader.Modify;
                until PPaymentReqHeader.Next = 0;
        end;
    end;


    procedure PostRequest(var PaymentRequest: Record "Payment Request Header")
    begin
        if not Confirm(Text104, false) then
            exit;
        PaymentRequest."Payment Date" := Today;
        PaymentRequest."Entry Status" := PaymentRequest."entry status"::Posted;
        PaymentRequest."Posted By" := UserId;
        PaymentRequest.Modify;
        ArchivePaymentRequest(PaymentRequest);
        Message(Text105);
    end;

    local procedure CheckFloatReimbment(PaymentRequest: Record "Payment Request Header")
    var
        PPaymentRequest: Record "Payment Request Header Archive";
    begin
        PPaymentRequest.SetRange("Document Type", PPaymentRequest."document type"::"Float Account");
        PPaymentRequest.SetRange("Retirement No.", PaymentRequest."No.");
        PPaymentRequest.ModifyAll("Retirement No.", '');
    end;

    local procedure UpdatePostedFloat(PaymentRequest: Record "Payment Request Header")
    var
        PPaymentRequest: Record "Payment Request Header Archive";
    begin
        if PaymentRequest."Request Type" <> PaymentRequest."request type"::"Float Reimbursement" then
            exit;
        PPaymentRequest.SetRange("Document Type", PPaymentRequest."document type"::"Float Account");
        PPaymentRequest.SetRange("Retirement No.", PaymentRequest."No.");
        PPaymentRequest.ModifyAll("Retirement Status", PPaymentRequest."retirement status"::Retired);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreatePaymentDocument(var PaymentRequest: Record "Payment Request Header"; var PaymentHeader: Record "Payment Header")
    begin
    end;
}

