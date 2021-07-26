Page 52092145 "Payroll-EDs"
{
    CardPageID = "Payroll ED Card";
    PageType = List;
    SourceTable = "Payroll-E/D";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Payslipappearance;"Payslip appearance")
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
                field(Compute;Compute)
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
                field(YesNoReq;"Yes/No Req.")
                {
                    ApplicationArea = Basic;
                }
                field(EditAmount;"Edit Amount")
                {
                    ApplicationArea = Basic;
                }
                field(EditGrpAmount;"Edit Grp. Amount")
                {
                    ApplicationArea = Basic;
                }
                field(ResetNextPeriod;"Reset Next Period")
                {
                    ApplicationArea = Basic;
                }
                field(PayslipColumn;"Payslip Column")
                {
                    ApplicationArea = Basic;
                }
                field(StatisticsGroupCode;"Statistics Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(LoanYN;"Loan (Y/N)")
                {
                    ApplicationArea = Basic;
                }
                field(LoanDeductionStartingPeriod;"Loan Deduction Starting Period")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

