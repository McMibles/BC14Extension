Report 52092355 "Suggest Training Nominations"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Training Schedule Line"; "Training Schedule Line")
        {
            DataItemTableView = sorting("Schedule Code", "Line No.");
            column(ReportForNavId_9740; 9740)
            {
            }
        }
        dataitem(Employee; Employee)
        {
            DataItemLinkReference = "Training Schedule Line";
            RequestFilterFields = "No.", "Grade Level Code", "Job Title Code", "Global Dimension 2 Code";
            column(ReportForNavId_7528; 7528)
            {
            }

            trigger OnAfterGetRecord()
            begin
                // use delimitations
                // Status
                if Employee.Status <> Employee.Status::Active
                  then
                    CurrReport.Skip;

                // Age
                if (MinAge <> 0) or (MaxAge <> 0) then begin
                    if Employee."Birth Date" = 0D then CurrReport.Skip;
                    Age := Date2dmy("Training Schedule Line"."Start Date", 3) - Date2dmy(Employee."Birth Date", 3);
                    if (MinAge <> 0) and (Age < MinAge) then CurrReport.Skip;
                    if (MaxAge <> 0) and (Age > MaxAge) then CurrReport.Skip;
                end;

                // Year of Service
                if NoYearofService <> 0 then begin
                    if Employee."Employment Date" = 0D then CurrReport.Skip;
                    if NoYearofService > (Date2dmy("Training Schedule Line"."Start Date", 3) - Date2dmy(Employee."Employment Date", 3)) then
                        CurrReport.Skip;
                end;

                // Previous Training
                if TrainingCode <> '' then begin
                    TrainingAttendance.SetCurrentkey("Training Code", "Employee No.");
                    TrainingAttendance.SetRange(TrainingAttendance."Training Code", TrainingCode);
                    TrainingAttendance.SetRange(TrainingAttendance."Employee No.", Employee."No.");
                    if not TrainingAttendance.Find('-') then CurrReport.Skip;
                end;

                begin
                    Window.Update(4, Employee."No.");
                    Nomination.Init;
                    Nomination."Schedule Code" := "Training Schedule Line"."Schedule Code";
                    Nomination."Line No." := "Training Schedule Line"."Line No.";
                    Nomination.Validate(Nomination."Employee No.", Employee."No.");
                    Nomination."Training Code" := "Training Schedule Line"."Training Code";
                    Nomination."Reference No." := "Training Schedule Line"."Reference No.";
                    Nomination."Description/Title" := "Training Schedule Line"."Description/Title";
                    Nomination.Type := "Training Schedule Line".Type;
                    Nomination.Duration := "Training Schedule Line".Duration;
                    Nomination."Start Date" := "Training Schedule Line"."Start Date";
                    Nomination."End Date" := "Training Schedule Line"."End Date";
                    Nomination."Begin Time" := "Training Schedule Line"."Begin Time";
                    Nomination."End Time" := "Training Schedule Line"."End Time";
                    Nomination."Internal/External" := "Training Schedule Line"."Internal/External";
                    if Nomination.Status = Nomination.Status::Rejected then
                        CurrReport.Skip;
                    if Nomination.Insert then;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  'Training Description #1##################\\' +
                  'Reference No.  #2#############\' +
                  'Training Code  #3#############\' +
                  'Employee No.   #4#############\');

                Window.Update(1, "Training Schedule Line"."Description/Title");
                Window.Update(2, "Training Schedule Line"."Reference No.");
                Window.Update(3, "Training Schedule Line"."Training Code");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(NominationCriteria)
                {
                    Caption = 'Nomination Criteria';
                    field(MinAge; MinAge)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Min. Age';
                    }
                    field(MaxAge; MaxAge)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Max. Age';
                    }
                    field(NoYearofService; NoYearofService)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Yrs of Service';
                    }
                    field(TrainingCode; TrainingCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Previous Training';
                        TableRelation = "Training Category";
                    }
                    field(UseSkillGap; UseSkillGap)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Use Skill Gap';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Nomination: Record "Training Attendance";
        TrainingAttendance: Record "Training Attendance";
        MinQualification: Code[10];
        TrainingCode: Code[10];
        ScheduleCode: Code[10];
        ReferenceNo: Code[10];
        LineNo: Integer;
        MinAge: Integer;
        MaxAge: Integer;
        Age: Integer;
        NoYearofService: Integer;
        UseSkillGap: Boolean;
        Window: Dialog;
}

