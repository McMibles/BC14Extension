Report 52092149 "PRoll; Create New Payslips"
{
    // This function transfers data from the Employee group to Payroll Entry for
    // the specified employees, if the Payroll entries for these Employees in the
    // specified period do not exist.
    // If the Payroll entry exists then the lines are not copied.

    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; "Payroll-Employee")
        {
            DataItemTableView = sorting("No.") where("Appointment Status" = const(Active), "Termination Date" = filter(''));
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Appointment Status", "Termination Date";

            trigger OnAfterGetRecord()
            begin
                Window.Update(2, Employee."No.");
                if "Posting Group" = '' then
                    Error(Text000, Employee."No.");

                PayrollSetup.Get;
                PayrollSetup.TestField("Annual Gross Pay E/D Code");
                PayrollMgt.GetSalaryStructure(Employee."No.", PayPeriodRec."Start Date", EmployeeGrp,
                  AnnualGrossAmount, EmpGrpEffectiveDate);

                if EmployeeGrp = '' then
                    CurrReport.Skip;

                InfoCounter := InfoCounter + 1;
                Window.Update(3, InfoCounter);

                if (("Employment Date" <> 0D) and
                   ("Employment Date" > PayPeriodRec."End Date")) or
                   (("Termination Date" <> 0D) and
                   ("Termination Date" < PayPeriodRec."End Date")) or
                   (("Contract Start Date" <> 0D) and
                   ("Contract Start Date" > PayPeriodRec."End Date")) or
                   (("Contract Expiry Date" <> 0D) and
                   ("Contract Expiry Date" < PayPeriodRec."End Date")) or
                   (("Re-Instatement Date" <> 0D) and
                   ("Re-Instatement Date" > PayPeriodRec."End Date")) then
                    CurrReport.Skip;

                if ("Appointment Status" = "appointment status"::Inactive) and (Employee."Inactive Without Pay") then begin
                    if (Employee."Inactive Date" <> 0D) and
                      (CalcDate("Inactive Duration", "Inactive Date") > PayPeriodRec."End Date") then
                        CurrReport.Skip;
                end;

                begin
                    PayHeadRec."Payroll Period" := PayPeriodRec."Period Code";
                    PayHeadRec."Employee No." := "No.";
                    PayHeadRec."Period Start" := PayPeriodRec."Start Date";
                    PayHeadRec."Period End" := PayPeriodRec."End Date";
                    PayHeadRec."Period Name" := PayPeriodRec.Name;
                    PayHeadRec."Employee Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";
                    PayHeadRec."Global Dimension 1 Code" := "Global Dimension 1 Code";
                    PayHeadRec."Global Dimension 2 Code" := "Global Dimension 2 Code";
                    PayHeadRec.Company := CopyStr(COMPANYNAME, 1, 20);
                    PayHeadRec."Customer Number" := "Customer No.";
                    PayHeadRec."Job Title Code" := Employee."Job Title Code";
                    PayHeadRec.Designation := Designation;
                    PayHeadRec."Salary Group" := EmployeeGrp;
                    PayHeadRec."Employee Category" := "Employee Category";
                    PayHeadRec."Tax State" := "Tax State";
                    PayHeadRec."Pension Adminstrator Code" := "Pension Administrator Code";
                    PayHeadRec."CBN Bank Code" := "CBN Bank Code";
                    PayHeadRec."Bank Account" := "Bank Account";
                    EmpGrpHeader.Get(EmployeeGrp);
                    PayHeadRec.Validate("Currency Code", EmpGrpHeader."Currency Code");
                    if PayrollSetup."No. of Working Days" = 0 then
                        PayHeadRec."No. of Working Days Basis" := Date2dmy(CalcDate('CM', PayHeadRec."Period Start"), 1)
                    else
                        PayHeadRec."No. of Working Days Basis" := PayrollSetup."No. of Working Days";

                    if "Employment Date" <> 0D then
                        if ("Employment Date" > PayPeriodRec."Start Date") and ("Employment Date" < PayPeriodRec."End Date") then
                            PayHeadRec."No. of Days Worked" := Date2dmy(CalcDate('CM', PayPeriodRec."Start Date"), 1) -
                              Date2dmy("Employment Date", 1) + 1;

                    if "Employment Date" <> 0D then
                        PayHeadRec."No. of Months Worked" := ROUND(((Date2dmy(PayPeriodRec."End Date", 3) - Date2dmy("Employment Date", 3)) * 12 +
                          (Date2dmy(PayPeriodRec."End Date", 2) - Date2dmy("Employment Date", 2))), 1, '=');
                    if PayHeadRec."No. of Days Worked" = 0 then
                        PayHeadRec."No. of Days Worked" := PayHeadRec."No. of Working Days Basis";
                    PayHeadRec.CreateDim(Database::"Payroll-Employee", PayHeadRec."Employee No.");
                    PayHeadRec.Insert;
                end;

                begin
                    PayLinesRec.SetRange("Payroll Period", PayHeadRec."Payroll Period");
                    PayLinesRec.SetRange("Employee No.", PayHeadRec."Employee No.");
                    if PayLinesRec.Find('-') then begin
                        PayLinesRec.Reset;
                        CurrReport.Skip;
                    end;

                    EmpGrpLinesRec.Init;
                    EmpGrpLinesRec.SetRange("E/D Code");
                    EmpGrpLinesRec.SetRange("Employee Group");
                    if EmployeeGrp <> '' then
                        EmpGrpLinesRec."Employee Group" := EmployeeGrp
                    else
                        CurrReport.Skip;

                    EmpGrpLinesRec."E/D Code" := '';
                    if EmployeeGrp <> '' then
                        EmpGrpLinesRec.SetRange("Employee Group", EmployeeGrp)
                    else
                        CurrReport.Skip;

                    if not (EmpGrpLinesRec.Count = 0) then begin
                        PayLinesRec.LockTable;
                        PayLinesRec.SetRange("E/D Code");

                        EmpGrpLinesRec.Find('>');
                        repeat
                            EDFileRec.Get(EmpGrpLinesRec."E/D Code");
                            if EDFileRec.CheckandAllow(Employee."No.", EmployeeGrp) then begin
                                PayLinesRec.Init;
                                PayLinesRec."E/D Code" := EmpGrpLinesRec."E/D Code";
                                PayLinesRec."Payslip Text" := EmpGrpLinesRec."Payslip Text";
                                PayLinesRec."Payroll Period" := PayHeadRec."Payroll Period";
                                PayLinesRec."Employee No." := PayHeadRec."Employee No.";
                                PayLinesRec."Period Start" := PayHeadRec."Period Start";
                                PayLinesRec."Period End" := PayHeadRec."Period End";
                                PayLinesRec."Global Dimension 1 Code" := PayHeadRec."Global Dimension 1 Code";
                                PayLinesRec."Global Dimension 2 Code" := PayHeadRec."Global Dimension 2 Code";
                                PayLinesRec."Job No." := PayHeadRec."Job No.";
                                PayLinesRec."Employee Category" := PayHeadRec."Employee Category";
                                PayLinesRec."Statistics Group Code" := EDFileRec."Statistics Group Code";
                                PayLinesRec."Pos. In Payslip Grp." := EDFileRec."Pos. In Payslip Grp.";
                                PayLinesRec."Payslip Appearance" := EDFileRec."Payslip appearance";
                                PayLinesRec."Payslip Column" := EDFileRec."Payslip Column";
                                PayLinesRec.Units := EDFileRec.Units;
                                PayLinesRec.Rate := EDFileRec.Rate;
                                PayLinesRec.Reimbursable := EDFileRec.Reimbursable;
                                PayLinesRec."Overline Column" := EDFileRec."Overline Column";
                                PayLinesRec."Underline Amount" := EDFileRec."Underline Amount";
                                PayLinesRec.Compute := EDFileRec.Compute;
                                PayLinesRec."Common ID" := EDFileRec."Common Id";
                                PayLinesRec."Loan (Y/N)" := EDFileRec."Loan (Y/N)";
                                PayLinesRec."No. of Days Prorate" := EDFileRec."No. of Days Prorate";
                                PayLinesRec."No. of Months Prorate" := EDFileRec."No. of Months Prorate";
                                PayLinesRec."E/D Code" := EmpGrpLinesRec."E/D Code";
                                PayLinesRec.Units := EmpGrpLinesRec.Units;
                                PayLinesRec.Rate := EmpGrpLinesRec.Rate;
                                PayLinesRec.Quantity := EmpGrpLinesRec.Quantity;
                                PayLinesRec.Flag := EmpGrpLinesRec.Flag;
                                PayLinesRec."Currency Code" := PayHeadRec."Currency Code";
                                if (PayLinesRec."E/D Code" = PayrollSetup."Annual Gross Pay E/D Code")
                                  and (AnnualGrossAmount <> 0) then
                                    PayLinesRec.Amount := AnnualGrossAmount
                                else
                                    PayLinesRec.Amount := EmpGrpLinesRec."Default Amount";

                                if BookGrLinesRec.Get("Posting Group", PayLinesRec."E/D Code") then begin
                                    PayLinesRec."Debit Account" := BookGrLinesRec."Debit Account No.";
                                    PayLinesRec."Credit Account" := BookGrLinesRec."Credit Account No.";
                                    PayLinesRec."Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
                                    PayLinesRec."Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";

                                    if (BookGrLinesRec."Debit Acc. Type" = 1) then
                                        if "Customer No." <> '' then
                                            PayLinesRec."Debit Account" := "Customer No.";
                                    if (BookGrLinesRec."Credit Acc. Type" = 1) then
                                        if "Customer No." <> '' then
                                            PayLinesRec."Credit Account" := "Customer No.";
                                    if BookGrLinesRec."Transfer Global Dim. 1 Code" then
                                        PayLinesRec."Global Dimension 1 Code" := "Global Dimension 1 Code";
                                    if BookGrLinesRec."Transfer Global Dim. 2 Code" then
                                        PayLinesRec."Global Dimension 2 Code" := "Global Dimension 2 Code";
                                end;
                                PayLinesRec."User Id" := UserId;
                                PayLinesRec.CreateDim(Database::"Payroll-Employee", PayLinesRec."Employee No.");
                                PayLinesRec.Insert;
                            end;
                        until (EmpGrpLinesRec.Next = 0);

                        if PayLinesRec.Find('-') then
                            repeat
                                EDFileRec.Get(PayLinesRec."E/D Code");
                                if (EDFileRec."Loan (Y/N)") or (EDFileRec."No. of Days Prorate") or (EDFileRec."No. of Months Prorate") then begin
                                    PayLinesRec.ReCalculateAmount;
                                    PayLinesRec.Modify;
                                end;
                                PayLinesRec.CalcCompute(PayLinesRec, PayLinesRec.Amount, false, PayLinesRec."E/D Code");
                                PayLinesRec.CalcFactor1(PayLinesRec);
                                PayLinesRec.ChangeOthers := false;
                                PayLinesRec.ChangeAllOver(PayLinesRec, false);
                                PayLinesRec.ResetChangeFlags(PayLinesRec);
                                PayLinesRec.CalcAmountLCY;
                                PayLinesRec.Modify;
                            until PayLinesRec.Next = 0;
                    end;
                end;
                Commit;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Total Employees Selected   #1########\' +
                            'Current Employee Number    #2########\' +
                            'Counter   #3########');
                Window.Update(1, Count);
                InfoCounter := 0;

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
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(EnterthePeriod; PayPeriodRec."Period Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Enter the Period';
                    TableRelation = "Payroll-Period";
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            EmployeeGrp := '';
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        PayPeriodRec.Get(PayPeriodRec."Period Code");
        PayPeriodRec.SetRange(PayPeriodRec."Period Code");
        EmpGrpLinesRec.SetRange("Employee Group");
        EmpGrpLinesRec.SetRange("E/D Code");
        PayLinesRec.SetRange("Payroll Period");
        PayLinesRec.SetRange("Employee No.");
        PayLinesRec.SetRange("E/D Code");
    end;

    var
        PayrollSetup: Record "Payroll-Setup";
        PayPeriodRec: Record "Payroll-Period";
        PayHeadRec: Record "Payroll-Payslip Header";
        PayLinesRec: Record "Payroll-Payslip Line";
        PayFirstHalf: Record "Proll-Pslip Lines First Half";
        EmpGrpHeader: Record "Payroll-Employee Group Header";
        EmpGrpLinesRec: Record "Payroll-Employee Group Line";
        EmpGrpFirstHalf: Record "Proll-Emply Grp First Half";
        EDFileRec: Record "Payroll-E/D";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        UserSetup: Record "User Setup";
        NoofDaysWorked: Integer;
        NoofMonthsWorked: Integer;
        InfoCounter: Integer;
        AnnualGrossAmount: Decimal;
        Window: Dialog;
        LoanRec: Record "Payroll-Loan";
        GLRec: Record "G/L Entry";
        PayrollType: Option " ","First Half","Month End";
        EmployeeGrp: Code[20];
        Text000: label 'Employee %1 does not have a posting group\Make sure the posting group is filled before you proceed';
        PayrollMgt: Codeunit "Payroll-Management";
        EmpGrpEffectiveDate: Date;
}

