Codeunit 52092145 "Payroll Period Check"
{
    TableNo = "Payroll-Period";

    trigger OnRun()
    var
        GradeLevel: Record "Grade Level";
        PayrollEmployee: Record "Payroll-Employee";
        PayrollLoanEntry: Record "Payroll-Loan Entry";
        TotalAmount: Decimal;
    begin
        if Closed then
          exit;
        TestField("End Date");
        TestField("Start Date");

        if ActivateMessage then
          if not Confirm(Text013,false) then
            Error('');
        PayrollPayslipHeader.SetRange("Payroll Period","Period Code");
        if not PayrollPayslipHeader.Find('-') then
          exit;
        ExcelBuf.DeleteAll;
        MakeExcelInfo;
        ErrorExist := false;

        repeat
          CheckEmployee(PayrollPayslipHeader);
          CheckCompulsoryED(PayrollPayslipHeader);
          CheckNegativePay(PayrollPayslipHeader);
          CheckLoans(PayrollPayslipHeader);
          CheckPostingConsistency(PayrollPayslipHeader);
        until PayrollPayslipHeader.Next = 0;

        if not ErrorExist then begin
          if ActivateMessage then
            Message(Text018);
          exit;
        end;

        Message(Text004);
        CreateExcelbook;
    end;

    var
        PayrollPayslipHeader: Record "Payroll-Payslip Header";
        ExcelBuf: Record "Excel Buffer" temporary;
        PayrollSetup: Record "Payroll-Setup";
        ErrorExist: Boolean;
        ActivateMessage: Boolean;
        Text000: label 'Termination date must be entered for Employee %1';
        Text001: label 'Employee %1 already terminated.';
        Text002: label 'Loan %1 does not appear for %2.';
        Text003: label 'Employee salary group must not be blank for %1.';
        Text004: label 'The program had encountered some errors and process will be terminated. Click Ok to see the errors on the MS Excel.';
        Text005: label 'Data';
        Text006: label 'Error List';
        Text007: label 'Comment';
        Text008: label 'Date';
        Text009: label 'User ID';
        Text010: label 'Company Name';
        Text011: label 'ED %1 has already been blocked but apears for %2.';
        Text012: label 'Amount for %1 not correct';
        Text013: label 'Changes to payroll will be closed. Are you sure you want to continue?';
        Text014: label 'Compulsory ED %1 does not appear for %2.';
        Text015: label 'Employee %1 (%2) does not have entry for %3 (%4)';
        Text016: label '%1 is negative for employee %2 (%3)';
        Text017: label 'Employee %1 already marked as payroll excemption.';
        Text018: label 'There are no errors found.';
        Text019: label 'No indication for exlcuding %1 on the payroll.';
        Text020: label '%1 has payroll entries not in order with the expected net pay';
        Text021: label 'Employee %1 not eligible for %2.';
        Text023: label '%1 is not set on posting group for %2.';
        Text024: label 'Customer account not created for %1.';
        Text100: label 'Employee %1 payroll is different from the grade level assigned.';
        Text101: label 'Loan Deducted for %1 on loan %2 does not correspond with the deduction ledger entry.';
        Text102: label 'Loan deducted for %1 on loan %2 is not consistent. Payslip Amount = %3, Loan Entry Amount = %4.';
        Text103: label 'PAYROLL ERROR LIST';
        Text104: label '%1 not specified for employee %2 for ED %3.';

    local procedure CheckEmployee(PayslipHeader: Record "Payroll-Payslip Header")
    var
        PayrollEmployee: Record "Payroll-Employee";
    begin
        with PayslipHeader do begin
          PayrollEmployee.Get("Employee No.");
          if PayrollEmployee."Exclude From Payroll" then
            MakeExcelDataBody(StrSubstNo(Text017,"Employee No."));

          CalcFields("Debit Amount","Credit Amount");
          if Abs("Credit Amount" - "Debit Amount") > 0.1 then
            MakeExcelDataBody(StrSubstNo(Text012,"Employee No."));

          PayrollEmployee.SetRange("Period Filter","Payroll Period");
          PayrollEmployee.CalcFields("ED Amount");
          if PayrollEmployee."ED Amount" <> 0 then begin
            if PayrollEmployee."Exclude From Payroll" then
              MakeExcelDataBody(StrSubstNo(Text017,"Employee No."));
            if (PayrollEmployee."Termination Date" < "Period End")  and (PayrollEmployee."Termination Date" <> 0D) then
              MakeExcelDataBody(StrSubstNo(Text001,"Employee No."));
          end else begin
            if (not PayrollEmployee."Exclude From Payroll") and (not PayrollEmployee."Inactive Without Pay") then begin
              if (PayrollEmployee."Termination Date" = 0D) and (PayrollEmployee."Employment Date" <> 0D) then
                MakeExcelDataBody(StrSubstNo(Text019,"Employee No."))
            end;
          end;

          if PayrollEmployee."Appointment Status" = PayrollEmployee."appointment status"::Terminated then begin
            if PayrollEmployee."Termination Date" = 0D then
              MakeExcelDataBody(StrSubstNo(Text000,"Employee No."));
            if PayrollEmployee."Termination Date" < "Period End" then
              MakeExcelDataBody(StrSubstNo(Text001,"Employee No."));
          end;
        end;
    end;

    local procedure CheckCompulsoryED(PayslipHeader: Record "Payroll-Payslip Header")
    var
        PayrollEmployee: Record "Payroll-Employee";
        PayslipGrpLine: Record "Payroll-Employee Group Line";
        PayslipLine: Record "Payroll-Payslip Line";
        PayrollMgt: Codeunit "Payroll-Management";
        AnnualGrossAmount: Decimal;
        EmployeeGrp: Code[20];
        EffectiveDateOfEmpGrp: Date;
    begin
        with PayslipHeader do begin
          PayrollMgt.GetSalaryStructure("Employee No.","Period End",EmployeeGrp,
            AnnualGrossAmount,EffectiveDateOfEmpGrp);

          if EmployeeGrp = '' then
            MakeExcelDataBody(StrSubstNo(Text003,"Employee No."))
          else begin
            PayslipGrpLine.Reset;
            PayslipGrpLine.SetCurrentkey("ED Compulsory");
            PayslipGrpLine.SetRange("Employee Group",EmployeeGrp);
            PayslipGrpLine.SetRange("ED Compulsory",true);
            if PayslipGrpLine.FindFirst then
              repeat
                if not PayslipLine.Get("Payroll Period","Employee No.",PayslipGrpLine."E/D Code") then
                  MakeExcelDataBody(StrSubstNo(Text014,PayslipGrpLine."E/D Code","Employee No."));
              until PayslipGrpLine.Next = 0;
          end;
        end;
    end;

    local procedure CheckNegativePay(PayslipHeader: Record "Payroll-Payslip Header")
    var
        NetPayLine: Record "Payroll-Payslip Line";
        PayrollED: Record "Payroll-E/D";
    begin
        with PayslipHeader do begin
          PayrollSetup.Get;
          PayrollSetup.TestField("Net Pay E/D Code");
          PayrollED.Get(PayrollSetup."Net Pay E/D Code");
          if NetPayLine.Get("Payroll Period","Employee No.",PayrollSetup."Net Pay E/D Code") then begin
            if NetPayLine.Amount < 0 then
              MakeExcelDataBody(StrSubstNo(Text016,PayrollED.Description,"Employee No.","Employee Name"));
          end else
            MakeExcelDataBody(StrSubstNo(Text015,"Employee No.","Employee Name",PayrollED."E/D Code",PayrollED.Description));
        end;
    end;

    local procedure CheckLoans(PayslipHeader: Record "Payroll-Payslip Header")
    var
        PayslipLine: Record "Payroll-Payslip Line";
        PayrollLoan: Record "Payroll-Loan";
        PayrollLoanEntry: Record "Payroll-Loan Entry";
        IncludeLoan: Boolean;
    begin
        with PayslipHeader do begin
          PayrollLoan.Reset;
          PayrollLoan.SetCurrentkey("Employee No.","Loan E/D","Open(Y/N)");
          PayrollLoan.SetRange("Employee No.","Employee No.");
          PayrollLoan.SetRange(Status,0,PayrollLoan.Status::Approved);
          if PayrollLoan.Find('-') then repeat
            PayrollLoan.SetFilter("Date Filter",'..%1',PayslipHeader."Period Start" - 1);
            PayrollLoan.CalcFields("Remaining Amount","Interest Remaining Amount");
            IncludeLoan := false;
            if (PayrollLoan."Remaining Amount" <> 0) or (PayrollLoan."Interest Remaining Amount" <> 0) then begin
              IncludeLoan := (PayrollLoan."Suspension Ending Date" = 0D) or ((PayrollLoan."Suspension Ending Date" <> 0D)
                and (PayrollLoan."Suspension Ending Date" <=
                  "Period End") and (PayrollLoan."Deduction Starting Date" <= "Period End"));
                if IncludeLoan then begin
                  if not PayslipLine.Get("Payroll Period","Employee No.",PayrollLoan."Loan E/D") then
                    MakeExcelDataBody(StrSubstNo(Text002,PayrollLoan."Loan ID","Employee No."));

              //IF PayslipLine.GET("Payroll Period","Employee No.",PayrollLoan."Loan E/D") THEN BEGIN
                Clear(PayrollLoanEntry);
                PayrollLoanEntry.Reset;
                PayrollLoanEntry.SetRange("Payroll Period","Payroll Period");
                PayrollLoanEntry.SetRange("Employee No.","Employee No.");
                PayrollLoanEntry.SetRange("E/D Code",PayrollLoan."Loan E/D");
                PayrollLoanEntry.SetRange(PayrollLoanEntry."Entry Type",PayrollLoanEntry."entry type"::"Payroll Deduction");
                PayrollLoanEntry.CalcSums(Amount);
                if PayslipLine.Amount <> Abs(PayrollLoanEntry.Amount) then
                  MakeExcelDataBody(StrSubstNo(Text102,"Employee No.",PayrollLoan."Loan ID",PayslipLine.Amount,Abs(PayrollLoanEntry.Amount)));
              end;
            end;
          until PayrollLoan.Next = 0;
        end;
    end;

    local procedure CheckPostingConsistency(PayslipHeader: Record "Payroll-Payslip Header")
    var
        PayrollLoanEntry: Record "Payroll-Loan Entry";
        PayslipLine: Record "Payroll-Payslip Line";
        CommonIDLine: Record "Payroll-Payslip Line";
        PayrollED: Record "Payroll-E/D";
        TotalAmount: array [2] of Decimal;
    begin
        with PayslipHeader do begin
          Clear(PayslipLine);
          PayslipLine.SetRange("Payroll Period","Payroll Period");
          PayslipLine.SetRange("Employee No.","Employee No.");
          TotalAmount[1] := 0;
          TotalAmount[2] := 0;
          if PayslipLine.FindFirst then
            repeat
              if PayslipLine.Amount <> 0 then
                GetAccountNo(PayslipLine);
              PayrollED.Get(PayslipLine."E/D Code");
              if PayrollED.Blocked then
                MakeExcelDataBody(StrSubstNo(Text011,PayrollED."E/D Code","Employee No."));
              case PayrollED.Posting of
                PayrollED.Posting::"Debit Only":begin
                  if  PayslipLine."Debit Account" = '' then
                    MakeExcelDataBody(StrSubstNo(Text104,PayslipLine.FieldCaption("Debit Account"),"Employee No.",PayrollED."E/D Code"));
                  TotalAmount[1] := TotalAmount[1] + PayslipLine.Amount;
                end;
                PayrollED.Posting::"Credit Only":begin
                  if (PayslipLine."Credit Account" = '') then
                    MakeExcelDataBody(StrSubstNo(Text104,PayslipLine.FieldCaption("Credit Account"),"Employee No.",PayrollED."E/D Code"));
                  TotalAmount[2] := TotalAmount[2] - PayslipLine.Amount;
                end;
                PayrollED.Posting::Both:begin
                  if  PayslipLine."Debit Account" = '' then
                    MakeExcelDataBody(StrSubstNo(Text104,PayslipLine.FieldCaption("Debit Account"),"Employee No.",PayrollED."E/D Code"));
                  if (PayslipLine."Credit Account" = '') then
                    MakeExcelDataBody(StrSubstNo(Text104,PayslipLine.FieldCaption("Credit Account"),"Employee No.",PayrollED."E/D Code"));
                  TotalAmount[1] := TotalAmount[1] + PayslipLine.Amount;
                  TotalAmount[2] := TotalAmount[2] - PayslipLine.Amount;
                end;
              end;
              //Check Common ID
              if PayrollED."Common Id" <> '' then begin
                if CommonIDLine.Get("Payroll Period",PayrollED."Common Id") then
                  MakeExcelDataBody(StrSubstNo(Text011,PayrollED."E/D Code","Employee No."));
              end;

            until PayslipLine.Next = 0;
          if TotalAmount[1] + TotalAmount[2] <> 0 then begin
            if Abs(TotalAmount[1] + TotalAmount[2] ) > 0.1 then
              MakeExcelDataBody(StrSubstNo(Text020,"Employee No."));
          end;
        end;
    end;


    procedure MakeExcelInfo()
    begin
        ExcelBuf.SetUseInfoSheet;
        ExcelBuf.AddInfoColumn(Format(Text010),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(COMPANYNAME,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text009),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(UserId,false,false,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.NewRow;
        ExcelBuf.AddInfoColumn(Format(Text008),false,true,false,false,'',ExcelBuf."cell type"::Text);
        ExcelBuf.AddInfoColumn(Today,false,false,false,false,'',ExcelBuf."cell type"::Date);
        ExcelBuf.ClearNewRow;
        MakeExcelDataHeader;
    end;

    local procedure MakeExcelDataHeader()
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(Format(Text007),false,'',true,false,true,'',ExcelBuf."cell type"::Text);
    end;


    procedure MakeExcelDataBody(ErrorText: Text[250])
    begin
        ExcelBuf.NewRow;
        ExcelBuf.AddColumn(ErrorText,false,'',false,false,false,'',ExcelBuf."cell type"::Text);
        ErrorExist := true;
    end;


    procedure CreateExcelbook()
    begin
        ExcelBuf.CreateBookAndOpenExcel('',Text006,Text103,COMPANYNAME,UserId);
        Error('');
    end;


    procedure SetShowMessage()
    begin
        ActivateMessage := true;
    end;


    procedure GetAccountNo(var PayslipLine: Record "Payroll-Payslip Line")
    var
        Cust: Record Customer;
        Employee: Record "Payroll-Employee";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        PayslipLineED: Record "Payroll-E/D";
    begin
        with PayslipLine do begin
          Employee.Get("Employee No.");
          PayslipLineED.Get(PayslipLine."E/D Code");
          if PayslipLineED.Posting <= PayslipLineED.Posting::None then begin
            PayslipLine."Debit Account" := '';
            PayslipLine."Credit Account" := '';
            PayslipLine.Modify;
            exit;
          end;

          if not BookGrLinesRec.Get(Employee."Posting Group", "E/D Code") then begin
            MakeExcelDataBody(StrSubstNo(Text023,PayslipLineED."E/D Code",Employee."Posting Group"));
            exit;
          end;
          "Debit Account" := BookGrLinesRec."Debit Account No.";
          "Credit Account" := BookGrLinesRec."Credit Account No.";
          "Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
          "Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";
          "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
          "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
          if PayslipLineED."Loan (Y/N)" then begin
            if not Cust.Get(Employee."Customer No.") or (Employee."Customer No." = '') then
              MakeExcelDataBody(StrSubstNo(Text024,Employee."No."));
            if (BookGrLinesRec."Debit Acc. Type" = 1) then
              "Debit Account" := Employee."Customer No.";
            if (BookGrLinesRec."Credit Acc. Type" = 1) then
                "Credit Account" := Employee."Customer No.";
          end;
          Modify;
        end;
    end;
}

