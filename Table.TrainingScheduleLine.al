Table 52092208 "Training Schedule Line"
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
                if "Training Code" <> '' then begin
                    Training.Get("Training Code");
                    "Description/Title" := Training."Description/Title";
                    Type := Training.Type;
                end;
                if TrainingSchHeader.Get("Schedule Code") then begin
                    "Start Date" := TrainingSchHeader."From Date";
                    "End Date" := TrainingSchHeader."To Date";
                    Duration := TrainingSchHeader.Duration;
                end;
            end;
        }
        field(4; "Reference No."; Code[20])
        {
            NotBlank = true;
        }
        field(5; "Description/Title"; Text[40])
        {
        }
        field(6; "Venue Code"; Code[10])
        {
            TableRelation = "Training Facility".Code where(Type = const(Venue));

            trigger OnValidate()
            begin
                Validate("Expected No. of Participant");
            end;
        }
        field(7; "Target Group"; Text[30])
        {
        }
        field(8; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1),
                                                          "Dimension Value Type" = filter(Standard));
        }
        field(9; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            Caption = 'Cost-centre Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2),
                                                          "Dimension Value Type" = filter(Standard));
        }
        field(10; "Estimated Cost"; Decimal)
        {

            trigger OnValidate()
            begin
                "Actual Cost" := "Estimated Cost";
            end;
        }
        field(11; Facilitator; Code[10])
        {
            TableRelation = "Training Facility".Code where(Type = const(Facilitator));

            trigger OnValidate()
            begin
                Validate("Expected No. of Participant");
            end;
        }
        field(12; Duration; Code[10])
        {
            DateFormula = true;

            trigger OnValidate()
            begin
                if "Start Date" <> 0D then
                    Validate("End Date", CalcDate(Format(Duration) + '-1D', "Start Date"));
            end;
        }
        field(13; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                TrainingSchHeader.Get("Schedule Code");
                if ("Start Date" <> 0D) and ("Start Date" < TrainingSchHeader."From Date") then
                    Error('Start Date outside allowed range!');

                Validate("End Date", CalcDate(Format(Duration) + '-1D', "Start Date"));
            end;
        }
        field(14; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                TrainingSchHeader.Get("Schedule Code");
                if ("End Date" <> 0D) and ("End Date" > TrainingSchHeader."To Date") then
                    Error('End Date outside allowed range!');
            end;
        }
        field(15; "Begin Time"; Time)
        {
        }
        field(16; "End Time"; Time)
        {
        }
        field(17; "Internal/External"; Option)
        {
            OptionMembers = Internal,External;
        }
        field(18; "Expected No. of Participant"; Integer)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                VenueCost := 0;
                FacilitatorCost := 0;
                EquipmentCost := 0;
                if "Venue Code" <> '' then begin
                    Venue.Get(Venue.Type::Venue, "Venue Code");
                    case Venue."Costing Method" of
                        0:
                            VenueCost := Venue.Amount;
                        1:
                            VenueCost := Venue.Amount * "Expected No. of Participant";
                        2:
                            VenueCost := ("End Date" - "Start Date") * Venue.Amount;
                    end;
                end;
                if Facilitator <> '' then begin
                    FacilitatorRec.Get(FacilitatorRec.Type::Facilitator, Facilitator);
                    case FacilitatorRec."Costing Method" of
                        0:
                            FacilitatorCost := FacilitatorRec.Amount;
                        1:
                            FacilitatorCost := FacilitatorRec.Amount * "Expected No. of Participant";
                        2:
                            FacilitatorCost := ("End Date" - "Start Date") * FacilitatorRec.Amount;
                    end;
                end;
                if "Equipment Code" <> '' then begin
                    Equipment.Get(Equipment.Type::Equipment, "Equipment Code");
                    case Equipment."Costing Method" of
                        0:
                            EquipmentCost := Equipment.Amount;
                        1:
                            EquipmentCost := Equipment.Amount * "Expected No. of Participant";
                        2:
                            EquipmentCost := ("End Date" - "Start Date") * Equipment.Amount;
                    end;
                end;

                "Estimated Cost" := VenueCost + FacilitatorCost + EquipmentCost;
            end;
        }
        field(19; "Equipment Code"; Code[10])
        {
            TableRelation = "Training Facility".Code where(Type = const(Equipment));

            trigger OnValidate()
            begin
                Validate("Expected No. of Participant");
            end;
        }
        field(22; "No. of Nomination"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Training Attendance" where("Schedule Code" = field("Schedule Code"),
                                                             "Line No." = field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23; "No. of Participant"; Integer)
        {
            BlankZero = true;
            CalcFormula = count("Training Attendance" where("Schedule Code" = field("Schedule Code"),
                                                             "Line No." = field("Line No."),
                                                             Status = filter(Evaluated)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; "Pre-requisite to"; Code[10])
        {
        }
        field(25; Status; Option)
        {
            OptionMembers = Scheduled,"On-going",Concluded,Closed;
        }
        field(26; "Highly Relevant?"; Boolean)
        {
            CalcFormula = exist("Training Attendance" where("Schedule Code" = field("Schedule Code"),
                                                             "Line No." = field("Line No."),
                                                             Relevance = const("Highly Relevant")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "Actual Cost"; Decimal)
        {
            BlankZero = true;
        }
        field(28; Recommendation; Boolean)
        {
        }
        field(29; "Facilitator Competence"; Option)
        {
            CalcFormula = lookup("Training Attendance"."Facilitator Competence" where("Schedule Code" = field("Schedule Code"),
                                                                                       "Line No." = field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ","Not Qualified",Moderately,"Highly Qualified";
        }
        field(30; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const(0),
                                                                     "No." = field("Schedule Code"),
                                                                     "Table Line No." = field("Line No."),
                                                                     "Training Type" = const(Line)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(31; Type; Code[10])
        {
            TableRelation = "Training Type";
        }
        field(32; Comprehensiveness; Option)
        {
            CalcFormula = lookup("Training Attendance".Comprehensiveness where("Schedule Code" = field("Schedule Code"),
                                                                                "Line No." = field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ","Not Comprehensive",Fairly,Sufficiently;
        }
        field(33; "Logical Format"; Option)
        {
            CalcFormula = lookup("Training Attendance"."Logical Format" where("Schedule Code" = field("Schedule Code"),
                                                                               "Line No." = field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ",No,"Not Really",Yes;
        }
        field(34; "Adequate Time"; Option)
        {
            CalcFormula = lookup("Training Attendance"."Adequate Time" where("Schedule Code" = field("Schedule Code"),
                                                                              "Line No." = field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ",No,"Not Really",Yes;
        }
        field(35; "Delivery Mode"; Option)
        {
            CalcFormula = lookup("Training Attendance"."Delivery Mode" where("Schedule Code" = field("Schedule Code"),
                                                                              "Line No." = field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ",Poor,Fair,Good;
        }
        field(36; "User ID"; Code[50])
        {
            TableRelation = User;
        }
        field(37; "Competence Score"; Decimal)
        {
            BlankZero = true;
            CalcFormula = average("Training Attendance"."Competence Score" where("Schedule Code" = field("Schedule Code"),
                                                                                  "Line No." = field("Line No."),
                                                                                  Status = const(Evaluated)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Comprehensiveness Score"; Decimal)
        {
            BlankZero = true;
            CalcFormula = average("Training Attendance"."Comprehensiveness Score" where("Schedule Code" = field("Schedule Code"),
                                                                                         "Line No." = field("Line No."),
                                                                                         Status = const(Evaluated)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Logical Format Score"; Decimal)
        {
            BlankZero = true;
            CalcFormula = average("Training Attendance"."Logical Format Score" where("Schedule Code" = field("Schedule Code"),
                                                                                      "Line No." = field("Line No."),
                                                                                      Status = const(Evaluated)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Adequate Time Score"; Decimal)
        {
            BlankZero = true;
            CalcFormula = average("Training Attendance"."Adequate Time Score" where("Schedule Code" = field("Schedule Code"),
                                                                                     "Line No." = field("Line No."),
                                                                                     Status = const(Evaluated)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(41; "Delivery Mode Score"; Decimal)
        {
            BlankZero = true;
            CalcFormula = average("Training Attendance"."Delivery Mode Score" where("Schedule Code" = field("Schedule Code"),
                                                                                     "Line No." = field("Line No."),
                                                                                     Status = const(Evaluated)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(42; "Relevance Score"; Decimal)
        {
            BlankZero = true;
            CalcFormula = average("Training Attendance"."Relevance Score" where("Schedule Code" = field("Schedule Code"),
                                                                                 "Line No." = field("Line No."),
                                                                                 Status = const(Evaluated)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; Relevance; Option)
        {
            CalcFormula = lookup("Training Attendance".Relevance where("Schedule Code" = field("Schedule Code"),
                                                                        "Line No." = field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
            OptionMembers = " ","Not Relevant","Fairly Relevant","Highly Relevant";
        }
    }

    keys
    {
        key(Key1; "Schedule Code", "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Estimated Cost", "Actual Cost";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatusOpen;
    end;

    trigger OnInsert()
    begin
        TestField("Reference No.");
        TestField("Training Code");
        TestStatusOpen;
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
    end;

    var
        Training: Record "Training Category";
        TrainingSchHeader: Record "Training Schedule Header";
        ScheduleCode: Record "Training Schedule Line";
        Venue: Record "Training Facility";
        FacilitatorRec: Record "Training Facility";
        Equipment: Record "Training Facility";
        VenueCost: Decimal;
        FacilitatorCost: Decimal;
        EquipmentCost: Integer;
        StatusCheckSuspended: Boolean;


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetTrainingScheduleHeader;
        TrainingSchHeader.TestField(Status, TrainingSchHeader.Status::Open);
    end;


    procedure GetTrainingScheduleHeader()
    begin
        TrainingSchHeader.Get("Schedule Code");
    end;


    procedure SuspendStatusCheck(var Suspend: Boolean): Boolean
    begin
        StatusCheckSuspended := Suspend;
    end;
}

