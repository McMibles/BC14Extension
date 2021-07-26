Page 52092164 "Table Lookup Subform"
{
    PageType = ListPart;
    SourceTable = "Payroll-Lookup Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(LowerAmount;"Lower Amount")
                {
                    ApplicationArea = Basic;
                }
                field(LowerCode;"Lower Code")
                {
                    ApplicationArea = Basic;
                }
                field(UpperAmount;"Upper Amount")
                {
                    ApplicationArea = Basic;
                }
                field(UpperCode;"Upper Code")
                {
                    ApplicationArea = Basic;
                }
                field(ExtractAmount;"Extract Amount")
                {
                    ApplicationArea = Basic;
                }
                field(TaxRate;"Tax Rate %")
                {
                    ApplicationArea = Basic;
                }
                field(CumTaxPayable;"Cum. Tax Payable")
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

