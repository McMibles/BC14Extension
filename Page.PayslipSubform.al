Page 52092151 "Payslip Subform"
{
    PageType = ListPart;
    SourceTable = "Payroll-Payslip Line";

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
                field(PayrollPeriod;"Payroll Period")
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
                field(AmountLCY;"Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DebitAccType;"Debit Acc. Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DebitAccount;"Debit Account")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CreditAccType;"Credit Acc. Type")
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
                field(Bold;Bold)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Dimension)
            {
                ApplicationArea = Basic;
                Caption = 'Dimension';
                Image = Dimensions;

                trigger OnAction()
                begin
                    ShowDimensions;
                end;
            }
        }
    }
}

