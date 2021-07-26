Codeunit 52092194 "ESS Portal Management"
{

    trigger OnRun()
    begin
        //GetProfilePicture('JR');
    end;

    var
        Text001: label 'This is to notify you that you have been issued a query for %1. You must respond to the query on or before %2';
        Text002: label 'Nothing to submit\Explanation must be given';
        Text009: label 'Leave Schedule not approved, application cannot be created';
        Text010: label 'This schedule have been exhausted, application cannot be created';
        Text013: label 'Prior schedules not yet exhausted. Application not allowed.';
        Text016: label 'Leave Schedule must be open for this action to go through';
        Text017: label 'Nothing to recall';
        Text018: label 'This leave has been utilised, recall not allowed';

    procedure ReopenSelectedRecord(TabID: Integer; DocNo: Code[50]; DocType: Integer; YearNo: Integer; EmpNo: Code[20]; WkshName: Code[10]) Successful: Boolean
    var
        RecRef: RecordRef;
        ReleaseDocument: Codeunit "Release Documents";
        Employee: Record Employee;
        PaymentHeader: Record "Payment Header";
        CashReceiptHeader: Record "Cash Receipt Header";
        PayrollLoan: Record "Payroll-Loan";
        LeaveScheduleHeader: Record "Leave Schedule Header";
        LeaveApplication: Record "Leave Application";
        EmployeeRequisition: Record "Employee Requisition";
        EmployeeExit: Record "Employee Exit";
        AppraisalHeader: Record "Appraisal Header";
        PurchRequisition: Record "Requisition Wksh. Name";
        PurchaseReqHeader: Record "Purchase Req. Header";
        //StockTransactionHeader: Record "Stock Transaction Header";
        PaymentRequestHeader: Record "Payment Request Header";
    begin
        Successful := false;
        case TabID of
            Database::Employee:
                begin
                    Employee.Get(DocNo);
                    RecRef.GetTable(Employee);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Payment Header":
                begin
                    PaymentHeader.Get(DocType, DocNo);
                    RecRef.GetTable(PaymentHeader);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Payment Request Header":
                begin
                    PaymentRequestHeader.Get(DocType, DocNo);
                    RecRef.GetTable(PaymentRequestHeader);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Cash Receipt Header":
                begin
                    CashReceiptHeader.Get(DocNo);
                    RecRef.GetTable(CashReceiptHeader);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Payroll-Loan":
                begin
                    PayrollLoan.Get(DocNo);
                    RecRef.GetTable(PayrollLoan);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Leave Schedule Header":
                begin
                    LeaveScheduleHeader.Get(YearNo, EmpNo, DocNo);
                    RecRef.GetTable(LeaveScheduleHeader);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Leave Application":
                begin
                    LeaveApplication.Get(DocNo);
                    RecRef.GetTable(LeaveApplication);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Employee Requisition":
                begin
                    EmployeeRequisition.Get(DocNo);
                    RecRef.GetTable(EmployeeRequisition);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Employee Exit":
                begin
                    EmployeeExit.Get(DocNo);
                    RecRef.GetTable(EmployeeExit);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Appraisal Header":
                begin
                    AppraisalHeader.Get(DocNo, DocType, EmpNo);
                    RecRef.GetTable(AppraisalHeader);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Requisition Wksh. Name":
                begin
                    PurchRequisition.Get(WkshName, DocNo);
                    RecRef.GetTable(PurchRequisition);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
            Database::"Purchase Req. Header":
                begin
                    PurchaseReqHeader.Get(WkshName, DocNo);
                    RecRef.GetTable(PurchaseReqHeader);
                    ReleaseDocument.PerformManualReopen(RecRef);
                    Successful := true;
                end;
        /*Database::"Stock Transaction Header":
            begin
                StockTransactionHeader.Get(DocType, DocNo);
                RecRef.GetTable(StockTransactionHeader);
                ReleaseDocument.PerformManualReopen(RecRef);
                Successful := true;
            end;*/
        end;
        Clear(ReleaseDocument);
    end;

    procedure SendSelectedRecordForApproval(TabID: Integer; DocNo: Code[50]; DocType: Integer; YearNo: Integer; EmpNo: Code[20]; WkshName: Code[10]; MobileSenderID: Code[50]; UserRef: Code[50]) Successful: Boolean
    var
        RecRef: RecordRef;
        Employee: Record Employee;
        PaymentHeader: Record "Payment Header";
        CashReceiptHeader: Record "Cash Receipt Header";
        PayrollLoan: Record "Payroll-Loan";
        LeaveScheduleHeader: Record "Leave Schedule Header";
        LeaveApplication: Record "Leave Application";
        EmployeeRequisition: Record "Employee Requisition";
        EmployeeExit: Record "Employee Exit";
        AppraisalHeader: Record "Appraisal Header";
        PurchRequisition: Record "Requisition Wksh. Name";
        PurchaseReqHeader: Record "Purchase Req. Header";
        //StockTransactionHeader: Record "Stock Transaction Header";
        ApprovalsMgmt: Codeunit "Approvals Hook";
        PaymentRequestHeader: Record "Payment Request Header";
    begin
        Successful := false;
        case TabID of
            Database::Employee:
                begin
                    Employee.Get(DocNo);
                    RecRef.GetTable(Employee);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Payment Header":
                begin
                    PaymentHeader.Get(DocType, DocNo);
                    RecRef.GetTable(PaymentHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Payment Request Header":
                begin
                    PaymentRequestHeader.Get(DocType, DocNo);
                    RecRef.GetTable(PaymentRequestHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Cash Receipt Header":
                begin
                    CashReceiptHeader.Get(DocNo);
                    RecRef.GetTable(CashReceiptHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Payroll-Loan":
                begin
                    PayrollLoan.Get(DocNo);
                    RecRef.GetTable(PayrollLoan);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Leave Schedule Header":
                begin
                    LeaveScheduleHeader.Get(YearNo, EmpNo, DocNo);
                    RecRef.GetTable(LeaveScheduleHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Leave Application":
                begin
                    LeaveApplication.Get(DocNo);
                    RecRef.GetTable(LeaveApplication);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Employee Requisition":
                begin
                    EmployeeRequisition.Get(DocNo);
                    RecRef.GetTable(EmployeeRequisition);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Employee Exit":
                begin
                    EmployeeExit.Get(DocNo);
                    RecRef.GetTable(EmployeeExit);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Appraisal Header":
                begin
                    AppraisalHeader.Get(DocNo, DocType, EmpNo);
                    RecRef.GetTable(AppraisalHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Requisition Wksh. Name":
                begin
                    PurchRequisition.Get(WkshName, DocNo);
                    RecRef.GetTable(PurchRequisition);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Purchase Req. Header":
                begin
                    PurchaseReqHeader.Get(WkshName, DocNo);
                    RecRef.GetTable(PurchaseReqHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                        ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    Successful := true;
                end;
        /*Database::"Stock Transaction Header":
            begin
                StockTransactionHeader.Get(DocType, DocNo);
                RecRef.GetTable(StockTransactionHeader);
                UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                    ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                Successful := true;
            end;*/
        end;
        Clear(ApprovalsMgmt);
        //DeleMobileUser(MobileSenderID,RecRef.RECORDID);
    end;

    procedure CancelSelectedRecordFromApproval(TabID: Integer; DocNo: Code[50]; DocType: Integer; YearNo: Integer; EmpNo: Code[20]; WkshName: Code[10]; MobileSenderID: Code[50]; UserRef: Code[50]) Successful: Boolean
    var
        RecRef: RecordRef;
        Employee: Record Employee;
        PaymentHeader: Record "Payment Header";
        CashReceiptHeader: Record "Cash Receipt Header";
        PayrollLoan: Record "Payroll-Loan";
        LeaveScheduleHeader: Record "Leave Schedule Header";
        LeaveApplication: Record "Leave Application";
        EmployeeRequisition: Record "Employee Requisition";
        EmployeeExit: Record "Employee Exit";
        AppraisalHeader: Record "Appraisal Header";
        PurchRequisition: Record "Requisition Wksh. Name";
        PurchaseReqHeader: Record "Purchase Req. Header";
        //StockTransactionHeader: Record "Stock Transaction Header";
        ApprovalsMgmt: Codeunit "Approvals Hook";
        PaymentRequestHeader: Record "Payment Request Header";
    begin
        Successful := false;
        case TabID of
            Database::Employee:
                begin
                    Employee.Get(DocNo);
                    RecRef.GetTable(Employee);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Payment Header":
                begin
                    PaymentHeader.Get(DocType, DocNo);
                    RecRef.GetTable(PaymentHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Payment Request Header":
                begin
                    PaymentRequestHeader.Get(DocType, DocNo);
                    RecRef.GetTable(PaymentRequestHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Cash Receipt Header":
                begin
                    CashReceiptHeader.Get(DocNo);
                    RecRef.GetTable(CashReceiptHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Payroll-Loan":
                begin
                    PayrollLoan.Get(DocNo);
                    RecRef.GetTable(PayrollLoan);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Leave Schedule Header":
                begin
                    LeaveScheduleHeader.Get(YearNo, EmpNo, DocNo);
                    RecRef.GetTable(LeaveScheduleHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Leave Application":
                begin
                    LeaveApplication.Get(DocNo);
                    RecRef.GetTable(LeaveApplication);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Employee Requisition":
                begin
                    EmployeeRequisition.Get(DocNo);
                    RecRef.GetTable(EmployeeRequisition);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Employee Exit":
                begin
                    EmployeeExit.Get(DocNo);
                    RecRef.GetTable(EmployeeExit);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Appraisal Header":
                begin
                    AppraisalHeader.Get(DocNo, DocType, EmpNo);
                    RecRef.GetTable(AppraisalHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Requisition Wksh. Name":
                begin
                    PurchRequisition.Get(WkshName, DocNo);
                    RecRef.GetTable(PurchRequisition);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
            Database::"Purchase Req. Header":
                begin
                    PurchaseReqHeader.Get(WkshName, DocNo);
                    RecRef.GetTable(PurchaseReqHeader);
                    UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                    ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    Successful := true;
                end;
        /* Database::"Stock Transaction Header":
             begin
                 StockTransactionHeader.Get(DocType, DocNo);
                 RecRef.GetTable(StockTransactionHeader);
                 UpdateMobileUserSetup(MobileSenderID, UserRef, RecRef.RecordId);
                 ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                 Successful := true;
             end;*/
        end;
        Clear(ApprovalsMgmt);
        //DeleMobileUser(MobileSenderID,RecRef.RECORDID);
    end;

    procedure ReleaseSelectedRecord(TabID: Integer; DocNo: Code[50]; DocType: Integer; YearNo: Integer; EmpNo: Code[20]; WkshName: Code[10]) Successful: Boolean
    var
        RecRef: RecordRef;
        ReleaseDocument: Codeunit "Release Documents";
        Employee: Record Employee;
        PaymentHeader: Record "Payment Header";
        CashReceiptHeader: Record "Cash Receipt Header";
        PayrollLoan: Record "Payroll-Loan";
        LeaveScheduleHeader: Record "Leave Schedule Header";
        LeaveApplication: Record "Leave Application";
        EmployeeRequisition: Record "Employee Requisition";
        EmployeeExit: Record "Employee Exit";
        AppraisalHeader: Record "Appraisal Header";
        PurchRequisition: Record "Requisition Wksh. Name";
        PurchaseReqHeader: Record "Purchase Req. Header";
        // StockTransactionHeader: Record "Stock Transaction Header";
        PaymentRequestHeader: Record "Payment Request Header";
    begin
        Successful := false;
        case TabID of
            Database::Employee:
                begin
                    Employee.Get(DocNo);
                    RecRef.GetTable(Employee);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Payment Header":
                begin
                    PaymentHeader.Get(DocType, DocNo);
                    RecRef.GetTable(PaymentHeader);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Payment Request Header":
                begin
                    PaymentRequestHeader.Get(DocType, DocNo);
                    RecRef.GetTable(PaymentRequestHeader);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Cash Receipt Header":
                begin
                    CashReceiptHeader.Get(DocNo);
                    RecRef.GetTable(CashReceiptHeader);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Payroll-Loan":
                begin
                    PayrollLoan.Get(DocNo);
                    RecRef.GetTable(PayrollLoan);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Leave Schedule Header":
                begin
                    LeaveScheduleHeader.Get(YearNo, EmpNo, DocNo);
                    RecRef.GetTable(LeaveScheduleHeader);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Leave Application":
                begin
                    LeaveApplication.Get(DocNo);
                    RecRef.GetTable(LeaveApplication);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Employee Requisition":
                begin
                    EmployeeRequisition.Get(DocNo);
                    RecRef.GetTable(EmployeeRequisition);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Employee Exit":
                begin
                    EmployeeExit.Get(DocNo);
                    RecRef.GetTable(EmployeeExit);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Appraisal Header":
                begin
                    AppraisalHeader.Get(DocNo, DocType, EmpNo);
                    RecRef.GetTable(AppraisalHeader);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Requisition Wksh. Name":
                begin
                    PurchRequisition.Get(WkshName, DocNo);
                    RecRef.GetTable(PurchRequisition);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
            Database::"Purchase Req. Header":
                begin
                    PurchaseReqHeader.Get(WkshName, DocNo);
                    RecRef.GetTable(PurchaseReqHeader);
                    ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    Successful := true;
                end;
        /*Database::"Stock Transaction Header":
            begin
                StockTransactionHeader.Get(DocType, DocNo);
                RecRef.GetTable(StockTransactionHeader);
                ReleaseDocument.PerformanualManualDocRelease(RecRef);
                Successful := true;
            end;*/
        end;
    end;

    procedure RegisterQueryAndEmail(QueryRefNo: Code[20]) StatusOption: Text
    var
        Employee2: Record Employee;
        GlobalText: Integer;
        GlobalSender: Text[80];
        Body: Text[200];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
        EmployeeQueryEntry: Record "Employee Query Entry";
        Employee: Record Employee;
        SMTPMailSetup: Record "SMTP Mail Setup";
    begin
        EmployeeQueryEntry.Get(QueryRefNo);
        with EmployeeQueryEntry do begin
            TestField("Employee No.");
            TestField("Queried By");
            TestField("Cause of Query Code");
            TestField("Date of Query");
            SMTPMailSetup.Get;
            Employee.Get("Employee No.");
            Employee.TestField("Company E-Mail");
            Employee2.Get("Queried By");
            Employee2.TestField("Company E-Mail");

            GlobalSender := Employee2."First Name" + '' + Employee2."Last Name";
            Body := StrSubstNo(Text001, Offence, "Response Due Date");
            Subject := 'QUERY';
            SMTP.CreateMessage(GlobalSender, SMTPMailSetup."User ID", Employee."Company E-Mail", Subject, Body, false);
            SMTP.AddCC(Employee2."Company E-Mail");
            SMTP.Send;

            Status := Status::"Issued Out";
            Modify;
            StatusOption := Format(Status);
        end;
    end;

    procedure SubmitQueryResponse(QueryRefNo: Code[20]) StatusOption: Text
    var
        EmployeeQueryEntry: Record "Employee Query Entry";
    begin
        EmployeeQueryEntry.Get(QueryRefNo);
        with EmployeeQueryEntry do begin
            if Explanation = '' then
                Error(Text002);

            Status := Status::Answered;
            Modify;
            StatusOption := Format(Status);
        end;
    end;

    procedure SendQueryToHR(QueryRefNo: Code[20]) StatusOption: Text
    var
        EmployeeQueryEntry: Record "Employee Query Entry";
    begin
        EmployeeQueryEntry.Get(QueryRefNo);
        with EmployeeQueryEntry do begin
            Status := Status::"Awaiting HR Action";
            Modify;
            StatusOption := Format(Status);
        end;
    end;

    procedure ProcessQueryAction(QueryRefNo: Code[20]) StatusOption: Text
    var
        EmployeeQueryEntry: Record "Employee Query Entry";
        Employee: Record Employee;
    begin
        EmployeeQueryEntry.Get(QueryRefNo);
        with EmployeeQueryEntry do begin
            Employee.Get("Employee No.");
            if not (Action in [0]) then begin
                case Action of
                    3:
                        begin
                            Employee.Status := Employee.Status::Inactive;
                            Employee."Inactive Date" := "Effective Date of Action";
                            Employee."Inactive Duration" := Format("Suspension Duration");
                            Employee."Cause of Inactivity Code" := "Cause of Inactivity Code";
                            Employee.Modify
                        end;
                    4:
                        begin
                            Employee.Status := Employee.Status::Inactive;
                            Employee."Inactive Date" := "Effective Date of Action";
                            Employee."Inactive Duration" := Format("Suspension Duration");
                            Employee."Cause of Inactivity Code" := "Cause of Inactivity Code";
                            Employee."Inactive Without Pay" := true;
                            Employee.Modify;
                        end;
                    5:
                        begin
                            Employee.Status := Employee.Status::Terminated;
                            Employee."Termination Date" := "Effective Date of Action";
                            Employee."Grounds for Term. Code" := "Grounds for Term. Code";
                            Employee.Modify;
                        end;
                end;

            end;
            Status := Status::Closed;
            Modify;
            StatusOption := Format(Status);
        end;
    end;

    procedure CreateLeaveApplication(YearNo: Integer; EmpNo: Code[20]; AbsCode: Code[10]; LineNo: Integer) LeaveAppNo: Code[20]
    var
        HRSetup: Record "Human Resources Setup";
        LeaveHeader: Record "Leave Schedule Header";
        LeaveLine: Record "Leave Schedule Line";
        LeavePlanLine: Record "Leave Schedule Line";
        LeaveApplication: Record "Leave Application";
    begin
        LeaveAppNo := '';
        HRSetup.Get;
        LeaveHeader.Get(YearNo, EmpNo, AbsCode);
        LeaveLine.Get(YearNo, EmpNo, AbsCode, LineNo);
        if LeaveHeader.Status <> LeaveHeader.Status::Approved then
            Error(Text009);
        if LeaveLine."Outstanding No. of Days" = 0 then
            Error(Text010);

        //Ensure that the application is done according to the schedule
        LeavePlanLine.Reset;
        LeavePlanLine.SetCurrentkey("Start Date");
        LeavePlanLine.SetRange("Year No.", LeaveLine."Year No.");
        LeavePlanLine.SetRange("Employee No.", LeaveLine."Employee No.");
        LeavePlanLine.SetRange("Absence Code", LeaveLine."Absence Code");
        LeavePlanLine.SetFilter("Start Date", '<%1', LeaveLine."Start Date");
        LeavePlanLine.SetFilter("Outstanding No. of Days", '<>%1', 0);
        if LeavePlanLine.FindFirst then
            Error(Text013);

        //Create Leave application
        LeaveApplication.Init;
        LeaveApplication.Validate("Employee No.", LeaveLine."Employee No.");
        LeaveApplication."From Date" := LeaveLine."Start Date";
        LeaveApplication."To Date" := LeaveLine."End Date";
        LeaveApplication."Cause of Absence Code" := LeaveHeader."Absence Code";
        LeaveApplication.Description := 'ANNUAL LEAVE APPLICATION';
        LeaveApplication.Quantity := LeaveLine."Outstanding No. of Days";
        LeaveApplication."Unit of Measure Code" := HRSetup."Base Unit of Measure";
        LeaveApplication."Quantity (Base)" := LeaveLine."Outstanding No. of Days";
        LeaveApplication."Qty. per Unit of Measure" := 1;
        LeaveApplication."Application Date" := Today;
        LeaveApplication."Schedule Line No." := LeaveLine."Line No.";
        LeaveApplication."Year No." := LeaveLine."Year No.";
        LeaveApplication."Manager No." := LeaveLine."Manager No.";
        LeaveApplication."Global Dimension 1 Code" := LeaveLine."Global Dimension 1 Code";
        LeaveApplication."Global Dimension 2 Code" := LeaveLine."Global Dimension 2 Code";
        LeaveApplication.CalcReturnDate;
        LeaveApplication.Insert(true);
        LeaveAppNo := LeaveApplication."Document No.";

        LeaveLine.Validate("No. of Days Taken", LeaveLine."Outstanding No. of Days");
        LeaveLine.Modify;
    end;

    procedure RecallLeaveApplication(YearNo: Integer; EmpNo: Code[20]; AbsCode: Code[10]; LineNo: Integer) RecalledLeaveAppNo: Code[20]
    var
        HRSetup: Record "Human Resources Setup";
        LeaveHeader: Record "Leave Schedule Header";
        LeaveLine: Record "Leave Schedule Line";
        LeavePlanLine: Record "Leave Schedule Line";
        LeaveApplication: Record "Leave Application";
        Text016: label 'Leave Schedule must be open for this action to go through';
        Text017: label 'Nothing to recall';
        ApprovalMgt: Codeunit "Approvals Mgmt.";
    begin
        RecalledLeaveAppNo := '';
        LeaveHeader.Get(YearNo, EmpNo, AbsCode);
        LeaveLine.Get(YearNo, EmpNo, AbsCode, LineNo);
        HRSetup.Get;

        if LeaveHeader.Status <> LeaveHeader.Status::Open then
            Error(Text016);

        if LeaveLine."Outstanding No. of Days" <> 0 then
            Error(Text017);

        //Delete the employee absence
        LeaveApplication.SetRange("Employee No.", LeaveLine."Employee No.");
        LeaveApplication.SetRange("Year No.", LeaveLine."Year No.");
        LeaveApplication.SetRange("Schedule Line No.", LeaveLine."Line No.");
        LeaveApplication.SetRange("Cause of Absence Code", HRSetup."Annual Leave Code");


        if (LeaveApplication.FindFirst) and (LeaveApplication.Status = LeaveApplication.Status::Approved) then
            Error(Text018);
        ApprovalMgt.DeleteApprovalEntries(LeaveApplication.RecordId);

        RecalledLeaveAppNo := LeaveApplication."Document No.";

        LeaveApplication.DeleteAll;

        //Reset Line
        LeaveLine."No. of Days Taken" := 0;
        LeaveLine."Outstanding No. of Days" := LeaveLine."No. of Days Scheduled";
        LeaveLine."Recalled By" := UserId;
        LeaveLine."Recalled Date" := WorkDate;
        LeaveLine.Modify;
    end;

    procedure GetLeaveBal(YearNo: Integer; EmpNo: Code[20]; AbsCode: Code[10]) LeaveBal: Decimal
    var
        CauseofAbsence: Record "Cause of Absence";
        LeaveHeader: Record "Leave Schedule Header";
    begin
        LeaveBal := 0;
        if AbsCode <> '' then begin
            LeaveHeader.Get(YearNo, EmpNo, AbsCode);
            LeaveHeader.CalcFields("No. of Days Added", "No. of Days Committed", "No. of Days Subtracted", "No. of Days Utilised", "No. of Days Entitled", "No. of Days B/F");
            LeaveBal := (/*LeaveHeader."No. of Days Entitled" +*/ LeaveHeader."No. of Days Added" + LeaveHeader."No. of Days B/F") -
                    (LeaveHeader."No. of Days Subtracted" + LeaveHeader."No. of Days Utilised" + LeaveHeader."No. of Days Committed");
        end else begin
            LeaveHeader.Reset;
            LeaveHeader.SetRange("Year No.", YearNo);
            LeaveHeader.SetRange("Employee No.", EmpNo);
            if LeaveHeader.FindSet then
                repeat
                    LeaveHeader.CalcFields("No. of Days Added", "No. of Days Committed", "No. of Days Subtracted", "No. of Days Utilised", "No. of Days Entitled", "No. of Days B/F");
                    LeaveBal += (/*LeaveHeader."No. of Days Entitled" + */LeaveHeader."No. of Days Added" + LeaveHeader."No. of Days B/F") -
                            (LeaveHeader."No. of Days Subtracted" + LeaveHeader."No. of Days Utilised" + LeaveHeader."No. of Days Committed");
                until LeaveHeader.Next = 0;
        end;

    end;

    local procedure UpdateMobileUserSetup(MobileSender: Code[50]; UserName: Code[50]; CurrentRecordID: RecordID)
    var
        NAVMobileUserSetup: Record "NAV Mobile User Setup";
    begin
        if not NAVMobileUserSetup.Get(MobileSender, CurrentRecordID) then begin
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

    local procedure DeleMobileUser(MobileSender: Code[50]; CurrentRecordID: RecordID)
    var
        NAVMobileUserSetup: Record "Qualification Entry";
    begin
        if NAVMobileUserSetup.Get(MobileSender, CurrentRecordID) then
            NAVMobileUserSetup.Delete;
    end;

    procedure GetAllLeaveBalances(YearNo: Integer; EmpNo: Code[20]) LeaveBalances: Text[1024]
    var
        CauseofAbsence: Record "Cause of Absence";
        LeaveHeader: Record "Leave Schedule Header";
    begin
        LeaveHeader.Reset;
        LeaveHeader.SetRange("Year No.", YearNo);
        LeaveHeader.SetRange("Employee No.", EmpNo);
        if LeaveHeader.FindSet then begin
            LeaveBalances := '"{';
            repeat
                LeaveHeader.CalcFields("No. of Days Added", "No. of Days Committed", "No. of Days Subtracted", "No. of Days Utilised", "No. of Days Entitled", "No. of Days B/F");
                LeaveBalances := LeaveBalances + '"' + LeaveHeader."Absence Code" + '":"' + Format(ROUND((/*LeaveHeader."No. of Days Entitled" + */LeaveHeader."No. of Days Added" + LeaveHeader."No. of Days B/F") -
                        (LeaveHeader."No. of Days Subtracted" + LeaveHeader."No. of Days Utilised" + LeaveHeader."No. of Days Committed")), 0, '<Sign><Integer><Decimals>') + '",';
            until LeaveHeader.Next = 0;
            LeaveBalances := DelStr(LeaveBalances, StrLen(LeaveBalances), 1);
            LeaveBalances := LeaveBalances + '}"';
        end;

    end;

    procedure GetProfilePicture(StaffNo: Text) BaseImage: Text
    var
        Tofile: Text;
        IStream: InStream;
        Bytes: dotnet Array;
        Convert: dotnet Convert;
        MemoryStream: dotnet MemoryStream;
        Employee: Record Employee;
    begin
        Employee.Reset;
        Employee.SetRange("No.", StaffNo);

        if Employee.Find('-') then begin
            if Employee.Image.Hasvalue then begin
                //Employee.CALCFIELDS(Image);
                //Employee.Picture.CREATEINSTREAM(IStream);
                MemoryStream := MemoryStream.MemoryStream();
                //COPYSTREAM(MemoryStream,IStream);
                Employee.Image.ExportStream(MemoryStream);
                Bytes := MemoryStream.GetBuffer();
                BaseImage := Convert.ToBase64String(Bytes);
            end;
        end;
    end;

    procedure AttachCashAdvance(var RetiremenNo: Code[20]; var CashAdvNo: Code[20])
    var
        PaymentHeader: Record "Payment Header";
        PostedPaymentHeader: Record "Posted Payment Header";
        GetCashOutAdvances: Codeunit "Payment-Get Outst. Cash Advanc";
    begin
        PaymentHeader.Get(PaymentHeader."document type"::Retirement, RetiremenNo);
        PostedPaymentHeader.Get(PostedPaymentHeader."document type"::"Cash Advance", CashAdvNo);

        PaymentHeader.TestField(Status, PaymentHeader.Status::Open);

        if PostedPaymentHeader."Retirement No." <> '' then
            PostedPaymentHeader.TestField("Retirement No.", PaymentHeader."No.");

        PostedPaymentHeader."Retirement No." := PaymentHeader."No.";

        PostedPaymentHeader.Modify;
        GetCashOutAdvances.SetPaymentHeader(PaymentHeader);
        GetCashOutAdvances.CreateRetirementLines(PostedPaymentHeader);
    end;

    procedure UndoAttachedCashAdvance(var RetiremenNo: Code[20]; var CashAdvNo: Code[20])
    var
        PaymentHeader: Record "Payment Header";
        PostedPaymentHeader: Record "Posted Payment Header";
        GetCashOutAdvances: Codeunit "Payment-Get Outst. Cash Advanc";
        PostedPaymentLine: Record "Posted Payment Line";
        PaymentLine: Record "Payment Line";
    begin
        PaymentHeader.Get(PaymentHeader."document type"::Retirement, RetiremenNo);
        PostedPaymentHeader.Get(PostedPaymentHeader."document type"::"Cash Advance", CashAdvNo);

        PaymentHeader.TestField(Status, PaymentHeader.Status::Open);

        PostedPaymentHeader."Retirement No." := '';
        PostedPaymentHeader.Modify;

        PaymentLine.SetRange("Document Type", PaymentHeader."Document Type");
        PaymentLine.SetRange("Document No.", PaymentHeader."No.");
        PaymentLine.SetRange("Attached Doc. No.", PostedPaymentHeader."No.");
        PaymentLine.DeleteAll;

        PostedPaymentLine.SetRange("Document Type", PostedPaymentHeader."Document Type");
        PostedPaymentLine.SetRange("Document No.", PostedPaymentHeader."No.");
        PostedPaymentLine.ModifyAll("Retirement No.", '');
    end;
}

