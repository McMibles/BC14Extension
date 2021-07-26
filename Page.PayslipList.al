Page 52092152 "Payslip List"
{
    CardPageID = Payslip;
    PageType = List;
    SourceTable = "Payroll-Payslip Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field(PayrollPeriod;"Payroll Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    TableRelation = "Payroll-Period"."Period Code";
                    Visible = false;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(WithHoldSalary;"WithHold Salary")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PeriodStart;"Period Start")
                {
                    ApplicationArea = Basic;
                }
                field(PeriodEnd;"Period End")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SalaryGroup;"Salary Group")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(CurrencyCode;"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Reports)
            {
                Caption = '&Reports';
                action(Printpayslip)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print payslip';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = "Report";
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PayrollHeader.SetRange("Payroll Period","Payroll Period");
                        PayrollHeader.SetRange("Employee No.","Employee No.");
                        PayslipReport.SetTableview(PayrollHeader);
                        PayslipReport.RunModal;
                        Clear(PayslipReport);
                        Clear(PayrollHeader);
                    end;
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(RecalculatePayrollLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recalculate Payroll Lines';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        CurrentPayslipLine.SetRange(CurrentPayslipLine."Payroll Period","Payroll Period");
                        CurrentPayslipLine.SetRange(CurrentPayslipLine."Employee No.","Employee No.");
                        RecalculateLine.SetTableview(CurrentPayslipLine);
                        RecalculateLine.Run;
                        CurrPage.Update(true);
                        Commit;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if not(UserSetup."Payroll Administrator") then begin
          FilterGroup(2);
          if UserSetup."Personnel Level" <> '' then
            SetFilter("Employee Category",UserSetup."Personnel Level")
          else
            SetRange("Employee Category");
          FilterGroup(0);
        end else
          SetRange("Employee Category");
    end;

    var
        PayrollHeader: Record "Payroll-Payslip Header";
        UserSetup: Record "User Setup";
        ProllManagement: Codeunit "Payroll-Management";
        PayslipReport: Report "Payroll Payslip";
        CurrentPeriodCode: Code[10];
        CurrentPayslipLine: Record "Payroll-Payslip Line";
        RecalculateLine: Report "Recalculate Payroll Lines";
}

