Page 52092135 "Mobile Approval User Setup"
{
    PageType = List;
    SourceTable = "Mobile Approval User Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(UserID;"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(EMail;"E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExcludeFromMFA;"Exclude From MFA")
                {
                    ApplicationArea = Basic;
                }
                field(MultiFactorAuthPIN;"Multi Factor Auth PIN")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control8;MyNotes)
            {
            }
            systempart(Control9;Links)
            {
            }
            systempart(Control10;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Users)
            {
                ApplicationArea = Advanced;
                Caption = 'Users';
                Image = Users;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Approval User Setup";
                ToolTip = 'Set up the employees who will approve document in this company.';
            }
        }
    }
}

