Page 52092171 "Employee Group List"
{
    CardPageID = "Employee Group";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll-Employee Group Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(GrossPay;"Gross Pay")
                {
                    ApplicationArea = Basic;
                }
                field(TaxCharged;"Tax Charged")
                {
                    ApplicationArea = Basic;
                }
                field(TaxDeducted;"Tax Deducted")
                {
                    ApplicationArea = Basic;
                }
                field(TaxablePay;"Taxable Pay")
                {
                    ApplicationArea = Basic;
                }
                field(TotalDeductions;"Total Deductions")
                {
                    ApplicationArea = Basic;
                }
                field(NetPayDue;"Net Pay Due")
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

