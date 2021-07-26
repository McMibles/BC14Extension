Table 52092206 "Training Category"
{
    DrillDownPageID = "Training Categories";
    LookupPageID = "Training Categories";

    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;"Description/Title";Text[40])
        {
        }
        field(3;Type;Code[10])
        {
            TableRelation = "Training Type";
        }
        field(4;"Venue Code";Code[10])
        {
            TableRelation = "Training Facility".Code where (Type=filter(Venue));

            trigger OnValidate()
            begin
                if VenueRec.Get(VenueRec.Type::Venue,"Venue Code") then
                  Venue := VenueRec.Description;
            end;
        }
        field(5;Venue;Text[30])
        {
            Editable = false;
        }
        field(6;Duration;DateFormula)
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
        key(Key2;"Description/Title")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code","Description/Title")
        {
        }
    }

    var
        VenueRec: Record "Training Facility";
}

