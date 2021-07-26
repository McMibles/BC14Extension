PageExtension 52000044 pageextension52000044 extends "Employee Card"
{
    layout
    {
        addafter("Last Name")
        {
            field("Job Title Code"; "Job Title Code")
            {
                ApplicationArea = Basic;
                Caption = 'Job Title Code';
                Importance = Promoted;
            }
        }
        addafter("Job Title")
        {
            field(Designation; Designation)
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Gender)
        {
            field("Grade Level Code"; "Grade Level Code")
            {
                ApplicationArea = Basic;
            }
            field("Employee Category"; "Employee Category")
            {
                ApplicationArea = Basic;
            }
            field("Manager No."; "Manager No.")
            {
                ApplicationArea = Basic;
            }
            field("State Code"; "State Code")
            {
                ApplicationArea = Basic;
            }
            field("LG Code"; "LG Code")
            {
                ApplicationArea = Basic;
            }
        }

        addafter("Phone No.")
        {
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Employment Date")
        {
            field("Current Appointment Date"; "Current Appointment Date")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Cause of Inactivity Code")
        {
            field("Inactive Duration"; "Inactive Duration")
            {
                ApplicationArea = Basic;
            }
            field("Inactive Without Pay"; "Inactive Without Pay")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Salespers./Purch. Code")
        {
            field("Probation Period"; "Probation Period")
            {
                ApplicationArea = Basic;
            }
            field("Employment Status"; "Employment Status")
            {
                ApplicationArea = Basic;
            }
            field("Confirmation Date"; "Confirmation Date")
            {
                ApplicationArea = Basic;
            }
            field("Confirmation Due Date"; "Confirmation Due Date")
            {
                ApplicationArea = Basic;
            }
            field("Exclude From Payroll"; "Exclude From Payroll")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(Control3)
        {
            part(Control67; "Employee Signature")
            {
                SubPageLink = "No." = field("No.");
            }
        }
        moveafter(Gender; "Company E-Mail")
    }
    actions
    {
        addafter("A&bsences")
        {
            action("Bank Accounts")
            {
                ApplicationArea = Basic;
                Caption = 'Bank Accounts';
                Image = BankAccount;
                RunObject = Page "Employee Bank Account List";
                RunPageLink = "Employee No." = field("No.");
            }
            action(Skills)
            {
                ApplicationArea = Basic;
                Caption = 'Skills';
                Image = Skills;
                RunObject = Page "Skill Entry";
                RunPageLink = "Record Type" = const(Employee),
                              "No." = field("No.");
            }
            action("Working Experince")
            {
                ApplicationArea = Basic;
                Caption = 'Working Experince';
                Image = History;
                RunObject = Page "Employee Employment History";
                RunPageLink = "Record Type" = const(Employee),
                              "No." = field("No.");
            }
            action(Queries)
            {
                ApplicationArea = Basic;
                Caption = 'Queries';
                Image = Questionaire;
                RunObject = Page "Employee Query Register";
                RunPageLink = "Employee No." = field("No.");
            }
            action(Salary)
            {
                ApplicationArea = Basic;
                Caption = 'Salary';
                Image = WageLines;
                RunObject = Page "Employee Salary";
                RunPageLink = "Employee No." = field("No.");
            }
            action(Trainings)
            {
                ApplicationArea = Basic;
                Caption = 'Trainings';
                Image = Grid;
                RunObject = Page "Training Attendance List";
                RunPageLink = "Employee No." = field("No.");
            }
        }
        addfirst(processing)
        {
            action("<Action1000000005>")
            {
                ApplicationArea = Basic;
                Caption = 'Absence Setup';
                Image = AbsenceCategory;
                RunObject = Page "Leave Setup";
                RunPageLink = "Record Type" = const(Employee),
                              "No." = field("No.");
            }
            group(Functions)
            {
                Caption = 'Functions';
            }
            action("Update Payroll")
            {
                ApplicationArea = Basic;
                Caption = 'Update Payroll';
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Text001: label 'Records successfuly updated';
                    Text002: label 'Do you want to update payroll records?';
                    Text003: label 'Action Aborted!';
                begin
                    if Confirm(Text002) then begin
                        CreateEmployeePayrollRecord;
                        Message(Text001);
                    end else
                        Message(Text003);
                end;
            }
        }
    }
}

