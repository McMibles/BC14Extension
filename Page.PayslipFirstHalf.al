Page 52092154 "Payslip First Half"
{
    PageType = Document;
    SourceTable = "Payslip Header First Half";

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(PayrollPeriod;"Payroll Period")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PeriodName;"Period Name")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeGroup;"Employee Group")
                {
                    ApplicationArea = Basic;
                }
                field(EDFilter;"ED Filter")
                {
                    ApplicationArea = Basic;
                }
                field(EDAmount;"ED Amount")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(BasicPay;"Basic Pay")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;"Closed?")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000001;"Payslip First Half Subform")
            {
                SubPageLink = "Payroll Period"=field("Payroll Period"),
                              "Employee No."=field("Employee No");
            }
        }
    }

    actions
    {
    }
}

