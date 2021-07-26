Page 52092450 "Birthday Due"
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
                field(FromDate;FromDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'From Date';
                }
                field(ToDate;ToDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'To Date';

                    trigger OnValidate()
                    begin
                        if ToDate < FromDate then begin
                          Message(Text001);
                          ToDate := CalcDate('7D',FromDate)
                        end;
                    end;
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

                        CurrPage.Update(false);;
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
                        EventDueMgt.BirthDayDue(Rec,FromDate,ToDate);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if FromDate = 0D then
          FromDate := Dmy2date(1,Date2dmy(Today,2),Date2dmy(Today,3));
          ToDate := CalcDate('CM',Today);
        EventDueMgt.BirthDayDue(Rec,FromDate,ToDate);
    end;

    var
        EventDueMgt: Codeunit EventDueManagement;
        FromDate: Date;
        ToDate: Date;
        StaffCategory: Code[10];
        DisableGrp: Boolean;
        Text001: label 'To Date Cannot be Less Than From Date';
}

