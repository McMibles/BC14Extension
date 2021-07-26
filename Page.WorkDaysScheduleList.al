Page 52093074 "Work Days Schedule List"
{
    CardPageID = "Work Days Schedule Card";
    Editable = false;
    PageType = List;
    SourceTable = "Work Days Schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(WorkingdayID;"Working day ID")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Monday;Monday)
                {
                    ApplicationArea = Basic;
                }
                field(Tuesday;Tuesday)
                {
                    ApplicationArea = Basic;
                }
                field(Wednesday;Wednesday)
                {
                    ApplicationArea = Basic;
                }
                field(Thursday;Thursday)
                {
                    ApplicationArea = Basic;
                }
                field(Friday;Friday)
                {
                    ApplicationArea = Basic;
                }
                field(Saturday;Saturday)
                {
                    ApplicationArea = Basic;
                }
                field(Sunday;Sunday)
                {
                    ApplicationArea = Basic;
                }
                field(MondayOvertime;"Monday Overtime")
                {
                    ApplicationArea = Basic;
                }
                field(TuesdayOvertime;"Tuesday Overtime")
                {
                    ApplicationArea = Basic;
                }
                field(WednesdayOvertime;"Wednesday Overtime")
                {
                    ApplicationArea = Basic;
                }
                field(Thursdayovertime;"Thursday overtime")
                {
                    ApplicationArea = Basic;
                }
                field(FridayOvertime;"Friday Overtime")
                {
                    ApplicationArea = Basic;
                }
                field(SaturdayOvertime;"Saturday Overtime")
                {
                    ApplicationArea = Basic;
                }
                field(SundayOvertime;"Sunday Overtime")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

