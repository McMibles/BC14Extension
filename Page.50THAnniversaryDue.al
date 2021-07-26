Page 52092453 "50TH Anniversary Due"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(Filters)
            {
                Caption = 'Filters';
                field(Years;Years)
                {
                    ApplicationArea = Basic;
                    Caption = 'Anniversary Years';
                }
                field(StaffCategory;StaffCategory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category';
                    TableRelation = "Employee Category";

                    trigger OnValidate()
                    begin
                        if StaffCategory = '' then
                          SetRange("Employee Category")
                        else
                          SetRange("Employee Category",StaffCategory);

                        CurrPage.Update(false);
                    end;
                }
                field(DepartmentCode;DepartmentCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Department';
                    TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));

                    trigger OnValidate()
                    begin
                        if DepartmentCode = '' then
                          SetRange("Global Dimension 1 Code")
                        else
                          SetFilter("Global Dimension 1 Code",DepartmentCode);

                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Group)
            {
                Editable = false;
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(FullName;FullName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(BirthDate;"Birth Date")
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
            group(Functions)
            {
                Caption = 'Functions';
                action("<Action1000000014>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Update';
                    Image = UpdateXML;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        EventDueMgt.FiftyYrAnniversary(Rec,Years);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Years = 0 then Years := 50;
          EventDueMgt.FiftyYrAnniversary(Rec,Years);
    end;

    var
        EventDueMgt: Codeunit EventDueManagement;
        StaffCategory: Code[10];
        DepartmentCode: Code[20];
        Years: Integer;
        DisableGrp: Boolean;
        Text001: label 'To Date Cannot be Less Than From Date';
}

