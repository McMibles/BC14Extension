Query 52092146 "Top 10 Earners"
{
    OrderBy = ascending(ED_Closed_Amount);
    TopNumberOfRows = 10;

    elements
    {
        dataitem(Payroll_Employee;"Payroll-Employee")
        {
            column(No;"No.")
            {
            }
            column(First_Name;"First Name")
            {
            }
            column(Last_Name;"Last Name")
            {
            }
            column(Global_Dimension_1_Code;"Global Dimension 1 Code")
            {
            }
            column(Employee_Category;"Employee Category")
            {
            }
            filter(ED_Filter;"ED Filter")
            {
            }
            filter(Period_Filter;"Period Filter")
            {
            }
            column(ED_Closed_Amount;"ED Closed Amount")
            {
            }
        }
    }

    trigger OnBeforeOpen()
    var
        PayrollSetup: Record "Payroll-Setup";
        UserSetup: Record "User Setup";
    begin
        PayrollSetup.Get;
        UserSetup.Get(UserId);
        if not(UserSetup."Payroll Administrator") then
          SetFilter(Employee_Category,UserSetup."Personnel Level")
        else
          SetRange(Employee_Category);
        SetFilter(ED_Filter,PayrollSetup."Annual Gross Pay E/D Code");
    end;
}

