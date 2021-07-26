Page 52092155 "Payslip First Half Subform"
{
    PageType = ListPart;
    SourceTable = "Proll-Pslip Lines First Half";

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
                field(ArrearsAmount;"Arrears Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(Payslipappearance;"Payslip appearance")
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
                field(PaymentPeriod;"Payment Period")
                {
                    ApplicationArea = Basic;
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
            }
        }
    }

    actions
    {
    }
}

