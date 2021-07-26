Page 52092200 "Payroll Variable List"
{
    CardPageID = "Payroll Variable Card";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Variable Header";
    SourceTableView = where(Processed=const(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PeriodName;"Period Name")
                {
                    ApplicationArea = Basic;
                }
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(PayslipText;"Payslip Text")
                {
                    ApplicationArea = Basic;
                }
                field(UserId;"User Id")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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

