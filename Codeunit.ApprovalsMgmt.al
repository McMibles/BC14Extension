Codeunit 52001535 "Approvals Mgmt.1535"
{
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowManagement: Codeunit "Workflow Management";
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
        MobileUserSetup: Record "NAV Mobile User Setup";


        UserIdNotInSetupErr: Label 'User ID %1 does not exist in the Approval User Setup window.';
        ApproverUserIdNotInSetupErr: Label 'You must set up an approver for user ID %1 in the Approval User Setup window.';
        WFUserGroupNotInSetupErr: Label 'The workflow user group member with user ID %1 does not exist in the Approval User Setup window.';
        SubstituteNotFoundErr: Label 'There is no substitute, direct approver, or approval administrator for user ID %1 in the Approval User Setup window.';
        NoSuitableApproverFoundErr: Label 'No qualified approver was found.';
        DelegateOnlyOpenRequestsErr: Label 'You can only delegate open approval requests.';
        ApproveOnlyOpenRequestsErr: Label 'You can only approve open approval requests.';
        RejectOnlyOpenRequestsErr: Label 'You can only reject open approval entries.';
        ApprovalsDelegatedMsg: Label 'The selected approval requests have been delegated.';
        NoReqToApproveErr: Label 'There is no approval request to approve.';
        NoReqToRejectErr: Label 'There is no approval request to reject.';
        NoReqToDelegateErr: Label 'There is no approval request to delegate.';
        PendingApprovalMsg: Label 'An approval request has been sent.';
        NoApprovalsSentMsg: Label 'No approval requests have been sent, either because they are already sent or because related workflows do not support the journal line.';
        PendingApprovalForSelectedLinesMsg: Label 'Approval requests have been sent.';
        PendingApprovalForSomeSelectedLinesMsg: Label 'Approval requests have been sent.\\Requests for some journal lines were not sent, either because they are already sent or because related workflows do not support the journal line.';
        PurchaserUserNotFoundErr: Label 'The salesperson/purchaser user ID %1 does not exist in the Approval User Setup window for %2 %3.';
        NoApprovalRequestsFoundErr: Label 'No approval requests exist.';
        NoWFUserGroupMembersErr: Label 'A workflow user group with at least one member must be set up.';
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.';
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.';
        SalesPrePostCheckErr: Label 'Sales %1 %2 must be approved and released before you can perform this action.';
        PurchPrePostCheckErr: Label 'Purchase %1 %2 must be approved and released before you can perform this action.';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ApprovalReqCanceledForSelectedLinesMsg: Label 'The approval request for the selected record has been canceled.';
        PendingJournalBatchApprovalExistsErr: Label 'An approval request already exists.';
        ApporvalChainIsUnsupportedMsg: Label 'Only Direct Approver is supported as Approver Limit Type option for %1. The approval request will be approved automatically.';
        RecHasBeenApprovedMsg: Label '%1 has been approved.';
        NoPermissionToDelegateErr: Label 'You do not have permission to delegate one or more of the selected approval requests.';
        NothingToApproveErr: Label 'There is nothing to approve.';
        ApproverChainErr: Label 'No sufficient approver was found in the approver chain.';

    local Procedure ApproveSelectedApprovalRequest(VAR
                                                       ApprovalEntry: Record "Approval Entry")
    var

    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(ApproveOnlyOpenRequestsErr);

        IF NOT UserIsMobileOperator THEN BEGIN
            IF ApprovalEntry."Approver ID" <> USERID THEN
                CheckUserAsApprovalAdministrator(ApprovalEntry);
        END ELSE BEGIN
            GetMobileUser(ApprovalEntry."Record ID to Approve");
            IF ApprovalEntry."Approver ID" <> MobileUserSetup."Mobile User ID" THEN
                CheckUserAsApprovalAdministrator(ApprovalEntry);
        END;

        ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Approved);
        ApprovalEntry.MODIFY(TRUE);
        OnApproveApprovalRequestHook(ApprovalEntry);
        ApprovalMgmt.OnApproveApprovalRequest(ApprovalEntry);
    end;

    Procedure RejectSelectedApprovalRequest(VAR ApprovalEntry: Record "Approval Entry")
    var

    begin
        IF ApprovalEntry.Status <> ApprovalEntry.Status::Open THEN
            ERROR(RejectOnlyOpenRequestsErr);

        IF NOT UserIsMobileOperator THEN BEGIN
            IF ApprovalEntry."Approver ID" <> USERID THEN;
            //CheckUserAsApprovalAdministrator(ApprovalEntry);
        END ELSE BEGIN
            MobileUserSetup.GET(USERID, ApprovalEntry."Record ID to Approve");
            IF ApprovalEntry."Approver ID" <> MobileUserSetup."Mobile User ID" THEN
                CheckUserAsApprovalAdministrator(ApprovalEntry);
        END;

        ApprovalMgmt.OnRejectApprovalRequest(ApprovalEntry);
        ApprovalEntry.GET(ApprovalEntry."Entry No.");
        ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Rejected);
        ApprovalEntry.MODIFY(TRUE);

    end;

    procedure FindOpenApprovalEntryForCurrUser(VAR ApprovalEntry: Record "Approval Entry"; RecordID: RecordId): Boolean

    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        IF NOT UserIsMobileOperator THEN
            ApprovalEntry.SETRANGE("Approver ID", USERID)
        ELSE BEGIN
            IF MobileUserSetup.GET(USERID, RecordID) THEN BEGIN
                MobileUserSetup.TESTFIELD("Mobile User ID");
                ApprovalEntry.SETRANGE("Approver ID", MobileUserSetup."Mobile User ID");
            END ELSE
                ApprovalEntry.SETRANGE("Approver ID", USERID);

        END;
        ApprovalEntry.SETRANGE("Related to Change", FALSE);

        EXIT(ApprovalEntry.FINDFIRST);

    end;

    Procedure FindApprovalEntryForCurrUser(VAR ApprovalEntry: Record "Approval Entry"; RecordID: RecordId): Boolean
    var

    begin
        ApprovalEntry.SETRANGE("Table ID", RecordID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecordID);
        IF NOT UserIsMobileOperator THEN
            ApprovalEntry.SETRANGE("Approver ID", USERID)
        ELSE BEGIN
            IF MobileUserSetup.GET(USERID, RecordID) THEN BEGIN
                MobileUserSetup.TESTFIELD("Mobile Administrator ID");
                ApprovalEntry.SETRANGE("Approver ID", MobileUserSetup."Mobile User ID");
            END ELSE
                ApprovalEntry.SETRANGE("Approver ID", USERID);
        END;

        EXIT(ApprovalEntry.FINDFIRST);
    end;

    Procedure RejectApprovalRequestsForRecord(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalEntry: Record "Approval Entry";
        OldStatus: Option;
    begin
        ApprovalEntry.SETCURRENTKEY("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry.SETRANGE("Table ID", RecRef.NUMBER);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecRef.RECORDID);
        ApprovalEntry.SETFILTER(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
        ApprovalEntry.SETRANGE("Workflow Step Instance ID", WorkflowStepInstance.ID);
        IF ApprovalEntry.FINDSET(TRUE) THEN BEGIN
            REPEAT
                OldStatus := ApprovalEntry.Status;
                ApprovalEntry.VALIDATE(Status, ApprovalEntry.Status::Rejected);
                ApprovalEntry.MODIFY(TRUE);
                IF (OldStatus IN [ApprovalEntry.Status::Open, ApprovalEntry.Status::Approved]) AND
                (ApprovalEntry."Approver ID" <> USERID)
                THEN
                    ApprovalMgmt.CreateApprovalEntryNotification(ApprovalEntry, WorkflowStepInstance);
            UNTIL ApprovalEntry.NEXT = 0;
            ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Rejected);
            IF (ApprovalEntry."Approval Type" = ApprovalEntry."Approval Type"::Approver) AND
                (ApprovalEntry.COUNT = 1)
            THEN BEGIN
                ApprovalEntry."Approver ID" := ApprovalEntry."Sender ID";
                ApprovalMgmt.CreateApprovalEntryNotification(ApprovalEntry, WorkflowStepInstance);
            END;
        END;
    end;

    local procedure CreateApprovalRequestForApproverChain(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry"; SufficientApproverOnly: Boolean)
    var
        ApprovalEntry: Record "Approval Entry";
        UserSetup: Record "User Setup";
        ApproverId: Code[50];
        SequenceNo: Integer;
        MaxCount: Integer;
        i: Integer;
    begin
        IF NOT UserIsMobileOperator THEN
            ApproverId := USERID
        ELSE BEGIN
            GetMobileUser(ApprovalEntryArgument."Record ID to Approve");
            ApproverId := MobileUserSetup."Mobile User ID";
        END;

        WITH ApprovalEntry DO BEGIN
            SETCURRENTKEY("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.");
            SETRANGE("Table ID", ApprovalEntryArgument."Table ID");
            SETRANGE("Record ID to Approve", ApprovalEntryArgument."Record ID to Approve");
            SETRANGE("Workflow Step Instance ID", ApprovalEntryArgument."Workflow Step Instance ID");
            SETRANGE(Status, Status::Created);
            IF FINDLAST THEN
                ApproverId := "Approver ID"
            ELSE
                IF (WorkflowStepArgument."Approver Type" = WorkflowStepArgument."Approver Type"::"Salesperson/Purchaser") AND
                   (WorkflowStepArgument."Approver Limit Type" = WorkflowStepArgument."Approver Limit Type"::"First Qualified Approver")
                THEN BEGIN
                    //FindUserSetupBySalesPurchCode(UserSetup, ApprovalEntryArgument);
                    ApproverId := UserSetup."User ID";
                END;
        END;

        UserSetup.RESET;
        MaxCount := UserSetup.COUNT;

        IF NOT UserSetup.GET(ApproverId) THEN
            ERROR(ApproverUserIdNotInSetupErr, ApprovalEntry."Sender ID");

        IF NOT ApprovalMgmt.IsSufficientApprover(UserSetup, ApprovalEntryArgument) THEN
            REPEAT
                i += 1;
                IF i > MaxCount THEN
                    ERROR(ApproverChainErr);
                ApproverId := UserSetup."Approver ID";

                IF ApproverId = '' THEN
                    ERROR(NoSuitableApproverFoundErr);

                IF NOT UserSetup.GET(ApproverId) THEN
                    ERROR(ApproverUserIdNotInSetupErr, UserSetup."User ID");

                // Approval Entry should not be created only when IsSufficientApprover is false and SufficientApproverOnly is true
                IF ApprovalMgmt.IsSufficientApprover(UserSetup, ApprovalEntryArgument) OR (NOT SufficientApproverOnly) THEN BEGIN
                    SequenceNo := ApprovalMgmt.GetLastSequenceNo(ApprovalEntryArgument) + 1;
                    MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, ApproverId, WorkflowStepArgument);
                END;

            UNTIL ApprovalMgmt.IsSufficientApprover(UserSetup, ApprovalEntryArgument);
    end;

    local procedure CreateApprovalRequestForApprover(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        UsrId: Code[50];
        SequenceNo: Integer;
    begin
        UsrId := USERID;
        IF UserIsMobileOperator THEN BEGIN
            MobileUserSetup.GET(USERID, ApprovalEntryArgument."Record ID to Approve");
            MobileUserSetup.TESTFIELD("Mobile Administrator ID");
            UsrId := MobileUserSetup."Mobile User ID";
        END;

        SequenceNo := ApprovalMgmt.GetLastSequenceNo(ApprovalEntryArgument);

        IF NOT UserSetup.GET(USERID) THEN
            ERROR(UserIdNotInSetupErr, UsrId);

        UsrId := UserSetup."Approver ID";
        IF NOT UserSetup.GET(UsrId) THEN BEGIN
            IF NOT UserSetup."Approval Administrator" THEN
                ERROR(ApproverUserIdNotInSetupErr, UserSetup."User ID");
            UsrId := USERID;
            IF MobileUserSetup."Mobile User ID" <> '' THEN
                UsrId := MobileUserSetup."Mobile User ID";
        END;

        SequenceNo += 1;
        MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, UsrId, WorkflowStepArgument);
    end;

    Procedure CreateApprovalRequestForUser(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    var
        SequenceNo: Integer;
    begin
        SequenceNo := ApprovalMgmt.GetLastSequenceNo(ApprovalEntryArgument);

        SequenceNo += 1;
        IF NOT UserIsMobileOperator THEN
            MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, USERID, WorkflowStepArgument)
        ELSE BEGIN
            MobileUserSetup.GET(USERID, ApprovalEntryArgument."Record ID to Approve");
            MobileUserSetup.TESTFIELD("Mobile Administrator ID");
            MakeApprovalEntry(ApprovalEntryArgument, SequenceNo, MobileUserSetup."Mobile User ID", WorkflowStepArgument);
        END;
    end;

    Procedure MakeApprovalEntry(ApprovalEntryArgument: Record "Approval Entry"; SequenceNo: Integer; ApproverId: Code[50]; WorkflowStepArgument: Record "Workflow Step Argument")
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WITH ApprovalEntry DO BEGIN
            "Table ID" := ApprovalEntryArgument."Table ID";
            "Document Type" := ApprovalEntryArgument."Document Type";
            "Document No." := ApprovalEntryArgument."Document No.";
            "Salespers./Purch. Code" := ApprovalEntryArgument."Salespers./Purch. Code";
            "Sequence No." := SequenceNo;
            "Sender ID" := USERID;
            IF UserIsMobileOperator THEN BEGIN
                MobileUserSetup.GET(USERID, ApprovalEntryArgument."Record ID to Approve");
                MobileUserSetup.TESTFIELD("Mobile Administrator ID");
                "Sender ID" := MobileUserSetup."Mobile User ID";
            END;
            Amount := ApprovalEntryArgument.Amount;
            "Amount (LCY)" := ApprovalEntryArgument."Amount (LCY)";
            "Currency Code" := ApprovalEntryArgument."Currency Code";
            "Approver ID" := ApproverId;
            "Workflow Step Instance ID" := ApprovalEntryArgument."Workflow Step Instance ID";
            IF ApproverId = USERID THEN
                Status := Status::Approved
            ELSE
                Status := Status::Created;
            "Date-Time Sent for Approval" := CREATEDATETIME(TODAY, TIME);
            "Last Date-Time Modified" := CREATEDATETIME(TODAY, TIME);
            "Last Modified By User ID" := USERID;
            "Due Date" := CALCDATE(WorkflowStepArgument."Due Date Formula", TODAY);

            CASE WorkflowStepArgument."Delegate After" OF
                WorkflowStepArgument."Delegate After"::Never:
                    EVALUATE("Delegation Date Formula", '');
                WorkflowStepArgument."Delegate After"::"1 day":
                    EVALUATE("Delegation Date Formula", '<1D>');
                WorkflowStepArgument."Delegate After"::"2 days":
                    EVALUATE("Delegation Date Formula", '<2D>');
                WorkflowStepArgument."Delegate After"::"5 days":
                    EVALUATE("Delegation Date Formula", '<5D>');
                ELSE
                    EVALUATE("Delegation Date Formula", '');
            END;
            "Available Credit Limit (LCY)" := ApprovalEntryArgument."Available Credit Limit (LCY)";
            //SetApproverType(WorkflowStepArgument, ApprovalEntry);
            //SetLimitType(WorkflowStepArgument, ApprovalEntry);
            "Record ID to Approve" := ApprovalEntryArgument."Record ID to Approve";
            "Approval Code" := ApprovalEntryArgument."Approval Code";
            //OnBeforeApprovalEntryInsert(ApprovalEntry, ApprovalEntryArgument);
            INSERT(TRUE);
        END;

    end;

    local procedure PopulateApprovalEntryArgument(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; VAR ApprovalEntryArgument: Record "Approval Entry")
    var
        Customer: Record Customer;
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        IncomingDocument: Record "Incoming Document";
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
    begin
        ApprovalEntryArgument.INIT;
        ApprovalEntryArgument."Table ID" := RecRef.NUMBER;
        ApprovalEntryArgument."Record ID to Approve" := RecRef.RECORDID;
        ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::"Return Order";
        ApprovalEntryArgument."Approval Code" := WorkflowStepInstance."Workflow Code";
        ApprovalEntryArgument."Workflow Step Instance ID" := WorkflowStepInstance.ID;

        CASE RecRef.NUMBER OF
            DATABASE::"Purchase Header":
                BEGIN
                    RecRef.SETTABLE(PurchaseHeader);
                    ApprovalMgmt.CalcPurchaseDocAmount(PurchaseHeader, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := PurchaseHeader."Document Type";
                    ApprovalEntryArgument."Document No." := PurchaseHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := PurchaseHeader."Purchaser Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := PurchaseHeader."Currency Code";
                END;
            DATABASE::"Sales Header":
                BEGIN
                    RecRef.SETTABLE(SalesHeader);
                    ApprovalMgmt.CalcSalesDocAmount(SalesHeader, ApprovalAmount, ApprovalAmountLCY);
                    ApprovalEntryArgument."Document Type" := SalesHeader."Document Type";
                    ApprovalEntryArgument."Document No." := SalesHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := SalesHeader."Salesperson Code";
                    ApprovalEntryArgument.Amount := ApprovalAmount;
                    ApprovalEntryArgument."Amount (LCY)" := ApprovalAmountLCY;
                    ApprovalEntryArgument."Currency Code" := SalesHeader."Currency Code";
                    ApprovalEntryArgument."Available Credit Limit (LCY)" := GetAvailableCreditLimit(SalesHeader);
                END;
            DATABASE::Customer:
                BEGIN
                    RecRef.SETTABLE(Customer);
                    ApprovalEntryArgument."Salespers./Purch. Code" := Customer."Salesperson Code";
                    ApprovalEntryArgument."Currency Code" := Customer."Currency Code";
                    ApprovalEntryArgument."Available Credit Limit (LCY)" := Customer.CalcAvailableCredit;
                END;
            DATABASE::"Gen. Journal Batch":
                RecRef.SETTABLE(GenJournalBatch);
            DATABASE::"Gen. Journal Line":
                BEGIN
                    RecRef.SETTABLE(GenJournalLine);
                    ApprovalEntryArgument."Document Type" := GenJournalLine."Document Type";
                    ApprovalEntryArgument."Document No." := GenJournalLine."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := GenJournalLine."Salespers./Purch. Code";
                    ApprovalEntryArgument.Amount := GenJournalLine.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := GenJournalLine."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := GenJournalLine."Currency Code";
                END;
            DATABASE::"Incoming Document":
                BEGIN
                    RecRef.SETTABLE(IncomingDocument);
                    ApprovalEntryArgument."Document No." := FORMAT(IncomingDocument."Entry No.");
                END;
            ELSE
        //OnPopulateApprovalEntryArgument(RecRef, ApprovalEntryArgument, WorkflowStepInstance);
        END;

    end;

    procedure CanCancelApprovalForRecord(RecID: RecordID): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
        UserSetup: Record "User Setup";
        UsrId: Code[50];
    begin
        UsrId := USERID;
        IF UserIsMobileOperator THEN BEGIN
            ApprovalEntry.SETRANGE("Table ID", RecID.TABLENO);
            ApprovalEntry.SETRANGE("Record ID to Approve", RecID);
            ApprovalEntry.FINDFIRST;
            GetMobileUser(ApprovalEntry."Record ID to Approve");
            UsrId := MobileUserSetup."Mobile User ID";
        END;

        IF NOT UserSetup.GET(USERID) THEN
            EXIT(FALSE);

        ApprovalEntry.SETRANGE("Table ID", RecID.TABLENO);
        ApprovalEntry.SETRANGE("Record ID to Approve", RecID);
        ApprovalEntry.SETFILTER(Status, '%1|%2', ApprovalEntry.Status::Created, ApprovalEntry.Status::Open);
        ApprovalEntry.SETRANGE("Related to Change", FALSE);

        IF NOT UserSetup."Approval Administrator" THEN
            ApprovalEntry.SETRANGE("Sender ID", USERID);
        EXIT(ApprovalEntry.FINDFIRST);

    end;

    local procedure CheckUserAsApprovalAdministrator(ApprovalEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        //ApprovalMgmt.OnBeforeCheckUserAsApprovalAdministrator(ApprovalEntry, IsHandled);
        IF IsHandled THEN
            EXIT;

        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Approval Administrator");
    end;

    local procedure GetAvailableCreditLimit(SalesHeader: Record "Sales Header"): Decimal

    begin
        EXIT(SalesHeader.CheckAvailableCreditLimit);
    end;

    PROCEDURE UserIsMobileOperator(): Boolean;
    VAR
        UserSetup: Record "User Setup";
    BEGIN
        UserSetup.GET(USERID);
        EXIT(UserSetup."Mobile User Administrator");
    END;

    LOCAL PROCEDURE GetMobileUser(CurrentRecordID: RecordID);
    BEGIN
        CLEAR(MobileUserSetup);
        IF UserIsMobileOperator THEN BEGIN
            MobileUserSetup.GET(USERID, CurrentRecordID);
            MobileUserSetup.TESTFIELD("Mobile User ID");
        END;
    END;

    [IntegrationEvent(true, false)]
    PROCEDURE OnApproveApprovalRequestHook(VAR ApprovalEntry: Record "Approval Entry");
    BEGIN
    END;
}

