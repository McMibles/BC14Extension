Table 52092205 "Job Requirement Training"
{

    fields
    {
        field(1; "Job Ref. No."; Code[20])
        {
            TableRelation = "Job Title";
        }
        field(2; "Training Code"; Code[10])
        {

            trigger OnValidate()
            begin
                /*Training.GET("Training Code");
                "Description/Title" := Training."Description/Title";
                Duration := Training.Duration;*/

            end;
        }
        field(3; "Description/Title"; Text[40])
        {
        }
        field(4; Relevance; Option)
        {
            OptionMembers = " ","Highly Relevant","Fairly Relevant","Not Relevant";
        }
        field(5; Duration; DateFormula)
        {
        }
        field(6; "Min. Post Training Period"; Code[20])
        {
        }
        field(7; "Job Title/Description"; Text[40])
        {
        }
    }

    keys
    {
        key(Key1; "Job Ref. No.", "Training Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        JobTitle.Get("Job Ref. No.");
        "Job Title/Description" := JobTitle."Title/Description";
    end;

    var
        Training: Record "Training Category";
        JobTitle: Record "Job Title";
}

