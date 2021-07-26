Codeunit 52092191 TrainingManagement
{

    trigger OnRun()
    begin
    end;

    var
        TrainingAttendance: Record "Training Attendance";
        Facilitator: Record "Training Facility";
        SkillEntry: Record "Skill Entry";
        SkillEntry2: Record "Skill Entry";
        Text001: label 'Are you sure you want to process Evaluation!';
        Text002: label 'Nothing to process!';
        Text003: label 'Course already evaluated!';
        Text004: label 'No Employee found!\Nothing to evaluate';
        Text005: label 'Course Evaluation successfully processed!';
        TrainingSchHeader: Record "Training Schedule Header";
        TrainingScheduleLine2: Record "Training Schedule Line";
        CompanyInfo: Record "Company Information";
        Concluded: Boolean;
        Window: Dialog;


    procedure ProcessTrainingEvaluation(var TrainingScheduleLine: Record "Training Schedule Line")
    begin
        if not Confirm(Text001) then
          exit;
        if TrainingScheduleLine."Schedule Code" = '' then
          Error(Text002);

        if TrainingScheduleLine.Status = TrainingScheduleLine.Status::Concluded then
          Error(Text003);

        Window.Open('Processing Training Evaluation');
        CompanyInfo.Get;
        TrainingScheduleLine.TestField(TrainingScheduleLine."Facilitator Competence");
        TrainingScheduleLine.TestField(TrainingScheduleLine.Comprehensiveness);
        TrainingScheduleLine.TestField(TrainingScheduleLine."Logical Format");
        TrainingScheduleLine.TestField(TrainingScheduleLine."Adequate Time");
        TrainingScheduleLine.TestField(TrainingScheduleLine."Delivery Mode");
        TrainingScheduleLine.TestField(TrainingScheduleLine."Actual Cost");

        TrainingAttendance.SetRange(TrainingAttendance."Schedule Code",TrainingScheduleLine."Schedule Code");
        TrainingAttendance.SetRange(TrainingAttendance."Line No.",TrainingScheduleLine."Line No.");
        if not TrainingAttendance.Find('-') then
          Error(Text004);

        repeat
          if TrainingAttendance.Status <> TrainingAttendance.Status::"Not Attended" then begin
            TrainingAttendance.TestField(TrainingAttendance."Attendance (%)");
            TrainingAttendance.TestField(TrainingAttendance."Participation Level");
            TrainingAttendance.TestField(TrainingAttendance."Assessment Score (%)");
            TrainingAttendance.Modify;
          end;
        until TrainingAttendance.Next = 0;

        TrainingScheduleLine.Status := TrainingScheduleLine.Status::Concluded;
        TrainingScheduleLine."User ID" := UserId;
        TrainingScheduleLine.Modify;
        Window.Close;
        Message(Text005);
    end;


    procedure ProcessTrainingFeedback(var TrainingScheduleLine: Record "Training Schedule Line")
    begin
        if not Confirm('Are you sure you want to process feedback!') then
          exit;

        if TrainingScheduleLine.Status <> TrainingScheduleLine.Status::Concluded then
          Error('Course not yet evaluated!');

        TrainingScheduleLine.TestField(TrainingScheduleLine."Facilitator Competence");
        TrainingScheduleLine.TestField(TrainingScheduleLine.Comprehensiveness);
        TrainingScheduleLine.TestField(TrainingScheduleLine."Logical Format");
        TrainingScheduleLine.TestField(TrainingScheduleLine."Adequate Time");
        TrainingScheduleLine.TestField(TrainingScheduleLine."Delivery Mode");

        TrainingAttendance.SetRange(TrainingAttendance."Schedule Code",TrainingScheduleLine."Schedule Code");
        TrainingAttendance.SetRange(TrainingAttendance."Line No.",TrainingScheduleLine."Line No.");
        if not TrainingAttendance.Find('-') then
          Error('No Employee found!\No Feedback to evaluate');

        repeat
          if TrainingAttendance.Status <> TrainingAttendance.Status::"Not Attended" then begin
            TrainingAttendance.TestField(TrainingAttendance."Attendance (%)");
            TrainingAttendance.TestField(TrainingAttendance."Participation Level");
            TrainingAttendance.TestField(TrainingAttendance.Relevance);
            TrainingAttendance.TestField(TrainingAttendance."Assessment Score (%)");
            TrainingAttendance.Modify;

            // Transfer acquired skills
            if TrainingAttendance."Transfer Skills" then begin
              SkillEntry.SetRange(SkillEntry."Record Type",SkillEntry."record type"::"Courses Attended");
              SkillEntry.SetRange(SkillEntry."No.",TrainingScheduleLine."Schedule Code");
              SkillEntry.SetRange(SkillEntry."Line No.",TrainingScheduleLine."Line No.");
              if SkillEntry.Find('-') then
              repeat
                SkillEntry2.Init;
                SkillEntry2."Record Type" := SkillEntry2."record type"::Employee;
                SkillEntry2."No." := TrainingAttendance."Employee No.";
                SkillEntry2."Skill Code" := SkillEntry."Skill Code";
                SkillEntry2."Line No." := 0;
                SkillEntry2."From Date" :=  TrainingAttendance."Start Date";
                SkillEntry2."To Date" := TrainingAttendance."End Date";
                SkillEntry2."Acquisition Method" := SkillEntry2."acquisition method"::Training;
                SkillEntry2.Description := TrainingAttendance."Description/Title";
                if Facilitator.Get(2,TrainingScheduleLine.Facilitator) then
                  SkillEntry2.Instructor := Facilitator.Description;
                if SkillEntry2.Insert then;

              until SkillEntry.Next = 0;
            end;
          end;
        until TrainingAttendance.Next = 0;

        TrainingScheduleLine.Status := TrainingScheduleLine.Status::Closed;
        TrainingScheduleLine."User ID" := UserId;
        TrainingScheduleLine.Modify;

        Concluded := true;

        TrainingScheduleLine2.SetRange("Schedule Code",TrainingScheduleLine."Schedule Code");
        if TrainingScheduleLine2.Count > 1 then begin
          TrainingScheduleLine2.FindFirst;
          repeat
            if not (TrainingScheduleLine2.Status in [2,3] ) then
              Concluded := false;
          until (TrainingScheduleLine2.Next = 0)
        end;

        if Concluded then begin
          TrainingSchHeader.Get(TrainingScheduleLine."Schedule Code");
          TrainingSchHeader.Status := TrainingSchHeader.Status::Concluded;
          TrainingSchHeader.Modify;
        end;

        Message('Course Feedback successfully processed!');
    end;
}

