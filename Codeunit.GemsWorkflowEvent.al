Codeunit 52092140 "Gems Workflow Event"
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowEventMgt: Codeunit "Workflow Event Handling";
        WorkflowManagement: Codeunit "Workflow Management";
        GlobalUserSetup: Record "User Setup";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        //Payment Management
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendPaymentRequestForApprovalCode',
          Database::"Payment Request Header", 'Approval of a payment request is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelPaymentRequestForApprovalCode',
          Database::"Payment Request Header", 'An approval request for a payment request is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendPaymentDocForApprovalCode',
          Database::"Payment Header", 'Approval of a payment document is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelPaymentDocForApprovalCode',
          Database::"Payment Header", 'An approval request for a payment document is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendCashReceiptDocForApprovalCode',
          Database::"Cash Receipt Header", 'Approval of a cash receipt is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelCashReceiptDocForApprovalCode',
          Database::"Cash Receipt Header", 'An approval request for cash receipt is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendChequeForApprovalCode',
          Database::"Cheque File", 'Approval request of a cheque is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelChequeForApprovalCode',
          Database::"Cheque File", 'An approval request for a cheque is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendCashLodgementForApprovalCode',
          Database::"Cash Lodgement", 'Approval request of a cash lodgement is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelCashLodgementForApprovalCode',
          Database::"Cash Lodgement", 'An approval request for a cash lodgement is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnPaymentRequestBudgetExceededCode',
          Database::"Payment Request Header", 'A payment request budget is exceeded', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnPaymentRequestBudgetNotExceededCode',
          Database::"Payment Request Header", 'A payment request budget is not exceeded', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnPaymentDocumentBudgetExceededCode',
          Database::"Payment Header", 'A payment document budget is exceeded', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnPaymentDocumentBudgetNotExceededCode',
          Database::"Payment Header", 'A payment document budget is not exceeded', 0, false);

        // HR and Payroll
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendLoanApplicationForApprovalCode',
          Database::"Payroll-Loan", 'Approval of a Loan Application is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelLoanApplicationForApprovalCode',
          Database::"Payroll-Loan", 'An approval request for Loan Application is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendPayrollForApprovalCode',
          Database::"Payroll-Period", 'Approval of payroll is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelPayrollForApprovalCode',
          Database::"Payroll-Period", 'An approval request for payroll is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendLeaveScheduleForApprovalCode',
          Database::"Leave Schedule Header", 'Approval of a Leave Schedule is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelLeaveScheduleForApprovalCode',
          Database::"Leave Schedule Header", 'An approval request for Leave Schedule is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendLeaveApplicationForApprovalCode',
          Database::"Leave Application", 'Approval of a Leave Application is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelLeaveApplicationForApprovalCode',
          Database::"Leave Application", 'An approval request for Leave Application is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendLeaveResumptionForApprovalCode',
          Database::"Leave Resumption", 'Approval of a Leave Resumption is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelLeaveResumptionForApprovalCode',
          Database::"Leave Resumption", 'An approval request for Leave Resumption is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendEmployeeRequisitionForApprovalCode',
          Database::"Employee Requisition", 'Approval of a Employee Requisition is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelEmployeeRequisitionForApprovalCode',
          Database::"Employee Requisition", 'An approval request for Employee Requisition is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendEmployeeExitForApprovalCode',
          Database::"Employee Exit", 'Approval of employee exit is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelEmployeeExitForApprovalCode',
          Database::"Employee Exit", 'An approval request for employee exit is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendAppraisalForApprovalCode',
          Database::"Appraisal Header", 'Approval request of an appraisal is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelAppraisalForApprovalCode',
          Database::"Appraisal Header", 'An approval request for an appraisal is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendTravelRequestForApprovalCode',
          Database::"Travel Header", 'Approval request of a travel request is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelTravelRequestForApprovalCode',
          Database::"Travel Header", 'An approval request for a travel Request is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendPayrollVariableForApprovalCode',
          Database::"Payroll Variable Header", 'Approval request of a payroll variable is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelPayrollVariableForApprovalCode',
          Database::"Payroll Variable Header", 'An approval request for a payroll variable is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendEmployeeUpdateForApprovalCode',
          Database::"Employee Update Header", 'Approval request of an employee update is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelEmployeeUpdateForApprovalCode',
          Database::"Employee Update Header", 'An approval request for an employee update is cancelled', 0, false);

        //Procurement
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendPurchRequisitionForApprovalCode',
          Database::"Requisition Wksh. Name", 'Approval of a Purchase Requisition is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelPurchRequisitionForApprovalCode',
          Database::"Requisition Wksh. Name", 'An approval request for Purchase Requisition is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnPurchaseDocumentBudgetExceededCode',
          Database::"Purchase Header", 'A purchase document budget is exceeded', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnPurchaseDocumentBudgetNotExceededCode',
          Database::"Purchase Header", 'A purchase document budget is not exceeded', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnPurchaseRequisitionBudgetExceededCode',
          Database::"Requisition Wksh. Name", 'A purchase requisition budget is exceeded', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnPurchaseRequisitionBudgetNotExceededCode',
          Database::"Requisition Wksh. Name", 'A purchase requisition budget is not exceeded', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendBidEvaluationForApprovalCode',
          Database::"Purchase Req. Header", 'Approval request of a  bid evaluation is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelBidEvaluationForApprovalCode',
          Database::"Purchase Req. Header", 'An approval request for a bid evaluation is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendWarehouseReceiptForApprovalCode',
          Database::"Warehouse Receipt Header", 'Approval for Warehouse Receipt is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelWarehouseReceiptForApprovalCode',
          Database::"Warehouse Receipt Header", 'An approval for Warehouse Receipt is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendStockRequisitionForApprovalCode',
          Database::"Stock Transaction Header", 'Approval for stock requisition is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelStockRequisitionForApprovalCode',
          Database::"Stock Transaction Header", 'An approval for stock requisition is cancelled', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendStockReturnForApprovalCode',
          Database::"Stock Transaction Header", 'Approval for stock return is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelStockReturnForApprovalCode',
          Database::"Stock Transaction Header", 'An approval for stock return is cancelled', 0, false);

        //Disbursment E-Payment
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnSendCashLiteTransactionForApprovalCode',
          Database::"CashLite Trans Header", 'Approval of a CashLite Transaction is requested', 0, false);
        WorkflowEventHandling.AddEventToLibrary('RunWorkflowOnCancelCashLiteTransactionForApprovalCode',
          Database::"CashLite Trans Header", 'An approval request for a CashLite Transaction is cancelled', 0, false);

    end;


    procedure RunWorkflowOnSendGenericDocForApprovalCode(var DocName: Text[40]): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSend' + DocName + 'ForApprovalCode'));
    end;


    procedure RunWorkflowOnCancelGenericDocForApprovalCode(var DocName: Text[40]): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancel' + DocName + 'ForApprovalCode'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Hook", 'OnSendGenericDocForApproval', '', false, false)]
    local procedure RunWorkflowOnSendGenericDocForApproval(RecRef: RecordRef)
    var
        PaymentReq: Record "Payment Request Header";
        PaymentHeader: Record "Payment Header";
        ChequeFile: Record "Cheque File";
        CashReceiptHeader: Record "Cash Receipt Header";
        CashLodgement: Record "Cash Lodgement";
        PayrollPayslipHeader: Record "Payroll-Payslip Header";
        PayrollLoans: Record "Payroll-Loan";
        PayrollPeriod: Record "Payroll-Period";
        EmpRequisition: Record "Employee Requisition";
        TrainingSchedule: Record "Training Schedule Header";
        LeaveSchedule: Record "Leave Schedule Header";
        LeaveApplication: Record "Leave Application";
        LeaveResumption: Record "Leave Resumption";
        PromotionTransferBatch: Record "Employee Update Header";
        EmployeeExit: Record "Employee Exit";
        Appraisal: Record "Appraisal Header";
        PurchRequisition: Record "Requisition Wksh. Name";
        QuoteEvaluation: Record "Purchase Req. Header";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        StockTransHeader: Record "Stock Transaction Header";
        TravelHeader: Record "Travel Header";
        PayrollVariable: Record "Payroll Variable Header";
        EmpUpdate: Record "Employee Update Header";
        DocName: Text;
        CashLiteTransaction: Record "CashLite Trans Header";
    begin
        //WorkflowManagement.SetMobileUserID(GlobalUserSetup."User ID");
        case RecRef.Number of
            Database::"Payment Request Header":
                begin
                    RecRef.SetTable(PaymentReq);
                    DocName := 'PAYMENTREQUEST';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PaymentReq);
                end;
            Database::"Payment Header":
                begin
                    RecRef.SetTable(PaymentHeader);
                    DocName := 'PAYMENTDOC';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PaymentHeader);
                end;
            Database::"Cash Receipt Header":
                begin
                    RecRef.SetTable(CashReceiptHeader);
                    DocName := 'CASHRECEIPTDOC';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), CashReceiptHeader);
                end;
            Database::"Cheque File":
                begin
                    RecRef.SetTable(ChequeFile);
                    DocName := 'CHEQUE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), ChequeFile);
                end;
            Database::"Cash Lodgement":
                begin
                    RecRef.SetTable(CashLodgement);
                    DocName := 'CASHLODGEMENT';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), CashLodgement);
                end;
            Database::"Payroll-Loan":
                begin
                    RecRef.SetTable(PayrollLoans);
                    DocName := 'LOANAPPLICATION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PayrollLoans);
                end;
            Database::"Payroll-Period":
                begin
                    RecRef.SetTable(PayrollPeriod);
                    DocName := 'PAYROLL';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PayrollPeriod);
                end;
            Database::"Leave Schedule Header":
                begin
                    RecRef.SetTable(LeaveSchedule);
                    DocName := 'LEAVESCHEDULE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), LeaveSchedule);
                end;
            Database::"Leave Application":
                begin
                    RecRef.SetTable(LeaveApplication);
                    DocName := 'LEAVEAPPLICATION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), LeaveApplication);
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumption);
                    DocName := 'LEAVERESUMPTION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), LeaveResumption);
                end;
            Database::"Employee Requisition":
                begin
                    RecRef.SetTable(EmpRequisition);
                    DocName := 'EMPLOYEEREQUISITION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), EmpRequisition);
                end;
            Database::"Employee Exit":
                begin
                    RecRef.SetTable(EmployeeExit);
                    DocName := 'EMPLOYEEEXIT';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), EmployeeExit);
                end;
            Database::"Requisition Wksh. Name":
                begin
                    RecRef.SetTable(PurchRequisition);
                    DocName := 'PURCHREQUISITION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PurchRequisition);
                end;
            Database::"Purchase Req. Header":
                begin
                    RecRef.SetTable(QuoteEvaluation);
                    DocName := 'BIDEVALUATION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), QuoteEvaluation);
                end;
            Database::"Warehouse Receipt Header":
                begin
                    RecRef.SetTable(WarehouseReceiptHeader);
                    DocName := 'WAREHOUSERECEIPTHEADER';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), WarehouseReceiptHeader);
                end;
            Database::"Stock Transaction Header":
                begin
                    RecRef.SetTable(StockTransHeader);
                    case StockTransHeader."Document Type" of
                        StockTransHeader."document type"::SRN:
                            begin
                                DocName := 'STOCKREQUISITION';
                                WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), StockTransHeader);
                            end;
                        StockTransHeader."document type"::STOCKRET:
                            begin
                                DocName := 'STOCKRETURN';
                                WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), StockTransHeader);
                            end;
                    end;
                end;
            Database::"Travel Header":
                begin
                    RecRef.SetTable(TravelHeader);
                    DocName := 'TRAVELREQUEST';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), TravelHeader);
                end;
            Database::"Payroll Variable Header":
                begin
                    RecRef.SetTable(PayrollVariable);
                    DocName := 'PAYROLLVARIABLE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), PayrollVariable);
                end;
            Database::"Employee Update Header":
                begin
                    RecRef.SetTable(EmpUpdate);
                    DocName := 'EMPLOYEEUPDATE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), EmpUpdate);
                end;
            Database::"CashLite Trans Header":
                begin
                    RecRef.SetTable(CashLiteTransaction);
                    DocName := 'CASHLITETRANSACTION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnSendGenericDocForApprovalCode(DocName), CashLiteTransaction);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Hook", 'OnCancelGenericDocForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelGenericDocForApproval(var RecRef: RecordRef)
    var
        PaymentReq: Record "Payment Request Header";
        PaymentHeader: Record "Payment Header";
        ChequeFile: Record "Cheque File";
        CashReceiptHeader: Record "Cash Receipt Header";
        CashLodgement: Record "Cash Lodgement";
        PayrollPayslipHeader: Record "Payroll-Payslip Header";
        PayrollLoans: Record "Payroll-Loan";
        PayrollPeriod: Record "Payroll-Period";
        EmpRequisition: Record "Employee Requisition";
        TrainingSchedule: Record "Training Schedule Header";
        LeaveSchedule: Record "Leave Schedule Header";
        LeaveApplication: Record "Leave Application";
        LeaveResumption: Record "Leave Resumption";
        PromotionTransferBatch: Record "Employee Update Header";
        EmployeeExit: Record "Employee Exit";
        Appraisal: Record "Appraisal Header";
        PurchRequisition: Record "Requisition Wksh. Name";
        QuoteEvaluation: Record "Purchase Req. Header";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        StockTransHeader: Record "Stock Transaction Header";
        TravelHeader: Record "Travel Header";
        PayrollVariable: Record "Payroll Variable Header";
        EmpUpdate: Record "Employee Update Header";
        DocName: Text;
        CashLiteTransaction: Record "CashLite Trans Header";
    begin
        //WorkflowEventMgt.SetMobileUser(GlobalUserSetup."User ID");
        case RecRef.Number of
            Database::"Payment Request Header":
                begin
                    RecRef.SetTable(PaymentReq);
                    DocName := 'PAYMENTREQUEST';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PaymentReq);
                end;
            Database::"Payment Header":
                begin
                    RecRef.SetTable(PaymentHeader);
                    DocName := 'PAYMENTDOC';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PaymentHeader);
                end;
            Database::"Cash Receipt Header":
                begin
                    RecRef.SetTable(CashReceiptHeader);
                    DocName := 'CASHRECEIPTDOC';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), CashReceiptHeader);
                end;
            Database::"Cheque File":
                begin
                    RecRef.SetTable(ChequeFile);
                    DocName := 'CHEQUE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), ChequeFile);
                end;
            Database::"Cash Lodgement":
                begin
                    RecRef.SetTable(CashLodgement);
                    DocName := 'CASHLODGEMENT';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), CashLodgement);
                end;
            Database::"Payroll-Loan":
                begin
                    RecRef.SetTable(PayrollLoans);
                    DocName := 'LOANAPPLICATION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PayrollLoans);
                end;
            Database::"Payroll-Period":
                begin
                    RecRef.SetTable(PayrollPeriod);
                    DocName := 'PAYROLL';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PayrollPeriod);
                end;
            Database::"Leave Schedule Header":
                begin
                    RecRef.SetTable(LeaveSchedule);
                    DocName := 'LEAVESCHEDULE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), LeaveSchedule);
                end;
            Database::"Leave Application":
                begin
                    RecRef.SetTable(LeaveApplication);
                    DocName := 'LEAVEAPPLICATION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), LeaveApplication);
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumption);
                    DocName := 'LEAVERESUMPTION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), LeaveResumption);
                end;
            Database::"Employee Requisition":
                begin
                    RecRef.SetTable(EmpRequisition);
                    DocName := 'EMPLOYEEREQUISITION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), EmpRequisition);
                end;
            Database::"Employee Exit":
                begin
                    RecRef.SetTable(EmployeeExit);
                    DocName := 'EMPLOYEEEXIT';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), EmployeeExit);
                end;
            Database::"Appraisal Header":
                begin
                    RecRef.SetTable(Appraisal);
                    DocName := 'APPRAISAL';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), Appraisal);
                end;
            Database::"Requisition Wksh. Name":
                begin
                    RecRef.SetTable(PurchRequisition);
                    DocName := 'PURCHREQUISITION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PurchRequisition);
                end;
            Database::"Purchase Req. Header":
                begin
                    RecRef.SetTable(QuoteEvaluation);
                    DocName := 'BIDEVALUATION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), QuoteEvaluation);
                end;
            Database::"Warehouse Receipt Header":
                begin
                    RecRef.SetTable(WarehouseReceiptHeader);
                    DocName := 'WAREHOUSERECEIPTHEADER';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), WarehouseReceiptHeader);
                end;
            Database::"Stock Transaction Header":
                begin
                    RecRef.SetTable(StockTransHeader);
                    case StockTransHeader."Document Type" of
                        StockTransHeader."document type"::SRN:
                            begin
                                DocName := 'STOCKREQUISITION';
                                WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), StockTransHeader);
                            end;
                        StockTransHeader."document type"::STOCKRET:
                            begin
                                DocName := 'STOCKRETURN';
                                WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), StockTransHeader);
                            end;
                    end;
                end;
            Database::"Travel Header":
                begin
                    RecRef.SetTable(TravelHeader);
                    DocName := 'TRAVELREQUEST';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), TravelHeader);
                end;
            Database::"Payroll Variable Header":
                begin
                    RecRef.SetTable(PayrollVariable);
                    DocName := 'PAYROLLVARIABLE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), PayrollVariable);
                end;
            Database::"Employee Update Header":
                begin
                    RecRef.SetTable(EmpUpdate);
                    DocName := 'EMPLOYEEUPDATE';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), EmpUpdate);
                end;
            Database::"CashLite Trans Header":
                begin
                    RecRef.SetTable(CashLiteTransaction);
                    DocName := 'CASHLITETRANSACTION';
                    WorkflowManagement.HandleEvent(RunWorkflowOnCancelGenericDocForApprovalCode(DocName), CashLiteTransaction);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]

    procedure OnPaymentRequestBudgetExceeded(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnPaymentRequestBudgetNotExceeded(var RecRef: RecordRef)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnPaymentRequestBudgetExceeded', '', false, false)]
    local procedure RunWorkflowOnPaymentRequestBudgetExceeded(var RecRef: RecordRef)
    var
        PaymentReq: Record "Payment Request Header";
    begin
        RecRef.SetTable(PaymentReq);
        WorkflowManagement.HandleEvent('RunWorkflowOnPaymentRequestBudgetExceededCode', PaymentReq);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnPaymentRequestBudgetNotExceeded', '', false, false)]
    local procedure RunWorkflowOnPaymentRequestBudgetNotExceeded(var RecRef: RecordRef)
    var
        PaymentReq: Record "Payment Request Header";
    begin
        RecRef.SetTable(PaymentReq);
        WorkflowManagement.HandleEvent('RunWorkflowOnPaymentRequestBudgetNotExceededCode', PaymentReq);
    end;

    [IntegrationEvent(false, false)]

    procedure OnPaymentDocumentBudgetExceeded(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnPaymentDocumentBudgetNotExceeded(var RecRef: RecordRef)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnPaymentDocumentBudgetExceeded', '', false, false)]
    local procedure RunWorkflowOnPaymentDocumentBudgetExceeded(var RecRef: RecordRef)
    var
        PaymentHeader: Record "Payment Header";
    begin
        RecRef.SetTable(PaymentHeader);
        WorkflowManagement.HandleEvent('RunWorkflowOnPaymentDocumentBudgetExceededCode', PaymentHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnPaymentDocumentBudgetNotExceeded', '', false, false)]
    local procedure RunWorkflowOnPaymentDocumentrBudgetNotExceeded(var RecRef: RecordRef)
    var
        PaymentHeader: Record "Payment Header";
    begin
        RecRef.SetTable(PaymentHeader);
        WorkflowManagement.HandleEvent('RunWorkflowOnPaymentDocumentBudgetNotExceededCode', PaymentHeader);
    end;

    [IntegrationEvent(false, false)]

    procedure OnPurchaseDocumentBudgetExceeded(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnPurchaseDocumentBudgetNotExceeded(var RecRef: RecordRef)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnPurchaseDocumentBudgetExceeded', '', false, false)]
    local procedure RunWorkflowOnPurchaseDocumentBudgetExceeded(var RecRef: RecordRef)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        RecRef.SetTable(PurchaseHeader);
        WorkflowManagement.HandleEvent('RunWorkflowOnPurchaseDocumentBudgetExceededCode', PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnPurchaseDocumentBudgetNotExceeded', '', false, false)]
    local procedure RunWorkflowOnPurchaseDocumentBudgetNotExceeded(var RecRef: RecordRef)
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        RecRef.SetTable(PurchaseHeader);
        WorkflowManagement.HandleEvent('RunWorkflowOnPurchaseDocumentBudgetNotExceededCode', PurchaseHeader);
    end;

    [IntegrationEvent(false, false)]

    procedure OnPurchaseRequisitionBudgetExceeded(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnPurchaseRequisitionBudgetNotExceeded(var RecRef: RecordRef)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnPurchaseRequisitionBudgetExceeded', '', false, false)]
    local procedure RunWorkflowOnPurchaseRequisitionBudgetExceeded(var RecRef: RecordRef)
    var
        PurchaseRequisition: Record "Requisition Wksh. Name";
    begin
        RecRef.SetTable(PurchaseRequisition);
        WorkflowManagement.HandleEvent('RunWorkflowOnPurchaseRequisitionBudgetExceededCode', PurchaseRequisition);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnPurchaseRequisitionBudgetNotExceeded', '', false, false)]
    local procedure RunWorkflowOnPurchaseRequisitionBudgetNotExceeded(var RecRef: RecordRef)
    var
        PurchaseRequisition: Record "Requisition Wksh. Name";
    begin
        RecRef.SetTable(PurchaseRequisition);
        WorkflowManagement.HandleEvent('RunWorkflowOnPurchaseRequisitionBudgetNotExceededCode', PurchaseRequisition);
    end;

    [IntegrationEvent(false, false)]

    procedure OnTravelRequestBudgetExceeded(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnTravelRequestBudgetNotExceeded(var RecRef: RecordRef)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnTravelRequestBudgetExceeded', '', false, false)]
    local procedure RunWorkflowOnTravelRequestBudgetExceeded(var RecRef: RecordRef)
    var
        TravelReq: Record "Travel Header";
    begin
        RecRef.SetTable(TravelReq);
        WorkflowManagement.HandleEvent('RunWorkflowOnTravelRequestBudgetExceededCode', TravelReq);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gems Workflow Event", 'OnTravelRequestBudgetNotExceeded', '', false, false)]
    local procedure RunWorkflowOnTravelRequestBudgetNotExceeded(var RecRef: RecordRef)
    var
        TravelReq: Record "Travel Header";
    begin
        RecRef.SetTable(TravelReq);
        WorkflowManagement.HandleEvent('RunWorkflowOnTravelBudgetNotExceededCode', TravelReq);
    end;


    procedure SetMobileUser(MobileUserSetup: Code[50])
    begin
        GlobalUserSetup.Get(MobileUserSetup);
    end;
}

