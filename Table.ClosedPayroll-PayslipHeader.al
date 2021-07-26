Table 52092168 "Closed Payroll-Payslip Header"
{
    DataCaptionFields = "Payroll Period","Employee No.","Employee Name";
    DrillDownPageID = "Closed Payslip List";
    LookupPageID = "Closed Payslip List";
    Permissions = TableData "Payroll-Loan"=rimd,
                  TableData "Payroll-Loan Entry"=rimd;

    fields
    {
        field(1;"Payroll Period";Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Payroll-Period";
        }
        field(2;"Period Start";Date)
        {
            Editable = false;
        }
        field(3;"Period End";Date)
        {
            Editable = false;
        }
        field(4;"Period Name";Text[40])
        {
            Editable = false;
        }
        field(5;Company;Code[20])
        {
            Editable = false;
        }
        field(7;"Grade Level";Code[20])
        {
        }
        field(8;"Employee No.";Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Payroll-Employee";
        }
        field(9;"Employee Name";Text[100])
        {
            Editable = false;
        }
        field(11;Closed;Boolean)
        {
            Editable = false;
        }
        field(19;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension Code 1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(20;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension Code 2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(21;"Customer Number";Code[20])
        {
            TableRelation = Customer;
        }
        field(22;Designation;Text[50])
        {
        }
        field(23;"Employee Category";Code[10])
        {
            Editable = true;
            TableRelation = "Employee Category";
        }
        field(24;"Journal Posted";Boolean)
        {
        }
        field(25;"No. Printed";Integer)
        {
        }
        field(26;"Dimension Set ID";Integer)
        {
        }
        field(27;"Statistical Group Filter";Code[10])
        {
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = "Payroll Statistical Group";
        }
        field(28;"Misc. Amount";Decimal)
        {
            CalcFormula = sum("Closed Payroll-Payslip Line".Amount where ("Payroll Period"=field("Payroll Period"),
                                                                          "Employee No."=field("Employee No."),
                                                                          "Statistics Group Code"=field("Statistical Group Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(29;"No. of Days Worked";Integer)
        {
        }
        field(31;"Amount to Post to GL - Cr";Decimal)
        {
            CalcFormula = -sum("Closed Payroll-Payslip Line".Amount where ("Payroll Period"=field("Payroll Period"),
                                                                           "Employee No."=field("Employee No."),
                                                                           "Credit Account"=filter(<>'')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(32;"Amount to Post to GL - Dr";Decimal)
        {
            CalcFormula = sum("Closed Payroll-Payslip Line".Amount where ("Payroll Period"=field("Payroll Period"),
                                                                          "Employee No."=field("Employee No."),
                                                                          "Debit Account"=filter(<>'')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33;"User ID";Code[50])
        {
        }
        field(34;"Service Scope";Option)
        {
            OptionCaption = 'Self Company,Group';
            OptionMembers = "Self Company",Group;
        }
        field(35;"Employee Payslip Group";Code[20])
        {
            Editable = false;
        }
        field(36;Paid;Boolean)
        {
        }
        field(37;"Job No.";Code[20])
        {
            TableRelation = Job;
        }
        field(38;"ShortCut Dimension 3 Code";Code[50])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(3));
        }
        field(39;"WithHold Salary";Boolean)
        {
        }
        field(40;"No. of Working Days Basis";Integer)
        {
        }
        field(41;"Salary Group";Code[20])
        {
            TableRelation = "Payroll-Employee Group Header";
        }
        field(42;"Period Filter";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-Period";
        }
        field(43;"ED Filter";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-E/D";
        }
        field(44;"ED Amount";Decimal)
        {
            CalcFormula = sum("Closed Payroll-Payslip Line".Amount where ("Payroll Period"=field("Payroll Period"),
                                                                          "Employee No."=field("Employee No."),
                                                                          "E/D Code"=field("ED Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(45;"No. of Months Worked";Integer)
        {
        }
        field(46;"Job Title Code";Code[20])
        {
            TableRelation = "Job Title";
        }
        field(47;"Tax State";Code[20])
        {
            TableRelation = State;
        }
        field(48;"Pension Adminstrator Code";Code[20])
        {
            TableRelation = "Pension Administrator";
        }
        field(49;"Currency Code";Code[10])
        {
            Editable = true;
            TableRelation = Currency;
        }
        field(50;"Currency Factor";Decimal)
        {
        }
        field(51;"No. of Month End E-mail Sent";Integer)
        {
            Editable = false;
        }
        field(52;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(55;"CBN Bank Code";Code[10])
        {
        }
        field(56;"Bank Account";Code[20])
        {
        }
        field(500;"Voucher No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5000;"Effective Date Of Salary Group";Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Payroll Period","Employee No.")
        {
            Clustered = true;
        }
        key(Key2;"Employee No.","Payroll Period")
        {
        }
        key(Key3;"Global Dimension 1 Code","Global Dimension 2 Code")
        {
        }
        key(Key4;"Employee Category","Global Dimension 1 Code")
        {
        }
        key(Key5;"Global Dimension 1 Code","Employee No.","Employee Category")
        {
        }
        key(Key6;"Pension Adminstrator Code","Global Dimension 1 Code")
        {
        }
        key(Key7;"CBN Bank Code","Global Dimension 1 Code","Global Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PayPeriodRec: Record "Payroll-Period";
        EmployeeRec: Record "Payroll-Employee";
        PayLinesRec: Record "Payroll-Payslip Line";
        EmpGrpRec: Record "Payroll-Employee Group Header";
        EmpGrpLinesRec: Record "Payroll-Employee Group Line";
        EDFileRec: Record "Payroll-E/D";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        ProllLoan: Record "Payroll-Loan";
        PayrollSetUp: Record "Payroll-Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        payrollLine: Record "Payroll-Payslip Line";
        DimMgt: Codeunit DimensionManagement;
        RepRec: Record "Payroll-Payslip Header";
        Genset: Record "General Ledger Setup";
        Text000: label 'Entries for this Employee/Period closed. Nothing can be deleted';
        Text001: label 'All entries for this employee in this period will be deleted!\Proceed with Deletion?';
        Text002: label 'Nothing was deleted';
        NoofMonthDays: Integer;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text004: label 'Do you want to change %1?';
        Text015: label 'If you change %1, the existing payroll lines will be deleted and new payroll lines based on the new information on the header will be created.\\';
        Text021: label 'Do you want to update the exchange rate?';
        CurrencyDate: Date;
        Text017: label 'You must delete the existing payroll lines before you can change %1.';
        Text031: label 'You have modified %1.\\';
        Text032: label 'Do you want to update the lines?';


    procedure ValidateShortcutDimCode(FieldNo: Integer;var ShortcutDimCode: Code[20])
    begin
    end;

    local procedure UpdateCurrencyFactor()
    begin
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
    end;


    procedure RecreatePayrollLines(ChangedFieldName: Text[100])
    var
        PayrollLineTmp: Record "Payroll-Payslip Line" temporary;
        TempInteger: Record "Integer" temporary;
        ChangeLogMgt: Codeunit "Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
    end;


    procedure PayrollLinesExist(): Boolean
    begin
    end;


    procedure UpdatePayrollLines(ChangedFieldName: Text[100];AskQuestion: Boolean)
    var
        RecRef: RecordRef;
        xRecRef: RecordRef;
        Question: Text[250];
    begin
    end;
}

