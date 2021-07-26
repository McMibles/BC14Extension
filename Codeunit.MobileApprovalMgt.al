Codeunit 52092193 "Mobile Approval Mgt."
{
    // Payment Request
    // Cash Advances & Retirements
    // Leave
    // Loan
    // Approvals (Send,Delegate,Reject, Approve & Cancel)
    // Self Appraisals
    // Queries
    // Payslip & Leave Balances


    trigger OnRun()
    begin
    end;

    var
        NAVMobileUserSetup: Record "NAV Mobile User Setup";
        ApprovalEntry: Record "Approval Entry";
        SalesLines: Record "Sales Line";
        PurchaseLines: Record "Purchase Line";
        ApprovalMgt: Codeunit "Approvals Hook";
        Text000: label 'Sales Document %1.';
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;


    procedure ApproveDocument(TableID: Integer;DocType: Integer;DocNo: Code[20];SequenceNo: Integer;MobileSenderID: Code[50];UserRef: Code[50]): Boolean
    begin
        ApprovalEntry.SetCurrentkey("Table ID","Document Type","Document No.","Sequence No.","Record ID to Approve");
        ApprovalEntry.SetRange("Table ID",TableID);
        ApprovalEntry.SetRange("Document No.",DocNo);
        ApprovalEntry.SetRange(Status,ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Approver ID",UserRef);
        ApprovalEntry.FindFirst;
        UpdateMobileUserSetup(MobileSenderID,UserRef,ApprovalEntry."Record ID to Approve");
        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
        exit(true);
    end;


    procedure DelegateDocument(TableID: Integer;DocType: Integer;DocNo: Code[20];SequenceNo: Integer;MobileSenderID: Code[50];UserRef: Code[50]): Boolean
    begin
        ApprovalEntry.SetCurrentkey("Table ID","Document Type","Document No.","Sequence No.","Record ID to Approve");
        ApprovalEntry.SetRange("Table ID",TableID);
        ApprovalEntry.SetRange("Document No.",DocNo);
        ApprovalEntry.SetRange(Status,ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Approver ID",UserRef);
        ApprovalEntry.FindFirst;
        UpdateMobileUserSetup(MobileSenderID,UserRef,ApprovalEntry."Record ID to Approve");
        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
        exit(true);
    end;


    procedure RejectDocument(TableID: Integer;DocType: Integer;DocNo: Code[20];SequenceNo: Integer;MobileSenderID: Code[50];UserRef: Code[50]): Boolean
    begin
        ApprovalEntry.SetCurrentkey("Table ID","Document Type","Document No.","Sequence No.","Record ID to Approve");
        ApprovalEntry.SetRange("Table ID",TableID);
        ApprovalEntry.SetRange("Document No.",DocNo);
        ApprovalEntry.SetRange(Status,ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Approver ID",UserRef);
        ApprovalEntry.FindFirst;
        UpdateMobileUserSetup(MobileSenderID,UserRef,ApprovalEntry."Record ID to Approve");
        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
        exit(true);
    end;


    procedure ShowDocument(TableID: Integer;DocType: Integer;DocNo: Code[20];SequenceNo: Integer)
    begin
    end;


    procedure SendDocumentForApproval(TableID: Integer;DocType: Integer;DocNo: Code[20];MobileSenderID: Code[50];UserRef: Code[50];"Action": Integer) Successful: Boolean
    var
        ApprovalMgtHook: Codeunit "Approvals Hook";
        paymentRequestHeader: Record "Payment Request Header";
    begin
        Successful := false;
        /*1 - ApprovalEntry,2-Cancel,3-Delegate,4-RejectD*/
        case TableID of
          Database::"Payment Request Header":begin
            paymentRequestHeader.Get(DocType,DocNo);
            RecRef.GetTable(paymentRequestHeader);
            UpdateMobileUserSetup(MobileSenderID,UserRef,RecRef.RecordId);
            case Action of
              1:begin
                  paymentRequestHeader.CheckEntryForApproval;
                  if ApprovalMgt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                    ApprovalMgt.OnSendGenericDocForApproval(RecRef);
                end;
              2:begin
                  ApprovalMgt.OnCancelGenericDocForApproval(RecRef);
                end;
           end;
          end;
          /*DATABASE::"Employee Leave":BEGIN
            EmployeeLeave.GET(DocNo);
            RecRef.GETTABLE(EmployeeLeave);
            ApprovalMgtHook.SetMobileUser(UserRef);
            EmployeeLeave.CheckLeaveApprovalEntry;
            IF Action = 0 THEN BEGIN
              IF ApprovalMgtHook.GetGenericRecord(DATABASE::"Employee Leave",0,TRUE,FALSE,RecRef) THEN;
            END ELSE
              IF ApprovalMgtHook.GetGenericRecord(DATABASE::"Employee Leave",1,TRUE,FALSE,RecRef) THEN;
            EmployeeLeave.GET(DocNo);
            EXIT(EmployeeLeave.Status = EmployeeLeave.Status::"Pending Approval");*/
        end;
        Clear(ApprovalMgt);
        DeleMobileUser(MobileSenderID,RecRef.RecordId);
        Successful := true;

    end;

    local procedure UpdateMobileUserSetup(MobileSender: Code[50];UserName: Code[50];CurrentRecordID: RecordID)
    begin
        if not NAVMobileUserSetup.Get(MobileSender,CurrentRecordID) then begin
          NAVMobileUserSetup.Init;
          NAVMobileUserSetup."Record ID to Approve" := CurrentRecordID;
          NAVMobileUserSetup."Mobile Administrator ID" := MobileSender;
          NAVMobileUserSetup."Mobile User ID" := UserName;
          NAVMobileUserSetup.Insert;
        end else begin
          if NAVMobileUserSetup."Mobile User ID" = UserName then
            exit;
          NAVMobileUserSetup."Mobile User ID" := UserName;
          NAVMobileUserSetup.Modify;
        end;
    end;

    local procedure DeleMobileUser(MobileSender: Code[50];CurrentRecordID: RecordID)
    begin
        if NAVMobileUserSetup.Get(MobileSender,CurrentRecordID) then
          NAVMobileUserSetup.Delete;
    end;
}

