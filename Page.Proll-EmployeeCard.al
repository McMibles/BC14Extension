Page 52092162 "Proll-Employee Card"
{
    Caption = 'Employee Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Payroll-Employee";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = false;
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Name;"First Name" + ' ' +"Middle Name"+' '+"Last Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    Editable = false;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Address2;"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(MobilePhoneNo;"Mobile Phone No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(AppointmentStatus;"Appointment Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(SearchName;"Search Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(BirthDate;"Birth Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(GradeLevelCode;"Grade Level Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Posting)
            {
                Caption = 'Posting';
                field(CustomerNo;"Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingGroup;"Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Payment)
            {
                Caption = 'Payment';
                field(Modeofpayment;"Mode of payment")
                {
                    ApplicationArea = Basic;
                }
                field(PreferredBankAccount;"Preferred Bank Account")
                {
                    ApplicationArea = Basic;
                }
                field(BankAccount;"Bank Account")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(PayslipMode;"Payslip Mode")
                {
                    ApplicationArea = Basic;
                }
                field(TaxStateCode;"Tax State")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax State Code';
                }
                field(PensionAdministratorCode;"Pension Administrator Code")
                {
                    ApplicationArea = Basic;
                }
                field(PensionNo;"Pension No.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                field(EmploymentDate;"Employment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(TerminationDate;"Termination Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EDAmount;"ED Amount")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(NoofEntries;"No. of Entries")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EDClosedAmount;"ED Closed Amount")
                {
                    ApplicationArea = Basic;
                }
                field(ClosedNoofEntries;"Closed No. of Entries")
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
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Employee Bank Account List";
                    RunPageLink = "Employee No."=field("No.");
                }
                action(DebtorAccount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Debtor Account';
                    Image = Customer;
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
        EmpRec: Record "Payroll-Employee";
        StaffDebtor: Record Customer;
        UserSetup: Record "User Setup";
        CreateNewPay: Report "PRoll; Create New Payslips";
        StaffType: Option "Junior Staff","Senior Staff","Management Staff",Casual;
        Text000: label 'Are you sure you want to create staff debtor?';
        Text001: label 'Staff Debtor %1 successfully created!';
        Text002: label 'Staff debtor %1 already exist!';
}

