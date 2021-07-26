Table 52092198 "Employee Requisition"
{
    DrillDownPageID = "Employee Req. List";
    LookupPageID = "Employee Req. List";

    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  HumanResSetup.Get;
                  NoSeriesMgt.TestManual(HumanResSetup."Vacancy Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;Description;Text[40])
        {
        }
        field(3;"Job Title Code";Code[20])
        {
            TableRelation = "Job Title";

            trigger OnValidate()
            begin
                JobTitle.Get("Job Title Code");
                if JobTitle.Blocked then
                  Error(Text003);

                JobTitle.TestField(JobTitle."Approved Establishment");
                JobTitle.CalcFields(JobTitle."No. of Employee");
                "Approved Establishment" := JobTitle."Approved Establishment";
                "Present No. of Employee" := JobTitle."No. of Employee";
                if ("Present No. of Employee" > "Approved Establishment") then begin
                  if not Confirm(Text004,false) then
                    Error(Text005);
                  Validate(Vacancies,0);
                end else
                  Validate(Vacancies,"Approved Establishment" - "Present No. of Employee");

                Description := JobTitle."Title/Description";
                if JobTitle.Designation <> '' then
                  Designation := JobTitle.Designation
                else
                  Designation := JobTitle."Title/Description";

                "Global Dimension 1 Code" := JobTitle."Global Dimension 1 Code";
                "Global Dimension 2 Code" := JobTitle."Global Dimension 2 Code";
                "Employee Category" := JobTitle."Employee Category";
                "Min. Working Experience" := JobTitle."Min. Working Experience";
                if (JobTitle."Grade Level Code" <> '') then
                  Validate("Grade Level",JobTitle."Grade Level Code");

                if (xRec."Job Title Code" <> "Job Title Code") then begin
                  //Remove Existing Vacancy Skill Entries
                  VacancySkillEntry.SetRange(VacancySkillEntry."Record Type",VacancySkillEntry."record type"::Vacancy);
                  VacancySkillEntry.SetRange("No.","No.");
                  VacancySkillEntry.DeleteAll;

                  //Create New Skill Entries if Job Title code is not blank
                  if "Job Title Code" <> '' then begin
                    JobTitleSkillEntry.SetRange(JobTitleSkillEntry."Record Type",JobTitleSkillEntry."record type"::"Job Title");
                    JobTitleSkillEntry.SetRange("No.","Job Title Code");
                    if JobTitleSkillEntry.FindFirst then
                      repeat
                        VacancySkillEntry := JobTitleSkillEntry;
                        VacancySkillEntry."Record Type" := VacancySkillEntry."record type"::Vacancy;
                        VacancySkillEntry."No." :=  "No.";
                        VacancySkillEntry.Insert;
                      until JobTitleSkillEntry.Next = 0;
                  end;
                  //Remove Existing Vacancy Qualification Entries
                  VacancyQualification.SetRange("Record Type",VacancyQualification."record type"::Vacancy   );
                  VacancyQualification.SetRange("No.","No.");
                  VacancyQualification.DeleteAll;

                  //Create New Qualification Entries if Job Title code is not blank
                  if "Job Title Code" <> '' then begin
                    JobTitleQualification.SetRange("Record Type",JobTitleQualification."record type"::"Job Title");
                    JobTitleQualification.SetRange("No.","Job Title Code");
                    if JobTitleQualification.FindFirst then
                      repeat
                        VacancyQualification := JobTitleQualification;
                        VacancyQualification."Record Type" := VacancySkillEntry."record type"::Vacancy;
                        VacancyQualification."No." :=  "No.";
                        VacancyQualification.Insert;
                      until JobTitleQualification.Next = 0;
                  end;
                end;
            end;
        }
        field(4;Designation;Text[50])
        {
        }
        field(5;"Employment Type";Option)
        {
            OptionMembers = Permanent,Contract;

            trigger OnLookup()
            begin
                if "Employment Type" = "employment type"::Permanent then begin
                  "Temporary Period" := '';
                  "Emplymt. Contract Code" := '';
                end;
            end;
        }
        field(6;"Emplymt. Contract Code";Code[10])
        {
            TableRelation = "Employment Contract";

            trigger OnValidate()
            begin
                if "Emplymt. Contract Code" <> '' then
                  TestField("Employment Type","employment type"::Contract);
            end;
        }
        field(7;"Open Date";Date)
        {
        }
        field(8;"Global Dimension 1 Code";Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1),
                                                          "Dimension Value Type"=filter(<>Total));

            trigger OnValidate()
            begin
                JobTitle.Get("Job Title Code");
                if JobTitle."Global Dimension 1 Code" <> '' then
                  TestField("Global Dimension 1 Code",JobTitle."Global Dimension 1 Code");
            end;
        }
        field(9;"No. Approved";Integer)
        {
        }
        field(10;"Employment Status";Option)
        {
            Editable = false;
            OptionCaption = 'Vacant,Interviewing,Accepted Offer,Hired,Discontinued';
            OptionMembers = Vacant,Interviewing,"Accepted Offer",Hired,Discontinued;
        }
        field(11;"No. Hired";Integer)
        {
            CalcFormula = count(Applicant where ("Position Desired"=field("No."),
                                                 Status=const(Hired)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"No Interviewed";Integer)
        {
            CalcFormula = count(Applicant where ("Position Desired"=field("No."),
                                                 Status=const(Interviewed)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;"Internal/External";Option)
        {
            OptionMembers = External,Internal,Both;
        }
        field(14;"Grade Level";Code[20])
        {
            TableRelation = "Grade Level";

            trigger OnValidate()
            begin
                GradeLevel.Get("Grade Level");
                PayrollSetup.Get;
                PayrollSetup.TestField("Monthly Gross ED Code");
                GradeLevel.TestField("Salary Group");
                EmployeeGrp.Get(GradeLevel."Salary Group",PayrollSetup."Monthly Gross ED Code");
                "Salary Group" := GradeLevel."Salary Group";
                if "Expected Salary" = 0 then
                  "Expected Salary" := EmployeeGrp."Default Amount";
                if GradeLevel."Employee Category" <> '' then
                  "Employee Category" := GradeLevel."Employee Category";
            end;
        }
        field(15;"Expected Salary";Decimal)
        {
        }
        field(16;"Expected Apptmt. Date";Date)
        {
        }
        field(17;"No. of Years";Integer)
        {
            BlankZero = true;
            MinValue = 0;
        }
        field(18;"Min. Age Limit";Integer)
        {
            BlankZero = true;
            MaxValue = 60;
            MinValue = 0;
        }
        field(19;"Max. Age Limit";Integer)
        {
            BlankZero = true;
            MaxValue = 60;
            MinValue = 0;
        }
        field(20;"Min. Working Experience";Integer)
        {
            BlankZero = true;
            MinValue = 0;
        }
        field(21;"Min. Qualification";Code[10])
        {
            TableRelation = Qualification;
        }
        field(22;"No. Series";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(23;"Req. Skill Code";Code[10])
        {
            TableRelation = Skill;
        }
        field(24;"Probation Period";DateFormula)
        {
        }
        field(25;"Approved Establishment";Integer)
        {
            Editable = false;
        }
        field(26;"Present No. of Employee";Integer)
        {
            CalcFormula = count(Employee where ("Job Title Code"=field("Job Title Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27;Vacancies;Integer)
        {
            Editable = false;

            trigger OnValidate()
            begin
                Validate("No. Required",Vacancies);
            end;
        }
        field(28;"Grounds for Request Code";Code[10])
        {
        }
        field(29;"Date Filled";Date)
        {
            Editable = false;
        }
        field(30;"No. Required";Integer)
        {

            trigger OnValidate()
            begin
                if "No. Required" > Vacancies then
                  if not Confirm(Text008,false) then
                    Error(Text009);

                "No. Approved" := "No. Required";
            end;
        }
        field(32;"Nature of Request";Option)
        {
            OptionCaption = 'Additional,Replacement';
            OptionMembers = Additional,Replacement;

            trigger OnValidate()
            begin
                if "Nature of Request" = "nature of request"::Additional then begin
                  "For Whom" := '';
                  "Temporary Period" := '';
                end;
            end;
        }
        field(33;"For Whom";Text[30])
        {

            trigger OnValidate()
            begin
                TestField("Nature of Request","nature of request"::Replacement);
            end;
        }
        field(34;"Temporary Period";Code[10])
        {
            DateFormula = true;

            trigger OnValidate()
            begin
                TestField("Employment Type","employment type"::Contract);
            end;
        }
        field(35;"No. of Applicant";Integer)
        {
            CalcFormula = count(Applicant where ("Position Desired"=field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(36;"Global Dimension 2 Code";Code[10])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2),
                                                          "Dimension Value Type"=filter(<>Total));

            trigger OnValidate()
            begin
                JobTitle.Get("Job Title Code");
                if JobTitle."Global Dimension 2 Code" <> '' then
                  TestField("Global Dimension 2 Code",JobTitle."Global Dimension 2 Code");
            end;
        }
        field(37;"Employee Category";Code[10])
        {
            Editable = false;
            TableRelation = "Employee Category";
        }
        field(38;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Discontinued';
            OptionMembers = Open,Approved,"Pending Approval",Discontinued;
        }
        field(39;"Req. State Code";Code[10])
        {
            TableRelation = State.Code where ("Record Type"=const(State));
        }
        field(40;"Req. LG";Code[10])
        {
            TableRelation = State.Code where ("Record Type"=const(LG));
        }
        field(41;"Req. Gender";Option)
        {
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(42;"Final Interview No.";Code[20])
        {
        }
        field(43;"Salary Group";Code[20])
        {
            TableRelation = "Payroll-Employee Group Header";
        }
        field(44;"Requested By";Code[20])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(45;"Request Position";Option)
        {
            OptionCaption = 'With Requestor,With HR';
            OptionMembers = "With Requestor","With HR";
        }
        field(46;"Committed Date of Appmt.";Date)
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
          HumanResSetup.Get;
          HumanResSetup.TestField("Vacancy Nos.");
          NoSeriesMgt.InitSeries(HumanResSetup."Vacancy Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;

        "Open Date" := Today;
        UserSetup.Get(UserId);
        UserSetup.TestField(UserSetup."Employee No.");
        "Requested By" := UserSetup."Employee No.";
    end;

    trigger OnModify()
    begin
        TestField(Description);
        TestField("Job Title Code");
        TestField("Open Date");
        //IF "Request Position" = "Request Position"::"With Requestor" THEN
          //TESTFIELD(Status,Status::Open);
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        PayrollSetup: Record "Payroll-Setup";
        JobVacancy: Record "Employee Requisition";
        JobTitle: Record "Job Title";
        GradeLevel: Record "Grade Level";
        EmployeeGrp: Record "Payroll-Employee Group Line";
        Applicant: Record Applicant;
        VacancySkillEntry: Record "Skill Entry";
        JobTitleSkillEntry: Record "Skill Entry";
        VacancyQualification: Record "Other Qualification";
        JobTitleQualification: Record "Other Qualification";
        UserSetup: Record "User Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Text001: label 'Job Title currently inactive!\Continue Anyway';
        Text002: label 'Job Title not available!';
        Text003: label 'Job Title has been blocked\ Action Aborted';
        Text004: label 'Job title is already over-staffed!\Continue Anyway?';
        Text005: label 'Position is already over-staffed!';
        Text006: label 'StaFf Requisition Type cannot be changed!';
        Text007: label 'Do you want to change Grade Level on all applicants?';
        Text008: label 'No. Required is greater than Vacancies!\Continue Anyway?';
        Text009: label 'No. Required cannot be greater than Vacancies!';


    procedure AssistEdit(OldJob: Record "Employee Requisition"): Boolean
    begin
        with JobVacancy do begin
          JobVacancy := Rec;
          HumanResSetup.Get;
          HumanResSetup.TestField("Vacancy Nos.");
          if NoSeriesMgt.SelectSeries(HumanResSetup."Vacancy Nos.",OldJob."No. Series","No. Series") then
          begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Vacancy Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := JobVacancy;
            exit(true);
          end;
        end;
    end;
}

