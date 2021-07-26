Table 52092187 "Grade Level"
{
    DrillDownPageID = "Grade Level List";
    LookupPageID = "Grade Level List";

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Level;Integer)
        {
        }
        field(3;Step;Integer)
        {
        }
        field(4;Description;Text[50])
        {
        }
        field(5;"Min. Basic Salary";Decimal)
        {
        }
        field(6;"Employee Category";Code[20])
        {
            TableRelation = "Employee Category";
        }
        field(7;"No. of Employee";Integer)
        {
            CalcFormula = count(Employee where ("Grade Level Code"=field(Code),
                                                Status=field("Status Filter"),
                                                "Global Dimension 1 Code"=field("Dimension 1 Filter"),
                                                Gender=field("Sex FILTER"),
                                                "Global Dimension 2 Code"=field("Dimension 2 Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"New Grade Level";Code[10])
        {
            TableRelation = "Grade Level";
        }
        field(12;"Max. Basic Salary";Decimal)
        {
        }
        field(13;"Salary Group";Code[20])
        {
            Caption = 'Salary Grade';
            TableRelation = "Payroll-Employee Group Header";
        }
        field(14;"Sex FILTER";Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = " ",Female,Male;
        }
        field(15;"Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,1,1';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(16;"Status Filter";Option)
        {
            FieldClass = FlowFilter;
            OptionMembers = Active,Inactive,Terminated;
        }
        field(17;"Dimension 2 Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        TestField("Employee Category");
        
        /*IF "Min. Basic Salary" > "Max. Basic Salary" THEN
          ERROR(Text001);
         */

    end;

    var
        Employee: Record Employee;
        Text001: label 'Inconsistent Min./Max. Basic Salary!';
        Payrollsetup: Record "Payroll-Setup";
        EmployeeGroup: Record "Payroll-Employee Group Line";


    procedure GetBasicSalary(): Decimal
    begin
        Payrollsetup.Get;
        Payrollsetup.TestField("Basic E/D Code");
        TestField("Salary Group");
        EmployeeGroup.Get("Salary Group",Payrollsetup."Basic E/D Code");
        exit(EmployeeGroup."Default Amount");
    end;
}

