Table 52092188 "Job Title"
{
    DrillDownPageID = "Job Title List";
    LookupPageID = "Job Title List";

    fields
    {
        field(1;"Ref. No.";Code[20])
        {
            Editable = true;
        }
        field(2;"Title/Description";Text[50])
        {

            trigger OnValidate()
            begin
                if Designation = '' then
                  Designation := JobTitle."Title/Description";
            end;
        }
        field(3;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(4;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(5;Blocked;Boolean)
        {
        }
        field(6;"Min. Working Experience";Decimal)
        {
            BlankZero = true;
        }
        field(7;"No. of Employee";Integer)
        {
            CalcFormula = count(Employee where ("Job Title Code"=field("Ref. No."),
                                                Status=filter(<>Terminated)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Approved Establishment";Integer)
        {
        }
        field(9;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(10;Location;Text[30])
        {
        }
        field(11;Designation;Text[50])
        {
        }
        field(12;"Grade Level Code";Code[10])
        {
            TableRelation = "Grade Level";

            trigger OnValidate()
            begin
                if "Grade Level Code" <> '' then begin
                  GradeLevel.Get("Grade Level Code");
                  "Employee Category" := GradeLevel."Employee Category";
                end;
            end;
        }
        field(13;"Job Analyst";Code[20])
        {
            TableRelation = Employee;
        }
        field(14;"Direct Superior";Code[20])
        {
            TableRelation = Employee;
        }
        field(17;"Report to";Code[20])
        {
            TableRelation = Employee;
        }
        field(19;"Work Type";Option)
        {
            OptionMembers = Day,Shift,Relay,Others;
        }
        field(20;"No. of Subordinate";Integer)
        {
        }
        field(21;"Min. Qualification";Code[10])
        {
            Editable = false;
            TableRelation = Qualification;
        }
        field(22;Comment;Boolean)
        {
        }
        field(23;"No. Series";Code[10])
        {
        }
    }

    keys
    {
        key(Key1;"Ref. No.")
        {
            Clustered = true;
        }
        key(Key2;"Title/Description")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Ref. No.","Title/Description")
        {
        }
    }

    trigger OnInsert()
    begin
        if "Ref. No." = '' then begin
          HumanResSetup.Get;
          HumanResSetup.TestField("Job Title Nos.");
          NoSeriesMgt.InitSeries(HumanResSetup."Job Title Nos.",HumanResSetup."Job Title Nos.",0D,"Ref. No.",
                                 HumanResSetup."Job Title Nos.");
        end;
    end;

    trigger OnModify()
    begin
        TestField("Title/Description");
        TestField("Approved Establishment");
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        JobTitle: Record "Job Title";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GradeLevel: Record "Grade Level";
        DimValue: Record "Dimension Value";


    procedure AssistEdit(OldJobTitle: Record "Job Title"): Boolean
    begin
        with JobTitle do begin
          JobTitle := Rec;
          HumanResSetup.Get;
          HumanResSetup.TestField("Job Title Nos.");
          if NoSeriesMgt.SelectSeries(HumanResSetup."Job Title Nos.",OldJobTitle."No. Series","No. Series") then begin
            HumanResSetup.Get;
            HumanResSetup.TestField("Job Title Nos.");
            NoSeriesMgt.SetSeries("Ref. No.");
            Rec := JobTitle;
            exit(true);
          end;
        end;
    end;
}

