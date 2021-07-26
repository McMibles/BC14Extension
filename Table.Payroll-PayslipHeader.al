Table 52092146 "Payroll-Payslip Header"
{
    // Created           : FTN, 8/3/93
    // File name         : KI03b P.Roll Header
    // Comments          : Just to test the Header card that is intended to be used
    //                     as the main user interface for entering periodic employee
    //                     payroll details.
    // File details      : Primary Key is;
    //                      Payroll Period, Employee No
    //                   : Relations;
    //                      To Employee files
    // Display fields are: Period start, Period end and Period name, Employee name

    DataCaptionFields = "Payroll Period", "Employee No.", "Employee Name";
    DrillDownPageID = "Payslip List";
    LookupPageID = "Payslip List";
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;

    fields
    {
        field(1; "Payroll Period"; Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Payroll-Period";

            trigger OnValidate()
            begin
                PayPeriodRec.Get("Payroll Period");
                begin
                    "Period Start" := PayPeriodRec."Start Date";
                    "Period End" := PayPeriodRec."End Date";
                    "Period Name" := PayPeriodRec.Name;
                end;
            end;
        }
        field(2; "Period Start"; Date)
        {
            Editable = false;
        }
        field(3; "Period End"; Date)
        {
            Editable = false;
        }
        field(4; "Period Name"; Text[40])
        {
            Editable = false;
        }
        field(5; Company; Code[20])
        {
            Editable = false;
        }
        field(7; "Grade Level"; Code[20])
        {
        }
        field(8; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-Employee";

            trigger OnValidate()
            begin
                EmployeeRec.Get("Employee No.");
                begin
                    "Employee Name" := EmployeeRec.FullName;
                    "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                    "Customer Number" := EmployeeRec."Customer No.";
                    Designation := EmployeeRec.Designation;
                    CreateDim(
                      Database::"Payroll-Employee", "Employee No.");

                end;
            end;
        }
        field(9; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(11; Closed; Boolean)
        {
            Editable = false;
        }
        field(19; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension Code 1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(20; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension Code 2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(21; "Customer Number"; Code[20])
        {
            TableRelation = Customer;
        }
        field(22; Designation; Text[40])
        {
        }
        field(23; "Employee Category"; Code[10])
        {
            Editable = true;
            TableRelation = "Employee Category";
        }
        field(24; "Journal Posted"; Boolean)
        {
        }
        field(25; "No. Printed"; Integer)
        {
        }
        field(26; "Dimension Set ID"; Integer)
        {
        }
        field(27; "Statistical Group Filter"; Code[10])
        {
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = "Payroll Statistical Group";
        }
        field(28; "Misc. Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                   "Employee No." = field("Employee No."),
                                                                   "Statistics Group Code" = field("Statistical Group Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "No. of Days Worked"; Integer)
        {

            trigger OnValidate()
            begin
                if "No. of Days Worked" = xRec."No. of Days Worked" then
                    exit;
                if "No. of Working Days Basis" = 0 then
                    "No. of Working Days Basis" := Date2dmy(CalcDate('CM', "Period Start"), 1);
                if "No. of Days Worked" = 0 then
                    "No. of Days Worked" := "No. of Working Days Basis";

                TestField(Closed, false);

                PayLinesRec.SetRange("Payroll Period", "Payroll Period");
                PayLinesRec.SetRange("Employee No.", "Employee No.");
                PayLinesRec.SetRange("No. of Days Prorate", true);
                if PayLinesRec.Find('-') then begin
                    repeat
                        PayLinesRec.SetNoOfDays("No. of Days Worked");
                        PayLinesRec.ReCalculateAmount;
                        /*IF (PayLinesRec.Amount <> 0) THEN BEGIN
                          IF "No. of Days Worked" = 0 THEN
                            PayLinesRec.Amount := PayLinesRec.Amount / xRec."No. of Days Worked" * "No. of Working Days Basis"
                          ELSE BEGIN
                            IF xRec."No. of Days Worked" = 0 THEN
                              PayLinesRec.Amount := PayLinesRec.Amount /"No. of Working Days Basis" * "No. of Days Worked"
                            ELSE
                              PayLinesRec.Amount := PayLinesRec.Amount / xRec."No. of Days Worked" * "No. of Days Worked";
                          END;*/
                        PayLinesRec.Modify;
                        Commit;
                        PayLinesRec.CalcCompute(PayLinesRec, PayLinesRec.Amount, false, PayLinesRec."E/D Code");
                        PayLinesRec.CalcFactor1(PayLinesRec);
                        PayLinesRec.ChangeOthers := false;
                        PayLinesRec.ChangeAllOver(PayLinesRec, false);
                        PayLinesRec.ResetChangeFlags(PayLinesRec);
                    //END;
                    until PayLinesRec.Next = 0;
                end;
                PayLinesRec.Reset;

            end;
        }
        field(31; "Amount to Post to GL - Cr"; Decimal)
        {
            CalcFormula = - sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                    "Employee No." = field("Employee No."),
                                                                    "Credit Account" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Amount to Post to GL - Dr"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                   "Employee No." = field("Employee No."),
                                                                   "Debit Account" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "User ID"; Code[50])
        {
        }
        field(34; "Service Scope"; Option)
        {
            OptionCaption = 'Self Company,Group';
            OptionMembers = "Self Company",Group;
        }
        field(35; "Employee Payslip Group"; Code[20])
        {
            Editable = false;
        }
        field(36; Paid; Boolean)
        {
        }
        field(37; "Job No."; Code[20])
        {
            TableRelation = Job;
        }
        field(38; "ShortCut Dimension 3 Code"; Code[50])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "ShortCut Dimension 3 Code");
            end;
        }
        field(39; "WithHold Salary"; Boolean)
        {
        }
        field(40; "No. of Working Days Basis"; Integer)
        {
            Editable = false;
        }
        field(41; "Salary Group"; Code[20])
        {
            TableRelation = "Payroll-Employee Group Header";
        }
        field(42; "Period Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-Period";
        }
        field(43; "ED Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-E/D";
        }
        field(44; "ED Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                   "Employee No." = field("Employee No."),
                                                                   "E/D Code" = field("ED Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(45; "No. of Months Worked"; Integer)
        {

            trigger OnValidate()
            begin
                if "No. of Months Worked" = xRec."No. of Months Worked" then
                    exit;

                PayLinesRec.SetRange("Payroll Period", "Payroll Period");
                PayLinesRec.SetRange("Employee No.", "Employee No.");
                PayLinesRec.SetRange("No. of Months Prorate", true);
                if PayLinesRec.Find('-') then
                    repeat
                        if (PayLinesRec.Amount <> 0) then begin
                            if "No. of Months Worked" = 0 then
                                PayLinesRec.Amount := PayLinesRec.Amount / xRec."No. of Months Worked" * 12
                            else begin
                                if xRec."No. of Months Worked" = 0 then
                                    PayLinesRec.Amount := PayLinesRec.Amount / 12 * "No. of Months Worked"
                                else
                                    PayLinesRec.Amount := PayLinesRec.Amount / xRec."No. of Months Worked" * "No. of Months Worked";
                            end;
                            PayLinesRec.Modify;
                            Commit;
                            PayLinesRec.CalcCompute(PayLinesRec, PayLinesRec.Amount, false, PayLinesRec."E/D Code");
                            PayLinesRec.CalcFactor1(PayLinesRec);
                            PayLinesRec.ChangeOthers := false;
                            PayLinesRec.ChangeAllOver(PayLinesRec, false);
                            PayLinesRec.ResetChangeFlags(PayLinesRec);
                        end;
                    until PayLinesRec.Next = 0;
            end;
        }
        field(46; "Job Title Code"; Code[20])
        {
            TableRelation = "Job Title";
        }
        field(47; "Tax State"; Code[20])
        {
            TableRelation = State;
        }
        field(48; "Pension Adminstrator Code"; Code[20])
        {
            TableRelation = "Pension Administrator";
        }
        field(49; "Currency Code"; Code[10])
        {
            Editable = false;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if not (CurrFieldNo in [0, FieldNo("Period Start")]) or ("Currency Code" <> xRec."Currency Code") then
                    TestField(Closed, false);

                EmpGrpRec.Get("Salary Group");
                if EmpGrpRec."Currency Code" <> "Currency Code" then
                    Error(Text003, EmpGrpRec."Currency Code");

                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        if PayrollLinesExist then begin
                            SetHideValidationDialog(true);
                            UpdatePayrollLines(FieldCaption("Currency Code"), false);
                            SetHideValidationDialog(false);
                        end;
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(50; "Currency Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdatePayrollLines(FieldCaption("Currency Factor"), false);
            end;
        }
        field(51; "No. of Month End E-mail Sent"; Integer)
        {
            Editable = false;
        }
        field(52; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(55; "CBN Bank Code"; Code[10])
        {
        }
        field(56; "Bank Account"; Code[20])
        {
        }
        field(57; "ED Closed Amount"; Decimal)
        {
            CalcFormula = sum("Closed Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                          "Employee No." = field("Employee No."),
                                                                          "E/D Code" = field("ED Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(58; "Debit Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                   "Employee No." = field("Employee No."),
                                                                   "Debit Account" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "Credit Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                   "Employee No." = field("Employee No."),
                                                                   "Credit Account" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(500; "Voucher No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5000; "Effective Date Of Salary Group"; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Payroll Period", "Employee No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Payroll Period")
        {
        }
        key(Key3; "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
        }
        key(Key4; "Employee Category", "Global Dimension 1 Code")
        {
        }
        key(Key5; "Global Dimension 1 Code", "Employee No.", "Employee Category")
        {
        }
        key(Key6; "Pension Adminstrator Code", "Global Dimension 1 Code")
        {
        }
        key(Key7; "CBN Bank Code", "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Closed then
            Error(Text000);
        TestField("Journal Posted", false);

        TestField(Status, Status::Open);

        if not Confirm(Text001) then
            Error(Text002);

        if RECORDLEVELLOCKING then begin
            LockTable(true);
            PayLinesRec.LockTable(true);
        end else begin
            LockTable(false);
            PayLinesRec.LockTable(false);
        end;

        PayLinesRec.SetRange("Payroll Period", "Payroll Period");
        PayLinesRec.SetRange("Employee No.", "Employee No.");
        PayLinesRec.DeleteAll(true);

        Delete;

        Commit;
    end;

    trigger OnModify()
    begin
        TestField(Status, Status::Open);
    end;

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
        PayrollLine: Record "Payroll-Payslip Line";
        DimMgt: Codeunit 408;
        RepRec: Record "Payroll-Payslip Header";
        Genset: Record "General Ledger Setup";
        Text000: label 'Entries for this Employee/Period closed. Nothing can be deleted';
        Text001: label 'All entries for this employee in this period will be deleted!\Proceed with Deletion?';
        Text002: label 'Nothing was deleted';
        NoofMonthDays: Integer;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text003: label 'The currency selected for this employee is not correct. It must be %1';
        Text004: label 'Do you want to change %1?';
        Text015: label 'If you change %1, the existing payroll lines will be deleted and new payroll lines based on the new information on the header will be created.\\';
        Text021: label 'Do you want to update the exchange rate?';
        CurrencyDate: Date;
        Text017: label 'You must delete the existing payroll lines before you can change %1.';
        Text031: label 'You have modified %1.\\';
        Text032: label 'Do you want to update the lines?';
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';
        ChangeCurrencyQst: label 'If you change %1, the existing payroll lines will be deleted and new payroll lines based on the new information in the header will be created.\\Do you want to change %1?';


    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        TableID[1] := Type1;
        No[1] := No1;
        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No, '', "Global Dimension 1 Code", "Global Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ("Dimension Set ID" <> 0) and (PayrollLinesExist) then begin
            Modify;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "Payroll Period" <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if PayrollLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", StrSubstNo('%1 %2', "Payroll Period", "Employee No."),
            "Global Dimension 1 Code", "Global Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if PayrollLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
            if ("Period Start" = 0D) then
                CurrencyDate := WorkDate
            else
                CurrencyDate := "Period Start";

            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        if HideValidationDialog then
            Confirmed := true
        else
            Confirmed := Confirm(Text021, false);
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;


    procedure PayrollLinesExist(): Boolean
    begin
        PayrollLine.Reset;
        PayrollLine.SetRange("Payroll Period", "Payroll Period");
        PayrollLine.SetRange("Employee No.", "Employee No.");
        exit(PayrollLine.FindFirst);
    end;


    procedure UpdatePayrollLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        RecRef: RecordRef;
        xRecRef: RecordRef;
        Question: Text[250];
    begin
        if not PayrollLinesExist then
            exit;

        if AskQuestion then begin
            Question := StrSubstNo(
                Text031 +
                Text032, ChangedFieldName);
            if GuiAllowed then
                if not (Dialog.Confirm(Question, true)) then
                    exit;
        end;

        PayrollLine.LockTable;
        xRecRef.GetTable(xRec);
        Modify;
        RecRef.GetTable(Rec);

        PayrollLine.Reset;
        PayrollLine.SetRange("Payroll Period", "Payroll Period");
        PayrollLine.SetRange("Employee No.", "Employee No.");
        if PayrollLine.FindSet then
            repeat
                xRecRef.GetTable(PayrollLine);
                case ChangedFieldName of
                    FieldCaption("Currency Factor"):
                        PayrollLine.CalcAmountLCY;
                end;
                PayrollLine.Modify;
                RecRef.GetTable(PayrollLine);
            until PayrollLine.Next = 0;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text064) then
            exit;

        PayLinesRec.Reset;
        PayLinesRec.SetRange("Payroll Period", "Payroll Period");
        PayLinesRec.SetRange("Employee No.", "Employee No.");
        PayLinesRec.LockTable;
        if PayLinesRec.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(PayLinesRec."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if PayLinesRec."Dimension Set ID" <> NewDimSetID then begin
                    PayLinesRec."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PayLinesRec."Dimension Set ID", PayLinesRec."Global Dimension 1 Code", PayLinesRec."Global Dimension 2 Code");
                    PayLinesRec.Modify;
                end;
            until PayLinesRec.Next = 0;
    end;
}

