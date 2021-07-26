Page 52092349 "Leave Schedule - WorkSheet"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Worksheet;
    SourceTable = "Leave Schedule Line";

    layout
    {
        area(content)
        {
            field(YearNo;YearNo)
            {
                ApplicationArea = Basic;
                Caption = 'Year';

                trigger OnValidate()
                begin
                    SetRecdFilter;
                end;
            }
            field(StartDate;StartDate)
            {
                ApplicationArea = Basic;
                Caption = 'Start Date';

                trigger OnValidate()
                begin
                    SetRecdFilter
                end;
            }
            field(EndDate;EndDate)
            {
                ApplicationArea = Basic;
                Caption = 'End Date';

                trigger OnValidate()
                begin
                    SetRecdFilter
                end;
            }
            repeater(Group)
            {
                Editable = false;
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;EmployeeName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Name';
                }
                field(Control1000000002;"Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(Control1000000003;"End Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysScheduled;"No. of Days Scheduled")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysTaken;"No. of Days Taken")
                {
                    ApplicationArea = Basic;
                }
                field(OutstandingNoofDays;"Outstanding No. of Days")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Employee.Get("Employee No.");
        EmployeeName := Employee.FullName;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error(Text001);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error(Text001);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Error(Text001);
    end;

    trigger OnOpenPage()
    begin
        if YearNo = 0 then
          YearNo := Date2dmy(Today,3);

        FilterGroup(2);
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        if not UserSetup."HR Administrator" then
          SetRange("Manager No.",UserSetup."Employee No.");
        //FILTERGROUP(0);

        SetRecdFilter
    end;

    var
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        EmployeeName: Text[100];
        YearNo: Integer;
        Text001: label 'Action not allowed';
        StartDate: Text;
        EndDate: Text;
        EmployeeFilter: Text;


    procedure SetRecdFilter()
    begin
        if YearNo <> 0 then
          SetRange("Year No.",YearNo)
        else
          SetRange("Year No.");
        
        if (StartDate <> '') and (EndDate = '') then begin
          SetFilter("Start Date",StartDate);
          SetRange("End Date");
        end;
        if (EndDate <> '') and (StartDate = '') then begin
          SetRange("Start Date");
          SetFilter("End Date",EndDate);
        end;
        if (StartDate <> '') and (EndDate <> '')  then begin
          SetFilter("Start Date",StartDate);
          SetFilter("End Date",EndDate);
        end;
        if (StartDate = '') and (EndDate = '')  then begin
          SetRange("Start Date");
          SetRange("End Date");
        end;
        
        
        /*(IF (StartDate <> 0D) AND (EndDate = 0D) THEN BEGIN
          SETFILTER("Start Date",'%1',StartDate);
          SETRANGE("End Date");
        END;
        IF (EndDate <> 0D) AND (StartDate = 0D) THEN BEGIN
          SETRANGE("Start Date");
          SETFILTER("End Date",'%1',EndDate);
        END;
        IF (StartDate <> 0D) AND (EndDate <> 0D)  THEN BEGIN
          SETFILTER("Start Date",'%1',StartDate);
          SETFILTER("End Date",'%1',StartDate,EndDate);
        END;
        IF (StartDate = 0D) AND (EndDate = 0D)  THEN BEGIN
          SETRANGE("Start Date");
          SETRANGE("End Date");
        END;*/
        
        CurrPage.Update;

    end;
}

