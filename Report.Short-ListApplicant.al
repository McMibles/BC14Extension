Report 52092341 "Short-List Applicant"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Interview Header";"Interview Header")
        {
            DataItemTableView = sorting("No.");
            column(ReportForNavId_7262; 7262)
            {
            }
            dataitem("Interview Line";"Interview Line")
            {
                DataItemTableView = sorting("Score %") order(descending);
                RequestFilterFields = "Applicant No.",Status,Selection,"Score %",Performance;
                RequestFilterHeading = 'Previous Interview';
                column(ReportForNavId_3473; 3473)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(3,Applicant."No.");
                    Applicant.Get("Interview Line"."Applicant No.");

                    if iCount >= NoToAdd then CurrReport.Break;

                    begin
                      InterviewLine.Init;
                      InterviewLine."Interview No." := "Interview Header"."No.";
                      if InterviewLine2.Find('+') then
                        InterviewLine."Line No." := InterviewLine2."Line No." + 10000
                      else
                        InterviewLine."Line No." := 10000;
                      Window.Update(2,InterviewLine."Line No.");
                      InterviewLine.Validate("Emp. Requisition Code","Interview Header"."Emp. Requisition Code");
                      InterviewLine.Validate("Applicant No.",Applicant."No.");
                      InterviewLine.Date := "Interview Header"."Interview Date";
                      InterviewLine.Time := "Interview Header"."Interview Time";
                      InterviewLine.Stage := "Interview Header".Stage;
                      InterviewLine.Level := "Interview Header".Level;
                      InterviewLine.Insert;
                      iCount := iCount + 1;
                    end;

                    "Interview Line".Selection := "Interview Line".Selection::"Next Interview";
                    "Interview Line".Modify;
                end;

                trigger OnPreDataItem()
                begin
                    if "Interview Header".Stage = "Interview Header".Stage::First then
                      CurrReport.Break;

                    "Interview Line".SetRange("Interview Line"."Interview No.","Interview Header"."Prev. Interview Ref. No.");
                    "Interview Line".SetFilter("Interview Line".Selection,'%1|%2',0,2);
                end;
            }
            dataitem(Applicant;Applicant)
            {
                RequestFilterFields = "No.",City,Gender,"Search Name",Address;
                column(ReportForNavId_2840; 2840)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(3,Applicant."No.");
                    if not CheckApplicant then CurrReport.Skip;

                    if iCount >= NoToAdd then CurrReport.Break;

                    begin
                      InterviewLine.Init;
                      InterviewLine."Interview No." := "Interview Header"."No.";
                      if InterviewLine2.Find('+') then
                        InterviewLine."Line No." := InterviewLine2."Line No." + 10000
                      else
                        InterviewLine."Line No." := 10000;
                      Window.Update(2,InterviewLine."Line No.");
                      InterviewLine.Validate("Applicant No.",Applicant."No.");
                      InterviewLine.Validate("Emp. Requisition Code","Interview Header"."Emp. Requisition Code");
                      InterviewLine.Date := "Interview Header"."Interview Date";
                      InterviewLine.Time := "Interview Header"."Interview Time";
                      InterviewLine.Stage := "Interview Header".Stage;
                      InterviewLine.Level := "Interview Header".Level;
                      InterviewLine.Insert;
                      iCount := iCount + 1;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if "Interview Header".Stage <> "Interview Header".Stage::First then
                      CurrReport.Break;

                    Applicant.SetFilter(Applicant.Status,'%1|%2|%3',0,2,5);
                    if not InclAllApplicant then
                      Applicant.SetRange(Applicant."Position Desired","Interview Header"."Emp. Requisition Code")
                    else
                      Applicant.SetRange(Applicant."Position Desired");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Open(
                  'Interview Ref. No. #1#############\' +
                  'Applicant No.      #2#############\' +
                  'Line No.           #3#############\');

                Window.Update(1,"Interview Header"."No.");
                InterviewLine2.SetRange("Interview No.","Interview Header"."No.");

                "Interview Header".CalcFields("Interview Header"."No. Short-Listed");
                NoToAdd := "Interview Header"."No. to Interview" - "Interview Header"."No. Short-Listed";
                iCount := 0;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                if iCount <> 0 then begin
                  JobVacancy.Get("Interview Header"."Emp. Requisition Code");
                  JobVacancy."Employment Status" := JobVacancy."employment status"::Interviewing;
                  JobVacancy.Modify;
                end;
                Message(Text001,iCount);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Requirements)
                {
                    Caption = 'Requirements';
                    group(AgeLimit)
                    {
                        Caption = 'Age Limit';
                        field(MinAge;MinAge)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Min Age Limit';
                        }
                        field(MaxAge;MaxAge)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Max Age Limit';
                        }
                    }
                    field(NoYearofService;NoYearofService)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Year of Service';
                    }
                    field(StateCode;StateCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Req. State';
                    }
                    field(LGCode;LGCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Req. LG';
                    }
                    field(Gender;Gender)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Req. Gender';
                    }
                    field(InterviewRefNo;InterviewRefNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Previous Interview';
                        TableRelation = "Interview Header";
                    }
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
        InterviewLine: Record "Interview Line";
        InterviewLine2: Record "Interview Line";
        SkillEntry: Record "Skill Entry";
        TempSkillEntry: Record "Skill Entry" temporary;
        JobSkillEntry: Record "Skill Entry";
        Qualification: Record Qualification;
        Qualification2: Record Qualification;
        AppQualification: Record "Other Qualification";
        JobQualification: Record "Other Qualification";
        JobVacancy: Record "Employee Requisition";
        QualificationCode: Code[20];
        ReqSkillCode: Code[20];
        InterviewRefNo: Code[20];
        StateCode: Code[10];
        LGCode: Code[10];
        MinAge: Integer;
        MaxAge: Integer;
        Age: Integer;
        NoYearofService: Integer;
        JobSkillCount: Integer;
        Gender: Option " ",Female,Male;
        NoToAdd: Integer;
        iCount: Integer;
        InclAllApplicant: Boolean;
        Qualified: Boolean;
        Window: Dialog;
        Text001: label '%1 no of applicants were short-listed!';


    procedure CheckApplicant(): Boolean
    begin
        // already short-listed
        InterviewLine2.SetRange(InterviewLine2."Applicant No.",Applicant."No.");
        if InterviewLine2.Find('-') then begin
          InterviewLine2.SetRange(InterviewLine2."Applicant No.");
          exit (false);
        end;
        InterviewLine2.SetRange(InterviewLine2."Applicant No.");

        // use delimitations
        // Age
        if (MinAge <> 0) or (MaxAge <> 0) then begin
          if Applicant."Birth Date" = 0D then CurrReport.Skip;
          Age := Date2dmy("Interview Header"."Interview Date",3) - Date2dmy(Applicant."Birth Date",3);
          if ((MinAge <> 0) and (Age < MinAge)) or ((MaxAge <> 0) and (Age > MaxAge)) then exit(false);
        end;

        // Year of Service
        if NoYearofService <> 0 then begin
          if Applicant."Post Qualification Empl Date" = 0D then
            exit(false);
          if NoYearofService > (Date2dmy("Interview Header"."Interview Date",3) -
             Date2dmy(Applicant."Post Qualification Empl Date",3)) then
            exit(false);
        end;

        //Gender
        if Gender <> 0 then begin
          if Applicant.Gender <> Gender then
            exit(false);
        end;
        //State
        if StateCode <> '' then begin
          if Applicant."State Code" <> StateCode then
            exit(false);
        end;
        //Local Govt.
        if LGCode <> '' then begin
          if Applicant."LG Code" <> LGCode then
            exit(false);
        end;


        // Required Skill
        JobSkillEntry.SetRange(JobSkillEntry."Record Type",JobSkillEntry."record type"::Vacancy);
        JobSkillEntry.SetRange("No.","Interview Header"."Emp. Requisition Code");
        JobSkillCount := JobSkillEntry.Count;
        if JobSkillEntry.FindFirst then begin
          repeat
            SkillEntry.SetRange(SkillEntry."Record Type",SkillEntry."record type"::Applicant);
            SkillEntry.SetRange(SkillEntry."No.",Applicant."No.");
            SkillEntry.SetRange(SkillEntry."Skill Code",JobSkillEntry."Skill Code");
            if SkillEntry.FindFirst then begin
              TempSkillEntry := SkillEntry;
              TempSkillEntry.Insert;
            end;
          until JobSkillEntry.Next = 0;
          if TempSkillEntry.Count <> JobSkillCount then
            exit(false);
        end;


        //Required Qualification
        Qualified := false;
        JobQualification.SetRange("Record Type",JobQualification."record type"::Vacancy);
        JobQualification.SetRange("No.","Interview Header"."Emp. Requisition Code");
        if JobQualification.FindFirst then begin
          repeat
            AppQualification.SetRange("Record Type",AppQualification."record type"::Applicant);
            AppQualification.SetRange("No.",Applicant."No.");
            AppQualification.SetRange("Qualification Code",JobQualification."Qualification Code");
            if JobQualification."Course Code" <> '' then
              AppQualification.SetRange("Course Code",JobQualification."Course Code");
            if JobQualification."Course Grade" <> '' then
              AppQualification.SetRange("Course Grade",JobQualification."Course Grade");
            if AppQualification.FindFirst then
              Qualified := true;
          until (JobQualification.Next = 0) or  Qualified;

          exit(Qualified);
        end;
        exit (true);
    end;


    procedure SetRequirement(JobRefNo: Code[20])
    begin
        if JobRefNo = '' then exit;
        JobVacancy.Get(JobRefNo);
        MinAge := JobVacancy."Min. Age Limit";
        MaxAge := JobVacancy."Max. Age Limit";
        QualificationCode := JobVacancy."Min. Qualification";
        ReqSkillCode := JobVacancy."Req. Skill Code";
        NoYearofService := JobVacancy."Min. Working Experience";
        StateCode := JobVacancy."Req. State Code" ;
        LGCode := JobVacancy."Req. LG";
        Gender := JobVacancy."Req. Gender";
    end;
}

