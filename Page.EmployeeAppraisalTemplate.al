Page 52092403 "Employee Appraisal Template"
{
    Caption = 'Employee Performance Template';
    PageType = List;
    SourceTable = "Employee Appraisal Template";

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
            }
        }
    }

    actions
    {
    }
}

