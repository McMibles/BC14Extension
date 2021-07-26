Codeunit 52092186 LeaveManagement
{
    Permissions = TableData "Payroll-Payslip Header"=r,
                  TableData "Payroll-Employee Group Header"=r,
                  TableData "Payroll-Employee Group Line"=r,
                  TableData "Payroll-Posting Group Header"=r,
                  TableData "Payroll-Posting Group Line"=r,
                  TableData "Payroll-Setup"=r,
                  TableData "Payroll-Employee"=r,
                  TableData "Payment Header"=rim,
                  TableData "Payment Line"=rim;

    trigger OnRun()
    begin
    end;

    var
        HRSetup: Record "Human Resources Setup";
        PublicHoliday: Record "Public Holiday";
        LeaveScheduleLine: Record "Leave Schedule Line";
        CauseofAbsence: Record "Cause of Absence";
        UserSetup: Record "User Setup";
        PayMgtSetup: Record "Payment Mgt. Setup";
        GlobalEmployeeAbsence: Record "Employee Absence";
        NextEntryNo: Integer;
        GlobalSender: Text[80];
        Body: Text[200];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
        i: Integer;
        LeaveVouchAlert: label 'This is to notify you of the leave voucher %1 awaiting your processing.';
        Text014: label 'Leave allowance for %1';


    procedure RecalulateLeave(YearNo: Integer)
    var
        EmployeeAbsence: Record "Employee Absence";
        EndDate: Date;
        Counter: Integer;
        DateFound: Boolean;
    begin
        /*HRSetup.GET;
        EmployeeAbsence.LOCKTABLE;
        EmployeeAbsence.SETRANGE("Year No.",YearNo);
        EmployeeAbsence.SETRANGE("Entry Type",EmployeeAbsence."Entry Type"::Application);
        IF EmployeeAbsence.FINDFIRST THEN BEGIN
          REPEAT
            Counter := 0;
            EndDate := EmployeeAbsence."From Date";
            FOR i := 1 TO EmployeeAbsence."Quantity (Base)" DO BEGIN
              DateFound := FALSE;
              PublicHoliday.SETCURRENTKEY(Date);
              PublicHoliday.SETFILTER(Date,'<=%1',EndDate);
              IF PublicHoliday.FIND('+') THEN
                REPEAT
                  IF (EndDate >= PublicHoliday."Start Date") AND (EndDate <= PublicHoliday."End Date") THEN BEGIN
                    Counter := Counter + 1 ;
                    DateFound := TRUE;
                    //Create Public Holiday and Absence Relation
                    WITH EmployeeAbsence DO BEGIN
                      IF NOT(PubHolAbsenceRelation.GET(PublicHoliday.Code,"Cause of Absence Code","Year No.","Employee No."))
                        THEN BEGIN
                          PubHolAbsenceRelation.INIT;
                          PubHolAbsenceRelation."Public Holiday Code" := PublicHoliday.Code;
                          PubHolAbsenceRelation."Cause of Absence Code" := "Cause of Absence Code";
                          PubHolAbsenceRelation."Year No." := "Year No." ;
                          PubHolAbsenceRelation."Employee No." := "Employee No." ;
                          PubHolAbsenceRelation."Document No." := "Entry No.";
                          CASE Status OF
                            0,1: PubHolAbsenceRelation.Type := 0;
                            2: PubHolAbsenceRelation.Type := 1;
                          END;
                          PubHolAbsenceRelation.Value := 1;
                          PubHolAbsenceRelation.INSERT;
                      END ELSE BEGIN
                        PubHolAbsenceRelation.Value := PubHolAbsenceRelation.Value + 1;
                        PubHolAbsenceRelation.MODIFY;
                      END;
                    END;
                  END;
                UNTIL (PublicHoliday.NEXT(-1) =0) OR DateFound;
              EndDate := CALCDATE('1D',EndDate)
            END;
            IF Counter <> 0 THEN BEGIN
              CASE EmployeeAbsence.Status OF
                0,1:BEGIN
                      EmployeeAbsence.Quantity := EmployeeAbsence.Quantity - Counter;
                      EmployeeAbsence."Quantity (Base)" := EmployeeAbsence."Quantity (Base)" - Counter ;
                      EmployeeAbsence.MODIFY;
                      IF EmployeeAbsence."Schedule Line No." <> 0 THEN BEGIN
                        LeaveScheduleLine.GET(EmployeeAbsence."Year No.",EmployeeAbsence."Employee No.",
                          EmployeeAbsence."Schedule Line No.");
                        LeaveScheduleLine."No. of Days Scheduled" := EmployeeAbsence.Quantity;
                        LeaveScheduleLine."Outstanding No. of Days" := LeaveScheduleLine."No. of Days Scheduled";
                        LeaveScheduleLine.MODIFY;
                      END;
                END;
              END;
            END;
          UNTIL EmployeeAbsence.NEXT = 0;
        END;
        
        LeaveScheduleLine.LOCKTABLE;
        LeaveScheduleLine.SETRANGE("Year No.");
        LeaveScheduleLine.SETFILTER("No. of Days Taken",'%1',0);
        IF LeaveScheduleLine.FINDFIRST THEN BEGIN
          REPEAT
            Counter := 0;
            EndDate := LeaveScheduleLine."Start Date";
            FOR i := 1 TO LeaveScheduleLine."No. of Days Scheduled" DO BEGIN
              DateFound := FALSE ;
              PublicHoliday.SETCURRENTKEY(Date);
              PublicHoliday.SETFILTER(Date,'<=%1',EndDate);
              IF PublicHoliday.FIND('+') THEN
                REPEAT
                  IF (EndDate >= PublicHoliday."Start Date") AND (EndDate <= PublicHoliday."End Date") THEN BEGIN
                    Counter := Counter + 1 ;
                    DateFound := TRUE;
                    //Create Public Holiday and Absence Relation
                    WITH LeaveScheduleLine DO BEGIN
                      IF NOT(PubHolAbsenceRelation.GET(PublicHoliday.Code,HRSetup."Annual Leave Code","Year No.","Employee No."))
                        THEN BEGIN
                          PubHolAbsenceRelation.INIT;
                          PubHolAbsenceRelation."Public Holiday Code" := PublicHoliday.Code;
                          PubHolAbsenceRelation."Cause of Absence Code" := HRSetup."Annual Leave Code";
                          PubHolAbsenceRelation."Year No." := "Year No." ;
                          PubHolAbsenceRelation."Employee No." := "Employee No." ;
                          PubHolAbsenceRelation."Document No." := '';
                          PubHolAbsenceRelation.Type := 0 ;
                          PubHolAbsenceRelation.Value := 1;
                          PubHolAbsenceRelation."Line No." := "Line No.";
                          PubHolAbsenceRelation.INSERT;
                      END ELSE BEGIN
                        PubHolAbsenceRelation.Value := PubHolAbsenceRelation.Value + 1;
                        PubHolAbsenceRelation.MODIFY;
                      END;
                    END;
                  END;
                UNTIL (PublicHoliday.NEXT(-1) =0) OR DateFound;
              EndDate := CALCDATE('1D',EndDate);
            END;
            IF Counter <> 0 THEN BEGIN
              LeaveScheduleLine."No. of Days Scheduled" := LeaveScheduleLine."No. of Days Scheduled"  - Counter;
              LeaveScheduleLine."Outstanding No. of Days" :=  LeaveScheduleLine."No. of Days Scheduled";
              LeaveScheduleLine.MODIFY;
            END;
          UNTIL LeaveScheduleLine.NEXT = 0;
        END; */

    end;


    procedure CreateLeaveAllwVoucher(var LeaveApplication: Record "Leave Application")
    var
        PayrollEmployee: Record "Payroll-Employee";
        PayrollGroupHeader: Record "Payroll-Employee Group Header";
        PostingGroupLine: Record "Payroll-Posting Group Line";
        PayrollSetup: Record "Payroll-Setup";
        Employee: Record Employee;
        EmployeeBankAccount: Record "Employee Bank Account";
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
        SalaryGroup: Code[20];
        PayrollMgt: Codeunit "Payroll-Management";
    begin
        PayrollSetup.Get;
        PayrollSetup.TestField("Leave Accrual ED Code");
        LeaveApplication.TestField(Status,LeaveApplication.Status::Approved);
        Employee.Get(LeaveApplication."Employee No.");
        Employee.GetEmployeeBankAccount(EmployeeBankAccount);
        PayrollMgt.GetSalaryGroup(LeaveApplication."Employee No.",WorkDate,SalaryGroup);
        PayrollGroupHeader.Get(SalaryGroup);
        PayrollEmployee.Get(LeaveApplication."Employee No.");
        PayrollEmployee.TestField("Posting Group");
        PostingGroupLine.Get(PayrollEmployee."Posting Group",PayrollSetup."Leave Accrual ED Code");
        PostingGroupLine.TestField("Credit Acc. Type",PostingGroupLine."credit acc. type"::"G/l Account");
        PostingGroupLine.TestField("Credit Account No.");

        PaymentHeader.Init;
        PaymentHeader."No." := '';
        PaymentHeader."Posting Description" := StrSubstNo(Text014,1,StrLen(PaymentHeader."Posting Description"),Employee.FullName);
        PaymentHeader."System Created Entry" := true;
        PaymentHeader."Document Type" := PaymentHeader."document type"::"Payment Voucher";
        PaymentHeader."Payment Type" := PaymentHeader."payment type"::Others;
        PaymentHeader."Bal. Account No." := '';
        PaymentHeader."Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
        PaymentHeader."Shortcut Dimension 2 Code" := Employee."Global Dimension 2 Code";
        PaymentHeader."Payment Method" := PaymentHeader."payment method"::"E-Payment";
        PaymentHeader."Payee No." := Employee."No.";
        PaymentHeader.Payee:= CopyStr(Employee.FullName,1,MaxStrLen(PaymentHeader.Payee));
        PaymentHeader."Payee Bank Account No." := EmployeeBankAccount."Bank Account No.";
        PaymentHeader."Payee Bank Code" := EmployeeBankAccount.Code;
        PaymentHeader."Payee Bank Account Name" := EmployeeBankAccount."Bank Account Name";
        PaymentHeader."Payee CBN Bank Code" := EmployeeBankAccount."CBN Bank Code";
        PaymentHeader.Validate("Currency Code",PayrollGroupHeader."Currency Code");
        PaymentHeader."Source Type" := PaymentHeader."source type"::Leave;
        PaymentHeader."Source No." :=  LeaveApplication."Document No.";
        PaymentHeader.Insert(true);
        PaymentHeader.CreateDim(Database::Employee,Employee."No.");
        PaymentHeader.Modify;

        PaymentLine.Init;
        PaymentLine."Document No." := PaymentHeader."No.";
        PaymentLine."Document Type" := PaymentHeader."Document Type";
        PaymentLine."Line No." := 10000;
        PaymentLine.Validate("Account No.",PostingGroupLine."Credit Account No.");
        PaymentLine.Validate(Amount,LeaveApplication."Leave Amount to Pay");
        PaymentLine.Description := CopyStr(StrSubstNo(Text014,Employee.FullName),1,MaxStrLen(PaymentLine.Description));
        PaymentLine.Insert(true);

        PayMgtSetup.Get;
        if PayMgtSetup."Leave Vouch. Alert E-mail" <> '' then
          begin
            UserSetup.Get(UserId);
            UserSetup.TestField("E-Mail");
            UserSetup.TestField("Employee No.");
            Employee.Get(UserSetup."Employee No.");
            GlobalSender := Employee."First Name" + '' + Employee."Last Name";
            Body := StrSubstNo(LeaveVouchAlert,PaymentHeader."No.");
            Subject := 'ALERT FOR LEAVE VOUCHER CREATED';
            SMTP.CreateMessage(GlobalSender,UserSetup."E-Mail",PayMgtSetup."Leave Vouch. Alert E-mail"  ,Subject,Body,false);
            SMTP.Send;
          end;
    end;


    procedure ConsiderWeekend(LeaveCode: Code[20];var RefDate: Date)
    var
        WeekDay: Integer;
    begin
        CauseofAbsence.Get(LeaveCode);
        case CauseofAbsence."Days Calculation Basis" of
          CauseofAbsence."days calculation basis"::"Working Days":
            begin
              WeekDay := Date2dwy(RefDate,1);
              case WeekDay of
                6: RefDate :=CalcDate('2D', RefDate);
                7: RefDate:=CalcDate('1D', RefDate);
              end;
            end;
        end;
    end;


    procedure ConsiderPublicHoliday(LeaveCode: Code[20];var RefDate: Date)
    var
        DateFound: Boolean;
    begin
        CauseofAbsence.Get(LeaveCode);
        if (CauseofAbsence."Allow Pub. Holiday") then begin
          PublicHoliday.Reset;
          PublicHoliday.SetCurrentkey(Date);
          PublicHoliday.SetFilter(Date,'<=%1',RefDate);
          DateFound := false;
          if PublicHoliday.Find('+') then
            repeat
              if (RefDate >= PublicHoliday."Start Date") and (RefDate <= PublicHoliday."End Date") then
                DateFound:= true;
              if DateFound then begin
                RefDate :=CalcDate(PublicHoliday.Duration,RefDate);
                ConsiderWeekend(LeaveCode,RefDate);
              end;
            until (PublicHoliday.Next(-1) =0) or DateFound;
        end;
    end;


    procedure DateIsWeekend(var RefDate: Date): Boolean
    begin
        if Date2dwy(RefDate,1) > 5 then
          exit(true)
        else
          exit(false);
    end;


    procedure DateIsPublicHoliday(var RefDate: Date): Boolean
    var
        DateFound: Boolean;
    begin
        PublicHoliday.SetCurrentkey(Date);
        PublicHoliday.SetFilter(Date,'<=%1',RefDate);
        DateFound := false;
        if  PublicHoliday.Find('+') then
          repeat
            if (RefDate >= PublicHoliday."Start Date") and (RefDate <= PublicHoliday."End Date") then
              DateFound := true;
          until (PublicHoliday.Next(-1) = 0) or DateFound;
        exit(DateFound);
    end;


    procedure PostLeave(var LeaveApplication: Record "Leave Application")
    var
        EmployeeAbsence: Record "Employee Absence";
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

