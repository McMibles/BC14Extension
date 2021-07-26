PageExtension 52000045 pageextension52000045 extends "Employee List"
{
    layout
    {

        //Unsupported feature: Property Modification (SourceExpr) on ""Job Title"(Control 12)".


        //Unsupported feature: Property Modification (Name) on ""Job Title"(Control 12)".

        addafter("Job Title")
        {
            /*    
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = Basic;
                }
            */
            field("Employee Category"; "Employee Category")
            {
                ApplicationArea = Basic;
            }
        }

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
    }

    var
        UserSetup: Record "User Setup";


    //Unsupported feature: Code Insertion on "OnOpenPage".

    trigger OnOpenPage()
    begin

        UserSetup.GET(USERID);
        IF NOT (UserSetup."HR Administrator") THEN BEGIN
            FILTERGROUP(2);
            IF UserSetup."Personnel Level" <> '' THEN
                SETFILTER("Employee Category", UserSetup."Personnel Level")
            ELSE
                SETRANGE("Employee Category");
            FILTERGROUP(0);
        END ELSE
            SETRANGE("Employee Category");

    end;
}

