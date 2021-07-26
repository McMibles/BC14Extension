Page 52092199 "Payroll Variable Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Payroll Payslip Variable";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PayrollPeriod;"Payroll Period")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Processed;Processed)
                {
                    ApplicationArea = Basic;
                }
                field(PayslipLineExist;"Payslip Line Exist")
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

