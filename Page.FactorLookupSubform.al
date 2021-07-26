Page 52092174 "Factor Lookup Subform"
{
    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Payroll-Factor Lookup Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EDCode;"E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(EntryType;"Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(Projection;Projection)
                {
                    ApplicationArea = Basic;
                }
                field(CummulativePeriod;"Cummulative Period")
                {
                    ApplicationArea = Basic;
                }
                field(CummulativeStartPeriod;"Cummulative Start Period")
                {
                    ApplicationArea = Basic;
                }
                field(AddSubtract;"Add/Subtract")
                {
                    ApplicationArea = Basic;
                }
                field(FactorBasis;"Factor Basis")
                {
                    ApplicationArea = Basic;
                }
                field(Factor;Factor)
                {
                    ApplicationArea = Basic;
                }
                field(MinAmount;"Min. Amount")
                {
                    ApplicationArea = Basic;
                }
                field(UseArrearsAmount;"Use Arrears Amount")
                {
                    ApplicationArea = Basic;
                }
                field(MaxAmount;"Max. Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Percentage;Percentage)
                {
                    ApplicationArea = Basic;
                }
                field(InclSpecialPayroll;"Incl. Special Payroll")
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
}

