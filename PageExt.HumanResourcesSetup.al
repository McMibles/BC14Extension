PageExtension 52000050 pageextension52000050 extends "Human Resources Setup"
{
    layout
    {
        //modify("Employee Nos.")
        //{
        //ApplicationArea = Basic;

        //Unsupported feature: Property Modification (SourceExpr) on ""Employee Nos."(Control 2)".


        //Unsupported feature: Property Modification (Name) on ""Employee Nos."(Control 2)".

        // }

        //Unsupported feature: Property Deletion (ToolTipML) on ""Employee Nos."(Control 2)".

        addafter("Automatically Create Resource")
        {
            field("AutoUpdatePayroll Employee"; "AutoUpdatePayroll Employee")
            {
                ApplicationArea = Basic;
            }
            field("Interview Score Recording"; "Interview Score Recording")
            {
                ApplicationArea = Basic;
            }
            group("Leave Setup")
            {
                field("Annual Leave Code"; "Annual Leave Code")
                {
                    ApplicationArea = Basic;
                }
                field("Casual Leave Code"; "Casual Leave Code")
                {
                    ApplicationArea = Basic;
                }
                field("Min. Day(s) for Leave Allow."; "Min. Day(s) for Leave Allow.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This is the minimum number of days a user must apply for to get leave allowance';
                }
                field("Leave Allowance Payment Option"; "Leave Allowance Payment Option")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This indicates how leave allowance will be paid. Voucher means it won''t be paid as part of the salary while Payroll means it will be paid as part of a month''s salary';
                }
                field("Req. Month for Leave Allow."; "Req. Month for Leave Allow.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This is applicable to new employees. It states the number of months that a new emloyee must have worked to earn leave allowance';
                }
            }
            group(Control34)
            {
                Caption = 'Numbering';
                //field("Employee Nos."; "Employee Nos.")
                //{
                //  ApplicationArea = BasicHR;
                //ToolTip = 'Specifies the number series code to use when assigning numbers to employees.';
                //}
                field("Job Title Nos."; "Job Title Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Applicant Nos."; "Applicant Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Vacancy Nos."; "Vacancy Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Document Nos."; "Document Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Interview Nos."; "Interview Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Appraisal Template Nos."; "Appraisal Template Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Absence No."; "Employee Absence No.")
                {
                    ApplicationArea = Basic;
                }
                field("Referee Nos."; "Referee Nos.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        addafter("Employee Nos.")
        {
            field("Query Nos."; "Query Nos.")
            {
                ApplicationArea = Basic;
            }
            field("Exit No."; "Exit No.")
            {
                ApplicationArea = Basic;
            }
            field("Training Schedule Nos."; "Training Schedule Nos.")
            {
                ApplicationArea = Basic;
            }
            field("Employee Update Nos."; "Employee Update Nos.")
            {
                ApplicationArea = Basic;
            }
        }
        moveafter(Numbering; "Base Unit of Measure")
    }
}

