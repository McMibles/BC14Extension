Table 52092227 "Appraisal Section Score"
{

    fields
    {
        field(1;"Score Code";Code[10])
        {
            TableRelation = "Score Setup".Code where ("Record Type"=const("Appraisal Score"));

            trigger OnValidate()
            begin
                if "Score Code" <> '' then begin
                  Score.Get(1,"Score Code");
                  "Score Description" := Score.Description;
                end;
            end;
        }
        field(2;"Section Code";Code[20])
        {
            TableRelation = "Appraisal Section";
        }
        field(3;Include;Boolean)
        {
        }
        field(4;Percentage;Decimal)
        {
        }
        field(5;Marks;Decimal)
        {
        }
        field(6;"Score Description";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Section Code","Score Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Score: Record "Score Setup";
}

