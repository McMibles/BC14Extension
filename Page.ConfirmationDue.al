Page 52092451 "Confirmation Due"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = Employee;
    SourceTableView = where("Employment Status"=const(Probation));

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

                    trigger OnValidate()
                    begin
                        if FromDate = 0D then
                          SetRange("Confirmation Due Date")
                        else begin
                          ToDate := CalcDate('2W',FromDate);
                          SetRange("Confirmation Due Date",FromDate,ToDate);
                        end;
                        CurrPage.Update;
                    end;
                }
                field(ToDate;ToDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'To Date';

                    trigger OnValidate()
                    begin
                        if (ToDate = 0D) and (FromDate <> 0D) then  begin
                          ToDate := CalcDate('2W',FromDate);
                          SetRange("Confirmation Due Date",FromDate,ToDate);
                        end else
                          SetRange("Confirmation Due Date",FromDate,ToDate);

                        CurrPage.Update;
                    end;
                }
                field(StaffCategory;StaffCategory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category';
                    TableRelation = "Employee Category";

                    trigger OnValidate()
                    begin
                        if StaffCategory =  '' then
                          SetRange("Employee Category")
                        else
                          SetRange("Employee Category",StaffCategory);

                        CurrPage.Update;
                    end;
                }
                field(Dimension1Filter;Dimension1Filter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Department';

                    trigger OnValidate()
                    begin
                        if Dimension1Filter = '' then
                          SetRange("Global Dimension 1 Code")
                        else
                          SetFilter("Global Dimension 1 Code",Dimension1Filter);
                        CurrPage.Update;
                    end;
                }
            }
            repeater(Group)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(FullName;FullName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    Editable = false;
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmploymentDate;"Employment Date")
                {
                    ApplicationArea = Basic;
                }
                field(EmploymentStatus;"Employment Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ProbationPeriod;"Probation Period")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ConfirmationDueDate;"Confirmation Due Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(xAction;xAction)
                {
                    ApplicationArea = Basic;
                    Caption = 'Confirmation Action';

                    trigger OnValidate()
                    begin
                        EventDue.SetRange(EventDue."Entry Type",EventDue."entry type"::Confirmation);
                        EventDue.SetRange(EventDue."Employee No.","No.");
                        if EventDue.Find('-') then begin
                          EventDue.Confirmation := xAction;
                          EventDue."Due Date" := Today;
                          case xAction of
                           0 : begin
                             EventDue.Delete;
                             GroundsforTerm := '';
                             Clear(ExtPeriod);
                             ConfirmedBy := '';
                           end;
                           1 : begin
                             EventDue."Grounds for Termination" := '';
                             Clear(ExtPeriod);
                           end;
                           2 : begin
                             EventDue."Responsible Empl. No." := '';
                             EventDue."Grounds for Termination" := '';
                           end;
                           3 : begin
                             EventDue."Responsible Empl. No." := '';
                             Clear(ExtPeriod);
                           end;
                          end; /*end case*/
                          if xAction <> 0 then begin
                            GroundsforTerm := EventDue."Grounds for Termination";
                            Clear(ExtPeriod);
                            ConfirmedBy := EventDue."Responsible Empl. No.";
                            EventDue.Modify;
                          end;
                        end else begin
                          EventDue.Init;
                          EventDue."Entry Type" := EventDue."entry type"::Confirmation;
                          EventDue."Employee No." := "No.";
                          EventDue."Employee Name" := "Last Name" + ' ' + "First Name";
                          EventDue.Confirmation := xAction;
                          EventDue."Due Date" := Today;
                          if EventDue2.Find('+') then
                            EventDue."Entry No." := EventDue2."Entry No." + 1
                          else
                            EventDue."Entry No." := 1;
                          EventDue.Insert;
                        end;

                    end;
                }
                field(ExtPeriod;ExtPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'New Probation Period';

                    trigger OnValidate()
                    begin
                        EventDue.SetRange(EventDue."Entry Type",EventDue."entry type"::Confirmation);
                        EventDue.SetRange(EventDue."Employee No.","No.");
                        EventDue.SetRange(EventDue.Confirmation,EventDue.Confirmation::"Ext. Probation");
                        if EventDue.FindFirst then begin
                          EventDue."Ext. Period" := ExtPeriod;
                          EventDue."Due Date" := Today;
                          EventDue.Modify;
                        end else
                          Error('Confirmation must be specified as Ext. Probation!');
                    end;
                }
                field(GroundsforTerm;GroundsforTerm)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grounds for Termination';

                    trigger OnValidate()
                    begin
                        EventDue.SetRange(EventDue."Entry Type",EventDue."entry type"::Confirmation);
                        EventDue.SetRange(EventDue."Employee No.","No.");
                        EventDue.SetRange(Confirmation,EventDue.Confirmation::Terminate);
                        if EventDue.Find('-') then begin
                          EventDue."Grounds for Termination" := GroundsforTerm;
                          EventDue."Due Date" := Today;
                          EventDue.Modify;
                        end else
                          Error('Confirmation must be Terminated!');
                    end;
                }
                field(ConfirmedBy;ConfirmedBy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Confirmed By';
                    TableRelation = Employee;

                    trigger OnValidate()
                    begin
                        EventDue.SetRange(EventDue."Entry Type",EventDue."entry type"::Confirmation);
                        EventDue.SetRange(EventDue."Employee No.","No.");
                        EventDue.SetRange(Confirmation,EventDue.Confirmation::Confirm);
                        if EventDue.Find('-') then begin
                          EventDue."Responsible Empl. No." := ConfirmedBy;
                          EventDue."Due Date" := Today;
                          EventDue.Modify;
                        end else
                          Error('Employee not yet confirmed!');
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000015>")
            {
                ApplicationArea = Basic;
                Caption = 'Process Action';
                Image = Apply;

                trigger OnAction()
                begin
                    Employee.Copy(Rec);
                    EventDueMgt.Confirmation(Employee);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EventDue.SetRange(EventDue."Entry Type",EventDue."entry type"::Confirmation);
        EventDue.SetRange(EventDue."Employee No.","No.");
        if EventDue.Find('-') then begin
          xAction := EventDue.Confirmation;
          GroundsforTerm := EventDue."Grounds for Termination";
          ExtPeriod := EventDue."Ext. Period";
          ConfirmedBy := EventDue."Responsible Empl. No.";
        end else begin
          xAction := 0;
          GroundsforTerm := '';
          Clear(ExtPeriod);
          ConfirmedBy := ''
        end;
    end;

    trigger OnOpenPage()
    begin
        if FromDate = 0D then
          FromDate := Today;

        ToDate := CalcDate('2W',FromDate);
        SetRange("Confirmation Due Date",FromDate,ToDate);
    end;

    var
        EventDue: Record "Event Due";
        EventDue2: Record "Event Due";
        Employee: Record Employee;
        FromDate: Date;
        ToDate: Date;
        EventDueMgt: Codeunit EventDueManagement;
        StaffCategory: Code[10];
        Dimension1Filter: Code[10];
        GroundsforTerm: Code[10];
        ExtPeriod: DateFormula;
        ConfirmedBy: Code[10];
        xAction: Option " ",Confirm,"Ext. Probation",Terminate;
}

