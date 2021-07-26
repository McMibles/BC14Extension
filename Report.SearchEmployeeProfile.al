Report 52092348 "Search Employee Profile"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Search Employee Profile.rdlc';

    dataset
    {
        dataitem("Employee Requisition";"Employee Requisition")
        {
            DataItemTableView = sorting("No.") where("Internal/External"=filter(Internal|Both));
            column(ReportForNavId_3251; 3251)
            {
            }
            dataitem(Employee;Employee)
            {
                RequestFilterFields = "No.","Employee Category","Global Dimension 1 Code","Global Dimension 2 Code","Job Title Code","Grade Level Code","Marital Status",Gender;
                column(ReportForNavId_7528; 7528)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(3,Employee."No.");
                    if not CheckEmployee then CurrReport.Skip;
                    if Employee.Status <> Employee.Status::Active then CurrReport.Skip;

                    if iCount >= NoToAdd then CurrReport.Break;

                    if ShortListEmpl then
                    begin
                      Applicant.SetCurrentkey("Employee No.");
                      Applicant.SetRange("Employee No.",Employee."No.");
                      if Applicant.FindFirst then
                        Applicant.CopyFromEmplRec
                      else begin
                        Applicant.Init;
                        Applicant."Employee No." := Employee."No.";
                        Applicant.Insert(true);
                        Applicant.CopyFromEmplRec;
                      end;
                    end;

                    iCount := iCount + 1;
                end;

                trigger OnPreDataItem()
                begin
                    if Employee.GetFilter(Employee."Global Dimension 1 Code") = '' then
                      Employee.SetRange(Employee."Global Dimension 1 Code","Employee Requisition"."Global Dimension 1 Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Open(
                  'Employee Req. No. #1#############\' +
                  'Employee No.     #2#############\' +
                  'Line No.         #3#############\');

                Window.Update(1,"Employee Requisition"."No.");

                "Employee Requisition".CalcFields("Employee Requisition"."No. of Applicant");
                if NoToShortList <> 0 then
                  NoToAdd := NoToShortList - "Employee Requisition"."No. of Applicant"
                else
                  NoToAdd := 999999999;

                iCount := 0;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;

                Message(Text002,iCount);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ShortListEmpl;ShortListEmpl)
                {
                    ApplicationArea = Basic;
                }
                group(Requirements)
                {
                    Caption = 'Requirements';
                    field(MinAge;MinAge)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Min. Age';
                    }
                    field(MaxAge;MaxAge)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Max. Age';
                    }
                    field(NoYearofService;NoYearofService)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Yrs of Service';
                    }
                    field(QualificationCode;QualificationCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Min. Qualification';
                    }
                    field(ReqSkillCode;ReqSkillCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Req. Skill Code';
                    }
                    field(CurrJobTitle;CurrJobTitle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Current Job Title';
                    }
                    field(NoToShortList;NoToShortList)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. to Shortlist';
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

    trigger OnPreReport()
    begin
        if ShortListEmpl then
          if not Confirm(Text001,false) then
            ShortListEmpl := false;
    end;

    var
        InterviewDetail: Record "Interview Line";
        Applicant: Record Applicant;
        SkillEntry: Record "Skill Entry";
        TempSkillEntry: Record "Skill Entry" temporary;
        JobSkillEntry: Record "Skill Entry";
        EmpQualification: Record "Employee Qualification";
        JobQualification: Record "Other Qualification";
        QualificationCode: Code[10];
        ReqSkillCode: Code[10];
        CurrJobTitle: Code[20];
        StateCode: Code[10];
        LGCode: Code[10];
        MinAge: Integer;
        MaxAge: Integer;
        Age: Integer;
        NoYearofService: Integer;
        JobSkillCount: Integer;
        NoToAdd: Integer;
        NoToShortList: Integer;
        SerialNo: Integer;
        iCount: Integer;
        ShortListEmpl: Boolean;
        Qualified: Boolean;
        Window: Dialog;
        Text001: label 'Are you sure you want to short-List candidate(s)?';
        Text002: label '%1 no of employees were short-listed!';
        Gender: Option " ",Female,Male;


    procedure CheckEmployee(): Boolean
    begin
        // already short-listed
        Applicant.SetRange(Applicant."Position Desired","Employee Requisition"."No.");
        Applicant.SetRange(Applicant."Internal/External",Applicant."internal/external"::Internal);
        Applicant.SetRange(Applicant."Employee No.",Employee."No.");
        if Applicant.Find('-') then
          exit (false);

        // use delimitations
        // Age
        if (MinAge <> 0) or (MaxAge <> 0) then begin
          if Employee."Birth Date" = 0D then CurrReport.Skip;
          Age := Date2dmy("Employee Requisition"."Open Date",3) - Date2dmy(Employee."Birth Date",3);
          if ((MinAge <> 0) and (Age < MinAge)) or ((MaxAge <> 0) and (Age > MaxAge)) then exit(false);
        end;

        // Year of Service
        if NoYearofService <> 0 then begin
          if Employee."Employment Date" = 0D then
            exit(false);
          if NoYearofService > (Date2dmy("Employee Requisition"."Open Date",3) -
             Date2dmy(Employee."Employment Date",3)) then
            exit(false);
        end;

        // Current Job Title
        if Employee."Job Title Code" <> CurrJobTitle then
          exit(false);

        //Gender
        if Gender <> 0 then begin
          if Employee.Gender <> Gender then
            exit(false);
        end;
        //State
        if StateCode <> '' then begin
          if Employee."State Code" <> StateCode then
            exit(false);
        end;
        //Local Govt.
        if LGCode <> '' then begin
          if Employee."LG Code" <> LGCode then
            exit(false);
        end;

        // Required Skill
        JobSkillEntry.SetRange(JobSkillEntry."Record Type",JobSkillEntry."record type"::Vacancy);
        JobSkillEntry.SetRange("No.","Employee Requisition"."No.");
        JobSkillCount := JobSkillEntry.Count;
        if JobSkillEntry.FindFirst then begin
          repeat
            SkillEntry.SetRange(SkillEntry."Record Type",SkillEntry."record type"::Employee);
            SkillEntry.SetRange(SkillEntry."No.",Employee."No.");
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
        JobQualification.SetRange("No.","Employee Requisition"."No.");
        if JobQualification.FindFirst then begin
          repeat
            EmpQualification.SetRange("Employee No.",Employee."No.");
            EmpQualification.SetRange("Qualification Code",JobQualification."Qualification Code");
            if JobQualification."Course Code" <> '' then
              EmpQualification.SetRange("Course Code",JobQualification."Course Code");
            if JobQualification."Course Grade" <> '' then
              EmpQualification.SetRange("Course Grade",JobQualification."Course Grade");
            if EmpQualification.FindFirst then
              Qualified := true;
          until (JobQualification.Next = 0) or  Qualified;

          exit(Qualified);
        end;

        exit (true);
    end;


    procedure SetRequirement(JobRefNo: Code[10])
    var
        JobVacancy: Record "Employee Requisition";
    begin
        if JobRefNo = '' then exit;
        JobVacancy.Get(JobRefNo);
        MinAge := JobVacancy."Min. Age Limit";
        MaxAge := JobVacancy."Max. Age Limit";
        QualificationCode := JobVacancy."Min. Qualification";
        ReqSkillCode := JobVacancy."Req. Skill Code";
        NoYearofService := JobVacancy."Min. Working Experience";
        NoToShortList := JobVacancy."No. Required";
        StateCode := JobVacancy."Req. State Code" ;
        LGCode := JobVacancy."Req. LG";
        Gender := JobVacancy."Req. Gender";
    end;
}

