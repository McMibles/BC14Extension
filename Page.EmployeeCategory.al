Page 52092338 "Employee Category"
{
    PageType = List;
    SourceTable = "Employee Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000005>")
            {
                ApplicationArea = Basic;
                Caption = 'Absence Setup';
                Image = AbsenceCategory;
                RunObject = Page "Leave Setup";
                RunPageLink = "Record Type" = const(Category),
                              "No." = field(Code);
            }
            action("<Action1000000006>")
            {
                ApplicationArea = Basic;
                Caption = 'Travel Setup';
                Image = Travel;
                RunObject = Page "Employee Cat. Travel Setup";
                RunPageLink = "Employee Catgory" = field(Code);
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        EmployeeCategory: Record "Employee Category";
        SelectionFilterManagement: Codeunit SelectionFilterManagement46;
    begin
        CurrPage.SetSelectionFilter(EmployeeCategory);
        exit(SelectionFilterManagement.GetSelectionFilterForEmployeeCategory(EmployeeCategory));
    end;
}

