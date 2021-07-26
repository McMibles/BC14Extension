Page 52092455 "Employee Self  Update List"
{
    Caption = 'Employee List';
    CardPageID = "Employee Self Update";
    Editable = false;
    PageType = List;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(No;"No.")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(FullName;FullName)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Full Name';
                    ToolTip = 'Specifies the full name of the employee.';
                    Visible = false;
                }
                field(FirstName;"First Name")
                {
                    ApplicationArea = BasicHR;
                    NotBlank = true;
                    ToolTip = 'Specifies the employee''s first name.';
                }
                field(MiddleName;"Middle Name")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the employee''s middle name.';
                    Visible = false;
                }
                field(LastName;"Last Name")
                {
                    ApplicationArea = BasicHR;
                    NotBlank = true;
                    ToolTip = 'Specifies the employee''s last name.';
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the employee''s initials.';
                    Visible = false;
                }
                field(JobTitle;"Job Title")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the employee''s job title.';
                }
                field(PostCode;"Post Code")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the postal code.';
                    Visible = false;
                }
                field(CountryRegionCode;"Country/Region Code")
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the country/region of the address.';
                    Visible = false;
                }
                field(CompanyPhoneNo;"Phone No.")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Company Phone No.';
                    ToolTip = 'Specifies the employee''s telephone number.';
                }
                field(Extension;Extension)
                {
                    ApplicationArea = BasicHR;
                    ToolTip = 'Specifies the employee''s telephone extension.';
                    Visible = false;
                }
                field(PrivatePhoneNo;"Mobile Phone No.")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Private Phone No.';
                    ToolTip = 'Specifies the employee''s private telephone number.';
                    Visible = false;
                }
                field(PrivateEmail;"E-Mail")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Private Email';
                    ToolTip = 'Specifies the employee''s private email address.';
                    Visible = false;
                }
                field(StatisticsGroupCode;"Statistics Group Code")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies a statistics group code to assign to the employee for statistical purposes.';
                    Visible = false;
                }
                field(ResourceNo;"Resource No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a resource number for the employee.';
                    Visible = false;
                }
                field(SearchName;"Search Name")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies an alternate name that you can use to search for the record in question when you cannot remember the value in the Name field.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies if a comment has been entered for this entry.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                ApplicationArea = BasicHR;
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                ApplicationArea = BasicHR;
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
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action(DimensionsSingle)
                    {
                        ApplicationArea = BasicHR;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(5200),
                                      "No."=field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action(DimensionsMultiple)
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = BasicHR;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Employee: Record Employee;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Employee);
                            DefaultDimMultiple.SetMultiEmployee(Employee);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
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
                    Caption = 'Co&nfidential Information';
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
                action(Absences)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No."=field("No.");
                    ToolTip = 'View absence information for the employee.';
                }
                action("Bank Accounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Bank Accounts';
                    Image = BankAccount;
                    RunObject = Page "Employee Bank Account List";
                    RunPageLink = "Employee No."=field("No.");
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
                action("<Action1000000038>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Salary';
                    Image = WageLines;
                    RunObject = Page "Employee Salary";
                    RunPageLink = "Employee No."=field("No.");
                }
                action("<Action1000000024>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Trainings';
                    Image = Grid;
                    RunObject = Page "Training Attendance List";
                    RunPageLink = "Employee No."=field("No.");
                }
                separator(Action51)
                {
                }
                action(AbsencesbyCategories)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No."=field("No."),
                                  "Employee No. Filter"=field("No.");
                    ToolTip = 'View categorized absence information for the employee.';
                }
                action(MiscArticlesOverview)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                    ToolTip = 'View miscellaneous articles that are registered for the employee.';
                }
                action(ConfidentialInfoOverview)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Con&fidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                    ToolTip = 'View confidential information that is registered for the employee.';
                }
            }
        }
        area(processing)
        {
            action(AbsenceRegistration)
            {
                ApplicationArea = BasicHR;
                Caption = 'Absence Registration';
                Image = Absence;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Absence Registration";
                ToolTip = 'Register absence for the employee.';
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

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        SetRange("No.",UserSetup."Employee No.");
        FilterGroup(0);
    end;

    var
        UserSetup: Record "User Setup";
}

