Page 52092170 "Employee Group Subform"
{
    PageType = ListPart;
    SourceTable = "Payroll-Employee Group Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(EmployeeGroup; "Employee Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EDCode; "E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(PayslipText; "Payslip Text")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Units; Units)
                {
                    ApplicationArea = Basic;
                }
                field(Rate; Rate)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Flag; Flag)
                {
                    ApplicationArea = Basic;
                }
                field(DefaultAmount; "Default Amount")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0 :;
                }
            }
        }
    }

    actions
    {
    }
}

