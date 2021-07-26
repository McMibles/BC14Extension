Report 52092150 "PRoll; Create Next Payroll"
{
    // This batch Job copies payroll entries from one period to another for the
    // employee. Further, it closes the entries of the source period.

    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PreviousPayrollHeader; "Closed Payroll-Payslip Header")
        {
            DataItemTableView = sorting("Payroll Period", "Employee No.");
            RequestFilterFields = "Payroll Period", "Employee No.", "Employee Category";
            column(ReportForNavId_1435; 1435)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CloseAndCarry.RunOnRec(PreviousPayrollHeader, FirstHalf, NextPRollPeriod);
                Counter := Counter + 1;
                Window.Update(1, Counter);
            end;

            trigger OnPreDataItem()
            begin
                UserSetup.Get(UserId);
                if not (UserSetup."Payroll Administrator") then begin
                    FilterGroup(2);
                    if UserSetup."Personnel Level" <> '' then
                        SetFilter("Employee Category", UserSetup."Personnel Level")
                    else
                        SetRange("Employee Category");
                    FilterGroup(0);
                end else
                    SetRange("Employee Category");

                if not Confirm(Text001, true) then
                    CurrReport.Break;

                if GetFilter("Payroll Period") = '' then
                    Error(Text002);

                if GetRangeMin("Payroll Period") <> GetRangemax("Payroll Period") then
                    Error(Text003);

                Comma := ',';
                if StrPos(GetFilter("Payroll Period"), Comma) <> 0 then
                    Error(Text004);

                NextPRollPeriod.Get(GetFilter("Payroll Period"));
                if NextPRollPeriod.Next = 0 then
                    Error(Text007);
                if NextPRollPeriod.Closed then
                    Error(Text008, NextPRollPeriod."Period Code");
                if NextPRollPeriod.Status <> NextPRollPeriod.Status::Open then
                    Error(Text009, NextPRollPeriod."Period Code");

                Window.Open(Text005);

                Counter := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        PayrollType := Payrolltype::"Month End";
    end;

    trigger OnPreReport()
    begin
        PayPeriodRec.Get(PreviousPayrollHeader.GetFilter("Payroll Period"));
        if not (PayPeriodRec.Closed) then
            Error(Text006);
    end;

    var
        PayPeriodRec: Record "Payroll-Period";
        NextPRollPeriod: Record "Payroll-Period";
        UserSetup: Record "User Setup";
        YesNo: Boolean;
        FirstHalf: Boolean;
        Comma: Text[1];
        OrSymbol: Text[1];
        CloseAndCarry: Codeunit "Payroll-Management";
        Counter: Integer;
        Window: Dialog;
        PayrollType: Option " ","First Half","Month End";
        Text001: label 'Do you want to create next payroll?';
        Text002: label 'One Period must be entered as a parameter';
        Text003: label 'Transfer for multiple period is not possible';
        Text004: label 'Transfer for multiple period is not possible';
        Text005: label 'Total Number of PaySlips Created  #1#############';
        Text006: label 'The period selected is not yet closed';
        Text007: label 'The next period does not exist. Entries cannot be created';
        Text008: label 'Next period %1 has been closed ';
        Text009: label ' The next period %1 status must be open';
}

