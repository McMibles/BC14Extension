Table 52092203 Interviewer
{
    DrillDownPageID = Interviewers;
    LookupPageID = Interviewers;

    fields
    {
        field(1;"Schedule Code";Code[20])
        {
            NotBlank = true;
            TableRelation = "Interview Header";
        }
        field(2;"Employee Code";Code[20])
        {
            TableRelation = Employee where (Status=filter(Active));

            trigger OnValidate()
            begin
                if "Employee Code" <> '' then begin
                  EmployeeRec.Get("Employee Code");
                  EmployeeRec.TestField(EmployeeRec."E-Mail");
                  EmployeeRec.TestField("Mobile Phone No.");
                  "E-Mail" := EmployeeRec."E-Mail";
                  "Mobile No." := EmployeeRec."Mobile Phone No.";
                  "Employee Name" := EmployeeRec."Last Name" + ' ' + EmployeeRec."First Name";
                end else  begin
                   "Employee Name" := '';
                    "E-Mail" := '';
                end;
            end;
        }
        field(3;"Employee Name";Text[60])
        {
        }
        field(4;"E-Mail";Text[30])
        {
        }
        field(5;"Total Score";Decimal)
        {
            CalcFormula = sum("Interviewer Score Details"."Score %" where ("Ref. No."=field("Schedule Code"),
                                                                           "Applicant No."=field("Applicant Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Total Entries";Integer)
        {
            CalcFormula = count("Interviewer Score Details" where ("Ref. No."=field("Schedule Code"),
                                                                   "Applicant No."=field("Applicant Filter"),
                                                                   "Score %"=filter(<>0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Applicant Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(8;"Mobile No.";Text[30])
        {
        }
        field(9;"Schedule Closed";Boolean)
        {
        }
        field(10;"Interview Date";Date)
        {
        }
        field(11;"Interview Time";Time)
        {
        }
    }

    keys
    {
        key(Key1;"Schedule Code","Employee Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        EmployeeRec: Record Employee;
}

