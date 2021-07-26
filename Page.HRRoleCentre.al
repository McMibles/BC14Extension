Page 52092448 "HR Role Centre"
{
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1000000001)
            {
                part(Control1000000023; "HR Activities")
                {
                    Caption = 'HR Activities';
                }
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
            action("<Action1000000006>")
            {
                ApplicationArea = Basic;
                Caption = 'Employee Profile';
                Image = "Report";
                RunObject = Report "Employee Profile";
            }
            action("<Action1000000039>")
            {
                ApplicationArea = Basic;
                Caption = 'Employee Age Report';
                Image = "Report";
                RunObject = Report "Employee - Age Report";
            }
            action(EmployeeAddress)
            {
                ApplicationArea = Basic;
                Caption = 'Employee Address';
                Image = "Report";
                RunObject = Report "Employee - Addresses";
            }
            action(EmployeePhones)
            {
                ApplicationArea = Basic;
                Caption = 'Employee Phones';
                Image = "Report";
                RunObject = Report "Employee - Phone Nos.";
            }
            action(EmployeeAbsences)
            {
                ApplicationArea = Basic;
                Caption = 'Employee Absences';
                Image = "Report";
                RunObject = Report "Employee - Staff Absences";
            }
            action(EmployeeAbsencesbyCause)
            {
                ApplicationArea = Basic;
                Caption = 'Employee Absences by Cause';
                Image = "Report";
                RunObject = Report "Employee - Absences by Causes";
            }
            action(EmployeeBirthdays)
            {
                ApplicationArea = Basic;
                Caption = 'Employee Birthdays';
                Image = "Report";
                RunObject = Report "Employee - Birthdays";
            }
            action("<Action1000000063>")
            {
                ApplicationArea = Basic;
                Caption = 'Employee Query Statistics';
                Image = "Report";
                RunObject = Report "Employee Query Statistics";
            }
            action("<Action1000000100>")
            {
                ApplicationArea = Basic;
                Caption = 'Employee Query List';
                Image = "Report";
                RunObject = Report "Empolyee Query List";
            }
            action(EmployeeLeaveDetail)
            {
                ApplicationArea = Basic;
                Caption = 'Employee Leave Detail';
                Image = "Report";
                RunObject = Report "Leave Detail";
            }
        }
        area(embedding)
        {
            action("<Action1000000009>")
            {
                ApplicationArea = Basic;
                Caption = 'Employee';
                RunObject = Page "Employee List";
            }

        }
        area(sections)
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                Image = Confirm;
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
            group(Leave)
            {
                Caption = 'Leave';
                action(ApprovedLeave)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approved Leave';
                    RunObject = Page "Leave Application List";
                }
                action(ProcessedLeave)
                {
                    ApplicationArea = Basic;
                    Caption = 'Processed Leave';
                    RunObject = Page "Processed Leave";
                }
                action("Unprocessed Leave Resumption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unprocessed Leave Resumption';
                    RunObject = Page "Leave Resumption List";
                    RunPageView = where(Status = const(Approved),
                                        Processed = const(false));
                }
                action("Porcessed Leave Resumption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Processed Leave Resumption';
                    RunObject = Page "Leave Resumption List";
                    RunPageView = where(Status = const(Approved),
                                        Processed = const(true));
                }
            }
            group("<Action1000000011>")
            {
                Caption = 'Recruitment';
                Image = HumanResources;
                action(EmployeeRequisition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Requisition';
                    RunObject = Page "Employee Req. List";
                }
                action("<Action1000000018>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Internal Application';
                    RunObject = Page "Internal Applicant List";
                }
                action("<Action1000000019>")
                {
                    ApplicationArea = Basic;
                    Caption = 'External Application';
                    RunObject = Page "External Applicant List";
                }
                action("<Action1000000020>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interview Schedules';
                    RunObject = Page "Interview Schedule List";
                }
                action(InterviewResults)
                {
                    ApplicationArea = Basic;
                    Caption = 'Interview Results';
                    RunObject = Page "Interview Result List";
                }
                action("<Action1000000024>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed Interviews';
                    RunObject = Page "Closed Interviews";
                }
                action("<Action1000000078>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Exit Management';
                    RunObject = Page "Exit List";
                }
            }
            group("<Action1000000012>")
            {
                Caption = 'Trainings';
                Image = ResourcePlanning;
                action(TrainingCategories)
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Categories';
                    RunObject = Page "Training Categories";
                }
                action(TrainingFacilitators)
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Facilitators';
                    RunObject = Page "Training Facilitators";
                }
                action(Venues)
                {
                    ApplicationArea = Basic;
                    Caption = 'Venues';
                    RunObject = Page Venues;
                }
                action("<Action1000000061>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Equipments';
                    RunObject = Page "Training Equipments";
                }
                action(TrainingSchedules)
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Schedules';
                    RunObject = Page "Training Schedule List";
                }
                action(TrainingEvaluation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Training Evaluation';
                    RunObject = Page Evaluations;
                }
            }
            group("<Action1000000013>")
            {
                Caption = 'Performance Management';
                Image = ReferenceData;
                action("<Action1000000056>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance';
                    RunObject = Page "HR Appraisal List";
                }
                action("<Action1000000030>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Sections';
                    RunObject = Page "Appraisal Sections";
                }
                action("<Action1000000031>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category Ratings';
                    RunObject = Page "Employee Category Ratings";
                }
                action("<Action1000000032>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Gradings';
                    RunObject = Page "Appraisal Grading";
                }
                action("<Action1000000055>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Periods';
                    RunObject = Page "Appraisal Periods";
                }
                action("<Action1000000029>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Scores';
                    RunObject = Page "Appraisal Score";
                }
                action("<Action1000000074>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance List-Line Manager';
                    RunObject = Page "Appraisal List- Line Manager";
                }
                action("<Action1000000062>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Update';
                    RunObject = Page "Employee Update List";
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
                action("Pending Payment")
                {
                    ApplicationArea = Basic;
                    RunObject = Page "Payroll Internal Loans";
                    RunPageView = where("Voucher No." = filter(<> ''),
                                        Posted = const(false));
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
            group(ActionGroup43)
            {
                Caption = 'Travel';
                action(Travel)
                {
                    ApplicationArea = Basic;
                    RunObject = Page "Travel List - Admin";
                }
            }
            group("<Action1000000016>")
            {
                Caption = 'Documents';
                Image = RegisteredDocs;
                action("<Action1000000038>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Templates';
                    RunObject = Page "Document Templates";
                }
            }
            group("<Action1000000004>")
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
                }
                separator(Action32)
                {
                    Caption = 'Employee';
                }*/
                action(EmployeeSelfUpdate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Self Update';
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
                action("Leave Resumption")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Resumption';
                    RunObject = Page "Leave Resumption List-ESS";
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
                action(PerfomanceSections)
                {
                    ApplicationArea = Basic;
                    Caption = 'Perfomance Sections';
                    RunObject = Page "Appraisal Sections -ESS";
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
            group("<Action1000000033>")
            {
                Caption = 'Administration';
                Image = Administration;
                action(HumanResUnitofMeasure)
                {
                    ApplicationArea = Basic;
                    Caption = 'Human Res. Unit of Measure';
                    RunObject = Page "Human Res. Units of Measure";
                }
                action(JobTitles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Titles';
                    RunObject = Page "Job Title List";
                }
                action(GradeLevel)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grade Level';
                    RunObject = Page "Grade Level List";
                }
                action(CausesofAbsence)
                {
                    ApplicationArea = Basic;
                    Caption = 'Causes of Absence';
                    RunObject = Page "Causes of Absence";
                }
                action(CausesofInactivity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Causes of Inactivity';
                    RunObject = Page "Causes of Inactivity";
                }
                action(GroundsforTermination)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grounds for Termination';
                    RunObject = Page "Grounds for Termination";
                }
                action(EmployeeStatisticsGrp)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Statistics Grp.';
                    RunObject = Page "Employee Statistics Groups";
                }
                action(EmploymentContracts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employment Contracts';
                    RunObject = Page "Employment Contracts";
                }
                action(Relatives)
                {
                    ApplicationArea = Basic;
                    Caption = 'Relatives';
                    RunObject = Page Relatives;
                }
                action(Unions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unions';
                    RunObject = Page Unions;
                }
                action(MiscArticles)
                {
                    ApplicationArea = Basic;
                    Caption = 'Misc. Articles';
                    RunObject = Page "Misc. Articles";
                }
                action("<Action1000000046>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Confidential';
                    RunObject = Page Confidential;
                }
                action("<Action1000000047>")
                {
                    ApplicationArea = Basic;
                    Caption = 'States';
                    RunObject = Page States;
                }
                action(LocalGovts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Local Govts';
                    RunObject = Page "Local Govts";
                }
                action(Courses)
                {
                    ApplicationArea = Basic;
                    Caption = 'Courses';
                    RunObject = Page Courses;
                }
                action("<Action1000000059>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Course Grades';
                    RunObject = Page "Course Grades";
                }
                action("<Action1000000101>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    RunObject = Page Qualifications;
                }
                action(Skills)
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    RunObject = Page Skills;
                }
                action("<Action1000000050>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Admins';
                    RunObject = Page "Pension Administrators";
                }
                action("<Action1000000051>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Categories';
                    RunObject = Page "Employee Category";
                }
                action("<Action1000000021>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cause of Query';
                    RunObject = Page "Cause of Query";
                }
                action("<Action1000000088>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Groups';
                    RunObject = Page "Travel Groups";
                }
                action("<Action1000000086>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Travel Cost Group';
                    RunObject = Page "Travel Cost Group";
                }
            }
        }
        area(processing)
        {
            group("<Action1000000052>")
            {
                Caption = 'Administration';
                action("<Action1000000034>")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Setup';
                    Image = HRSetup;
                    RunObject = Page "Human Resources Setup";
                }
                action(PublicHoliday)
                {
                    ApplicationArea = Basic;
                    Caption = 'Public Holiday';
                    Image = Holiday;
                    RunObject = Page "Public Holidays";
                }
            }
            group(ActionGroup22)
            {
                Caption = 'Leave';
                action("Leave Schedule")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Leave Schedule';
                    Image = AbsenceCalendar;
                    RunObject = Report "Create Leave Schedule";
                }
                action("Leave Schedule Worksheet")
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Schedule - WorkSheet';
                    Image = Worksheet;
                    RunObject = Page "Leave Schedule - WorkSheet";
                }
                action(LeaveAdjustment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Leave Adjustment';
                    Image = AdjustEntries;
                    RunObject = Page "Leave Adjustments";
                }
                action("Clear Rolled Over Leave")
                {
                    ApplicationArea = Basic;
                    Image = ClearLog;
                    RunObject = Report "Clear Rolled Over Leave";
                }
                action(Performance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Performance';
                    Image = CreateForm;
                    RunObject = Report "Create Appraisal";
                }
                action(Appointment)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointment List';
                    Image = Employee;
                    RunObject = Page "Appointment List";
                }
            }
            group(Welfare)
            {
                Caption = 'Welfare';
                action(LongServiceDue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Long Service Due';
                    Image = Aging;
                    RunObject = Page "Long Service Due";
                }
                action(BirthdayDue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Birthday Due';
                    Image = Period;
                    RunObject = Page "Birthday Due";
                }
                action(ConfirmationDue)
                {
                    ApplicationArea = Basic;
                    Caption = 'Confirmation Due';
                    Image = Confirm;
                    RunObject = Page "Confirmation Due";
                }
                action("<50TH Anniversary>")
                {
                    ApplicationArea = Basic;
                    Caption = '50TH Anniversary';
                    Image = CustomerRating;
                    RunObject = Page "50TH Anniversary Due";
                }
            }
        }
    }
}

