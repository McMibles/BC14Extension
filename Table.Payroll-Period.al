Table 52092145 "Payroll-Period"
{
    DrillDownPageID = "Payroll Periods List";
    LookupPageID = "Payroll Periods List";

    fields
    {
        field(1;"Period Code";Code[10])
        {
            Editable = true;
            NotBlank = true;
        }
        field(2;"Start Date";Date)
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                if Name = '' then
                 Name := Format("Start Date",0,'<MONTH TEXT>, <YEAR4>');
            end;
        }
        field(3;"End Date";Date)
        {
            NotBlank = true;
        }
        field(4;Name;Text[40])
        {

            trigger OnValidate()
            begin
                /*IF (1 < CursorPos) AND (CursorPos < MAXSTRLEN("Search Name")) THEN
                BEGIN
                  "Search Name" := DELCHR (COPYSTR(Name, CursorPos),'<>');
                  "Search Name" := PADSTR ("Search Name" + ' ' + DELCHR (COPYSTR(Name, 1, CursorPos-1), '<>'), MAXSTRLEN("Search Name"));
                END
                ELSE
                  "Search Name" := Name;*/

            end;
        }
        field(5;Closed;Boolean)
        {
        }
        field(6;"Search Name";Code[20])
        {
        }
        field(7;"ED Delimitation";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-E/D";
        }
        field(8;"Employee Delimitation";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-Employee";
        }
        field(9;"ED Amount";Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where ("Payroll Period"=field("Period Code"),
                                                                   "Employee No."=field("Employee Delimitation"),
                                                                   "E/D Code"=field("ED Delimitation"),
                                                                   "Employee Category"=field("Employee Category Filter")));
            DecimalPlaces = 0:5;
            FieldClass = FlowField;
        }
        field(10;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(11;"Employee Category Filter";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Employee Category";
        }
        field(12;Publish;Boolean)
        {
        }
        field(13;"No. of Entries";Integer)
        {
            CalcFormula = count("Payroll-Payslip Header" where ("Payroll Period"=field("Period Code"),
                                                                "Global Dimension 1 Code"=field("Global Dimension 1 Code Filter")));
            FieldClass = FlowField;
        }
        field(14;"Global Dimension 1 Code Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(15;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";

            trigger OnValidate()
            begin
                ProllPayslipHeader.SetRange(ProllPayslipHeader."Payroll Period","Period Code");
                ProllPayslipHeader.ModifyAll(Status,Status);
            end;
        }
        field(16;"Journal Created";Boolean)
        {
        }
        field(17;"ED Closed Amount";Decimal)
        {
            CalcFormula = sum("Closed Payroll-Payslip Line".Amount where ("Payroll Period"=field("Period Code"),
                                                                          "Employee No."=field("Employee Delimitation"),
                                                                          "E/D Code"=field("ED Delimitation"),
                                                                          "Employee Category"=field("Employee Category Filter")));
            DecimalPlaces = 0:5;
            FieldClass = FlowField;
        }
        field(18;"No. of Entries Closed";Integer)
        {
            CalcFormula = count("Closed Payroll-Payslip Header" where ("Payroll Period"=field("Period Code"),
                                                                       "Global Dimension 1 Code"=field("Global Dimension 1 Code Filter")));
            FieldClass = FlowField;
        }
        field(19;"Statistics Group Filter";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll Statistical Group";
        }
    }

    keys
    {
        key(Key1;"Period Code")
        {
            Clustered = true;
        }
        key(Key2;"Search Name")
        {
        }
        key(Key3;"Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ProllPayslipHeader.SetRange(ProllPayslipHeader."Payroll Period","Period Code");
        if ProllPayslipHeader.Find('-') then
          Error(Text001,"Period Code");
    end;

    var
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        Text001: label 'Payroll Period is not empty!\Payroll Period %1 cannot be deleted';
}

