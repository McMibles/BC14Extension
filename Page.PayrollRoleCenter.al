Page 52092196 "Payroll Role Center"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1000000001)
            {
                systempart(Control1000000002; Outlook)
                {
                    Caption = 'OutLook';
                }
            }
            group(Control1000000003)
            {
                systempart(Control1000000004; MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action("Payroll Period Trend")
            {
                ApplicationArea = Basic;
                Caption = 'Payroll Period Trend';
                Image = "Report";
                RunObject = Report "Payroll Period Trend";
            }
            action("ED Entries per Period")
            {
                ApplicationArea = Basic;
                Caption = ' ED Entries per Period';
                Image = "Report";
                RunObject = Report "ED Entries per Period";
            }
            action("Pension Remittance")
            {
                ApplicationArea = Basic;
                Caption = 'Pension Remittance';
                Image = "Report";
                //RunObject = Report "Pension Remittance";
            }
            action("Pension Remittance Summary")
            {
                ApplicationArea = Basic;
                Image = "Report";
                RunObject = Report "Pension Remittance Summary";
            }
            action(CompensationInsurance)
            {
                ApplicationArea = Basic;
                Caption = 'Compensation Insurance';
                Image = "Report";
                RunObject = Report "Employee Comp. Insurance";
            }
            action("Amounts for one ED")
            {
                ApplicationArea = Basic;
                Caption = 'Amounts for one ED';
                Image = "Report";
                RunObject = Report "Amounts for one E/D";
            }
            action("Staff Loan Summary")
            {
                ApplicationArea = Basic;
                Image = "Report";
                RunObject = Report "Staff Loan - Summary Report";
            }
            action("Payroll Variation Report")
            {
                ApplicationArea = Basic;
                Caption = 'Payroll Variation Report';
                Image = "Report";
                RunObject = Report "Payroll Variation Report";
            }
            action("Payroll Monthly Variance")
            {
                ApplicationArea = Basic;
                Caption = 'Payroll Monthly Variance';
                Image = "Report";
                RunObject = Report "Payroll Monthly Variance";
            }
            action("Bank Advice")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Schedule';
                Image = "Report";
                RunObject = Report "Bank Advice";
            }
            action(PAYE)
            {
                ApplicationArea = Basic;
                Caption = 'PAYE Report';
                Image = "Report";
                RunObject = Report "PAYE Report 2";
            }
            action("PAYE by Periods")
            {
                ApplicationArea = Basic;
                Caption = 'PAYE by Periods';
                Image = "Report";
                RunObject = Report "PAYE by Period";
            }
            action("Payroll Top 10")
            {
                ApplicationArea = Basic;
                Caption = 'Top 10 Earners';
                Image = "Report";
                RunObject = Report "Payroll Top 10 Earners";
            }
            action(Payslips)
            {
                ApplicationArea = Basic;
                Caption = 'Payslips';
                Image = "Report";
                RunObject = Report "Payroll Payslip";
            }
            action("Payslip Via Email")
            {
                ApplicationArea = Basic;
                Caption = 'Payslip Via Email';
                Image = "Report";
                RunObject = Report "Payslip Via Email";
            }
        }
        area(embedding)
        {
            action(Employee)
            {
                ApplicationArea = Basic;
                Caption = 'Employee';
                RunObject = Page "Proll-Employee List";
            }
            action("Payroll Variables")
            {
                ApplicationArea = Basic;
                RunObject = Page "Payroll Variable List";
            }
            action("Payroll Periods")
            {
                ApplicationArea = Basic;
                Caption = 'Payroll Periods';
                RunObject = Page "Payroll Periods";
            }
            action("Open Periods")
            {
                ApplicationArea = Basic;
                Caption = 'Open Periods';
                RunObject = Page "Payroll Periods";
                RunPageView = where(Closed = const(false));
            }
            action("Closed Periods")
            {
                ApplicationArea = Basic;
                Caption = 'Closed Periods';
                RunObject = Page "Payroll Periods";
                RunPageView = where(Closed = const(true));
            }
        }
        area(sections)
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                ToolTip = 'Request approval of your documents, cards, or journal lines or, as the approver, approve requests made by other users.';
                action(RequestsSentforApproval)
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
            group("<Action1000000102>")
            {
                Caption = 'Staff Loans Processing';
                Image = Transactions;
                action("Internal Loans")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "Payroll Internal Loans";
                }
                action("Internal Running")
                {
                    ApplicationArea = Basic;
                    Caption = 'Running';
                    RunObject = Page "Payroll Internal Loans";
                    RunPageView = where("Open(Y/N)" = const(true),
                                        Posted = const(true),
                                        "Suspended(Y/N)" = const(false));
                }
                action("Internal Closed")
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed';
                    RunObject = Page "Payroll Internal Loans";
                    RunPageView = where("Open(Y/N)" = const(false),
                                        Posted = const(true));
                }
                action("External Loans")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "Payroll External Loans";
                }
                action("External Running")
                {
                    ApplicationArea = Basic;
                    Caption = 'Running';
                    RunObject = Page "Payroll External Loans";
                    RunPageView = where("Open(Y/N)" = const(true),
                                        "Suspended(Y/N)" = const(false));
                }
                action("External Closed")
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed';
                    RunObject = Page "Payroll External Loans";
                    RunPageView = where("Open(Y/N)" = const(false));
                }
            }
            group("Employee Self Service")
            {
                Caption = 'Employee Self Service';
                Image = HumanResources;
                action(PaymentRequests)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payment Requests';
                    RunObject = Page "Payment Request List- ESS";
                }
                /*action(CashAdvRetirements)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cash Adv. Retirements';
                    RunObject = Page "Cash Advance Rmt  List - ESS";
               
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
            }*/
                action(EmployeeSelfUpdate)
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
                action(SelfAppraisal)
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
            group(Administration)
            {
                Caption = 'Administration';
                Image = Administration;
                action("Pension Admins")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Admins';
                    RunObject = Page "Pension Administrators";
                }
                action("Earnings & Deductions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Earnings & Deductions';
                    RunObject = Page "Payroll-EDs";
                }
                action("Employee Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Group';
                    RunObject = Page "Employee Group List";
                }
                action("Table Lookup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Table Lookup';
                    RunObject = Page "Table Lookup-List";
                }
                action("Factor Lookup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Factor Lookup';
                    RunObject = Page "Factor Lookup List";
                }
                action("Posting Group")
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Group';
                    RunObject = Page "Posting Group List";
                }
                action("Payroll Statistical Group")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "Payroll Statistical Groups";
                }
            }
        }
        area(processing)
        {
            group(Setup)
            {
                Caption = 'Payroll-Setup';
                action(PayrollSetup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Setup';
                    Image = Setup;
                    RunObject = Page "Payroll-Setup";
                }
            }
            group("Periodic Activities")
            {
                action("Create Next Payroll")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Next Payroll';
                    Image = NextSet;
                    RunObject = Report "PRoll; Create Next Payroll";
                }
                action("Create Journal Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Journal Entries';
                    Image = Journal;
                    RunObject = Report "payroll mo";
                }
                action("Calculate Monthly Interest")
                {
                    ApplicationArea = Basic;
                    Caption = 'Calculate Monthly Interest';
                    Image = Calculate;
                    RunObject = Report "Calculate Monthly Interest";
                }
                action("Test Posting Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Posting Details';
                    Image = TestReport;
                    RunObject = Report "PRoll; Test Posting Details";
                }
                action("Create Bank Voucher")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Bank Voucher';
                    Image = Voucher;
                    RunObject = Report "Create Bank Payroll Vouchers";
                }
                action("Payslip Via E-mail")
                {
                    ApplicationArea = Basic;
                    Caption = 'Payslip Via Email';
                    Image = SendEmailPDF;
                    RunObject = Report "Payslip Via Email";
                }
            }
            group(Utilities)
            {
                action("Create New Payslip")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create New Payslip';
                    Image = New;
                    RunObject = Report "PRoll; Create New Payslips";
                }
                action("Recalculate Payroll Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recalculate Payroll Lines';
                    Image = Recalculate;
                    RunObject = Report "Recalculate Payroll Lines";
                }
                action("Amend Payslip Appearance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amend Payslip Appearance';
                    Image = Edit;
                    RunObject = Report "PRoll; Amend Payslip details";
                }
                action("Amend Posting Details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Amend Posting Details';
                    Image = Change;
                    RunObject = Report "PRoll; Amend Posting Details";
                }
                action("Flag Payroll Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Flag Payroll Entries';
                    Image = Calculate;
                    RunObject = Report "Flag Payroll Entries";
                }
                action("Insert ED in Payroll Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Insert ED in Payroll Lines';
                    Image = Insert;
                    RunObject = Report "Insert ED in Payroll Lines";
                }
                action("Delete Payslips")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Payslips';
                    Image = Delete;
                    RunObject = Report "PRoll; Delete Payslips";
                }
                action("Adjust Salary Scale")
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjust Salary Scale';
                    Image = AdjustEntries;
                    RunObject = Report "Adjust Salary Scale";
                }
                action("Delete ED in Payroll Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete ED in Payroll Lines';
                    Image = Delete;
                    RunObject = Report "PRoll; Remove ED definitions";
                }
                action("Change ED Amount")
                {
                    ApplicationArea = Basic;
                    Caption = 'Change ED Amount';
                    Image = Change;
                    RunObject = Report "Change E/D Amount";
                }
                action("Copy E/D From Payroll lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy E/D From Payroll lines';
                    Image = Copy;
                    RunObject = Report "Copy E/D From Payroll Payroll";
                }
                action("Calculate Arrears")
                {
                    ApplicationArea = Basic;
                    Image = CalculateCost;
                    RunObject = Report "Calculate Arrears";
                }
            }
        }
    }
}

