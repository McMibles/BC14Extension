Table 52092224 "Appraisal Template Line"
{

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[80])
        {
        }
        field(3;"Appraisal Type";Option)
        {
            OptionMembers = "Mid Year","Year End";
        }
        field(4;Weight;Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0:5;
            MaxValue = 1;
        }
        field(5;"Template Code";Code[20])
        {
            TableRelation = "Appraisal Template Header"."Template Code";
        }
        field(6;"Section Code";Code[20])
        {
        }
        field(7;"Factor Sum";Decimal)
        {
            CalcFormula = sum("Appraisal Template Line".Weight where ("Appraisal Type"=field("Appraisal Type"),
                                                                      "Template Code"=field("Template Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;Status;Option)
        {
            OptionCaption = ' ,Under Development,Certified,InActive';
            OptionMembers = Open,"Pending Approval",Approved,Inactive;
        }
        field(9;"Weighting Percent";Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if "Weighting Percent" <> 0 then begin
                 if "Line Type" <> "line type"::Standard then
                   Error(Text001);
                 Weight := "Weighting Percent"/100
                end else
                  Weight := 0;
            end;
        }
        field(10;"Line No.";Integer)
        {
        }
        field(11;"Line Type";Option)
        {
            OptionCaption = 'Standard,Heading';
            OptionMembers = Standard,Heading;
        }
        field(12;"Focus Arear";Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13;Expectation;Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Employee Dependent";Boolean)
        {
            CalcFormula = lookup("Appraisal Template Header"."Employee Dependent" where ("Template Code"=field("Template Code")));
            FieldClass = FlowField;
        }
        field(15;Type;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,General Trait,Performance,Leadership,Summary,Training,Job Related,Competence,Core Values';
            OptionMembers = " ","General Trait",Performance,Leadership,Summary,Training,"Job Related",Competence,"Core Values";
        }
        field(16;Comments;Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Appraisal Type","Section Code","Template Code","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Appraisal Type","Template Code")
        {
            SumIndexFields = Weight;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        Commit;
    end;

    var
        AppraisalGroup: Record "Appraisal Template Header";
        HRSetup: Record "Human Resources Setup";
        P: Code[10];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'Line Type must be standard. Entry not allowed';
}

