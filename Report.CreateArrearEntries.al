Report 52092186 "Create Arrear Entries"
{
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Employee Salary"; "Employee Salary")
        {
            DataItemTableView = where("Entry Type" = filter("Salary Arrears" | "Promotion Arrears"), "Arrears Calculated" = const(false));
            column(ReportForNavId_6600; 6600)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Employee Salary"."Employee No.");
                PayrollPeriod := "Employee Salary"."Effective Period";
                Counter := 0;
                ArrearType := "Employee Salary"."Entry Type" - 1;
                repeat
                    Window.Update(2, PayrollPeriod);
                    CreatePayrollEntries(PayrollPeriod, "Employee Salary"."Employee No.");
                    PayrollPeriod := IncStr(PayrollPeriod);
                    Counter += 1;
                until Counter = "Employee Salary"."No. of Periods";

                "Employee Salary"."Arrears Calculated" := true;
                "Employee Salary".Modify;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text001);
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Processing Employee No. #1##########\' +
                            'Creating Period  #2##########');
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
        PayslipHeader: Record "Payroll-Payslip Header";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        EmplRec: Record "Payroll-Employee";
        NewPRollEntryRec: Record "Payroll-Payslip Line";
        NewPRollEntryRec2: Record "Payroll-Payslip Line";
        PayPeriod: Record "Payroll-Period";
        ArrPeriod: Record "Payroll-Period";
        PayrollPeriod: Code[20];
        ArrearType: Option Salary,Promotion;
        Counter: Integer;
        Exist: Boolean;
        NoofDaysWorked: Integer;
        Window: Dialog;
        Text001: label 'Processing Completed';
        Found: Boolean;


    procedure CreatePayrollEntries(CurrPayPeriod: Code[20]; EmployeeCode: Code[20])
    var
        PayslipLines: Record "Payroll-Payslip Line";
        PayslipLines2: Record "Payroll-Payslip Line";
        PayslipHeaderArr: Record "Payslip Header First Half";
        PayslipLinesArr: Record "Proll-Pslip Lines First Half";
        PayslipLinesArr2: Record "Proll-Pslip Lines First Half";
        EmployeeGrpLines: Record "Payroll-Employee Group Line";
        EDFile: Record "Payroll-E/D";
        EDFileRec: Record "Payroll-E/D";
        EDFileRec2: Record "Payroll-E/D";
    begin
        NoofDaysWorked := 0;
        EmplRec.Get(EmployeeCode);
        PayPeriod.Get(CurrPayPeriod);

        //Create Arrears Header
        if not (PayslipHeaderArr.Get(CurrPayPeriod, ArrearType, EmployeeCode)) then begin
            PayslipHeaderArr.Init;
            PayslipHeaderArr."Payroll Period" := PayPeriod."Period Code";
            PayslipHeaderArr."Arrear Type" := ArrearType;
            PayslipHeaderArr."Employee No" := EmployeeCode;
            PayslipHeaderArr."Period Start" := PayPeriod."Start Date";
            PayslipHeaderArr."Period End" := PayPeriod."End Date";
            PayslipHeaderArr."Period Name" := PayPeriod.Name;
            PayslipHeaderArr."Employee Name" := EmplRec.GetName(EmployeeCode);
            PayslipHeaderArr."Global Dimension 1 Code" := EmplRec."Global Dimension 1 Code";
            PayslipHeaderArr."Global Dimension 2 Code" := EmplRec."Global Dimension 2 Code";
            PayslipHeaderArr."Staff Category" := EmplRec."Employee Category";
            PayslipHeaderArr."Employee Group" := "Employee Salary"."Salary Group";
            PayslipHeaderArr."Payment Period" := "Employee Salary"."Payment Period";
            PayslipHeaderArr.Insert;
        end;

        PayslipLines.SetRange("Payroll Period", CurrPayPeriod);
        PayslipLines.SetRange("Employee No.", EmployeeCode);
        if PayslipLines.FindFirst then begin
            repeat
                PayslipLinesArr.TransferFields(PayslipLines);
                EDFileRec.Get(PayslipLinesArr."E/D Code");
                PayslipLinesArr."Payment Period" := "Employee Salary"."Payment Period";
                if EDFileRec.CheckandAllow(EmployeeCode, "Employee Salary"."Salary Group") and (not (EDFileRec.Arrear)) then begin
                    PayslipLinesArr."Payroll Period" := CurrPayPeriod;
                    PayslipLinesArr."Arrear Type" := ArrearType;
                    if EmployeeGrpLines.Get("Employee Salary"."Salary Group", PayslipLines."E/D Code") then begin
                        PayslipLinesArr.Units := EmployeeGrpLines.Units;
                        PayslipLinesArr.Rate := EmployeeGrpLines.Rate;
                        PayslipLinesArr.Amount := EmployeeGrpLines."Default Amount";
                    end;
                    PayslipLinesArr.Validate(PayslipLinesArr."E/D Code");
                    EDFileRec.Get(PayslipLinesArr."E/D Code");
                    if PayslipLines.Quantity <> 0 then
                        PayslipLinesArr.Validate(Quantity);
                    if (EDFileRec."Yes/No Req.") and (PayslipLines.Amount <> 0) then
                        PayslipLinesArr.Validate(Flag, true);
                    PayslipLinesArr.Insert;
                end;
            until PayslipLines.Next(1) = 0;
        end;
        /* Additional E/Ds for upgraded staff
        The entries are copied from the employee group entry lines.*/
        EmployeeGrpLines.SetRange(EmployeeGrpLines."Employee Group", "Employee Salary"."Salary Group");
        EmployeeGrpLines.FindFirst;
        repeat
            EDFile.Get(EmployeeGrpLines."E/D Code");
            if EDFile.CheckandAllow(EmployeeCode, "Employee Salary"."Salary Group") and (not (EDFile.Arrear)) then begin
                if not (PayslipLinesArr.Get(CurrPayPeriod, ArrearType, EmployeeCode, EmployeeGrpLines."E/D Code")) then begin
                    PayslipLinesArr.Init;
                    PayslipLinesArr."Payroll Period" := PayslipHeaderArr."Payroll Period";
                    PayslipLinesArr."Arrear Type" := ArrearType;
                    PayslipLinesArr."Employee No." := PayslipHeaderArr."Employee No";
                    PayslipLinesArr."Global Dimension 1 Code" := PayslipHeaderArr."Global Dimension 1 Code";
                    PayslipLinesArr."Global Dimension 2 Code" := PayslipHeaderArr."Global Dimension 2 Code";
                    PayslipLinesArr."Staff Category" := PayslipHeaderArr."Staff Category";
                    PayslipLinesArr."Payment Period" := "Employee Salary"."Payment Period";
                    EDFileRec.Get(EmployeeGrpLines."E/D Code");
                    PayslipLinesArr."E/D Code" := EmployeeGrpLines."E/D Code";
                    PayslipLinesArr."Payslip Text" := EmployeeGrpLines."Payslip Text";
                    begin
                        PayslipLinesArr."Statistics Group Code" := EDFileRec."Statistics Group Code";
                        PayslipLinesArr."Pos. In Payslip Grp." := EDFileRec."Pos. In Payslip Grp.";
                        PayslipLinesArr."Payslip appearance" := EDFileRec."Payslip appearance";
                        PayslipLinesArr."Overline Column" := EDFileRec."Overline Column";
                        PayslipLinesArr."Underline Amount" := EDFileRec."Underline Amount";
                    end;        /* Payslip Grp/Pos */
                    begin
                        PayslipLinesArr."E/D Code" := EmployeeGrpLines."E/D Code";
                        PayslipLinesArr.Units := EmployeeGrpLines.Units;
                        PayslipLinesArr.Rate := EmployeeGrpLines.Rate;
                        PayslipLinesArr.Quantity := EmployeeGrpLines.Quantity;
                        PayslipLinesArr.Flag := EmployeeGrpLines.Flag;
                        PayslipLinesArr.Amount := EmployeeGrpLines."Default Amount";
                    end;   /* Rate,Units,Amount,... */

                    if BookGrLinesRec.Get(EmplRec."Customer No.", PayslipLinesArr."E/D Code") then begin
                        PayslipLinesArr."Debit Account" := BookGrLinesRec."Debit Account No.";
                        PayslipLinesArr."Credit Account" := BookGrLinesRec."Credit Account No.";
                        PayslipLinesArr."Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
                        PayslipLinesArr."Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";
                    end; /* Debit/Credit accounts*/

                    if BookGrLinesRec."Transfer Global Dim. 1 Code" then
                        PayslipLinesArr."Global Dimension 1 Code" := PayslipHeaderArr."Global Dimension 1 Code";
                    ;
                    if BookGrLinesRec."Transfer Global Dim. 2 Code" then
                        PayslipLinesArr."Global Dimension 2 Code" := PayslipHeaderArr."Global Dimension 2 Code";
                    ;

                    PayslipLinesArr."User Id" := UserId;
                    EDFileRec.Get(PayslipLinesArr."E/D Code");

                    if (EDFileRec."Common Id" <> '') then begin
                        EDFileRec2.SetCurrentkey("Common Id");
                        EDFileRec2.SetFilter("E/D Code", '<>%1', EDFileRec."E/D Code");
                        EDFileRec2.SetRange("Common Id", EDFileRec."Common Id");
                        if EDFileRec2.FindFirst then begin
                            repeat
                                if (PayslipLinesArr.Amount <> 0) then begin
                                    if PayslipLinesArr2.Get(PayslipLinesArr."Payroll Period", ArrearType, PayslipLinesArr."Employee No.",
                                                      EDFileRec2."E/D Code") then
                                        PayslipLinesArr2.Delete;
                                end else begin
                                    if EDFileRec."Yes/No Req." then begin
                                        if PayslipLinesArr2.Get(PayslipLinesArr."Payroll Period", ArrearType, PayslipLinesArr."Employee No.",
                                                          EDFileRec2."E/D Code") and (PayslipLinesArr2.Amount <> 0) then begin
                                            PayslipLinesArr2.Delete;
                                            PayslipLinesArr.Validate(Flag, true);
                                        end;
                                    end;
                                end;
                            until EDFileRec2.Next = 0;
                        end;
                    end;
                    PayslipLinesArr.Insert;
                end;
            end;
        until (EmployeeGrpLines.Next = 0);

        // recalculate lines if appropriate e.g. if loan
        PayslipLinesArr.SetRange("Payroll Period", CurrPayPeriod);
        PayslipLinesArr.SetRange("Arrear Type", ArrearType);
        PayslipLinesArr.SetRange("Employee No.", EmployeeCode);
        if PayslipLinesArr.Find('-') then
            repeat
                EDFileRec.Get(PayslipLinesArr."E/D Code");
                Exist := false;
                if PayslipLines.Get(CurrPayPeriod, PayslipLinesArr."Employee No.", PayslipLinesArr."E/D Code") then
                    Exist := true;

                if (EDFileRec."Loan (Y/N)") or (EDFileRec."Recalculate Next Period") then begin
                    PayslipLinesArr.Amount := 0;
                    PayslipLinesArr.ReCalcutateAmount;
                    PayslipLinesArr.Modify;
                    if (not Exist or (Exist and (PayslipLines.Amount <> PayslipLinesArr.Amount))) then begin
                        /* If this new entry contributes in computing another, then compute that value
                          for that computed entry and insert it appropriately*/
                        PayslipLinesArr.CalcCompute(PayslipLinesArr, PayslipLinesArr.Amount, false, PayslipLinesArr."E/D Code");
                        /*BDC*/

                        /* If this new entry is a contributory factor for the value of another line,
                          then compute that other line's value and insert it appropriately */
                        PayslipLinesArr.CalcFactor1(PayslipLinesArr);

                        /* The two functions above have used this line to change others */
                        PayslipLinesArr.ChangeOthers := false;

                        /* Go through all the lines and change where necessary */
                        PayslipLinesArr.ChangeAllOver(PayslipLinesArr, false);

                        /* Reset the ChangeOthers flag in all lines */
                        PayslipLinesArr.ResetChangeFlags(PayslipLinesArr);
                    end;
                end;

                //Update Arrears on Initial Pay
                if (EDFileRec."Use in Arrear Calc.") and (PayslipLinesArr.Amount <> 0) then begin
                    Found := false;
                    if PayslipLines.Get(PayslipLinesArr."Payroll Period", PayslipLinesArr."Employee No.", PayslipLinesArr."E/D Code") then begin
                        PayslipLinesArr."Arrears Amount" := PayslipLinesArr.Amount - PayslipLines.Amount;
                        PayslipLinesArr.Modify;
                    end else begin
                        if EDFileRec."Common Id" <> '' then begin
                            EDFileRec2.SetCurrentkey("Common Id");
                            EDFileRec2.SetFilter("E/D Code", '<>%1', EDFileRec."E/D Code");
                            EDFileRec2.SetRange("Common Id", EDFileRec."Common Id");
                            if EDFileRec2.FindFirst then begin
                                repeat
                                    if PayslipLines2.Get(PayslipLinesArr."Payroll Period", PayslipLinesArr."Employee No.",
                                                        EDFileRec2."E/D Code") then begin

                                        PayslipLinesArr."Arrears Amount" := PayslipLinesArr.Amount - PayslipLines2.Amount;
                                        PayslipLinesArr.Modify;
                                        Found := true;
                                    end else begin
                                        PayslipLinesArr."Arrears Amount" := PayslipLinesArr.Amount;
                                        PayslipLinesArr.Modify;
                                    end;
                                until (EDFileRec2.Next = 0) or Found;
                            end
                        end else begin
                            PayslipLinesArr."Arrears Amount" := PayslipLinesArr.Amount;
                            PayslipLinesArr.Modify;
                        end;
                    end;
                end;
            until PayslipLinesArr.Next = 0;

        PayslipLinesArr.SetRange("Payroll Period");
        PayslipLinesArr.SetRange("Arrear Type");
        PayslipLinesArr.SetRange("Employee No.");

        //Prorate No. of days
        if ("Employee Salary"."Effective Date" > PayPeriod."Start Date") then
            NoofDaysWorked := Date2dmy(CalcDate('CM', PayPeriod."Start Date"), 1) -
                              Date2dmy("Employee Salary"."Effective Date", 1) + 1;


        if NoofDaysWorked <> 0 then begin
            PayslipHeaderArr.Validate(PayslipHeaderArr."No. of Days Worked (Arr)", NoofDaysWorked);
            PayslipHeaderArr.Modify;
        end;
        //END;
        Commit;

    end;
}

