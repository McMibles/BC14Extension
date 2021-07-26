Table 52092159 "Payroll-Employee"
{
    Caption = 'Employee';
    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    DrillDownPageID = "Proll-Employee List";
    LookupPageID = "Proll-Employee List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            var
                HumanResSetup: Record "Human Resources Setup";
                NoSeriesMgt: Codeunit NoSeriesManagement;

            begin
                if "No." <> xRec."No." then begin
                    HumanResSetup.Get;
                    NoSeriesMgt.TestManual(HumanResSetup."Employee Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            Caption = 'First Name';
        }
        field(3; "Middle Name"; Text[30])
        {
            Caption = 'Middle Name';
        }
        field(4; "Last Name"; Text[30])
        {
            Caption = 'Last Name';

            trigger OnValidate()
            begin

                "Search Name" := "First Name" + ' ' + "Middle Name" + ' ' + "Last Name";  //Added by Francis
            end;
        }
        field(5; Initials; Text[30])
        {
            Caption = 'Initials';

            trigger OnValidate()
            begin
                if ("Search Name" = UpperCase(xRec.Initials)) or ("Search Name" = '') then
                    "Search Name" := Initials;
            end;
        }
        field(6; "Job Title"; Text[30])
        {
            Caption = 'Job Title';

            trigger OnValidate()
            var
                JobTitle: Record "Job Title";

            begin
                if JobTitle.Get("Job Title") then begin
                    "Global Dimension 1 Code" := JobTitle."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := JobTitle."Global Dimension 2 Code";
                    "Employee Category" := JobTitle."Employee Category";
                    Designation := JobTitle."Title/Description";
                end;
            end;
        }
        field(7; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
        }
        field(8; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(9; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(10; City; Text[30])
        {
            Caption = 'City';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity(City,"Post Code");
            end;
        }
        field(11; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode(City,"Post Code",TRUE);
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode(City,"Post Code");
            end;
        }
        field(12; County; Text[30])
        {
            Caption = 'County';
        }
        field(13; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(14; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(15; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(16; "Alt. Address Code"; Code[10])
        {
            Caption = 'Alt. Address Code';
            TableRelation = "Alternative Address".Code where("Employee No." = field("No."));
        }
        field(17; "Alt. Address Start Date"; Date)
        {
            Caption = 'Alt. Address Start Date';
        }
        field(18; "Alt. Address End Date"; Date)
        {
            Caption = 'Alt. Address End Date';
        }
        field(19; Picture; Blob)
        {
            Caption = 'Picture';
            SubType = Bitmap;
        }
        field(20; "Birth Date"; Date)
        {
            Caption = 'Birth Date';
        }
        field(21; "Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
        }
        field(22; "Union Code"; Code[10])
        {
            Caption = 'Union Code';
        }
        field(23; "Union Membership No."; Text[30])
        {
            Caption = 'Union Membership No.';
        }
        field(24; Gender; Option)
        {
            Caption = 'Gender';
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(25; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(26; "Manager No."; Code[20])
        {
            Caption = 'Manager No.';
            TableRelation = Employee;
        }
        field(27; "Emplymt. Contract Code"; Code[10])
        {
            Caption = 'Emplymt. Contract Code';
            TableRelation = "Employment Contract";
        }
        field(28; "Statistics Group Code"; Code[10])
        {
            Caption = 'Statistics Group Code';
            TableRelation = "Employee Statistics Group";
        }
        field(29; "Employment Date"; Date)
        {
            Caption = 'Employment Date';
        }
        field(31; "Appointment Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(32; "Inactive Date"; Date)
        {
            Caption = 'Inactive Date';
        }
        field(33; "Cause of Inactivity Code"; Code[10])
        {
            Caption = 'Cause of Inactivity Code';
            TableRelation = "Cause of Inactivity";
        }
        field(34; "Termination Date"; Date)
        {
            Caption = 'Termination Date';
        }
        field(35; "Grounds for Term. Code"; Code[10])
        {
            Caption = 'Grounds for Term. Code';
            TableRelation = "Grounds for Termination";
        }
        field(36; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(37; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(38; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource where(Type = const(Person));
        }
        field(39; Comment; Boolean)
        {
            CalcFormula = exist("Human Resource Comment Line" where("Table Name" = const(Employee),
                                                                     "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(41; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(42; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(43; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(44; "Cause of Absence Filter"; Code[10])
        {
            Caption = 'Cause of Absence Filter';
            FieldClass = FlowFilter;
            TableRelation = "Cause of Absence";
        }
        field(45; "Total Absence (Base)"; Decimal)
        {
            CalcFormula = sum("Employee Absence"."Quantity (Base)" where("Employee No." = field("No."),
                                                                          "Cause of Absence Code" = field("Cause of Absence Filter"),
                                                                          "From Date" = field("Date Filter")));
            Caption = 'Total Absence (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(46; Extension; Text[30])
        {
            Caption = 'Extension';
        }
        field(47; "Employee No. Filter"; Code[20])
        {
            Caption = 'Employee No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Employee;
        }
        field(48; Pager; Text[30])
        {
            Caption = 'Pager';
        }
        field(49; "Fax No."; Text[30])
        {
            Caption = 'Fax No.';
        }
        field(50; "Company E-Mail"; Text[80])
        {
            Caption = 'Company E-Mail';
        }
        field(51; Title; Text[30])
        {
            Caption = 'Title';
        }
        field(52; "Salespers./Purch. Code"; Code[10])
        {
            Caption = 'Salespers./Purch. Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(53; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(1100; "Cost Center Code"; Code[20])
        {
            Caption = 'Cost Center Code';
            TableRelation = "Cost Center";
        }
        field(1101; "Cost Object Code"; Code[20])
        {
            Caption = 'Cost Object Code';
            TableRelation = "Cost Object";
        }
        field(60000; "Job Title Code"; Code[20])
        {
            Caption = 'Job Title';
            DataClassification = ToBeClassified;
            TableRelation = "Job Title";

            trigger OnValidate()
            var
                JobTitle: Record "Job Title";
            begin
                if JobTitle.Get("Job Title") then begin
                    "Global Dimension 1 Code" := JobTitle."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := JobTitle."Global Dimension 2 Code";
                    "Employee Category" := JobTitle."Employee Category";
                    Designation := JobTitle."Title/Description";
                end;
            end;
        }
        field(60002; "Customer No."; Code[20])
        {
            Editable = false;
            TableRelation = Customer where(Type = const(Staff));
        }
        field(60003; "Employee Category"; Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(60004; "Marital Status"; Option)
        {
            OptionCaption = ' ,Single,Married,Separated,Widowed';
            OptionMembers = " ",Single,Married,Separated,Widowed;
        }
        field(60008; Designation; Text[50])
        {
        }
        field(60009; "State Code"; Code[10])
        {
            TableRelation = State.Code where("Record Type" = const(State));
        }
        field(60010; "Grade Level Code"; Code[20])
        {
            TableRelation = "Grade Level";
        }
        field(60013; "Employment Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Probation,Confirmed';
            OptionMembers = Probation,Confirmed;
        }
        field(60016; "Pension No."; Code[20])
        {
        }
        field(60018; "Contract Start Date"; Date)
        {

            trigger OnValidate()
            begin
                TestField("Emplymt. Contract Code");
            end;
        }
        field(60019; "Contract Expiry Date"; Date)
        {

            trigger OnValidate()
            begin
                TestField("Emplymt. Contract Code");
            end;
        }
        field(60020; "Inactive Duration"; Code[10])
        {
        }
        field(60021; "Zone Code"; Code[20])
        {
        }
        field(60022; "LG Code"; Code[10])
        {
            TableRelation = State.Code where("Record Type" = const(LG));
        }
        field(60030; "Re-Instatement Date"; Date)
        {
        }
        field(60031; "Inactive Without Pay"; Boolean)
        {
        }
        field(60400; "Pension Administrator Code"; Code[20])
        {
            TableRelation = "Pension Administrator";
        }
        field(60401; "Exclude From Payroll"; Boolean)
        {
        }
        field(60402; "Preferred Bank Account"; Code[20])
        {
            TableRelation = "Employee Bank Account".Code where("Employee No." = field("No."),
                                                                "Use for Payroll" = filter(true));

            trigger OnValidate()
            var
                EmpBank: Record "Employee Bank Account";
            begin
                if "Preferred Bank Account" <> '' then begin
                    TestField("Mode of payment", 1);
                    EmpBank.Get("No.", "Preferred Bank Account");
                    "Bank Account" := EmpBank."Bank Account No.";
                    "CBN Bank Code" := EmpBank."CBN Bank Code";
                end else begin
                    "Bank Account" := '';
                    "CBN Bank Code" := '';
                end;
            end;
        }
        field(60403; "Bank Account"; Text[20])
        {
        }
        field(60404; "Posting Group"; Code[20])
        {
            TableRelation = "Payroll-Posting Group Header";
        }
        field(60405; "Mode of payment"; Option)
        {
            OptionMembers = Cash,Bank;
        }
        field(60406; "Period Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-Period";
        }
        field(60407; "ED Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-E/D";
        }
        field(60408; "ED Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Period Filter"),
                                                                   "Employee No." = field("No."),
                                                                   "E/D Code" = field("ED Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60409; "Loan Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Loan"."Loan Amount" where("Employee No." = field("No."),
                                                                  "Loan E/D" = field("ED Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60410; "No. of Entries"; Integer)
        {
            CalcFormula = count("Payroll-Payslip Header" where("Employee No." = field("No."),
                                                                "Payroll Period" = field("Period Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60411; "ED Quantity"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Quantity where("Payroll Period" = field("Period Filter"),
                                                                     "Employee No." = field("No."),
                                                                     "E/D Code" = field("ED Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60412; "Monthly Tax Relief Amount"; Decimal)
        {
        }
        field(60413; "CBN Bank Code"; Code[20])
        {
            TableRelation = Bank;
        }
        field(60414; "EDFirstHalf Amount"; Decimal)
        {
            CalcFormula = sum("Proll-Pslip Lines First Half".Amount where("Payroll Period" = field("Period Filter"),
                                                                           "Arrear Type" = field("Arrear Type Filter"),
                                                                           "Employee No." = field("No."),
                                                                           "E/D Code" = field("ED Filter")));
            FieldClass = FlowField;
        }
        field(60415; "EDArrears Amount"; Decimal)
        {
            CalcFormula = sum("Proll-Pslip Lines First Half"."Arrears Amount" where("Payroll Period" = field("Period Filter"),
                                                                                     "Arrear Type" = field("Arrear Type Filter"),
                                                                                     "Employee No." = field("No."),
                                                                                     "E/D Code" = field("ED Filter"),
                                                                                     "Payment Period" = field("Arr. Payment Period Filter")));
            FieldClass = FlowField;
        }
        field(60416; "EDFirstHalf ArAmount"; Decimal)
        {
            CalcFormula = sum("Proll-Pslip Lines First Half"."Arrears Amount" where("Payroll Period" = field("Period Filter"),
                                                                                     "Employee No." = field("No."),
                                                                                     "E/D Code" = field("ED Filter"),
                                                                                     "Payment Period" = field("Arr. Payment Period Filter")));
            FieldClass = FlowField;
        }
        field(60417; "Arrear Type Filter"; Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = 'Salary,Promotion';
            OptionMembers = Salary,Promotion;
        }
        field(60418; "Arr. Payment Period Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-Period";
        }
        field(60419; "Tax State"; Code[20])
        {
            TableRelation = State.Code where("Record Type" = const(State));
        }
        field(60420; "Gratuity Amount"; Decimal)
        {
            CalcFormula = sum("Gratuity Ledger Entry"."Current Amount" where("Employee No." = field("No."),
                                                                              "Period End Date" = field("Date Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60423; "Payslip Mode"; Option)
        {
            OptionCaption = 'Hard Copy,E-mail';
            OptionMembers = "Hard Copy","E-mail";

            trigger OnValidate()
            begin
                if "Payslip Mode" = "payslip mode"::"E-mail" then
                    TestField("Company E-Mail");
            end;
        }
        field(60424; "ED Closed Amount"; Decimal)
        {
            CalcFormula = sum("Closed Payroll-Payslip Line".Amount where("Payroll Period" = field("Period Filter"),
                                                                          "Employee No." = field("No."),
                                                                          "E/D Code" = field("ED Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60425; "Closed No. of Entries"; Integer)
        {
            CalcFormula = count("Closed Payroll-Payslip Header" where("Employee No." = field("No."),
                                                                       "Payroll Period" = field("Period Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60426; "ED Closed Quantity"; Decimal)
        {
            CalcFormula = sum("Closed Payroll-Payslip Line".Quantity where("Payroll Period" = field("Period Filter"),
                                                                            "Employee No." = field("No."),
                                                                            "E/D Code" = field("ED Filter")));
            Editable = false;
            FieldClass = FlowField;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Appointment Status", "Union Code")
        {
        }
        key(Key4; "Appointment Status", "Emplymt. Contract Code")
        {
        }
        key(Key5; "Last Name", "First Name", "Middle Name")
        {
        }
        key(Key6; "Global Dimension 1 Code", "CBN Bank Code", "Global Dimension 2 Code")
        {
        }
        key(Key7; "Global Dimension 1 Code", "Global Dimension 2 Code", "No.", "Employee Category")
        {
        }
        key(Key8; "Global Dimension 2 Code", "No.", "Employee Category")
        {
        }
        key(Key9; "Pension Administrator Code", "Global Dimension 1 Code")
        {
        }
        key(Key10; "Global Dimension 1 Code", "Global Dimension 2 Code", "Employee Category")
        {
        }
        key(Key11; "Preferred Bank Account")
        {
        }
        key(Key12; "Global Dimension 1 Code", "Employment Status", "Global Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "First Name", "Last Name", Initials, "Job Title")
        {
        }
    }

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        Res: Record Resource;
        PostCode: Record "Post Code";
        AlternativeAddr: Record "Alternative Address";
        EmployeeQualification: Record "Employee Qualification";
        Relative: Record "Employee Relative";
        EmployeeAbsence: Record "Employee Absence";
        MiscArticleInformation: Record "Misc. Article Information";
        ConfidentialInformation: Record "Confidential Information";
        PayrollPayslipHeader: Record "Payroll-Payslip Header";
        PayrollPayslipHeader2: Record "Payroll-Payslip Header";
        PayrollPayslipLines: Record "Payroll-Payslip Line";
        PayrollPayslipLines2: Record "Payroll-Payslip Line";
        PeriodRec: Record "Payroll-Period";
        PayrollEdCode: Record "Payroll-E/D";
        PeriodRec2: Record "Payroll-Period";
        HumanResComment: Record "Human Resource Comment Line";
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        JobTitle: Record "Job Title";
        EmpBank: Record "Employee Bank Account";
        PayrollSetup: Record "Payroll-Setup";
        Text000: label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Text50000: label 'Action not possible for terminated employee!';
        Text50001: label 'Probation Period not correct!';
        PenAdmin: Record "Pension Administrator";
        PrevDate: Date;
        OldNetPay: Decimal;
        CurrentNetPay: Decimal;


    procedure AssistEdit(OldEmployee: Record Employee): Boolean
    begin
    end;


    procedure FullName(): Text[100]
    begin
        if "Middle Name" = '' then
            exit("Last Name" + ',' + ' ' + "First Name")
        else
            exit("Last Name" + ',' + ' ' + "First Name" + ' ' + "Middle Name");
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;

    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"Payroll-Employee", "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;


    procedure DisplayMap()
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.Find('-') then
            MapMgt.MakeSelection(Database::Employee, GetPosition)
        else
            Message(Text000);
    end;


    procedure GetName(EmplCode: Code[20]): Text[60]
    var
        EmpRec: Record "Payroll-Employee";
        CompanyRec: Record "Payroll-Employee";
    begin
        if EmplCode <> '' then begin
            if EmpRec.Get(EmplCode) then
                exit(EmpRec."Last Name" + ',' + ' ' + EmpRec."First Name")
        end else
            exit(' ');
    end;


    procedure CreateCustomerRecord()
    var
        ProllEmployee: Record "Payroll-Employee";
        Customer: Record Customer;
        PayrollHeader: Record "Payroll-Employee";
        Employee: Record Employee;
        ReceivableSetup: Record "Sales & Receivables Setup";
        CreateNewStaffDebtAcct: Boolean;
    begin
        if "Appointment Status" = "appointment status"::Terminated then
            exit;
        PayrollSetup.Get;
        CreateNewStaffDebtAcct := false;

        with Rec do begin
            // Customer Account for staff loans
            if "Customer No." = '' then begin
                Customer.Init;
                Customer."No." := "No.";
            end else
                if not Customer.Get("Customer No.") then
                    CreateNewStaffDebtAcct := true;

            if CreateNewStaffDebtAcct then
                Customer."No." := "No.";
            Customer.Validate(Name, CopyStr(FullName, 1, MaxStrLen(Customer.Name)));
            Customer.Validate("Search Name", UpperCase(FullName));
            Customer.Address := Address;
            Customer."Bill-to Customer No." := "No.";
            Customer."Address 2" := "Address 2";
            Customer."Global Dimension 1 Code" := "Global Dimension 1 Code";
            Customer."Global Dimension 2 Code" := "Global Dimension 2 Code";
            Customer."Customer Posting Group" := PayrollSetup."Staff  Debtor Posting Grp";
            Customer.Type := Customer.Type::Staff;

            if Address = '' then
                Customer.Address := 'LAGOS';

            if ("Customer No." = '') or (CreateNewStaffDebtAcct) then begin
                if Customer.Insert then;
                Commit;
                "Customer No." := Customer."No.";
            end;
        end;
    end;


    procedure GetPenAdminName(PenCode: Code[10]): Text[50]
    begin
        if PenAdmin.Get(PenCode) then
            exit(PenAdmin.Name)
        else
            exit(' ');
    end;


    procedure GetBankName(): Text[30]
    var
        Banks: Record Bank;
    begin
        if "CBN Bank Code" <> '' then begin
            Banks.Get("CBN Bank Code");
            exit(Banks.Name);
        end;
    end;


    procedure NewEmployee(PayrollEmpRec: Record "Payroll-Employee"; PayrollPeriod: Text[50]; ComparisonFilters: Text[50]) NewEmployee: Boolean
    begin
        NewEmployee := false;
        PayrollPayslipHeader.Reset;
        PayrollPayslipHeader.SetRange(PayrollPayslipHeader."Payroll Period", PayrollPeriod);
        PayrollPayslipHeader.SetRange(PayrollPayslipHeader."Employee No.", PayrollEmpRec."No.");
        if PayrollPayslipHeader.Find('-') then begin
            PeriodRec.SetRange("Period Code", PayrollPeriod);
            if PeriodRec.FindFirst then
                PrevDate := CalcDate('-1M', PeriodRec."End Date");
            PeriodRec2.SetFilter(PeriodRec2."Start Date", '<=%1', PrevDate);
            if PeriodRec2.FindLast then
                PayrollPayslipHeader2.SetRange("Payroll Period", PeriodRec2."Period Code");
            PayrollPayslipHeader2.SetRange("Employee No.", PayrollPayslipHeader."Employee No.");
            if not PayrollPayslipHeader2.FindFirst then
                NewEmployee := true;
        end;
    end;


    procedure NetDifference(PayrollEmpRec: Record "Payroll-Employee"; PayrollPeriod: Text[50]; ComparisonFilters: Text[50]) NetDiffExist: Boolean
    var
        PayrollEmpRec2: Record "Payroll-Employee";
    begin
        NetDiffExist := false;
        PeriodRec.Reset;
        PayrollPayslipHeader.Reset;
        PayrollPayslipLines.Reset;
        PayrollPayslipLines2.Reset;
        PayrollPayslipHeader.SetRange(PayrollPayslipHeader."Payroll Period", PayrollPeriod);
        PayrollPayslipHeader.SetRange(PayrollPayslipHeader."Employee No.", PayrollEmpRec."No.");
        if PayrollPayslipHeader.Find('-') then begin
            OldNetPay := 0;
            CurrentNetPay := 0;
            PayrollPayslipLines.SetRange("Payroll Period", PayrollPayslipHeader."Payroll Period");
            PayrollPayslipLines.SetRange("Employee No.", PayrollPayslipHeader."Employee No.");
            PayrollEdCode.FindLast;
            PayrollPayslipLines.SetRange("E/D Code", PayrollEdCode."E/D Code");
            if PayrollPayslipLines.FindLast then
                CurrentNetPay := ROUND(PayrollPayslipLines.Amount, 0.1);
            PeriodRec.SetRange("Period Code", PayrollPeriod);
            if PeriodRec.FindFirst then
                PrevDate := CalcDate('-1M', PeriodRec."End Date");
            PeriodRec2.SetFilter(PeriodRec2."Start Date", '<=%1', PrevDate);
            if PeriodRec2.FindLast then
                if ComparisonFilters = '' then
                    ComparisonFilters := PeriodRec2."Period Code";
            PayrollPayslipLines2.SetRange("Payroll Period", ComparisonFilters);
            PayrollPayslipLines2.SetRange("Employee No.", PayrollPayslipHeader."Employee No.");
            PayrollPayslipLines2.SetRange("E/D Code", PayrollEdCode."E/D Code");
            if PayrollPayslipLines2.FindLast then
                OldNetPay := ROUND(PayrollPayslipLines2.Amount, 0.1);
            if CurrentNetPay <> OldNetPay then
                NetDiffExist := true;
        end;
    end;
}

