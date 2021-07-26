Page 52092367 "External Applicant List"
{
    CardPageID = "External Applicant Card";
    Editable = false;
    PageType = List;
    SourceTable = Applicant;
    SourceTableView = where("Internal/External" = const(External));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }
                field(FirstName; "First Name")
                {
                    ApplicationArea = Basic;
                }
                field(LastName; "Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Address; Address)
                {
                    ApplicationArea = Basic;
                }
                field(Address2; "Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(City; City)
                {
                    ApplicationArea = Basic;
                }
                field(PostCode; "Post Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1000000010>")
            {
                Caption = 'Applicant';
                action("<Action1000000011>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Referees';
                    Image = Relationship;
                    RunObject = Page "Applicant Referee List";
                    RunPageLink = "No." = field("No.");
                }
                action("<Action1000000041>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    RunObject = Page "Applicant Qualifications";
                    RunPageLink = "Record Type" = const(Applicant),
                                  "No." = field("No.");
                }
                action("<Action1000000042>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Working Experience';
                    Image = Worksheet;
                    RunObject = Page "Applicant Employment History";
                    RunPageLink = "Record Type" = const(Applicant),
                                  "No." = field("No.");
                }
                action(Skills)
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    Image = Skills;
                    RunObject = Page "Skill Entry";
                    RunPageLink = "Record Type" = const(Applicant),
                                  "No." = field("No.");
                }
            }
        }
    }
}

