Page 52092473 "Appraisal Template -Sup"
{
    Caption = 'Performance Template';
    PageType = Document;
    SourceTable = "Appraisal Template Header";
    SourceTableView = where("Employee Dependent"=const(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(SectionCode;"Section Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SectionalWeight;"Sectional Weight")
                {
                    ApplicationArea = Basic;
                }
                field(TemplateCode;"Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(PerformanceType;"Appraisal Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Type';
                }
                field(WeightSum;"Weight Sum")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Template Status")
            {
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Filters)
            {
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GradeLevelCode;"Grade Level Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Staff Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category';
                }
                field(JobTitleCode;"Job Title Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeDependent;"Employee Dependent")
                {
                    ApplicationArea = Basic;
                }
                field(AdditionalReviewerRequired;"Additional Reviewer Required")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Personal Information")
            {
                field(EmployeeFullName;"Employee Full Name")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeJobTitle;"Employee Job Title")
                {
                    ApplicationArea = Basic;
                }
                field(ManagerNo;"Manager No")
                {
                    ApplicationArea = Basic;
                }
                field(ManagerName;"Manager Name")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000014;"Appraisal Template SubForm")
            {
                Caption = 'Template Lines';
                SubPageLink = "Section Code"=field("Section Code"),
                              "Template Code"=field("Template Code"),
                              "Appraisal Type"=field("Appraisal Type");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Fuctions)
            {
                Caption = 'Fuctions';
                action(AttachEmployees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Attach Employees';
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Employee Appraisal Template";
                    RunPageLink = "Section Code"=field("Section Code"),
                                  "Group Code"=field("Template Code"),
                                  "Appraisal Type"=field("Appraisal Type");
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetUserView;
    end;

    local procedure SetUserView()
    var
        MyUserSetup: Record "User Setup";
    begin
        MyUserSetup.Get(UserId);
        MyUserSetup.TestField("Employee No.");
        SetRange("Manager No",MyUserSetup."Employee No.");
        SetRange(Location,Location::Supervisor);
    end;
}

