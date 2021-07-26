PageExtension 52000055 pageextension52000055 extends "Accounting Manager Role Center"
{
    actions
    {
        addafter("Cost Accounting")
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                ToolTip = 'Request approval of your documents, cards, or journal lines or, as the approver, approve requests made by other users.';
                action("Requests Sent for Approval")
                {
                    ApplicationArea = Advanced;
                    Caption = 'Requests Sent for Approval';
                    Image = Approvals;
                    RunObject = Page "Approval Entries";
                    RunPageView = sorting("Record ID to Approve", "Workflow Step Instance ID", "Sequence No.")
                                  order(ascending)
                                  where(Status = filter(Open));
                    ToolTip = 'View the approval requests that you have sent.';
                }
                action(RequestsToApprove)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Requests to Approve';
                    Image = Approvals;
                    RunObject = Page "Requests to Approve";
                    ToolTip = 'Accept or reject other users'' requests to create or change certain documents, cards, or journal lines that you must approve before they can proceed. The list is filtered to requests where you are set up as the approver.';
                }
            }
            group("Employee Self Service")
            {
                Caption = 'Employee Self Service';
                Image = HumanResources;
                separator(Action136)
                {
                    Caption = 'Employee';
                }
                action("Payment Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Requests';
                    RunObject = Page "Payment Request List- ESS";
                }
                action("Cash Adv. Retirements")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Adv. Retirements';
                    //RunObject = Page "Cash Advance Rmt  List - ESS";
                }
                action("Float Payment Requests")
                {
                    ApplicationArea = Basic;
                    Caption = 'Float Payment Requests';
                    //RunObject = Page "Float Payment Request List-ESS";
                }
                action("Stock Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Stock Requition';
                    //RunObject = Page "Stock Requisition List - ESS";
                }
                action("Purchase Requisitions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Requisitions';
                    //RunObject = Page "PRNs-ESS";
                }
                action("Service Comp. Certificate")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Comp. Certificate';
                    //RunObject = Page "Service PO Completions";
                }
                separator(Action129)
                {
                    Caption = 'Employee';
                }
                action("Employee Self  Update")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Self  Update';
                    RunObject = Page "Employee Self  Update List";
                }
                action("Employee Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Requisition';
                    RunObject = Page "Employee Req. List- Line Mgr";
                }
                action("Annual Leave Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Annual Leave Schedule';
                    RunObject = Page "Leave Schedule List -ESS";
                }
                action("Leave Application")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Application';
                    RunObject = Page "Leave Applications - ESS";
                }
                action("Travel Request")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "Travel List- ESS";
                }
                action("Training Evaluation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Evaluation';
                    RunObject = Page "Evaluations-ESS";
                }
                action("Loan Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Loan Request';
                    RunObject = Page "Loan Request List- ESS";
                }
                action("Issue Query")
                {
                    ApplicationArea = Basic;
                    Caption = 'Issue Query';
                    RunObject = Page "Employee Queries";
                }
                action("Respond to Query")
                {
                    ApplicationArea = Basic;
                    Caption = 'Respond to Query';
                    RunObject = Page "Query Response List";
                }
                action("Process Query")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Query';
                    RunObject = Page "Query Action Register List";
                }
                action("Self Appraisal")
                {
                    ApplicationArea = Basic;
                    Caption = 'Self Appraisal';
                    RunObject = Page "Appraisal List- ESS";
                }
                action("Performance List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance List';
                    RunObject = Page "Appraisal List- Line Manager";
                }
            }
        }
    }
}

