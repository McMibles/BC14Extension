Page 52092186 "Employee Salary"
{
    PageType = Card;
    SourceTable = "Employee Salary";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SalaryGroup;"Salary Group")
                {
                    ApplicationArea = Basic;
                }
                field(EffectiveDate;"Effective Date")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode;"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(AnnualGrossAmount;"Annual Gross Amount")
                {
                    ApplicationArea = Basic;
                }
                field(PaymentPeriod;"Payment Period")
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

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if "Salary Group" <> '' then
          TestField("Effective Date");
        if "Entry Type" in [1,2] then begin
          TestField("No. of Periods");
          TestField("Payment Period");
        end;
    end;
}

