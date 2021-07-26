Table 52092220 "Appraisal Section"
{

    fields
    {
        field(1;Name;Code[20])
        {
        }
        field(2;Description;Text[80])
        {
        }
        field(3;"Sectional Weight";Decimal)
        {
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                /*
                AppraisalSection.RESET;
                IF AppraisalSection.FIND('+') THEN
                BEGIN
                Dec := 0;
                REPEAT
                  Dec := AppraisalSection."Sectional Weight" + Dec;
                 UNTIL  AppraisalSection.NEXT = 0;
                
                //IF Dec > 1 THEN
                // ERROR('Total Sectional weight Must Not Be Greater Than 1');
                
                END;
                
                MESSAGE(FORMAT(Dec));
                */

            end;
        }
        field(4;Type;Option)
        {
            OptionCaption = ' ,General Trait,Performance,Leadership,Summary,Training';
            OptionMembers = " ","General Trait",Performance,Leadership,Summary,Training;
        }
        field(5;"Employee Template Exist";Boolean)
        {
            CalcFormula = exist("Employee Appraisal Template" where ("Section Code"=field(Name),
                                                                     "Group Code"=field("Template Code Filter"),
                                                                     "Employee No."=field("Employee No. Filter"),
                                                                     "Appraisal Type"=field("Appraisal Type Filter")));
            FieldClass = FlowField;
        }
        field(10;"Employee Dependent";Boolean)
        {
            Caption = 'Employee Dependent';
            DataClassification = ToBeClassified;
            Description = 'The KPI setting on this section defined by the employee and then certified by his/her Supervisor';
        }
        field(11;"Employee Category";Code[20])
        {
            Caption = 'Employee Category';
            DataClassification = ToBeClassified;
            Description = 'This is used to specify the category of employees that this section applies to';
            TableRelation = "Employee Category".Code;
        }
        field(12;"Additional Reviewer Required";Boolean)
        {
            Caption = 'Additional Reviewer Required';
            DataClassification = ToBeClassified;
            Description = 'This is usd to indicate sections that would required reviewer(s) who is/are not the appraisees supervisor nor in the workflow user group for approval of the appraisees appraisal';
        }
        field(24;"Employee No. Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(25;"Template Code Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(26;"Appraisal Type Filter";Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = 'Mid Year,Year End';
            OptionMembers = "Mid Year","Year End";
        }
        field(27;"Grade Level Code Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(28;"Job Title Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(29;"Global Dimension 1 Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(30;"Global Dimension 2 Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(31;"Employee Category Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(32;"Additional Reviewer Setup";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'HR,Supervisor,Appraisee';
            OptionMembers = HR,Supervisor,Appraisee;
        }
    }

    keys
    {
        key(Key1;Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AppraisalSection: Record "Appraisal Section";
        Dec: Decimal;
}

