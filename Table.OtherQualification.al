Table 52092243 "Other Qualification"
{
    Caption = 'Employee Qualification';
    DataCaptionFields = "No.";
    LookupPageID = "Employee Qualifications";

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'Employee No.';
            NotBlank = true;
            TableRelation = if ("Record Type"=const(Applicant)) Applicant
                            else if ("Record Type"=const("Job Title")) "Job Title"
                            else if ("Record Type"=const(Vacancy)) "Employee Requisition";
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;"Qualification Code";Code[10])
        {
            Caption = 'Qualification Code';
            TableRelation = Qualification;

            trigger OnValidate()
            begin
                Qualification.Get("Qualification Code");
                Description := Qualification.Description;
            end;
        }
        field(4;"From Date";Date)
        {
            Caption = 'From Date';
        }
        field(5;"To Date";Date)
        {
            Caption = 'To Date';
        }
        field(6;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Internal,External,Previous Position';
            OptionMembers = " ",Internal,External,"Previous Position";
        }
        field(7;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(8;"Institution/Company";Text[100])
        {
            Caption = 'Institution/Company';
        }
        field(9;Cost;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost';
        }
        field(10;"Course Grade";Text[50])
        {
            Caption = 'Course Grade';
        }
        field(11;"Employee Status";Option)
        {
            Caption = 'Employee Status';
            Editable = false;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(12;Comment;Boolean)
        {
            Caption = 'Comment';
            Editable = false;
        }
        field(13;"Expiration Date";Date)
        {
            Caption = 'Expiration Date';
        }
        field(14;"Record Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Applicant,Job Title,Vacancy';
            OptionMembers = Applicant,"Job Title",Vacancy;
        }
        field(15;"Course Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Course.Code where ("Record Type"=const(Course));
        }
    }

    keys
    {
        key(Key1;"Record Type","No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Qualification Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Comment then
          Error(Text000);
    end;

    trigger OnInsert()
    begin
        Employee.Get("No.");
        "Employee Status" := Employee.Status;
    end;

    var
        Text000: label 'You cannot delete employee qualification information if there are comments associated with it.';
        Qualification: Record Qualification;
        Employee: Record Employee;
}

