PageExtension 52000056 pageextension52000056 extends "Bookkeeper Role Center"
{
    actions
    {
        addfirst(Sections)
        {
            group("Employee Self Service")
            {
                Caption = 'Employee Self Service';
                Image = HumanResources;
                separator(Action76)
                {
                    Caption = 'Employee';
                }
                /*  action("Payment Requests")
                  {
                      ApplicationArea = Basic;
                      Caption = 'Payment Requests';
                      RunObject = Page "Payment Request List- ESS";
                  }
                  action("Cash Adv. Retirements")
                  {
                      ApplicationArea = Basic;
                      Caption = 'Cash Adv. Retirements';
                      RunObject = Page "Cash Advance Rmt  List - ESS";
                  }
                  action("Float Payment Requests")
                  {
                      ApplicationArea = Basic;
                      Caption = 'Float Payment Requests';
                      RunObject = Page "Float Payment Request List-ESS";
                  }
                  action("Stock Requisitions")
                  {
                      ApplicationArea = Basic;
                      Caption = 'Stock Requition';
                      RunObject = Page "Stock Requisition List - ESS";
                  }
                  action("Stock Returns")
                  {
                      ApplicationArea = Basic;
                      RunObject = Page "Stock Return List - ESS";
                  }
                  action("Purchase Requisitions")
                  {
                      ApplicationArea = Basic;
                      Caption = 'Purchase Requisitions';
                      RunObject = Page "PRNs-ESS";
                  }
                  action("Service Comp. Certificate")
                  {
                      ApplicationArea = Basic;
                      Caption = 'Service Comp. Certificate';
                      RunObject = Page "Service PO Completions";
                  }
                  */
                separator(Action66)
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

