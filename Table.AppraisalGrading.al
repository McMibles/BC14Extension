Table 52092226 "Appraisal Grading"
{

    fields
    {
        field(1;"Lower Score";Decimal)
        {
        }
        field(2;"Upper Score";Decimal)
        {
        }
        field(3;"No. of Steps";Integer)
        {
        }
        field(4;Remarks;Text[30])
        {
        }
        field(5;"Inflation Increase";Boolean)
        {
        }
        field(6;"Notch Increase";Boolean)
        {
        }
        field(7;"Merit Increase";Boolean)
        {
        }
        field(8;"Bonus Increase";Boolean)
        {
        }
        field(9;"Grade Code";Code[10])
        {
        }
        field(10;"Percentage %";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Lower Score")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

