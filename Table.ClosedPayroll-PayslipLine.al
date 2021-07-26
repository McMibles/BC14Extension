Table 52092169 "Closed Payroll-Payslip Line"
{
    DrillDownPageID = "Closed Payslip Lines";
    LookupPageID = "Closed Payslip Lines";
    Permissions = TableData "Employee Absence" = rim,
                  TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;

    fields
    {
        field(1; "Payroll Period"; Code[10])
        {
            Editable = false;
            TableRelation = "Payroll-Period";
        }
        field(2; "Employee No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "Payroll-Employee";
        }
        field(3; "E/D Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-E/D";
        }
        field(4; Units; Text[10])
        {
            Editable = false;
        }
        field(5; Rate; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(6; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(7; Flag; Boolean)
        {
        }
        field(8; Amount; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(9; "Debit Account"; Code[20])
        {
            TableRelation = if ("Debit Acc. Type" = const(Finance)) "G/L Account"
            else
            if ("Debit Acc. Type" = const(Customer)) Customer;
        }
        field(10; "Credit Account"; Code[20])
        {
            TableRelation = if ("Credit Acc. Type" = const(Finance)) "G/L Account"
            else
            if ("Credit Acc. Type" = const(Customer)) Customer;
        }
        field(11; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(12; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(13; AmountToBook; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(14; "Statistics Group Code"; Code[10])
        {
            TableRelation = "Payroll Statistical Group";
        }
        field(15; "Pos. In Payslip Grp."; Integer)
        {
        }
        field(16; "Payslip Appearance"; Option)
        {
            OptionMembers = "Non-zero & Code","Always & Code","Always & Text","Non-zero & Text","Does not appear",Heading;
        }
        field(17; "Debit Acc. Type"; Option)
        {
            OptionMembers = Finance,Customer,Supplier;
        }
        field(18; "Credit Acc. Type"; Option)
        {
            OptionMembers = Finance,Customer,Supplier;
        }
        field(19; ChangeOthers; Boolean)
        {
            Editable = false;
            InitValue = false;
        }
        field(20; HasBeenChanged; Boolean)
        {
            Editable = false;
            InitValue = false;
        }
        field(21; ChangeCounter; Integer)
        {
            Editable = false;
            InitValue = 0;
        }
        field(22; "Payslip Column"; Option)
        {
            OptionMembers = "1","2","3";
        }
        field(23; "S. Report appearance"; Option)
        {
            OptionMembers = "Non-zero & Code","Always & Code","Always & Text","Non-zero & Text","Does not appear",Heading;
        }
        field(24; "Overline Column"; Option)
        {
            InitValue = "None";
            OptionMembers = "None","1","2","3","1-2","2-3","1-3";
        }
        field(25; "Underline Amount"; Option)
        {
            InitValue = "None";
            OptionMembers = "None",Underline,"Double Underline";
        }
        field(26; "Loan ID"; Code[10])
        {
            TableRelation = "Payroll-Loan";
        }
        field(27; "Payslip Text"; Text[40])
        {
            Editable = false;
        }
        field(28; "Employee Category"; Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(29; "Staff Posting Type"; Option)
        {
            OptionCaption = ' ,Salary Adv.,Housing,Non-Housing';
            OptionMembers = " ","Salary Adv.",Housing,"Non-Housing";
        }
        field(30; "User Id"; Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(31; Status; Option)
        {
            Editable = false;
            OptionMembers = " ",Journal,Posted;
        }
        field(32; "Period Start"; Date)
        {
            Editable = false;
        }
        field(33; "Period End"; Date)
        {
            Editable = false;
        }
        field(34; "Job No."; Code[20])
        {
            TableRelation = Job;
        }
        field(35; Reimbursable; Boolean)
        {
        }
        field(36; "Global Dimension 3 Code"; Code[50])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(37; Bold; Boolean)
        {
        }
        field(38; "Arrears Amount"; Decimal)
        {
        }
        field(39; Updated; Boolean)
        {
        }
        field(40; "Actual Prorated Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Skip Recalc."; Boolean)
        {
        }
        field(42; "Amount (LCY)"; Decimal)
        {
        }
        field(43; Compute; Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(44; "Common ID"; Code[10])
        {
        }
        field(45; "Loan (Y/N)"; Boolean)
        {
        }
        field(46; "No. of Days Prorate"; Boolean)
        {
        }
        field(47; "No. of Months Prorate"; Boolean)
        {
        }
        field(48; "Currency Code"; Code[10])
        {
        }
        field(49; "Dimension Set ID"; Integer)
        {
        }
        field(50; "Processed Leave Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Payroll Period", "Employee No.", "E/D Code")
        {
            Clustered = true;
            SumIndexFields = Amount, Quantity, "Arrears Amount";
        }
        key(Key2; "Payroll Period", "Global Dimension 1 Code", "Global Dimension 2 Code", "Job No.", "Debit Acc. Type", "Debit Account", "Credit Acc. Type", "Credit Account", "Loan ID")
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
        key(Key3; "Payroll Period", "Employee No.", "Statistics Group Code", "Pos. In Payslip Grp.")
        {
            SumIndexFields = Amount, Quantity, "Arrears Amount";
        }
        key(Key4; "E/D Code", "Employee No.", "Payroll Period")
        {
        }
        key(Key5; "Employee No.", "Payroll Period")
        {
        }
        key(Key6; "Global Dimension 1 Code", "E/D Code")
        {
        }
        key(Key7; "Payroll Period", "Global Dimension 1 Code", "Employee No.", "E/D Code")
        {
        }
        key(Key8; "Global Dimension 1 Code", "Employee No.", "Employee Category")
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
        key(Key9; "Payroll Period", "Employee No.", "Loan ID", Status)
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
        key(Key10; "Debit Account", "Credit Account")
        {
        }
        key(Key11; "Employee No.", "E/D Code", Units)
        {
        }
        key(Key12; "Employee No.", "Statistics Group Code", "Period End")
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
        key(Key13; "Payroll Period", "E/D Code", "Debit Account", "Credit Account")
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
    }

    fieldgroups
    {
    }

    var
        "E/DFileRec": Record "Payroll-E/D";
        ConstEDFileRec: Record "Payroll-E/D";
        ProllHeader: Record "Payroll-Payslip Header";
        ProllRecStore: Record "Payroll-Payslip Line";
        ProllFactorRec: Record "Payroll-Payslip Line";
        ProllEntryRec: Record "Payroll-Payslip Line";
        LookHeaderRec: Record "Payroll-Lookup Header";
        LookLinesRec: Record "Payroll-Lookup Line";
        FactorLookRec: Record "Payroll-Factor Lookup";
        EmployeeRec: Record "Payroll-Employee";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        PrevLookRec: Record "Payroll-Lookup Line";
        ProllLoan: Record "Payroll-Loan";
        ProllLoanEntry: Record "Payroll-Loan Entry";
        ProllLoanEntry2: Record "Payroll-Loan Entry";
        ProllPeriod: Record "Payroll-Period";
        FinanceAccRec: Record "G/L Account";
        CustomerAccRec: Record Customer;
        SupplierAccRec: Record Vendor;
        PayPeriodRec: Record "Payroll-Period";
        RepRec: Record "Payroll-Payslip Line";
        PayrollSetUp: Record "Payroll-Setup";
        PayrollHeader: Record "Payroll-Payslip Header";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        EmployeeAbsence: Record "Employee Absence";
        PayslipLineQry: Query "Payroll-Payslip Line Query";
        DimMgt: Codeunit DimensionManagement;
        RoundDir: Text[1];
        ReturnAmount: Decimal;
        InputAmount: Decimal;
        ComputedTotal: Decimal;
        AmountToAdd: Decimal;
        FactorRecAmount: Decimal;
        AmtToAdd: Decimal;
        RoundPrec: Decimal;
        BackOneRec: Integer;
        MaxChangeCount: Integer;
        IsComputed: Boolean;
        FactorOf: Boolean;
        Text000: label 'It is not possible to have %1 and %2 together!';
        Text001: label 'Maximum no. of entries already exceeded!\ %1 already taken in %2';
        Text002: label 'Loan Amount can not changed manually';
        Text003: label 'Entries for Employee %1/ in Period %2/ are closed\Nothing can be deleted';
        Text004: label 'E/D code %1 cannot be changed for %2!';
        Text005: label 'Entries for Employee %1 for period %2 have already been closed';
        Text006: label 'Do you want to apply Maximum/Minimum check!';
        Text007: label 'Factor Lookup Not Registered Yet';
        Text008: label 'The E/D Code %1,seems to have been defined with CYCLIC characteristics';
        PeriodTaken: Code[20];
        Text009: label 'Do you want to delete %1';
        Text010: label 'This employee is not entitled to this E/D';
        nMonths: Decimal;
        RefDate: Date;
        Text011: label 'Fatal Error! Employment Date for Employee %1 is blank';
        Text012: label 'ED Cannot be deleted!';
        CurrencyDate: Date;


    procedure SpecialRelation("FieldNo.": Integer)
    begin
    end;


    procedure CalcAmount(EDFileRec: Record "Payroll-E/D"; var EntryLineRec: Record "Payroll-Payslip Line"; EntryLineAmount: Decimal; EDCode: Code[20]): Decimal
    begin
    end;


    procedure CheckClosed(): Boolean
    begin
    end;


    procedure CalcTaxAmt(var LDetailsRec: Record "Payroll-Lookup Line"; TaxTableInput: Decimal): Decimal
    begin
    end;


    procedure CalcGraduated(var WantedLookRec: Record "Payroll-Lookup Line"; InputToTable: Decimal): Decimal
    begin
    end;


    procedure CalcCompute(EntryRecParam: Record "Payroll-Payslip Line"; AmountInLine: Decimal; "CalledFromEdCode?": Boolean; EDCode: Code[20])
    begin
    end;


    procedure CalcFactor1(CurrentEntryLine: Record "Payroll-Payslip Line")
    begin
    end;


    procedure "CalcFactor1.1"(CurrLineRec: Record "Payroll-Payslip Line"; LineToChangeRec: Record "Payroll-Payslip Line"; EDFileRec: Record "Payroll-E/D"): Decimal
    begin
    end;


    procedure ChangeAllOver(CurrentRec: Record "Payroll-Payslip Line"; CurrWasDeleted: Boolean)
    var
        ChangeOthersRec: Record "Payroll-Payslip Line";
    begin
    end;


    procedure ComputeAgain(ParamLine: Record "Payroll-Payslip Line"; CurrentRec: Record "Payroll-Payslip Line"; CurrWasDeleted: Boolean)
    begin
    end;


    procedure CalcFactorAgain(ParamLine: Record "Payroll-Payslip Line"; CurrentRec: Record "Payroll-Payslip Line"; CurrWasDeleted: Boolean)
    begin
    end;


    procedure ResetChangeFlags(CurrentRec: Record "Payroll-Payslip Line")
    begin
    end;


    procedure AmountIsComputed(var ReturnAmount: Decimal; EntryLineRec: Record "Payroll-Payslip Line"; EDFileRec: Record "Payroll-E/D"; NewAmount: Decimal; EDCode: Code[20]): Boolean
    begin
    end;


    procedure ChangeDueToDelete(DeletedRec: Record "Payroll-Payslip Line")
    begin
    end;


    procedure ChkRoundMaxMin(EDRecord: Record "Payroll-E/D"; TheAmount: Decimal): Decimal
    begin
    end;


    procedure CalcLoanAmount(EDFileRec: Record "Payroll-E/D"; var CurrEntryLineRec: Record "Payroll-Payslip Line"): Decimal
    var
        LoanRec: Record "Payroll-Loan";
        RepaymentAmt: Decimal;
        IntRepaymentAmt: Decimal;
        TotalRepaymentAmt: Decimal;
        RemainingAmt: Decimal;
        IntRemainingAmt: Decimal;
        IncludeLoan: Boolean;
        NextLoanEntryNo: Integer;
    begin
    end;


    procedure ReCalculateAmount()
    begin
    end;


    procedure CheckNoOfEntries() NoOfEntries: Integer
    var
        ProllPeriod: Record "Payroll-Period";
        PayrollFirstPeriod: Code[10];
    begin
    end;


    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure ProrateAmount(EDFileRec: Record "Payroll-E/D"; ProrateAmount: Decimal; PayLine: Record "Payroll-Payslip Line") ProratedAmount: Decimal
    var
        NoofMonthDays: Integer;
        RefDate2: Date;
    begin
    end;


    procedure CheckCommonIDExists(ShowErr: Boolean): Boolean
    var
        CommonIDErr: Text;
    begin
    end;


    procedure SetLastPeriod(var RefPeriod: Code[20])
    begin
    end;


    procedure GetPayrollHeader()
    begin
    end;


    procedure CalcAmountLCY(AmounttoCalculate: Decimal; var PayLine: Record "Payroll-Payslip Line")
    begin
    end;
}

