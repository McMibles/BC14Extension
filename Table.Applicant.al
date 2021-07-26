Table 52092199 Applicant
{
    DrillDownPageID = "Applicant List";
    LookupPageID = "Applicant List";

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2;"First Name";Text[30])
        {
            Caption = 'First Name';
        }
        field(3;"Middle Name";Text[30])
        {
            Caption = 'Middle Name';
        }
        field(4;"Last Name";Text[30])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec."Last Name")) or ("Search Name" = '') then
                  "Search Name" := "Last Name";

                if Status = Status::Hired then
                  Error(Text003,FieldName("Last Name"));
            end;
        }
        field(5;Initials;Text[30])
        {
            Caption = 'Initials';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Initials)) or ("Search Name" = '') then
                  "Search Name" := Initials;
            end;
        }
        field(7;"Search Name";Code[50])
        {
            Caption = 'Search Name';
            Editable = false;
        }
        field(8;Address;Text[50])
        {
            Caption = 'Address';
        }
        field(9;"Address 2";Text[50])
        {
            Caption = 'Address 2';
        }
        field(10;City;Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(11;"Post Code";Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code");
            end;
        }
        field(12;County;Text[30])
        {
            Caption = 'County';
        }
        field(13;"Phone No.";Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(14;"Mobile Phone No.";Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(15;"E-Mail";Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(16;"Alt. Address Code";Code[10])
        {
            Caption = 'Alt. Address Code';
            TableRelation = "Alternative Address".Code where ("Employee No."=field("No."));
        }
        field(17;"Alt. Address Start Date";Date)
        {
            Caption = 'Alt. Address Start Date';
        }
        field(18;"Alt. Address End Date";Date)
        {
            Caption = 'Alt. Address End Date';
        }
        field(19;Picture;Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(20;"Birth Date";Date)
        {
            Caption = 'Birth Date';
        }
        field(21;"Social Security No.";Text[30])
        {
            Caption = 'Social Security No.';
        }
        field(24;Gender;Option)
        {
            Caption = 'Gender';
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(25;"Country/Region Code";Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(27;"Emplymt. Contract Code";Code[10])
        {
            Caption = 'Emplymt. Contract Code';
            TableRelation = "Employment Contract";
        }
        field(51;Title;Text[30])
        {
            Caption = 'Title';
        }
        field(5000;"Position Desired";Code[20])
        {
            TableRelation = if ("Internal/External"=const(External)) "Employee Requisition" where ("Internal/External"=filter(<>Internal),
                                                                                                   Status=filter(Approved))
                                                                                                   else if ("Internal/External"=const(Internal)) "Employee Requisition" where ("Internal/External"=filter(<>External),
                                                                                                                                                                               Status=filter(Approved));

            trigger OnValidate()
            begin
                if JobVacancy.Get("Position Desired") then begin
                   "Grade Level Code" := JobVacancy."Grade Level";
                   "Salary Group" := JobVacancy."Salary Group";
                   "Expected Basic Salary" := JobVacancy."Expected Salary";
                   "Global Dimension 1 Code" := JobVacancy."Global Dimension 1 Code";
                   "Global Dimension 2 Code" := JobVacancy."Global Dimension 2 Code";
                   "Job Applied For" := JobVacancy.Description;
                   "Job Title Code" :=  JobVacancy."Job Title Code";
                end;
            end;
        }
        field(5001;Status;Option)
        {
            Editable = false;
            OptionCaption = ' ,Invited,Interviewed,Hired,Disqualified,Waiting List,To be Deleted';
            OptionMembers = " ",Invited,Interviewed,Hired,Disqualified,"Waiting List","To be Deleted";

            trigger OnValidate()
            begin
                if Status in [1,2,3] then
                  Error(Text004,Status);
            end;
        }
        field(5002;"No. Series";Code[10])
        {
        }
        field(5003;"Employee No.";Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Employee.Get("Employee No.") then begin
                  if Employee.Status <> Employee.Status::Active then
                    if not Confirm(Text005,false,Employee.Status) then
                      Error(Text006);
                  if (xRec."Employee No." <> "Employee No.") then begin
                    if xRec."Employee No." <> '' then
                      if not Confirm(Text007,false,"Employee No.") then
                        Error(Text008);
                        CopyFromEmplRec;
                  end;
                end;
            end;
        }
        field(5004;"Job Applied For";Text[50])
        {
        }
        field(5005;"Internal/External";Option)
        {
            Editable = false;
            OptionCaption = 'External,Internal';
            OptionMembers = External,Internal;
        }
        field(5006;"Date Received";Date)
        {
        }
        field(5007;"Current  Appointment";Text[40])
        {
        }
        field(5008;"Current Appointment Date";Date)
        {
        }
        field(5009;"Current Basic Salary";Decimal)
        {
        }
        field(5010;"Final Interview Ref. No.";Code[20])
        {
            TableRelation = "Interview Header" where ("Emp. Requisition Code"=field("Position Desired"));
        }
        field(5011;"Confirmed (Y/N)";Boolean)
        {
        }
        field(5012;"Closed?";Boolean)
        {
        }
        field(5013;Show;Boolean)
        {

            trigger OnValidate()
            begin
                Show:=true;
            end;
        }
        field(5014;"User ID";Code[50])
        {
        }
        field(5015;"Empl. Job Ref. No.";Code[20])
        {
            TableRelation = "Employee Requisition";

            trigger OnValidate()
            begin
                if JobVacancy.Get("Empl. Job Ref. No.") then begin
                  "Grade Level Code" := JobVacancy."Grade Level";
                  "Expected Basic Salary":= JobVacancy."Expected Salary";
                  "Global Dimension 1 Code" := JobVacancy."Global Dimension 1 Code";
                  "Global Dimension 2 Code" := JobVacancy."Global Dimension 2 Code";
                  "Probation Period" := JobVacancy."Probation Period";
                  "Job Title Code"  := JobVacancy."Job Title Code";
                  "Employee Category" :=  JobVacancy."Employee Category";
                  Applicant."Salary Group" := JobVacancy."Salary Group";
                end;
            end;
        }
        field(5016;"Expected Basic Salary";Decimal)
        {
        }
        field(5017;"Current Department";Code[20])
        {
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(5018;"Current Unit";Code[20])
        {
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(5019;"Current Grade Level";Code[20])
        {
        }
        field(5020;"Grade Level Code";Code[20])
        {
            TableRelation = "Grade Level";

            trigger OnValidate()
            begin
                GradeLevel.Get("Grade Level Code");
                "Employee Category":= GradeLevel."Employee Category";
            end;
        }
        field(5021;"Probation Period";DateFormula)
        {
        }
        field(5022;"Current Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(5023;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(5024;"Current Job Title Code";Code[20])
        {
            Caption = 'Job Title';
            TableRelation = "Job Title";
        }
        field(5025;"Job Title Code";Code[20])
        {
            Caption = 'Job Title';
            TableRelation = "Job Title";
        }
        field(5026;"Date Assumed";Date)
        {
            Caption = 'Employment Date';
        }
        field(5027;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(5028;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(5029;"Manager No.";Code[20])
        {
            Caption = 'Manager No.';
            TableRelation = Employee;
        }
        field(5030;"Current Salary Group";Code[20])
        {
            TableRelation = "Payroll-Employee Group Header";
        }
        field(5031;"Salary Group";Code[20])
        {
            TableRelation = "Payroll-Employee Group Header";
        }
        field(52092191;"Marital Status";Option)
        {
            OptionCaption = ' ,Single,Married,Separated,Widowed';
            OptionMembers = " ",Single,Married,Separated,Widowed;
        }
        field(52092206;"Blood Group";Option)
        {
            OptionMembers = " ",A,B,AB,O;
        }
        field(52092207;Genotype;Option)
        {
            OptionMembers = " ",AA,AS,SS,Others;
        }
        field(52092208;"Height (m)";Decimal)
        {
        }
        field(52092209;"Fitness (%)";Decimal)
        {
        }
        field(52092210;"Post Qualification Empl Date";Date)
        {
        }
        field(52092215;"Previous Employee No.";Code[20])
        {

            trigger OnValidate()
            begin
                if Employee.Get("Previous Employee No.") then
                  Employee.TestField(Status,Employee.Status::Terminated);
            end;
        }
        field(52092221;"State Code";Code[10])
        {
            TableRelation = State;
        }
        field(52092222;"LG Code";Code[10])
        {
            TableRelation = State.Code where ("Record Type"=const(LG));
        }
        field(52092223;Religion;Option)
        {
            OptionCaption = ' ,Christianity,Islamic,Traditional,Others';
            OptionMembers = " ",Christianity,Islamic,Traditional,Others;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
        key(Key2;"Search Name")
        {
        }
        key(Key3;"Position Desired")
        {
        }
        key(Key4;"Internal/External")
        {
        }
        key(Key5;Status)
        {
        }
        key(Key6;"First Name","Last Name")
        {
        }
        key(Key7;"Employee No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.","First Name","Last Name")
        {
        }
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
          UserSetup.Get(UserId);
          if "Internal/External" = "internal/external"::Internal then begin
            UserSetup.TestField("Employee No.");
            Applicant.SetRange(Applicant."Employee No.",UserSetup."Employee No.");
            if Applicant.Find('-') then
              Error(Text001,Applicant."No.");
          end;
          HumanResSetup.Get;
          HumanResSetup.TestField(HumanResSetup."Applicant Nos.");
          NoSeriesMgt.InitSeries(HumanResSetup."Applicant Nos.",xRec."No. Series",0D,"No.","No. Series");
        end;
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        if "Closed?" then Error(Text002);
        TestField(Gender);
        TestField("First Name");
        TestField("Last Name");
        TestField(Address);
        TestField("Post Qualification Empl Date");
        if "Internal/External" = "internal/external"::Internal then begin
          TestField("Employee No.");
          TestField("Position Desired");
        end;
    end;

    var
        PostCode: Record "Post Code";
        UserSetup: Record "User Setup";
        HumanResSetup: Record "Human Resources Setup";
        Applicant: Record Applicant;
        Employee: Record Employee;
        JobVacancy: Record "Employee Requisition";
        GradeLevel: Record "Grade Level";
        EmplQualification: Record "Employee Qualification";
        ApplicantQualification: Record "Other Qualification";
        EmplHistory: Record "Employment History";
        ApplicantHistory: Record "Employment History";
        EmpSkillEntry: Record "Skill Entry";
        AppSkillEntry: Record "Skill Entry";
        PayrollMgt: Codeunit "Payroll-Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Country: Record "Country/Region";
        Text001: label 'You already have an Applicant No. %1, New one cannot be created';
        Text002: label 'Closed Applicant cannot be modified!';
        Text003: label '%1 cannot be changed!';
        Text004: label '%1 Manual entry not allowed!';
        Text005: label 'Employee Status is %1!\Are you sure you want to continue?';
        Text006: label 'Employee Status not correct!';
        Text007: label 'Are you sure you want to change employee no. to?';
        Text008: label 'Employee No. can not be changed!';
        EmpGrpEffectiveDate: Date;


    procedure FullName(): Text[100]
    begin
        if Initials = '' then
          exit("First Name" + ' ' + "Last Name")
        else
          exit("First Name" + ' ' + Initials + ' ' + "Last Name");
    end;


    procedure AssistEdit(OldApplicant: Record Applicant): Boolean
    begin
        with Applicant do begin
          Applicant := Rec;
          HumanResSetup.Get;
          HumanResSetup.TestField("Applicant Nos.");
          if NoSeriesMgt.SelectSeries(HumanResSetup."Applicant Nos.",OldApplicant."No. Series","No. Series") then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Applicant Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Applicant;
            exit(true);
          end;
        end;
    end;


    procedure CopyFromEmplRec()
    var
        ApplicantNo: Code[20];
    begin
        // copies fields from employee record
        begin
          Employee.Get("Employee No.");
          ApplicantNo := "No.";
          TransferFields(Employee);
          "No." := ApplicantNo;
          "Current  Appointment" := Employee.Designation;
          "Current Appointment Date" := Employee."Employment Date";
          "Current Department" := Employee."Global Dimension 1 Code";
          "Current Unit" := Employee."Global Dimension 2 Code" ;
          "Current Grade Level" := Employee."Grade Level Code";
          PayrollMgt.GetSalaryStructure("Employee No.",Today,"Current Salary Group","Current Basic Salary",EmpGrpEffectiveDate);
          "Current Employee Category" := Employee."Employee Category";
          "Current Job Title Code"  := Employee."Job Title Code";
          "Internal/External" := "internal/external"::Internal;
          "Date Received" := Today;
          //MODIFY;
          // Copy Employee Qualifications
          EmplQualification.SetRange(EmplQualification."Employee No.","Employee No.");
          if EmplQualification.Find('-') then
          repeat
            ApplicantQualification."Record Type" := ApplicantQualification."record type"::Applicant;
            ApplicantQualification."No." := EmplQualification."Employee No.";
            ApplicantQualification."Line No." := EmplQualification."Line No.";
            ApplicantQualification."Qualification Code" := EmplQualification."Qualification Code";
            ApplicantQualification."From Date" := EmplQualification."From Date";
            ApplicantQualification."To Date" := EmplQualification."To Date";
            ApplicantQualification.Type := EmplQualification.Type;
            ApplicantQualification.Description := EmplQualification.Description;
            ApplicantQualification."Institution/Company" := EmplQualification."Institution/Company";
            ApplicantQualification."Course Grade" := EmplQualification."Course Grade";
            ApplicantQualification."Expiration Date" := EmplQualification."Expiration Date";
            ApplicantQualification."Course Code" := EmplQualification."Course Grade";
            if not ApplicantQualification.Insert then;
          until EmplQualification.Next = 0;

          // copies Skills
          EmpSkillEntry.SetRange(EmpSkillEntry."Record Type",EmpSkillEntry."record type"::Employee);
          EmpSkillEntry.SetRange("No.", "Employee No.");
          if EmpSkillEntry.Find('-') then
            repeat
              AppSkillEntry := EmpSkillEntry;
              AppSkillEntry."Record Type" := AppSkillEntry."record type"::Applicant;
              AppSkillEntry."No." := "No." ;
              if not(AppSkillEntry.Insert) then;
           until EmpSkillEntry.Next = 0;

          // employment history
          EmplHistory.SetRange(EmplHistory."Record Type",EmplHistory."record type"::Employee);
          EmplHistory.SetRange(EmplHistory."No.","Employee No.");
          if EmplHistory.Find('-') then
          repeat
            ApplicantHistory := EmplHistory;
            ApplicantHistory."Record Type" := ApplicantHistory."record type"::Applicant;
            ApplicantHistory."No." := "No.";
            if not ApplicantHistory.Insert then;
          until EmplHistory.Next = 0;

        end;
    end;


    procedure CopyToEmplRec(var Employee: Record Employee)
    var
        EmployeeNo: Code[20];
    begin
        // copies fields from employee record
        begin
          EmployeeNo := Employee."No.";
          Employee.TransferFields(Rec);
          Employee."No." := EmployeeNo;
          Employee.Validate(Employee."Job Title Code","Job Title Code");
          Employee.Validate(Employee."Grade Level Code","Grade Level Code");
          Employee."Global Dimension 1 Code" := "Global Dimension 1 Code";
          Employee."Global Dimension 2 Code" := "Global Dimension 2 Code";
          Employee."Employment Date" := "Date Assumed";
          Employee."Current Appointment Date" := "Date Assumed";
          Employee."Manager No." := "Manager No.";
          if Format("Probation Period") <> '' then begin
            Employee."Probation Period" := "Probation Period";
            Employee."Employment Status" := Employee."employment status"::Probation;
            Employee."Confirmation Due Date" := CalcDate(Format("Probation Period"),"Date Assumed");
           end;
          Employee.Modify;

          // Copy Applicant Qualifications
          ApplicantQualification.SetRange("Record Type",ApplicantQualification."record type"::Applicant);
          ApplicantQualification.SetRange(ApplicantQualification."No.","No.");
          if ApplicantQualification.Find('-') then
          repeat
            EmplQualification."Employee No." := Employee."No.";
            EmplQualification."Line No." := ApplicantQualification."Line No.";
            EmplQualification."Qualification Code" := ApplicantQualification."Qualification Code";
            EmplQualification."From Date" := ApplicantQualification."From Date";
            EmplQualification."To Date" := ApplicantQualification."To Date";
            EmplQualification.Type := ApplicantQualification.Type;
            EmplQualification.Description := ApplicantQualification.Description;
            EmplQualification."Institution/Company" := ApplicantQualification."Institution/Company";
            EmplQualification."Course Grade" := ApplicantQualification."Course Code";
            EmplQualification."Expiration Date" := ApplicantQualification."Expiration Date" ;
            EmplQualification."Course Grade" := ApplicantQualification."Course Code";
            if not EmplQualification.Insert then;
          until ApplicantQualification.Next = 0;

          // copies Skills
          AppSkillEntry.SetRange("Record Type",AppSkillEntry."record type"::Employee);
          AppSkillEntry.SetRange("No.", "No.");
          if AppSkillEntry.Find('-') then
            repeat
              EmpSkillEntry := AppSkillEntry;
              EmpSkillEntry."Record Type" := EmpSkillEntry."record type"::Employee;
              EmpSkillEntry."No." := Employee."No.";
              if not(EmpSkillEntry.Insert) then;
           until AppSkillEntry.Next = 0;


          // employment history
          ApplicantHistory.SetRange("Record Type",ApplicantHistory."record type"::Applicant);
          ApplicantHistory.SetRange(ApplicantHistory."No.","No.");
          if ApplicantHistory.Find('-') then
          repeat
            EmplHistory := ApplicantHistory;
            EmplHistory."Record Type" := EmplHistory."record type"::Employee;
            EmplHistory."No." := Employee."No.";
            if not EmplHistory.Insert then;
          until ApplicantHistory.Next = 0;

        end;
    end;
}

