Page 52092146 "Payroll-ED List"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Payroll-E/D";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EDCode; "E/D Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(FactorOf; "Factor Of")
                {
                    ApplicationArea = Basic;
                }
                field(FactorLookup; "Factor Lookup")
                {
                    ApplicationArea = Basic;
                }
                field(TableLookUp; "Table Look Up")
                {
                    ApplicationArea = Basic;
                }
                field(Percentage; Percentage)
                {
                    ApplicationArea = Basic;
                }
                field(Compute; Compute)
                {
                    ApplicationArea = Basic;
                }
                field(Units; Units)
                {
                    ApplicationArea = Basic;
                }
                field(Rate; Rate)
                {
                    ApplicationArea = Basic;
                }
                field(YesNoReq; "Yes/No Req.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    procedure GetSelectionFilter(): Text
    var
        PayrollED: Record "Payroll-E/D";
        SelectionFilterManagement: Codeunit SelectionFilterManagement46;
    begin
        CurrPage.SetSelectionFilter(PayrollED);
        exit(SelectionFilterManagement.GetSelectionFilterForPayrollED(PayrollED));
    end;
}

