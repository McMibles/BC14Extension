Table 52092207 "Training Schedule Header"
{

    fields
    {
        field(1; "Code"; Code[10])
        {
            Editable = false;
        }
        field(2; "Objective/Theme"; Text[50])
        {
        }
        field(3; "From Date"; Date)
        {

            trigger OnValidate()
            begin
                if Duration <> '' then
                    "To Date" := CalcDate(Format(Duration) + '-1D', "From Date")
            end;
        }
        field(4; "To Date"; Date)
        {
        }
        field(5; Duration; Code[10])
        {
            DateFormula = true;

            trigger OnValidate()
            begin
                TestField("From Date");
                "To Date" := CalcDate(Format(Duration) + '-1D', "From Date");
            end;
        }
        field(6; "Budget Amount"; Decimal)
        {
        }
        field(10; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const(0),
                                                                     "No." = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Estimated Cost"; Decimal)
        {
            CalcFormula = sum("Training Schedule Line"."Estimated Cost" where("Schedule Code" = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Actual Cost"; Decimal)
        {
            CalcFormula = sum("Training Schedule Line"."Actual Cost" where("Schedule Code" = field(Code)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Discontinued,Concluded';
            OptionMembers = Open,Approved,"Pending Approval",Discontinued,Concluded;
        }
        field(14; "No. Series"; Code[10])
        {
        }
        field(15; "Venue Code"; Code[10])
        {
            TableRelation = "Training Facility".Code where(Type = const(Venue));
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if Code = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Training Schedule Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Training Schedule Nos.", xRec."No. Series", 0D, Code, "No. Series");
        end;
    end;

    trigger OnModify()
    begin
        TestField("From Date");
        TestField("To Date");
        TestField("Objective/Theme");
        TestField(Status, Status::Open);
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit 396;
}

