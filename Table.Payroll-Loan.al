Table 52092152 "Payroll-Loan"
{
    DataCaptionFields = "Loan ID", "Employee No.", "Employee Name";
    Permissions = TableData Customer = rimd,
                  TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;

    fields
    {
        field(1; "Loan ID"; Code[20])
        {
        }
        field(2; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Employee No." <> '' then begin
                    if ("Voucher No." <> '') and (xRec."Employee No." <> '') and
                      (xRec."Employee No." <> "Employee No.") and (CurrFieldNo = FieldNo("Employee No.")) then
                        Error(Text000);
                    if (xRec."Employee No." <> '') and (xRec."Employee No." <> "Employee No.") and
                      (CurrFieldNo = FieldNo("Employee No.")) then
                        if Posted and ("Remaining Amount" <> 0) then
                            Error(Text000);

                    Employee.Get("Employee No.");
                    if Employee."Customer No." = '' then
                        Employee.CreateDebtor;

                    "Account Type" := "account type"::Customer;
                    "Account No." := Employee."Customer No.";
                    "Employee Name" := Employee.FullName;
                    "Employee Category" := Employee."Employee Category";
                    "Grade Level" := Employee."Grade Level Code";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                end;
            end;
        }
        field(3; "Employee Name"; Text[40])
        {
            NotBlank = true;
        }
        field(5; Description; Text[40])
        {
            NotBlank = true;
        }
        field(6; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";

            trigger OnValidate()
            begin
                if "Account No." <> '' then
                    Error(Text002, FieldName("Account Type"));
                if ("Voucher No." <> '') then
                    Error(Text003, "Voucher No.");
            end;
        }
        field(7; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor;

            trigger OnValidate()
            begin
                if CurrFieldNo <> 0 then
                    Error(Text002, FieldName("Account No."));
                if ("Voucher No." <> '') then
                    Error(Text003, "Voucher No.");
            end;
        }
        field(8; "Counter Acct. Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";

            trigger OnValidate()
            begin
                if "Source Document Type" = "source document type"::"Cash Advance"
                  then
                    Error(Text004)
            end;
        }
        field(9; "Counter Acct. No."; Code[20])
        {
            TableRelation = if ("Counter Acct. Type" = const("G/L Account")) "G/L Account"
            else
            if ("Counter Acct. Type" = const(Customer)) Customer
            else
            if ("Counter Acct. Type" = const(Vendor)) Vendor
            else
            if ("Counter Acct. Type" = const("Bank Account")) "Bank Account"
            else
            if ("Counter Acct. Type" = const("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            begin
                if "Source Document Type" = "source document type"::"Cash Advance"
                  then
                    Error(Text004)
            end;
        }
        field(10; "Loan Amount"; Decimal)
        {
            BlankZero = true;
            MinValue = 0;

            trigger OnValidate()
            begin
                if ("Voucher No." <> '') then
                    Error(Text003, "Voucher No.");

                CalcFields("Repaid Amount");
                if "Repaid Amount" <> 0 then
                    Error(Text018);
                CheckShareholdersFundlimit;

                Validate("Number of Payments");

                Validate("Interest Rate (%)");
            end;
        }
        field(12; "Number of Payments"; Integer)
        {
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Number of Payments" <> 0 then
                    "Monthly Repayment" := ROUND(("Loan Amount") / "Number of Payments", 0.01, '>')
                else
                    if CurrFieldNo = FieldNo("Number of Payments") then
                        Error(Text006);

                "Loan Due Date" := CalcDate((Format("Number of Payments") + 'M'), "Posting Date for Loan");

                Validate("Monthly Repayment");
            end;
        }
        field(13; "Monthly Repayment"; Decimal)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                if "Monthly Repayment" <> 0 then
                    "Number of Payments" := ROUND(("Loan Amount") / "Monthly Repayment", 1, '=');
                CheckDSRLimit;
            end;
        }
        field(14; "Open(Y/N)"; Boolean)
        {
        }
        field(15; "Suspended(Y/N)"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Suspended(Y/N)" then begin
                    "Suspended By" := UserId;
                    "Date Suspended" := Today;
                end;
            end;
        }
        field(16; "Loan E/D"; Code[10])
        {
            TableRelation = "Payroll-E/D"."E/D Code" where("Loan (Y/N)" = filter(true));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);

                if "Loan E/D" <> '' then begin
                    EDRec.Get("Loan E/D");
                    if not EDRec."Loan (Y/N)" then
                        Error(Text007);

                    PayrollLoanRec.SetRange(PayrollLoanRec."Employee No.", "Employee No.");
                    PayrollLoanRec.SetFilter(PayrollLoanRec."Loan ID", '<>%1', "Loan ID");
                    PayrollLoanRec.SetRange(PayrollLoanRec."Loan E/D", "Loan E/D");
                    if PayrollLoanRec.Find('-') then
                        repeat
                            if not (EDRec."Allow Multiple Loans") then begin
                                if PayrollLoanRec."Open(Y/N)" then
                                    Error(Text009);
                            end;
                        until PayrollLoanRec.Next = 0;

                    Validate("Number of Payments", EDRec."Number of Repayment");
                    Description := EDRec.Description;
                end;
            end;
        }
        field(17; "Remaining Amount"; Decimal)
        {
            BlankZero = true;
            CalcFormula = sum("Payroll-Loan Entry".Amount where("Employee No." = field("Employee No."),
                                                                 "Loan ID" = field("Loan ID"),
                                                                 Date = field("Date Filter"),
                                                                 "Amount Type" = const("Loan Amount")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Posting Date for Loan"; Date)
        {
        }
        field(19; "Source Document No."; Code[10])
        {

            trigger OnValidate()
            var
                VendPostingGrp: Record "Vendor Posting Group";
            begin
                /*TESTFIELD(Status,Status::Open);
                IF ("Source Document Type" = "Source Document Type"::"Cash Advance") THEN
                BEGIN
                  IF (xRec."Source Document No." <> '') THEN BEGIN
                    CashAdvance.GET(CashAdvance."Document Type"::"1",xRec."Source Document No.");
                    CashAdvance.TESTFIELD("Retirement Status",CashAdvance."Retirement Status"::"0");
                  END;
                  IF "Source Document No." <> '' THEN BEGIN
                    CashAdvance.GET(CashAdvance."Document Type"::"1","Source Document No.");
                    CashAdvance.TESTFIELD("Entry Status",CashAdvance."Entry Status"::"2");
                    VALIDATE("Employee No.",CashAdvance."Payee No.");
                    CASE CashAdvance."Retirement Status" OF
                      CashAdvance."Retirement Status"::"0":
                        BEGIN
                          CashAdvance.CALCFIELDS(Amount,"Amount (LCY)");
                          IF "Loan Amount" = 0 THEN
                            VALIDATE("Loan Amount",CashAdvance."Amount (LCY)");
                          CashAdvance."Retirement No." := "Loan ID";
                        END;
                      CashAdvance."Retirement Status"::"3":
                        BEGIN
                          IF "Loan Amount" = 0 THEN
                            VALIDATE("Loan Amount",CashAdvance.GetAmountRefundable(TRUE));
                        END;
                    END;
                    IF "Number of Payments" = 0 THEN
                      VALIDATE("Number of Payments",1);
                    VendPostingGrp.GET(CashAdvance."Employee Posting Group");
                    "Counter Acct. Type" := "Counter Acct. Type"::"G/L Account";
                    //"Counter Acct. No." := VendPostingGrp."Cash Adv. Receivable Acc.";
                  END;
                END;*/

            end;
        }
        field(21; "Voucher No."; Code[20])
        {
            Editable = false;
        }
        field(22; "Originated By"; Code[20])
        {
            TableRelation = Employee;
        }
        field(23; Date; Date)
        {
        }
        field(24; "Source Document Type"; Option)
        {
            OptionCaption = ' ,Cash Advance';
            OptionMembers = " ","Cash Advance";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if (xRec."Source Document Type" <> "Source Document Type") and (xRec."Source Document Type" = "source document type"::"Cash Advance") then
                    Validate("Source Document No.", '');
            end;
        }
        field(25; "Interest Amount"; Decimal)
        {
            BlankZero = true;

            trigger OnValidate()
            begin
                if "Interest Amount" <> 0 then
                    TestField("Interest Calculation Method", "interest calculation method"::Declining);
            end;
        }
        field(26; "Interest Account No."; Code[20])
        {
        }
        field(27; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(28; "Repaid Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Loan Entry".Amount where(Date = field("Date Filter"),
                                                                 "Loan ID" = field("Loan ID"),
                                                                 "Entry Type" = filter(<> "Cost Amount"),
                                                                 "Amount Type" = const("Loan Amount")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Period Filter"; Code[10])
        {
            Editable = false;
            FieldClass = FlowFilter;
            TableRelation = "Payroll-Period";
        }
        field(31; Posted; Boolean)
        {
        }
        field(32; "User ID"; Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(33; "Suspended By"; Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(34; "Date Suspended"; Date)
        {
            Editable = false;
        }
        field(35; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Cancelled';
            OptionMembers = Open,Approved,"Pending Approval",Cancelled;
        }
        field(36; "Request Location"; Option)
        {
            OptionCaption = 'Requestor,HR';
            OptionMembers = Requestor,HR;
        }
        field(37; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(38; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(47; Balance; Decimal)
        {
            CalcFormula = sum("Payroll-Loan Entry".Amount where("Loan ID" = field("Loan ID")));
            FieldClass = FlowField;
        }
        field(48; "Interest Rate (%)"; Decimal)
        {

            trigger OnValidate()
            begin
                TestField("Loan Amount");
                case "Interest Calculation Method" of
                    "interest calculation method"::Straight, "interest calculation method"::"Straight with Ammortization":
                        "Interest Amount" := ("Loan Amount" * "Interest Rate (%)" * "Number of Payments") / (12 * 100);
                end;
            end;
        }
        field(49; "Interest Calculation Method"; Option)
        {
            OptionCaption = 'Straight,Declining,Straight with Ammortization';
            OptionMembers = Straight,Declining,"Straight with Ammortization";

            trigger OnValidate()
            begin
                PayrollSetup.Get;
                case "Interest Calculation Method" of
                    "interest calculation method"::Straight:
                        "Interest Account No." := PayrollSetup."Interest Account";
                    "interest calculation method"::"Straight with Ammortization":
                        begin
                            "Interest Account No." := PayrollSetup."Interest Account";
                            "Deferred Interest Account" := PayrollSetup."Deferred Interest Account";
                        end;
                end;
            end;
        }
        field(50; "Interest Starting Date"; Date)
        {
        }
        field(51; "Interest Date Formula"; DateFormula)
        {

            trigger OnValidate()
            begin
                "Interest Starting Date" := CalcDate("Interest Date Formula", "Posting Date for Loan");
            end;
        }
        field(52; "Interest Chargeable Amount"; Decimal)
        {
        }
        field(53; "Entry Type Filter"; Option)
        {
            OptionCaption = 'Cost Amount,Payroll Deduction,Settlement,Adjustment';
            OptionMembers = "Cost Amount","Payroll Deduction",Settlement,Adjustment;
        }
        field(55; "Cancelled By"; Code[50])
        {
        }
        field(56; Guarantor; Code[20])
        {
            TableRelation = Employee;
        }
        field(58; "Suspension Ending Date"; Date)
        {
        }
        field(59; "Loan Due Date"; Date)
        {
        }
        field(60; "Deduction Starting Date"; Date)
        {

            trigger OnValidate()
            begin
                CalcFields("Repaid Amount");
                if "Repaid Amount" <> 0 then
                    Error(Text017);
            end;
        }
        field(61; "Interest Repaid Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Loan Entry".Amount where(Date = field("Date Filter"),
                                                                 "Loan ID" = field("Loan ID"),
                                                                 "Entry Type" = filter(<> "Cost Amount"),
                                                                 "Amount Type" = const("Interest Amount")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Interest Remaining Amount"; Decimal)
        {
            CalcFormula = sum("Payroll-Loan Entry".Amount where("Loan ID" = field("Loan ID"),
                                                                 Date = field("Date Filter"),
                                                                 "Amount Type" = const("Interest Amount")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Preferred Pmt. Method"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,E-Payment';
            OptionMembers = " ",Cash,Cheque,"E-Payment";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Preferred Pmt. Method" <> xRec."Preferred Pmt. Method" then
                    "Preferred  Bank Code" := '';

                if "Preferred Pmt. Method" = "preferred pmt. method"::Cash then begin
                    "Bank Account" := '';
                    "Bank Account Name" := '';
                end else
                    if "Bank Account Name" = '' then
                        "Bank Account Name" := "Employee Name";
            end;
        }
        field(64; "Preferred  Bank Code"; Code[20])
        {
            TableRelation = if ("Preferred Pmt. Method" = filter(Cheque | "E-Payment")) "Employee Bank Account".Code where("Employee No." = field("Employee No."));

            trigger OnValidate()
            begin
                if "Preferred  Bank Code" <> '' then begin
                    EmployeeBankAccount.Get("Employee No.", "Preferred  Bank Code");
                    "Bank Account" := EmployeeBankAccount."Bank Account No.";
                    "Bank Account Name" := EmployeeBankAccount."Bank Account Name";
                end else begin
                    "Bank Account" := '';
                    "Bank Account Name" := '';
                end;
            end;
        }
        field(65; "Bank Account"; Text[30])
        {
            Editable = false;
        }
        field(66; "Bank Account Name"; Text[50])
        {
            Editable = false;
        }
        field(69; "Voucher Creation Date"; Date)
        {
        }
        field(70; "Voucher Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Does Not Exist,In-Process,Voided,Completed';
            OptionMembers = "Does Not Exist","In-Process",Voided,Completed;
        }
        field(71; "Remaining Amt Adjustment"; Decimal)
        {
        }
        field(72; "Loan Type"; Option)
        {
            OptionCaption = 'Internal,External';
            OptionMembers = Internal,External;
        }
        field(73; "Employee Category"; Code[20])
        {
            Editable = false;
            TableRelation = "Employee Category";
        }
        field(74; "Grade Level"; Code[20])
        {
            Editable = false;
            TableRelation = "Grade Level";
        }
        field(75; "System Created Entry"; Boolean)
        {
        }
        field(76; "DSR Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(77; "Deferred Interest Account"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70000; "Portal ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Mobile User ID"; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "User ID" := "Mobile User ID";
                UserSetup.Get("User ID");
                Validate("Employee No.", UserSetup."Employee No.");
            end;
        }
        field(70002; "Created from External Portal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Created from External Portal such as Retail';
        }
    }

    keys
    {
        key(Key1; "Loan ID")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.", "Open(Y/N)", "Suspended(Y/N)")
        {
        }
        key(Key3; "Employee No.", "Loan E/D", "Open(Y/N)")
        {
            SumIndexFields = "Loan Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if "Voucher No." <> '' then
            Error(Text014);
        CalcFields("Remaining Amount");
        if Posted and ("Remaining Amount" <> 0) then
            Error(Text015);
    end;

    trigger OnInsert()
    begin
        if not "System Created Entry" then begin
            PayrollLoanRec.SetRange(PayrollLoanRec."Employee No.", '');
            PayrollLoanRec.SetRange(PayrollLoanRec."User ID", UserId);
            if PayrollLoanRec.Find('+') then
                Error(Text013, PayrollLoanRec."Loan ID");
        end;

        PayrollSetup.Get;
        PayrollSetup.TestField(PayrollSetup."Loan Nos.");
        NoSeriesMgt.InitSeries(PayrollSetup."Loan Nos.", '', 0D, "Loan ID", PayrollSetup."Loan Nos.");


        if not "System Created Entry" then begin
            UserSetup.Get(UserId);
            UserSetup.TestField("Employee No.");
            Validate("Employee No.", UserSetup."Employee No.");
        end;

        if "Created from External Portal" then begin
            UserSetup.Get("Mobile User ID");
            Validate("Employee No.", UserSetup."Employee No.");
        end;

        Validate("Interest Calculation Method", PayrollSetup."Interest Calculation Method");

        CalculateDSRLimit;

        //initilaise dates
        Date := Today;
        if "Posting Date for Loan" = 0D then
            "Posting Date for Loan" := Today;
        "User ID" := UserId;
        "Open(Y/N)" := true;
    end;

    trigger OnModify()
    begin
        TestField("Loan ID");
        TestField("Employee No.");
        TestField(Description);
        TestField("Loan Amount");

        TestField("Account No.");

        TestField("Loan Amount");
        TestField("Number of Payments");
        TestField("Monthly Repayment");
        TestField("Loan E/D");

        if "Suspended(Y/N)" then
            TestField("Suspension Ending Date");

        if xRec."Employee No." = '' then
            "User ID" := UserId;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PayrollSetup: Record "Payroll-Setup";
        HRSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        Employee2: Record Employee;
        EDRec: Record "Payroll-E/D";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        PayrollLoanRec: Record "Payroll-Loan";
        ProllLoanEntry: Record "Payroll-Loan Entry";
        ProllLoanEntry2: Record "Payroll-Loan Entry";
        PayrollPeriodRec: Record "Payroll-Period";
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        EmployeeBankAccount: Record "Employee Bank Account";
        PaymentMgt: Record "Payment Mgt. Setup";
        GlobalSender: Text[80];
        Body: Text[200];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
        GenJnlLinePost: Codeunit "Gen. Jnl.-Post Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        LoanBalance: Decimal;
        LineCounter: Integer;
        Text000: label 'Staff No. cannot be changed!';
        Text001: label 'Previous Loan %1 not yet posted for Employee No. %2!';
        Text002: label '%1 cannot be changed!';
        Text003: label 'Voucher %1 already created/posted\Loan entry cannot be modified!';
        Text004: label 'Source Document is IOU\Counter Acct. Type cannot be changed!';
        Text005: label 'Salary advances are fully deductible at the end of the month!';
        Text006: label 'Number of payments cannot be zero!';
        Text007: label 'The selected E/D Code is not a loan code!';
        Text008: label 'Previous loan %1 with E/D %2 not yet exhausted!\Do you still want to continue?';
        Text009: label 'New loan cannot be registered!';
        Text011: label 'Voucher No. cannot be changed for %1!';
        Text012: label 'The CPV/CRV cannot be created\Has been posted previously!';
        Text013: label 'Previously created Loan Id %1 not used!';
        Text014: label 'Voucher has already been created!\Loan cannot be deleted';
        Text015: label 'Loan has not been fully repaid, cannot be deleted!';
        Text016: label 'Payroll Period %1 already closed.';
        Text017: label 'Deduction already started!!!';
        Text018: label 'Deduction already started!!!\ Loan amount can not be changed';
        Text019: label 'This is to notify you that loan request %1 has been created for processing by %2. ';
        Text020: label 'Loan request %1 has been recalled back by the requestor';
        Text021: label 'Request already sent to HR\\Modification is no more allowed';
        Text022: label 'Do you want to send this request to HR?';
        Text023: label 'Do you want to recall this request from HR';
        Text024: label 'Your request has been sent to HR';
        Text025: label 'Your request has been recalled from HR';
        Text026: label 'Request already with HR';
        Text027: label 'Request already under processing\\ Action not allowed';
        Text028: label 'Do you want to reject this request?';
        Text029: label 'Request rejected';
        Text030: label 'Your loan request %1 has been rejected';
        Text101: label 'Your monthly repayment cannot be more than your Remaining DSR of %1';
        Text103: label 'Shareholder''s Fund has been exhausted, your loan will not be processed .';


    procedure CreatePaymentVoucher()
    var
        PaymentVoucherHeader: Record "Payment Header";
        PaymentVoucherLine: Record "Payment Line";
    begin
        if ("Voucher No." <> '') then
            Error(Text012);

        if "Interest Amount" <> 0 then
            TestField("Interest Account No.");

        // Create and print CPV/CRV
        begin
            Employee.Get("Employee No.");
            PaymentVoucherHeader.Init;
            PaymentVoucherHeader."No." := '';
            PaymentVoucherHeader."System Created Entry" := true;
            PaymentVoucherHeader."Posting Description" := Description;
            PaymentVoucherHeader."Document Type" := PaymentVoucherHeader."document type"::"Payment Voucher";
            PaymentVoucherHeader."Payment Type" := PaymentVoucherHeader."payment type"::Others;
            PaymentVoucherHeader."Bal. Account No." := '';
            PaymentVoucherHeader.Payee := "Employee Name";
            PaymentVoucherHeader."Source No." := "Loan ID";
            PaymentVoucherHeader."Document Date" := WorkDate;
            PaymentVoucherHeader."Payment Request No." := "Loan ID";
            PaymentVoucherHeader."Currency Code" := '';
            PaymentVoucherHeader."Currency Factor" := 0;
            PaymentVoucherHeader."Payee No." := "Employee No.";
            PaymentVoucherHeader.Insert(true);
            PaymentVoucherHeader.Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
            PaymentVoucherHeader.Validate("Shortcut Dimension 2 Code", Employee."Global Dimension 2 Code");
            PaymentVoucherHeader.Modify;
            // create Payment Voucher Line
            PaymentVoucherLine.Init;
            PaymentVoucherLine."Document No." := PaymentVoucherHeader."No.";
            PaymentVoucherLine."Document Type" := PaymentVoucherHeader."Document Type";
            PaymentVoucherLine."Account Type" := PaymentVoucherLine."account type"::Customer;
            PaymentVoucherLine.Validate("Account No.", "Account No.");
            PaymentVoucherLine.Description := Description;
            PaymentVoucherLine.Validate(Amount, "Loan Amount");
            PaymentVoucherLine."Shortcut Dimension 1 Code" := PaymentVoucherHeader."Shortcut Dimension 1 Code";
            PaymentVoucherLine."Shortcut Dimension 2 Code" := PaymentVoucherHeader."Shortcut Dimension 2 Code";
            PaymentVoucherLine."Loan ID" := "Loan ID";
            PaymentVoucherLine."Line No." := 10000;
            if "Interest Amount" <> 0 then begin
                case "Interest Calculation Method" of
                    "interest calculation method"::Straight:
                        begin
                            TestField("Interest Account No.");
                            PaymentVoucherLine."Interest Amount" := "Interest Amount";
                        end;
                    "interest calculation method"::"Straight with Ammortization":
                        begin
                            TestField("Deferred Interest Account");
                            PaymentVoucherLine."Interest Amount" := "Interest Amount";
                        end;
                end;
            end;
            PaymentVoucherLine.Insert(true);

            "Voucher Creation Date" := Today;
            "Voucher No." := PaymentVoucherHeader."No.";
            Modify;

            // create payroll loan entries
            CreateProllLoanEntry('', "Loan E/D", 0, Date, 0, "Loan Amount", 0);

            //Send Notification to Accounts
            PaymentMgt.Get;
            if PaymentMgt."Loan Voucher Alert E-mail" <> '' then begin
                UserSetup.Get(UserId);
                UserSetup.TestField("E-Mail");
                UserSetup.TestField("Employee No.");
                Employee2.Get(UserSetup2."Employee No.");
                GlobalSender := Employee2."First Name" + '' + Employee2."Last Name";
                Body := StrSubstNo(Text019, "Voucher No.");
                Subject := 'ALERT FOR LOAN VOUCHER CREATED';
                SMTP.CreateMessage(GlobalSender, UserSetup."E-Mail", PaymentMgt."Loan Voucher Alert E-mail", Subject, Body, false);
                SMTP.Send;
            end;
        end;
    end;


    procedure CreateGLJournal()
    begin
        if Posted then
            exit;
        PayrollSetup.Get;
        TestField("Loan ID");
        TestField("Employee No.");
        TestField("Account No.");
        TestField("Loan Amount");
        TestField("Loan E/D");
        TestField("Number of Payments");
        TestField("Monthly Repayment");
        TestField("Posting Date for Loan");
        TestField("Source Document No.");
        //TESTFIELD("Voucher No.",'');
        if "Interest Amount" <> 0 then
            TestField("Interest Account No.");

        TestField("Counter Acct. No.");

        Clear(GenJnlLinePost);
        Window.Open(
          'Creating Lines.  #1#############\' +
          'Posting Lines.   #2#############');

        // Create G/L Journal
        begin
            Window.Update(1, 1);
            GenJnlLine.Init;
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Account Type" := "Account Type";
            GenJnlLine.Validate("Account No.", "Account No.");
            GenJnlLine."Posting Date" := WorkDate;
            GenJnlLine."Document No." := "Loan ID";
            GenJnlLine.Description := Description;
            GenJnlLine.Amount := "Loan Amount";
            GenJnlLine."Amount (LCY)" := "Loan Amount";
            GenJnlLine."Loan ID" := "Loan ID";
            GenJnlLine."External Document No." := "Loan ID";
            Window.Update(2, 1);
            GenJnlLinePost.Run(GenJnlLine);

            // B. Counter Account - CR (Principal amount)
            Window.Update(1, 2);
            GenJnlLine.Init;
            GenJnlLine."Account Type" := "Counter Acct. Type";
            GenJnlLine.Validate(GenJnlLine."Account No.", "Counter Acct. No.");
            GenJnlLine.Description := Description;
            GenJnlLine.Validate(GenJnlLine.Amount, "Loan Amount" * (-1));
            GenJnlLine.Validate(GenJnlLine."VAT %", 0);
            GenJnlLine."Gen. Bus. Posting Group" := '';
            GenJnlLine."Gen. Prod. Posting Group" := '';
            if (GenJnlLine."Account Type" = GenJnlLine."account type"::Customer) and
              (GenJnlLine."Account No." = "Account No.") then
                GenJnlLine."External Document No." := '';
            GenJnlLinePost.Run(GenJnlLine);

            /*// C. Interest Account - CR (Interest Amount)
            IF "Interest Amount" <> 0 THEN BEGIN
              TESTFIELD("Interest Account No.");
              Window.UPDATE(1,3);
              GenJnlLine.INIT;
              GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
              GenJnlLine.VALIDATE(GenJnlLine."Account No.","Interest Account No.");
              GenJnlLine.Description := 'Interest on Loan ' + "Loan ID";
              GenJnlLine.VALIDATE(GenJnlLine.Amount,"Interest Amount" * (-1));
              GenJnlLine.VALIDATE(GenJnlLine."VAT %",0);
              GenJnlLine."Depreciation Book Code" := '';
              GenJnlLine."FA Posting Type" := 0;
              GenJnlLine."Gen. Bus. Posting Group" := '';
              GenJnlLine."Gen. Prod. Posting Group" := '';
              GenJnlLine."External Document No." := "Loan ID";
              Window.UPDATE(2,2);
              GenJnlLinePost.RUN(GenJnlLine);
            END;*/

            "Open(Y/N)" := true;
            Posted := true;
            "Posting Date for Loan" := WorkDate;
            EDRec.Get("Loan E/D");
            if Format(EDRec."Loan Deduction Starting Period") <> '' then
                "Deduction Starting Date" := CalcDate(EDRec."Loan Deduction Starting Period", WorkDate)
            else
                "Deduction Starting Date" := CalcDate(PayrollSetup."Loan Deduction Starting Period", WorkDate);
            Modify;

            CreateProllLoanEntry('', "Loan E/D", 0, Date, 0, "Loan Amount", 0);
            //Ola To Consider Interest Loan
            CreateProllLoanEntry('', "Loan E/D", 0, Date, 0, "Interest Amount", 1);

        end;

        Window.Close;

    end;


    procedure CreateProllLoanEntry(PeriodCode: Code[10]; EDCode: Code[20]; EntryType: Option "Cost Amount","Payroll Deduction",Settlement,Adjustment; EntryDate: Date; CustLedgEntryNo: Integer; RepymtAmount: Decimal; AmountType: Option "Loan Amount","Interest Amount")
    begin
        TestField("Open(Y/N)");
        ProllLoanEntry.Init;
        ProllLoanEntry."Payroll Period" := PeriodCode;
        ProllLoanEntry."Employee No." := "Employee No.";
        if EDCode <> '' then
            ProllLoanEntry."E/D Code" := EDCode
        else
            ProllLoanEntry."E/D Code" := "Loan E/D";
        ProllLoanEntry."Loan ID" := "Loan ID";
        ProllLoanEntry.Amount := RepymtAmount;
        ProllLoanEntry."Entry Type" := EntryType;
        ProllLoanEntry.Date := EntryDate;
        ProllLoanEntry."Cust. Ledger Entry No." := CustLedgEntryNo;

        if ProllLoanEntry2.FindLast then
            ProllLoanEntry."Entry No." := ProllLoanEntry2."Entry No." + 1
        else
            ProllLoanEntry."Entry No." := 1;
        ProllLoanEntry.Insert;
    end;


    procedure CancelLoan()
    var
        EDLoan: Record "Payroll-Loan Entry";
        PayrollSlip: Record "Payroll-Payslip Line";
        CancelledRpdAmnt: Decimal;
        Index: Integer;
    begin
        case "Loan Type" of
            "loan type"::Internal:
                begin
                    TestField(Posted, false);
                    TestField("Voucher No.", '');
                end;
        end;
        TestField("Open(Y/N)", true);
        TestField("Suspended(Y/N)", false);
        TestField("Loan E/D");
        EDRec.Get("Loan E/D");
        Window.Open('Cancelling Loan #1##############\');
        CreateProllLoanEntry('', "Loan E/D", 0, WorkDate, 0, -("Loan Amount"), 0);
        "Open(Y/N)" := false;
        Status := Status::Cancelled;
        "Cancelled By" := UserId;
        Modify;
        Commit;
        Window.Close;
        Message(Text011);
    end;


    procedure Register()
    begin
        TestField("Loan ID");
        TestField("Employee No.");
        TestField(Description);
        TestField("Account No.");
        TestField("Loan Amount");
        TestField("Number of Payments");
        TestField("Monthly Repayment");
        TestField("Loan E/D");
        CreateProllLoanEntry('', "Loan E/D", 0, Date, 0, "Loan Amount", 0);
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
    end;


    procedure SendToHR()
    begin
        if not Confirm(Text022) then
            exit;
        if "Request Location" = "request location"::HR then
            Error(Text026);
        TestField("Employee No.");
        TestField("Account No.");
        TestField("Loan Amount");
        TestField("Loan E/D");
        "Request Location" := "request location"::HR;
        Modify;
        SendLoanRequestAlert;
        Message(Text024)
    end;


    procedure RecallFromHR()
    begin
        if not Confirm(Text023) then
            exit;
        if Status <> Status::Open then
            Error(Text027);
        if "Request Location" = "request location"::Requestor then
            exit;

        "Request Location" := "request location"::Requestor;
        Modify;
        SendLoanRecallAlert;
        Message(Text025)
    end;


    procedure RejectRequest()
    begin
        if not Confirm(Text028) then
            exit;

        TestField("Voucher No.", '');
        TestField(Status, Status::Open);
        "Request Location" := "request location"::Requestor;
        Modify;
        SendLoanRequestRejectionAlert;
    end;


    procedure SendLoanRequestAlert()
    begin
        PaymentMgt.Get;
        if PaymentMgt."Loan Request Alert E-mail" <> '' then begin
            Employee.Get("Employee No.");
            Employee.TestField(Employee."Company E-Mail");
            GlobalSender := Employee."First Name" + '' + Employee."Last Name";
            Body := StrSubstNo(Text019, "Loan ID", "Employee Name");
            Subject := 'LOAN REQUEST ALERT';
            UserSetup.TestField("E-Mail");
            SMTP.CreateMessage(GlobalSender, Employee."Company E-Mail", PaymentMgt."Loan Request Alert E-mail", Subject, Body, false);
            SMTP.Send;
        end;
    end;


    procedure SendLoanRecallAlert()
    begin
        PaymentMgt.Get;
        if PaymentMgt."Loan Request Alert E-mail" <> '' then begin
            Employee.Get("Employee No.");
            Employee.TestField(Employee."Company E-Mail");
            GlobalSender := Employee."First Name" + '' + Employee."Last Name";
            Body := StrSubstNo(Text020, "Loan ID", "Employee Name");
            Subject := 'LOAN RECALL ALERT';
            UserSetup.TestField("E-Mail");
            SMTP.CreateMessage(GlobalSender, Employee."Company E-Mail", PaymentMgt."Loan Request Alert E-mail", Subject, Body, false);
            SMTP.Send;
        end;
    end;


    procedure SendLoanRequestRejectionAlert()
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("E-Mail");
        Employee.Get("Employee No.");
        Employee.TestField("Company E-Mail");
        GlobalSender := COMPANYNAME;
        Body := StrSubstNo(Text030, "Loan ID");
        Subject := 'LOAN REQUEST REJECTION ALERT';
        SMTP.CreateMessage(GlobalSender, UserSetup."E-Mail", Employee."Company E-Mail", Subject, Body, false);
        SMTP.Send;
    end;


    procedure SendLoanVoucherAlert()
    begin
    end;

    local procedure CalculateDSRLimit()
    var
        ClosedPayrollPayslip: Record "Closed Payroll-Payslip Header";
    begin
        PayrollSetup.Get;
        if PayrollSetup."Use DSR Limit" then begin
            ClosedPayrollPayslip.SetCurrentkey("Payroll Period", "Employee No.");
            ClosedPayrollPayslip.SetRange("Employee No.", "Employee No.");
            if ClosedPayrollPayslip.FindLast then begin
                ClosedPayrollPayslip.SetRange("ED Filter", PayrollSetup."Monthly Gross ED Code");
                ClosedPayrollPayslip.CalcFields("ED Amount");
                "DSR Limit" := PayrollSetup."DSR Limit  Calc. Value" * ClosedPayrollPayslip."ED Amount";
            end;
        end;
    end;

    local procedure CheckDSRLimit()
    var
        ProllLoan: Record "Payroll-Loan";
        RemainingDSR: Decimal;
    begin
        PayrollSetup.Get;
        if PayrollSetup."Use DSR Limit" then begin
            ProllLoan.SetRange("Employee No.", "Employee No.");
            ProllLoan.SetRange("Open(Y/N)", true);
            ProllLoan.CalcSums("Monthly Repayment");
            RemainingDSR := "DSR Limit" - ProllLoan."Monthly Repayment";
            if "Monthly Repayment" + "Interest Amount" > RemainingDSR then
                Error(Text101, RemainingDSR);
        end;
    end;

    local procedure CheckShareholdersFundlimit()
    var
        ProllLoanEntry: Record "Payroll-Loan Entry";
    begin
        PayrollSetup.Get;
        if PayrollSetup."Use Stakeholders Fund Limit" then begin
            ProllLoanEntry.CalcSums(Amount);
            if PayrollSetup."StakeHolders Fund Limit" < ProllLoanEntry.Amount then
                Message(Text103);
        end;
    end;
}

