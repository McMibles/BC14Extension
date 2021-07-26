Page 52092363 "Applicant Referee List"
{
    CardPageID = "Applicant Referee Card";
    Editable = false;
    PageType = List;
    SourceTable = Referee;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Name2;"Name 2")
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field(Address2;"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(Relationship;Relationship)
                {
                    ApplicationArea = Basic;
                }
                field(NoofYears;"No. of Years")
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

