Report 52092168 "PRoll; Remove ED definitions"
{
    // Removes specified E/D(s) from the payroll entry file.

    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-E/D"; "Payroll-E/D")
        {
            DataItemTableView = sorting("E/D Code");
            RequestFilterFields = "E/D Code";
            column(ReportForNavId_9150; 9150)
            {
            }
            dataitem("Payroll-Payslip Header"; "Payroll-Payslip Header")
            {
                DataItemTableView = sorting("Employee No.", "Payroll Period");
                RequestFilterFields = "Payroll Period", "Employee No.", "Global Dimension 1 Code", "Global Dimension 2 Code";
                column(ReportForNavId_1435; 1435)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2, "Payroll-Payslip Header"."Employee No.");
                    Window.Update(3, "Payroll Period");
                    InfoCounter := InfoCounter + 1;
                    Window.Update(4, InfoCounter);
                    if not Closed then begin
                        if EntryLineRec.Get("Payroll Period", "Employee No.",
                          "Payroll-E/D"."E/D Code") then begin
                            if (EntryLineRec.Amount <> 0) then
                                EntryLineRec.Delete(true);
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    EntryLineRec.LockTable;
                    EntryLineRec.Reset;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "E/D Code");
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Current E/D   #1####\' +
                            'Current Employee Number    #2####\' +
                            'Current Period    #3#####\' +
                            'Counter   #4###');
                InfoCounter := 0;
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
        EntryLineRec: Record "Payroll-Payslip Line";
        ProllRecStore: Record "Payroll-Payslip Line";
        ProllFactorRec: Record "Payroll-Payslip Line";
        FactorLookRec: Record "Payroll-Factor Lookup";
        ReturnAmount: Decimal;
        IsComputed: Boolean;
        "E/DFileRec": Record "Payroll-E/D";
        AmtToAdd: Decimal;
        InputAmount: Decimal;
        LookHeaderRec: Record "Payroll-Lookup Header";
        LookLinesRec: Record "Payroll-Lookup Line";
        BookGrLinesRec: Record "Payroll-Posting Group Header";
        BackOneRec: Integer;
        RoundPrec: Decimal;
        RoundDir: Text[1];
        PrevLookRec: Record "Payroll-Lookup Line";
        InfoCounter: Integer;
        Window: Dialog;
}

