Table 52092230 "Appraisal Skill Gap"
{

    fields
    {
        field(1;"Appraisal Period";Code[20])
        {
        }
        field(2;"Appraisal Type";Option)
        {
            OptionMembers = "Mid Year","Year End";
        }
        field(3;"Employee No.";Code[10])
        {
            Editable = false;
            TableRelation = Employee;
        }
        field(4;"Line No.";Integer)
        {
        }
        field(5;"Skill Code";Code[10])
        {
        }
        field(6;"Skill Description";Text[50])
        {
        }
        field(7;"Training Required";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Appraisal Period","Appraisal Type","Employee No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

