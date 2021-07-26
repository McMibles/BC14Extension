Page 52092161 "Closed Payslip Lines"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Closed Payroll-Payslip Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(PayslipText;"Payslip Text")
                {
                    ApplicationArea = Basic;
                }
                field(PayrollPeriod;"Payroll Period")
                {
                    ApplicationArea = Basic;
                }
                field(AmountToBook;AmountToBook)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ChangeOthers;ChangeOthers)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(HasBeenChanged;HasBeenChanged)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Units;Units)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Rate;Rate)
                {
                    ApplicationArea = Basic;
                }
                field(Flag;Flag)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(DebitAccount;"Debit Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CreditAccount;"Credit Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PayslipAppearance;"Payslip Appearance")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PayslipColumn;"Payslip Column")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(StatisticsGroupCode;"Statistics Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PosInPayslipGrp;"Pos. In Payslip Grp.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OverlineColumn;"Overline Column")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnderlineAmount;"Underline Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LoanID;"Loan ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

