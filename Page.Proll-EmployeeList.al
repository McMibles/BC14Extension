Page 52092163 "Proll-Employee List"
{
    CardPageID = "Proll-Employee Card";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll-Employee";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(FirstName;"First Name")
                {
                    ApplicationArea = Basic;
                }
                field(LastName;"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(JobTitle;"Job Title")
                {
                    ApplicationArea = Basic;
                }
                field(MaritalStatus;"Marital Status")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field(GradeLevelCode;"Grade Level Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EmploymentStatus;"Employment Status")
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
                field(StateCode;"State Code")
                {
                    ApplicationArea = Basic;
                }
                field(LGCode;"LG Code")
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
            group(Employee)
            {
                Caption = 'Employee';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(52092159),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("<Page Employee Bank Account List")
                {
                    ApplicationArea = Basic;
                    Caption = ' Bank Accounts';
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Employee Bank Account List";
                    RunPageLink = "Employee No."=field("No.");
                }
                action(StaffDebtorAccount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Staff Debtor Account';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Staff Debtor Card";
                    RunPageLink = "No."=field("Customer No.");
                }
            }
        }
        area(processing)
        {
            group("Function")
            {
                Caption = 'Function';
                action(CreateStaffDebtor)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Staff Debtor';
                    Image = NewCustomer;

                    trigger OnAction()
                    begin
                        CreateCustomerRecord;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        UserSetup.Get(UserId);
        if not(UserSetup."Payroll Administrator") then begin
          FilterGroup(2);
          if UserSetup."Personnel Level" <> '' then
            SetFilter("Employee Category",UserSetup."Personnel Level")
          else
            SetRange("Employee Category");
          FilterGroup(0);
        end else
          SetRange("Employee Category");
    end;

    var
        UserSetup: Record "User Setup";
}

