Table 52092457 "Work Days Schedule"
{
    DrillDownPageID = "Work Days Schedule List";
    LookupPageID = "Work Days Schedule List";

    fields
    {
        field(1;"Working day ID";Code[20])
        {
        }
        field(2;Description;Text[50])
        {
        }
        field(3;Monday;Boolean)
        {
        }
        field(4;Tuesday;Boolean)
        {
        }
        field(5;Wednesday;Boolean)
        {
        }
        field(6;Thursday;Boolean)
        {
        }
        field(7;Friday;Boolean)
        {
        }
        field(8;Saturday;Boolean)
        {
        }
        field(9;Sunday;Boolean)
        {
        }
        field(10;"Monday Overtime";Boolean)
        {
        }
        field(11;"Tuesday Overtime";Boolean)
        {
        }
        field(12;"Wednesday Overtime";Boolean)
        {
        }
        field(13;"Thursday overtime";Boolean)
        {
        }
        field(14;"Friday Overtime";Boolean)
        {
        }
        field(15;"Saturday Overtime";Boolean)
        {
        }
        field(16;"Sunday Overtime";Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Working day ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

