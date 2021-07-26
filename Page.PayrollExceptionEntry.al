Page 52092185 "Payroll Exception Entry"
{
    Editable = false;
    PageType = Card;
    SourceTable = "Payroll Exception";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EDCode;"ED Code")
                {
                    ApplicationArea = Basic;
                }
                field(Remark;Remark)
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

