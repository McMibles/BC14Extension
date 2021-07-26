Page 52092689 "Treasurer  Role Center"
{
    //     Caption = 'Role Center';
    //     PageType = RoleCenter;

    //     layout
    //     {
    //         area(rolecenter)
    //         {
    //             group(Control1900724808)
    //             {
    //                 part(Control1901197008; "Treasurer Activities")
    //                 {
    //                 }
    //                 systempart(Control1901420308; Outlook)
    //                 {
    //                 }
    //             }
    //             group(Control1900724708)
    //             {
    //                 part(Control17; "My Job Queue")
    //                 {
    //                     Visible = false;
    //                 }
    //                 part(Control1907692008; "My Customers")
    //                 {
    //                 }
    //                 part(Control1902476008; "My Vendors")
    //                 {
    //                 }
    //                 systempart(Control1901377608; MyNotes)
    //                 {
    //                 }
    //             }
    //         }
    //     }

    //     actions
    //     {
    //         area(reporting)
    //         {
    //             action(AgedAccountsReceivable)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = '&Aged Accounts Receivable';
    //                 Image = "Report";
    //                 RunObject = Report "Aged Accounts Receivable";
    //             }
    //             action(AgedAccountsPayable)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Aged Accou&nts Payable';
    //                 Image = "Report";
    //                 RunObject = Report "Aged Accounts Payable";
    //             }
    //             action(BankDetailTrialBalance)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = '&Bank Detail Trial Balance';
    //                 Image = "Report";
    //                 RunObject = Report "Bank Acc. - Detail Trial Bal.";
    //             }
    //             action("Outstanding Cash Advance")
    //             {
    //                 ApplicationArea = Basic;
    //                 Image = "Report";
    //                 RunObject = Report "Outst. Cash Adv. Bal. Date";
    //             }
    //             action("Daily Cash Receipt List")
    //             {
    //                 ApplicationArea = Basic;
    //                 Image = "Report";
    //                 RunObject = Report "Daily Cash Receipt";
    //             }
    //             separator(Action53)
    //             {
    //             }
    //         }
    //         area(embedding)
    //         {
    //             action(PaymentVouchers)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Payment Vouchers';
    //                 RunObject = Page "Payment Voucher List";
    //             }
    //             action("<Open Payment Voucher List>")
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Open';
    //                 RunObject = Page "Payment Voucher List";
    //                 RunPageView = where(Status = const(Open));
    //             }
    //             action("<Pending Payment Voucher List>")
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Pending Approval';
    //                 RunObject = Page "Payment Voucher List";
    //                 RunPageView = where(Status = const("Pending Approval"));
    //             }
    //             action(CashAdvances)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Cash Advances';
    //                 RunObject = Page "Cash Advance List";
    //             }
    //             action(Open)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Open';
    //                 RunObject = Page "Cash Advance List";
    //                 RunPageView = where(Status = const(Open));
    //             }
    //             action(PendingApproval)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Pending Approval';
    //                 RunObject = Page "Cash Advance List";
    //                 RunPageView = where(Status = const("Pending Approval"));
    //             }
    //             action(InvoicesPayable)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Invoices Payable';
    //                 RunObject = Page "Invoices - Payable";
    //             }
    //             action(CashAdvRetirementPayable)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Cash Adv/ Retirement Payable';
    //                 RunObject = Page "Cash Adv./Retirement Payable";
    //             }
    //             action(BankAccounts)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Bank Accounts';
    //                 Image = BankAccount;
    //                 RunObject = Page "Bank Account List";
    //             }
    //             action(CashReceiptJournals)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Cash Receipt Journals';
    //                 Image = Journals;
    //                 RunObject = Page "General Journal Batches";
    //                 RunPageView = where("Template Type" = const("Cash Receipts"),
    //                                     Recurring = const(false));
    //             }
    //             action(PaymentJournals)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Payment Journals';
    //                 Image = Journals;
    //                 RunObject = Page "General Journal Batches";
    //                 RunPageView = where("Template Type" = const(Payments),
    //                                     Recurring = const(false));
    //             }
    //             action(GeneralJournals)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'General Journals';
    //                 Image = Journal;
    //                 RunObject = Page "General Journal Batches";
    //                 RunPageView = where("Template Type" = const(General),
    //                                     Recurring = const(false));
    //             }
    //             action(RecurringGeneralJournals)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Recurring General Journals';
    //                 RunObject = Page "General Journal Batches";
    //                 RunPageView = where("Template Type" = const(General),
    //                                     Recurring = const(true));
    //             }
    //         }
    //         area(sections)
    //         {
    //             group(CheckPayment)
    //             {
    //                 Caption = 'Check Payment';
    //                 Image = Payables;
    //                 action(Checks)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Checks';
    //                     RunObject = Page "Cheques List";
    //                 }
    //                 action(Action1000000020)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Open';
    //                     RunObject = Page "Cheques List";
    //                     RunPageView = where(Status = const(Open));
    //                 }
    //                 action(Action1000000021)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Pending Approval';
    //                     RunObject = Page "Cheques List";
    //                     RunPageView = where(Status = const("Pending Approval"));
    //                 }
    //                 action(Approved)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Approved';
    //                     RunObject = Page "Cheques List";
    //                     RunPageView = where(Status = const(Approved));
    //                 }
    //             }
    //             group(CashReceipt)
    //             {
    //                 Caption = 'Cash Receipt';
    //                 Image = Bank;
    //                 action(CashReceipts)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Cash Receipts';
    //                     RunObject = Page "Cash Receipt List";
    //                 }
    //                 action(Action1000000025)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Open';
    //                     RunObject = Page "Cash Receipt List";
    //                     RunPageView = where(Status = const(Open));
    //                 }
    //                 action(Action1000000023)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Pending Approval';
    //                     RunObject = Page "Cash Receipt List";
    //                     RunPageView = where(Status = const("Pending Approval"));
    //                 }
    //                 action(Action1000000024)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Approved';
    //                     RunObject = Page "Cash Receipt List";
    //                     RunPageView = where(Status = const(Approved));
    //                 }
    //             }
    //             group(CashLodgement)
    //             {
    //                 Caption = 'Cash Lodgement';
    //                 Image = Bank;
    //                 action(CashLodgements)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Cash Lodgements';
    //                     RunObject = Page "Cash Lodgement List";
    //                 }
    //                 action(Action1000000054)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Open';
    //                     RunObject = Page "Cash Lodgement List";
    //                     RunPageView = where(Status = const(Open));
    //                 }
    //                 action(Action1000000055)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Pending Approval';
    //                     RunObject = Page "Cash Lodgement List";
    //                     RunPageView = where(Status = const("Pending Approval"));
    //                 }
    //                 action(Action1000000056)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Approved';
    //                     RunObject = Page "Cash Lodgement List";
    //                     RunPageView = where(Status = const(Approved));
    //                 }
    //             }
    //             group(Approvals)
    //             {
    //                 Caption = 'Approvals';
    //                 ToolTip = 'Request approval of your documents, cards, or journal lines or, as the approver, approve requests made by other users.';
    //                 action(RequestsSentforApproval)
    //                 {
    //                     ApplicationArea = Advanced;
    //                     Caption = 'Requests Sent for Approval';
    //                     Image = Approvals;
    //                     RunObject = Page "Approval Entries";
    //                     RunPageView = sorting("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.")
    //                                   order(ascending)
    //                                   where(Status = filter(Open));
    //                     ToolTip = 'View the approval requests that you have sent.';
    //                 }
    //                 action(RequestsToApprove)
    //                 {
    //                     ApplicationArea = Advanced;
    //                     Caption = 'Requests to Approve';
    //                     Image = Approvals;
    //                     RunObject = Page "Requests to Approve";
    //                     ToolTip = 'Accept or reject other users'' requests to create or change certain documents, cards, or journal lines that you must approve before they can proceed. The list is filtered to requests where you are set up as the approver.';
    //                 }
    //             }
    //             group("Employee Self Service")
    //             {
    //                 Caption = 'Employee Self Service';
    //                 Image = HumanResources;
    //                 separator(Action1000000052)
    //                 {
    //                     Caption = 'Employee';
    //                 }
    //                 action(PaymentRequests)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Payment Requests';
    //                     RunObject = Page "Payment Request List- ESS";
    //                 }
    //                 action(CashAdvRetirements)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Cash Adv. Retirements';
    //                     RunObject = Page "Cash Advance Rmt  List - ESS";
    //                 }
    //                 action("Stock Requisitions")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Stock Requition';
    //                     RunObject = Page "Stock Requisition List - ESS";
    //                 }
    //                 action("Stock Returns")
    //                 {
    //                     ApplicationArea = Basic;
    //                     RunObject = Page "Stock Return List - ESS";
    //                 }
    //                 action("Purchase Requisitions")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Purchase Requisitions';
    //                     RunObject = Page "PRNs-ESS";
    //                 }
    //                 action("Service Comp. Certificate")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Service Comp. Certificate';
    //                     RunObject = Page "Service PO Completions";
    //                 }
    //                 separator(Action1000000045)
    //                 {
    //                     Caption = 'Employee';
    //                 }
    //                 action(EmployeeSelfUpdate)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Employee Self  Update';
    //                     RunObject = Page "Employee Self  Update List";
    //                 }
    //                 action("Employee Requisition")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Employee Requisition';
    //                     RunObject = Page "Employee Req. List- Line Mgr";
    //                 }
    //                 action("Annual Leave Schedule")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Annual Leave Schedule';
    //                     RunObject = Page "Leave Schedule List -ESS";
    //                 }
    //                 action("Leave Application")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Leave Application';
    //                     RunObject = Page "Leave Applications - ESS";
    //                 }
    //                 action("Training Evaluation")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Training Evaluation';
    //                     RunObject = Page "Evaluations-ESS";
    //                 }
    //                 action("Loan Request")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Loan Request';
    //                     RunObject = Page "Loan Request List- ESS";
    //                 }
    //                 action("Issue Query")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Issue Query';
    //                     RunObject = Page "Employee Queries";
    //                 }
    //                 action("Respond to Query")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Respond to Query';
    //                     RunObject = Page "Query Response List";
    //                 }
    //                 action("Process Query")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Process Query';
    //                     RunObject = Page "Query Action Register List";
    //                 }
    //                 action(SelfAppraisal)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Self Appraisal';
    //                     RunObject = Page "Appraisal List- ESS";
    //                 }
    //                 action("Performance List")
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Performance List';
    //                     RunObject = Page "Appraisal List- Line Manager";
    //                 }
    //             }
    //             group(PostedDocuments)
    //             {
    //                 Caption = 'Posted Documents';
    //                 Image = FiledPosted;
    //                 action(PostedPaymentVouchers)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Posted Payment Vouchers';
    //                     RunObject = Page "Posted Payment Vouchers";
    //                 }
    //                 action(PostedCheques)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Posted Cheques';
    //                     RunObject = Page "Check Ledger Entries";
    //                 }
    //                 action(PostedCashAdvances)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Posted Cash Advances';
    //                     RunObject = Page "Posted Cash Advances";
    //                 }
    //                 action(NotRetired)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Not Retired';
    //                     RunObject = Page "Posted Cash Advances";
    //                     RunPageView = where("Entry Status" = const(Posted),
    //                                         "Retirement Status" = filter(Open));
    //                 }
    //                 action(Retired)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Retired';
    //                     RunObject = Page "Posted Cash Advances";
    //                     RunPageView = where("Entry Status" = const(Posted),
    //                                         "Retirement Status" = const(Retired));
    //                 }
    //                 action(PendingRefundbyEmployee)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Pending Refund by Employee';
    //                     RunObject = Page "Posted Cash Advances";
    //                     RunPageView = where("Entry Status" = const(Posted),
    //                                         "Retirement Status" = const("Partially Retired"));
    //                 }
    //                 action(PostedCashAdvRetirements)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Posted Cash Adv.Retirements';
    //                     RunObject = Page "Posted Cash Adv.Retirements";
    //                 }
    //                 action(PostedCashReceipts)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Posted Cash Receipts';
    //                     RunObject = Page "Posted Cash Receipt List";
    //                 }
    //                 action(PostedCashLodgement)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'Posted Cash Lodgement';
    //                     RunObject = Page "Posted Cash Lodgement List";
    //                 }
    //                 action(GLRegisters)
    //                 {
    //                     ApplicationArea = Basic;
    //                     Caption = 'G/L Registers';
    //                     Image = GLRegisters;
    //                     RunObject = Page "G/L Registers";
    //                 }
    //             }
    //         }
    //         area(creation)
    //         {
    //             action(Voucher)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = '&Voucher';
    //                 Image = Voucher;
    //                 Promoted = false;
    //                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
    //                 //PromotedCategory = Process;
    //                 RunObject = Page "Payment Voucher";
    //                 RunPageMode = Create;
    //             }
    //             action(CashAdvance)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Cash A&dvance';
    //                 Image = Voucher;
    //                 Promoted = false;
    //                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
    //                 //PromotedCategory = Process;
    //                 RunObject = Page "Cash Advance";
    //                 RunPageMode = Create;
    //             }
    //             action(Action1000000032)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Cash Receipt';
    //                 Image = Receipt;
    //                 Promoted = false;
    //                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
    //                 //PromotedCategory = Process;
    //                 RunObject = Page "Cash Receipt";
    //                 RunPageMode = Create;
    //             }
    //         }
    //         area(processing)
    //         {
    //             separator(Action67)
    //             {
    //                 Caption = 'Tasks';
    //                 IsHeader = true;
    //             }
    //             action(CashReceiptJournal)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Cash Re&ceipt Journal';
    //                 Image = CashReceiptJournal;
    //                 RunObject = Page "Cash Receipt Journal";
    //             }
    //             action(PaymentJournal)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Payment &Journal';
    //                 Image = PaymentJournal;
    //                 RunObject = Page "Payment Journal";
    //             }
    //             separator(Action77)
    //             {
    //             }
    //             action(BankAccountReconciliations)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'B&ank Account Reconciliations';
    //                 Image = BankAccountRec;
    //                 RunObject = Page "Bank Acc. Reconciliation";
    //             }
    //             separator(Action89)
    //             {
    //                 Caption = 'History';
    //                 IsHeader = true;
    //             }
    //             action(Navigate)
    //             {
    //                 ApplicationArea = Basic;
    //                 Caption = 'Navi&gate';
    //                 Image = Navigate;
    //                 RunObject = Page Navigate;
    //             }
    //         }
    //     }
}

