Page 52092454 "Employee Self Update"
{
    Caption = 'Employee Card';
    PageType = Card;
    SourceTable = Employee;

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
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = NoFieldVisible;

                    trigger OnAssistEdit()
                    begin
                        AssistEdit;
                    end;
                }
                field(FirstName;"First Name")
                {
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the employee''s first name.';
                }
                field(MiddleName;"Middle Name")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the employee''s middle name.';
                }
                field(LastName;"Last Name")
                {
                    ApplicationArea = BasicHR;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the employee''s last name.';
                }
                field(JobTitleCode;"Job Title Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    Visible = false;
                }
                field(JobTitle;"Job Title")
                {
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s job title.';
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the employee''s initials.';
                }
                field(SearchName;"Search Name")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the employee''s gender.';
                }
                field(GradeLevelCode;"Grade Level Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
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
                field("Phone No.2";"Phone No.")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Company Phone No.';
                    ToolTip = 'Specifies the employee''s telephone number.';
                }
                field(CompanyEMail;"Company E-Mail")
                {
                    ApplicationArea = BasicHR;
                    ExtendedDatatype = EMail;
                    ToolTip = 'Specifies the employee''s email address at the company.';
                }
                field(LastDateModified;"Last Date Modified")
                {
                    ApplicationArea = BasicHR;
                    Importance = Additional;
                    ToolTip = 'Specifies when this record was last modified.';
                }
                field(PrivacyBlocked;"Privacy Blocked")
                {
                    ApplicationArea = BasicHR;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to limit access to data for the data subject during daily operations. This is useful, for example, when protecting data from changes while it is under privacy review.';
                }
            }
            group(AddressContact)
            {
                Caption = 'Address & Contact';
                group(Control13)
                {
                    Editable = false;
                    field(Address;Address)
                    {
                        ApplicationArea = BasicHR;
                        ToolTip = 'Specifies the employee''s address.';
                    }
                    field(Address2;"Address 2")
                    {
                        ApplicationArea = BasicHR;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field(PostCode;"Post Code")
                    {
                        ApplicationArea = BasicHR;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field(City;City)
                    {
                        ApplicationArea = BasicHR;
                        ToolTip = 'Specifies the city of the address.';
                    }
                    field(CountryRegionCode;"Country/Region Code")
                    {
                        ApplicationArea = BasicHR;
                        ToolTip = 'Specifies the country/region of the address.';
                    }
                    field(ShowMap;ShowMapLbl)
                    {
                        ApplicationArea = BasicHR;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the employee''s address on your preferred online map.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.Update(true);
                            DisplayMap;
                        end;
                    }
                }
                group(Control7)
                {
                    field(PrivatePhoneNo;"Mobile Phone No.")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Private Phone No.';
                        Importance = Promoted;
                        ToolTip = 'Specifies the employee''s private telephone number.';
                    }
                    field(Pager;Pager)
                    {
                        ApplicationArea = Advanced;
                        ToolTip = 'Specifies the employee''s pager number.';
                    }
                    field(Extension;Extension)
                    {
                        ApplicationArea = BasicHR;
                        Importance = Promoted;
                        ToolTip = 'Specifies the employee''s telephone extension.';
                    }
                    field(DirectPhoneNo;"Phone No.")
                    {
                        ApplicationArea = Advanced;
                        Caption = 'Direct Phone No.';
                        Importance = Promoted;
                        ToolTip = 'Specifies the employee''s telephone number.';
                    }
                    field(PrivateEmail;"E-Mail")
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Private Email';
                        Importance = Promoted;
                        ToolTip = 'Specifies the employee''s private email address.';
                    }
                    field(AltAddressCode;"Alt. Address Code")
                    {
                        ApplicationArea = Advanced;
                        ToolTip = 'Specifies a code for an alternate address.';
                    }
                    field(AltAddressStartDate;"Alt. Address Start Date")
                    {
                        ApplicationArea = Advanced;
                        ToolTip = 'Specifies the starting date when the alternate address is valid.';
                    }
                    field(AltAddressEndDate;"Alt. Address End Date")
                    {
                        ApplicationArea = Advanced;
                        ToolTip = 'Specifies the last day when the alternate address is valid.';
                    }
                }
            }
            group(Administration)
            {
                Caption = 'Administration';
                Editable = false;
                field(EmploymentDate;"Employment Date")
                {
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the employee began to work for the company.';
                }
                field(CurrentAppointmentDate;"Current Appointment Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employment status of the employee.';
                }
                field(InactiveDate;"Inactive Date")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the date when the employee became inactive, due to disability or maternity leave, for example.';
                }
                field(CauseofInactivityCode;"Cause of Inactivity Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a code for the cause of inactivity by the employee.';
                }
                field(InactiveDuration;"Inactive Duration")
                {
                    ApplicationArea = Basic;
                }
                field(InactiveWithoutPay;"Inactive Without Pay")
                {
                    ApplicationArea = Basic;
                }
                field(TerminationDate;"Termination Date")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the date when the employee was terminated, due to retirement or dismissal, for example.';
                }
                field(GroundsforTermCode;"Grounds for Term. Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a termination code for the employee who has been terminated.';
                }
                field(EmplymtContractCode;"Emplymt. Contract Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the employment contract code for the employee.';
                }
                field(StatisticsGroupCode;"Statistics Group Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                }
                field(ResourceNo;"Resource No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a resource number for the employee.';
                }
                field(SalespersPurchCode;"Salespers./Purch. Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a salesperson or purchaser code for the employee.';
                }
                field(ProbationPeriod;"Probation Period")
                {
                    ApplicationArea = Basic;
                }
                field(EmploymentStatus;"Employment Status")
                {
                    ApplicationArea = Basic;
                }
                field(ConfirmationDate;"Confirmation Date")
                {
                    ApplicationArea = Basic;
                }
                field(ConfirmationDueDate;"Confirmation Due Date")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                field(BirthDate;"Birth Date")
                {
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ToolTip = 'Specifies the employee''s date of birth.';
                }
                field(SocialSecurityNo;"Social Security No.")
                {
                    ApplicationArea = BasicHR;
                    Importance = Promoted;
                    ToolTip = 'Specifies the social security number of the employee.';
                }
                field(UnionCode;"Union Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the employee''s labor union membership code.';
                }
                field(UnionMembershipNo;"Union Membership No.")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the employee''s labor union membership number.';
                }
            }
            group(Payments)
            {
                Caption = 'Payments';
                Editable = false;
                field(EmployeePostingGroup;"Employee Posting Group")
                {
                    ApplicationArea = BasicHR;
                    LookupPageID = "Employee Posting Groups";
                    ToolTip = 'Specifies the employee''s type to link business transactions made for the employee with the appropriate account in the general ledger.';
                }
                field(ApplicationMethod;"Application Method")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies how to apply payments to entries for this employee.';
                }
                field(BankBranchNo;"Bank Branch No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies a number of the bank branch.';
                }
                field(BankAccountNo;"Bank Account No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the number used by the bank for the bank account.';
                }
                field(Iban;Iban)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the bank account''s international bank account number.';
                }
                field(SWIFTCode;"SWIFT Code")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the SWIFT code (international bank identifier code) of the bank where the employee has the account.';
                }
            }
        }
        area(factboxes)
        {
            part(Control3;"Employee Picture")
            {
                ApplicationArea = BasicHR;
                SubPageLink = "No."=field("No.");
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Employee)
            {
                Caption = 'E&mployee';
                Image = Employee;
                action(Comments)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name"=const(Employee),
                                  "No."=field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action(Picture)
                {
                    ApplicationArea = BasicHR;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No."=field("No.");
                    ToolTip = 'View or add a picture of the employee or, for example, the company''s logo.';
                }
                action(AlternativeAddresses)
                {
                    ApplicationArea = BasicHR;
                    Caption = '&Alternate Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No."=field("No.");
                    ToolTip = 'Open the list of addresses that are registered for the employee.';
                }
                action(MyPayslips)
                {
                    ApplicationArea = Basic;
                    Caption = 'My Payslips';
                    Image = Print;
                    RunObject = Report "Payroll Payslip - Individual";
                }
                action(Relatives)
                {
                    ApplicationArea = BasicHR;
                    Caption = '&Relatives';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No."=field("No.");
                    ToolTip = 'Open the list of relatives that are registered for the employee.';
                }
                action(MiscArticleInformation)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No."=field("No.");
                    ToolTip = 'Open the list of miscellaneous articles that are registered for the employee.';
                }
                action(ConfidentialInformation)
                {
                    ApplicationArea = BasicHR;
                    Caption = '&Confidential Information';
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No."=field("No.");
                    ToolTip = 'Open the list of any confidential information that is registered for the employee.';
                }
                action(Qualifications)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Q&ualifications';
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No."=field("No.");
                    ToolTip = 'Open the list of qualifications that are registered for the employee.';
                }
                action("<Action1000000018>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    Image = Skills;
                    RunObject = Page "Skill Entry";
                    RunPageLink = "Record Type"=const(Employee),
                                  "No."=field("No.");
                }
                action(WorkingExperince)
                {
                    ApplicationArea = Basic;
                    Caption = 'Working Experince';
                    Image = History;
                    RunObject = Page "Employee Employment History";
                    RunPageLink = "Record Type"=const(Employee),
                                  "No."=field("No.");
                }
                action(Queries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Queries';
                    Image = Questionaire;
                    RunObject = Page "Employee Query Register";
                    RunPageLink = "Employee No."=field("No.");
                }
                action(LedgerEntries)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Ledger E&ntries';
                    Image = VendorLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Employee Ledger Entries";
                    RunPageLink = "Employee No."=field("No.");
                    RunPageView = sorting("Employee No.")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetNoFieldVisible;
    end;

    var
        ShowMapLbl: label 'Show on Map';
        NoFieldVisible: Boolean;
        Text001: label 'Records successfuly updated';
        Text002: label 'Do you want to update payroll records?';
        Text003: label 'Action Aborted!';

    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        NoFieldVisible := DocumentNoVisibility.EmployeeNoIsVisible;
    end;
}

