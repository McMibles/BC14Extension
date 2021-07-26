Codeunit 52092232 "Custom CheckManagement"
{
    Permissions = TableData "Cust. Ledger Entry" = rm,
                  TableData "Vendor Ledger Entry" = rm,
                  TableData "Bank Account Ledger Entry" = rm,
                  TableData "Check Ledger Entry" = rim;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Check %1 already exists for this %2.';
        Text001: label 'Voiding check %1.';
        GenJnlLine2: Record "Gen. Journal Line";
        BankAcc: Record "Bank Account";
        BankAccLedgEntry2: Record "Bank Account Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        VendorLedgEntry: Record "Vendor Ledger Entry";
        EmployeeLedgEntry: Record "Employee Ledger Entry";
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        FALedgEntry: Record "FA Ledger Entry";
        BankAccLedgEntry3: Record "Bank Account Ledger Entry";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        NextCheckEntryNo: Integer;
        Text002: label 'You cannot Financially Void checks posted in a non-balancing transaction.';
        AppliesIDCounter: Integer;
        NoAppliedEntryErr: label 'Cannot find an applied entry within the specified filter.';


    procedure FinancialVoidCheck(var CheckLedgEntry: Record "Check Ledger Entry")
    var
        TransactionBalance: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        Currency: Record Currency;
        BankAccLedgEntry4: Record "Bank Account Ledger Entry";
        ConfirmFinVoid: Page "Confirm Financial Void";
        AmountToVoid: Decimal;
        CheckAmountLCY: Decimal;
        BalanceAmountLCY: Decimal;
    begin
        CheckLedgEntry.TestField("Entry Status", CheckLedgEntry."entry status"::Posted);
        CheckLedgEntry.TestField("Statement Status", CheckLedgEntry."statement status"::Open);
        BankAcc.Get(CheckLedgEntry."Bank Account No.");
        BankAccLedgEntry2.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
        SourceCodeSetup.Get;
        with GLEntry do begin
            SetCurrentkey("Transaction No.");
            SetRange("Transaction No.", BankAccLedgEntry2."Transaction No.");
            SetRange("Document No.", BankAccLedgEntry2."Document No.");
            CalcSums(Amount);
            TransactionBalance := Amount;
        end;
        if TransactionBalance <> 0 then
            Error(Text002);

        Clear(ConfirmFinVoid);
        ConfirmFinVoid.SetCheckLedgerEntry(CheckLedgEntry);
        if ConfirmFinVoid.RunModal <> Action::Yes then
            exit;

        AmountToVoid := 0;

        with CheckLedgEntry2 do begin
            Reset;
            SetCurrentkey("Bank Account No.", "Entry Status", "Check No.");
            SetRange("Bank Account No.", CheckLedgEntry."Bank Account No.");
            SetRange("Entry Status", CheckLedgEntry."entry status"::Posted);
            SetRange("Check No.", CheckLedgEntry."Check No.");
            SetRange("Check Date", CheckLedgEntry."Check Date");
            CalcSums(Amount);
            AmountToVoid := Amount;
        end;

        InitBankGenJnlLine(
          GenJnlLine2, CheckLedgEntry."Document No.", ConfirmFinVoid.GetVoidDate,
          GenJnlLine2."account type"::"Bank Account", CheckLedgEntry."Bank Account No.",
          StrSubstNo(Text001, CheckLedgEntry."Check No."));

        GenJnlLine2.Validate(Amount, AmountToVoid);
        CheckAmountLCY := GenJnlLine2."Amount (LCY)";
        BalanceAmountLCY := 0;
        GenJnlLine2."Shortcut Dimension 1 Code" := BankAccLedgEntry2."Global Dimension 1 Code";
        GenJnlLine2."Shortcut Dimension 2 Code" := BankAccLedgEntry2."Global Dimension 2 Code";
        GenJnlLine2."Dimension Set ID" := BankAccLedgEntry2."Dimension Set ID";
        GenJnlLine2."Allow Zero-Amount Posting" := true;
        GenJnlPostLine.RunWithCheck(GenJnlLine2);

        // Mark newly posted entry as cleared for bank reconciliation purposes.
        if ConfirmFinVoid.GetVoidDate = CheckLedgEntry."Check Date" then begin
            BankAccLedgEntry3.Reset;
            BankAccLedgEntry3.FindLast;
            BankAccLedgEntry3.Open := false;
            BankAccLedgEntry3."Remaining Amount" := 0;
            BankAccLedgEntry3."Statement Status" := BankAccLedgEntry2."statement status"::Closed;
            BankAccLedgEntry3.Modify;
        end;

        InitGenJnlLine(
          GenJnlLine2, CheckLedgEntry."Document No.", ConfirmFinVoid.GetVoidDate,
          StrSubstNo(Text001, CheckLedgEntry."Check No."));
        GenJnlLine2.Validate("Currency Code", BankAcc."Currency Code");
        GenJnlLine2."Allow Zero-Amount Posting" := true;
        with GLEntry do begin
            SetCurrentkey("Transaction No.");
            SetRange("Transaction No.", BankAccLedgEntry2."Transaction No.");
            SetRange("Document No.", BankAccLedgEntry2."Document No.");
            SetRange("Posting Date", BankAccLedgEntry2."Posting Date");
            SetFilter("Entry No.", '<>%1', BankAccLedgEntry2."Entry No.");
            if FindSet then
                repeat
                    case "Source Type" of
                        0:
                            begin
                                GenJnlLine2."Account Type" := GenJnlLine2."account type"::"G/L Account";
                                GenJnlLine2.Validate("Account No.", "G/L Account No.");
                                GenJnlLine2.Validate("Currency Code", BankAcc."Currency Code");
                                GenJnlLine2.Validate(Amount, -Amount - "VAT Amount");
                                BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                                GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                                GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                                GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                                GenJnlLine2."Gen. Posting Type" := "Gen. Posting Type";
                                GenJnlLine2."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                                GenJnlLine2."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
                                GenJnlLine2."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                                GenJnlLine2."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
                                if VATPostingSetup.Get("VAT Bus. Posting Group", "VAT Prod. Posting Group") then
                                    GenJnlLine2."VAT Calculation Type" := VATPostingSetup."VAT Calculation Type";
                                GenJnlPostLine.RunWithCheck(GenJnlLine2);
                            end;
                        "source type"::Customer:
                            begin
                                if ConfirmFinVoid.GetVoidType = 0 then begin    // Unapply entry
                                    if UnApplyCustInvoices(CheckLedgEntry, ConfirmFinVoid.GetVoidDate) then
                                        GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
                                end;

                                with CustLedgEntry do begin
                                    SetCurrentkey("Transaction No.");
                                    SetRange("Transaction No.", BankAccLedgEntry2."Transaction No.");
                                    SetRange("Document No.", BankAccLedgEntry2."Document No.");
                                    SetRange("Posting Date", BankAccLedgEntry2."Posting Date");
                                    SetRange("Customer No.", GLEntry."Source No.");
                                    SetRange("Entry No.", GLEntry."Entry No.");
                                    if FindSet then
                                        repeat
                                            SetGenJnlLine(
                                              GenJnlLine2, -"Original Amount", "Currency Code", CheckLedgEntry."Document No.",
                                              GenJnlLine2."account type"::Customer, GLEntry."Source No.",
                                              "Global Dimension 1 Code", "Global Dimension 2 Code", "Dimension Set ID");
                                            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                                            GenJnlPostLine.RunWithCheck(GenJnlLine2);
                                        until Next = 0;
                                end;
                            end;
                        "source type"::Vendor:
                            begin
                                if ConfirmFinVoid.GetVoidType = 0 then begin    // Unapply entry
                                    if UnApplyVendInvoices(CheckLedgEntry, ConfirmFinVoid.GetVoidDate) then
                                        GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
                                end;

                                with VendorLedgEntry do begin
                                    SetCurrentkey("Transaction No.");
                                    SetRange("Transaction No.", BankAccLedgEntry2."Transaction No.");
                                    SetRange("Document No.", BankAccLedgEntry2."Document No.");
                                    SetRange("Posting Date", BankAccLedgEntry2."Posting Date");
                                    SetRange("Vendor No.", GLEntry."Source No.");
                                    SetRange("Entry No.", GLEntry."Entry No.");
                                    if FindSet then
                                        repeat
                                            CalcFields("Original Amount");
                                            SetGenJnlLine(
                                              GenJnlLine2, -"Original Amount", "Currency Code", CheckLedgEntry."Document No.",
                                              GenJnlLine2."account type"::Vendor, GLEntry."Source No.",
                                              "Global Dimension 1 Code", "Global Dimension 2 Code", "Dimension Set ID");
                                            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                                            GenJnlPostLine.RunWithCheck(GenJnlLine2);
                                        until Next = 0;
                                end;
                            end;
                        "source type"::Employee:
                            begin
                                if ConfirmFinVoid.GetVoidType = 0 then begin    // Unapply entry
                                    if UnApplyEmpEntries(CheckLedgEntry, ConfirmFinVoid.GetVoidDate) then
                                        GenJnlLine2."Applies-to ID" := CheckLedgEntry."Document No.";
                                end;
                                with EmployeeLedgEntry do begin
                                    SetCurrentkey("Transaction No.");
                                    SetRange("Transaction No.", BankAccLedgEntry2."Transaction No.");
                                    SetRange("Document No.", BankAccLedgEntry2."Document No.");
                                    SetRange("Posting Date", BankAccLedgEntry2."Posting Date");
                                    SetRange("Employee No.", GLEntry."Source No.");
                                    SetRange("Entry No.", GLEntry."Entry No.");
                                    if FindSet then
                                        repeat
                                            CalcFields("Original Amount");
                                            SetGenJnlLine(
                                              GenJnlLine2, -"Original Amount", "Currency Code", CheckLedgEntry."Document No.",
                                              GenJnlLine2."account type"::Employee, GLEntry."Source No.",
                                              "Global Dimension 1 Code", "Global Dimension 2 Code", "Dimension Set ID");
                                            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                                            GenJnlPostLine.RunWithCheck(GenJnlLine2);
                                        until Next = 0;
                                end;
                            end;
                        "source type"::"Bank Account":
                            begin
                                GenJnlLine2."Account Type" := GenJnlLine2."account type"::"Bank Account";
                                GenJnlLine2.Validate("Account No.", GLEntry."Source No.");
                                GenJnlLine2.Description := StrSubstNo(Text001, CheckLedgEntry."Check No.");
                                GenJnlLine2.Validate("Currency Code", BankAcc."Currency Code");
                                with BankAccLedgEntry3 do begin
                                    SetCurrentkey("Transaction No.");
                                    SetRange("Transaction No.", BankAccLedgEntry2."Transaction No.");
                                    SetRange("Document No.", BankAccLedgEntry2."Document No.");
                                    SetRange("Posting Date", BankAccLedgEntry2."Posting Date");
                                    SetFilter("Entry No.", '<>%1', BankAccLedgEntry2."Entry No.");
                                    if FindSet then
                                        repeat
                                            GenJnlLine2.Validate(Amount, -Amount);
                                            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                                            GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                                            GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                                            GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                                            GenJnlPostLine.RunWithCheck(GenJnlLine2);
                                        until Next = 0;
                                end;
                            end;
                        "source type"::"Fixed Asset":
                            begin
                                GenJnlLine2."Account Type" := GenJnlLine2."account type"::"Fixed Asset";
                                GenJnlLine2.Validate("Account No.", GLEntry."Source No.");
                                GenJnlLine2.Description := StrSubstNo(Text001, CheckLedgEntry."Check No.");
                                GenJnlLine2.Validate("Currency Code", BankAcc."Currency Code");
                                with FALedgEntry do begin
                                    SetCurrentkey("Transaction No.");
                                    SetRange("Transaction No.", BankAccLedgEntry2."Transaction No.");
                                    SetRange("Document No.", BankAccLedgEntry2."Document No.");
                                    SetRange("Posting Date", BankAccLedgEntry2."Posting Date");
                                    if FindSet then
                                        repeat
                                            GenJnlLine2.Validate(Amount, -Amount);
                                            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                                            GenJnlLine2."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
                                            GenJnlLine2."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
                                            GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                                            GenJnlPostLine.RunWithCheck(GenJnlLine2);
                                        until Next = 0;
                                end;
                            end;
                    end;
                until Next = 0;
        end;

        if ConfirmFinVoid.GetVoidDate = CheckLedgEntry."Check Date" then begin
            BankAccLedgEntry2.Open := false;
            BankAccLedgEntry2."Remaining Amount" := 0;
            BankAccLedgEntry2."Statement Status" := BankAccLedgEntry2."statement status"::Closed;
            BankAccLedgEntry2.Modify;
        end;

        if CheckAmountLCY + BalanceAmountLCY <> 0 then begin  // rounding error from currency conversion
            Currency.Get(BankAcc."Currency Code");
            Currency.TestField("Conv. LCY Rndg. Debit Acc.");
            Currency.TestField("Conv. LCY Rndg. Credit Acc.");
            GenJnlLine2.Init;
            GenJnlLine2."System-Created Entry" := true;
            GenJnlLine2."Financial Void" := true;
            GenJnlLine2."Document No." := CheckLedgEntry."Document No.";
            GenJnlLine2."Account Type" := GenJnlLine2."account type"::"G/L Account";
            GenJnlLine2."Posting Date" := ConfirmFinVoid.GetVoidDate;
            if -(CheckAmountLCY + BalanceAmountLCY) > 0 then
                GenJnlLine2.Validate("Account No.", Currency."Conv. LCY Rndg. Debit Acc.")
            else
                GenJnlLine2.Validate("Account No.", Currency."Conv. LCY Rndg. Credit Acc.");
            GenJnlLine2.Validate("Currency Code", BankAcc."Currency Code");
            GenJnlLine2.Description := StrSubstNo(Text001, CheckLedgEntry."Check No.");
            GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Check";
            GenJnlLine2."Allow Zero-Amount Posting" := true;
            GenJnlLine2.Validate(Amount, 0);
            GenJnlLine2."Amount (LCY)" := -(CheckAmountLCY + BalanceAmountLCY);
            GenJnlLine2."Shortcut Dimension 1 Code" := BankAccLedgEntry2."Global Dimension 1 Code";
            GenJnlLine2."Shortcut Dimension 2 Code" := BankAccLedgEntry2."Global Dimension 2 Code";
            GenJnlLine2."Dimension Set ID" := BankAccLedgEntry2."Dimension Set ID";
            GenJnlLine2."Gen. Bus. Posting Group" := '';
            GenJnlLine2."Gen. Prod. Posting Group" := '';
            GenJnlLine2."VAT Bus. Posting Group" := '';
            GenJnlLine2."VAT Prod. Posting Group" := '';
            GenJnlPostLine.RunWithCheck(GenJnlLine2);
        end;

        MarkCheckEntriesVoid(CheckLedgEntry, ConfirmFinVoid.GetVoidDate);
        Commit;
        UpdateAnalysisView.UpdateAll(0, true);
    end;

    local procedure UnApplyVendInvoices(var CheckLedgEntry: Record "Check Ledger Entry"; VoidDate: Date): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentVendLedgEntry: Record "Vendor Ledger Entry";
        PaymentDetVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
    begin
        // first, find first original payment line, if any
        BankAccLedgEntry.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
        if GLEntry."Source Type" = GLEntry."source type"::Vendor then begin
            with OrigPaymentVendLedgEntry do begin
                SetCurrentkey("Transaction No.");
                SetRange("Transaction No.", BankAccLedgEntry."Transaction No.");
                SetRange("Document No.", BankAccLedgEntry."Document No.");
                SetRange("Posting Date", BankAccLedgEntry."Posting Date");
                SetRange("Vendor No.", GLEntry."Source No.");
                SetRange("Entry No.", GLEntry."Entry No.");
                if not FindFirst then
                    exit(false);
            end;
        end else
            exit(false);

        AppliesID := CheckLedgEntry."Document No.";

        PaymentDetVendLedgEntry.SetCurrentkey("Vendor Ledger Entry No.", "Entry Type", "Posting Date");
        PaymentDetVendLedgEntry.SetRange("Vendor Ledger Entry No.", OrigPaymentVendLedgEntry."Entry No.");
        PaymentDetVendLedgEntry.SetRange(Unapplied, false);
        PaymentDetVendLedgEntry.SetFilter("Applied Vend. Ledger Entry No.", '<>%1', 0);
        PaymentDetVendLedgEntry.SetRange("Entry Type", PaymentDetVendLedgEntry."entry type"::Application);
        if not PaymentDetVendLedgEntry.FindFirst then
            Error(NoAppliedEntryErr);

        GenJnlLine3."Document No." := OrigPaymentVendLedgEntry."Document No.";
        GenJnlLine3."Posting Date" := VoidDate;
        GenJnlLine3."Account Type" := GenJnlLine3."account type"::Vendor;
        GenJnlLine3."Account No." := OrigPaymentVendLedgEntry."Vendor No.";
        GenJnlLine3.Correction := true;
        GenJnlLine3.Description := StrSubstNo(Text001, CheckLedgEntry."Check No.");
        GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentVendLedgEntry."Global Dimension 1 Code";
        GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentVendLedgEntry."Global Dimension 2 Code";
        GenJnlLine3."Posting Group" := OrigPaymentVendLedgEntry."Vendor Posting Group";
        GenJnlLine3."Source Type" := GenJnlLine3."source type"::Vendor;
        GenJnlLine3."Source No." := OrigPaymentVendLedgEntry."Vendor No.";
        GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
        GenJnlLine3."Source Currency Code" := OrigPaymentVendLedgEntry."Currency Code";
        GenJnlLine3."System-Created Entry" := true;
        GenJnlLine3."Financial Void" := true;
        GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine3, PaymentDetVendLedgEntry);

        with OrigPaymentVendLedgEntry do begin
            FindSet(true, false);  // re-get the now-modified payment entry.
            repeat                // set up to be applied by upcoming voiding entry.
                MakeAppliesID(AppliesID, CheckLedgEntry."Document No.");
                "Applies-to ID" := AppliesID;
                CalcFields("Remaining Amount");
                "Amount to Apply" := "Remaining Amount";
                "Accepted Pmt. Disc. Tolerance" := false;
                "Accepted Payment Tolerance" := 0;
                Modify;
            until Next = 0;
        end;
        exit(true);
    end;

    local procedure UnApplyCustInvoices(var CheckLedgEntry: Record "Check Ledger Entry"; VoidDate: Date): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentCustLedgEntry: Record "Cust. Ledger Entry";
        PaymentDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
    begin
        // first, find first original payment line, if any
        BankAccLedgEntry.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
        if GLEntry."Source Type" = GLEntry."source type"::Customer then begin
            with OrigPaymentCustLedgEntry do begin
                SetCurrentkey("Transaction No.");
                SetRange("Transaction No.", BankAccLedgEntry."Transaction No.");
                SetRange("Document No.", BankAccLedgEntry."Document No.");
                SetRange("Posting Date", BankAccLedgEntry."Posting Date");
                SetRange("Customer No.", GLEntry."Source No.");
                SetRange("Entry No.", GLEntry."Entry No.");
                if not FindFirst then
                    exit(false);
            end;
        end else
            exit(false);

        AppliesID := CheckLedgEntry."Document No.";

        PaymentDetCustLedgEntry.SetCurrentkey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
        PaymentDetCustLedgEntry.SetRange("Cust. Ledger Entry No.", OrigPaymentCustLedgEntry."Entry No.");
        PaymentDetCustLedgEntry.SetRange(Unapplied, false);
        PaymentDetCustLedgEntry.SetFilter("Applied Cust. Ledger Entry No.", '<>%1', 0);
        PaymentDetCustLedgEntry.SetRange("Entry Type", PaymentDetCustLedgEntry."entry type"::Application);
        if not PaymentDetCustLedgEntry.FindFirst then
            Error(NoAppliedEntryErr);

        GenJnlLine3."Document No." := OrigPaymentCustLedgEntry."Document No.";
        GenJnlLine3."Posting Date" := VoidDate;
        GenJnlLine3."Account Type" := GenJnlLine3."account type"::Customer;
        GenJnlLine3."Account No." := OrigPaymentCustLedgEntry."Customer No.";
        GenJnlLine3.Correction := true;
        GenJnlLine3.Description := StrSubstNo(Text001, CheckLedgEntry."Check No.");
        GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentCustLedgEntry."Global Dimension 1 Code";
        GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentCustLedgEntry."Global Dimension 2 Code";
        GenJnlLine3."Posting Group" := OrigPaymentCustLedgEntry."Customer Posting Group";
        GenJnlLine3."Source Type" := GenJnlLine3."source type"::Customer;
        GenJnlLine3."Source No." := OrigPaymentCustLedgEntry."Customer No.";
        GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
        GenJnlLine3."Source Currency Code" := OrigPaymentCustLedgEntry."Currency Code";
        GenJnlLine3."System-Created Entry" := true;
        GenJnlLine3."Financial Void" := true;
        GenJnlPostLine.UnapplyCustLedgEntry(GenJnlLine3, PaymentDetCustLedgEntry);

        with OrigPaymentCustLedgEntry do begin
            FindSet(true, false);  // re-get the now-modified payment entry.
            repeat                // set up to be applied by upcoming voiding entry.
                MakeAppliesID(AppliesID, CheckLedgEntry."Document No.");
                "Applies-to ID" := AppliesID;
                CalcFields("Remaining Amount");
                "Amount to Apply" := "Remaining Amount";
                "Accepted Pmt. Disc. Tolerance" := false;
                "Accepted Payment Tolerance" := 0;
                Modify;
            until Next = 0;
        end;
        exit(true);
    end;

    local procedure UnApplyEmpEntries(var CheckLedgEntry: Record "Check Ledger Entry"; VoidDate: Date): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentEmpLedgEntry: Record "Employee Ledger Entry";
        PaymentDetEmpLedgEntry: Record "Detailed Employee Ledger Entry";
        EmpLedgEntry3: Record "Employee Ledger Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
    begin
        // first, find first original payment line, if any
        BankAccLedgEntry.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
        if GLEntry."Source Type" = GLEntry."source type"::Employee then begin
            with OrigPaymentEmpLedgEntry do begin
                SetCurrentkey("Transaction No.");
                SetRange("Transaction No.", BankAccLedgEntry."Transaction No.");
                SetRange("Document No.", BankAccLedgEntry."Document No.");
                SetRange("Posting Date", BankAccLedgEntry."Posting Date");
                SetRange("Employee No.", GLEntry."Source No.");
                SetRange("Entry No.", GLEntry."Entry No.");
                if not FindFirst then
                    exit(false);
            end;
        end else
            exit(false);

        AppliesID := CheckLedgEntry."Document No.";

        PaymentDetEmpLedgEntry.SetCurrentkey("Employee Ledger Entry No.", "Entry Type", "Posting Date");
        PaymentDetEmpLedgEntry.SetRange("Employee Ledger Entry No.", OrigPaymentEmpLedgEntry."Entry No.");
        PaymentDetEmpLedgEntry.SetRange(Unapplied, false);
        PaymentDetEmpLedgEntry.SetFilter("Applied Empl. Ledger Entry No.", '<>%1', 0);
        PaymentDetEmpLedgEntry.SetRange("Entry Type", PaymentDetEmpLedgEntry."entry type"::Application);
        if not PaymentDetEmpLedgEntry.FindFirst then
            Error(NoAppliedEntryErr);

        GenJnlLine3."Document No." := OrigPaymentEmpLedgEntry."Document No.";
        GenJnlLine3."Posting Date" := VoidDate;
        GenJnlLine3."Account Type" := GenJnlLine3."account type"::Employee;
        GenJnlLine3."Account No." := OrigPaymentEmpLedgEntry."Employee No.";
        GenJnlLine3.Correction := true;
        GenJnlLine3.Description := StrSubstNo(Text001, CheckLedgEntry."Check No.");
        GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentEmpLedgEntry."Global Dimension 1 Code";
        GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentEmpLedgEntry."Global Dimension 2 Code";
        GenJnlLine3."Posting Group" := OrigPaymentEmpLedgEntry."Employee Posting Group";
        GenJnlLine3."Source Type" := GenJnlLine3."source type"::Employee;
        GenJnlLine3."Source No." := OrigPaymentEmpLedgEntry."Employee No.";
        GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
        GenJnlLine3."Source Currency Code" := OrigPaymentEmpLedgEntry."Currency Code";
        GenJnlLine3."System-Created Entry" := true;
        GenJnlLine3."Financial Void" := true;
        GenJnlPostLine.UnapplyEmplLedgEntry(GenJnlLine3, PaymentDetEmpLedgEntry);

        with OrigPaymentEmpLedgEntry do begin
            FindSet(true, false);  // re-get the now-modified payment entry.
            repeat                // set up to be applied by upcoming voiding entry.
                MakeAppliesID(AppliesID, CheckLedgEntry."Document No.");
                "Applies-to ID" := AppliesID;
                CalcFields("Remaining Amount");
                "Amount to Apply" := "Remaining Amount";
                Modify;
            until Next = 0;
        end;
        exit(true);
    end;

    local procedure MarkCheckEntriesVoid(var OriginalCheckEntry: Record "Check Ledger Entry"; VoidDate: Date)
    var
        RelatedCheckEntry: Record "Check Ledger Entry";
        RelatedCheckEntry2: Record "Check Ledger Entry";
    begin
        with RelatedCheckEntry do begin
            Reset;
            SetCurrentkey("Bank Account No.", "Entry Status", "Check No.");
            SetRange("Bank Account No.", OriginalCheckEntry."Bank Account No.");
            SetRange("Entry Status", OriginalCheckEntry."entry status"::Posted);
            SetRange("Statement Status", OriginalCheckEntry."statement status"::Open);
            SetRange("Check No.", OriginalCheckEntry."Check No.");
            SetRange("Check Date", OriginalCheckEntry."Check Date");
            SetFilter("Entry No.", '<>%1', OriginalCheckEntry."Entry No.");
            if FindSet then
                repeat
                    RelatedCheckEntry2 := RelatedCheckEntry;
                    RelatedCheckEntry2."Original Entry Status" := "Entry Status";
                    RelatedCheckEntry2."Entry Status" := "entry status"::"Financially Voided";
                    if VoidDate = OriginalCheckEntry."Check Date" then begin
                        RelatedCheckEntry2.Open := false;
                        RelatedCheckEntry2."Statement Status" := RelatedCheckEntry2."statement status"::Closed;
                    end;
                    RelatedCheckEntry2.Modify;
                until Next = 0;
        end;

        with OriginalCheckEntry do begin
            "Original Entry Status" := "Entry Status";
            "Entry Status" := "entry status"::"Financially Voided";
            if VoidDate = "Check Date" then begin
                Open := false;
                "Statement Status" := "statement status"::Closed;
            end;
            Modify;
        end;
    end;

    local procedure MakeAppliesID(var AppliesID: Code[50]; CheckDocNo: Code[20])
    begin
        if AppliesID = '' then
            exit;
        if AppliesID = CheckDocNo then
            AppliesIDCounter := 0;
        AppliesIDCounter := AppliesIDCounter + 1;
        AppliesID :=
          CopyStr(Format(AppliesIDCounter) + CheckDocNo, 1, MaxStrLen(AppliesID));
    end;

    local procedure InitBankGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; DocumentNo: Code[20]; PostingDate: Date; AccountType: Option; AccountNo: Code[20]; Description: Text[50])
    begin
        GenJnlLine.Init;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Financial Void" := true;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine."Account Type" := AccountType;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine.Validate("Account No.", AccountNo);
        GenJnlLine.Description := Description;
        GenJnlLine."Source Code" := SourceCodeSetup."Financially Voided Check";
    end;

    local procedure InitGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; DocumentNo: Code[20]; PostingDate: Date; Description: Text[50])
    begin
        GenJnlLine.Init;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Financial Void" := true;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine.Description := Description;
        GenJnlLine."Source Code" := SourceCodeSetup."Financially Voided Check";
    end;

    local procedure SetGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; OriginalAmount: Decimal; CurrencyCode: Code[10]; DocumentNo: Code[20]; AccountType: Option; AccountNo: Code[20]; Dim1Code: Code[20]; Dim2Code: Code[20]; DimSetID: Integer)
    begin
        GenJnlLine."Account Type" := AccountType;
        GenJnlLine.Validate("Account No.", AccountNo);
        GenJnlLine.Validate(Amount, OriginalAmount);
        GenJnlLine.Validate("Currency Code", CurrencyCode);
        MakeAppliesID(GenJnlLine."Applies-to ID", DocumentNo);
        GenJnlLine."Shortcut Dimension 1 Code" := Dim1Code;
        GenJnlLine."Shortcut Dimension 2 Code" := Dim2Code;
        GenJnlLine."Dimension Set ID" := DimSetID;
        GenJnlLine."Source Currency Code" := CurrencyCode;
    end;
}

