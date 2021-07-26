Table 52092174 "Payslip Header First Half"
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

    DataCaptionFields = "Payroll Period", "Employee No", "Employee Name";
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
        field(7; Section; Code[20])
        {
            Editable = false;
        }
        field(8; "Employee No"; Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Payroll-Employee";

            trigger OnValidate()
            begin
                EmployeeRec.Get("Employee No");
                begin
                    "Employee Name" := EmployeeRec.FullName;
                    "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                    "Customer Number" := EmployeeRec."Customer No.";
                    Designation := EmployeeRec.Designation;

                end;
            end;
        }
        field(9; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(11; "Closed?"; Boolean)
        {
            Editable = false;
        }
        field(12; "Gross Pay"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                   "Employee No." = field("Employee No"),
                                                                   "Statistics Group Code" = const('4')));
            Description = 'Gross Pay';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; Overtime; Decimal)
        {
            Description = 'Overtime';
            Editable = false;
        }
        field(14; "Tax Deducted"; Decimal)
        {
            Description = 'PAYE';
            Editable = false;
        }
        field(15; "Taxable Pay"; Decimal)
        {
            Description = 'Taxable Pay';
            Editable = false;
        }
        field(16; "Total Deductions"; Decimal)
        {
            Description = 'NSITF + CPF + First Hal f+ Loan Deductions + Other Deductions';
            Editable = false;
        }
        field(17; "Net Pay Due"; Decimal)
        {
            Description = 'Net Pay';
            Editable = false;
        }
        field(18; "Total Relief"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Description = 'Other Allowances';
            Editable = false;
        }
        field(19; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension Code 1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(20; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension Code 2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(21; "Customer Number"; Code[20])
        {
            TableRelation = Customer;
        }
        field(22; Designation; Text[40])
        {
        }
        field(23; "Staff Category"; Code[10])
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
        field(26; "Basic Pay"; Decimal)
        {
            Description = 'Basic';
        }
        field(27; "Group ID Filter"; Option)
        {
            Editable = false;
            FieldClass = FlowFilter;
            OptionMembers = " ","BASIC PAY",OVERTIME,"OTHER ALLOWANCES","GROSS PAY","TAXABLE PAY","TAX DEDUCTED","NSITF I","NSITF II","CPF I","CPF II","FIRST HALF","LOAN DEDUCTIONS","OTHER DEDUCTIONS","NET PAY DUE";
        }
        field(28; "Misc. Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                   "Employee No." = field("Employee No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "No. of Days Worked"; Integer)
        {

            trigger OnValidate()
            begin
                if "No. of Days Worked" = xRec."No. of Days Worked" then
                    exit;
                NoOfMonthDays := Date2dmy(CalcDate('CM', "Period Start"), 1);

                TestField("Closed?", false);
                PayrollSetUp.Get;
                PayrollSetUp.TestField(PayrollSetUp."No. of Working Days");
                PayLinesRec.SetRange("Payroll Period", "Payroll Period");
                PayLinesRec.SetRange("Arrear Type", "Arrear Type");
                PayLinesRec.SetRange("Employee No.", "Employee No");
                if PayLinesRec.Find('-') then
                    repeat
                        EDFileRec.Get(PayLinesRec."E/D Code");
                        if (EDFileRec."Prorate Arrear") and (PayLinesRec."Arrears Amount" <> 0) then begin
                            if "No. of Days Worked" = 0 then begin
                                PayLinesRec.Amount := (PayLinesRec.Amount / xRec."No. of Days Worked") *
                                                                 NoOfMonthDays;
                                PayLinesRec.Modify;
                            end else begin
                                if xRec."No. of Days Worked" = 0 then begin
                                    PayLinesRec.Amount := (PayLinesRec.Amount / NoOfMonthDays) *
                                                                      "No. of Days Worked";
                                    PayLinesRec.Modify;
                                end else begin
                                    PayLinesRec.Amount := (PayLinesRec.Amount / xRec."No. of Days Worked") * "No. of Days Worked";
                                    PayLinesRec.Modify;
                                end;
                            end;
                        end;
                    until PayLinesRec.Next = 0;
            end;
        }
        field(31; "Amount to Post to GL - Cr"; Decimal)
        {
            CalcFormula = - sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                    "Employee No." = field("Employee No"),
                                                                    "Credit Account" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Amount to Post to GL - Dr"; Decimal)
        {
            CalcFormula = sum("Payroll-Payslip Line".Amount where("Payroll Period" = field("Payroll Period"),
                                                                   "Employee No." = field("Employee No"),
                                                                   "Debit Account" = filter(<> '')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(33; "User ID"; Code[10])
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
        field(38; "Global Dimension 3 Code"; Code[50])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Global Dimension 3 Code");
            end;
        }
        field(39; "WithHold Salary"; Boolean)
        {
        }
        field(40; "No. of Working Days Basis"; Integer)
        {
        }
        field(41; "Employee Group"; Code[20])
        {
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
            CalcFormula = sum("Proll-Pslip Lines First Half".Amount where("Payroll Period" = field("Payroll Period"),
                                                                           "Employee No." = field("Employee No"),
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

                TestField("Closed?", false);
                PayLinesRec.SetRange("Payroll Period", "Payroll Period");
                PayLinesRec.SetRange("Employee No.", "Employee No");
                if PayLinesRec.Find('-') then
                    repeat
                        EDFileRec.Get(PayLinesRec."E/D Code");
                        if (EDFileRec."No. of Months Prorate") and (PayLinesRec.Amount <> 0) then begin
                            PayLinesRec.SetRange(PayLinesRec."E/D Code", PayLinesRec."E/D Code");
                            if "No. of Months Worked" = 0 then
                                PayLinesRec.ModifyAll(PayLinesRec.Amount, PayLinesRec.Amount / xRec."No. of Months Worked" * 12
                                , true)
                            else begin
                                if xRec."No. of Months Worked" = 0 then
                                    PayLinesRec.ModifyAll(PayLinesRec.Amount, PayLinesRec.Amount / 12 * "No. of Months Worked", true)
                                else
                                    PayLinesRec.ModifyAll(PayLinesRec.Amount, PayLinesRec.Amount / xRec."No. of Months Worked" * "No. of Months Worked", true);
                            end;
                            PayLinesRec.SetRange(PayLinesRec."E/D Code");
                        end;
                    until PayLinesRec.Next = 0;
            end;
        }
        field(46; "Payment Period"; Code[10])
        {
            TableRelation = "Payroll-Period";
        }
        field(48; "Arrear Type"; Option)
        {
            OptionCaption = 'Salary,Promotion,Initial Entry';
            OptionMembers = Salary,Promotion,"Initial Entry";
        }
        field(49; "No. of Days Worked (Arr)"; Integer)
        {

            trigger OnValidate()
            begin
                if "No. of Days Worked (Arr)" = xRec."No. of Days Worked (Arr)" then
                    exit;
                NoOfMonthDays := Date2dmy(CalcDate('CM', "Period Start"), 1);

                TestField("Closed?", false);
                PayrollSetUp.Get;
                //PayrollSetUp.TESTFIELD(PayrollSetUp."No. of Working Days");
                PayLinesRec.SetRange("Payroll Period", "Payroll Period");
                PayLinesRec.SetRange("Arrear Type", "Arrear Type");
                PayLinesRec.SetRange("Employee No.", "Employee No");
                if PayLinesRec.Find('-') then
                    repeat
                        EDFileRec.Get(PayLinesRec."E/D Code");
                        if (EDFileRec."Prorate Arrear") and (PayLinesRec."Arrears Amount" <> 0) then begin
                            if "No. of Days Worked (Arr)" = 0 then begin
                                PayLinesRec."Arrears Amount" := (PayLinesRec."Arrears Amount" / xRec."No. of Days Worked (Arr)") *
                                                                 NoOfMonthDays;
                                PayLinesRec.Modify;
                            end else begin
                                if xRec."No. of Days Worked (Arr)" = 0 then begin
                                    PayLinesRec."Arrears Amount" := (PayLinesRec."Arrears Amount" / NoOfMonthDays) *
                                                                      "No. of Days Worked (Arr)";
                                    PayLinesRec.Modify;
                                end else begin
                                    PayLinesRec."Arrears Amount" := (PayLinesRec."Arrears Amount" / xRec."No. of Days Worked (Arr)") *
                                                                  "No. of Days Worked (Arr)";
                                    PayLinesRec.Modify;
                                end;
                            end;
                        end;
                    until PayLinesRec.Next = 0;
            end;
        }
    }

    keys
    {
        key(Key1; "Payroll Period", "Arrear Type", "Employee No")
        {
            Clustered = true;
        }
        key(Key2; "Employee No", "Payroll Period")
        {
        }
        key(Key3; "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
        }
        key(Key4; "Staff Category", "Global Dimension 1 Code")
        {
        }
        key(Key5; "Global Dimension 1 Code", "Employee No", "Staff Category")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Closed?" then
            Error(Text000);
        TestField("Journal Posted", false);

        /* Confirm */
        if not Confirm(Text001) then
            Error(Text002);

        /* Lock 'parent' and 'child' files*/
        if RECORDLEVELLOCKING then begin
            LockTable(true);
            PayLinesRec.LockTable(true);
        end else begin
            LockTable(false);
            PayLinesRec.LockTable(false);
        end;

        /* First delete the detail lines */
        PayLinesRec.SetRange("Payroll Period", "Payroll Period");
        PayLinesRec.SetRange("Arrear Type", "Arrear Type");
        PayLinesRec.SetRange("Employee No.", "Employee No");
        PayLinesRec.DeleteAll(true);

        /* Delete the 'parent record'*/
        Delete;

        /* Disable the locking effect */
        Commit;

    end;

    trigger OnInsert()
    begin
        /*EmployeeRec.GET("Employee No");
        EmpGrpLinesRec.INIT;
        EmpGrpLinesRec."Employee Group" :=  EmployeeRec."Employee Group";
        EmpGrpLinesRec."E/D Code" := '';
        EmpGrpLinesRec.SETRANGE("Employee Group", EmployeeRec."Employee Group");
        IF  EmpGrpLinesRec.COUNT = 0 THEN
          BEGIN
            EmpGrpLinesRec.RESET;
            EXIT
          END;
        
        { Lock the Payroll Lines Entry file }
        IF RECORDLEVELLOCKING THEN
          PayLinesRec.LOCKTABLE(TRUE)
        ELSE
          PayLinesRec.LOCKTABLE(FALSE);
        
        { Transfer the E/D lines from Employe Group lines to Payroll Lines }
        EmpGrpLinesRec.FIND( '>');
        BEGIN
          PayLinesRec."Payroll Period" := "Payroll Period";
          PayLinesRec."Arrear Type" := "Arrear Type";
          PayLinesRec."Employee No." := "Employee No";
        END;
        WHILE (EmpGrpLinesRec."Employee Group" = EmployeeRec."Employee Group") DO
          BEGIN
            PayLinesRec.INIT;
            EDFileRec.GET( EmpGrpLinesRec."E/D Code");
            BEGIN
              PayLinesRec."Payslip Group ID" := EDFileRec."Payslip Group ID";
              PayLinesRec."Pos. In Payslip Grp." := EDFileRec."Pos. In Payslip Grp.";
              PayLinesRec."Payslip appearance" := EDFileRec."Payslip appearance";
              PayLinesRec.Units := EDFileRec.Units;
              PayLinesRec.Rate := EDFileRec.Rate;
              PayLinesRec."Overline Column" := EDFileRec."Overline Column";
              PayLinesRec."Underline Amount" := EDFileRec."Underline Amount";
            END;        { Payslip Grp/Pos }
            BEGIN
              PayLinesRec."E/D Code" := EmpGrpLinesRec."E/D Code";
              PayLinesRec.Units := EmpGrpLinesRec.Units;
              PayLinesRec.Rate := EmpGrpLinesRec.Rate;
              PayLinesRec.Quantity := EmpGrpLinesRec.Quantity;
              PayLinesRec.Flag := EmpGrpLinesRec.Flag;
              PayLinesRec.Amount := EmpGrpLinesRec."Default Amount";
            END;   { Rate,Units,Amount,... }
            IF  BookGrLinesRec.GET( EmployeeRec."Basic Salary",
              PayLinesRec."E/D Code") THEN BEGIN
                BEGIN
                  PayLinesRec."Debit Account" := BookGrLinesRec."Debit Account No.";
                  PayLinesRec."Credit Account" := BookGrLinesRec."Credit Account No.";
                  PayLinesRec."Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
                  PayLinesRec."Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";
                  PayLinesRec."Global Dimension 1 Code" := BookGrLinesRec."Global Dimension 1 Code";
                  PayLinesRec."Global Dimension 2 Code" := BookGrLinesRec."Global Dimension 2 Code";
                END; { Debit/Credit accounts}
                IF NOT BookGrLinesRec."Transfer Global Dim. 1 Code" THEN
                  PayLinesRec."Global Dimension 1 Code" := ''
                ELSE
                  IF PayLinesRec."Global Dimension 1 Code" = '' THEN
                    PayLinesRec."Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
        
                IF NOT BookGrLinesRec."Transfer Global Dim. 2 Code" THEN
                  PayLinesRec."Global Dimension 2 Code" := ''
                ELSE
                  IF PayLinesRec."Global Dimension 2 Code" = '' THEN
                    PayLinesRec."Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
        
                {IF BookGrLinesRec."Debit Acc. Type" = 1 THEN
                  IF EmployeeRec."Customer Number" <> '' THEN
                    PayLinesRec."Debit Account" := EmployeeRec."Customer Number" ;}
        
                {IF BookGrLinesRec."Credit Acc. Type" = 1 THEN
                  IF EmployeeRec."Customer Number" <> '' THEN
                    PayLinesRec."Credit Account" := EmployeeRec."Customer Number" ;}
              END;
            PayLinesRec.INSERT;
            IF  EmpGrpLinesRec.NEXT = 0 THEN
              BEGIN
                EmpGrpLinesRec.RESET;
                COMMIT ;
                EXIT
              END;
          END;
        COMMIT;*/

    end;

    var
        PayPeriodRec: Record "Payroll-Period";
        EmployeeRec: Record "Payroll-Employee";
        PayLinesRec: Record "Proll-Pslip Lines First Half";
        EmpGrpRec: Record "Payroll-Employee Group Header";
        EmpGrpLinesRec: Record "Payroll-Employee Group Line";
        EDFileRec: Record "Payroll-E/D";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        ProllLoan: Record "Payroll-Loan";
        PayrollSetUp: Record "Payroll-Setup";
        DimMgt: Codeunit 408;
        RepRec: Record "Payslip Header First Half";
        Genset: Record "General Ledger Setup";
        Text000: label 'Entries for this Employee/Period closed. Nothing can be deleted';
        Text001: label 'All entries for this employee in this period will be deleted!\Proceed with Deletion?';
        Text002: label 'Nothing was deleted';
        NoOfMonthDays: Integer;


    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNo, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"Payroll-Payslip Header", "Payroll Period", FieldNo, ShortcutDimCode);
        Modify;
    end;
}

