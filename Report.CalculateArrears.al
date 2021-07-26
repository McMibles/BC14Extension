Report 52092193 "Calculate Arrears"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-E/D";"Payroll-E/D")
        {
            DataItemTableView = sorting("E/D Code") where("Use in Arrear Calc."=const(true));
            column(ReportForNavId_1; 1)
            {
            }
            dataitem(ClosedPaySlip;"Closed Payroll-Payslip Header")
            {
                CalcFields = "ED Amount";
                RequestFilterFields = "Payroll Period";
                RequestFilterHeading = 'Select Arrear Periods';
                column(ReportForNavId_2; 2)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CurrentPayslip.Reset;
                    CurrentAmount := 0;
                    PreviousAmount := 0;
                    ActualAmount := 0;
                    if not(CurrentPayslip.Get(CurrentPeriod,ClosedPaySlip."Employee No.")) then
                      CurrReport.Skip;
                    ClosedPaySlip.SetFilter("ED Filter","Payroll-E/D"."E/D Code");
                    CurrentPayslip.SetFilter("ED Filter","Payroll-E/D"."E/D Code");

                    CurrentPayslip.CalcFields(CurrentPayslip."ED Amount");
                    ClosedPaySlip.CalcFields(ClosedPaySlip."ED Amount");

                    if (CurrentPayslip."No. of Days Worked" <> 0) and ("Payroll-E/D"."Prorate Arrear") then
                      ActualAmount := (CurrentPayslip."ED Amount"/CurrentPayslip."No. of Days Worked") * CurrentPayslip."No. of Working Days Basis"
                    else
                      ActualAmount := CurrentPayslip."ED Amount";

                    if (ClosedPaySlip."No. of Days Worked" <> 0) and ("Payroll-E/D"."Prorate Arrear") then
                      CurrentAmount := (ActualAmount/ClosedPaySlip."No. of Working Days Basis") * ClosedPaySlip."No. of Days Worked"
                    else
                      CurrentAmount := ActualAmount;
                    CreateEmployeeAmount("Employee No.","Payroll-E/D"."Arrear ED Code",(CurrentAmount - ClosedPaySlip."ED Amount"));
                end;
            }
        }
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(1));
            column(ReportForNavId_3; 3)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if EmployeeAmount[1].Find('-') then
                  repeat
                    CurrentPayslipLine.Get(CurrentPeriod,EmployeeAmount[1]."Employee No.",EmployeeAmount[1]."ED Code");
                    CurrentPayslipLine.Amount := EmployeeAmount[1].Amount;
                    CurrentPayslipLine.Modify;

                    CurrentPayslipLine.CalcCompute(CurrentPayslipLine, CurrentPayslipLine.Amount, false,CurrentPayslipLine."E/D Code");
                    CurrentPayslipLine.CalcFactor1 (CurrentPayslipLine);
                    CurrentPayslipLine.ChangeOthers := false;
                    CurrentPayslipLine.ChangeAllOver (CurrentPayslipLine, false);
                    CurrentPayslipLine.ResetChangeFlags(CurrentPayslipLine);

                  until EmployeeAmount[1].Next = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Current Period";CurrentPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Select Current Period';
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

    var
        CurrentPeriod: Code[20];
        CurrentPayslip: Record "Payroll-Payslip Header";
        CurrentPayslipLine: Record "Payroll-Payslip Line";
        EmployeeAmount: array [2] of Record "Employee Amount";
        CurrentAmount: Decimal;
        PreviousAmount: Decimal;
        ActualAmount: Decimal;


    procedure CreateEmployeeAmount(EmployeeNo: Code[20];EDCode: Code[20];Amount: Decimal)
    begin
        if Amount >= 0 then begin
          EmployeeAmount[1]."Employee No." := EmployeeNo;
          EmployeeAmount[1]."ED Code" := EDCode;
          EmployeeAmount[1].Amount := Amount;
          EmployeeAmount[2] := EmployeeAmount[1];
          if EmployeeAmount[2].Find then begin
            EmployeeAmount[2].Amount :=
              EmployeeAmount[2].Amount + EmployeeAmount[1].Amount;
            EmployeeAmount[2].Modify;
          end else
            EmployeeAmount[1].Insert;
        end else
          exit;
    end;


    procedure CalActualAndCurrentAmount()
    var
        CurrentPayslipLine: Record "Payroll-Payslip Line";
    begin
        if not("Payroll-E/D".Variable) then begin
          if (CurrentPayslip."No. of Days Worked" <> 0) and ("Payroll-E/D"."Prorate Arrear") then
            ActualAmount := (CurrentPayslip."ED Amount"/CurrentPayslip."No. of Days Worked") * CurrentPayslip."No. of Working Days Basis"
          else
            ActualAmount := CurrentPayslip."ED Amount";

          if (ClosedPaySlip."No. of Days Worked" <> 0) and ("Payroll-E/D"."Prorate Arrear") then
            CurrentAmount := (ActualAmount/ClosedPaySlip."No. of Working Days Basis") * ClosedPaySlip."No. of Days Worked"
          else
            CurrentAmount := ActualAmount;
        end else begin
          //CurrentPayslipLine.get(
          if ("Payroll-E/D"."No. of Months Prorate") and ("Payroll-E/D"."Prorate Arrear") then
            ActualAmount := (CurrentPayslip."ED Amount"/CurrentPayslip."No. of Days Worked") * CurrentPayslip."No. of Working Days Basis"
          else
            ActualAmount := CurrentPayslip."ED Amount";

          if (ClosedPaySlip."No. of Days Worked" <> 0) and ("Payroll-E/D"."Prorate Arrear") then
            CurrentAmount := (ActualAmount/ClosedPaySlip."No. of Working Days Basis") * ClosedPaySlip."No. of Days Worked"
          else
            CurrentAmount := ActualAmount;
        end;
    end;
}

