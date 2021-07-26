Report 52092364 "Create Leave Schedule"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.";
            column(ReportForNavId_7528; 7528)
            {
            }
            dataitem("Cause of Absence";"Cause of Absence")
            {
                DataItemTableView = sorting(Code);
                column(ReportForNavId_5595; 5595)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    //Check Gender
                    case "Cause of Absence".Gender of
                      1,2: if Employee.Gender <> "Cause of Absence".Gender then
                              CurrReport.Skip;
                    end;
                    ClosePrevAbsence;
                    CreateCurrAbsence;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Employee.Status = Employee.Status::Terminated then begin
                  ClosePrevTermEmpAbsence;
                  CurrReport.Skip;
                end;

                if "Employment Date" = 0D then
                  Error(Text002,Employee."No.");
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text003,YearNo);
            end;

            trigger OnPreDataItem()
            begin
                if YearNo = 0 then
                  Error(Text001);
                Window.Open('Creating Absence Schedules');
                StartDate := Dmy2date(1,1,YearNo);
                PreviousDate := CalcDate('-1D',StartDate);
                PreviousYr := Date2dmy(PreviousDate,3);
                HRSetup.Get
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Year No";YearNo)
                {
                    ApplicationArea = Basic;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        CurAbsenceSchedule: Record "Leave Schedule Header";
        HRSetup: Record "Human Resources Setup";
        Absences: Record "Cause of Absence";
        EmployeeAbsence: Record "Employee Absence";
        GlobalEmployeeAbsence: Record "Employee Absence";
        LeaveApplication: Record "Leave Application";
        Allowance: Decimal;
        YearNo: Integer;
        Text001: label 'Leave year must be specified!';
        Text002: label 'Employment date for employee no. %1 is empty. Leave schedule creation stopped.';
        NextEntryNo: Integer;
        PreviousYr: Integer;
        Window: Dialog;
        Text003: label 'Absence Schedules created for %1';
        StartDate: Date;
        PreviousDate: Date;

    local procedure ClosePrevTermEmpAbsence()
    var
        PrevAbsenceSchedule: Record "Leave Schedule Header";
    begin
        PrevAbsenceSchedule.SetCurrentkey("Year No.","Employee No.");
        PrevAbsenceSchedule.SetFilter("Year No.",'<%1',YearNo);
        PrevAbsenceSchedule.SetRange("Employee No.",Employee."No.");
        if PrevAbsenceSchedule.FindSet then
          PrevAbsenceSchedule.ModifyAll(Closed,true);
    end;

    local procedure ClosePrevAbsence()
    var
        PrevAbsenceSchedule: Record "Leave Schedule Header";
    begin
        PrevAbsenceSchedule.SetCurrentkey("Year No.","Employee No.");
        PrevAbsenceSchedule.SetFilter("Year No.",'<%1',YearNo);
        PrevAbsenceSchedule.SetRange("Employee No.",Employee."No.");
        PrevAbsenceSchedule.SetRange("Absence Code","Cause of Absence".Code);
        if PrevAbsenceSchedule.FindLast then begin
          if PrevAbsenceSchedule.Closed <> true then begin
            PrevAbsenceSchedule.Closed := true;
            PrevAbsenceSchedule.Modify;
            if not("Cause of Absence"."Roll Over Absence") then
              ClearPrevBalance;
          end;
        end;
    end;

    local procedure ClearPrevBalance()
    var
        LeaveApplication: Record "Leave Application";
    begin
        Employee.SetRange("Cause of Absence Filter","Cause of Absence".Code);
        Employee.SetFilter("Date Filter",'..%1',PreviousDate);
        Employee.CalcFields("Total Absence (Base)");
        if Employee."Total Absence (Base)" <> 0 then begin
          LeaveApplication."Document No." := 'CLOSE'+ Format(PreviousDate);
          LeaveApplication."Employee No." := Employee."No.";
          LeaveApplication."Employee Name" := Employee.FullName;
          LeaveApplication."Employee Category" := Employee."Employee Category";
          LeaveApplication."From Date" := PreviousDate;
          LeaveApplication."Cause of Absence Code" := "Cause of Absence".Code;
          LeaveApplication."Year No." := PreviousYr;
          LeaveApplication."Entry Type" := LeaveApplication."entry type"::"Negative Adjustment";
          LeaveApplication."Opening/Closing Entry" := LeaveApplication."opening/closing entry"::Closing;
          LeaveApplication.Description := 'Previous Year ' + "Cause of Absence".Description + ' Closure';
          LeaveApplication.Validate("Unit of Measure Code","Cause of Absence"."Unit of Measure Code");
          LeaveApplication.Validate(Quantity,Employee."Total Absence (Base)");
          LeaveApplication.Insert;
          PostLeave(LeaveApplication);
        end;
    end;

    local procedure CreateCurrAbsence()
    var
        DaysEntitled: Decimal;
    begin
        CurAbsenceSchedule.Init;
        CurAbsenceSchedule."Year No." := YearNo;
        CurAbsenceSchedule."Employee No." := Employee."No.";
        CurAbsenceSchedule."Employee Name" := Employee.FullName;
        CurAbsenceSchedule."Manager No." := Employee."Manager No.";
        CurAbsenceSchedule."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
        CurAbsenceSchedule."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
        CurAbsenceSchedule."Absence Code" := "Cause of Absence".Code;
        CurAbsenceSchedule."Employment Date" := Employee."Employment Date";
        Employee.GetAbsenceParameter("Cause of Absence".Code,DaysEntitled,
        Allowance);

        if CurAbsenceSchedule.Insert then
          CreateOpeningLeaveEntry(DaysEntitled)
    end;

    local procedure CreateOpeningLeaveEntry(lDaysEntitled: Decimal)
    begin
        if lDaysEntitled <> 0 then begin
          LeaveApplication."Document No." := 'OPEN'+ Format(StartDate);
          LeaveApplication."Employee No." := Employee."No.";
          LeaveApplication."Employee Name" := Employee.FullName;
          LeaveApplication."Employee Category" := Employee."Employee Category";
          LeaveApplication."From Date" := StartDate;
          LeaveApplication."Cause of Absence Code" := "Cause of Absence".Code;
          LeaveApplication."Year No." := YearNo;
          LeaveApplication."Entry Type" := LeaveApplication."entry type"::"Positive Adjustment";
          LeaveApplication."Opening/Closing Entry" := LeaveApplication."opening/closing entry"::Opening;
          LeaveApplication.Description := "Cause of Absence".Description + ' Current Year Days';
          LeaveApplication.Validate("Unit of Measure Code","Cause of Absence"."Unit of Measure Code");
          LeaveApplication.Validate(Quantity,Abs(lDaysEntitled));
          LeaveApplication.Insert;
          PostLeave(LeaveApplication);
        end;
    end;

    local procedure PostLeave(var LeaveApplication: Record "Leave Application")
    begin
        EmployeeAbsence.Init;
        EmployeeAbsence.CopyFromLeaveApplication(LeaveApplication);
        GetNextEntryNo;
        EmployeeAbsence."Entry No." := NextEntryNo;
        EmployeeAbsence.Insert;
        LeaveApplication.Delete;
    end;


    procedure GetNextEntryNo()
    begin
        GlobalEmployeeAbsence.LockTable;
        if GlobalEmployeeAbsence.FindLast then
          NextEntryNo := GlobalEmployeeAbsence."Entry No." + 1
        else
          NextEntryNo := 1;
    end;
}

