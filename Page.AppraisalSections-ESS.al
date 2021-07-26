Page 52092471 "Appraisal Sections -ESS"
{
    Caption = 'Performance Sections';
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Appraisal Section";
    SourceTableView = where("Employee Dependent" = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(SectionalWeight; "Sectional Weight")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeDependent; "Employee Dependent")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory; "Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field(AdditionalReviewerRequired; "Additional Reviewer Required")
                {
                    ApplicationArea = Basic;
                }
                field(AdditionalReviewerSetup; "Additional Reviewer Setup")
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
            group(Section)
            {
                Caption = 'Sections';
                action("<Action1000000009>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Template';
                    Image = Template;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Appraisal Template -ESS";
                    RunPageLink = "Section Code" = field(Name);
                    RunPageMode = Edit;
                }
            }
        }
    }
}

