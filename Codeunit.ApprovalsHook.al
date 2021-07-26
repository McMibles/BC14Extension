Codeunit 52092138 "Approvals Hook"
{
    Permissions = TableData "Approval Entry" = imd,
                  TableData "Approval Comment Line" = imd,
                  TableData "Posted Approval Entry" = imd,
                  TableData "Posted Approval Comment Line" = imd,
                  TableData "Overdue Approval Entry" = imd;

    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        NoWorkflowEnabledErr: label 'This record is not supported by related approval workflow.';


    procedure CheckGenericApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    var
        DocName: Text;
        GemsWorkflowEvent: Codeunit "Gems Workflow Event";
    begin
        if not IsGenericApprovalsWorkflowEnabled(RecRef) then
            Error(NoWorkflowEnabledErr);

        exit(true);
    end;


    procedure IsGenericApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
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
        Employee: Record Employee;
        TransferHeader: Record "Transfer Header";
        PurchRequisition: Record "Requisition Wksh. Name";
        //QuoteEvaluation: Record "Purchase Req. Header";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        //StockTransHeader: Record "Stock Transaction Header";
        TravelHeader: Record "Travel Header";
        PayrollVariable: Record "Payroll Variable Header";
        EmpUpdate: Record "Employee Update Header";
        DocName: Text;
        GemsWorkflowEvent: Codeunit "Gems Workflow Event";
    //CashLiteTransaction: Record "CashLite Trans Header";
    begin
        case RecRef.Number of
            Database::"Payment Request Header":
                begin
                    RecRef.SetTable(PaymentReq);
                    DocName := 'PAYMENTREQUEST';
                    exit(WorkflowManagement.CanExecuteWorkflow(PaymentReq, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Payment Header":
                begin
                    RecRef.SetTable(PaymentHeader);
                    DocName := 'PAYMENTDOC';
                    exit(WorkflowManagement.CanExecuteWorkflow(PaymentHeader, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Cash Receipt Header":
                begin
                    RecRef.SetTable(CashReceiptHeader);
                    DocName := 'CASHRECEIPTDOC';
                    exit(WorkflowManagement.CanExecuteWorkflow(CashReceiptHeader, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Cheque File":
                begin
                    RecRef.SetTable(ChequeFile);
                    DocName := 'CHEQUE';
                    exit(WorkflowManagement.CanExecuteWorkflow(ChequeFile, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Cash Lodgement":
                begin
                    RecRef.SetTable(CashLodgement);
                    DocName := 'CASHLODGEMENT';
                    exit(WorkflowManagement.CanExecuteWorkflow(CashLodgement, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;

            Database::"Payroll-Loan":
                begin
                    RecRef.SetTable(PayrollLoans);
                    DocName := 'LOANAPPLICATION';
                    exit(WorkflowManagement.CanExecuteWorkflow(PayrollLoans, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Payroll-Period":
                begin
                    RecRef.SetTable(PayrollPeriod);
                    DocName := 'PAYROLL';
                    exit(WorkflowManagement.CanExecuteWorkflow(PayrollPeriod, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Payroll Variable Header":
                begin
                    RecRef.SetTable(PayrollVariable);
                    DocName := 'PAYROLLVARIABLE';
                    exit(WorkflowManagement.CanExecuteWorkflow(PayrollVariable, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Leave Schedule Header":
                begin
                    RecRef.SetTable(LeaveSchedule);
                    DocName := 'LEAVESCHEDULE';
                    exit(WorkflowManagement.CanExecuteWorkflow(LeaveSchedule, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Leave Application":
                begin
                    RecRef.SetTable(LeaveApplication);
                    DocName := 'LEAVEAPPLICATION';
                    exit(WorkflowManagement.CanExecuteWorkflow(LeaveApplication, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumption);
                    DocName := 'LEAVERESUMPTION';
                    exit(WorkflowManagement.CanExecuteWorkflow(LeaveResumption, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Employee Requisition":
                begin
                    RecRef.SetTable(EmpRequisition);
                    DocName := 'EMPLOYEEREQUISITION';
                    exit(WorkflowManagement.CanExecuteWorkflow(EmpRequisition, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Employee Exit":
                begin
                    RecRef.SetTable(EmployeeExit);
                    DocName := 'EMPLOYEEEXIT';
                    exit(WorkflowManagement.CanExecuteWorkflow(EmployeeExit, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Appraisal Header":
                begin
                    RecRef.SetTable(Appraisal);
                    DocName := 'APPRAISAL';
                    exit(WorkflowManagement.CanExecuteWorkflow(Appraisal, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::Employee:
                begin
                    RecRef.SetTable(Employee);
                    DocName := 'EMPLOYEERECORD';
                    exit(WorkflowManagement.CanExecuteWorkflow(Employee, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Travel Header":
                begin
                    RecRef.SetTable(TravelHeader);
                    DocName := 'TRAVELREQUEST';
                    exit(WorkflowManagement.CanExecuteWorkflow(TravelHeader, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Employee Update Header":
                begin
                    RecRef.SetTable(EmpUpdate);
                    DocName := 'EMPLOYEEUPDATE';
                    exit(WorkflowManagement.CanExecuteWorkflow(EmpUpdate, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            Database::"Requisition Wksh. Name":
                begin
                    RecRef.SetTable(PurchRequisition);
                    DocName := 'PURCHREQUISITION';
                    exit(WorkflowManagement.CanExecuteWorkflow(PurchRequisition, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
            /*Database::"Purchase Req. Header":
                begin
                    RecRef.SetTable(QuoteEvaluation);
                    DocName := 'BIDEVALUATION';
                    exit(WorkflowManagement.CanExecuteWorkflow(QuoteEvaluation, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;*/
            Database::"Warehouse Receipt Header":
                begin
                    RecRef.SetTable(WarehouseReceiptHeader);
                    DocName := 'WAREHOUSERECEIPTHEADER';
                    exit(WorkflowManagement.CanExecuteWorkflow(WarehouseReceiptHeader, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                      DocName)));
                end;
        /* Database::"Stock Transaction Header":
             begin
                 RecRef.SetTable(StockTransHeader);
                 case StockTransHeader."Document Type" of
                     StockTransHeader."document type"::SRN:
                         begin
                             DocName := 'STOCKREQUISITION';
                             exit(WorkflowManagement.CanExecuteWorkflow(StockTransHeader, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                               DocName)));
                         end;
                     StockTransHeader."document type"::STOCKRET:
                         begin
                             DocName := 'STOCKRETURN';
                             exit(WorkflowManagement.CanExecuteWorkflow(StockTransHeader, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                               DocName)));
                         end;
                 end;
             end;
         Database::"CashLite Trans Header":
             begin
                 RecRef.SetTable(CashLiteTransaction);
                 DocName := 'CASHLITETRANSACTION';
                 exit(WorkflowManagement.CanExecuteWorkflow(CashLiteTransaction, GemsWorkflowEvent.RunWorkflowOnSendGenericDocForApprovalCode(
                   DocName)));
             end;*/


        end;
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelGenericDocForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendGenericDocForApproval(RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnPopulateApprovalEntryArgumentCode(RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        PaymentReq: Record "Payment Request Header";
        PaymentHeader: Record "Payment Header";
        ChequeFile: Record "Cheque File";
        CashReceiptHeader: Record "Cash Receipt Header";
        CashLodgement: Record "Cash Lodgement";
        PayrollPayslipHeader: Record "Payroll-Payslip Header";
        PayrollLoan: Record "Payroll-Loan";
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
        //QuoteEvaluation: Record "Purchase Req. Header";
        Employee: Record Employee;
        TransferHeader: Record "Transfer Header";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        //StockTransHeader: Record "Stock Transaction Header";
        TravelHeader: Record "Travel Header";
        PayrollVariable: Record "Payroll Variable Header";
        EmpUpdate: Record "Employee Update Header";
        ApprovalAmount: Decimal;
        ApprovalAmountLCY: Decimal;
        AboveCreditLimitAmountLCY: Decimal;
        TemplateName: Code[20];
        DocTypeFieldNo: Integer;
        DocTypeOptionNo: Integer;
        OptionValue: Integer;
        DocTypeNo: Integer;
        Desc: Text[50];
    //CashLiteTransaction: Record "CashLite Trans Header";
    begin
        if WorkflowStepArgument.Get(WorkflowStepInstance.Argument) then
            ApprovalEntryArgument."Workflow User Group" := WorkflowStepArgument."Workflow User Group Code";
        case RecRef.Number of
            Database::"Payment Header":
                begin
                    RecRef.SetTable(PaymentHeader);
                    PaymentHeader.CalcFields(PaymentHeader.Amount, PaymentHeader."Amount (LCY)");
                    ApprovalEntryArgument."Document No." := PaymentHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := PaymentHeader.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := PaymentHeader."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := PaymentHeader."Currency Code";
                    ApprovalEntryArgument.Description := PaymentHeader."Posting Description";
                end;
            Database::"Payment Request Header":
                begin
                    RecRef.SetTable(PaymentReq);
                    //SetBeneficiary(PaymentReq.Beneficiary);
                    PaymentReq.CalcFields(Amount, "Amount (LCY)");
                    ApprovalEntryArgument."Document No." := PaymentReq."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := PaymentReq.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := PaymentReq."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := PaymentReq."Currency Code";
                    ApprovalEntryArgument.Description := PaymentReq."Posting Description";
                end;
            Database::"Cash Receipt Header":
                begin
                    RecRef.SetTable(CashReceiptHeader);
                    CashReceiptHeader.CalcFields(Amount, "Amount (LCY)");
                    ApprovalEntryArgument."Document No." := CashReceiptHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := CashReceiptHeader.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := CashReceiptHeader."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := CashReceiptHeader."Currency Code";
                    ApprovalEntryArgument.Description := CashReceiptHeader."Posting Description";
                end;
            Database::"Cash Lodgement":
                begin
                    RecRef.SetTable(CashLodgement);
                    ApprovalEntryArgument."Document No." := CashLodgement."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := CashLodgement.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := CashLodgement."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := CashLodgement."Currency Code";
                    ApprovalEntryArgument.Description := CashLodgement.Description;
                end;
            Database::"Cheque File":
                begin
                    RecRef.SetTable(ChequeFile);
                    ApprovalEntryArgument."Document No." := ChequeFile."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := ChequeFile.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := ChequeFile."Amount (LCY)";
                    ApprovalEntryArgument."Currency Code" := ChequeFile."Currency Code";
                    ApprovalEntryArgument.Description := ChequeFile.Description;
                end;

            //HR - Payroll
            Database::"Payroll-Loan":
                begin
                    RecRef.SetTable(PayrollLoan);
                    ApprovalEntryArgument."Document No." := PayrollLoan."Loan ID";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := PayrollLoan."Loan Amount";
                    ApprovalEntryArgument."Amount (LCY)" := PayrollLoan."Loan Amount";
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := PayrollLoan.Description;
                end;
            Database::"Payroll-Period":
                begin
                    RecRef.SetTable(PayrollPeriod);
                    ApprovalEntryArgument."Document No." := PayrollPeriod."Period Code";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := 0;
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := PayrollPeriod.Name
                end;
            Database::"Employee Requisition":
                begin
                    RecRef.SetTable(EmpRequisition);
                    ApprovalEntryArgument."Document No." := EmpRequisition."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := 0;
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := EmpRequisition.Description;
                end;
            Database::"Leave Application":
                begin
                    RecRef.SetTable(LeaveApplication);
                    ApprovalEntryArgument."Document No." := LeaveApplication."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := 0;
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := LeaveApplication.Description;
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumption);
                    ApprovalEntryArgument."Document No." := LeaveResumption."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := 0;
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := 'Leave Resumption';
                end;
            Database::"Leave Schedule Header":
                begin
                    RecRef.SetTable(LeaveSchedule);
                    ApprovalEntryArgument."Document No." := LeaveSchedule."Employee No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := 0;
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := 'Leave Schedule';
                end;
            Database::"Employee Exit":
                begin
                    RecRef.SetTable(EmployeeExit);
                    ApprovalEntryArgument."Document No." := EmployeeExit."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := 0;
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := 'Employee Exit';
                end;
            Database::"Appraisal Header":
                begin
                    RecRef.SetTable(Appraisal);
                    ApprovalEntryArgument."Document No." := Appraisal."Appraisee No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := 0;
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := 'Appraisal Approval';
                end;
            Database::"Travel Header":
                begin
                    RecRef.SetTable(TravelHeader);
                    //SetBeneficiary(PaymentReq.Beneficiary);
                    TravelHeader.CalcFields("Total Allowance Cost", "Total Allowance Cost (LCY)");
                    ApprovalEntryArgument."Document No." := TravelHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := TravelHeader."Total Allowance Cost";
                    ApprovalEntryArgument."Amount (LCY)" := TravelHeader."Total Allowance Cost (LCY)";
                    ApprovalEntryArgument."Currency Code" := TravelHeader."Currency Code";
                    ApprovalEntryArgument.Description := TravelHeader."Purpose of Travel";
                end;
            Database::"Payroll Variable Header":
                begin
                    RecRef.SetTable(PayrollVariable);
                    ApprovalEntryArgument."Document No." := PayrollVariable."E/D Code";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    //ApprovalEntryArgument.Amount := TravelHeader."Total Allowance Cost";
                    //ApprovalEntryArgument."Amount (LCY)" := TravelHeader."Total Allowance Cost (LCY)";
                    ApprovalEntryArgument.Description := PayrollVariable."Payslip Text";
                end;
            Database::"Employee Update Header":
                begin
                    RecRef.SetTable(EmpUpdate);
                    ApprovalEntryArgument."Document No." := EmpUpdate."Document No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    //ApprovalEntryArgument.Amount := TravelHeader."Total Allowance Cost";
                    //ApprovalEntryArgument."Amount (LCY)" := TravelHeader."Total Allowance Cost (LCY)";
                    ApprovalEntryArgument.Description := EmpUpdate.Description;
                end;
            //Procurement
            Database::"Requisition Wksh. Name":
                begin
                    RecRef.SetTable(PurchRequisition);
                    PurchRequisition.CalcFields(Amount, "Amount ( LCY)", "Total Quantity");
                    ApprovalEntryArgument."Document No." := PurchRequisition.Name;
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := PurchRequisition.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := PurchRequisition."Amount ( LCY)";
                    ApprovalEntryArgument."Currency Code" := PurchRequisition."Currency Code";
                    ApprovalEntryArgument.Description := PurchRequisition.Description;
                end;
            /*Database::"Purchase Req. Header":
                begin
                    RecRef.SetTable(QuoteEvaluation);
                    ApprovalEntryArgument."Document No." := QuoteEvaluation."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument.Amount := 0;
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := QuoteEvaluation.Description;
                end;*/
            Database::"Warehouse Receipt Header":
                begin
                    RecRef.SetTable(WarehouseReceiptHeader);
                    ApprovalEntryArgument."Document No." := WarehouseReceiptHeader."No.";
                    ApprovalEntryArgument."Salespers./Purch. Code" := '';
                    ApprovalEntryArgument."Amount (LCY)" := 0;
                    ApprovalEntryArgument."Currency Code" := '';
                    ApprovalEntryArgument.Description := 'Warehouse Receipt';
                end;
        /*Database::"Stock Transaction Header":
            begin
                RecRef.SetTable(StockTransHeader);
                ApprovalEntryArgument."Document No." := StockTransHeader."No.";
                ApprovalEntryArgument."Salespers./Purch. Code" := '';
                ApprovalEntryArgument."Amount (LCY)" := 0;
                ApprovalEntryArgument."Currency Code" := '';
                case StockTransHeader."Document Type" of
                    StockTransHeader."document type"::SRN:
                        ApprovalEntryArgument.Description := 'Stock Requisition';
                    StockTransHeader."document type"::STOCKRET:
                        ApprovalEntryArgument.Description := 'Stock Return';
                end;
            end;
        Database::"CashLite Trans Header":
            begin
                RecRef.SetTable(CashLiteTransaction);
                CashLiteTransaction.CalcFields("Total Amount");
                ApprovalEntryArgument."Document No." := CashLiteTransaction."Batch Number";
                ApprovalEntryArgument."Salespers./Purch. Code" := '';
                ApprovalEntryArgument.Amount := CashLiteTransaction."Total Amount";
                ApprovalEntryArgument."Amount (LCY)" := 0;
                ApprovalEntryArgument."Currency Code" := CashLiteTransaction."Currency Code";
                ApprovalEntryArgument.Description := CashLiteTransaction.Description;
            end;*/

        end;
    end;


    procedure GetTableID(TableID: Integer): Integer
    begin
        case TableID of
            Database::"Payment Header":
                exit(Database::"Payment Header");
            Database::"Payment Request Header":
                exit(Database::"Payment Request Header");
            Database::"Cheque File":
                exit(Database::"Cheque File");
            Database::"Cash Receipt Header":
                exit(Database::"Cash Receipt Header");
            Database::"Cash Lodgement":
                exit(Database::"Cash Lodgement");
            Database::"Payroll-Loan":
                exit(Database::"Payroll-Loan");
            Database::"Requisition Wksh. Name":
                exit(Database::"Requisition Wksh. Name");
            Database::"Travel Header":
                exit(Database::"Travel Header");
        //Database::"CashLite Trans Header":
        //  exit(Database::"CashLite Trans Header");
        end
    end;


    procedure GetTableIDForApproval(TableID: Integer): Integer
    begin
        case TableID of
            //Treasury
            Database::"Payment Header":
                exit(Database::"Payment Header");
            Database::"Payment Request Header":
                exit(Database::"Payment Request Header");
            Database::"Cheque File":
                exit(Database::"Cheque File");
            Database::"Cash Receipt Header":
                exit(Database::"Cash Receipt Header");
            Database::"Cash Lodgement":
                exit(Database::"Cash Lodgement");

            //HR-Payroll
            Database::"Leave Schedule Header":
                exit(Database::"Leave Schedule Header");
            Database::"Leave Application":
                exit(Database::"Leave Application");
            Database::"Leave Resumption":
                exit(Database::"Leave Resumption");
            Database::"Payroll-Loan":
                exit(Database::"Payroll-Loan");
            Database::Employee:
                exit(Database::Employee);
            Database::"Payroll-Period":
                exit(Database::"Payroll-Period");
            Database::"Employee Requisition":
                exit(Database::"Employee Requisition");
            Database::"Employee Exit":
                exit(Database::"Employee Exit");
            Database::"Appraisal Header":
                exit(Database::"Appraisal Header");
            Database::"Travel Header":
                exit(Database::"Travel Header");
            Database::"Payroll Variable Header":
                exit(Database::"Payroll Variable Header");
            Database::"Employee Update Header":
                exit(Database::"Employee Update Header");

        //Procurement
        /* Database::"Requisition Wksh. Name":
             exit(Database::"Requisition Wksh. Name");
         Database::"Purchase Req. Header":
             exit(Database::"Purchase Req. Header");
         Database::"Warehouse Receipt Header":
             exit(Database::"Warehouse Receipt Header");
         Database::"Stock Transaction Header":
             exit(Database::"Stock Transaction Header");

         //Disbursment E-Payment
         Database::"CashLite Trans Header":
             exit(Database::"Stock Transaction Header");
*/

        end
    end;


    procedure IsSufficientGenericApprover(var UserSetup: Record "User Setup"; var DocumentType: Option; var ApprovalAmountLCY: Decimal): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if UserSetup."User ID" = UserSetup."Approver ID" then
            exit(true);
        if UserSetup."Unlimited Purchase Approval" or
          ((ApprovalAmountLCY <= UserSetup."Purchase Amount Approval Limit") and (UserSetup."Purchase Amount Approval Limit" <> 0))
          then
            exit(true);
        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        ReleaseDocuments: Codeunit "Release Documents";
    begin
        case RecRef.Number of
            GetTableIDForApproval(RecRef.Number):
                begin
                    ReleaseDocuments.SetCalledFromApproval(true);
                    ReleaseDocuments.PerformManualReopen(RecRef);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        ReleaseDocuments: Codeunit "Release Documents";
    begin
        case RecRef.Number of
            GetTableIDForApproval(RecRef.Number):
                begin
                    ReleaseDocuments.SetCalledFromApproval(true);
                    ReleaseDocuments.PerformanualManualDocRelease(RecRef);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]

    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        PaymentReq: Record "Payment Request Header";
        PaymentHeader: Record "Payment Header";
        ChequeFile: Record "Cheque File";
        CashReceiptHeader: Record "Cash Receipt Header";
        CashLodgement: Record "Cash Lodgement";
        EmpRequisition: Record "Employee Requisition";
        TrainingSchedule: Record "Training Schedule Header";
        LeaveSchedule: Record "Leave Schedule Header";
        LeaveApplication: Record "Leave Application";
        LeaveResumption: Record "Leave Resumption";
        PromotionTransferBatch: Record "Employee Update Header";
        EmployeeExit: Record "Employee Exit";
        Appraisal: Record "Appraisal Header";
        PayrollPayslipHeader: Record "Payroll-Payslip Header";
        PayrollLoans: Record "Payroll-Loan";
        PurchRequisition: Record "Requisition Wksh. Name";
        //QuoteEvaluation: Record "Purchase Req. Header";
        WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        Employee: Record Employee;
        PayrollPeriod: Record "Payroll-Period";
        //StockTransHeader: Record "Stock Transaction Header";
        TravelHeader: Record "Travel Header";
        PayrollVariable: Record "Payroll Variable Header";
        EmpUpdate: Record "Employee Update Header";
    //CashLiteTransaction: Record "CashLite Trans Header";
    begin
        case RecRef.Number of
            Database::"Payment Request Header":
                begin
                    RecRef.SetTable(PaymentReq);
                    PaymentReq.Validate(Status, PaymentReq.Status::"Pending Approval");
                    PaymentReq.Modify(true);
                    Variant := PaymentReq;
                    IsHandled := true;
                end;
            Database::"Payment Header":
                begin
                    RecRef.SetTable(PaymentHeader);
                    PaymentHeader.Validate(Status, PaymentHeader.Status::"Pending Approval");
                    PaymentHeader.Modify(true);
                    Variant := PaymentHeader;
                    IsHandled := true;
                end;
            Database::"Cheque File":
                begin
                    RecRef.SetTable(ChequeFile);
                    ChequeFile.Validate(Status, ChequeFile.Status::"Pending Approval");
                    ChequeFile.Modify(true);
                    Variant := ChequeFile;
                    IsHandled := true;
                end;
            Database::"Cash Receipt Header":
                begin
                    RecRef.SetTable(CashReceiptHeader);
                    CashReceiptHeader.Validate(Status, CashReceiptHeader.Status::"Pending Approval");
                    CashReceiptHeader.Modify(true);
                    Variant := CashReceiptHeader;
                    IsHandled := true;
                end;
            Database::"Cash Lodgement":
                begin
                    RecRef.SetTable(CashLodgement);
                    CashLodgement.Validate(Status, CashLodgement.Status::"Pending Approval");
                    CashLodgement.Modify(true);
                    Variant := CashLodgement;
                    IsHandled := true;
                end;

            //HR - Payroll
            Database::"Payroll-Loan":
                begin
                    RecRef.SetTable(PayrollLoans);
                    PayrollLoans.Validate(Status, PayrollLoans.Status::"Pending Approval");
                    PayrollLoans.Modify(true);
                    Variant := PayrollLoans;
                    IsHandled := true;
                end;
            Database::"Payroll-Period":
                begin
                    RecRef.SetTable(PayrollPeriod);
                    PayrollPeriod.Validate(Status, PayrollPeriod.Status::"Pending Approval");
                    PayrollPeriod.Modify(true);
                    Variant := PayrollPeriod;
                    IsHandled := true;
                end;
            Database::"Leave Application":
                begin
                    RecRef.SetTable(LeaveApplication);
                    LeaveApplication.Validate(Status, LeaveApplication.Status::"Pending Approval");
                    LeaveApplication.SuspendStatusCheck(true);
                    LeaveApplication.Modify(true);
                    Variant := LeaveApplication;
                    IsHandled := true;
                end;
            Database::"Leave Resumption":
                begin
                    RecRef.SetTable(LeaveResumption);
                    LeaveResumption.Validate(Status, LeaveResumption.Status::"Pending Approval");
                    LeaveResumption.SuspendStatusCheck(true);
                    LeaveResumption.Modify(true);
                    Variant := LeaveResumption;
                    IsHandled := true;
                end;
            Database::"Leave Schedule Header":
                begin
                    RecRef.SetTable(LeaveSchedule);
                    LeaveSchedule.Validate(Status, LeaveSchedule.Status::"Pending Approval");
                    LeaveSchedule.Modify(true);
                    Variant := LeaveSchedule;
                    IsHandled := true;
                end;
            Database::"Employee Requisition":
                begin
                    RecRef.SetTable(EmpRequisition);
                    EmpRequisition.Validate(Status, EmpRequisition.Status::"Pending Approval");
                    EmpRequisition.Modify(true);
                    Variant := EmpRequisition;
                    IsHandled := true;
                end;
            Database::"Employee Exit":
                begin
                    RecRef.SetTable(EmployeeExit);
                    EmployeeExit.Validate(Status, EmployeeExit.Status::Approved);
                    EmployeeExit.Modify(true);
                    Variant := EmployeeExit;
                    IsHandled := true;
                end;
            Database::"Appraisal Header":
                begin
                    RecRef.SetTable(Appraisal);
                    Appraisal.Validate(Status, Appraisal.Status::"Pending Approval");
                    Appraisal.Modify(true);
                    Variant := Appraisal;
                    IsHandled := true;
                end;
            Database::"Travel Header":
                begin
                    RecRef.SetTable(TravelHeader);
                    TravelHeader.Validate(Status, TravelHeader.Status::"Pending Approval");
                    TravelHeader.Modify(true);
                    Variant := TravelHeader;
                    IsHandled := true;
                end;
            Database::"Payroll Variable Header":
                begin
                    RecRef.SetTable(PayrollVariable);
                    PayrollVariable.Validate(Status, PayrollVariable.Status::"Pending Approval");
                    PayrollVariable.Modify(true);
                    Variant := PayrollVariable;
                    IsHandled := true;
                end;
            Database::"Employee Update Header":
                begin
                    RecRef.SetTable(EmpUpdate);
                    EmpUpdate.Validate(Status, EmpUpdate.Status::"Pending Approval");
                    EmpUpdate.Modify(true);
                    Variant := EmpUpdate;
                    IsHandled := true;
                end;

            //Procurement
            Database::"Requisition Wksh. Name":
                begin
                    RecRef.SetTable(PurchRequisition);
                    PurchRequisition.Validate(Status, PurchRequisition.Status::"Pending Approval");
                    PurchRequisition.Modify(true);
                    Variant := PurchRequisition;
                    IsHandled := true;
                end;
            /*Database::"Purchase Req. Header":
                begin
                    RecRef.SetTable(QuoteEvaluation);
                    QuoteEvaluation.Validate(Status, QuoteEvaluation.Status::"Pending Approval");
                    QuoteEvaluation.Modify(true);
                    Variant := QuoteEvaluation;
                    IsHandled := true;
                end;*/
            Database::"Warehouse Receipt Header":
                begin
                    RecRef.SetTable(WarehouseReceiptHeader);
                    WarehouseReceiptHeader.Validate(Status, WarehouseReceiptHeader.Status::"Pending Approval");
                    WarehouseReceiptHeader.Modify(true);
                    Variant := WarehouseReceiptHeader;
                    IsHandled := true;
                end;
        /*Database::"Stock Transaction Header":
            begin
                RecRef.SetTable(StockTransHeader);
                StockTransHeader.Validate(Status, StockTransHeader.Status::"Pending Approval");
                StockTransHeader.Modify(true);
                Variant := StockTransHeader;
                IsHandled := true;
            end;

        //Disbursment E-Payment
        Database::"CashLite Trans Header":
            begin
                RecRef.SetTable(CashLiteTransaction);
                CashLiteTransaction.Validate(Status, CashLiteTransaction.Status::"Pending Approval");
                CashLiteTransaction.Modify(true);
                Variant := CashLiteTransaction;
                IsHandled := true;
            end;*/
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeApprovalEntryInsert', '', false, false)]

    procedure OnBeforeApprovalEntryInsert(var ApprovalEntry: Record "Approval Entry"; ApprovalEntryArgument: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
    begin
        ApprovalEntry."Workflow User Group" := ApprovalEntryArgument."Workflow User Group";
        ApprovalEntry.Description := ApprovalEntryArgument.Description;
        UserSetup.Get(ApprovalEntry."Approver ID");
        UserSetup.TestField("Employee No.");
        ApprovalEntry."Employee No." := UserSetup."Employee No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.1535", 'OnApproveApprovalRequestHook', '', false, false)]

    procedure OnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        lApprovalEntry: Record "Approval Entry";
    begin
        if RequiredApprovalReached(ApprovalEntry) then begin
            lApprovalEntry.SetCurrentkey("Table ID", "Document No.", "Workflow User Group", Status);
            lApprovalEntry.SetRange("Table ID", ApprovalEntry."Table ID");
            lApprovalEntry.SetRange("Document No.", ApprovalEntry."Document No.");
            lApprovalEntry.SetRange("Workflow User Group", ApprovalEntry."Workflow User Group");
            lApprovalEntry.SetRange(Status, lApprovalEntry.Status::Created, lApprovalEntry.Status::Open);
            lApprovalEntry.ModifyAll(Status, lApprovalEntry.Status::Approved);
            lApprovalEntry.ModifyAll("Last Date-Time Modified", CurrentDatetime);
            lApprovalEntry.ModifyAll("Last Modified By User ID", UserId);
        end;
    end;


    procedure RequiredApprovalReached(ApprovalEntry: Record "Approval Entry"): Boolean
    var
        ApprovalEntry2: Record "Approval Entry";
        WorkflowUserGrp: Record "Workflow User Group";
    begin
        if ApprovalEntry."Workflow User Group" = '' then
            exit;
        WorkflowUserGrp.Get(ApprovalEntry."Workflow User Group");
        if WorkflowUserGrp."No. of Required Approvals" = 0 then
            exit;
        ApprovalEntry.CalcFields("Number of Approved Requests");
        exit(ApprovalEntry."Number of Approved Requests" >= WorkflowUserGrp."No. of Required Approvals");
    end;


    procedure SendIMNotification(RecordLink: Record "Record Link")
    var
        Sender: Record "User Setup";
        Receiver: Record "User Setup";
        GlobalSender: Text;
        Subject: Text;
        Body: Text;
        TextLine: Text;
        SMTP: Codeunit "SMTP Mail";
        TextMsg: label 'Kindly log in to NAV to view message';
    begin
        Sender.Get(UserId);
        Receiver.Get(RecordLink."To User ID");
        GlobalSender := COMPANYNAME;
        Body := 'There is an Instant Message for your action on NAV';
        Subject := 'Instant Message Notification';
        SMTP.CreateMessage(GlobalSender, Sender."E-Mail", Receiver."E-Mail", Subject, Body, true);
        TextLine := '<p class="MsoNormal"><span style="font-family:Arial size 2">' + TextMsg + '</span></p>';
        SMTP.AppendBody(TextLine);
        SMTP.Send;
    end;
}

