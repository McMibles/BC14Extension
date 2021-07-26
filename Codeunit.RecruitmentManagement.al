Codeunit 52092187 RecruitmentManagement
{

    trigger OnRun()
    begin
    end;

    var
        Text001: label '%1 not specified!';
        Text002: label 'Interview stage not yet final!\Continue Anyway?';
        Text003: label 'No record to select from!';
        Text004: label '%1 no of records selected!';
        Text005: label 'Nothing to Apply!';
        Text006: label 'Interview Results successfully applied!';
        Text007: label 'Are you sure you want to apply successful\candidates for the specified Job(s) No.';
        Text008: label 'Unknown Error!\Employee No. %1 does not exist';
        Text1009: label 'This is to notity you that %1 has been recruited into your department as requested by you.';
        Text1010: label 'Recruitment Notification';
        JobVacancy: Record "Employee Requisition";
        InterviewLine: Record "Interview Line";
        InterviewHeader: Record "Interview Header";
        Applicant: Record Applicant;
        Employee: Record Employee;
        JobTitle: Record "Job Title";
        EmploymentHistory: Record "Employment History";
        EmplReferee: Record Referee;
        EmplReferee2: Record Referee;
        SkillEntry: Record "Skill Entry";
        SkillEntry2: Record "Skill Entry";
        CompanyInfo: Record "Company Information";
        EmployeeSalary: Record "Employee Salary";
        Requestor: Record Employee;
        UserSetup: Record "User Setup";
        SMTP: Codeunit "SMTP Mail";
        NoOfRecords: Integer;
        iCount: Integer;
        "Hired(Y/N)": Boolean;
        Window: Dialog;
       // EmploymentLetter: Report "Employment Letter";
        FileNameServer: Text;
        Subject: Text;
        Body: Text;


    procedure SelectApplicant(var Rec: Record "Interview Header")
    begin
        if (Rec."Emp. Requisition Code" = '') then begin
          Message(Text001,Rec.FieldName(Rec."Emp. Requisition Code"));
          exit;
        end;

        if Rec.Stage <> Rec.Stage::Final then
          if not Confirm(Text002,false) then
            exit;

        JobVacancy.Get(Rec."Emp. Requisition Code");
        JobVacancy.TestField(JobVacancy."No. Required");
        NoOfRecords := JobVacancy."No. Required";
        InterviewLine.SetRange(InterviewLine."Interview No.",Rec."No.");
        InterviewLine.SetRange(InterviewLine.Status,2,3);
        if not InterviewLine.Find('-') then begin
          Message(Text003);
          exit;
        end;

        InterviewLine.SetCurrentkey("Score %");
        InterviewLine.Ascending := false;

        Window.Open('Please Wait #1###### @2@@@@@@@@@@@@@');

        InterviewLine.Find('-');
        iCount := 1;
        repeat

          Window.Update(1,InterviewLine."Applicant No.");
          Window.Update(2,ROUND(iCount / NoOfRecords * 10000,1));
          InterviewLine.Validate(InterviewLine.Selection,InterviewLine.Selection::Employed);
          InterviewLine.Modify;
          iCount := iCount + 1;

        until (InterviewLine.Next = 0) or (iCount > NoOfRecords);
        Rec.Status := Rec.Status::Hired;
        Rec."Schedule Closed" := true;
        Rec.Modify;
        Window.Close;
        Message(Text004,iCount -1);
    end;


    procedure ApplyRecruitment(var Rec: Record "Interview Header")
    begin
        with Rec do begin
          if ("Emp. Requisition Code" = '') then begin
            Message(Text001,Rec.FieldName("Emp. Requisition Code"));
            exit;
          end;

          JobVacancy.Get(Rec."Emp. Requisition Code");
          JobVacancy.TestField(JobVacancy."No. Required");
          CalcFields("No. Short-Listed");
          NoOfRecords := "No. Short-Listed";

          InterviewLine.SetRange(InterviewLine."Interview No.","No.");
          //InterviewLine.SETRANGE(InterviewLine.Status,2,3,5);
          if not InterviewLine.Find('-') then begin
            Message(Text005);
            exit;
          end;

          InterviewLine.SetRange(InterviewLine.Status);

          Window.Open('Please Wait #1###### @2@@@@@@@@@@@@@');

          InterviewLine.Find('-');
          "Hired(Y/N)" := false;
          iCount := 1;
          repeat
            Window.Update(1,InterviewLine."Applicant No.");
            Window.Update(2,ROUND(iCount / NoOfRecords * 10000,1));
            Applicant.Get(InterviewLine."Applicant No.");
            Applicant.Status := InterviewLine.Status;
            Applicant.Validate("Empl. Job Ref. No.","Emp. Requisition Code");
            Applicant."Final Interview Ref. No." := "No.";
            Applicant."Probation Period" := InterviewLine."Probation Period";
            Applicant."Job Title Code" := JobVacancy."Job Title Code";
            Applicant."Grade Level Code" := InterviewLine."Grade Level Code";
            Applicant."Employee Category" := InterviewLine."Employee Category";
            Applicant."Global Dimension 1 Code"  := InterviewLine."Global Dimension 1 Code";
            Applicant."Global Dimension 2 Code"  := InterviewLine."Global Dimension 2 Code";

            if InterviewLine.Status = InterviewLine.Status::Hired then begin
              "Hired(Y/N)" := true;
            end;
            Applicant.Modify;
            iCount := iCount + 1;
          until (InterviewLine.Next = 0);

          if (Stage = Stage::Final) or "Hired(Y/N)" then begin
            Status := Status::Hired;
            JobVacancy."Employment Status"  := JobVacancy."employment status"::"Accepted Offer";
            JobVacancy."Final Interview No." := Rec."No.";
            JobVacancy.Modify;
          end else
            Status := Status::"Next Interview";
          Modify;
        end;

        Window.Close;
        Message(Text006);
    end;


    procedure ApplyAppointment(var Rec: Record Applicant)
    var
        ApplicantQualification: Record "Other Qualification";
        EmplQualification: Record "Employee Qualification";
        AppSkillEntry: Record "Skill Entry";
        EmpSkillEntry: Record "Skill Entry";
    begin
        if not Confirm(Text007,false) then
          exit;
        
        CompanyInfo.Get;
        
        
        Rec.SetRange(Rec.Status,Rec.Status::Hired);
        Rec.SetRange(Rec."Confirmed (Y/N)",true);
        Rec.SetRange(Rec."Closed?",false);
        
        if not Rec.Find('-') then
          Error(Text005);
        
        NoOfRecords := Rec.Count;
        iCount := 0;
        
        Window.Open('Please Wait #1###### @2@@@@@@@@@@@@@');
        
        with Rec do
        repeat
        
          Window.Update(1,"No.");
          Window.Update(2,ROUND(iCount / NoOfRecords * 10000,1));
        
          TestField("Empl. Job Ref. No.");
          TestField("Confirmed (Y/N)");
          TestField("Date Assumed");
          TestField("Grade Level Code");
          TestField("First Name");
          TestField("Last Name");
          TestField(Address);
          TestField(Gender);
          TestField("Marital Status");
          TestField("Birth Date");
          TestField("Job Title Code");
        
          JobVacancy.Get(Rec."Empl. Job Ref. No.");
          JobVacancy.TestField(JobVacancy."Job Title Code",Rec."Job Title Code");
        
          case "Internal/External" of
            1 : begin
              TestField("Employee No.");
              if not Employee.Get("Employee No.") then
                Error(Text008,"Employee No.");
              Employee.Validate(Employee."Job Title Code","Job Title Code");
              Employee.Validate(Employee."Grade Level Code","Grade Level Code");
              Employee."Global Dimension 1 Code" := "Global Dimension 1 Code";
              Employee."Employee Category" := Applicant."Employee Category";
              Employee."Global Dimension 2 Code" := "Global Dimension 2 Code";
              Employee."Current Appointment Date" := "Date Assumed";
              Employee."Previous Employee No." := "Previous Employee No.";
              Employee.Modify;
              // copies qualifications
              ApplicantQualification.SetRange("Record Type",ApplicantQualification."record type"::Applicant);
              ApplicantQualification.SetRange("No.","No.");
              if ApplicantQualification.Find('-') then begin
                 EmplQualification.SetRange("Employee No.",Employee."No.");
                 EmplQualification.DeleteAll;
                 EmplQualification.Reset;
                repeat
                  EmplQualification."Employee No." := Employee."No.";
                  EmplQualification."Line No." := ApplicantQualification."Line No.";
                  EmplQualification."Qualification Code" := ApplicantQualification."Qualification Code";
                  EmplQualification."From Date" := ApplicantQualification."From Date";
                  EmplQualification."To Date" := ApplicantQualification."To Date";
                  EmplQualification.Type := ApplicantQualification.Type;
                  EmplQualification.Description := ApplicantQualification.Description;
                  EmplQualification."Institution/Company" := ApplicantQualification."Institution/Company";
                  EmplQualification."Course Grade" := ApplicantQualification."Course Grade";
                  EmplQualification."Expiration Date"  := ApplicantQualification."Expiration Date";
                  EmplQualification."Course Code" := ApplicantQualification."Course Code";
                        if not EmplQualification.Insert then;
                until ApplicantQualification.Next = 0;
              end;
              // copies Skills
              AppSkillEntry.SetRange("Record Type",AppSkillEntry."record type"::Employee);
              AppSkillEntry.SetRange("No.", "No.");
              if AppSkillEntry.Find('-') then begin
                 EmpSkillEntry.SetRange("Record Type",EmpSkillEntry."record type"::Employee);
                 EmpSkillEntry.SetRange("No.",Employee."No.");
                 EmpSkillEntry.DeleteAll;
                 EmpSkillEntry.Reset;
                repeat
                  EmpSkillEntry := AppSkillEntry;
                  EmpSkillEntry."Record Type" := EmpSkillEntry."record type"::Employee;
                  EmpSkillEntry."No." := Employee."No.";
                  if not(EmpSkillEntry.Insert) then;
                until AppSkillEntry.Next = 0;
              end;
        
            end;
            0 : begin
              Employee.Init;
              Employee."No." := '';
              Employee."Previous Employee No." := Rec."Previous Employee No.";
              Employee.Insert(true);
              Rec.CopyToEmplRec(Employee);
              Rec."Employee No." := Employee."No.";
        
            end;
          end; /*end case*/
        
          // Update employment history for current employment
          EmploymentHistory.SetRange(EmploymentHistory."Record Type",EmploymentHistory."record type"::Employee);
          EmploymentHistory.SetRange(EmploymentHistory."No.",Employee."No.");
          if EmploymentHistory.Find('+') then begin
            if EmploymentHistory."To Date" = 0D then begin
              EmploymentHistory."To Date" := Rec."Date Assumed";
              EmploymentHistory.Modify;
            end;
            EmploymentHistory."Line No." := EmploymentHistory."Line No." + 10000
          end else begin
            EmploymentHistory."Record Type" := EmploymentHistory."record type"::Employee;
            EmploymentHistory."No." := Employee."No.";
            EmploymentHistory."Line No." := 10000;
          end;
          EmploymentHistory."From Date" := Rec."Date Assumed";
          EmploymentHistory.Type := EmploymentHistory.Type::Internal;
          EmploymentHistory."Entry Type" := EmploymentHistory."entry type"::Recruitment;
          EmploymentHistory."Position Held" := JobVacancy.Designation;
          EmploymentHistory."Institution/Company" := CompanyInfo.Name;
          EmploymentHistory."Job Title Code" := JobVacancy."Job Title Code";
          EmploymentHistory."Global Dimension 1 Code" := JobVacancy."Global Dimension 1 Code";
          EmploymentHistory."Global Dimension 2 Code" := JobVacancy."Global Dimension 2 Code";
          EmploymentHistory."Grade Level" := JobVacancy."Grade Level";
          EmploymentHistory."To Date" := 0D;
          EmploymentHistory.Remark := '';
          EmploymentHistory."Document No." := '';
          EmploymentHistory.Insert;
          //Update Employee Salary
          EmployeeSalary.Init;
          EmployeeSalary."Employee No." := Employee."No.";
          EmployeeSalary.Validate("Salary Group" ,Rec."Salary Group");
          EmployeeSalary."Effective Date" := "Date Assumed";
          EmployeeSalary.Insert;
          // referees
          EmplReferee2.SetRange(EmplReferee2."Record Type",EmplReferee2."record type"::Applicant);
          EmplReferee2.SetRange(EmplReferee2."No.","No.");
          if EmplReferee2.Find('-') then
          repeat
            EmplReferee := EmplReferee2;
            EmplReferee."Record Type" := EmplReferee."record type"::Employee;
            EmplReferee."No." := Employee."No.";
            if EmplReferee.Insert then;
          until EmplReferee2.Next = 0;
          iCount := iCount + 1;
        
          Subject := Text1010;
          Body := StrSubstNo(Text1009,Rec.FullName);
          Requestor.Get(JobVacancy."Requested By");
          UserSetup.Get(UserId);
          if Requestor."Company E-Mail" <> '' then begin
            SMTP.CreateMessage(COMPANYNAME,UserSetup."E-Mail",Requestor."Company E-Mail",Subject,Body,true);
            SMTP.Send;
          end;
        
          "Closed?" := true;
          Modify;
        until Next = 0;
        
        JobVacancy.CalcFields(JobVacancy."No. Hired");
        if JobVacancy."No. Hired" = iCount then begin
          JobVacancy."Employment Status" := JobVacancy."employment status"::Hired ;
          JobVacancy.Modify;
          InterviewHeader.Get(JobVacancy."Final Interview No.");
          InterviewHeader."Interview Closed" := true;
          InterviewHeader."Schedule Closed" := true;
          InterviewHeader.Modify;
        end;
        Window.Close;

    end;


    procedure CopyRefreefromApplicant(EmployeeNo: Code[20])
    begin
        // copy referees from applicant
        Applicant.SetRange(Applicant."Employee No.",EmployeeNo);
        if not Applicant.Find('-') then
          exit;

        EmplReferee2.SetRange(EmplReferee2."Record Type",EmplReferee2."record type"::Applicant);
        EmplReferee2.SetRange(EmplReferee2."No.",Applicant."No.");
        if EmplReferee2.Find('-') then
        repeat
          EmplReferee := EmplReferee2;
          EmplReferee."Record Type" := EmplReferee."record type"::Employee;
          EmplReferee."No." := EmployeeNo;
          EmplReferee.Insert;
        until EmplReferee2.Next = 0;
    end;
}

