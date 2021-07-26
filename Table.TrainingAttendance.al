Table 52092209 "Training Attendance"
{

    fields
    {
        field(1; "Schedule Code"; Code[10])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Training Code"; Code[10])
        {
            TableRelation = "Training Category";

            trigger OnValidate()
            begin
                if TrainngSchLine.Get("Schedule Code") then begin
                    "Training Code" := TrainngSchLine."Training Code";
                    "Reference No." := TrainngSchLine."Reference No.";
                end;
            end;
        }
        field(4; "Reference No."; Code[20])
        {
            Editable = false;
        }
        field(5; "Description/Title"; Text[40])
        {
            Editable = false;
        }
        field(6; Type; Code[10])
        {
            Editable = false;
            TableRelation = "Training Type";
        }
        field(7; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Employee No." <> '' then begin
                    Employee.Get("Employee No.");
                    "Employee Name" := Employee.FullName;
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Staff Category" := Employee."Employee Category";
                    "Grade Level" := Employee."Grade Level Code";

                    // check conflicts
                    // employee must be active
                    Employee.TestField(Employee.Status, Employee.Status::Active);
                    // another training
                    TrainngSchLine.Get("Schedule Code", "Line No.");
                    TrainingAttendance.SetRange(TrainingAttendance."Employee No.", "Employee No.");
                    TrainingAttendance.SetFilter(TrainingAttendance."Start Date", '<=%1', TrainngSchLine."Start Date");
                    TrainingAttendance.SetFilter(TrainingAttendance."End Date", '>=%1', TrainngSchLine."Start Date");
                    if TrainingAttendance.Find('-') then begin
                        if not Confirm(Text001, false, "Employee No.", TrainingAttendance."Description/Title", TrainingAttendance."Start Date",
                                       TrainingAttendance."End Date") then
                            Error('Nomination not allowed');
                    end else begin
                        TrainingAttendance.SetFilter(TrainingAttendance."Start Date", '<=%1', TrainngSchLine."End Date");
                        TrainingAttendance.SetFilter(TrainingAttendance."End Date", '>=%1', TrainngSchLine."End Date");
                        if TrainingAttendance.Find('-') then
                            if not Confirm(Text001, false, "Employee No.", TrainingAttendance."Description/Title", TrainingAttendance."Start Date",
                                           TrainingAttendance."End Date") then
                                Error('Nomination not allowed');
                    end;

                    // check for schecduled leave
                    LeaveScheduleLine.SetRange("Year No.", Date2dmy(TrainngSchLine."Start Date", 3));
                    LeaveScheduleLine.SetRange("Employee No.", "Employee No.");
                    LeaveScheduleLine.SetFilter("Start Date", '<=%1', TrainngSchLine."Start Date");
                    LeaveScheduleLine.SetFilter("End Date", '>=%1', TrainngSchLine."Start Date");
                    if LeaveScheduleLine.Find('-') then begin
                        if not Confirm(Text002, false, "Employee No.", LeaveScheduleLine."Start Date", LeaveScheduleLine."End Date") then begin
                            if CurrFieldNo = FieldNo("Employee No.") then
                                Error('Nomination not allowed')
                            else
                                Status := Status::Rejected;
                        end;
                    end else begin
                        LeaveScheduleLine.SetFilter("Start Date", '<=%1', TrainngSchLine."End Date");
                        LeaveScheduleLine.SetFilter("End Date", '>=%1', TrainngSchLine."End Date");
                        if LeaveScheduleLine.Find('-') then begin
                            if not Confirm(Text002, false, "Employee No.", LeaveScheduleLine."Start Date", LeaveScheduleLine."End Date") then begin
                                if CurrFieldNo = FieldNo("Employee No.") then
                                    Error('Nomination not allowed')
                                else
                                    Status := Status::Rejected;
                            end;
                        end;
                    end;

                    //Check Absence
                    EmployeeAbsence.SetRange("Employee No.", "Employee No.");
                    EmployeeAbsence.SetFilter("From Date", '<=%1', TrainngSchLine."Start Date");
                    EmployeeAbsence.SetFilter("To Date", '>=%1', TrainngSchLine."Start Date");
                    if EmployeeAbsence.Find('-') then begin
                        if not Confirm(Text003, false, "Employee No.", EmployeeAbsence.Description) then
                            Error('Nomination not allowed');
                    end else begin
                        EmployeeAbsence.SetFilter("From Date", '<=%1', TrainngSchLine."End Date");
                        EmployeeAbsence.SetFilter("To Date", '>=%1', TrainngSchLine."End Date");
                        if EmployeeAbsence.Find('-') then
                            if not Confirm(Text001, false, "Employee No.", EmployeeAbsence.Description) then
                                Error('Nomination not allowed');
                    end;

                end;
            end;
        }
        field(8; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = filter(Standard));
        }
        field(9; "Staff Category"; Code[10])
        {
            Editable = false;
        }
        field(10; "Nominated By"; Code[20])
        {
            TableRelation = Employee;
        }
        field(11; Status; Option)
        {
            OptionCaption = 'Nominated,Invited,Rejected,Not Attended,Evaluated';
            OptionMembers = Nominated,Invited,Rejected,"Not Attended",Evaluated;

            trigger OnValidate()
            begin
                if (Status in [0, 1, 4]) and (CurrFieldNo <> 0) then
                    Error('Status cannot be changed manually!');

                // set to zero
                if Status in [2, 3] then begin
                    "Attendance (%)" := 0;
                    "Participation Level" := 0;
                    Relevance := 0;
                    "Assessment Score (%)" := 0;
                end;
            end;
        }
        field(12; "Attendance (%)"; Decimal)
        {
            BlankZero = true;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Attendance (%)" = 0 then
                    Status := Status::"Not Attended"
                else
                    Status := Status::Invited;
            end;
        }
        field(13; "Participation Level"; Option)
        {
            OptionMembers = " ","Very High","Average",Low,"Not Active";

            trigger OnValidate()
            begin
                if ("Participation Level" <> 0) and (Status in [2, 3]) then
                    Error('Status must not be %1!', Status);
            end;
        }
        field(14; Relevance; Option)
        {
            OptionMembers = " ","Not Relevant","Fairly Relevant","Highly Relevant";

            trigger OnValidate()
            begin
                if (Relevance <> 0) and (Status <> Status::Evaluated) then
                    Error('Status must be %1!', Status::Evaluated);

                case Relevance of
                    0:
                        "Relevance Score" := 0;
                    1:
                        "Relevance Score" := 1;
                    2:
                        "Relevance Score" := 3;
                    3:
                        "Relevance Score" := 5;
                end;
            end;
        }
        field(15; "Assessment Score (%)"; Decimal)
        {
            BlankZero = true;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Assessment Score (%)" <> 0) and (Status in [2, 3]) then
                    Error('Status must not be %1!', Status);
            end;
        }
        field(16; Recommendation; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const(0),
                                                                     "No." = field("Schedule Code"),
                                                                     "Table Line No." = field("Line No."),
                                                                     "Training Type" = const(Attendance),
                                                                     "Employee No." = field("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; Duration; Code[10])
        {
            DateFormula = true;
        }
        field(18; "Start Date"; Date)
        {
        }
        field(19; "End Date"; Date)
        {
        }
        field(20; "Begin Time"; Time)
        {
        }
        field(21; "End Time"; Time)
        {
        }
        field(22; "Internal/External"; Option)
        {
            OptionMembers = Internal,External;
        }
        field(23; "Grade Level"; Code[10])
        {
            Editable = false;
            TableRelation = "Grade Level";
        }
        field(24; "Facilitator Competence"; Option)
        {
            OptionMembers = " ","Not Qualified",Moderately,"Highly Qualified";

            trigger OnValidate()
            begin
                if ("Facilitator Competence" <> 0) and (Status in [2, 3]) then
                    Error('Status must not be %1!', Status);

                case "Facilitator Competence" of
                    0:
                        "Competence Score" := 0;
                    1:
                        "Competence Score" := 1;
                    2:
                        "Competence Score" := 3;
                    3:
                        "Competence Score" := 5;
                end;
            end;
        }
        field(25; "Competence Score"; Decimal)
        {
        }
        field(26; Comprehensiveness; Option)
        {
            OptionMembers = " ","Not Comprehensive",Fairly,Sufficiently;

            trigger OnValidate()
            begin
                if ("Facilitator Competence" <> 0) and (Status in [2, 3]) then
                    Error('Status must not be %1!', Status);

                case "Facilitator Competence" of
                    0:
                        "Competence Score" := 0;
                    1:
                        "Competence Score" := 1;
                    2:
                        "Competence Score" := 3;
                    3:
                        "Competence Score" := 5;
                end;
            end;
        }
        field(27; "Comprehensiveness Score"; Decimal)
        {
        }
        field(28; "Logical Format"; Option)
        {
            OptionMembers = " ",No,"Not Really",Yes;

            trigger OnValidate()
            begin
                if ("Logical Format" <> 0) and (Status in [2, 3]) then
                    Error('Status must not be %1!', Status);

                case "Logical Format" of
                    0:
                        "Logical Format Score" := 0;
                    1:
                        "Logical Format Score" := 1;
                    2:
                        "Logical Format Score" := 3;
                    3:
                        "Logical Format Score" := 5;
                end;
            end;
        }
        field(29; "Logical Format Score"; Decimal)
        {
        }
        field(30; "Adequate Time"; Option)
        {
            OptionMembers = " ",No,"Not Really",Yes;

            trigger OnValidate()
            begin
                if ("Adequate Time" <> 0) and (Status in [2, 3]) then
                    Error('Status must not be %1!', Status);

                case "Adequate Time" of
                    0:
                        "Adequate Time Score" := 0;
                    1:
                        "Adequate Time Score" := 1;
                    2:
                        "Adequate Time Score" := 3;
                    3:
                        "Adequate Time Score" := 5;
                end;
            end;
        }
        field(31; "Adequate Time Score"; Decimal)
        {
        }
        field(32; "Delivery Mode"; Option)
        {
            OptionMembers = " ",Poor,Fair,Good;

            trigger OnValidate()
            begin
                if ("Delivery Mode" <> 0) and (Status in [2, 3]) then
                    Error('Status must not be %1!', Status);

                case "Delivery Mode" of
                    0:
                        "Delivery Mode Score" := 0;
                    1:
                        "Delivery Mode Score" := 1;
                    2:
                        "Delivery Mode Score" := 3;
                    3:
                        "Delivery Mode Score" := 5;
                end;
            end;
        }
        field(33; "Delivery Mode Score"; Decimal)
        {
        }
        field(34; "Relevance Score"; Decimal)
        {
        }
        field(35; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = filter(Standard));
        }
        field(36; "Venue Code"; Code[10])
        {
        }
        field(37; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(38; "Transfer Skills"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Schedule Code", "Line No.", "Employee No.")
        {
            Clustered = true;
            SumIndexFields = "Competence Score", "Comprehensiveness Score", "Logical Format Score", "Adequate Time Score", "Delivery Mode Score", "Relevance Score";
        }
        key(Key2; "Training Code", "Start Date", Status)
        {
        }
        key(Key3; "Global Dimension 1 Code", "Start Date", Status)
        {
        }
        key(Key4; Status)
        {
            SumIndexFields = "Competence Score", "Comprehensiveness Score", "Logical Format Score", "Adequate Time Score", "Delivery Mode Score", "Relevance Score";
        }
        key(Key5; "Line No.", "Schedule Code")
        {
        }
        key(Key6; "Training Code", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        // copy fields from Training Schedule Line
        TrainngSchLine.Get("Schedule Code", "Line No.");
        "Training Code" := TrainngSchLine."Training Code";
        "Reference No." := TrainngSchLine."Reference No.";
        "Description/Title" := TrainngSchLine."Description/Title";
        Type := TrainngSchLine.Type;
        Duration := TrainngSchLine.Duration;
        "Start Date" := TrainngSchLine."Start Date";
        "End Date" := TrainngSchLine."End Date";
        "Begin Time" := TrainngSchLine."Begin Time";
        "End Time" := TrainngSchLine."End Time";
        "Internal/External" := TrainngSchLine."Internal/External";
        "Venue Code" := TrainngSchLine."Venue Code";
    end;

    trigger OnModify()
    begin
        if (Relevance <> 0) or
           ("Facilitator Competence" <> 0) or
           (Comprehensiveness <> 0) or
           ("Logical Format" <> 0) or
           ("Adequate Time" <> 0) or
           ("Delivery Mode" <> 0) then
            Status := Status::Evaluated;
    end;

    var
        Employee: Record Employee;
        TrainngSchLine: Record "Training Schedule Line";
        TrainingAttendance: Record "Training Attendance";
        LeaveScheduleLine: Record "Leave Schedule Line";
        Text001: label 'Employee %1 already scheduled for Training: %2 between %3 and %4!\ Schedule Anyway?';
        Text002: label 'Employee %1 already scheduled for leave between %2 and %3!\Schedule Anyway?';
        EmployeeAbsence: Record "Employee Absence";
        Text003: label 'Employee %1 is on %2 within this period! Schedule Anyway?';
}

