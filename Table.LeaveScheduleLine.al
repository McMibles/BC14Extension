Table 52092193 "Leave Schedule Line"
{

    fields
    {
        field(1;"Year No.";Integer)
        {
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;"Manager No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(5;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(6;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(7;"Start Date";Date)
        {

            trigger OnValidate()
            begin
                CheckDate;
                if ("Start Date" <> xRec."Start Date") then begin
                  TestField("No. of Days Taken",0);
                  if "No. of Days Scheduled" <> 0 then
                    CalcEndDate;
                end;
            end;
        }
        field(8;"End Date";Date)
        {

            trigger OnValidate()
            begin
                // Checks proper order of starts and ends/recalls
                LeavePlanLine.Reset;
                LeavePlanLine.SetCurrentkey("Year No.","Employee No.","Absence Code","Line No.");
                LeavePlanLine.SetRange("Year No.","Year No.");
                LeavePlanLine.SetRange("Employee No.","Employee No.");
                LeavePlanLine.SetRange("Absence Code","Absence Code");
                LeavePlanLine.SetFilter("Line No.",'<>%1',"Line No.");
                LeavePlanLine.SetFilter("Start Date",'<=%1',"End Date");
                LeavePlanLine.SetFilter("End Date",'>=%1',"End Date");
                if LeavePlanLine.FindSet then
                  Error(Text005);
                if CurrFieldNo = FieldNo("End Date") then begin
                  TestField("Start Date");
                  Validate("No. of Days Scheduled" ,CalcNoofDays("Start Date","End Date"));
                end;
            end;
        }
        field(9;"No. of Days Scheduled";Decimal)
        {

            trigger OnValidate()
            begin
                TestField("No. of Days Taken",0);
                TestField("Start Date");
                if "No. of Days Scheduled" <> 0 then begin
                  "Outstanding No. of Days" := "No. of Days Scheduled" - "No. of Days Taken";
                  CheckAvailableDays;
                  if CurrFieldNo = FieldNo("No. of Days Scheduled" ) then
                    CalcEndDate;
                end else begin
                  "Outstanding No. of Days" := "No. of Days Scheduled" - "No. of Days Taken";
                  "End Date" := 0D;
                end;
            end;
        }
        field(10;"No. of Days Taken";Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                "Outstanding No. of Days" := "No. of Days Scheduled" - "No. of Days Taken";
            end;
        }
        field(11;"Outstanding No. of Days";Decimal)
        {
            Editable = false;
        }
        field(12;"Absence Code";Code[10])
        {
            TableRelation = "Cause of Absence";
        }
        field(13;"Recalled By";Code[50])
        {
        }
        field(14;"Recalled Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Year No.","Employee No.","Absence Code","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Start Date")
        {
        }
        key(Key3;"Year No.","Employee No.","Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatusOpen;
        if "No. of Days Taken" <> 0 then
          Error(Text014,"No. of Days Taken");
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
        EmployeeRec.Get("Employee No.");
        "Manager No." := EmployeeRec."Manager No.";
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
        if "No. of Days Taken" <> 0 then
          Error(Text014,"No. of Days Taken");
    end;

    trigger OnRename()
    begin
        TestStatusOpen;
    end;

    var
        LeavePlanLine: Record "Leave Schedule Line";
        Text001: label 'There is a schedule Line that has a start date later than this!\ Entry not allowed.';
        Text002: label 'Start Date is not a working Day!';
        PublicHoliday: Record "Public Holiday";
        LeaveHeader: Record "Leave Schedule Header";
        LeaveApplication: Record "Leave Application";
        EmployeeRec: Record Employee;
        HRSetup: Record "Human Resources Setup";
        CauseofAbsence: Record "Cause of Absence";
        DateFound: Boolean;
        Text003: label 'Start Date is a public Holdiday!';
        Text004: label 'There is a schedule line that has end date later than this!\ Entry not allowed.';
        Text005: label 'This action will lead to overlapping. The end date of this line will be greater than the start date of some lines. Adjust the lines appropriately';
        Text006: label 'You can only schedule for %1 day(s)';
        Text007: label 'The start date must be within %1';
        Text008: label 'The earliest period you can go on leave is %1\ Entry not allowed';
        Text009: label 'Leave Schedule not approved, application cannot be created';
        Text010: label 'This schedule have been exhausted, application cannot be created';
        Text011: label 'Fatal error, the year of the date entered is incorrect.';
        StatusCheckSuspended: Boolean;
        Window: Dialog;
        Text012: label 'Creating Leave Application';
        LeaveAppPage: Page "Leave Application Card -ESS";
        Text013: label 'Prior schedules not yet exhausted. Application not allowed.';
        Text014: label '%1 no. of days already applied for, changes cannot be made to the schedule';
        Text015: label 'Start  Date %1 cannnot be less than today %2';
        LeaveMgt: Codeunit LeaveManagement;
        Text016: label 'Leave Schedule must be open for this action to go through';
        Text017: label 'Nothing to recall';
        Text018: label 'This leave has been utilised, recall not allowed';
        Text020: label 'Recall Completed';
        ApprovalMgt: Codeunit "Approvals Mgmt.";


    procedure CheckDate()
    var
        LeaveStartDate: Date;
        nMonths: Decimal;
    begin
        GetLeaveHeader;
        // Check for Start Year
        if Date2dmy("Start Date",3) <> "Year No." then
          Error(Text011);
        if ("Start Date") < Today then
          Error(Text015,"Start Date",Today);
        
        // Checks proper order of starts and ends/recalls
        LeavePlanLine.Reset;
        LeavePlanLine.SetCurrentkey("Year No.","Employee No.","Absence Code","Line No.");
        LeavePlanLine.SetRange("Year No.","Year No.");
        LeavePlanLine.SetRange("Employee No.","Employee No.");
        LeavePlanLine.SetRange("Absence Code","Absence Code");
        LeavePlanLine.SetFilter("Line No.",'<>%1',"Line No.");
        LeavePlanLine.SetFilter("Start Date",'>=%1',"Start Date");
        if LeavePlanLine.FindSet then
         Error(Text001);
        
        LeavePlanLine.SetRange("Start Date");
        LeavePlanLine.SetFilter("End Date",'>=%1',"Start Date");
        if LeavePlanLine.FindSet then
          Error(Text004);
        
        
        //Check for weekends
        CauseofAbsence.Get("Absence Code");
        if CauseofAbsence."Days Calculation Basis" = CauseofAbsence."days calculation basis"::"Working Days" then
          if LeaveMgt.DateIsWeekend("Start Date") then
            Error(Text002);
        
        //Check for year
        if Date2dmy("Start Date",3) <> "Year No." then
          Error(Text007,"Year No.");
        
        // Check for public holidays
        if CauseofAbsence."Allow Pub. Holiday"  then
          if LeaveMgt.DateIsPublicHoliday("Start Date") then
            Error(Text003);
        
        //Check for new employees starting date
        nMonths := ROUND(((Date2dmy(WorkDate,3) - Date2dmy(LeaveHeader."Employment Date",3)) * 365 +
                    (Date2dmy(WorkDate,2) - Date2dmy(LeaveHeader."Employment Date",2))* 30.41 +
                    (Date2dmy(WorkDate,1) - Date2dmy(LeaveHeader."Employment Date",1)))/30.41,0.00001);
        
        /*IF nMonths < 12 THEN BEGIN
          LeaveStartDate := 0D;
          LeaveHeader.TESTFIELD("Employment Date");
          LeaveStartDate := CALCDATE('6M',LeaveHeader."Employment Date");
          IF "Start Date" < LeaveStartDate THEN
            ERROR(Text008,LeaveStartDate);
        END;*/

    end;


    procedure CalcEndDate()
    var
        Counter: Integer;
        Holder1: Integer;
        Holder2: Integer;
        EndDate: Date;
    begin
        TestField("Start Date");
        Counter:= 0;
        EndDate:= "Start Date";
        repeat
          Counter:= Counter + 1;
          LeaveMgt.ConsiderWeekend("Absence Code",EndDate);
          LeaveMgt.ConsiderPublicHoliday("Absence Code",EndDate);
          EndDate := CalcDate('1D',EndDate);
          LeaveMgt.ConsiderWeekend("Absence Code",EndDate);
          LeaveMgt.ConsiderPublicHoliday("Absence Code",EndDate);
        until Counter = "No. of Days Scheduled";

        Validate("End Date",CalcDate('-1D',EndDate));
    end;


    procedure GetLeaveHeader()
    begin
        LeaveHeader.Get("Year No.", "Employee No.","Absence Code");
    end;


    procedure CheckAvailableDays()
    var
        ScheduledDays: Integer;
        AvailableDays: Integer;
    begin
        ScheduledDays := 0;
        AvailableDays := 0;
        GetLeaveHeader;
        LeaveHeader.CalcFields(Balance);
        LeavePlanLine.Reset;
        LeavePlanLine.SetCurrentkey("Year No.","Employee No.","Absence Code","Line No.");
        LeavePlanLine.SetRange("Year No.","Year No.");
        LeavePlanLine.SetRange("Employee No.","Employee No.");
        LeavePlanLine.SetRange("Absence Code","Absence Code");
        LeavePlanLine.SetFilter("Line No.",'<>%1',"Line No.");
        if LeavePlanLine.FindSet then
          repeat
            ScheduledDays := ScheduledDays + LeavePlanLine."No. of Days Scheduled";
          until LeavePlanLine.Next = 0;

        AvailableDays := LeaveHeader.Balance - ScheduledDays;

        if AvailableDays < "No. of Days Scheduled" then
          Error(Text006,AvailableDays)
    end;


    procedure CreateLeaveApplication()
    begin
        GetLeaveHeader;
        HRSetup.Get;
        if LeaveHeader.Status <> LeaveHeader.Status::Approved then
          Error(Text009);
        if "Outstanding No. of Days" = 0 then
          Error(Text010);

        //Ensure that the application is done according to the schedule
        LeavePlanLine.Reset;
        LeavePlanLine.SetCurrentkey("Start Date");
        LeavePlanLine.SetRange("Year No.","Year No.");
        LeavePlanLine.SetRange("Employee No.","Employee No.");
        LeavePlanLine.SetRange("Absence Code","Absence Code");
        LeavePlanLine.SetFilter("Start Date",'<%1',"Start Date");
        LeavePlanLine.SetFilter("Outstanding No. of Days",'<>%1',0);
        if LeavePlanLine.FindFirst then
         Error( Text013);



        Window.Open(Text012);

        //Create Leave application
        LeaveApplication.Init;
        LeaveApplication.Validate("Employee No.","Employee No.");
        LeaveApplication."From Date" := "Start Date";
        LeaveApplication."To Date"  := "End Date";
        LeaveApplication."Cause of Absence Code" := LeaveHeader."Absence Code";
        LeaveApplication.Description := 'ANNUAL LEAVE APPLICATION';
        LeaveApplication.Quantity  := "Outstanding No. of Days";
        LeaveApplication."Unit of Measure Code"  := HRSetup."Base Unit of Measure";
        LeaveApplication."Quantity (Base)" := "Outstanding No. of Days";
        LeaveApplication."Qty. per Unit of Measure" := 1;
        LeaveApplication."Application Date" := Today;
        LeaveApplication."Schedule Line No." := "Line No.";
        LeaveApplication."Year No."  := "Year No.";
        LeaveApplication."Manager No." := "Manager No.";
        LeaveApplication."Global Dimension 1 Code" := "Global Dimension 1 Code";
        LeaveApplication."Global Dimension 2 Code" := "Global Dimension 2 Code" ;
        LeaveApplication.CalcReturnDate;
        LeaveApplication.Insert(true);

        Validate("No. of Days Taken","Outstanding No. of Days");
        Modify;
        Window.Close;

        //Open Application Page
        Clear(LeaveAppPage);
        LeaveApplication.SetRecfilter;
        LeaveAppPage.SetTableview(LeaveApplication);
        LeaveAppPage.Run;
    end;


    procedure RecallLeaveApplication()
    begin
        GetLeaveHeader;
        HRSetup.Get;

        if LeaveHeader.Status <> LeaveHeader.Status::Open then
          Error(Text016);

        if "Outstanding No. of Days" <> 0 then
          Error(Text017);

        //Delete the employee absence
        LeaveApplication.SetRange("Employee No.","Employee No.");
        LeaveApplication.SetRange("Year No.","Year No.");
        LeaveApplication.SetRange("Schedule Line No.","Line No.");
        LeaveApplication.SetRange("Cause of Absence Code",HRSetup."Annual Leave Code");
        if (LeaveApplication.FindFirst) and (LeaveApplication.Status = LeaveApplication.Status::Approved) then
          Error(Text018);
        ApprovalMgt.DeleteApprovalEntries(LeaveApplication.RecordId);
        LeaveApplication.DeleteAll;

        //Reset Line
        "No. of Days Taken" := 0;
        "Outstanding No. of Days" := "No. of Days Scheduled";
        "Recalled By" := UserId;
        "Recalled Date" := WorkDate;
        Modify;
        Message(Text020);
    end;


    procedure CalcNoofDays(FromDate: Date;ToDate: Date): Decimal
    var
        NoofDays: Decimal;
        NoofDaysDiff: Decimal;
        Counter: Integer;
        Holder1: Integer;
        NextDate: Date;
        NotWeekEnd: Boolean;
        NotPublicHoliday: Boolean;
    begin
        TestField("Start Date");
        NoofDaysDiff := (ToDate - FromDate) + 1;
        Counter:= 0;
        NextDate:= FromDate;
        repeat

          //Check Weekends
          CauseofAbsence.Get("Absence Code");
          case CauseofAbsence."Days Calculation Basis" of
           CauseofAbsence."days calculation basis"::"Working Days":
             begin
               Holder1 := Date2dwy(NextDate,1);
               if not (Holder1 in[6,7]) then
                 NotWeekEnd := true
               else
                 NotWeekEnd := false;
             end;
          end;

          //Check Public Holiday
          if CauseofAbsence."Allow Pub. Holiday" then begin
            PublicHoliday.Reset;
            PublicHoliday.SetCurrentkey(Date);
            PublicHoliday.SetFilter(Date,'<=%1',NextDate);
            DateFound := false;
            NotPublicHoliday := true;
            if PublicHoliday.Find('+') then
              repeat
                if (NextDate >= PublicHoliday."Start Date") and (NextDate <=PublicHoliday."End Date") then begin
                  DateFound:= true;
                  NotPublicHoliday := false;
                end;
              until (PublicHoliday.Next(-1) =0) or DateFound;

            Counter := Counter + 1;

            //Exclude Public Holiday and Weekends
            if  (NotWeekEnd) and (NotPublicHoliday) then
              NoofDays := NoofDays + 1;

            NextDate := CalcDate('1D',NextDate);
          end;
        until Counter = NoofDaysDiff;

        exit(NoofDays);
    end;


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
          exit;
        GetLeaveHeader;
        LeaveHeader.TestField(Status,LeaveHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(var Suspend: Boolean): Boolean
    begin
        StatusCheckSuspended := Suspend;
    end;
}

