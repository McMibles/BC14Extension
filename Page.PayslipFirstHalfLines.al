Page 52092156 "Payslip First Half Lines"
{
    Editable = false;
    PageType = List;
    SourceTable = "Proll-Pslip Lines First Half";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(PayrollPeriod;"Payroll Period")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EDCode;"E/D Code")
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
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Flag;Flag)
                {
                    ApplicationArea = Basic;
                }
                field(ArrearsAmount;"Arrears Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Amount;Amount)
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

