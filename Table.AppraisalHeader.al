Table 52092223 "Appraisal Header"
{

    fields
    {
        field(1;"Appraisal Period";Code[20])
        {
        }
        field(2;"Appraisal Type";Option)
        {
            OptionMembers = "Mid Year","Year End";
        }
        field(3;"Appraisee No.";Code[20])
        {
            Editable = false;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                Employee.Get("Appraisee No.");
                if Employee."Termination Date" <> 0D then
                  if Date2dmy(Employee."Termination Date",3) <= Date2dmy("Start Date",3) then
                    Error(Text005,Employee."Termination Date");

                "First Name" := Employee."First Name";
                "Last Name" := Employee."Last Name";
                "Middle Name" := Employee."Middle Name";
                Initials := Employee.Initials;
                "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                "Employee Category" := Employee."Employee Category";
                "Grade Level Code" := Employee."Grade Level Code";
                "Manager No." := Employee."Manager No.";
                "Appraised By" :=  Employee."Manager No.";
                Designation := Employee.Designation
            end;
        }
        field(4;Category;Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(5;"Sectional Weight Score";Decimal)
        {
            CalcFormula = sum("Appraisal Lines"."Appraiser Sectional Weight" where ("Appraisal Period"=field("Appraisal Period"),
                                                                                    "Appraisal Type"=field("Appraisal Type"),
                                                                                    "Employee No."=field("Appraisee No.")));
            DecimalPlaces = 0:2;
            Description = 'Used to keep the performance scores on the appraisal lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"No. of Steps";Integer)
        {
        }
        field(7;"First Name";Text[30])
        {
            Editable = false;
        }
        field(8;"Last Name";Text[30])
        {
            Editable = false;
        }
        field(9;"Middle Name";Text[30])
        {
            Editable = false;
        }
        field(10;Initials;Code[10])
        {
            Editable = false;
        }
        field(11;Closed;Boolean)
        {
            Editable = false;
        }
        field(12;Recommendation;Option)
        {
            OptionCaption = ' ,Enhanced Salary Increase,Promotion,Upgrade,Transfer-Department,Transfer-Unit,Demotion,Termination';
            OptionMembers = " ","Enhanced Salary Increase",Promotion,Upgrade,"Transfer-Department","Transfer-Unit",Demotion,Termination;

            trigger OnValidate()
            begin
                if "Approved?" then
                  Error(Text006);
            end;
        }
        field(13;"Recommended Code";Code[10])
        {
            TableRelation = if (Recommendation=const(Promotion)) "Grade Level"
                            else if (Recommendation=const(Upgrade)) "Grade Level"
                            else if (Recommendation=const("Transfer-Department")) "Dimension Value".Code where ("Global Dimension No."=const(1))
                            else if (Recommendation=const("Transfer-Unit")) "Dimension Value".Code where ("Global Dimension No."=const(2))
                            else if (Recommendation=const(Demotion)) "Grade Level"
                            else if (Recommendation=const(Termination)) "Grounds for Termination";

            trigger OnValidate()
            begin
                if "Approved?" then
                  Error(Text006);

                Employee.Get("Appraisee No.");

                case Recommendation of
                  1:begin
                    if "Recommended Code" <> '' then
                      "Recommended Code" := ''
                  end;
                  3:begin       // Upgrade - new Grade Level
                      GradeLevel.Get("Recommended Code");
                      PayrollMgt.GetSalaryStructure("Appraisee No.",Today,EmployeeGrp,BasicSalary,EmpGrpEffectiveDate);
                      if (GradeLevel."Min. Basic Salary" <> 0) and (GradeLevel."Min. Basic Salary" < BasicSalary)
                        then
                          Error(Text007);
                  end;
                  6:begin                                  // Demotion - new Grade Level
                    GradeLevel.Get("Recommended Code");
                    PayrollMgt.GetSalaryStructure("Appraisee No.",Today,EmployeeGrp,BasicSalary,EmpGrpEffectiveDate);
                    if (GradeLevel."Min. Basic Salary" <> 0) and (GradeLevel."Min. Basic Salary" > BasicSalary)
                      then
                        Error(Text007);
                  end;
                  7 : begin  // Termination - Termination Date
                  end;
                end;
            end;
        }
        field(14;"Appraised By";Code[10])
        {
            TableRelation = Employee;
        }
        field(15;"Date Appraised";Date)
        {
            Editable = false;
        }
        field(16;"Approved?";Boolean)
        {

            trigger OnValidate()
            begin
                if xRec."Approved?"  and ("Approved By" <> UserId) then
                  Error('You are not allowed to change %1!',FieldName("Approved?"));

                if ((Recommendation <> Recommendation::" ") and ("Recommended Code" = ''))
                 then Error('There is nothing to approve');

                if ((Recommendation = Recommendation::" ")
                     or (Recommendation = Recommendation::"Enhanced Salary Increase")) then
                   TestField("Recommended Sal % Increase");

                if "Approved?" then
                  "Approved By" := UserId
                else
                  "Approved By" := '';
            end;
        }
        field(17;"Approved By";Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(18;"Recommendation Applied?";Boolean)
        {
        }
        field(19;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(20;"Employee Category";Code[10])
        {
            Editable = false;
            TableRelation = "Employee Category";
        }
        field(21;"Grade Level Code";Code[10])
        {
            Editable = false;
            Enabled = true;
            TableRelation = "Grade Level";
        }
        field(22;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(23;"Section Code";Code[20])
        {
            TableRelation = "Appraisal Section";
        }
        field(32;"Performance Score";Decimal)
        {
            CalcFormula = sum("Appraisal Lines"."Appraiser Weighted Score" where ("Employee No."=field("Appraisee No."),
                                                                                  "Appraisal Type"=field("Appraisal Type"),
                                                                                  "Appraisal Period"=field("Appraisal Period"),
                                                                                  "Section Code"=field("Section Code")));
            FieldClass = FlowField;
        }
        field(33;"Group Code";Code[20])
        {
            Editable = false;
            TableRelation = "Appraisal Template Header"."Template Code" where ("Section Code"=field("Section Code"));
        }
        field(34;"Appraiser's Comment";Text[80])
        {
        }
        field(35;"Employee's Comment";Text[80])
        {
        }
        field(36;"Reviewer's Comment";Text[80])
        {
        }
        field(37;"Appraisal Ready";Boolean)
        {
            Editable = true;
        }
        field(38;Location;Option)
        {
            OptionCaption = 'Appraisee,Appraiser';
            OptionMembers = Appraisee,Appraiser;
        }
        field(39;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";

            trigger OnValidate()
            begin
                if Status = Status::Open then
                  "Appraisal Ready" := false;
            end;
        }
        field(40;Designation;Text[50])
        {
            Editable = false;
        }
        field(41;"Appraisee Sectional Weight";Decimal)
        {
            CalcFormula = sum("Appraisal Lines"."Appraisee Sectional Weight" where ("Appraisal Period"=field("Appraisal Period"),
                                                                                    "Global Dimension 1 Code"=field("Cost Center Filter"),
                                                                                    "Global Dimension 2 Code"=field("Department Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42;"New Gross Salary";Decimal)
        {
            Editable = false;
        }
        field(60;"Recommended Sal % Increase";Decimal)
        {
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if "Recommended Sal % Increase" <> 0 then
                  if Recommendation <> Recommendation::"Enhanced Salary Increase" then
                    Error(Text010);
            end;
        }
        field(61;"Appraiser Sectional Weight";Decimal)
        {
            CalcFormula = sum("Appraisal Lines"."Appraiser Sectional Weight" where ("Appraisal Period"=field("Appraisal Period"),
                                                                                    "Global Dimension 1 Code"=field("Cost Center Filter"),
                                                                                    "Global Dimension 2 Code"=field("Department Filter")));
            FieldClass = FlowField;
        }
        field(62;"Department Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(63;"Grade Level Filter";Code[20])
        {
            Enabled = false;
            TableRelation = "Grade Level".Code;
        }
        field(64;"Cost Center Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(65;"Line Group Code";Code[30])
        {
            CalcFormula = lookup("Appraisal Lines"."Template Code" where ("Appraisal Period"=field("Appraisal Period"),
                                                                          "Appraisal Type"=field("Appraisal Type"),
                                                                          "Employee No."=field("Appraisee No."),
                                                                          "Section Code"=field("Section Code")));
            FieldClass = FlowField;
        }
        field(66;"Manager No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(67;"Recommended Sal Increase";Decimal)
        {

            trigger OnValidate()
            begin
                if "Recommended Sal Increase" <> 0 then
                  if Recommendation <> Recommendation::"Enhanced Salary Increase" then
                    Error(Text010);
            end;
        }
        field(68;"Start Date";Date)
        {
        }
        field(69;"End Date";Date)
        {
        }
        field(70;Year;Integer)
        {
        }
        field(71;"Inflation Increase";Boolean)
        {
            Editable = false;
        }
        field(72;"Notch Increase";Boolean)
        {
            Editable = false;
        }
        field(73;"Merit Increase";Boolean)
        {
            Editable = false;
        }
        field(74;"Bonus Increase";Boolean)
        {
            Editable = false;
        }
        field(75;"Appraisal Applied";Boolean)
        {
        }
        field(100;"Appraiser No.";Code[20])
        {
            TableRelation = Employee;
        }
    }

    keys
    {
        key(Key1;"Appraisal Period","Appraisal Type","Appraisee No.")
        {
            Clustered = true;
        }
        key(Key2;"Section Code")
        {
        }
        key(Key3;"Global Dimension 1 Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Closed then Error('Appraisal already applied\Record may not be deleted!');
        AppraisalLine.SetRange(AppraisalLine."Appraisal Period","Appraisal Period");
        AppraisalLine.SetRange(AppraisalLine."Appraisal Type","Appraisal Type");
        AppraisalLine.SetRange(AppraisalLine."Employee No.","Appraisee No.");
        if AppraisalLine.Find('-') then
          if not Confirm(Text002) then
            Error(Text003);

        AppraisalLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        TestField("Appraisal Period");
        TestField("Appraisee No.");
        TestField("Section Code");
        if "Appraisal Type" = "appraisal type"::"Mid Year" then
          if AppraisalHeader.Get("Appraisal Period",AppraisalHeader."appraisal type"::"Year End","Appraisee No.") then
            if AppraisalHeader.Closed then
              Error(Text001,"Appraisee No.");

        if "Appraisal Type" = "appraisal type"::"Mid Year" then
          "Date Appraised" := "End Date"
        else
          "Date Appraised" := "End Date";

        if Employee."Manager No." <> '' then
          "Appraised By" := Employee."Manager No."
    end;

    trigger OnModify()
    begin
        if not(Recommendation in [0,1]) then
          TestField("Recommended Code");
        TestField(Closed,false);
    end;

    trigger OnRename()
    begin
        Error(Text004);
    end;

    var
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        DimValue: Record "Dimension Value";
        AppraisalHeader: Record "Appraisal Header";
        AppraisalLine: Record "Appraisal Lines";
        AppraisalFactor: Record "Appraisal Template Line";
        JobTitle: Record "Job Title";
        GradeLevel: Record "Grade Level";
        AppraisalGroup: Record "Appraisal Template Header";
        TrainingAttendance: Record "Training Attendance";
        Trapper: Boolean;
        JobRef: Text[40];
        SubGroup: Text[30];
        GlobalSender: Text[80];
        Body: Text[200];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
        EmployeeGrp: Code[20];
        BasicSalary: Decimal;
        StaffCategory: Record Employee;
        Text001: label 'Year End Appraisal already applied for %1!';
        Text002: label 'Do you really want to delete record?';
        Text003: label 'Record cannot be deleted!';
        Text004: label 'Record cannot be renamed!';
        Text005: label 'Employee already terminated on %1!\Appraisal not allowed.';
        Text006: label 'Recommendation already approved!';
        Text007: label 'Incorrect Recommended Grade Level!';
        Text008: label 'Employee already scheduled/attended training!';
        Text009: label 'Recommended training not possible!';
        PayrollMgt: Codeunit "Payroll-Management";
        Text010: label 'Recommendation must be Enhanced Salary Increase';
        Text011: label 'My appraisal is ready for your processing';
        Text012: label 'Entry Already Submitted';
        Text013: label 'Complete the scoring before Submiting';
        Text014: label 'Are you sure you want to submit this entry?';
        Text015: label 'Entry successfully submitted';
        EmpGrpEffectiveDate: Date;


    procedure TransferFactor()
    begin
        AppraisalFactor.SetRange(AppraisalFactor."Appraisal Type","Appraisal Type");
        //AppraisalFactor.SETRANGE(AppraisalFactor.Cadre,Cadre);
        if not AppraisalFactor.Find('-') then
          Error('Appraisal factor not setup for %1, %2!');

        repeat
          AppraisalLine.Init;
          AppraisalLine."Appraisal Period" := "Appraisal Period";
          AppraisalLine."Appraisal Type" := "Appraisal Type";
          AppraisalLine."Employee No." := "Appraisee No.";
         // AppraisalLine.Cadre := Cadre;
          AppraisalLine.Validate("Factor Code",AppraisalFactor.Code);
          AppraisalLine.Insert;
        until AppraisalFactor.Next = 0;
    end;


    procedure CheckEmployee()
    begin
        Trapper := false;

        Employee.Get("Appraisee No.");
        AppraisalGroup.Reset;
        AppraisalGroup.SetCurrentkey("Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Section Code","Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Employee No.",Employee."No.");
        AppraisalGroup.SetRange(AppraisalGroup."Appraisal Type","Appraisal Type");
        AppraisalGroup.SetRange(AppraisalGroup.Status,AppraisalGroup.Status::Approved);

        if ((AppraisalGroup.Find('-')) and (AppraisalGroup.Find('='))) then

        Message(Format(AppraisalGroup.Count) + 'employee');
         begin
            AppraisalFactor.Reset;
            AppraisalFactor.SetRange(AppraisalFactor."Section Code",AppraisalGroup."Section Code");
            AppraisalFactor.SetRange(AppraisalFactor."Template Code",AppraisalGroup."Template Code");
            AppraisalFactor.SetRange(AppraisalFactor."Appraisal Type","Appraisal Type");
          //  MESSAGE(FORMAT(AppraisalFactor.COUNT));
             if AppraisalFactor.Find('-') then
                if Trapper = false then
                begin
                   repeat
                     AppraisalLine.Init;
                     AppraisalLine."Section Code" := "Section Code";
                     AppraisalLine."Factor Code" := AppraisalFactor.Code;
                     AppraisalLine.Weight := AppraisalFactor.Weight;
                     AppraisalLine.Description := AppraisalFactor.Description;
                     AppraisalLine."Appraisal Period"  := "Appraisal Period";
                     AppraisalLine."Appraisal Type" := "Appraisal Type";
                     AppraisalLine."Employee No." := "Appraisee No.";
                     AppraisalLine.Insert;
                   until AppraisalFactor.Next = 0;
                   Trapper := true;
                   //This will modify the group of the header
                  "Group Code" := AppraisalFactor."Template Code";
                   Modify;
                end;

         end
    end;


    procedure CheckGradeLevel()
    begin
        Employee.Get("Appraisee No.");
        AppraisalGroup.Reset;
        AppraisalGroup.SetCurrentkey("Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Section Code","Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Grade Level Code",Employee."Grade Level Code");
        AppraisalGroup.SetRange(AppraisalGroup."Appraisal Type","Appraisal Type");
        AppraisalGroup.SetRange(AppraisalGroup.Status,AppraisalGroup.Status::Approved);

        if ((AppraisalGroup.Find('-')) and (AppraisalGroup.Find('='))) then

        Message(Format(AppraisalGroup.Count) + 'gradelevel');
         begin
            AppraisalFactor.Reset;
            AppraisalFactor.SetRange(AppraisalFactor."Section Code",AppraisalGroup."Section Code");
            AppraisalFactor.SetRange(AppraisalFactor."Template Code",AppraisalGroup."Template Code");
            AppraisalFactor.SetRange(AppraisalFactor."Appraisal Type","Appraisal Type");
          //  MESSAGE(FORMAT(AppraisalFactor.COUNT));
             if AppraisalFactor.Find('-') then
                if Trapper = false then
                 begin
                   repeat
                     AppraisalLine.Init;
                     AppraisalLine."Section Code" := "Section Code";
                     AppraisalLine."Factor Code" := AppraisalFactor.Code;
                     AppraisalLine.Weight := AppraisalFactor.Weight;
                     AppraisalLine.Description := AppraisalFactor.Description;
                     AppraisalLine."Appraisal Period"  := "Appraisal Period";
                     AppraisalLine."Appraisal Type" := "Appraisal Type";
                     AppraisalLine."Employee No." := "Appraisee No.";
                     AppraisalLine.Insert;
                   until AppraisalFactor.Next = 0;
                   Trapper := true;
                   //This will modify the group of the header
                  "Group Code" := AppraisalFactor."Template Code";
                   Modify;
                end;

         end
    end;


    procedure CheckDept()
    begin
        Employee.Get("Appraisee No.");
        AppraisalGroup.Reset;
        AppraisalGroup.SetCurrentkey("Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Section Code","Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Global Dimension 2 Code",Employee."Global Dimension 2 Code");
        AppraisalGroup.SetRange(AppraisalGroup."Appraisal Type","Appraisal Type");
        AppraisalGroup.SetRange(AppraisalGroup.Status,AppraisalGroup.Status::Approved);

        if ((AppraisalGroup.Find('-')) and (AppraisalGroup.Find('='))) then

        Message(Format(AppraisalGroup.Count) + 'department');
         begin
            AppraisalFactor.Reset;
            AppraisalFactor.SetRange(AppraisalFactor."Section Code",AppraisalGroup."Section Code");
            AppraisalFactor.SetRange(AppraisalFactor."Template Code",AppraisalGroup."Template Code");
            AppraisalFactor.SetRange(AppraisalFactor."Appraisal Type","Appraisal Type");
             if AppraisalFactor.Find('-') then
                if Trapper = false then
                begin
                   repeat
                     AppraisalLine.Init;
                     AppraisalLine."Section Code" := "Section Code";
                     AppraisalLine."Factor Code" := AppraisalFactor.Code;
                     AppraisalLine.Weight := AppraisalFactor.Weight;
                     AppraisalLine.Description := AppraisalFactor.Description;
                     AppraisalLine."Appraisal Period"  := "Appraisal Period";
                     AppraisalLine."Appraisal Type" := "Appraisal Type";
                     AppraisalLine."Employee No." := "Appraisee No.";
                     AppraisalLine.Insert;
                   until AppraisalFactor.Next = 0;
                   Trapper := true;
                   //This will modify the group of the header
                  "Group Code" := AppraisalFactor."Template Code";
                   Modify;
                end;

         end
    end;


    procedure CheckGlobalDim()
    begin
        Employee.Get("Appraisee No.");
        AppraisalGroup.Reset;
        AppraisalGroup.SetCurrentkey("Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Section Code","Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Global Dimension 1 Code",Employee."Global Dimension 1 Code");
        AppraisalGroup.SetRange(AppraisalGroup."Appraisal Type","Appraisal Type");
        AppraisalGroup.SetRange(AppraisalGroup.Status,AppraisalGroup.Status::Approved);

        if ((AppraisalGroup.Find('-')) and (AppraisalGroup.Find('='))) then
        Message(Format(AppraisalGroup.Count) + 'globaldim');
         begin
            AppraisalFactor.Reset;
            AppraisalFactor.SetRange(AppraisalFactor."Section Code",AppraisalGroup."Section Code");
            AppraisalFactor.SetRange(AppraisalFactor."Template Code",AppraisalGroup."Template Code");
            AppraisalFactor.SetRange(AppraisalFactor."Appraisal Type","Appraisal Type");
             if AppraisalFactor.Find('-') then
                if Trapper = false then
                begin
                   repeat
                     AppraisalLine.Init;
                     AppraisalLine."Section Code" := "Section Code";
                     AppraisalLine."Factor Code" := AppraisalFactor.Code;
                     AppraisalLine.Weight := AppraisalFactor.Weight;
                     AppraisalLine.Description := AppraisalFactor.Description;
                     AppraisalLine."Appraisal Period"  := "Appraisal Period";
                     AppraisalLine."Appraisal Type" := "Appraisal Type";
                     AppraisalLine."Employee No." := "Appraisee No.";
                     AppraisalLine.Insert;
                   until AppraisalFactor.Next = 0;
                   Trapper := true;
                   //This will modify the group of the header
                  "Group Code" := AppraisalFactor."Template Code";
                   Modify;
                end;

         end
    end;


    procedure CheckCategory()
    begin
        Employee.Get("Appraisee No.");
        AppraisalGroup.Reset;
        AppraisalGroup.SetCurrentkey("Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Section Code","Section Code");
        /*AppraisalGroup.SETRANGE(AppraisalGroup.Cadre,Employee.Cadre);*/
        AppraisalGroup.SetRange(AppraisalGroup."Appraisal Type","Appraisal Type");
        AppraisalGroup.SetRange(AppraisalGroup.Status,AppraisalGroup.Status::Approved);
        
        if ((AppraisalGroup.Find('-')) and (AppraisalGroup.Find('='))) then
        Message(Format(AppraisalGroup.Count) + 'Category');
         begin
            AppraisalFactor.Reset;
            AppraisalFactor.SetRange(AppraisalFactor."Section Code",AppraisalGroup."Section Code");
            AppraisalFactor.SetRange(AppraisalFactor."Template Code",AppraisalGroup."Template Code");
            AppraisalFactor.SetRange(AppraisalFactor."Appraisal Type","Appraisal Type");
             if AppraisalFactor.Find('-') then
                if Trapper = false then
                begin
                   repeat
                     AppraisalLine.Init;
                     AppraisalLine."Section Code" := "Section Code";
                     AppraisalLine."Factor Code" := AppraisalFactor.Code;
                     AppraisalLine.Weight := AppraisalFactor.Weight;
                     AppraisalLine.Description := AppraisalFactor.Description;
                     AppraisalLine."Appraisal Period"  := "Appraisal Period";
                     AppraisalLine."Appraisal Type" := "Appraisal Type";
                     AppraisalLine."Employee No." := "Appraisee No.";
                     AppraisalLine.Insert;
                   until AppraisalFactor.Next = 0;
                   Trapper := true;
                   //This will modify the group of the header
                  "Group Code" := AppraisalFactor."Template Code";
                   Modify;
                end;
        
         end

    end;


    procedure CheckJobTitle()
    begin
        Employee.Get("Appraisee No.");
        AppraisalGroup.Reset;
        AppraisalGroup.SetCurrentkey("Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Section Code","Section Code");
        AppraisalGroup.SetRange(AppraisalGroup."Job Title Code",Employee."Job Title Code");
        AppraisalGroup.SetRange(AppraisalGroup."Appraisal Type","Appraisal Type");
        AppraisalGroup.SetRange(AppraisalGroup.Status,AppraisalGroup.Status::Approved);

        if ((AppraisalGroup.Find('-')) and (AppraisalGroup.Find('='))) then

        Message(Format(AppraisalGroup.Count) + 'Jobtitle');
         begin
            AppraisalFactor.Reset;
            AppraisalFactor.SetRange(AppraisalFactor."Section Code",AppraisalGroup."Section Code");
            AppraisalFactor.SetRange(AppraisalFactor."Template Code",AppraisalGroup."Template Code");
            AppraisalFactor.SetRange(AppraisalFactor."Appraisal Type","Appraisal Type");
             if AppraisalFactor.Find('-') then
                if Trapper = false then
                begin
                   repeat
                     AppraisalLine.Init;
                     AppraisalLine."Section Code" := "Section Code";
                     AppraisalLine."Factor Code" := AppraisalFactor.Code;
                     AppraisalLine.Weight := AppraisalFactor.Weight;
                     AppraisalLine.Description := AppraisalFactor.Description;
                     AppraisalLine."Appraisal Period"  := "Appraisal Period";
                     AppraisalLine."Appraisal Type" := "Appraisal Type";
                     AppraisalLine."Employee No." := "Appraisee No.";
                     AppraisalLine.Insert;
                   until AppraisalFactor.Next = 0;
                   Trapper := true;
                   //This will modify the group of the header
                  "Group Code" := AppraisalFactor."Template Code";
                   Modify;
                end;

         end;
    end;


    procedure CheckCadre()
    begin
    end;


    procedure Submit()
    begin
        //to check if all entries are correctly filled
        AppraisalLine.Reset;
        AppraisalLine.SetRange(AppraisalLine."Employee No.","Appraisee No.");
        AppraisalLine.SetRange(AppraisalLine."Appraisal Period","Appraisal Period");
        AppraisalLine.SetRange(AppraisalLine."Appraisee Score Code",'');
        AppraisalLine.SetFilter(AppraisalLine.Weight,'<>%1',0);
        if AppraisalLine.Find('-') then
          Error(Text013,AppraisalLine."Appraisal Type");

        //to update d header
        if Confirm(Text014,false) then
          begin
            AppraisalHeader.Get("Appraisal Period","Appraisal Type","Appraisee No.");
            AppraisalHeader.Location := AppraisalHeader.Location::Appraiser;
            AppraisalHeader.Modify;
          end else
            exit;

        UserSetup.Get(UserId);
        UserSetup.TestField("E-Mail");
        GlobalSender := "First Name" + '' + "Last Name";
        Body := Text011;
        Subject := 'APPRAISAL';
        Employee.Get("Manager No.");
        SMTP.CreateMessage(GlobalSender,UserSetup."E-Mail",Employee."Company E-Mail",Subject,Body,false);
        SMTP.Send;
        Message(Text015);
    end;
}

