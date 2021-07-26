Page 52092158 "Closed Payslip List"
{
    CardPageID = "Closed Payslip";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Closed Payroll-Payslip Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field(PayrollPeriod; "Payroll Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    TableRelation = "Payroll-Period"."Period Code";
                    Visible = false;
                }
                field(EmployeeNo; "Employee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeName; "Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Closed; Closed)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(WithHoldSalary; "WithHold Salary")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PeriodStart; "Period Start")
                {
                    ApplicationArea = Basic;
                }
                field(PeriodEnd; "Period End")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; "Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(GlobalDimension2Code; "Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SalaryGroup; "Salary Group")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
                field(CurrencyCode; "Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
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
                        PayrollHeader.SetRange("Payroll Period", "Payroll Period");
                        PayrollHeader.SetRange("Employee No.", "Employee No.");
                        PayslipReport.SetTableview(PayrollHeader);
                        PayslipReport.RunModal;
                        Clear(PayslipReport);
                        Clear(PayrollHeader);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if (CalledFromPaymentVoucher = false) and (CalledFromCashLite = false) then begin
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
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if (CloseAction in [Action::OK, Action::LookupOK]) and (CalledFromPaymentVoucher) then
            CreateLines;
        if (CloseAction in [Action::OK, Action::LookupOK]) and (CalledFromCashLite) then
            CreateCashLiteLines;
    end;

    var
        PayrollHeader: Record "Payroll-Payslip Header";
        UserSetup: Record "User Setup";
        PaymentLine: Record "Payment Line";
        PaymentHeader: Record "Payment Header";
        //CashLiteTransHeader: Record "CashLite Trans Header";
        //GetScheduleEntries: Codeunit "Get Payment Schedule Entries";
        //GetCashLitePayrollEntries: Codeunit "Cashlite - Get Payroll Entries";
        CalledFromPaymentVoucher: Boolean;
        CalledFromCashLite: Boolean;
        PayslipReport: Report "Payroll Payslip";


    procedure SetParameters(var PaymentLine2: Record "Payment Line"; CalledFromPaymentVoucher2: Boolean)
    begin
        PaymentLine := PaymentLine2;
        CalledFromPaymentVoucher := CalledFromPaymentVoucher2;
        PaymentHeader.Get(PaymentLine."Document Type", PaymentLine."Document No.");
    end;

    /*
        procedure SetCashLiteParameters(var CashLiteTransHeader2: Record "CashLite Trans Header"; CalledFromCashLite2: Boolean)
        begin
            CashLiteTransHeader := CashLiteTransHeader2;
            CalledFromCashLite := CalledFromCashLite2;
        end;
    */

    procedure CreateLines()
    begin
        CurrPage.SetSelectionFilter(Rec);
        // GetScheduleEntries.SetPaymentLine(PaymentLine);
        // GetScheduleEntries.CreateScheduleFromClosedEntries(Rec);
    end;

    local procedure CreateCashLiteLines()
    begin
        CurrPage.SetSelectionFilter(Rec);
        // GetCashLitePayrollEntries.SetCashLiteTranHeader(CashLiteTransHeader);
        // case CashLiteTransHeader."Payroll Payment" of
        //     CashLiteTransHeader."payroll payment"::Salary:
        //         begin
        //             GetCashLitePayrollEntries.CreatePayrollEntries(Rec);
        //         end;
        //     CashLiteTransHeader."payroll payment"::"Pension Remitance":
        //         begin
        //             GetCashLitePayrollEntries.CreatePayrollPensionRemittanceEntries(Rec);
        //         end;
        //     CashLiteTransHeader."payroll payment"::"Other Payroll Deductions":
        //         begin
        //             GetCashLitePayrollEntries.CreatePayrollEntries(Rec);
        //         end;
        // end;
    end;
}

