Table 52092211 "Training Time Table"
{

    fields
    {
        field(1;"Schedule Code";Code[10])
        {
        }
        field(2;"Line No.";Integer)
        {
        }
        field(3;"Training Code";Code[10])
        {
            TableRelation = "Training Category";
        }
        field(4;"Reference No.";Code[20])
        {
            NotBlank = true;
        }
        field(5;"Description/Title";Text[40])
        {
        }
        field(6;"Venue Code";Code[10])
        {
            TableRelation = "Training Facility";
        }
        field(7;"Estimated Cost";Decimal)
        {
        }
        field(8;Facilitator;Code[10])
        {
        }
        field(9;Duration;Code[10])
        {
            DateFormula = true;
        }
        field(10;"Start Date";Date)
        {

            trigger OnValidate()
            begin
                TrainingSchLine.Get("Schedule Code","Line No.");
                if ("Start Date" <> 0D) and ("Start Date" < TrainingSchLine."Start Date") then
                  Error('Start Date outside allowed range!');
            end;
        }
        field(11;"End Date";Date)
        {

            trigger OnValidate()
            begin
                TrainingSchHeader.Get("Schedule Code");
                TrainingSchLine.Get("Schedule Code","Line No.");
                if ("End Date" <> 0D) and  (TrainingSchLine."End Date" <> 0D) then begin
                   if ("End Date" > TrainingSchLine."End Date") then
                     Error('End Date outside allowed range!');
                end else begin
                  if ("End Date" <> 0D) and  (TrainingSchLine."End Date" = 0D) then begin
                    if ("End Date" > TrainingSchHeader."To Date") then
                      Error('End Date outside allowed range!');
                  end;
                end;
                if ("End Date" <> 0D) and ("End Date" < "Start Date") then
                  Error('End Date cannot less than Start Date!');
            end;
        }
        field(12;"Begin Time";Time)
        {
        }
        field(13;"End Time";Time)
        {

            trigger OnValidate()
            begin
                if ("End Time" <> 0T) and ("End Time" < "Begin Time") then
                  Error('End Time %1 cannot be less than Begin Time %2',"End Time","Begin Time");
            end;
        }
        field(14;"Internal/External";Option)
        {
            OptionMembers = Internal,External;
        }
        field(15;"Equipment Code";Code[10])
        {
        }
        field(16;"No. of Participant";Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(17;"Actual Cost";Decimal)
        {
            BlankZero = true;
        }
        field(18;"Delivery Mode";Option)
        {
            CalcFormula = lookup("Training Attendance"."Delivery Mode" where ("Schedule Code"=field("Schedule Code"),
                                                                              "Line No."=field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ",Poor,Fair,Good;
        }
        field(19;"Entry No.";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Schedule Code","Line No.","Entry No.")
        {
            Clustered = true;
            SumIndexFields = "Estimated Cost","Actual Cost";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if TrainingSchLine.Get("Schedule Code","Line No.") then
          "Training Code" := TrainingSchLine."Training Code";
    end;

    trigger OnModify()
    begin
        TestField("Description/Title");
    end;

    var
        Training: Record "Training Category";
        TrainingSchHeader: Record "Training Schedule Header";
        TrainingSchLine: Record "Training Schedule Line";
}

