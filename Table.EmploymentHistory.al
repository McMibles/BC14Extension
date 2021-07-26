Table 52092202 "Employment History"
{

    fields
    {
        field(1; "Record Type"; Option)
        {
            OptionMembers = Employee,Applicant;
        }
        field(2; "No."; Code[20])
        {
            TableRelation = if ("Record Type" = const(Employee)) Employee
            else
            if ("Record Type" = const(Applicant)) Applicant;
        }
        field(3; "Line No."; Integer)
        {
        }
        field(4; "From Date"; Date)
        {
        }
        field(5; "To Date"; Date)
        {
        }
        field(6; Type; Option)
        {
            OptionMembers = " ",Internal,External,"Previous Position","Salary Change";

            trigger OnValidate()
            begin
                if Type = Type::Internal then
                    "Institution/Company" := COMPANYNAME;
            end;
        }
        field(7; "Position Held"; Text[50])
        {
        }
        field(8; "Institution/Company"; Text[100])
        {
        }
        field(9; "Employee Status"; Option)
        {
            OptionMembers = Active,Inactive,Terminated;
        }
        field(10; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = filter(0 | 6),
                                                                     "No." = field("No."),
                                                                     "Table Line No." = field("Line No.")));
            FieldClass = FlowField;
        }
        field(11; "Expiration Date"; Date)
        {
        }
        field(12; Remark; Text[50])
        {
        }
        field(14; "Job Title Code"; Code[20])
        {
            TableRelation = "Job Title";
        }
        field(15; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(16; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(17; "Grade Level"; Code[10])
        {
        }
        field(18; "Document No."; Code[20])
        {
        }
        field(19; "Document Date"; Date)
        {
        }
        field(20; Salary; Decimal)
        {
        }
        field(23; "Old Grade Level"; Code[10])
        {
        }
        field(24; "Old Gross Salary"; Decimal)
        {
        }
        field(25; "Entry Type"; Option)
        {
            OptionCaption = 'Promotion,Transfer,Salary Change,Upgrade,Redesignation,Redesignation/Transfer,Recruitment';
            OptionMembers = Promotion,Transfer,"Salary Change",Upgrade,Redesignation,"Redesignation/Transfer",Recruitment;
        }
        field(26; "Old Global Dimension 1 Code"; Code[10])
        {
        }
        field(27; "Old Global Dimension 2 Code"; Code[10])
        {
        }
        field(28; "Old Job Title Code"; Code[20])
        {
        }
        field(29; "User ID"; Code[50])
        {
        }
        field(30; "System Date"; Date)
        {
        }
        field(32; Correction; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Record Type", "No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "From Date")
        {
        }
        key(Key3; "Job Title Code", "From Date")
        {
        }
        key(Key4; "Record Type", "From Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Entry Type" = "entry type"::"Upgrade" then
            Error('Employee log entry cannot be deleted!');
    end;

    trigger OnInsert()
    begin
        if "Line No." = 0 then begin
            EmplHistory.SetRange(EmplHistory."No.", "No.");
            if EmplHistory.Find('+') then begin
                if Type = Type::"Salary Change" then
                    "Line No." := EmplHistory."Line No." + 11000
                else
                    "Line No." := EmplHistory."Line No." + 10000
            end else begin
                if Type = Type::"Salary Change" then
                    "Line No." := 11000
                else
                    "Line No." := 10000;
            end;
        end;

        "User ID" := UserId;
        "System Date" := Today;
    end;

    trigger OnModify()
    begin
        TestField("Position Held");
        TestField("Institution/Company");
        TestField("From Date");
        if "To Date" <> 0D then
            TestField(Remark);
    end;

    var
        HRSetup: Record "Human Resources Setup";
        EmplHistory: Record "Employment History";
        LineNo: Integer;


    procedure InsertEntry(NewEmployee: Record Employee; EntryType: Option Promotion,Transfer,"Salary Change",Upgrading,Redesignation,"Redesignation/Transfer",Appraisal,Direct)
    var
        Employee: Record Employee;
    begin
        if NewEmployee.FullName = '' then
            exit;

        Employee.Get(NewEmployee."No.");

        Init;
        "Record Type" := "record type"::Employee;
        "No." := NewEmployee."No.";
        "From Date" := Today;
        Type := Type::Internal;
        "Institution/Company" := COMPANYNAME;
        "Position Held" := NewEmployee.Designation;
        "Employee Status" := NewEmployee.Status;
        "Job Title Code" := NewEmployee."Job Title Code";
        "Global Dimension 1 Code" := NewEmployee."Global Dimension 1 Code";
        "Global Dimension 2 Code" := NewEmployee."Global Dimension 2 Code";
        "Grade Level" := NewEmployee."Grade Level Code";
        //Salary := NewEmployee."Basic Salary";
        "Old Grade Level" := Employee."Grade Level Code";
        //"Old Basic Salary" := Employee."Basic Salary";
        "Entry Type" := EntryType;
        "Old Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
        "Old Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
        "Old Job Title Code" := Employee."Job Title Code";
        "User ID" := UserId;
        "System Date" := Today;
        Remark := 'Direct Change';
        EmplHistory.SetRange(EmplHistory."No.", "No.");
        if EmplHistory.Find('+') then
            "Line No." := EmplHistory."Line No." + 10000
        else
            "Line No." := 10000;

        Insert;
    end;
}

