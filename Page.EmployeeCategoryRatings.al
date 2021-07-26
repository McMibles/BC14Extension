Page 52092399 "Employee Category Ratings"
{
    Caption = 'Employee Category Ratings';
    PageType = List;
    SourceTable = "Employee Category Rating Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category';
                }
                field(Ratingtype;"Rating type")
                {
                    ApplicationArea = Basic;
                }
                field("Max";"Max%")
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

