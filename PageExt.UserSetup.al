PageExtension 52000017 pageextension52000017 extends "User Setup" 
{
    layout
    {
        addafter(Email)
        {
            field("Treasury Resp. Ctr Filter";"Treasury Resp. Ctr Filter")
            {
                ApplicationArea = Basic;
            }
            field("Float Resp. Ctr Filter";"Float Resp. Ctr Filter")
            {
                ApplicationArea = Basic;
            }
            field("Employee No.";"Employee No.")
            {
                ApplicationArea = Basic;
            }
            field("Personnel Level";"Personnel Level")
            {
                ApplicationArea = Basic;

                trigger OnLookup(var Text: Text): Boolean
                var
                    EmployeeCategoryList: Page "Employee Category";
                begin
                    Clear(EmployeeCategoryList);
                    EmployeeCategoryList.LookupMode(true);
                    if not (EmployeeCategoryList.RunModal = Action::LookupOK) then
                      exit(false)
                    else
                      Text := EmployeeCategoryList.GetSelectionFilter;
                    exit(true);
                    Clear(EmployeeCategoryList)
                end;
            }
            field("Cashier Type";"Cashier Type")
            {
                ApplicationArea = Basic;
            }
            field("Account Administrator";"Account Administrator")
            {
                ApplicationArea = Basic;
            }
            field("Payroll Administrator";"Payroll Administrator")
            {
                ApplicationArea = Basic;
            }
            field("HR Administrator";"HR Administrator")
            {
                ApplicationArea = Basic;
            }
            field("Procurement Admin";"Procurement Admin")
            {
                ApplicationArea = Basic;
            }
            field("Float Administrator";"Float Administrator")
            {
                ApplicationArea = Basic;
            }
            field("Float Account No.";"Float Account No.")
            {
                ApplicationArea = Basic;
            }
            field("Receive Leave Alert";"Receive Leave Alert")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field("Schedule View Filter";"Schedule View Filter")
            {
                ApplicationArea = Basic;
            }
            field("Mobile User Administrator";"Mobile User Administrator")
            {
                ApplicationArea = Basic;
            }
            field("Login Pin";"Login Pin")
            {
                ApplicationArea = Basic;
            }
            field("Disable Token Authentication";"Disable Token Authentication")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

