Table 52092195 "Leave Application"
{
    Caption = 'Leave Application';
    DataCaptionFields = "Employee No.";
    DrillDownPageID = "Leave Application List";
    LookupPageID = "Leave Application List";
    Permissions = TableData "Payroll-Period"=r,
                  TableData "Payroll-Employee Group Header"=r,
                  TableData "Payroll-Posting Group Line"=r,
                  TableData "Payroll-Setup"=r,
                  TableData "Payroll-Employee"=r,
                  TableData "Closed Payroll-Payslip Header"=r,
                  TableData "Closed Payroll-Payslip Line"=r;

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Employee No.";Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                Employee.Get("Employee No.");
                "Manager No." := Employee."Manager No.";
                "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                "Global Dimension 2 Code" := Employee."Global Dimension 2 Code" ;
                "Employee Name" := Employee.FullName;
                "Employee Category" := Employee."Employee Category";
            end;
        }
        field(3;"From Date";Date)
        {
            Caption = 'From Date';

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                HumanResSetup.Get;
                if CurrFieldNo = FieldNo("From Date") then begin
                  if ApplicationRestrictionExist then
                    Error(Text006,Description);
                end;

                "Year No." := Date2dmy("From Date",3);
                if "Entry Type" = "entry type"::Application then
                  if IsClosedSchedule then
                    Error(Text014);

                if "From Date" <> 0D then begin
                  if "Days Calculation Basis" = "days calculation basis"::"Working Days" then
                    if LeaveMgt.DateIsWeekend("From Date") then
                      Error(Text001);
                  if "Allow Public Holiday" then begin
                    if LeaveMgt.DateIsPublicHoliday("From Date") then
                      Error(Text002);
                  end;
                  if Quantity <> 0 then
                    Validate(Quantity);
                end
            end;
        }
        field(4;"To Date";Date)
        {
            Caption = 'To Date';
        }
        field(5;"Cause of Absence Code";Code[10])
        {
            Caption = 'Cause of Absence Code';
            TableRelation = "Cause of Absence";

            trigger OnValidate()
            var
                AnnualLeave: Record "Cause of Absence";
            begin
                TestField(Status,Status::Open);
                HumanResSetup.Get;
                CauseOfAbsence.Get("Cause of Absence Code");
                if "Entry Type" = "entry type"::Application then begin
                  if CurrFieldNo = FieldNo("Cause of Absence Code") then begin
                    if ApplicationRestrictionExist then
                      Error(Text006,CauseOfAbsence.Description);
                  end;
                  CheckExistingApplication;

                  if CauseOfAbsence."Block if Annual Leave Exist" then begin
                    AnnualLeave.Get(HumanResSetup."Annual Leave Code");
                    if AnnualLeave.GetAvailableDays("Year No.","Employee No.") > 0 then
                      Error(Text015,CauseOfAbsence.Description);
                  end;
                end;

                CauseOfAbsence.Get("Cause of Absence Code");
                if "Entry Type" in[1,2] then
                  if IsClosedSchedule then
                    Error(Text014);
                Description := CauseOfAbsence.Description;
                Validate("Unit of Measure Code",CauseOfAbsence."Unit of Measure Code");
                "Allow Public Holiday" := CauseOfAbsence."Allow Pub. Holiday" ;
                "Days Calculation Basis" := CauseOfAbsence."Days Calculation Basis";
            end;
        }
        field(6;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(7;Quantity;Decimal)
        {
            Caption = 'No. of Days';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            var
                Counter: Decimal;
                Holder1: Integer;
                Holder2: Integer;
                ToDate: Date;
            begin
                if "Entry Type" in[0,2] then begin
                  TestField("Cause of Absence Code");
                  CauseOfAbsence.Get("Cause of Absence Code");
                  AvailableNoOfDays :=  CauseOfAbsence.GetAvailableDays("Year No.","Employee No.");
                  "Quantity (Base)" := CalcBaseQty(Quantity);

                  case "Entry Type" of
                    "entry type"::Application:
                      begin
                        if (CurrFieldNo = FieldNo(Quantity)) then begin
                          if ApplicationRestrictionExist then
                            Error(Text006,Description);
                        end;

                        if Quantity <> 0 then begin
                          TestField("From Date");
                          if "Quantity (Base)" > AvailableNoOfDays then
                            Error(Text007,AvailableNoOfDays);

                          Counter:= 0;
                          ToDate:= "From Date";
                          repeat
                            Counter:= Counter + 1;
                            LeaveMgt.ConsiderWeekend("Cause of Absence Code",ToDate);
                            LeaveMgt.ConsiderPublicHoliday("Cause of Absence Code",ToDate);
                            ToDate := CalcDate('1D',ToDate);
                            LeaveMgt.ConsiderWeekend("Cause of Absence Code",ToDate);
                            LeaveMgt.ConsiderPublicHoliday("Cause of Absence Code",ToDate);
                          until Counter = Quantity;
                        end;
                        "Resumption Date" := ToDate;
                        if ToDate <> 0D then
                          "To Date" := CalcDate('-1D',ToDate);
                        //CalcReturnDate;
                      end;
                    "entry type"::"Negative Adjustment":
                      begin
                        //Check Availabilty
                        if Quantity <> 0 then begin
                          if "Quantity (Base)" > AvailableNoOfDays then
                            Error(NegativeBalErr);
                        end;
                      end;
                  end;
                end else
                  "Quantity (Base)" := CalcBaseQty(Quantity)
            end;
        }
        field(8;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Human Resource Unit of Measure";

            trigger OnValidate()
            begin
                HumanResUnitOfMeasure.Get("Unit of Measure Code");
                "Qty. per Unit of Measure" := HumanResUnitOfMeasure."Qty. per Unit of Measure";
                Validate(Quantity);
            end;
        }
        field(11;Comment;Boolean)
        {
            Caption = 'Comment';
            Editable = false;
        }
        field(12;"Quantity (Base)";Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure",1);
                Validate(Quantity,"Quantity (Base)");
            end;
        }
        field(13;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            Editable = false;
            InitValue = 1;
        }
        field(30;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";

            trigger OnValidate()
            begin
                if "Entry Type" = "entry type"::Application then begin
                  if Status = Status::Approved then
                    SendNotification;
                end;
            end;
        }
        field(31;"Application Date";Date)
        {
        }
        field(32;"Schedule Line No.";Integer)
        {
        }
        field(33;"Year No.";Integer)
        {

            trigger OnValidate()
            begin
                if "Entry Type" in[1,2] then
                  if IsClosedSchedule then
                    Error(Text014);
            end;
        }
        field(34;"Manager No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(35;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(36;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(37;"Relief No.";Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Employee No." = "Relief No." then
                  Error(Text012);
            end;
        }
        field(38;"No. Series";Code[10])
        {
        }
        field(39;"Process Allowance Payment";Boolean)
        {

            trigger OnValidate()
            begin
                if "Process Allowance Payment" then begin
                  HumanResSetup.Get;
                  HumanResSetup.TestField("Annual Leave Code");
                
                  if "Process Allowance Payment" then begin
                    if HumanResSetup."Annual Leave Code" <> "Cause of Absence Code" then
                      Error(Text003);
                    if HumanResSetup."Min. Day(s) for Leave Allow." <> 0 then
                      if HumanResSetup."Min. Day(s) for Leave Allow." > Quantity then
                        Error(Text004,HumanResSetup."Min. Day(s) for Leave Allow." );
                
                    if HumanResSetup."Req. Month for Leave Allow." <> 0 then
                      CheckEmploymentStatus;
                
                    CheckExistingPayment;
                
                    /*CASE HumanResSetup."Leave Allowance Payment Option" OF
                      HumanResSetup."Leave Allowance Payment Option"::Voucher:
                        "Leave Amount to Pay" := GetLeaveAllowance;
                    END;*/
                  end;
                end else
                  "Leave Amount to Pay" := 0;

            end;
        }
        field(40;"Resumption Date";Date)
        {
            Editable = false;
        }
        field(41;"Allow Public Holiday";Boolean)
        {
        }
        field(42;"Entry Type";Option)
        {
            OptionCaption = 'Application,Add,Substract';
            OptionMembers = Application,"Positive Adjustment","Negative Adjustment";
        }
        field(43;"Document Date";Date)
        {
        }
        field(44;"Employee Name";Text[150])
        {
            Editable = false;
        }
        field(45;"Days Calculation Basis";Option)
        {
            OptionCaption = 'Working Days,Day';
            OptionMembers = "Working Days",Day;
        }
        field(46;"Leave Amount to Pay";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(47;"Opening/Closing Entry";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Opening,Closing';
            OptionMembers = " ",Opening,Closing;
        }
        field(48;"Employee Category";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Category";
        }
        field(70000;"Portal ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70001;"Mobile User ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70002;"Created from External Portal";Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Created from External Portal such as Retail';
        }
    }

    keys
    {
        key(Key1;"Document No.")
        {
            Clustered = true;
        }
        key(Key2;"Year No.","Employee No.","Cause of Absence Code","Entry Type",Status)
        {
            SumIndexFields = Quantity,"Quantity (Base)";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Status,Status::Open);
        if "Schedule Line No." <> 0 then begin
          LeaveScheduleLine.Get("Year No.","Employee No.","Cause of Absence Code","Schedule Line No.");
          LeaveScheduleLine."No. of Days Taken" := 0;
          LeaveScheduleLine."Outstanding No. of Days" := LeaveScheduleLine."No. of Days Scheduled";
          LeaveScheduleLine.Modify;
        end;
        ApprovalMgt.DeleteApprovalEntries(RecordId)
    end;

    trigger OnInsert()
    begin
        if "Document No." = '' then begin
          HumanResSetup.Get;
          HumanResSetup.TestField(HumanResSetup."Employee Absence No.");
          NoSeriesMgt.InitSeries(HumanResSetup."Employee Absence No.",xRec."No. Series",0D,"Document No.","No. Series");
        end;

        if ("Entry Type" = "entry type"::Application) and ("Employee No." = '') then begin
          UserSetup.Get(UserId);
          UserSetup.TestField("Employee No.");
          Validate("Employee No.",UserSetup."Employee No.");
          "Year No." := Date2dmy(Today,3);
          "Document Date" := Today;
        end else begin
          "Year No." := Date2dmy(Today,3);
          "Document Date" := Today;
        end;
    end;

    trigger OnModify()
    begin
        if not(StatusCheckSuspended) then
          TestField(Status,Status::Open);
    end;

    var
        Text001: label 'Date is not a working day';
        Text002: label 'Date is a Public Holiday';
        Text003: label 'This is applicable to only annual leave';
        Text004: label 'Leave days must be equal to or above %1';
        Text005: label 'Leave allowance already paid';
        Text006: label 'You must apply for %1 through your leave scheddule';
        Text007: label 'You cannot apply for more than %1 days';
        Text008: label '%1 day(s) %2  has been approved for %3 by his/her line manager';
        Text009: label 'Kindly pay my leave allowance.';
        Text010: label 'Your action is required.';
        Text011: label 'Best Regards.';
        UserSetup: Record "User Setup";
        CauseOfAbsence: Record "Cause of Absence";
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        GlobalEmployeeAbsence: Record "Employee Absence";
        HumanResUnitOfMeasure: Record "Human Resource Unit of Measure";
        PublicHoliday: Record "Public Holiday";
        LeaveScheduleHeader: Record "Leave Schedule Header";
        HumanResSetup: Record "Human Resources Setup";
        LeaveScheduleLine: Record "Leave Schedule Line";
        TempApprovalEntry: Record "Approval Entry" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        LeaveMgt: Codeunit LeaveManagement;
        AvailableNoOfDays: Decimal;
        GlobalSender: Text[80];
        Body: Text[200];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
        NextEntryNo: Integer;
        Text012: label 'You cannot relief yourself';
        Text013: label '%1 application raised with document no. %2 not yet processed.\\ New application not allowed';
        Text014: label 'The leave for the year selected has been closed';
        StatusCheckSuspended: Boolean;
        Text015: label 'You cannot go on %1 until you have exhausted your annual leave';
        EmploymentDateErr: label 'Fatal Error! Employment Date for Employee %1 is blank';
        LeaveEntitleErr: label 'You are not entitled to leave allowance until after %1 months of your employment';
        Window: Dialog;
        NegativeBalErr: label 'This will be lead to a negative balance';
        NoOfDaysError: label 'No. Of Days must be specified';

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;


    procedure CalcReturnDate()
    var
        ReturnDate: Date;
        Holder2: Integer;
    begin
        if "To Date" = 0D then
          "Resumption Date" := 0D
        else begin
          ReturnDate := CalcDate('1D',"To Date");
          LeaveMgt.ConsiderPublicHoliday("Cause of Absence Code",ReturnDate);
          LeaveMgt.ConsiderWeekend("Cause of Absence Code",ReturnDate);
          "Resumption Date" :=  ReturnDate;
        end;
    end;


    procedure CheckExistingApplication()
    var
        LeaveApplication: Record "Leave Application";
    begin
        LeaveApplication.SetRange("Year No.","Year No.");
        LeaveApplication.SetRange("Employee No.", "Employee No.");
        LeaveApplication.SetRange("Cause of Absence Code","Cause of Absence Code");
        LeaveApplication.SetRange("Entry Type",LeaveApplication."entry type"::Application);
        LeaveApplication.SetFilter(Status,'<>%1',LeaveApplication.Status::Approved);
        LeaveApplication.SetFilter("Document No.",'<>%1',"Document No.");
        if LeaveApplication.FindFirst then
          Error(Text013,LeaveApplication.Description,LeaveApplication."Document No.");
    end;


    procedure IsClosedSchedule(): Boolean
    begin
        LeaveScheduleHeader.Get("Year No.","Employee No.","Cause of Absence Code");
        if LeaveScheduleHeader.Closed then
          exit(true)
        else
          exit(false);
    end;


    procedure SendNotification()
    var
        EmployeeAbsence: Record "Employee Absence";
    begin
        UserSetup.Get(UserId);
        Employee.Get(UserSetup."Employee No.");
        GlobalSender := Employee.FullName;
        Body := StrSubstNo(Text008,Quantity,Description,"Employee Name");
        Subject := 'Approved' + ' ' + Description;
        UserSetup.SetRange("Receive Leave Alert",true);
        if UserSetup.FindFirst then begin
          UserSetup.TestField("E-Mail" );
          SMTP.CreateMessage(GlobalSender,Employee."Company E-Mail",UserSetup."E-Mail",
                            Subject,Body,true);
          SMTP.Send;
        end;
    end;


    procedure PostLeave()
    begin
        HumanResSetup.Get;
        TestField(Status,Status::Approved);
        Window.Open('#1#################################');
        if "Process Allowance Payment" then begin
          case HumanResSetup."Leave Allowance Payment Option" of
            HumanResSetup."leave allowance payment option"::Voucher:
              begin
                TestField("Leave Amount to Pay");
                Window.Update(1,'Processing Leave Allowance');
                LeaveMgt.CreateLeaveAllwVoucher(Rec);
              end;
          end;
        end;

        EmployeeAbsence.Init;
        Window.Update(1,'Posting Leave Entries');
        EmployeeAbsence.CopyFromLeaveApplication(Rec);
        GetNextEntryNo;
        EmployeeAbsence."Entry No." := NextEntryNo;
        EmployeeAbsence.Insert;
        ApprovalMgt.PostApprovalEntries(Rec.RecordId,EmployeeAbsence.RecordId,"Document No.");
        ApprovalMgt.DeleteApprovalEntries(Rec.RecordId);
        if HasLinks then
          EmployeeAbsence.CopyLinks(Rec);

        DeleteLinks;

        Window.Close;

        Delete;

        Message('Action Completed');
    end;


    procedure GetNextEntryNo()
    begin
        GlobalEmployeeAbsence.LockTable;
        if GlobalEmployeeAbsence.FindLast then
          NextEntryNo := GlobalEmployeeAbsence."Entry No." + 1
        else
          NextEntryNo := 1;
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;

    local procedure ApplicationRestrictionExist(): Boolean
    var
        CauseOfAbsence: Record "Cause of Absence";
    begin
        if "Entry Type" = "entry type"::Application then begin
          CauseOfAbsence.Get("Cause of Absence Code");
          if CauseOfAbsence."Restrict App. to Schedule" then
            exit(true)
          else
            exit(false);
        end else
          exit(false);
    end;

    local procedure CheckEmploymentStatus()
    var
        nMonths: Decimal;
    begin
        Employee.Get("Employee No.");
        if Employee."Employment Date" = 0D then
          Error(EmploymentDateErr,Employee."No.");
        nMonths := ROUND(((Date2dmy("From Date",3) - Date2dmy(Employee."Employment Date",3)) * 365 +
                        (Date2dmy("From Date",2) - Date2dmy(Employee."Employment Date",2))* 30.41 +
                        (Date2dmy("From Date",1) - Date2dmy(Employee."Employment Date",1)))/30.41,0.00001);
        if nMonths < HumanResSetup."Req. Month for Leave Allow." then
          Error(LeaveEntitleErr,HumanResSetup."Req. Month for Leave Allow.");
    end;

    local procedure CheckExistingPayment()
    begin
        EmployeeAbsence.SetRange("Employee No.","Employee No.");
        EmployeeAbsence.SetRange("Year No.","Year No.");
        EmployeeAbsence.SetRange("Cause of Absence Code","Cause of Absence Code");
        EmployeeAbsence.SetRange("Process Allowance Payment",true);
        EmployeeAbsence.SetRange("Leave Paid",true);
        if EmployeeAbsence.FindFirst then
          Error(Text005);
    end;

    local procedure GetLeaveAllowance(): Decimal
    var
        FirstPayrollPeriod: Record "Payroll-Period";
        NextPayrollPeriod: Record "Payroll-Period";
        ClosedPayslip: Record "Payroll-Payslip Line";
        PayrollSetup: Record "Payroll-Setup";
        StartDate: Date;
        CurrentLeaveAllowance: Decimal;
        TotalLeaveAllowance: Decimal;
        NoMonths: Integer;
    begin
        PayrollSetup.Get;
        PayrollSetup.TestField("Leave Accrual ED Code");
        StartDate := Dmy2date(1,1,Date2dmy("From Date",3));
        FirstPayrollPeriod.SetRange("Start Date",StartDate);
        ClosedPayslip.SetCurrentkey("Payroll Period","Employee No.","E/D Code");
        ClosedPayslip.SetFilter("Payroll Period",'>=%1',FirstPayrollPeriod."Period Code");
        ClosedPayslip.SetRange("Employee No.","Employee No.");
        ClosedPayslip.SetRange("E/D Code",PayrollSetup."Leave Accrual ED Code");
        if ClosedPayslip.FindSet then begin
          repeat
            CurrentLeaveAllowance := ClosedPayslip."Actual Prorated Amount";
            TotalLeaveAllowance += ClosedPayslip.Amount;
            NoMonths += 1;
          until ClosedPayslip.Next = 0;
        end;
        if NoMonths < 12 then
          TotalLeaveAllowance += CurrentLeaveAllowance *(12 - NoMonths);
        exit(TotalLeaveAllowance);
    end;


    procedure CheckRequiredFields()
    begin
        case "Entry Type" of
          "entry type"::Application:
            begin
              if Quantity = 0 then
                Error(NoOfDaysError);
            end;
        end;
    end;
}

