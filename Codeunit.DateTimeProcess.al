Codeunit 52092310 "Date Time Process"
{
    /*
        trigger OnRun()
        begin
        end;

        var
            ScheduleRec: Record Schedule;
            AttendanceRegister: Record "Attendance Register";
            EntryNo: Integer;
            DefaultTime: Time;


        procedure DateTimeInsert(Date1: Date;Date2: Date;Time1: Time;Time2: Time;EmployeeRec: Record Employee;SchedCode: Code[20];TerminalId1: Code[20];TerminalId2: Code[20])
        begin
            AttendanceRegister.Reset;
            if AttendanceRegister.Find('+') or not AttendanceRegister.Find then begin
              EntryNo := AttendanceRegister."Entry No.";
              AttendanceRegister.Init;
              AttendanceRegister."Entry No." := EntryNo + 1;
              AttendanceRegister.Validate("Employee No.",EmployeeRec."No.");
              AttendanceRegister.Validate("Date In",Date1);
              AttendanceRegister."In-Terminal ID" := TerminalId1;
              AttendanceRegister."Out-Terminal ID" := TerminalId2;
              ScheduleRec.Get(SchedCode);
              if Time1 = DefaultTime then begin
                if ScheduleRec."Auto Clock In" then begin
                  AttendanceRegister."Clock Out Option" := 0;
                  AttendanceRegister."Entry Type" := 0;
                  AttendanceRegister."Time In" := ScheduleRec."Start Time";
                end;
              end else begin
                AttendanceRegister."Clock Out Option" := 1;
                AttendanceRegister."Entry Type" := 0;
                AttendanceRegister."Time In" := Time1;
              end;
              AttendanceRegister."Employee Card ID" := EmployeeRec."TnA ID";
              AttendanceRegister.Status := 2;
              AttendanceRegister."Schedule Code" := SchedCode;
              AttendanceRegister."Date Out":= Date2;
              if Time2 = DefaultTime then begin
                if ScheduleRec."Auto Clock Out" then begin
                  AttendanceRegister."Clock Out Option" := 0;
                  AttendanceRegister."Entry Type" := 0;
                  AttendanceRegister.Validate("Time Out",ScheduleRec."Expected End Time");
                end;
              end else begin
                AttendanceRegister."Clock Out Option" := 1;
                AttendanceRegister."Entry Type" := 0;
                AttendanceRegister.Validate("Time Out",Time2);
              end;
              AttendanceRegister.Close := true;
              AttendanceRegister.Insert;
            end;
        end;


        procedure DateTimeInsert2(Date1: Date;Time1: Time;EmployeeRec: Record Employee;var Counter: Integer;SchedCode: Code[20];TerminalId1: Code[20])
        begin
            AttendanceRegister.Reset;
            if AttendanceRegister.Find('+') or not AttendanceRegister.Find then begin
              EntryNo := AttendanceRegister."Entry No.";
              AttendanceRegister.Init;
              AttendanceRegister."Entry No." := EntryNo + 1;
              AttendanceRegister.Validate("Employee No.",EmployeeRec."No.");
              AttendanceRegister."Schedule Code" := SchedCode;
              AttendanceRegister."Employee Card ID" := EmployeeRec."TnA ID";
              ScheduleRec.Get(SchedCode);
              if Time1 >= ScheduleRec."Expected End Time" then begin
                AttendanceRegister.Status := 1;
                AttendanceRegister.Validate("Date Out",Date1);
                AttendanceRegister."Time Out" := Time1;
                if ScheduleRec."Auto Clock In" then begin
                  AttendanceRegister.Validate("Date In",Date1);
                  AttendanceRegister."Time In" := ScheduleRec."Start Time";
                end;
              end else begin
                AttendanceRegister.Status := 0;
                AttendanceRegister.Validate("Date In",Date1);
                AttendanceRegister."Time In" := Time1;
                AttendanceRegister."Awaiting Out" := true;
                if ScheduleRec."Auto Clock Out" then begin
                  AttendanceRegister.Validate("Date Out",Date1);
                  AttendanceRegister."Time Out" := ScheduleRec."Expected End Time";
                  AttendanceRegister."Clock Out Option" := 0;
                end;
              end;
              AttendanceRegister.Void := true;
              AttendanceRegister."In-Terminal ID" := TerminalId1;
              AttendanceRegister.Insert;
            end;
        end;


        procedure DateTimeInsert3(Date1: Date;Date2: Date;EmployeeRec: Record Employee;SchedCode: Code[20];TerminalId1: Code[20];TerminalId2: Code[20])
        begin
            AttendanceRegister.Reset;
            if AttendanceRegister.Find('+') or not AttendanceRegister.Find then begin
              EntryNo := AttendanceRegister."Entry No.";
              AttendanceRegister.Init;
              AttendanceRegister."Entry No." := EntryNo + 1;
              AttendanceRegister.Validate("Employee No.",EmployeeRec."No.");
              AttendanceRegister.Validate("Date In",Date1);
              AttendanceRegister."Employee Card ID" := EmployeeRec."TnA ID";
              AttendanceRegister.Status := 2;
              AttendanceRegister."Attendance Status" := 1;
              AttendanceRegister."Schedule Code" := SchedCode;
              AttendanceRegister."In-Terminal ID" := TerminalId1;
              AttendanceRegister."Out-Terminal ID" := TerminalId2;
              AttendanceRegister."Date Out" := Date2;
              AttendanceRegister."Clock Out Option" := 1;
              AttendanceRegister.Close := true;
              AttendanceRegister.Insert;
            end;
        end;
    */
}

