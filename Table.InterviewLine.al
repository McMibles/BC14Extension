Table 52092201 "Interview Line"
{

    fields
    {
        field(1;"Interview No.";Code[20])
        {
        }
        field(2;"Emp. Requisition Code";Code[20])
        {
            TableRelation = "Employee Requisition";

            trigger OnValidate()
            begin
                if "Emp. Requisition Code" <> '' then begin
                  JobVacancy.Get("Emp. Requisition Code");
                  "Grade Level Code" :=  JobVacancy."Grade Level";
                  "Salary Group" := JobVacancy."Salary Group";
                  "Global Dimension 1 Code"  := JobVacancy."Global Dimension 1 Code";
                  "Global Dimension 2 Code"  := JobVacancy."Global Dimension 2 Code";
                end;
            end;
        }
        field(3;"Applicant No.";Code[20])
        {
            TableRelation = Applicant;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                Applicant.Get("Applicant No.");
                if Applicant.Status in [3,4,6] then
                  Error(Text003,"Applicant No.",Applicant.Status);

                InterviewDetail.SetRange(InterviewDetail."Applicant No.","Applicant No.");
                InterviewDetail.SetRange(InterviewDetail."Interview No.","Interview No.");
                InterviewDetail.SetFilter(InterviewDetail."Line No.",'<>%1',"Line No.");
                if InterviewDetail.Find('-') then
                  Error(Text004);

                InterviewDetail.SetRange(InterviewDetail."Line No.");
                InterviewDetail.SetRange(InterviewDetail.Status,InterviewDetail.Status::None);
                InterviewDetail.SetFilter(InterviewDetail."Interview No.",'<>%1',"Interview No.");
                if InterviewDetail.Find('-') then
                  if not Confirm(Text005,false,InterviewDetail."Interview No.") then
                    Error(Text006);

                Name := CopyStr(Applicant.FullName,1,60);
            end;
        }
        field(4;Name;Text[60])
        {
        }
        field(5;Date;Date)
        {
        }
        field(6;Time;Time)
        {
        }
        field(7;Status;Option)
        {
            OptionCaption = 'None,Invited,Interviewed,Hired,Disqualified,Waiting List';
            OptionMembers = "None",Invited,Interviewed,Hired,Disqualified,"Waiting List";
        }
        field(8;"Score %";Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                case "Score %" of
                  90.0..100.0 : Performance := 1;
                  75.0..89.99 :  Performance := 2;
                  60.0..74.99 : Performance := 3;
                  50.0..59.99 : Performance := 4;
                  40.0..49.99 : Performance := 5;
                   0.01..39.99 : Performance := 6;
                  else
                    Performance := 0;
                end;
                Status := Status::Interviewed;
            end;
        }
        field(9;Performance;Option)
        {
            OptionCaption = ' ,Outstanding,Very Good,Good/Above Average,Average,Below Average,Unsatisfactory';
            OptionMembers = " ",Outstanding,"Very Good","Good/Above Average","Average","Below Average",Unsatisfactory;

            trigger OnValidate()
            begin
                case Performance of
                  1: "Score %" := 90;
                  2: "Score %" := 75;
                  3: "Score %" := 60;
                  4: "Score %" := 50;
                  5: "Score %" := 40;
                  6: "Score %" := 0;
                  else
                    "Score %" := 0;
                end;
                Status := Status::Interviewed;
            end;
        }
        field(10;Selection;Option)
        {
            OptionCaption = ' ,Employed,Next Interview,Disqualified,Waiting List,Awaiting Response';
            OptionMembers = " ",Employed,"Next Interview",Disqualified,"Waiting List","Awaiting Response";

            trigger OnValidate()
            begin
                if Selection <> 0 then
                  TestField(Performance);
                if (xRec.Selection = xRec.Selection::Employed) and (Selection <> Selection::Employed) then begin
                  Applicant.Get("Applicant No.");
                  if Employee.Get(Applicant."Employee No.") and (Employee."Job Title Code" = Applicant."Job Title Code") then
                    if not Confirm(Text001,false) then
                        Error(Text002);
                end;
                case Selection of
                 0 : Validate(Performance);
                 1 : begin
                   if (Stage <> Stage::Final) and (xRec.Stage <> Stage) then
                     if not Confirm(Text008,false) then Error(Text009);
                   // checks no. required
                   if JobVacancy.Get("Emp. Requisition Code") then begin
                     InterviewDetail.SetRange(InterviewDetail."Emp. Requisition Code","Emp. Requisition Code");
                     InterviewDetail.SetRange(InterviewDetail.Selection,InterviewDetail.Selection::Employed);
                     InterviewDetail.SetFilter(InterviewDetail."Applicant No.",'<>%1',"Applicant No.");
                     if JobVacancy."No. Approved" < InterviewDetail.Count + 1 then
                       Error(Text010);
                   end;
                   Status := Status::Hired;
                 end;
                 2 : Status := Status::Interviewed;
                 3 : Status := Status::Disqualified;
                 4 : Status := Status::"Waiting List";
                 5 : Status := Status::"Waiting List";
                end; /*end case*/
                
                InterviewHeader.Get("Interview No.");
                if Selection in [1,2] then begin
                  if (InterviewHeader."Pass Mark" <> 0) and ("Score %" < InterviewHeader."Pass Mark") then
                    if not Confirm(Text011,false,InterviewHeader."Pass Mark",Selection) then
                      Error(Text012,Selection)
                end else begin
                  if (InterviewHeader."Pass Mark" <> 0) and ("Score %" >= InterviewHeader."Pass Mark") then
                    if not Confirm(Text013,
                                    false,InterviewHeader."Pass Mark",Selection) then
                      Error(Text012,Selection)
                end;

            end;
        }
        field(11;Response;Option)
        {
            OptionMembers = " ",Accepted,Rejected;
        }
        field(12;"Reason for Selection";Text[30])
        {
        }
        field(13;"Reason for Response";Text[30])
        {
        }
        field(14;Close;Boolean)
        {
        }
        field(16;Stage;Option)
        {
            OptionCaption = 'First,Intermediate,Final';
            OptionMembers = First,Intermediate,Final;
        }
        field(17;Level;Integer)
        {
            InitValue = 1;
        }
        field(18;"Line No.";Integer)
        {
        }
        field(19;"Internal/External";Option)
        {
            OptionMembers = External,Internal,Both;
        }
        field(20;"Mode of Interview";Option)
        {
            OptionMembers = Written,Oral,Practical,Other;
        }
        field(21;Remarks;Text[40])
        {
        }
        field(22;"Expressed Date of Resumption";Date)
        {
        }
        field(23;"Grade Level Code";Code[20])
        {
            TableRelation = "Grade Level";

            trigger OnValidate()
            begin
                if "Grade Level Code" <> '' then begin
                  GradeLevel.Get("Grade Level Code");
                  if GradeLevel."Salary Group" <> '' then
                  "Salary Group" := GradeLevel."Salary Group";
                end;
            end;
        }
        field(24;"Probation Period";DateFormula)
        {
        }
        field(25;"Salary Group";Code[20])
        {
            TableRelation = "Payroll-Employee Group Header";
        }
        field(26;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(27;"Global Dimension 1 Code";Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1),
                                                          "Dimension Value Type"=filter(<>Total));
        }
        field(28;"Global Dimension 2 Code";Code[10])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2),
                                                          "Dimension Value Type"=filter(<>Total));
        }
    }

    keys
    {
        key(Key1;"Interview No.","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Applicant No.")
        {
        }
        key(Key3;"Emp. Requisition Code")
        {
        }
        key(Key4;"Score %")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        InterviewHeader.Get("Interview No.");
        JobVacancy.Get(InterviewHeader."Emp. Requisition Code");
        InterviewHeader.CalcFields(InterviewHeader."No. Short-Listed");
        if (InterviewHeader."No. to Interview" <> 0) and (InterviewHeader."No. Short-Listed" >= InterviewHeader."No. to Interview") then
          Error(Text007);
        "Emp. Requisition Code" := InterviewHeader."Emp. Requisition Code";
        //"Job Title No." := InterviewHeader."Job Title No.";
        Date := InterviewHeader."Interview Date";
        Time := InterviewHeader."Interview Time";
        Stage := InterviewHeader.Stage;
        Level := InterviewHeader.Level;
        "Internal/External" := InterviewHeader."Internal/External";
        "Mode of Interview" := InterviewHeader."Mode of Interview";
        "Grade Level Code" :=  JobVacancy."Grade Level";
        "Salary Group" := JobVacancy."Salary Group";
        "Global Dimension 1 Code"  := JobVacancy."Global Dimension 1 Code";
        "Global Dimension 2 Code"  := JobVacancy."Global Dimension 2 Code";
    end;

    trigger OnModify()
    begin
        if Status <> xRec.Status then begin
          Applicant.Get("Applicant No.");
          Applicant.Status := Status;
        end;

        if "Reason for Selection" <> '' then
          TestField(Selection);

        if "Reason for Response" <> '' then
          TestField(Response);
    end;

    var
        InterviewHeader: Record "Interview Header";
        InterviewDetail: Record "Interview Line";
        Applicant: Record Applicant;
        JobVacancy: Record "Employee Requisition";
        Employee: Record Employee;
        Text001: label 'Applicant''s Employee record for this job already exists.\Are you sure you want to change selection?';
        Text002: label 'Selection unchanged!';
        Text003: label 'Applicant No. %1''''s status is %2!';
        Text004: label 'Applicant already short-listed!';
        Text005: label 'Previous interview schedule No. %1 not concluded for applicant!\Continue Anyway?';
        Text006: label 'Applicant cannot by Schedule!';
        Text007: label 'No of Applicants to interview already exceeded!';
        Text008: label 'Interview Stage not yet final!\Are you sure you want to Hire now?';
        Text009: label 'Selection not correct!';
        Text010: label 'Job Requirement already exceeded!';
        Text011: label 'Candidate''s score is less than Pass Mark %1!\Select %2 Anyway?';
        Text012: label '%1 not Allowed!';
        Text013: label 'Candidate''s score is greater than Pass Mark %1!\Select %2 Anyway?';
        GradeLevel: Record "Grade Level";
}

