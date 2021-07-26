Table 52092244 "Additional Reviewer"
{

    fields
    {
        field(1;"Section Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Appraisal Period Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3;"Appraisal Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Mid-Year,Year End,Monthly,Quarterly';
            OptionMembers = "Mid-Year","Year End",Monthly,Quarterly;
        }
        field(4;"Appraisee Employee No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5;Comment;Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(6;"Additional Comment";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(51;"Date Created";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52;"Last Date Modified";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(53;"Last Modified By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(54;"Appraisal Template Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(55;"Mark As Completed";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Section Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

