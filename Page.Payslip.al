Page 52092150 Payslip
{
    PageType = Document;
    SourceTable = "Payroll-Payslip Header";

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(NoofDaysWorked;"No. of Days Worked")
                {
                    ApplicationArea = Basic;
                }
                field(NoofWorkingDaysBasis;"No. of Working Days Basis")
                {
                    ApplicationArea = Basic;
                }
            }
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field(PayrollPeriod;"Payroll Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
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
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                }
                field(SalaryGroup;"Salary Group")
                {
                    ApplicationArea = Basic;
                }
                field(EffectiveDateOfSalaryGroup;"Effective Date Of Salary Group")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode;"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control24;"Payslip Subform")
            {
                SubPageLink = "Payroll Period"=field("Payroll Period"),
                              "Employee No."=field("Employee No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimension)
            {
                ApplicationArea = Basic;
                Image = Dimensions;

                trigger OnAction()
                begin
                    ShowDocDim;
                    CurrPage.SaveRecord;
                end;
            }
        }
        area(reporting)
        {
            action(Payslip)
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

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
        area(processing)
        {
            group(Functions)
            {
                action("Recalculate Payroll Lines")
                {
                    ApplicationArea = Basic;
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
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ReleaseDocument: Codeunit "Release Documents";
        RecRef: RecordRef;
        PayslipReport: Report "Payroll Payslip";
        CurrentPeriodCode: Code[10];
        CurrentPayslipLine: Record "Payroll-Payslip Line";
        RecalculateLine: Report "Recalculate Payroll Lines";
}

