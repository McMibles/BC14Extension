Page 52092361 "Internal Applicant Card"
{
    DeleteAllowed = false;
    SourceTable = Applicant;
    SourceTableView = where("Internal/External" = const(Internal));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo; "Employee No.")
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
                field(MiddleName; "Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field(Title; Title)
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
                field(CountryRegionCode; "Country/Region Code")
                {
                    ApplicationArea = Basic;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status"; "Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field(InternalExternal; "Internal/External")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentDepartment; "Current Department")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentUnit; "Current Unit")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentEmployeeCategory; "Current Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentGradeLevel; "Current Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentJobTitleCode; "Current Job Title Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Communication)
            {
                field(PhoneNo; "Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(MobilePhoneNo; "Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(EMail; "E-Mail")
                {
                    ApplicationArea = Basic;
                }
                field(AltAddressCode; "Alt. Address Code")
                {
                    ApplicationArea = Basic;
                }
                field(AltAddressStartDate; "Alt. Address Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(AltAddressEndDate; "Alt. Address End Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Administration)
            {
                field(DateReceived; "Date Received")
                {
                    ApplicationArea = Basic;
                }
                field(PositionDesired; "Position Desired")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
                field("Post Qualification Empl Date"; "Post Qualification Empl Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Qualification Empl Date';
                }
                field(CurrentAppointment; "Current  Appointment")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentAppointmentDate; "Current Appointment Date")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentBasicSalary; "Current Basic Salary")
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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        "Internal/External" := "internal/external"::Internal;
    end;
}

