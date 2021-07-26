Page 52092189 "Gratuity Ledger Entry"
{
    Editable = false;
    PageType = List;
    SourceTable = "Gratuity Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(PeriodEndDate;"Period End Date")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentAmount;"Current Amount")
                {
                    ApplicationArea = Basic;
                }
                field(BasicSalary;"Basic Salary")
                {
                    ApplicationArea = Basic;
                }
                field(PeriodLength;"Period Length")
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

