Table 52092231 "Employee Update Line"
{

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Employee No.";Code[20])
        {
            TableRelation = Employee where (Status=filter(<>Terminated));

            trigger OnValidate()
            begin
                Employee.Get("Employee No.");
                if Employee."Termination Date" <> 0D then
                  if Employee."Termination Date" <= "Effective Date"  then
                    Error(Text001,Employee."Termination Date");

                "Employee Name":= Employee.FullName;
                "Grade Level" := Employee."Grade Level Code";
                PayrollMgt.GetSalaryStructure("Employee No.",WorkDate,"Salary Group","Gross Salary",EmpGrpEffectiveDate);
                "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                "Job Title Code" := Employee."Job Title Code";
                Description := Employee.Designation;
                Category := Employee."Employee Category";
            end;
        }
        field(3;"Employee Name";Text[50])
        {
        }
        field(4;"Grade Level";Code[10])
        {
            TableRelation = "Grade Level";
        }
        field(5;"Effective Date";Date)
        {
        }
        field(6;"New Grade Level";Code[10])
        {
            TableRelation = "Grade Level";

            trigger OnValidate()
            begin
                if "New Grade Level" <> '' then begin
                  GradeLevel.Get("New Grade Level");
                  if GradeLevel."Salary Group" <> '' then begin
                    PayrollSetup.Get;
                    PayrollSetup.TestField(PayrollSetup."Annual Gross Pay E/D Code");
                    EmployeeGrpLines.Get(GradeLevel."Salary Group",PayrollSetup."Annual Gross Pay E/D Code");
                    Validate("New Gross Salary",EmployeeGrpLines."Default Amount");
                    "New Salary Group" := GradeLevel."Salary Group";
                  end;
                end;
            end;
        }
        field(7;"Gross Salary";Decimal)
        {
        }
        field(8;"Increment %";Decimal)
        {

            trigger OnValidate()
            begin
                Employee.Get("Employee No.");
                "New Gross Salary" := "Gross Salary" + ("Gross Salary" * "Increment %" / 100);
            end;
        }
        field(9;"New Gross Salary";Decimal)
        {

            trigger OnValidate()
            begin
                Employee.Get("Employee No.");
                if "Gross Salary" <> 0  then
                  "Increment %" := (100 * ("New Gross Salary" - "Gross Salary")) / "Gross Salary";
            end;
        }
        field(10;"User ID";Code[50])
        {
            TableRelation = User;
        }
        field(12;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(13;"New Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(14;"Line No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Entry Type";Option)
        {
            OptionCaption = 'Promotion,Transfer,Salary Change,Upgrading,Redesignation,Redesignation/Transfer';
            OptionMembers = Promotion,Transfer,"Salary Change",Upgrading,Redesignation,"Redesignation/Transfer";
        }
        field(16;Description;Text[50])
        {
        }
        field(17;"Job Title Code";Code[20])
        {
            TableRelation = "Job Title";
        }
        field(18;"New Job Title";Code[20])
        {
            TableRelation = "Job Title";

            trigger OnValidate()
            begin
                if "New Job Title" <> '' then begin
                  JobTitle.Get("New Job Title");
                  JobTitle.TestField(JobTitle."Title/Description");
                  JobTitle.TestField(Blocked,false);
                  if (JobTitle."Global Dimension 2 Code" <> '') and (JobTitle."Global Dimension 2 Code" <> "Global Dimension 2 Code") then
                    if Confirm('Do you want to Change the %1 to %2?',
                               false,FieldCaption("Global Dimension 2 Code"),JobTitle."Global Dimension 2 Code") then
                      "New Global Dimension 1 Code" := JobTitle."Global Dimension 1 Code";
                  "New Designation" := JobTitle.Designation;
                  "New Category" := JobTitle."Employee Category";
                  "New Grade Level" := JobTitle."Grade Level Code";
                  Validate("New Grade Level","New Grade Level");
                end;
            end;
        }
        field(19;"New Designation";Text[50])
        {
        }
        field(20;"New Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(21;"Recommended By";Code[50])
        {
            TableRelation = Employee where (Status=filter(<>Terminated));

            trigger OnValidate()
            begin
                if not Employee.Get("Recommended By") then
                  if not Confirm(Text004,false) then
                    Error(Text005);
            end;
        }
        field(22;"Approved By";Code[50])
        {
            TableRelation = Employee where (Status=filter(<>Terminated));

            trigger OnValidate()
            begin
                if not Employee.Get("Approved By") then
                  if not Confirm(Text004,false) then
                    Error(Text005);
            end;
        }
        field(23;Grounds;Text[40])
        {
        }
        field(28;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(29;"New Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(30;Correction;Boolean)
        {
        }
        field(31;Category;Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(32;"Salary Group";Code[20])
        {
            TableRelation = "Payroll-Employee Group Header";
        }
        field(33;"New Salary Group";Code[20])
        {
            TableRelation = "Payroll-Employee Group Header";

            trigger OnValidate()
            begin
                if "New Salary Group" <> '' then begin
                  PayrollSetup.Get;
                  EmployeeGrpLines.Get("New Salary Group",PayrollSetup."Annual Gross Pay E/D Code");
                  Validate("New Gross Salary",EmployeeGrpLines."Default Amount");
                end;
            end;
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatusOpen
    end;

    trigger OnInsert()
    begin
        "Effective Date" := Today;
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
        TestField("Employee No.");
        Employee.Get("Employee No.");
        
        /*CASE "Entry Type" OF
         0 : BEGIN                                     // Promotion
           TESTFIELD("New Grade Level");
           TESTFIELD("New Basic Salary");
         END;
         1: BEGIN                                      // Transfer
        
           TESTFIELD("New Global Dimension 1 Code");
         END;
         2 : BEGIN                                     // Salary Change
           IF Employee."Employee Category" = '' THEN
             TESTFIELD("New Grade Level")
           ELSE
             TESTFIELD("Increment %");
         END;
         3 : BEGIN                                     // Upgrading
           TESTFIELD("New Grade Level");
           TESTFIELD("New Basic Salary");
         END;
         4: BEGIN                                      // Redesignation
           TESTFIELD("New Job Title");
         END;
         5 : BEGIN                                     // Redesignation/Transfer
        
           TESTFIELD("New Global Dimension 1 Code");
           TESTFIELD("New Job Title");
         END;
        END;
        TESTFIELD("Recommended By");
        TESTFIELD("Approved By");*/

    end;

    var
        PromotionJnlLine: Record "Employee Update Line";
        EmpUpdateHeader: Record "Employee Update Header";
        Employee: Record Employee;
        GradeLevel: Record "Grade Level";
        JobTitle: Record "Job Title";
        Text001: label 'Employee already terminated on %1!\Promotion not allowed.';
        Text002: label 'Batch already posted\New lines cannot be inserted!';
        Text003: label 'Applied %1 cannot be modified!';
        Text004: label 'Employee does not exist.Are you sure you want to continue?';
        Text005: label 'Cannot save changes';
        Text006: label 'Job Title %1 is %2!\Continue anyway?';
        Text007: label '% Job Title/Description!';
        PayrollSetup: Record "Payroll-Setup";
        EmployeeGrpLines: Record "Payroll-Employee Group Line";
        StatusCheckSuspended: Boolean;
        PayrollMgt: Codeunit "Payroll-Management";
        EmployeeGrp: Code[10];
        EmpGrpEffectiveDate: Date;


    procedure GetEmpUpdateHeader()
    begin
        TestField("Document No.");
        if ("Document No." <> EmpUpdateHeader."Document No.") then
          EmpUpdateHeader.Get("Document No.");
    end;


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
          exit;
        GetEmpUpdateHeader;
        EmpUpdateHeader.TestField(Status,EmpUpdateHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;
}

