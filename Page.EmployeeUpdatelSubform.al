Page 52092415 "Employee Updatel Subform"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Employee Update Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(GradeLevel;"Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field(NewGradeLevel;"New Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field(GrossSalary;"Gross Salary")
                {
                    ApplicationArea = Basic;
                }
                field(Increment;"Increment %")
                {
                    ApplicationArea = Basic;
                }
                field(NewGrossSalary;"New Gross Salary")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(NewGlobalDimension1Code;"New Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(JobTitleCode;"Job Title Code")
                {
                    ApplicationArea = Basic;
                }
                field(NewJobTitle;"New Job Title")
                {
                    ApplicationArea = Basic;
                }
                field(NewDesignation;"New Designation")
                {
                    ApplicationArea = Basic;
                }
                field(NewCategory;"New Category")
                {
                    ApplicationArea = Basic;
                }
                field(SalaryGroup;"Salary Group")
                {
                    ApplicationArea = Basic;
                }
                field(NewSalaryGroup;"New Salary Group")
                {
                    ApplicationArea = Basic;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        PromotionJnlBatchPost: Codeunit "Employee Update-Post";
        EmpJnlManagement: Codeunit EmployeeJnlMgt;
        EmployeeUpdate: Record "Employee Update Header";
        RecRef: RecordRef;
        ApprovalsMgmt: Codeunit "Approvals Hook";
        Text001: label 'Employee Update Status must be approved before Application!';
        Text002: label 'Status must be Open!';
}

