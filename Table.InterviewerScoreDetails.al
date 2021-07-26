Table 52092204 "Interviewer Score Details"
{

    fields
    {
        field(1;"Ref. No.";Code[20])
        {
        }
        field(2;"Job Ref. No.";Code[20])
        {
            TableRelation = "Employee Requisition";
        }
        field(3;"Applicant No.";Code[20])
        {
            TableRelation = if ("Internal/External"=const(External),
                                "Job Ref. No."=filter(<>'')) Applicant where ("Position Desired"=field("Job Ref. No."),
                                                                              "Internal/External"=const(External),
                                                                              Status=filter(" "|Interviewed|"Waiting List"))
                                                                              else if ("Internal/External"=const(Internal),
                                                                                       "Job Ref. No."=filter(<>'')) Applicant where ("Position Desired"=field("Job Ref. No."),
                                                                                                                                     "Internal/External"=const(Internal),
                                                                                                                                     Status=filter(" "|Interviewed|"Waiting List"))
                                                                                                                                     else if ("Internal/External"=const(External)) Applicant where ("Internal/External"=const(External),
                                                                                                                                                                                                    Status=filter(" "|Interviewed|"Waiting List"))
                                                                                                                                                                                                    else if ("Internal/External"=const(Internal)) Applicant where ("Internal/External"=const(Internal),
                                                                                                                                                                                                                                                                   Status=filter(" "|Interviewed|"Waiting List"))
                                                                                                                                                                                                                                                                   else if ("Job Ref. No."=filter(<>'')) Applicant where ("Position Desired"=field("Job Ref. No."),
                                                                                                                                                                                                                                                                                                                          Status=filter(" "|Interviewed|"Waiting List"))
                                                                                                                                                                                                                                                                                                                          else Applicant where (Status=filter(" "|Interviewed|"Waiting List"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                Applicant.Get("Applicant No.");
                if Applicant.Status in [3,4,6] then
                  Error('Applicant No. %1''s status is %2!',"Applicant No.",Applicant.Status);

                InterviewDetail.SetRange(InterviewDetail."Applicant No.","Applicant No.");
                InterviewDetail.SetRange(InterviewDetail."Interview No.","Ref. No.");
                InterviewDetail.SetFilter(InterviewDetail."Line No.",'<>%1',"Line No.");
                if InterviewDetail.Find('-') then
                  Error('Applicant already short-listed!');

                InterviewDetail.SetRange(InterviewDetail."Line No.");
                InterviewDetail.SetRange(InterviewDetail.Status,InterviewDetail.Status::None);
                InterviewDetail.SetFilter(InterviewDetail."Interview No.",'<>%1',"Ref. No.");
                if InterviewDetail.Find('-') then
                  if not Confirm('Previous interview schedule No. %1 not concluded for applicant!\Continue Anyway?',
                                 false,InterviewDetail."Interview No.") then
                    Error('Applicant cannot by Schedule!');

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
            OptionCaption = 'None,Invited,Interviewed,Hired,Disqualified,Waiting List,To Be Deleted';
            OptionMembers = "None",Invited,Interviewed,Hired,Disqualified,"Waiting List","To Be Deleted";
        }
        field(8;"Score %";Decimal)
        {

            trigger OnValidate()
            begin
                case "Score %" of
                  90.0..100.0 : Performance := 1;
                  75.0..89.0 : Performance := 2;
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
            OptionCaption = ' ,Employed,Next Interview,Disqualified,Waiting List,To Be Deleted,Awaiting Response';
            OptionMembers = " ",Employed,"Next Interview",Disqualified,"Waiting List","To Be Deleted","Awaiting Response";

            trigger OnValidate()
            begin
                
                if Selection <> 0 then
                  TestField(Performance);
                if (xRec.Selection = xRec.Selection::Employed) and (Selection <> Selection::Employed) then begin
                  Applicant.Get("Applicant No.");
                  if Employee.Get(Applicant."Employee No.") and (Employee."Job Title Code" = Applicant."Job Title Code") then
                    if not Confirm('Applicant''s Employee record for this job already exists.\Are you sure' +
                      ' you want to change selection?',false) then
                        Error('Selection unchanged!');
                end;
                case Selection of
                 0 : Validate(Performance);
                 1 : begin
                   if (Stage <> Stage::Final) and (xRec.Stage <> Stage) then
                     if not Confirm('Interview Stage not yet final!\Are you sure you want to Hire now?',false) then
                       Error('Selection not correct!');
                   // checks no. required
                   if JobVacancy.Get("Job Ref. No.") then begin
                     InterviewDetail.SetRange(InterviewDetail."Emp. Requisition Code","Job Ref. No.");
                     InterviewDetail.SetRange(InterviewDetail.Selection,InterviewDetail.Selection::Employed);
                     InterviewDetail.SetFilter(InterviewDetail."Applicant No.",'<>%1',"Applicant No.");
                     if JobVacancy."No. Approved" < InterviewDetail.Count + 1 then
                       Error('Job Requirement already exceeded!');
                   end;
                   Status := Status::Hired;
                 end;
                 2 : Status := Status::Interviewed;
                 3 : Status := Status::Disqualified;
                 4 : Status := Status::"Waiting List";
                 5 : Status := Status::"To Be Deleted";
                 6 : Status := Status::"Waiting List";
                end; /*end case*/
                
                InterviewHeader.Get("Ref. No.");
                if Selection in [1,2] then begin
                  if (InterviewHeader."Pass Mark" <> 0) and ("Score %" < InterviewHeader."Pass Mark") then
                    if not Confirm('Candidate''s score is less than Pass Mark %1!\Select %2 Anyway?',
                                    false,InterviewHeader."Pass Mark",Selection) then
                      Error('%1 not Allowed!',Selection)
                end else begin
                  if (InterviewHeader."Pass Mark" <> 0) and ("Score %" >= InterviewHeader."Pass Mark") then
                    if not Confirm('Candidate''s score is greater than Pass Mark %1!\Select %2 Anyway?',
                                    false,InterviewHeader."Pass Mark",Selection) then
                      Error('%1 not Allowed!',Selection)
                end;

            end;
        }
        field(11;Response;Option)
        {
            OptionCaption = ' ,Accepted,Rejected';
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
        field(15;"Job Title No.";Code[20])
        {
        }
        field(16;Stage;Option)
        {
            OptionCaption = 'First,Intermediate,Final';
            OptionMembers = First,Intermediate,Final;
        }
        field(17;Level;Integer)
        {
        }
        field(18;"Line No.";Integer)
        {
        }
        field(19;"Internal/External";Option)
        {
            OptionCaption = 'External,Internal,Both';
            OptionMembers = External,Internal,Both;
        }
        field(20;"Mode of Interview";Option)
        {
            OptionCaption = 'Written,Oral,Practical,Other';
            OptionMembers = Written,Oral,Practical,Other;
        }
        field(21;Remarks;Text[40])
        {
        }
        field(22;"Interviewer Code";Code[20])
        {
            TableRelation = Interviewer;
        }
    }

    keys
    {
        key(Key1;"Ref. No.","Interviewer Code","Line No.")
        {
            Clustered = true;
        }
        key(Key2;"Ref. No.","Applicant No.")
        {
            SumIndexFields = "Score %";
        }
        key(Key3;"Score %")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        InterviewHeader.Get("Ref. No.");
        InterviewHeader.CalcFields(InterviewHeader."No. Short-Listed");
        if (InterviewHeader."No. to Interview" <> 0) and (InterviewHeader."No. Short-Listed" >= InterviewHeader."No. to Interview") then
          Error('No of Applicants to interview already exceeded!');
        "Job Ref. No." := InterviewHeader."Emp. Requisition Code";
        "Job Title No." := InterviewHeader."Emp. Requisition Code";
        Date := InterviewHeader."Interview Date";
        Time := InterviewHeader."Interview Time";
        Stage := InterviewHeader.Stage;
        Level := InterviewHeader.Level;
        "Internal/External" := InterviewHeader."Internal/External";
        "Mode of Interview" := InterviewHeader."Mode of Interview";
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
}

