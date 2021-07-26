Page 52092147 "Payroll ED Card"
{
    PageType = Card;
    SourceTable = "Payroll-E/D";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(FactorOf;"Factor Of")
                {
                    ApplicationArea = Basic;
                }
                field(FactorLookup;"Factor Lookup")
                {
                    ApplicationArea = Basic;
                }
                field(TableLookUp;"Table Look Up")
                {
                    ApplicationArea = Basic;
                }
                field(Percentage;Percentage)
                {
                    ApplicationArea = Basic;
                }
                field(AddSubtract;"Add/Subtract")
                {
                    ApplicationArea = Basic;
                }
                field(Units;Units)
                {
                    ApplicationArea = Basic;
                }
                field(Rate;Rate)
                {
                    ApplicationArea = Basic;
                }
                field(Posting;Posting)
                {
                    ApplicationArea = Basic;
                }
                field(Compute;Compute)
                {
                    ApplicationArea = Basic;
                }
                field(CommonId;"Common Id")
                {
                    ApplicationArea = Basic;
                }
                field(YesNoReq;"Yes/No Req.")
                {
                    ApplicationArea = Basic;
                }
                field(ResetNextPeriod;"Reset Next Period")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysProrate;"No. of Days Prorate")
                {
                    ApplicationArea = Basic;
                }
                field(MaxEntriesPerYear;"Max. Entries Per Year")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field(EditAmount;"Edit Amount")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(EditGrpAmount;"Edit Grp. Amount")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(RoundingDirection;"Rounding Direction")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Visible = false;
                }
                field(RoundingPrecision;"Rounding Precision")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(MinPercentage;"Min. Percentage")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(MaxPercentage;"Max. Percentage")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(StaticED;"Static ED")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Annual)
            {
                field(AnnualLeaveED;"Annual Leave ED")
                {
                    ApplicationArea = Basic;
                }
                field("13thMonthED";"Annual Allowance ED")
                {
                    ApplicationArea = Basic;
                    Caption = '13th Month ED';
                }
                field(AccrualEDCode;"Accrual ED Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Appearance)
            {
                field(Variable;Variable)
                {
                    ApplicationArea = Basic;
                }
                field(Reimbursable;Reimbursable)
                {
                    ApplicationArea = Basic;
                }
                field(Payslipappearance;"Payslip appearance")
                {
                    ApplicationArea = Basic;
                }
                field(PosInPayslipGrp;"Pos. In Payslip Grp.")
                {
                    ApplicationArea = Basic;
                }
                field(PayslipColumn;"Payslip Column")
                {
                    ApplicationArea = Basic;
                }
                field(SReportappearance;"S. Report appearance")
                {
                    ApplicationArea = Basic;
                }
                field(OverlineColumn;"Overline Column")
                {
                    ApplicationArea = Basic;
                }
                field(UnderlineAmount;"Underline Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Historical;Historical)
                {
                    ApplicationArea = Basic;
                }
                field(PayslipAppearanceText;"Payslip Appearance Text")
                {
                    ApplicationArea = Basic;
                }
                field(UseasGroupTotal;"Use as Group Total")
                {
                    ApplicationArea = Basic;
                }
                field(Italic;Italic)
                {
                    ApplicationArea = Basic;
                }
                field(Bold;Bold)
                {
                    ApplicationArea = Basic;
                }
                field(StatisticsGroupCode;"Statistics Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(AppearOnReimburseableReport;"Appear On Reimburseable Report")
                {
                    ApplicationArea = Basic;
                }
                field(ReimburseableReportText;"Reimburseable Report Text")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Loans)
            {
                field(LoanYN;"Loan (Y/N)")
                {
                    ApplicationArea = Basic;
                }
                field(LoanType;"Loan Type")
                {
                    ApplicationArea = Basic;
                }
                field(LoanDeductionStartingPeriod;"Loan Deduction Starting Period")
                {
                    ApplicationArea = Basic;
                }
                field(NumberofRepayment;"Number of Repayment")
                {
                    ApplicationArea = Basic;
                }
                field(AllowMultipleLoans;"Allow Multiple Loans")
                {
                    ApplicationArea = Basic;
                }
                field(Interest;"Interest %")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Arrears)
            {
                field(UseinArrearCalc;"Use in Arrear Calc.")
                {
                    ApplicationArea = Basic;
                }
                field(ProrateArrear;"Prorate Arrear")
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
            action(EDValues)
            {
                ApplicationArea = Basic;
                Caption = 'ED Values';
                Image = EditLines;
                RunObject = Page "ED Period and Value";
                RunPageLink = "ED Code"=field("E/D Code");
            }
            action(EDConditions)
            {
                ApplicationArea = Basic;
                Caption = 'ED Conditions';
                Image = EditList;
                RunObject = Page "ED Conditions";
                RunPageLink = "ED Code"=field("E/D Code");
            }
        }
    }
}

