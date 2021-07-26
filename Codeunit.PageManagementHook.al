Codeunit 52092132 "PageManagement Hook"
{

    // trigger OnRun()
    // begin
    // end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', false, false)]

    // procedure OnConditionalPageIDNotFound(RecordRef: RecordRef; var CardPageID: Integer)
    // begin
    //     CardPageID := GetConditionalCardPageID(RecordRef);
    // end;


    // procedure GetConditionalCardPageID(RecordRef: RecordRef): Integer
    // begin
    //     case RecordRef.Number of
    //         Database::"Payment Request Header":
    //             exit(GetPaymentReqPageID(RecordRef));
    //         Database::"Payment Header":
    //             exit(GetPaymentHeaderPageID(RecordRef));
    //         Database::"Cash Lodgement":
    //             exit(Page::"Cash Lodgement Card");
    //         Database::"Cheque File":
    //             exit(Page::"Cheque  Register");

    //         //HR-Payroll
    //         Database::"Leave Application":
    //             exit(GetLeavePageID(RecordRef));
    //         Database::"Leave Schedule Header":
    //             exit(Page::"Leave Schedule Header -ESS");
    //         Database::"Cash Receipt Header":
    //             exit(Page::"Cash Receipt");
    //         Database::"Cash Lodgement":
    //             exit(Page::"Cash Lodgement Card");
    //         Database::"Employee Requisition":
    //             exit(Page::"Employee Req. Card - Line Mgr");
    //         Database::Employee:
    //             exit(Page::"Employee Card");
    //         Database::"Payroll-Loan":
    //             exit(Page::"Payroll Internal Loan Card");
    //         Database::"Payroll-Period":
    //             exit(Page::"Payroll Periods");
    //         Database::"Travel Header":
    //             exit(Page::"Travel Request-ESS");
    //         Database::"Appraisal Header":
    //             exit(Page::"Appraisal - Line Manager");
    //         Database::"Payroll Variable Header":
    //             exit(Page::"Payroll Variable Card");
    //         Database::"Employee Update Header":
    //             exit(Page::"Employee Update Card");

    //         //Procurement
    //         Database::"Requisition Wksh. Name":
    //             exit(GetReqWorkSheetPageID(RecordRef));
    //         Database::"Purchase Req. Header":
    //             exit(Page::"Quote Evaluation");
    //         Database::"Transfer Header":
    //             exit(Page::"Transfer Order");
    //         Database::"Warehouse Receipt Header":
    //             exit(Page::"Warehouse Receipt");
    //         Database::"Stock Transaction Header":
    //             exit(GetStockTransHeaderPageID(RecordRef));
    //     end;
    // end;


    // procedure GetPaymentHeaderPageID(RecordRef: RecordRef): Integer
    // var
    //     PaymentHeader: Record "Payment Header";
    // begin
    //     RecordRef.SetTable(PaymentHeader);
    //     case PaymentHeader."Document Type" of
    //         PaymentHeader."document type"::"Payment Voucher":
    //             exit(Page::"Payment Voucher");
    //         PaymentHeader."document type"::Retirement:
    //             exit(Page::"Cash Advance Retirement - ESS");
    //     end;
    // end;


    // procedure GetReqWorkSheetPageID(RecordRef: RecordRef): Integer
    // var
    //     ReqWorkSheetName: Record "Requisition Wksh. Name";
    //     PurchaseReqHeader: Record "Purchase Req. Header";
    // begin
    //     RecordRef.SetTable(ReqWorkSheetName);
    //     case ReqWorkSheetName."Worksheet Template Name" of
    //         'P-REQ':
    //             exit(Page::"PRN-ESS");
    //     end;
    // end;


    // procedure GetLeavePageID(RecordRef: RecordRef): Integer
    // var
    //     EmployeeLeave: Record "Leave Application";
    // begin
    //     RecordRef.SetTable(EmployeeLeave);
    //     case EmployeeLeave."Entry Type" of
    //         EmployeeLeave."entry type"::Application:
    //             exit(Page::"Leave Application Card -ESS");
    //         EmployeeLeave."entry type"::"Negative Adjustment",
    //       EmployeeLeave."entry type"::"Positive Adjustment":
    //             exit(Page::"Leave Adjustment");
    //     end;
    // end;

    // local procedure GetPurchaseReqHeaderPageID(RecordRef: RecordRef): Integer
    // var
    //     PurchaseReqHeader: Record "Purchase Req. Header";
    // begin
    // end;

    // local procedure GetPaymentReqPageID(RecordRef: RecordRef): Integer
    // var
    //     PaymentRequest: Record "Payment Request Header";
    // begin
    //     RecordRef.SetTable(PaymentRequest);
    //     case PaymentRequest."Document Type" of
    //         PaymentRequest."document type"::"Cash Account":
    //             exit(Page::"Payment Request - ESS");
    //         PaymentRequest."document type"::"Float Account":
    //             exit(Page::"Float Payment Request - ESS");
    //     end;
    // end;


    // procedure GetStockTransHeaderPageID(RecordRef: RecordRef): Integer
    // var
    //     StockTransHeader: Record "Stock Transaction Header";
    // begin
    //     RecordRef.SetTable(StockTransHeader);
    //     case StockTransHeader."Document Type" of
    //         StockTransHeader."document type"::SRN:
    //             exit(Page::"Stock Requisition - ESS");
    //         StockTransHeader."document type"::STOCKRET:
    //             exit(Page::"Stock Return-ESS");
    //     end;
    // end;
}

