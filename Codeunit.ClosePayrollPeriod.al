Codeunit 52092144 "Close Payroll Period"
{
    Permissions = TableData "Employee Absence"=rim;
    TableNo = "Payroll-Period";

    trigger OnRun()
    begin
        PayrollPeriod.Copy(Rec);
        Code;
        Rec := PayrollPeriod;
    end;

    var
        Text002: label 'This function closes the payroll period from %1 to %2. ';
        Text003: label 'Once the payroll period is closed it cannot be opened again, and the entries in the period cannot be changed.\\';
        Text004: label 'Do you want to close the payroll period?';
        PayrollPeriod: Record "Payroll-Period";
        Text005: label 'Period not yet approved';
        WindowDialog: Dialog;
        PayrollPayslipHeader: Record "Payroll-Payslip Header";
        PayrollPayslipLine: Record "Payroll-Payslip Line";
        ClosedPayrollPayslipHeader: Record "Closed Payroll-Payslip Header";
        ClosedPayrollPayslipLine: Record "Closed Payroll-Payslip Line";
        Text006: label 'Closing Payslips';
        ApprovalEntry: Record "Approval Entry";
        TempApprovalEntry: Record "Approval Entry" temporary;
        EmployeeAbsence: Record "Employee Absence";
        ApprovalMgt: Codeunit "Approvals Mgmt.";

    local procedure "Code"()
    begin
        with PayrollPeriod do begin
          if Closed then
            exit;
          if not
             Confirm(
               Text002 +
               Text003 +
               Text004,false,
               PayrollPeriod."Start Date",PayrollPeriod."End Date")
          then
            exit;

          if PayrollPeriod.Status <> PayrollPeriod.Status::Approved then
            Error(Text005);

          WindowDialog.Open(Text006);

          PayrollPayslipHeader.SetRange("Payroll Period",PayrollPeriod."Period Code");
          if PayrollPayslipHeader.Find('-') then
            repeat
              ClosedPayrollPayslipHeader.TransferFields(PayrollPayslipHeader);
              ClosedPayrollPayslipHeader.Insert;
            until PayrollPayslipHeader.Next = 0;

          PayrollPayslipLine.SetRange("Payroll Period","Period Code");
          if PayrollPayslipLine.Find('-') then
            repeat
              ClosedPayrollPayslipLine.TransferFields(PayrollPayslipLine);
              ClosedPayrollPayslipLine.Insert;
              if PayrollPayslipLine."Processed Leave Entry No." <> 0 then begin
                EmployeeAbsence.Get(PayrollPayslipLine."Processed Leave Entry No.");
                EmployeeAbsence."Leave Paid" := PayrollPayslipLine."Amount (LCY)" <> 0;
                EmployeeAbsence."Leave Amount Paid" := PayrollPayslipLine.Amount;
                EmployeeAbsence.Modify;
              end;
            until PayrollPayslipLine.Next = 0;

          PayrollPayslipHeader.DeleteAll;
          PayrollPayslipLine.DeleteAll;

          PayrollPeriod.Closed :=  true;
          PayrollPeriod.Modify;

          ApprovalMgt.PostApprovalEntries(RecordId,RecordId,"Period Code");
          ApprovalMgt.DeleteApprovalEntries(RecordId);

          WindowDialog.Close;
        end;
    end;
}

