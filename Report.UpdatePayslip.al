Report 52092166 "Update Payslip"
{
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee; "Payroll-Employee")
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_7528; 7528)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(2, "No.");
                PeriodRec.Get(PayrollPeriod);

                if "Posting Group" = '' then
                    Error(Text000);

                PayrollSetup.Get;
                PayrollSetup.TestField("Annual Gross Pay E/D Code");
                PayrollMgt.GetSalaryStructure(Employee."No.", PeriodRec."Start Date", EmployeeGrp,
                                              FixedBasicAmount, EmpGrpEffectiveDate);

                if EmployeeGrp = '' then
                    CurrReport.Skip;

                InfoCounter := InfoCounter + 1;
                Window.Update(3, InfoCounter);
                Upgraded := false;
                NoofMonthDays := 0;
                PeriodRec.Get(PayrollPeriod);
                NoofMonthDays := Date2dmy(CalcDate('CM', PeriodRec."Start Date"), 1);

                if PeriodRec.Closed then
                    Error(Text001);

                if ProllPayslipHeader.Get(PayrollPeriod, "No.") then begin

                    if (("Employment Date" <> 0D) and
                       ("Employment Date" > PeriodRec."End Date")) or
                       (("Termination Date" <> 0D) and
                       ("Termination Date" < PeriodRec."End Date")) or
                       (("Contract Start Date" <> 0D) and
                       ("Contract Start Date" > PeriodRec."End Date")) or
                       (("Contract Expiry Date" <> 0D) and
                       ("Contract Expiry Date" < PeriodRec."End Date")) or
                       (("Re-Instatement Date" <> 0D) and
                       ("Re-Instatement Date" > PeriodRec."End Date")) then begin
                        ProllPayslipHeader.Delete(true);
                        CurrReport.Skip;
                    end;
                    if "Appointment Status" = "appointment status"::Inactive then begin
                        if (Employee."Inactive Date" <> 0D) and
                          (CalcDate("Inactive Duration", "Inactive Date") > PeriodRec."End Date") then begin
                            ProllPayslipHeader.Delete(true);
                            CurrReport.Skip;
                        end;
                    end;

                    if (ProllPayslipHeader."Global Dimension 1 Code" <> "Global Dimension 1 Code") or
                       (ProllPayslipHeader."Global Dimension 2 Code" <> "Global Dimension 2 Code") or
                       (ProllPayslipHeader."Employee Category" <> "Employee Category") then
                        UpdatePayLines := true;

                    if (EmployeeGrp <> ProllPayslipHeader."Salary Group") then
                        Upgraded := true;

                    ProllPayslipHeader."Employee Name" := "Last Name" + ',' + ' ' + "First Name" + ' ' + "Middle Name";
                    ProllPayslipHeader."Global Dimension 1 Code" := "Global Dimension 1 Code";
                    ProllPayslipHeader."Global Dimension 2 Code" := "Global Dimension 2 Code";
                    ProllPayslipHeader.Company := CopyStr(COMPANYNAME, 1, 20);
                    ProllPayslipHeader."Customer Number" := "Customer No.";
                    ProllPayslipHeader.Designation := Designation;
                    ProllPayslipHeader."Salary Group" := EmployeeGrp;
                    ProllPayslipHeader."Employee Category" := "Employee Category";
                    ProllPayslipHeader."Tax State" := "Tax State";
                    ProllPayslipHeader."CBN Bank Code" := "Preferred Bank Account";
                    ProllPayslipHeader."Bank Account" := "Bank Account";
                    EmployeeSalary.SetRange("Employee No.", Employee."No.");
                    EmployeeSalary.SetFilter("Currency Code", '<>%1', '');
                    if EmployeeSalary.FindLast then
                        ProllPayslipHeader.Validate("Currency Code", EmployeeSalary."Currency Code");
                    ProllPayslipHeader."Pension Adminstrator Code" := "Pension Administrator Code";
                    ProllPayslipHeader.Modify;
                    if (Upgraded) or (FixedBasicAmount <> 0) then begin
                        ProllPayslipLine.SetRange("Payroll Period", PayrollPeriod);
                        ProllPayslipLine.SetRange("Employee No.", "No.");
                        if ProllPayslipLine.FindFirst then
                            repeat
                                EDFile.Get(ProllPayslipLine."E/D Code");
                                if EDFile.CheckandAllow(ProllPayslipLine."Employee No.", EmployeeGrp) then begin
                                    NewPRollEntryRec := ProllPayslipLine;
                                    NewPRollEntryRec."Global Dimension 1 Code" := "Global Dimension 1 Code";
                                    NewPRollEntryRec."Global Dimension 2 Code" := "Global Dimension 2 Code";
                                    NewPRollEntryRec."Employee Category" := "Employee Category";
                                    NewPRollEntryRec.Status := 0;
                                    if EmpGroupLine.Get(EmployeeGrp, ProllPayslipLine."E/D Code") then begin
                                        NewPRollEntryRec.Units := EmpGroupLine.Units;
                                        NewPRollEntryRec.Rate := EmpGroupLine.Rate;
                                        if (NewPRollEntryRec."E/D Code" in [PayrollSetup."Annual Gross Pay E/D Code", PayrollSetup."Basic E/D Code"])
                                           and (FixedBasicAmount <> 0) then begin
                                            if NewPRollEntryRec."E/D Code" = PayrollSetup."Annual Gross Pay E/D Code" then
                                                NewPRollEntryRec.Amount := FixedBasicAmount * 12
                                            else
                                                NewPRollEntryRec.Amount := FixedBasicAmount
                                        end else
                                            NewPRollEntryRec.Amount := EmpGroupLine."Default Amount"
                                        /* Rate,Units,Amount,... */
                                    end;
                                    NewPRollEntryRec.Modify;
                                end;
                            until ProllPayslipLine.Next = 0;
                        /* Delimit the Employee group lines appropriately */
                        EmpGroupLine.Init;
                        EmpGroupLine.SetRange("E/D Code");
                        EmpGroupLine.SetRange("Employee Group");
                        EmpGroupLine."Employee Group" := EmployeeGrp;
                        EmpGroupLine."E/D Code" := '';
                        EmpGroupLine.SetRange("Employee Group", EmployeeGrp);
                        if not (EmpGroupLine.Count = 0) then begin

                            /* Transfer the E/D lines from Employe Group lines to Payroll Lines */
                            EmpGroupLine.Find('>');
                            repeat
                                if not NewPRollEntryRec.Get(PayrollPeriod, "No.", EmpGroupLine."E/D Code") then begin
                                    EDFile.Get(EmpGroupLine."E/D Code");
                                    if EDFile.CheckandAllow("No.", EmployeeGrp) then begin
                                        NewPRollEntryRec.Init;
                                        NewPRollEntryRec."Payroll Period" := ProllPayslipHeader."Payroll Period";
                                        NewPRollEntryRec."Employee No." := "No.";
                                        NewPRollEntryRec."Global Dimension 1 Code" := ProllPayslipHeader."Global Dimension 1 Code";
                                        NewPRollEntryRec."Global Dimension 2 Code" := ProllPayslipHeader."Global Dimension 2 Code";
                                        NewPRollEntryRec."Employee Category" := ProllPayslipHeader."Employee Category";

                                        EDFileRec.Get(EmpGroupLine."E/D Code");
                                        NewPRollEntryRec."E/D Code" := EmpGroupLine."E/D Code";
                                        NewPRollEntryRec."Payslip Text" := EmpGroupLine."Payslip Text";
                                        begin
                                            NewPRollEntryRec."Statistics Group Code" := EDFileRec."Statistics Group Code";
                                            NewPRollEntryRec."Pos. In Payslip Grp." := EDFileRec."Pos. In Payslip Grp.";
                                            NewPRollEntryRec."Payslip Appearance" := EDFileRec."Payslip appearance";
                                            NewPRollEntryRec.Units := EDFileRec.Units;
                                            NewPRollEntryRec.Rate := EDFileRec.Rate;
                                            NewPRollEntryRec.Reimbursable := EDFileRec.Reimbursable;
                                            NewPRollEntryRec."Overline Column" := EDFileRec."Overline Column";
                                            NewPRollEntryRec."Underline Amount" := EDFileRec."Underline Amount";
                                        end;        /* Payslip Grp/Pos */
                                        begin
                                            NewPRollEntryRec."E/D Code" := EmpGroupLine."E/D Code";
                                            NewPRollEntryRec.Units := EmpGroupLine.Units;
                                            NewPRollEntryRec.Rate := EmpGroupLine.Rate;
                                            NewPRollEntryRec.Quantity := EmpGroupLine.Quantity;
                                            NewPRollEntryRec.Flag := EmpGroupLine.Flag;
                                            if (NewPRollEntryRec."E/D Code" in [PayrollSetup."Annual Gross Pay E/D Code", PayrollSetup."Basic E/D Code"])
                                               and (FixedBasicAmount <> 0) then begin
                                                if NewPRollEntryRec."E/D Code" = PayrollSetup."Annual Gross Pay E/D Code" then
                                                    NewPRollEntryRec.Amount := FixedBasicAmount * 12
                                                else
                                                    NewPRollEntryRec.Amount := FixedBasicAmount
                                            end else
                                                NewPRollEntryRec.Amount := EmpGroupLine."Default Amount"

                                        end;   /* Rate,Units,Amount,... */

                                        if BookGrLinesRec.Get("Customer No.", NewPRollEntryRec."E/D Code") then begin
                                            NewPRollEntryRec."Debit Account" := BookGrLinesRec."Debit Account No.";
                                            NewPRollEntryRec."Credit Account" := BookGrLinesRec."Credit Account No.";
                                            NewPRollEntryRec."Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
                                            NewPRollEntryRec."Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";
                                        end; /* Debit/Credit accounts*/

                                        if BookGrLinesRec."Transfer Global Dim. 1 Code" then
                                            NewPRollEntryRec."Global Dimension 1 Code" := "Global Dimension 1 Code";
                                        if BookGrLinesRec."Transfer Global Dim. 2 Code" then
                                            NewPRollEntryRec."Global Dimension 2 Code" := "Global Dimension 2 Code";

                                        NewPRollEntryRec."User Id" := UserId;
                                        //Check for common ID
                                        if (EDFileRec."Common Id" <> '') then begin
                                            EDFileRec2.SetCurrentkey("Common Id");
                                            EDFileRec2.SetFilter("E/D Code", '<>%1', EDFileRec."E/D Code");
                                            EDFileRec2.SetRange("Common Id", EDFileRec."Common Id");
                                            if EDFileRec2.FindFirst then begin
                                                repeat
                                                    if (NewPRollEntryRec.Amount <> 0) then begin
                                                        if NewPRollEntryRec2.Get(NewPRollEntryRec."Payroll Period", NewPRollEntryRec."Employee No.",
                                                                          EDFileRec2."E/D Code") then
                                                            NewPRollEntryRec2.Delete;
                                                    end else begin
                                                        if EDFileRec."Yes/No Req." then begin
                                                            if NewPRollEntryRec2.Get(NewPRollEntryRec."Payroll Period", NewPRollEntryRec."Employee No.",
                                                                              EDFileRec2."E/D Code") and (NewPRollEntryRec2.Amount <> 0) then begin
                                                                NewPRollEntryRec2.Delete;
                                                                NewPRollEntryRec.Validate(Flag, true);
                                                            end;
                                                        end;
                                                    end;
                                                until EDFileRec2.Next = 0;
                                            end;
                                        end;
                                        NewPRollEntryRec.Insert;
                                    end;
                                end;
                            until (EmpGroupLine.Next = 0);
                        end;
                        // recalculate lines if appropriate e.g. if loan
                        if ProllPayslipLine.Find('-') then
                            repeat
                                EDFileRec.Get(ProllPayslipLine."E/D Code");
                                Exist := false;
                                if NewPRollEntryRec.Get(PayrollPeriod, "No.", ProllPayslipLine."E/D Code") then
                                    Exist := true;
                                if (EDFileRec."Loan (Y/N)" or EDFileRec."Recalculate Next Period") then begin
                                    ProllPayslipLine.Amount := 0;
                                    ProllPayslipLine.ReCalculateAmount;
                                    ProllPayslipLine.Modify;
                                    if (not Exist or (Exist and (NewPRollEntryRec.Amount <> ProllPayslipLine.Amount))) then begin
                                        /* If this new entry contributes in computing another, then compute that value
                                          for that computed entry and insert it appropriately*/
                                        ProllPayslipLine.CalcCompute(ProllPayslipLine, ProllPayslipLine.Amount, false, ProllPayslipLine."E/D Code");
                                        /*BDC*/

                                        /* If this new entry is a contributory factor for the value of another line,
                                          then compute that other line's value and insert it appropriately */
                                        ProllPayslipLine.CalcFactor1(ProllPayslipLine);

                                        /* The two functions above have used this line to change others */
                                        ProllPayslipLine.ChangeOthers := false;

                                        /* Go through all the lines and change where necessary */
                                        ProllPayslipLine.ChangeAllOver(ProllPayslipLine, false);

                                        /* Reset the ChangeOthers flag in all lines */
                                        ProllPayslipLine.ResetChangeFlags(ProllPayslipLine);
                                    end;
                                end;
                            until ProllPayslipLine.Next = 0;
                    end else
                        if UpdatePayLines then begin
                            ProllPayslipLine.Reset;
                            ProllPayslipLine.SetRange("Payroll Period", PayrollPeriod);
                            ProllPayslipLine.SetRange("Employee No.", "No.");
                            ProllPayslipLine.ModifyAll("Global Dimension 1 Code", "Global Dimension 1 Code");
                            ProllPayslipLine.ModifyAll("Global Dimension 2 Code", "Global Dimension 2 Code");
                            ProllPayslipLine.ModifyAll("Employee Category", "Employee Category");
                        end;


                    if (ProllPayslipHeader."No. of Days Worked" <> 0) then begin
                        ProllPayslipHeader.Validate("No. of Days Worked");
                    end;
                    Commit;
                end;

            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Total Employees Selected   #1##\' +
                            'Current Employee Number    #2###\' +
                            'Counter   #3###');
                Window.Update(1, Count);
                InfoCounter := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PayrollPeriod; PayrollPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Periods';
                    TableRelation = "Payroll-Period";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        Window.Close;
        Message('FUNCTION COMPLETED');
    end;

    var
        PayrollSetup: Record "Payroll-Setup";
        PeriodRec: Record "Payroll-Period";
        EDFile: Record "Payroll-E/D";
        EDFileRec: Record "Payroll-E/D";
        EDFileRec2: Record "Payroll-E/D";
        ProllEmployee: Record Employee;
        EmpGroupRec: Record "Payroll-Employee Group Header";
        EmpGroupLine: Record "Payroll-Employee Group Line";
        EmpGroupFirstHalf: Record "Proll-Emply Grp First Half";
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        ProllPayslipLine: Record "Payroll-Payslip Line";
        NewPRollEntryRec: Record "Payroll-Payslip Line";
        NewPRollEntryRec2: Record "Payroll-Payslip Line";
        ProllPayslipFirstHalf: Record "Proll-Pslip Lines First Half";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        EmployeeSalary: Record "Employee Salary";
        PayrollMgt: Codeunit "Payroll-Management";
        PayrollPeriod: Code[10];
        GrossPayEdCode: Code[20];
        EmployeeGrp: Code[20];
        CreateNewRec: Boolean;
        InclDetail: Boolean;
        Upgraded: Boolean;
        UpdatePayLines: Boolean;
        Window: Dialog;
        Text000: label 'Employee %1 does not have a posting group\Make sure the posting group is filled before you proceed';
        InfoCounter: Integer;
        NoofMonthDays: Integer;
        Exist: Boolean;
        FixedBasicAmount: Decimal;
        Text001: label 'Payroll Period already closed!';
        EmpGrpEffectiveDate: Date;
}

