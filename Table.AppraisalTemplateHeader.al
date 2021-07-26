Table 52092221 "Appraisal Template Header"
{

    fields
    {
        field(1;"Section Code";Code[20])
        {
            TableRelation = "Appraisal Section";
        }
        field(2;"Template Code";Code[20])
        {

            trigger OnValidate()
            begin
                PreventChange;
            end;
        }
        field(3;"Employee No.";Code[20])
        {
            TableRelation = Employee where ("Termination Date"=filter(''));

            trigger OnValidate()
            begin
                AttachEmployeeRec.Reset;
                AttachEmployeeRec.SetRange(AttachEmployeeRec."Section Code","Section Code");
                AttachEmployeeRec.SetRange(AttachEmployeeRec."Appraisal Type","Appraisal Type");
                AttachEmployeeRec.SetRange(AttachEmployeeRec."Employee No.","Employee No.");
                if AttachEmployeeRec.Find('-') then

                begin
                Message('Employee No %1 As been attached to %2\' +
                'Group Code is %3',"Employee No.",AttachEmployeeRec."Section Code",AttachEmployeeRec."Group Code");
                "Employee No." := ''
                end;
            end;
        }
        field(4;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(5;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(6;"Grade Level Code";Code[20])
        {
            TableRelation = "Grade Level";
        }
        field(7;"Staff Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(8;"Job Title Code";Code[20])
        {
            TableRelation = "Job Title";
        }
        field(9;"Appraisal Type";Option)
        {
            OptionCaption = 'Mid-Year,Year End,Monthly,Quarterly';
            OptionMembers = "Mid-Year","Year End",Monthly,Quarterly;

            trigger OnValidate()
            begin
                PreventChange;
            end;
        }
        field(10;Status;Option)
        {
            OptionCaption = ' ,Under Development,Certified,InActive';
            OptionMembers = Open,"Pending Approval",Approved,Inactive;

            trigger OnValidate()
            begin
                AttachEmployeeRec.Reset;
                AttachEmployeeRec.SetRange(AttachEmployeeRec."Section Code","Section Code");
                AttachEmployeeRec.SetRange(AttachEmployeeRec."Appraisal Type","Appraisal Type");
                if AttachEmployeeRec.Find('-') then
                repeat
                AttachEmployeeRec.Status := Status;
                AttachEmployeeRec.Modify
                until AttachEmployeeRec.Next = 0;
            end;
        }
        field(11;"Weight Sum";Decimal)
        {
            CalcFormula = sum("Appraisal Template Line".Weight where ("Appraisal Type"=field("Appraisal Type"),
                                                                      "Template Code"=field("Template Code"),
                                                                      "Section Code"=field("Section Code")));
            DecimalPlaces = 0:5;
            Description = 'This is the sum of scores on the lines';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Sectional Weight";Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'This is a percentage of the total section';
        }
        field(13;"Employee Dependent";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14;"Additional Reviewer Required";Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(15;"Employee Full Name";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(16;"Employee Job Title";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Manager No";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee."No.";
        }
        field(18;"Manager Name";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(19;Location;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Appraisee,Supervisor';
            OptionMembers = Appraisee,Supervisor;
        }
    }

    keys
    {
        key(Key1;"Section Code","Template Code","Appraisal Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Status = Status::Approved then
           Error('Status Must Not Be Certified!');

        AttachEmployeeRec.Reset;
        AttachEmployeeRec.SetRange(AttachEmployeeRec."Section Code","Section Code");
        AttachEmployeeRec.SetRange(AttachEmployeeRec."Group Code","Template Code");
        AttachEmployeeRec.SetRange(AttachEmployeeRec."Appraisal Type","Appraisal Type");

        AppraisalTemplateLine.Reset;
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Section Code","Section Code");
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Template Code", "Template Code");
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Appraisal Type","Appraisal Type");

        if ((AppraisalTemplateLine.Find('-')) or (AttachEmployeeRec.Find('-')))then
         begin
           if not Confirm('Are You Sure You want To Delete The Record') then
            Error('Record Not Deleted');
             AppraisalTemplateLine.DeleteAll;
             AttachEmployeeRec.DeleteAll;
         end;
    end;

    trigger OnInsert()
    begin
        if "Template Code" = '' then begin
          HRSetup.Get;
          HRSetup.TestField(HRSetup."Appraisal Template Nos.");
          NoSeriesMgt.InitSeries(HRSetup."Appraisal Template Nos.",'',0D,"Template Code",HRSetup."Appraisal Template Nos.");
        end;
        UpdateInfoFromSection;
    end;

    trigger OnModify()
    begin
        AppraisalTemplateLine.Reset;
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Section Code","Section Code");
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Template Code","Template Code");
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Appraisal Type","Appraisal Type");

        if AppraisalTemplateLine.Find('-') then
          begin
            repeat
              AppraisalTemplateLine."Section Code" := "Section Code";
              AppraisalTemplateLine."Template Code" := "Template Code";
              AppraisalTemplateLine."Appraisal Type" := "Appraisal Type";
              AppraisalTemplateLine.Status := Status;
              AppraisalTemplateLine.Modify;
            until AppraisalTemplateLine.Next = 0;
          end;
        UpdateInfoFromSection;
    end;

    trigger OnRename()
    begin
        PreventChange
    end;

    var
        AppraisalTemplateLine: Record "Appraisal Template Line";
        AttachEmployeeRec: Record "Employee Appraisal Template";
        HRSetup: Record "Human Resources Setup";
        i: Integer;
        Text001: label 'Changes Not Allowed Since The Line Contains Some Information';
        NoSeriesMgt: Codeunit NoSeriesManagement;


    procedure PreventChange()
    begin
        AppraisalTemplateLine.Reset;
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Section Code","Section Code");
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Template Code","Template Code");
        AppraisalTemplateLine.SetRange(AppraisalTemplateLine."Appraisal Type","Appraisal Type");
        if AppraisalTemplateLine.Find('-')then
          Error(Text001);
    end;


    procedure AttachEmployee()
    begin
        /*CLEAR(AttachEmployeeForm);
        
        AttachEmployeeRec.RESET;
        
        
        AttachEmployeeRec.SETRANGE(AttachEmployeeRec."Section Code","Section Code");
        AttachEmployeeRec.SETRANGE(AttachEmployeeRec."Group Code","Group Code");
        AttachEmployeeRec.SETRANGE(AttachEmployeeRec."Appraisal Type","Appraisal Type");
        
        AttachEmployeeForm.SETTABLEVIEW(AttachEmployeeRec);
        AttachEmployeeForm.LOOKUPMODE := TRUE;
        AttachEmployeeForm.RUN;
        CLEAR(AttachEmployeeForm);*/

    end;

    local procedure CheckIfCombinationExist(AppraisalPeriod: Code[20];AppraisalType: Option "Mid-Year","Year End",Monthly,Quarterly;EmployeeNo: Code[20];AppraisalSection: Code[20])
    begin
    end;

    local procedure UpdateInfoFromSection()
    var
        AppraisalSection: Record "Appraisal Section";
    begin
        if AppraisalSection.Get("Section Code") then
          begin
            Validate("Employee Dependent",AppraisalSection."Employee Dependent");
            Validate("Additional Reviewer Required",AppraisalSection."Additional Reviewer Required");
          end;
    end;
}

