Table 52092200 "Interview Header"
{
    DrillDownPageID = "Interview Schedule List";
    LookupPageID = "Interview Schedule List";

    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;
        }
        field(2;"Emp. Requisition Code";Code[20])
        {
            TableRelation = "Employee Requisition";

            trigger OnValidate()
            begin
                if ("Emp. Requisition Code" <> '') then begin
                  JobVacancy.Get("Emp. Requisition Code");
                  JobVacancy.TestField(JobVacancy."Employment Status",JobVacancy."employment status"::Vacant);
                  JobVacancy.TestField(JobVacancy."Job Title Code");
                  "No. to Interview" := JobVacancy."No. Required";
                  Description := JobVacancy.Description;
                  "Internal/External" := JobVacancy."Internal/External";
                  // check previous interviews
                  InterviewHeader.SetRange(InterviewHeader."Emp. Requisition Code","Emp. Requisition Code");
                  if InterviewHeader.Find('+') then begin
                    if InterviewHeader.Status = 0 then
                      if not Confirm(Text002,false,InterviewHeader."No.") then
                        Error(Text003);
                    Stage := Stage::Intermediate;
                    Level := InterviewHeader.Level + 1;
                    "Prev. Interview Ref. No." := InterviewHeader."No.";
                  end else begin
                    Stage := Stage::First;
                    Level := 1;
                  end;
                end else begin
                  Description := '';
                end;
            end;
        }
        field(3;Description;Text[40])
        {
        }
        field(4;"Document Date";Date)
        {
        }
        field(5;"Interview Date";Date)
        {

            trigger OnValidate()
            begin
                if ("Interview Date" < Today) or (("Document Date" <> 0D) and ("Interview Date" < "Document Date")) then
                  if not Confirm(Text004,false,FieldName("Interview Date")) then
                    Error(Text005);

                InterviewLine.SetRange(InterviewLine."Interview No.","No.");
                InterviewLine.SetFilter(InterviewLine.Date,'%1|%2',0D,xRec."Interview Date");
                InterviewLine.ModifyAll(InterviewLine.Date,"Interview Date");
            end;
        }
        field(6;"Interview Time";Time)
        {

            trigger OnValidate()
            begin
                InterviewLine.SetRange(InterviewLine."Interview No.","No.");
                InterviewLine.SetFilter(InterviewLine.Time,'%1|%2',0T,xRec."Interview Time");
                InterviewLine.ModifyAll(InterviewLine.Time,"Interview Time");
            end;
        }
        field(7;Stage;Option)
        {
            OptionCaption = 'First,Intermediate,Final';
            OptionMembers = First,Intermediate,Final;

            trigger OnValidate()
            begin
                InterviewLine.SetRange(InterviewLine."Interview No.","No.");
                InterviewLine.ModifyAll(InterviewLine.Stage,Stage);
            end;
        }
        field(8;Level;Integer)
        {
            InitValue = 1;
            MinValue = 1;

            trigger OnValidate()
            begin
                InterviewLine.SetRange(InterviewLine."Interview No.","No.");
                InterviewLine.ModifyAll(InterviewLine.Level,Level);
            end;
        }
        field(9;"No. Short-Listed";Integer)
        {
            BlankZero = true;
            CalcFormula = count("Interview Line" where ("Interview No."=field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"No. Interviewed";Integer)
        {
            BlankZero = true;
            CalcFormula = count("Interview Line" where ("Interview No."=field("No."),
                                                        Status=filter(<>None&<>Invited)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;Address;Text[30])
        {
        }
        field(12;"Address 2";Text[30])
        {
        }
        field(13;Status;Option)
        {
            OptionCaption = ' ,Invited,Next Interview,Hired,Discontinued';
            OptionMembers = " ",Invited,"Next Interview",Hired,Discontinued;

            trigger OnValidate()
            begin
                if Status = Status::Invited then Error(Text007);

                if Status = 0 then begin
                  InterviewLine.SetRange(InterviewLine."Interview No.",InterviewHeader."No.");
                  InterviewLine.SetRange(InterviewLine.Status,2,5);
                  if InterviewLine.Find('-') then
                    Error(Text006);
                end;
            end;
        }
        field(14;Comment;Boolean)
        {
        }
        field(15;"Responsible Empl. No.";Code[40])
        {
            TableRelation = Employee;
        }
        field(16;"Prev. Interview Ref. No.";Code[20])
        {
            TableRelation = "Interview Header" where (Status=const("Next Interview"));
        }
        field(17;"No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(19;"Venue Code";Code[10])
        {
            TableRelation = "Training Facility".Code where (Type=const(Venue));

            trigger OnValidate()
            begin
                VenueRec.Get(1,"Venue Code");
                "Venue Description" := VenueRec.Description;
                Address := VenueRec.Address;
                "Address 2" := VenueRec."Address 2";
            end;
        }
        field(20;"Venue Description";Text[40])
        {
        }
        field(21;"No. to Interview";Integer)
        {
            MinValue = 1;

            trigger OnValidate()
            begin
                CalcFields("No. Short-Listed");
                if ("No. to Interview" <> 0) and ("No. Short-Listed" > "No. to Interview") then begin
                  if not Confirm(Text008) then
                    Error(Text009)
                  else begin
                    InterviewLine.SetRange(InterviewLine."Interview No.","No.");
                    if InterviewLine.Find('-') then
                      InterviewLine.Next("No. to Interview");
                    InterviewLine.SetFilter(InterviewLine."Line No.",'>=%1',InterviewLine."Line No.");
                    if InterviewLine.Count <> ("No. Short-Listed" - "No. to Interview") then
                      Error(Text010);
                    InterviewLine.DeleteAll;
                  end;
                end;
            end;
        }
        field(22;"No. Passed";Integer)
        {
            CalcFormula = count("Interview Line" where ("Interview No."=field("No."),
                                                        "Score %"=field(ScoreFilter)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23;"Pass Mark";Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Pass Mark" = 0 then
                  Error(Text011);

                SetFilter(ScoreFilter,'>=%1',"Pass Mark");
                CalcFields("No. Passed");
            end;
        }
        field(24;ScoreFilter;Decimal)
        {
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(25;"Internal/External";Option)
        {
            OptionMembers = External,Internal,Both;
        }
        field(26;"Mode of Interview";Option)
        {
            OptionMembers = Written,Oral,Practical,Other;
        }
        field(27;"Schedule Closed";Boolean)
        {
        }
        field(28;"Interview Closed";Boolean)
        {
        }
        field(29;"Interviewing Officers";Integer)
        {
            CalcFormula = count(Interviewer where ("Schedule Code"=field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Emp. Requisition Code",Stage,Level)
        {
        }
        key(Key3;Status)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CalcFields("No. Interviewed");
        if "No. Interviewed" <> 0 then
          Error(Text012);
        InterviewLine.SetRange(InterviewLine."Interview No.","No.");
        InterviewLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
          InterviewHeader.SetFilter("Emp. Requisition Code",'%1','');
          if InterviewHeader.Find('-') then
            Error(Text001,InterviewHeader."No.");

          HumanResSetup.Get;
          HumanResSetup.TestField("Interview Nos.");
          NoSeriesMgt.InitSeries(HumanResSetup."Interview Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;
        "Document Date" := WorkDate;
        "Pass Mark" := 50;
    end;

    var
        InterviewHeader: Record "Interview Header";
        InterviewLine: Record "Interview Line";
        Applicant: Record Applicant;
        JobVacancy: Record "Employee Requisition";
        VenueRec: Record "Training Facility";
        Employee: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        Interviewers: Record Interviewer;
        Interviewer: Record Interviewer;
        UserSetup: Record "User Setup";
        GlobalText: Text[160];
        ShortList: Report "Short-List Applicant";
        ApplicantMobile: Text[80];
        GlobalSender: Text[80];
        CurrErrMessage: Text[80];
        SMTP: Codeunit "SMTP Mail";
        RecruitmentMgt: Codeunit RecruitmentManagement;
        Body: Text[200];
        Subject: Text[200];
        Choice: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'Created No. %1 not used!\New no. cannot be created';
        Text002: label 'Previous Interview %1 not yet concluded!\Continue Anyway?';
        Text003: label 'New interview not possible!';
        Text004: label '%1 may not be correct!\Continue Anyway?';
        Text005: label 'Incorrect Date!';
        Text006: label 'Entry not allowed!';
        Text007: label 'Manual entry not allowed!';
        Text008: label 'No of Applicants to interview already exceeded!\Do you want to reduce the no.?';
        Text009: label 'No. to interview not correct!';
        Text010: label 'Unknown Error - Inconsistent records!';
        Text011: label 'Pass Mark must be specified!';
        Text012: label 'Interview Results in progress!\Record cannot be deleted';
        Text013: label 'No candidate passed!';
        Text014: label 'Line is empty!';
        Text015: label 'This is to notify you that interview for the position of %1 will held at %2 on %3 at %4 prompt and your presence is highly required';
        Text016: label 'Invitation was successfully sent!';
        Text017: label 'Interviewing Officers not yet selected!';
        Text018: label 'You are hereby invited for an interview at %1, Venue is %2, Date %3 and Time %4';
        Text019: label 'Nothing to apply!';
        Text020: label 'Applicant must accept employment offer';
        Text021: label 'Are you sure you want to discontinue this interview?';
        Text022: label 'Do you want to discontinue the Job Vacancy as well!';
        Text023: label 'Result yet to be captured for Applicant No. %1';


    procedure CreateNextStage(var NextInterviewHeader: Record "Interview Header")
    begin
        if Stage = Stage::Final then
          Stage := Stage::Intermediate;

        if "Pass Mark" = 0 then
          "Pass Mark" := 50;

        Status := Status::"Next Interview";

        Modify;
        SetFilter(ScoreFilter,'>=%1',"Pass Mark");

        CalcFields("No. Passed");
        if "No. Passed" = 0 then
          Error(Text013);

        NextInterviewHeader := Rec;
        NextInterviewHeader."Document Date" := Today;
        NextInterviewHeader."Interview Date" := 0D;
        NextInterviewHeader."Interview Time" := 0T;

        NextInterviewHeader.Stage := NextInterviewHeader.Stage::Intermediate;
        NextInterviewHeader.Level := Level + 1;

        NextInterviewHeader.Status := 0;
        NextInterviewHeader."No. to Interview" := "No. Passed";
        NextInterviewHeader."Prev. Interview Ref. No." := "No.";


        if not NextInterviewHeader.Insert then begin
          NextInterviewHeader."No." := '';
          HumanResSetup.Get;
          HumanResSetup.TestField("Interview Nos.");
          NoSeriesMgt.InitSeries(HumanResSetup."Interview Nos.",xRec."No. Series",0D,NextInterviewHeader."No.","No. Series");
          NextInterviewHeader.Insert;
        end;

        //Close Interviewers score sheet
        Interviewers.SetRange("Schedule Code","No.");
        Interviewers.ModifyAll(Interviewers."Schedule Closed",true);
    end;


    procedure ApplicantEmailInv()
    begin
        GlobalSender := COMPANYNAME;
        Subject := 'RECRUITMENT INTERVIEW';
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        Employee.Get(UserSetup."Employee No.");
        Employee.TestField("Company E-Mail");
        Applicant.Reset;
        //*************** Check if E-mails are entered
        InterviewLine.Reset;
        InterviewLine.SetRange(InterviewLine."Interview No.","No.");
        InterviewLine.FindFirst;
        repeat
          Applicant.Get(InterviewLine."Applicant No.");
          Applicant.TestField(Applicant."E-Mail");
        until InterviewLine.Next = 0;
        Applicant.Reset;

        //*********** Sending messages to respective applicant
        InterviewLine.Reset;
        InterviewLine.SetRange(InterviewLine."Interview No.","No.");
        InterviewLine.FindFirst;
        repeat
          Applicant.Get(InterviewLine."Applicant No.");
          Body := StrSubstNo(Text018,COMPANYNAME,"Venue Description",InterviewLine.Date,InterviewLine.Time);
          SMTP.CreateMessage('HR DEPT.',Employee."Company E-Mail",Applicant."E-Mail",Subject,Body,false);
          SMTP.Send;
        until InterviewLine.Next = 0;

        //****** Updatting status
        Applicant.Reset;
        InterviewLine.Reset;
        InterviewLine.SetRange(InterviewLine."Interview No.","No.");
        InterviewLine.FindFirst;
        repeat

          Applicant.Get(InterviewLine."Applicant No.");
          if Applicant.Status = 0 then begin
            Applicant.Status := Applicant.Status::Invited;
            Applicant.Modify;
          end;

          if InterviewLine.Status = 0 then begin
            InterviewLine.Status := InterviewLine.Status::Invited;
            InterviewLine.Modify;
          end;
        until InterviewLine.Next = 0;

        if Status in [0,2] then begin
          Status := Status::Invited;
          Modify;
        end;
    end;


    procedure ApplicantMobileInv()
    begin
        /*GlobalSender := COMPANYNAME;
        Subject := 'RECRUITMENT INTERVIEW';
        SMSSetup.GET;
        ApplicantMobile := '';
        Applicant.RESET;
        
        //*********** Sending messages to respective applicant
        InterviewLine.RESET;
        InterviewLine.SETRANGE(InterviewLine."Interview No.","No.");
        InterviewLine.FINDFIRST;
        REPEAT
          CurrErrMessage := '';
          Applicant.GET(InterviewLine."Applicant No.");
          //***** Check if Mobile No. is entered
          Applicant.TESTFIELD(Applicant."Mobile Phone No.");
        
          //**** Send message
          CASE SMSSetup."Send SMS By" OF
            0:BEGIN
              GlobalText := STRSUBSTNO(Text018,COMPANYNAME,"Venue Description",InterviewLine.Date,InterviewLine.Time);
              CurrErrMessage := SendSMS.SendURLSMS(Applicant."Mobile Phone No.",GlobalText,GlobalSender);
              IF STRLEN(CurrErrMessage) > 3 THEN
                ERROR(CurrErrMessage);
            END;
            1:BEGIN
              SendSMS.SendEmailAsSMS(GlobalSender,Applicant."Mobile Phone No.",Subject,GlobalText);
            END;
          END;
        
          //****** Update Applicant Status
          Applicant.Status := Applicant.Status::Invited;
          Applicant.MODIFY;
        
          //****** Update Interview Line Status
          InterviewLine.Status := InterviewLine.Status::Invited;
          InterviewLine.MODIFY;
        UNTIL InterviewLine.NEXT = 0;
        
        
        IF Status IN [0,2] THEN BEGIN
          Status := Status::Invited;
          MODIFY;
        END;
        MESSAGE(Text016);*/

    end;


    procedure NotifyPanel(Choice: Integer)
    var
        Interviewer: Record Interviewer;
        InterviewLines: Record "Interview Line";
    begin
        GlobalSender := 'HR DEPARTMENT';
        //SMSSetup.GET;
        UserSetup.Get(UserId);
        case Choice of
          1:begin
            UserSetup.TestField("Employee No.");
            Employee.Get(UserSetup."Employee No.");
            Employee.TestField("Company E-Mail");
          end;
        end;
        InterviewLine.Reset;
        InterviewLine.SetRange(InterviewLine."Interview No.","No.");
        InterviewLine.SetFilter(InterviewLine."Applicant No.",'<>%1','');
        if not InterviewLine.FindFirst then
          Error(Text014);
        
        Interviewer.Reset;
        Interviewer.SetRange(Interviewer."Schedule Code","No.");
        if Interviewer.Find('-') then begin
          if Choice <> 0 then begin
            repeat
              CreateResultSheet(Interviewer);
              Body := StrSubstNo(Text015,Description,"Venue Description","Interview Date","Interview Time");
              Subject := 'RECRUITMENT INTERVIEW';
              case Choice of
                1:begin
                  SMTP.CreateMessage('HR DEPT.',Employee."Company E-Mail",Interviewer."E-Mail",Subject,Body,false);
                  SMTP.Send;
                end;
                /*2:BEGIN
                  CASE SMSSetup."Send SMS By" OF
                    0:BEGIN
                      CurrErrMessage := SendSMS.SendURLSMS(Interviewer."Mobile No.",Body,GlobalSender);
                      IF STRLEN(CurrErrMessage) > 3 THEN
                        ERROR(CurrErrMessage);
                    END;
                    1: SendSMS.SendEmailAsSMS(GlobalSender,Interviewer."Mobile No.",Subject,Body);
                  END;
                END;*/
              end;
            until Interviewer.Next = 0;
            Message(Text016);
          end;
        end else begin
          Error(Text017);
        end;

    end;


    procedure CreateResultSheet(CurrRec: Record Interviewer)
    var
        InterviewLineScoreSheet: Record "Interviewer Score Details";
    begin
        InterviewLine.Reset;
        InterviewLine.SetRange(InterviewLine."Interview No.","No.");
        InterviewLine.Find('-');
        repeat
          InterviewLineScoreSheet."Ref. No." := InterviewLine."Interview No.";
          InterviewLineScoreSheet."Line No." := InterviewLine."Line No.";
          InterviewLineScoreSheet."Job Ref. No." := InterviewLine."Emp. Requisition Code";
          InterviewLineScoreSheet."Applicant No." := InterviewLine."Applicant No.";
          InterviewLineScoreSheet.Name :=   InterviewLine.Name;
          InterviewLineScoreSheet."Interviewer Code" := CurrRec."Employee Code";
          if not(InterviewLineScoreSheet.Insert) then
            InterviewLineScoreSheet.Modify;
        until InterviewLine.Next = 0;
    end;


    procedure GetResult()
    var
        InterviewScore: Record Interviewer;
    begin
        InterviewScore.Reset;
        InterviewLine.Reset;
        InterviewLine.SetRange(InterviewLine."Interview No.","No.");
        if InterviewLine.FindFirst then begin
          repeat
            InterviewScore.Reset;
            InterviewScore.SetRange(InterviewScore."Schedule Code","No.");
            InterviewScore.SetRange(InterviewScore."Applicant Filter",InterviewLine."Applicant No.");
            InterviewScore.FindFirst;
            InterviewScore.CalcFields(InterviewScore."Total Score",InterviewScore."Total Entries");
            if ((InterviewScore."Total Score" <> 0)  and (InterviewScore."Total Entries" <> 0)) then begin
              InterviewLine.Validate("Score %",(InterviewScore."Total Score"/InterviewScore."Total Entries"));
              InterviewLine.Modify;
            end else begin
              Error(Text023,InterviewLine."Applicant No.");
            end;

          until InterviewLine.Next = 0;
        end;
    end;


    procedure ApplyResult()
    var
        Selected: Integer;
    begin
        InterviewLine.SetRange("Interview No.","No.");
        InterviewLine.SetRange(Selection,InterviewLine.Selection::Employed);
        if not InterviewLine.Find('-') then begin
          Message(Text019);
          exit
        end else begin
          repeat
            if InterviewLine.Response <> InterviewLine.Response::Accepted then
              Error(Text020);
          until InterviewLine.Next = 0;
        end;

        Selected := Dialog.StrMenu('Apply Only,Apply && Close', 1);

        case Selected of
        1:
          begin
            RecruitmentMgt.ApplyRecruitment(Rec);
          end;
        2:
          begin
            RecruitmentMgt.ApplyRecruitment(Rec);
            "Interview Closed" := true;
          end;
        end;
    end;


    procedure DiscontinueInterview()
    begin
        if not Confirm(Text021,false) then
          exit;

        if Confirm(Text022,false) then begin
          JobVacancy.Get("Emp. Requisition Code");
          JobVacancy.Status := JobVacancy.Status::Discontinued;
          JobVacancy.Modify;
        end;

        Status := Status::Discontinued;
        "Schedule Closed" := true;

        //Close Interviewers score sheet
        Interviewer.SetRange("Schedule Code","No.");
        Interviewer.ModifyAll("Schedule Closed",true);
    end;
}

