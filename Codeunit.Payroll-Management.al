Codeunit 52092146 "Payroll-Management"
{
    Permissions = TableData "Employee Absence"=rm,
                  TableData "Employee Salary"=r;

    trigger OnRun()
    var
        PeriodRec: Record "Payroll-Period";
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        ProllPayslipForm: Page Payslip;
    begin
        PayrollPeriodList.LookupMode := true;
        PayrollPeriodList.Editable := false;
        PayrollPeriodList.SetTableview(PeriodRec);
        if PayrollPeriodList.RunModal = Action::LookupOK then
        begin
          PayrollPeriodList.GetRecord(PeriodRec);
          ProllPayslipHeader.SetRange(ProllPayslipHeader."Payroll Period",PeriodRec."Period Code");
          if ProllPayslipHeader.Count = 0 then begin
            Message(Text000);
            exit;
          end;

          ProllPayslipForm.SetTableview(ProllPayslipHeader);
          ProllPayslipForm.RunModal;
        end;
        Clear(ProllPayslipForm);
        Clear(PayrollPeriodList);
    end;

    var
        PayrollSetup: Record "Payroll-Setup";
        NextPRollPeriod: Record "Payroll-Period";
        ProllHeaderRec: Record "Payroll-Payslip Header";
        NextProllHeader: Record "Payroll-Payslip Header";
        PrevPayslipLine: Record "Closed Payroll-Payslip Line";
        NewPRollEntryRec: Record "Payroll-Payslip Line";
        NewPRollEntryRec2: Record "Payroll-Payslip Line";
        PRollFirstHalfRec: Record "Proll-Pslip Lines First Half";
        NewPRollFirstHalfRec: Record "Proll-Pslip Lines First Half";
        EDFile: Record "Payroll-E/D";
        EDFileRec: Record "Payroll-E/D";
        EDFileRec2: Record "Payroll-E/D";
        PrevPayrollHeader: Record "Closed Payroll-Payslip Header";
        CurrentEmployee: Record "Payroll-Employee";
        Employee: Record "Payroll-Employee";
        EmpGrpLinesRec: Record "Payroll-Employee Group Line";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        UserSetup: Record "User Setup";
        EmployeeAbsence: Record "Employee Absence";
        PayrollVariable: Record "Payroll Variable Header";
        PayrollPeriodList: Page "Payroll Periods";
        ProcessedLeave: Page "Processed Leave";
        FirstHalf: Boolean;
        Upgraded: Boolean;
        Text000: label 'No Payroll Entry found within the filter!';
        SkipDetails: Boolean;
        GrossHasChanged: Boolean;
        ResetProration: Boolean;
        AnnualGrossAmount: Decimal;
        EmployeeGrp: Code[20];
        AmountRoundingFactor: Option "None","1","1000","1000000";
        Text001: label 'Rounding Factor:';
        Text002: label 'Employee Payroll Entry';
        Text003: label 'Amounts are in whole %1s';
        Text004: label 'User ID';
        Text005: label 'Report Name:';
        Text006: label 'Error List';
        Text007: label 'No.';
        Text008: label 'Name';
        Text009: label 'Processing  Employee  #1############.\\ED  #2############.';
        Text010: label 'Period Filter';
        Text011: label 'Date';
        ExcelBuf: Record "Excel Buffer" temporary;
        Text012: label 'Payroll Error';
        EffectiveDateOfEmplGrp: Date;


    procedure RunOnRec(var Rec: Record "Closed Payroll-Payslip Header";UseFirstHalf: Boolean;NextPRollPeriod2: Record "Payroll-Period")
    begin
        PrevPayrollHeader.Copy(Rec);
        FirstHalf := UseFirstHalf;
        NextPRollPeriod := NextPRollPeriod2;
        CODE;
        Rec.Copy(PrevPayrollHeader);
    end;


    procedure "CODE"()
    begin
        with PrevPayrollHeader do begin
          SkipDetails := false;

          Employee.Get(PrevPayrollHeader."Employee No.");

          if ((Employee."Termination Date" <> 0D) and
             (Employee."Termination Date" < NextPRollPeriod."End Date")) or
             ((Employee."Contract Expiry Date" <> 0D) and
             (Employee."Contract Expiry Date" < NextPRollPeriod."End Date")) then
               SkipDetails := true;

          if (Employee."Appointment Status" = Employee."appointment status"::Inactive) and (Employee."Inactive Without Pay") then begin
            if (Employee."Inactive Date" <> 0D) and
              (CalcDate(Employee."Inactive Duration",Employee."Inactive Date") > NextPRollPeriod."End Date") then
                SkipDetails := true;
          end;

          if SkipDetails = false then
            CreateDetails;

        end;
    end;


    procedure CreateDetails()
    begin
        with PrevPayrollHeader do begin

          Employee.Get(PrevPayrollHeader."Employee No.");
          PrevPayrollHeader.LockTable;
          PrevPayslipLine.LockTable;

          CreatePHeadRec;

          if FirstHalf then
            CreateFirstHalfRec(NextProllHeader."Payroll Period",
                             NextProllHeader."Employee No.",
                             NextPRollPeriod."Period Code")
          else
            CreatePLinesRec;

          ProllHeaderRec.Get(NextPRollPeriod."Period Code",NextProllHeader."Employee No.");
          ProllHeaderRec.Validate("No. of Days Worked",0);
          ProllHeaderRec.Modify;
          Commit;
        end;
    end;


    procedure CreatePHeadRec()
    begin
        NextProllHeader.TransferFields(PrevPayrollHeader);
        NextProllHeader."Payroll Period" := NextPRollPeriod."Period Code";
        NextProllHeader."Period Start" := NextPRollPeriod."Start Date";
        NextProllHeader."Period End" := NextPRollPeriod."End Date";
        NextProllHeader."Period Name" := NextPRollPeriod.Name;

        PayrollSetup.Get;
        Upgraded := false;
        EmployeeGrp := '';
        AnnualGrossAmount := 0;
        GrossHasChanged := false;
        ResetProration := false;

        GetSalaryStructure(NextProllHeader."Employee No.",NextProllHeader."Period Start",EmployeeGrp,AnnualGrossAmount,EffectiveDateOfEmplGrp);

        Employee.Get(NextProllHeader."Employee No.");
        NextProllHeader."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
        NextProllHeader."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
        NextProllHeader.Closed := false;
        NextProllHeader."Employee Category" := Employee."Employee Category";
        NextProllHeader."Job Title Code" := Employee."Job Title Code";
        NextProllHeader.Designation := Employee.Designation;
        NextProllHeader."Tax State"  := Employee."Tax State" ;
        NextProllHeader."Pension Adminstrator Code" := Employee."Pension Administrator Code";
        NextProllHeader."CBN Bank Code"  := Employee."CBN Bank Code";
        NextProllHeader."Bank Account"  := Employee."Bank Account";
        NextProllHeader."No. Printed" := 0;
        NextProllHeader.Status := 0;
        NextProllHeader."Effective Date Of Salary Group":=EffectiveDateOfEmplGrp;
        if (PrevPayrollHeader."Global Dimension 1 Code" <> NextProllHeader."Global Dimension 1 Code") or
          (PrevPayrollHeader."Global Dimension 2 Code" <> NextProllHeader."Global Dimension 2 Code") then
            NextProllHeader.CreateDim(Database::"Payroll-Employee",NextProllHeader."Employee No.")
        else
          NextProllHeader."Dimension Set ID" := PrevPayrollHeader."Dimension Set ID";
        NextProllHeader.Validate("Currency Code");
        NextProllHeader."No. of Days Worked" := 0;
        NextProllHeader."No. of Working Days Basis" :=  Date2dmy(CalcDate('CM',NextProllHeader."Period Start"),1);

        if (NextProllHeader."Salary Group" <> EmployeeGrp) and (EmployeeGrp <> '') then begin
          Upgraded := true;
          NextProllHeader."Salary Group" := EmployeeGrp;
        end;

        PrevPayslipLine.Get(PrevPayrollHeader."Payroll Period",PrevPayrollHeader."Employee No.",PayrollSetup."Annual Gross Pay E/D Code");
        if PrevPayslipLine.Amount <> AnnualGrossAmount then
          GrossHasChanged := true;

        if PrevPayrollHeader."No. of Days Worked" <> NextProllHeader."No. of Days Worked" then
          ResetProration := true;

        if not NextProllHeader.Insert then
          NextProllHeader.Modify;
    end;


    procedure CreatePLinesRec()
    var
        PrevPayslipLineQry: Query "Closed Payslip Line Qry";
    begin
        if not Upgraded then begin
          Clear(PrevPayslipLineQry);
          PrevPayslipLineQry.SetRange(Payroll_Period,PrevPayrollHeader."Payroll Period");
          PrevPayslipLineQry.SetRange(Employee_No,PrevPayrollHeader."Employee No.");
          PrevPayslipLineQry.Open;
          while PrevPayslipLineQry.Read do begin
            EDFile.Get(PrevPayslipLineQry.E_D_Code);
            if EDFile.CheckandAllow(NextProllHeader."Employee No.",NextProllHeader."Salary Group") then begin
              PrevPayslipLine.Get(PrevPayslipLineQry.Payroll_Period,PrevPayslipLineQry.Employee_No,
                PrevPayslipLineQry.E_D_Code);
              NewPRollEntryRec.TransferFields(PrevPayslipLine);
              NewPRollEntryRec."Payroll Period" := NextProllHeader."Payroll Period";
              NewPRollEntryRec."Period Start" := NextProllHeader."Period Start";
              NewPRollEntryRec."Period End" := NextProllHeader."Period End";
              NewPRollEntryRec."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
              NewPRollEntryRec."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
              NewPRollEntryRec."Employee Category" := Employee."Employee Category";
              NewPRollEntryRec.Status := 0;
              NewPRollEntryRec."User Id" := UserId;
              EDFileRec.Get(NewPRollEntryRec."E/D Code");
              if EDFileRec."Yes/No Req." then begin
                NewPRollEntryRec.Flag := false;
                NewPRollEntryRec.Amount := 0;
                NewPRollEntryRec."Amount (LCY)" := 0;
                NewPRollEntryRec.Quantity := 0;
              end;
              if (EDFileRec."Reset Next Period") or (EDFileRec."Loan (Y/N)") then
                begin
                  NewPRollEntryRec.Amount := 0;
                  NewPRollEntryRec.Quantity := 0;
                  NewPRollEntryRec."Amount (LCY)" := 0;
                end;
              if GrossHasChanged then begin
                if (NewPRollEntryRec."E/D Code" = PayrollSetup."Annual Gross Pay E/D Code")
                  and (AnnualGrossAmount <> 0) then
                    NewPRollEntryRec.Amount := AnnualGrossAmount;
              end;
              NewPRollEntryRec.CalcAmountLCY;
              if (PrevPayslipLine."Global Dimension 1 Code" <> NewPRollEntryRec."Global Dimension 1 Code") or
                (PrevPayslipLine."Global Dimension 2 Code" <> NewPRollEntryRec."Global Dimension 2 Code") then
                  NewPRollEntryRec.CreateDim(Database::"Payroll-Employee",NewPRollEntryRec."Employee No.")
              else
                NewPRollEntryRec."Dimension Set ID" := PrevPayslipLine."Dimension Set ID";
        
              if not (NewPRollEntryRec.Insert) then
                NewPRollEntryRec.Modify;
            end;
          end;
          Clear(PrevPayslipLineQry);
          PrevPayslipLineQry.Close;
        end else begin
          EmpGrpLinesRec.Init;
          EmpGrpLinesRec.SetRange("E/D Code");
          EmpGrpLinesRec.SetRange("Employee Group");
          EmpGrpLinesRec."Employee Group" := EmployeeGrp;
          EmpGrpLinesRec."E/D Code" := '';
          EmpGrpLinesRec.SetRange("Employee Group",EmployeeGrp);
          EmpGrpLinesRec.Find('>');
          repeat
            EDFile.Get(EmpGrpLinesRec."E/D Code");
            if EDFile.CheckandAllow(Employee."No.",EmployeeGrp) then begin
              NewPRollEntryRec.Init;
              NewPRollEntryRec."Payroll Period" := NextProllHeader."Payroll Period";
              NewPRollEntryRec."Period Start" := NextProllHeader."Period Start";
              NewPRollEntryRec."Period End" := NextProllHeader."Period End";
              NewPRollEntryRec."Employee No." := NextProllHeader."Employee No.";
              NewPRollEntryRec."Global Dimension 1 Code" := NextProllHeader."Global Dimension 1 Code";
              NewPRollEntryRec."Global Dimension 2 Code" := NextProllHeader."Global Dimension 2 Code";
              NewPRollEntryRec."Employee Category" := NextProllHeader."Employee Category";
        
              EDFileRec.Get(EmpGrpLinesRec."E/D Code");
              NewPRollEntryRec."E/D Code" := EmpGrpLinesRec."E/D Code";
              NewPRollEntryRec."Payslip Text" := EmpGrpLinesRec."Payslip Text";
        
              NewPRollEntryRec."Statistics Group Code" := EDFileRec."Statistics Group Code";
              NewPRollEntryRec."Pos. In Payslip Grp." := EDFileRec."Pos. In Payslip Grp.";
              NewPRollEntryRec."Payslip Appearance" := EDFileRec."Payslip appearance";
              NewPRollEntryRec.Units := EDFileRec.Units;
              NewPRollEntryRec.Rate := EDFileRec.Rate;
              NewPRollEntryRec.Reimbursable := EDFileRec.Reimbursable;
              NewPRollEntryRec."Overline Column" := EDFileRec."Overline Column";
              NewPRollEntryRec."Underline Amount" := EDFileRec."Underline Amount";
              NewPRollEntryRec.Compute := EDFileRec.Compute;
              NewPRollEntryRec."Common ID" := EDFileRec."Common Id";
              NewPRollEntryRec."Loan (Y/N)" := EDFileRec."Loan (Y/N)";
              NewPRollEntryRec."No. of Days Prorate"  := EDFileRec."No. of Days Prorate";
              NewPRollEntryRec."No. of Months Prorate" := EDFileRec."No. of Months Prorate";
        
              NewPRollEntryRec."E/D Code" := EmpGrpLinesRec."E/D Code";
              NewPRollEntryRec.Units := EmpGrpLinesRec.Units;
              NewPRollEntryRec.Rate := EmpGrpLinesRec.Rate;
              NewPRollEntryRec.Quantity := EmpGrpLinesRec.Quantity;
              NewPRollEntryRec.Flag := EmpGrpLinesRec.Flag;
              if (NewPRollEntryRec."E/D Code" = PayrollSetup."Annual Gross Pay E/D Code")
                and (AnnualGrossAmount <> 0) then
                  NewPRollEntryRec.Amount := AnnualGrossAmount
              else
                NewPRollEntryRec.Amount := EmpGrpLinesRec."Default Amount";
        
              if BookGrLinesRec.Get(Employee."Customer No.",NewPRollEntryRec."E/D Code") then
                begin
                  NewPRollEntryRec."Debit Account" := BookGrLinesRec."Debit Account No.";
                  NewPRollEntryRec."Credit Account" := BookGrLinesRec."Credit Account No.";
                  NewPRollEntryRec."Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
                  NewPRollEntryRec."Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";
                  if BookGrLinesRec."Transfer Global Dim. 1 Code" then
                    NewPRollEntryRec."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                  if BookGrLinesRec."Transfer Global Dim. 2 Code" then
                    NewPRollEntryRec."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                end; /* Debit/Credit accounts*/
        
              NewPRollEntryRec."User Id" := UserId;
              if NewPRollEntryRec.CheckCommonIDExists(false) and (NewPRollEntryRec.Amount <> 0) then begin
                EDFileRec2.SetCurrentkey("Common Id");
                EDFileRec2.SetFilter("E/D Code",'<>%1',EDFileRec."E/D Code");
                EDFileRec2.SetRange("Common Id",EDFileRec."Common Id");
                if EDFileRec2.FindFirst then begin
                  repeat
                    if NewPRollEntryRec2.Get(NewPRollEntryRec."Payroll Period",NewPRollEntryRec."Employee No.",
                      EDFileRec2."E/D Code") then
                      NewPRollEntryRec2.Delete;
                  until EDFileRec2.Next = 0;
                end;
              end;
              NewPRollEntryRec.CalcAmountLCY;
              if not (NewPRollEntryRec.Insert) then
                NewPRollEntryRec.Modify;
            end;
          until (EmpGrpLinesRec.Next = 0);
          Clear(PrevPayslipLineQry);
          PrevPayslipLineQry.SetRange(Payroll_Period,PrevPayrollHeader."Payroll Period");
          PrevPayslipLineQry.SetRange(Employee_No,PrevPayrollHeader."Employee No.");
          PrevPayslipLineQry.SetRange(Loan_Y_N,true);
          PrevPayslipLineQry.Open;
          while PrevPayslipLineQry.Read do begin
            if not(NewPRollEntryRec.Get(NextProllHeader."Payroll Period",NextProllHeader."Employee No.",
              PrevPayslipLineQry.E_D_Code))then
                begin
                  PrevPayslipLine.Get(PrevPayslipLineQry.Payroll_Period,PrevPayslipLineQry.Employee_No,
                    PrevPayslipLineQry.E_D_Code);
                  NewPRollEntryRec.TransferFields(PrevPayslipLine);
                  NewPRollEntryRec."Payroll Period" := NextProllHeader."Payroll Period";
                  NewPRollEntryRec."Period Start" := NextProllHeader."Period Start";
                  NewPRollEntryRec."Period End" := NextProllHeader."Period End";
                  NewPRollEntryRec."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                  NewPRollEntryRec."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                  NewPRollEntryRec."Employee Category" := Employee."Employee Category";
                  NewPRollEntryRec.Status := 0;
                  NewPRollEntryRec."User Id" := UserId;
                  NewPRollEntryRec.Amount := 0;
                  if not NewPRollEntryRec.Insert then
                    NewPRollEntryRec.Modify;
                end;
          end;
          Clear(PrevPayslipLineQry);
          PrevPayslipLineQry.Close;
        end;
        NewPRollEntryRec.SetCurrentkey("Payroll Period","Employee No.","E/D Code");
        NewPRollEntryRec.SetRange("Payroll Period",NextProllHeader."Payroll Period");
        NewPRollEntryRec.SetRange("Employee No.",NextProllHeader."Employee No.");
        if NewPRollEntryRec.Find('-') then
          repeat
            EDFileRec.Get(NewPRollEntryRec."E/D Code");
            if (EDFileRec."Loan (Y/N)" or EDFileRec."Reset Next Period" or GrossHasChanged or Upgraded or ResetProration) then begin
              NewPRollEntryRec.ReCalculateAmount;
              NewPRollEntryRec.CalcAmountLCY;
              NewPRollEntryRec.Modify;
              NewPRollEntryRec.CalcCompute(NewPRollEntryRec,NewPRollEntryRec.Amount,false,NewPRollEntryRec."E/D Code");
              NewPRollEntryRec.CalcFactor1(NewPRollEntryRec);
              NewPRollEntryRec.ChangeOthers := false;
              NewPRollEntryRec.ChangeAllOver(NewPRollEntryRec, false);
              NewPRollEntryRec.ResetChangeFlags(NewPRollEntryRec);
            end;
          until NewPRollEntryRec.Next = 0;
        NewPRollEntryRec.SetRange("Payroll Period");
        NewPRollEntryRec.SetRange("Employee No.");

    end;


    procedure CreateFirstHalfRec(CurrPeriod: Code[20];CurrEmpNo: Code[20];NextPeriod: Code[20])
    begin
        /*----------------------------------------------------------------------------+
        ¦ Creates and inserts new First Half Payroll lines Records from the ones of  ¦
        ¦ the period to be closed                                                    ¦
        +----------------------------------------------------------------------------*/
        /* search for the first entry line record for the period to be closed */
        PRollFirstHalfRec."Payroll Period" := CurrPeriod;
        PRollFirstHalfRec."Employee No."    := CurrEmpNo;
        PRollFirstHalfRec."E/D Code"       := '';
        
         PRollFirstHalfRec.SetRange("Payroll Period",CurrPeriod);
         PRollFirstHalfRec.SetRange("Employee No.",CurrEmpNo);
        if not  PRollFirstHalfRec.Find( '>') then
        begin
           PRollFirstHalfRec.SetRange("Payroll Period");
           PRollFirstHalfRec.SetRange("Employee No.");
          exit
        end;
        
        /* copy entry lines of period to be closed to next period */
        repeat
          NewPRollFirstHalfRec := PRollFirstHalfRec;
          NewPRollFirstHalfRec."Payroll Period" := NextPeriod;
          NewPRollFirstHalfRec."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
          NewPRollFirstHalfRec."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
          NewPRollFirstHalfRec."Staff Category" := Employee."Employee Category";
          EDFileRec.Get( NewPRollFirstHalfRec."E/D Code");
          if (EDFileRec."Reset Next Period") then
          begin
            NewPRollFirstHalfRec.Amount := 0;
            NewPRollFirstHalfRec.Quantity := 0;
            if EDFileRec."Yes/No Req." then
              NewPRollFirstHalfRec.Flag := false;
            /*BDC - Recalculate*/
            NewPRollFirstHalfRec.Validate(NewPRollFirstHalfRec."E/D Code");
            /*END BDC*/
            end;
           NewPRollFirstHalfRec.Insert;
        until ( ( PRollFirstHalfRec.Next(1) = 0) );
         PRollFirstHalfRec.SetRange("Payroll Period");
         PRollFirstHalfRec.SetRange("Employee No.");

    end;


    procedure PeriodSelection(var CurrentPeriodCode: Code[10])
    var
        ProllPeriod: Record "Payroll-Period";
        ProllPeriodList: Page "Payroll Periods List";
    begin
        ProllPeriodList.LookupMode := true;
        if ProllPeriodList.RunModal = Action::LookupOK then begin
          ProllPeriodList.GetRecord(ProllPeriod);
          CurrentPeriodCode := ProllPeriod."Period Code";
          Clear(ProllPeriodList);
        end else
          Clear(ProllPeriodList);
    end;


    procedure OpenMonthlyPay()
    var
        PeriodRec: Record "Payroll-Period";
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        ProllPayslipForm: Page Payslip;
    begin
        PayrollPeriodList.LookupMode := true;
        PayrollPeriodList.Editable := false;
        PayrollPeriodList.SetTableview(PeriodRec);
        if PayrollPeriodList.RunModal = Action::LookupOK then
        begin
          PayrollPeriodList.GetRecord(PeriodRec);
          ProllPayslipHeader.SetRange(ProllPayslipHeader."Payroll Period",PeriodRec."Period Code");

          ProllPayslipForm.SetTableview(ProllPayslipHeader);
          ProllPayslipForm.RunModal;
        end;
        Clear(ProllPayslipForm);
        Clear(PayrollPeriodList);
    end;


    procedure GetSalaryStructure(EmployeeCode: Code[20];EffectiveDate: Date;var EmpGrp: Code[20];var AnnualGrossSalary: Decimal;var EffectiveDateOfEmpGrp: Date)
    var
        EmployeeSalary: Record "Employee Salary";
    begin
        EmployeeSalary.SetCurrentkey("Employee No.","Effective Date");
        EmployeeSalary.SetRange("Employee No.",EmployeeCode);
        PayrollSetup.Get;
        if EffectiveDate <> 0D then
          EmployeeSalary.SetFilter("Effective Date",'<=%1',EffectiveDate)
        else
          EmployeeSalary.SetFilter(EmployeeSalary."Effective Date",'<=%1',Today);
        if EmployeeSalary.FindLast then begin
          EmpGrp := EmployeeSalary."Salary Group";
          EmpGrpLinesRec.Get(EmployeeSalary."Salary Group",PayrollSetup."Annual Gross Pay E/D Code");
          if EmployeeSalary."Annual Gross Amount" <> 0 then
            begin
              AnnualGrossSalary := EmployeeSalary."Annual Gross Amount";
              EffectiveDateOfEmpGrp:= EmployeeSalary."Effective Date";
            end
          else
            begin
              EffectiveDateOfEmpGrp:= EmployeeSalary."Effective Date";
              AnnualGrossSalary := EmpGrpLinesRec."Default Amount";
            end;
        end else begin
          EmpGrp := '';
          AnnualGrossSalary := 0;
          EffectiveDateOfEmpGrp:=0D;
        end;
    end;


    procedure GetSalaryGroup(EmployeeCode: Code[20];EffectiveDate: Date;var EmpGrp: Code[20])
    var
        EmployeeSalary: Record "Employee Salary";
    begin
        EmployeeSalary.SetCurrentkey("Employee No.","Effective Date");
        EmployeeSalary.SetRange("Employee No.",EmployeeCode);
        PayrollSetup.Get;
        if EffectiveDate <> 0D then
          EmployeeSalary.SetFilter("Effective Date",'<=%1',EffectiveDate)
        else
          EmployeeSalary.SetFilter(EmployeeSalary."Effective Date",'<=%1',Today);
        if EmployeeSalary.FindLast then
          EmpGrp := EmployeeSalary."Salary Group"
        else
          EmpGrp := '';
    end;


    procedure ExportPayrollOverview(PeriodFilter: Text[250];EDFilter: Text[250];RoundingFactor: Option "None","1","1000","1000000";ShowColumnName: Boolean;StaffCategory: Code[10])
    var
        EmplRec: Record "Payroll-Employee";
        CreateNewRow: Boolean;
        CreateBook: Boolean;
        Window: Dialog;
    begin
        Clear(Employee);
        AmountRoundingFactor := RoundingFactor;
        MakeExcelInfo(PeriodFilter);
        MakeExcelDataHeader(EDFilter,ShowColumnName);
        CreateNewRow := true;
        CreateBook := false;

        if StaffCategory <>''  then
          Employee.SetRange("Employee Category",StaffCategory);

        if not Employee.FindFirst then
          exit;
        repeat
          Clear(CurrentEmployee);
          CurrentEmployee.Get(Employee."No.");
          if  PeriodFilter <> '' then
            Employee.SetFilter("Period Filter",PeriodFilter);
          if EDFilter <> '' then
            Employee.SetFilter("ED Filter",EDFilter);
          Employee.CalcFields("ED Amount");
          if Employee."ED Amount"  <> 0 then begin
            CreateNewRow := true;
            if not CreateBook then begin
              Window.Open(Text009);
              CreateBook := true;
            end;
            Clear(EDFile);
            Window.Update(1,CurrentEmployee."No.");
            EDFile.Reset;
            if EDFilter <> '' then
              EDFile.SetFilter("E/D Code",EDFilter);
          if EDFile.FindFirst then
            repeat
              Window.Update(2,EDFile."E/D Code");
              if  PeriodFilter <> '' then
                CurrentEmployee.SetFilter("Period Filter",PeriodFilter);
              CurrentEmployee.SetRange("ED Filter",EDFile."E/D Code");
              CurrentEmployee.CalcFields("ED Amount");
              case RoundingFactor of
                //  None,1,1000,1000000
                0:begin
                    MakeExcelDataBody(CurrentEmployee."ED Amount",CreateNewRow);
                    CreateNewRow := false;
                  end;
                1:begin
                    MakeExcelDataBody(ROUND(CurrentEmployee."ED Amount",1),CreateNewRow);
                    CreateNewRow := false;
                  end;
                2:begin
                    MakeExcelDataBody(ROUND(CurrentEmployee."ED Amount" / 1000,0.1),CreateNewRow);
                    CreateNewRow := false;
                  end;
                3:begin
                    MakeExcelDataBody(ROUND(CurrentEmployee."ED Amount" / 1000000,0.1),CreateNewRow);
                    CreateNewRow := false;
                  end;
              end;
            until EDFile.Next(1) = 0;
          end;
        until Employee.Next(1) = 0;

        if CreateBook then begin
          Window.Close;
          CreateExcelbook;
        end;
    end;


    procedure MakeExcelInfo(ReportPeriodFilter: Text[250])
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text000),false,true,false,false,'',1);
        ExcelBuf.AddInfoColumn(COMPANYNAME,false,false,false,false,'',1);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text005),false,true,false,false,'',1);
        ExcelBuf.AddInfoColumn(Format(Text002),false,false,false,false,'',1);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text010),false,true,false,false,'',1);
        ExcelBuf.AddInfoColumn(ReportPeriodFilter,false,false,false,false,'',1);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text004),false,true,false,false,'',1);
        ExcelBuf.AddInfoColumn(UserId,false,false,false,false,'',1);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text011),false,true,false,false,'',1);
        ExcelBuf.AddInfoColumn(Today,false,false,false,false,'',1);

        ExcelBuf.NewRow;

        if AmountRoundingFactor <> 0 then begin
          ExcelBuf.NewRow;
          ExcelBuf.AddInfoColumn(Format(Text001),false,true,false,false,'',1);
          ExcelBuf.AddInfoColumn(Format(StrSubstNo(Text003,AmountRoundingFactor)),false,false,false,false,'',1);
        end;

        ExcelBuf.ClearNewRow;
    end;


    procedure MakeExcelDataHeader(EDHeaderFilter: Text[250];ShowComnName: Boolean)
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text007),false,'',true,false,true,'',1);
        ExcelBuf.AddColumn(Format(Text008),false,'',true,false,true,'',1);

        EDFile.Reset;
        if EDHeaderFilter <> '' then
          EDFile.SetFilter("E/D Code",EDHeaderFilter);

        if EDFile.FindFirst then
          repeat
            if ShowComnName then
              ExcelBuf.AddColumn(EDFile."Payslip Appearance Text",false,'',true,false,true,'',1)
            else
              ExcelBuf.AddColumn(EDFile."E/D Code",false,'',true,false,true,'',1);
          until EDFile.Next(1) = 0;
    end;


    procedure MakeExcelDataBody(EntryAmount: Decimal;NewRow: Boolean)
    var
        BlankField: Text[1];
    begin
        if NewRow then begin
          ExcelBuf.NewRow;
          ExcelBuf.AddColumn(CurrentEmployee."No.",false,'',false,false,false,'',1);
          ExcelBuf.AddColumn(Format(CurrentEmployee.FullName),false,'',false,false,false,'',1);
        end;

        if EntryAmount <> 0 then
          ExcelBuf.AddColumn(Format(EntryAmount),false,'',false,false,false,'',1)
        else
          ExcelBuf.AddColumn(BlankField,false,'',
            false,false,false,'',1);
    end;


    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('',Text006,Text012,COMPANYNAME,UserId);
    end;


    procedure GetLeave(PayrollVariable: Record "Payroll Variable Header")
    begin
        Clear(ProcessedLeave);
        EmployeeAbsence.SetRange("Process Allowance Payment",true);
        EmployeeAbsence.SetRange("Leave Paid",false);
        EmployeeAbsence.SetRange("Payroll Period",'');
        ProcessedLeave.SetTableview(EmployeeAbsence);
        ProcessedLeave.LookupMode := true;
        ProcessedLeave.SetParameters(true,PayrollVariable);
        ProcessedLeave.RunModal;
        Clear(ProcessedLeave);
    end;


    procedure SetPayrollVariable(lPayrollVariable: Record "Payroll Variable Header")
    begin
        PayrollVariable.Get(lPayrollVariable."Payroll Period",lPayrollVariable."E/D Code");
    end;


    procedure CreateLeaveVariableLines(var lEmployeeAbsence: Record "Employee Absence")
    var
        PayrollVariableLine: Record "Payroll Payslip Variable";
    begin
        if lEmployeeAbsence.Find('-') then begin
          repeat
            PayrollVariableLine.Init;
            PayrollVariableLine."Payroll Period" := PayrollVariable."Payroll Period";
            PayrollVariableLine."E/D Code" := PayrollVariable."E/D Code";
            PayrollVariableLine."Employee No." := lEmployeeAbsence."Employee No.";
            PayrollVariableLine."Employee Name" := lEmployeeAbsence."Employee Name";
            PayrollVariableLine."Processed Leave Entry No." := lEmployeeAbsence."Entry No.";
            PayrollVariableLine.Validate(Flag,true);
            PayrollVariableLine.Insert;
            lEmployeeAbsence."Payroll Period" := PayrollVariable."Payroll Period";
            lEmployeeAbsence.Modify;
          until lEmployeeAbsence.Next =0;
        end;
    end;
}

