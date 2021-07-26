Page 52092470 "Processed Leave"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Employee Absence";
    SourceTableView = where("Entry Type"=const(Application));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(YearNo;"Year No.")
                {
                    ApplicationArea = Basic;
                }
                field(LeaveApplicationID;"Leave Application ID")
                {
                    ApplicationArea = Basic;
                }
                field(ApplicationDate;"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(FromDate;"From Date")
                {
                    ApplicationArea = Basic;
                }
                field(ToDate;"To Date")
                {
                    ApplicationArea = Basic;
                }
                field(CauseofAbsenceCode;"Cause of Absence Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(ResumptionDate;"Resumption Date")
                {
                    ApplicationArea = Basic;
                }
                field(LeaveAmountPaid;"Leave Amount Paid")
                {
                    ApplicationArea = Basic;
                }
                field(ProcessAllowancePayment;"Process Allowance Payment")
                {
                    ApplicationArea = Basic;
                }
                field(ReliefNo;"Relief No.")
                {
                    ApplicationArea = Basic;
                }
                field(LeavePaid;"Leave Paid")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        HRSetup.Get;
        SetRange("Cause of Absence Code",HRSetup."Annual Leave Code");
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CallledFromPayroll then
          CreateLines;
    end;

    var
        HRSetup: Record "Human Resources Setup";
        PayrollVariable: Record "Payroll Variable Header";
        CallledFromPayroll: Boolean;
        GetLeave: Codeunit "Payroll-Management";


    procedure SetParameters(lCallledFromPayroll: Boolean;lPayrollVariable: Record "Payroll Variable Header")
    begin
        CallledFromPayroll := lCallledFromPayroll;
        PayrollVariable.Get(lPayrollVariable."Payroll Period",lPayrollVariable."E/D Code");
    end;


    procedure CreateLines()
    begin
        CurrPage.SetSelectionFilter(Rec);
        GetLeave.SetPayrollVariable(PayrollVariable);
        GetLeave.CreateLeaveVariableLines(Rec);
    end;
}

