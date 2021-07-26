Page 52092144 "Payroll-Setup"
{
    PageType = Card;
    SourceTable = "Payroll-Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(PayrollPersonnelIntegration; "Payroll/Personnel Integration")
                {
                    ApplicationArea = Basic;
                }
                field(NetPayEDCode; "Net Pay E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(TotalNetPayED; "Total Net Pay E/D")
                {
                    ApplicationArea = Basic;
                }
                field(AnnualGrossPayEDCode; "Annual Gross Pay E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(TotalEmolumentFactorLookup; "Total Emolument Factor Lookup")
                {
                    ApplicationArea = Basic;
                }
                field(GratuityBenefitFactorCode; "Gratuity Benefit Factor Code")
                {
                    ApplicationArea = Basic;
                }
                field(PensionRegistrationNo; "Pension Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(PensionEmployeeED; "Pension Employee E/D")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Clear(EDList);
                        EDList.LookupMode(true);
                        if not (EDList.RunModal = Action::LookupOK) then
                            exit(false)
                        else
                            Text := EDList.GetSelectionFilter;
                        exit(true);
                        Clear(EDList)
                    end;
                }
                field(PensionEmployerED; "Pension Employer E/D")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Clear(EDList);
                        EDList.LookupMode(true);
                        if not (EDList.RunModal = Action::LookupOK) then
                            exit(false)
                        else
                            Text := EDList.GetSelectionFilter;
                        exit(true);
                        Clear(EDList)
                    end;
                }
                field(TotalPensionContriED; "Total Pension Contri. E/D")
                {
                    ApplicationArea = Basic;
                }
                field(MonthlyGrossEDCode; "Monthly Gross ED Code")
                {
                    ApplicationArea = Basic;
                }
                field(BasicEDCode; "Basic E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(NetPayStatisticalGroupCode; "Net Pay Statistical Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(NoofWorkingDays; "No. of Working Days")
                {
                    ApplicationArea = Basic;
                }
                field(ExGratiaEDCode; "ExGratia ED Code")
                {
                    ApplicationArea = Basic;
                }
                field(LeaveEDCode; "Leave ED Code")
                {
                    ApplicationArea = Basic;
                }
                field(LeaveAccrualEDCode; "Leave Accrual ED Code")
                {
                    ApplicationArea = Basic;
                }
                field(ShowCompanyLogo; "Show Company Logo")
                {
                    ApplicationArea = Basic;
                }
            }
            group(LoanProcessing)
            {
                Caption = 'Loan Processing';
                field(LoanDeductionStartingPeriod; "Loan Deduction Starting Period")
                {
                    ApplicationArea = Basic;
                }
                field(InterestAccount; "Interest Account")
                {
                    ApplicationArea = Basic;
                }
                field(InterestCalculationMethod; "Interest Calculation Method")
                {
                    ApplicationArea = Basic;
                }
                field(DeferredInterestAccount; "Deferred Interest Account")
                {
                    ApplicationArea = Basic;
                }
                field(UseDSRLimit; "Use DSR Limit")
                {
                    ApplicationArea = Basic;
                }
                field(UseStakeholdersFundLimit; "Use Stakeholders Fund Limit")
                {
                    ApplicationArea = Basic;
                }
                field(StakeHoldersFundLimit; "StakeHolders Fund Limit")
                {
                    ApplicationArea = Basic;
                }
                field(DSRLimitCalcValue; "DSR Limit  Calc. Value")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field(EmployeeNos; "Employee Nos")
                {
                    ApplicationArea = Basic;
                }
                field(LoanNos; "Loan Nos.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        EDList: Page "Payroll-ED List";
}

