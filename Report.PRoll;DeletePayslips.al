Report 52092148 "PRoll; Delete Payslips"
{
    // 
    // This function deletes Payroll Entry for the specified employees.

    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; "Payroll-Payslip Header")
        {
            DataItemTableView = sorting("Payroll Period", "Employee No.");
            RequestFilterFields = "Payroll Period", "Employee No.", "Employee Category", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(ReportForNavId_7528; 7528)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(2, Employee."Employee No.");
                InfoCounter := InfoCounter + 1;
                Window.Update(3, InfoCounter);

                // payroll must not be closed
                TestField(Status, Status::Open);

                PayLinesRec.SetRange("Payroll Period", "Payroll Period");
                PayLinesRec.SetRange("Employee No.", "Employee No.");
                if PayLinesRec.Find('-') then
                    repeat
                        PayrollEd.Get(PayLinesRec."E/D Code");
                        if (PayrollEd."Loan (Y/N)") and (PayLinesRec.Amount <> 0) then begin
                            ProllLoanEntry.SetRange(ProllLoanEntry."Payroll Period", PayLinesRec."Payroll Period");
                            ProllLoanEntry.SetRange(ProllLoanEntry."Employee No.", PayLinesRec."Employee No.");
                            ProllLoanEntry.SetRange(ProllLoanEntry."E/D Code", PayLinesRec."E/D Code");
                            ProllLoanEntry.SetRange("Entry Type", ProllLoanEntry."entry type"::"Payroll Deduction");
                            if ProllLoanEntry.Find('-') then begin
                                repeat
                                    ProllLoan.Get(ProllLoanEntry."Loan ID");
                                    ProllLoanEntry.Delete;
                                    ProllLoan.CalcFields("Remaining Amount");
                                    ProllLoan."Open(Y/N)" := (ProllLoan."Remaining Amount" <> 0);
                                    ProllLoan.Modify;
                                until ProllLoanEntry.Next = 0;
                            end;
                        end;
                    until PayLinesRec.Next = 0;

                PayLinesRec.DeleteAll;
                Delete
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Total Employees Selected   #1##\' +
                            'Current Employee Number    #2###\' +
                            'Counter   #3###');
                Window.Update(1, Count);
                InfoCounter := 0;

                UserSetup.Get(UserId);
                if not (UserSetup."Payroll Administrator") then begin
                    FilterGroup(2);
                    SetFilter("Employee Category", UserSetup."Personnel Level");
                    FilterGroup(0);
                end else
                    SetRange("Employee Category");
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

    var
        PayPeriodRec: Record "Payroll-Period";
        PayHeadRec: Record "Payroll-Payslip Header";
        PayLinesRec: Record "Payroll-Payslip Line";
        PayFirstHalf: Record "Proll-Pslip Lines First Half";
        ProllLoan: Record "Payroll-Loan";
        ProllLoanEntry: Record "Payroll-Loan Entry";
        PayrollEd: Record "Payroll-E/D";
        UserSetup: Record "User Setup";
        InfoCounter: Integer;
        Window: Dialog;
        PayrollType: Option " ","First Half","Month End";
}

