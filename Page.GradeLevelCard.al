Page 52092333 "Grade Level Card"
{
    PageType = Card;
    SourceTable = "Grade Level";

    layout
    {
        area(content)
        {
            field("Code";Code)
            {
                ApplicationArea = Basic;
            }
            field(Level;Level)
            {
                ApplicationArea = Basic;
            }
            field(Step;Step)
            {
                ApplicationArea = Basic;
            }
            field(Description;Description)
            {
                ApplicationArea = Basic;
            }
            field(EmployeeCategory;"Employee Category")
            {
                ApplicationArea = Basic;
                Caption = 'Employee Category';
            }
            field(SalaryGrade;"Salary Group")
            {
                ApplicationArea = Basic;
                Caption = 'Salary Grade';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(AbsenceSetup)
            {
                ApplicationArea = Basic;
                Caption = 'Absence Setup';
                Image = AbsenceCategory;
                RunObject = Page "Leave Setup";
                RunPageLink = "Record Type"=const("Grade Level"),
                              "No."=field(Code);
            }
        }
    }

    trigger OnOpenPage()
    begin
        if CurrPage.LookupMode then
          CurrPage.Editable := false;
    end;
}

