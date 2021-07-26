Codeunit 52092218 PaymentManagement
{
    Permissions = TableData "Cust. Ledger Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "Check Ledger Entry" = rimd,
                  TableData "FA Ledger Entry" = rimd,
                  TableData "Posted Payment Header" = rimd,
                  TableData "Posted Payment Line" = rimd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Are you sure you want to Void payment document %1?';
        GLSetup: Record "General Ledger Setup";
        PmtMgtSetup: Record "Payment Mgt. Setup";
        CashAdvance: Record "Posted Payment Header";
        CashAdvanceLine: Record "Posted Payment Line";
        PaymentLine: Record "Payment Line";
        CashAdvtoReverse: Record "Posted Payment Header" temporary;
        Text001: label 'Document successfully voided';
        Text002: label 'You must use the posted check register interface to financially void this document ';
        GenJnlLine2: Record "Gen. Journal Line";
        BankAcc: Record "Bank Account";
        BankAccLedgEntry2: Record "Bank Account Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GLEntry: Record "G/L Entry";
        BankAccLedgEntry3: Record "Bank Account Ledger Entry";
        CommitmentEntry: Record "Commitment Entry";
        PmtCommentLine: Record "Payment Comment Line";
        PmtCommentLine2: Record "Payment Comment Line";
        EmployeePostingGrp: Record "Employee Posting Group";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        WHTMgt: Codeunit "WHT Management";
        UserControl: Codeunit "User Permissions";
        ApprovalsMgt: Codeunit "Approvals Mgmt.";
        NextCheckEntryNo: Integer;
        AppliesIDCounter: Integer;
        Text003: label 'Check %1 already exists for this %2.';
        Text004: label 'Voiding check %1.';
        Text005: label 'You cannot Financially Void payments posted in a non-balancing transaction.';
        TransactionNo: Integer;
        BankLedgerNo: Integer;
        Text006: label 'Voiding payment %1.';
        Text007: label 'You cannot void a retired document';
        VendLedgerNo: Integer;
        Text008: label 'Voiding cash advance %1.';
        Text009: label 'Payment voucher %1 must be voided before you can carry out this action';
        Text010: label 'Financially void attached cash advance,Void only the payment voucher';
        NoAppliedEntryErr: label 'Cannot find an applied entry within the specified filter.';
        CurrCodeErr: label 'If this transaction is in your operating currency %1\\ then the currency must be blank';


    procedure VoidPayment(var PaymentHeader: Record "Payment Header")
    var
        PostedPaymentHeader: Record "Posted Payment Header";
        PostedPaymentLine: Record "Posted Payment Line";
    begin
        with PaymentHeader do begin
            UserControl.UserPermissionNoError('VOIDPAYMENT', false);
            if (not Confirm(Text000, false, PaymentHeader."No.")) or (PaymentHeader."Entry Status" = PaymentHeader."entry status"::Voided) then
                exit;
            TestField("Check Entry No.", 0);
            case "Document Type" of
                "document type"::Retirement:
                    begin
                        CashAdvance.SetRange(CashAdvance."Retirement No.", "No.");
                        if CashAdvance.Find('-') then
                            repeat
                                CashAdvanceLine.SetRange("Document Type", CashAdvance."Document Type");
                                CashAdvanceLine.SetRange("Document No.", CashAdvance."No.");
                                CashAdvanceLine.ModifyAll("Retirement No.", '');
                                CashAdvanceLine.ModifyAll("Retirement Line No.", 0);
                                CashAdvance."Retirement No." := '';
                                CashAdvance.Modify;
                            until CashAdvance.Next = 0;
                    end;
                "document type"::"Payment Voucher":
                    begin
                        GetCashAdvtoReverse(PaymentHeader."No.");
                        PaymentLine.SetRange("Document Type", "Document Type");
                        PaymentLine.SetRange(PaymentLine."Document No.", "No.");
                        if PaymentLine.FindFirst then
                            repeat
                                case "Payment Type" of
                                    "payment type"::"Supp. Invoice", "payment type"::"Cash Advance", "payment type"::Retirement:
                                        begin
                                            PaymentLine.ClearCustVendEmpApplnEntry;
                                        end;
                                end;
                            until PaymentLine.Next = 0;
                    end;
            end;
            //Delete commitment
            CommitmentEntry.SetRange("Document No.", PaymentHeader."No.");
            CommitmentEntry.DeleteAll;

            Validate(PaymentHeader."Entry Status", PaymentHeader."entry status"::Voided);
            PaymentHeader."Voided By" := UpperCase(UserId);
            PaymentHeader."Date-Time Voided" := CreateDatetime(Today, Time);
            PaymentHeader.Modify;

            //Archive Voided Payment Document
            PostedPaymentHeader.TransferFields(PaymentHeader);
            PostedPaymentHeader.Insert;
            if PmtMgtSetup."Copy Comments Pmt to Posted" then begin
                CopyCommentLines(
                  "Document Type" + 1, "Document Type" + 4,
                  "No.", PostedPaymentHeader."No.");
                PostedPaymentHeader.CopyLinks(PaymentHeader);
            end;

            PaymentLine.Reset;
            PaymentLine.SetRange("Document Type", "Document Type");
            PaymentLine.SetRange("Document No.", "No.");
            PaymentLine.FindSet;
            repeat
                PostedPaymentLine.TransferFields(PaymentLine);
                PostedPaymentLine.Insert;
                if PaymentLine.HasLinks then
                    PaymentLine.DeleteLinks;
            until PaymentLine.Next = 0;

            ApprovalsMgt.PostApprovalEntries(RecordId, PostedPaymentHeader.RecordId, PostedPaymentHeader."No.");
            ApprovalsMgt.DeleteApprovalEntries(RecordId);

            if HasLinks then
                DeleteLinks;

            PmtCommentLine.SetRange("Table Name", ("Document Type" + 1));
            PmtCommentLine.SetRange("No.", "No.");
            if not PmtCommentLine.IsEmpty then
                PmtCommentLine.DeleteAll;

            WHTMgt.DeleteWHTDocBuffer(PaymentHeader."No.");
            Delete;

            PaymentLine.DeleteAll;

            if CashAdvtoReverse.FindSet then
                repeat
                    FinancialVoidCashAdvance(CashAdvtoReverse, true, Today, false);
                until CashAdvtoReverse.Next = 0;

            CashAdvtoReverse.DeleteAll;

            Message(Text001);
        end;
    end;


    procedure FinancialVoidPayment(PostedPaymentHeader: Record "Posted Payment Header")
    var
        TransactionBalance: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        Currency: Record Currency;
        VendorLedgEntry: Record "Vendor Ledger Entry";
        EmployeeLedgEntry: Record "Employee Ledger Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        FALedgEntry: Record "FA Ledger Entry";
        ConfirmFinVoid: Page "Confirm Pmt Financial Void";
        AmountToVoid: Decimal;
        AmountToVoidLCY: Decimal;
        PaymentAmountLCY: Decimal;
        BalanceAmountLCY: Decimal;
        CurrencyRoundingDebitAccount: Code[20];
        CurrencyRoundingCreditAccount: Code[20];
    begin
        //Check permission
        UserControl.UserPermissionNoError('VOIDPAYMENT', false);

        with PostedPaymentHeader do begin
            SourceCodeSetup.Get;
            TestField("Entry Status", "entry status"::Posted);
            if "Retirement Status" <> "retirement status"::Open then
                Error(Text007);

            if "Document Type" in [0] then begin
                GetCashAdvtoReverse(PostedPaymentHeader."No.");
                PaymentLine.SetRange("Document Type", "Document Type");
                PaymentLine.SetRange(PaymentLine."Document No.", "No.");
                if PaymentLine.Find('-') then
                    repeat
                        case "Payment Type" of
                            "payment type"::"Supp. Invoice", "payment type"::"Cash Advance", "payment type"::Retirement:
                                begin
                                    PaymentLine.ClearCustVendEmpApplnEntry;
                                end;
                        end;
                    until PaymentLine.Next = 0;

                BankAcc.Get(PostedPaymentHeader."Payment Source");
                BankAccLedgEntry2.SetCurrentkey("Document No.", "Posting Date");
                BankAccLedgEntry2.SetRange("Document No.", PostedPaymentHeader."No.");
                BankAccLedgEntry2.SetRange("Bank Account No.", "Payment Source");
                BankAccLedgEntry2.FindFirst;
                TransactionNo := BankAccLedgEntry2."Transaction No.";
                BankLedgerNo := BankAccLedgEntry2."Entry No.";

                with GLEntry do begin
                    SetCurrentkey("Transaction No.");
                    SetRange("Transaction No.", BankAccLedgEntry2."Transaction No.");
                    SetRange("Document No.", BankAccLedgEntry2."Document No.");
                    CalcSums(Amount);
                    TransactionBalance := TransactionBalance + Amount;
                end;
                if TransactionBalance <> 0 then
                    Error(Text005);

                Clear(ConfirmFinVoid);
                ConfirmFinVoid.SetPostedPaymentHeader(PostedPaymentHeader);
                if ConfirmFinVoid.RunModal <> Action::Yes then
                    exit;

                PostedPaymentHeader.CalcFields(Amount, "Amount (LCY)", "WHT Amount", "WHT Amount (LCY)");

                AmountToVoid := PostedPaymentHeader.Amount - PostedPaymentHeader."WHT Amount";
                AmountToVoidLCY := PostedPaymentHeader."Amount (LCY)" - PostedPaymentHeader."WHT Amount (LCY)";

                InitBankGenJnlLine(
                  GenJnlLine2, "No.", ConfirmFinVoid.GetVoidDate,
                  GenJnlLine2."account type"::"Bank Account", "Payment Source",
                  StrSubstNo(Text006, "No."));
                GenJnlLine2.Validate(Amount, AmountToVoid);
                PaymentAmountLCY := GenJnlLine2."Amount (LCY)";
                BalanceAmountLCY := 0;
                GenJnlLine2."Shortcut Dimension 1 Code" := BankAccLedgEntry2."Global Dimension 1 Code";
                GenJnlLine2."Shortcut Dimension 2 Code" := BankAccLedgEntry2."Global Dimension 1 Code";
                GenJnlLine2."Dimension Set ID" := BankAccLedgEntry2."Dimension Set ID";
                GenJnlLine2."Allow Zero-Amount Posting" := true;
                GenJnlPostLine.RunWithCheck(GenJnlLine2);

                // Mark newly posted entry as cleared for bank reconciliation purposes.
                if ConfirmFinVoid.GetVoidDate = PostedPaymentHeader."Payment Date" then begin
                    BankAccLedgEntry3.Reset;
                    BankAccLedgEntry3.FindLast;
                    BankAccLedgEntry3.Open := false;
                    BankAccLedgEntry3."Remaining Amount" := 0;
                    BankAccLedgEntry3."Statement Status" := BankAccLedgEntry2."statement status"::Closed;
                    BankAccLedgEntry3.Modify;
                end;

                InitGenJnlLine(
                  GenJnlLine2, "No.", ConfirmFinVoid.GetVoidDate,
                  StrSubstNo(Text006, "No."));
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
                                        GenJnlLine2.Validate(Amount, -Amount);
                                        GenJnlLine2.Quantity := Quantity;
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
                                            if UnApplyCustInvoices(PostedPaymentHeader, ConfirmFinVoid.GetVoidDate) then
                                                GenJnlLine2."Applies-to ID" := PostedPaymentHeader."No.";
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
                                                    CalcFields("Original Amount");
                                                    SetGenJnlLine(
                                                      GenJnlLine2, -"Original Amount", "Currency Code", PostedPaymentHeader."No.",
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
                                            if UnApplyVendInvoices(PostedPaymentHeader, ConfirmFinVoid.GetVoidDate) then
                                                GenJnlLine2."Applies-to ID" := PostedPaymentHeader."No.";
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
                                                      GenJnlLine2, -"Original Amount", "Currency Code", PostedPaymentHeader."No.",
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
                                            if UnApplyEmpEntries(PostedPaymentHeader, ConfirmFinVoid.GetVoidDate) then
                                                GenJnlLine2."Applies-to ID" := PostedPaymentHeader."No.";
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
                                                      GenJnlLine2, -"Original Amount", "Currency Code", PostedPaymentHeader."No.",
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
                                        GenJnlLine2.Description := StrSubstNo(Text006, PostedPaymentHeader."No.");
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
                                                    GenJnlLine2."Gen. Posting Type" := 0;
                                                    GenJnlLine2."Gen. Bus. Posting Group" := '';
                                                    GenJnlLine2."Gen. Prod. Posting Group" := '';
                                                    GenJnlLine2."VAT Bus. Posting Group" := '';
                                                    GenJnlLine2."VAT Prod. Posting Group" := '';
                                                    GenJnlPostLine.RunWithCheck(GenJnlLine2);
                                                until Next = 0;
                                        end;
                                    end;
                                "source type"::"Fixed Asset":
                                    begin
                                        GenJnlLine2."Account Type" := GenJnlLine2."account type"::"Fixed Asset";
                                        GenJnlLine2.Validate("Account No.", GLEntry."Source No.");
                                        GenJnlLine2.Description := StrSubstNo(Text006, PostedPaymentHeader."No.");
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
                                                    GenJnlLine2."Gen. Posting Type" := 0;
                                                    GenJnlLine2."Gen. Bus. Posting Group" := '';
                                                    GenJnlLine2."Gen. Prod. Posting Group" := '';
                                                    GenJnlLine2."VAT Bus. Posting Group" := '';
                                                    GenJnlLine2."VAT Prod. Posting Group" := '';
                                                    GenJnlPostLine.RunWithCheck(GenJnlLine2);
                                                until Next = 0;
                                        end;
                                    end;
                            end;

                        until GLEntry.Next = 0;
                end;

                if ConfirmFinVoid.GetVoidDate = PostedPaymentHeader."Payment Date" then begin
                    BankAccLedgEntry2.Open := false;
                    BankAccLedgEntry2."Remaining Amount" := 0;
                    BankAccLedgEntry2."Statement Status" := BankAccLedgEntry2."statement status"::Closed;
                    BankAccLedgEntry2.Modify;
                end;

                if PaymentAmountLCY + BalanceAmountLCY <> 0 then begin  // rounding error from currency conversion
                    Currency.Get(BankAcc."Currency Code");
                    Currency.TestField("Conv. LCY Rndg. Debit Acc.");
                    Currency.TestField("Conv. LCY Rndg. Credit Acc.");
                    GenJnlLine2.Init;
                    GenJnlLine2."System-Created Entry" := true;
                    //GenJnlLine2."Financial Void" := TRUE;
                    GenJnlLine2."Document No." := PostedPaymentHeader."No.";
                    GenJnlLine2."Account Type" := GenJnlLine2."account type"::"G/L Account";
                    GenJnlLine2."Posting Date" := ConfirmFinVoid.GetVoidDate;
                    if -(PaymentAmountLCY + BalanceAmountLCY) > 0 then
                        GenJnlLine2.Validate("Account No.", Currency."Conv. LCY Rndg. Debit Acc.")
                    else
                        GenJnlLine2.Validate("Account No.", Currency."Conv. LCY Rndg. Credit Acc.");
                    GenJnlLine2.Validate("Currency Code", BankAcc."Currency Code");
                    GenJnlLine2.Description := StrSubstNo(Text006, PostedPaymentHeader."No.");
                    GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Check";
                    GenJnlLine2."Allow Zero-Amount Posting" := true;
                    GenJnlLine2.Validate(Amount, 0);
                    GenJnlLine2."Amount (LCY)" := -(PaymentAmountLCY + BalanceAmountLCY);
                    GenJnlLine2."Shortcut Dimension 1 Code" := BankAccLedgEntry2."Global Dimension 1 Code";
                    GenJnlLine2."Shortcut Dimension 2 Code" := BankAccLedgEntry2."Global Dimension 2 Code";
                    GenJnlLine2."Dimension Set ID" := BankAccLedgEntry2."Dimension Set ID";
                    GenJnlLine2."Gen. Posting Type" := 0;
                    GenJnlLine2."Gen. Bus. Posting Group" := '';
                    GenJnlLine2."Gen. Prod. Posting Group" := '';
                    GenJnlLine2."VAT Bus. Posting Group" := '';
                    GenJnlLine2."VAT Prod. Posting Group" := '';

                    GenJnlPostLine.RunWithCheck(GenJnlLine2);
                end;
            end;
            "Entry Status" := PostedPaymentHeader."entry status"::"Financially Voided";
            "Voided By" := UpperCase(UserId);
            "Date-Time Voided" := CreateDatetime(Today, Time);
            Modify;

            if CashAdvtoReverse.FindSet then
                repeat
                    FinancialVoidCashAdvance(CashAdvtoReverse, true, ConfirmFinVoid.GetVoidDate, false);
                until CashAdvtoReverse.Next = 0;

            Commit;
            UpdateAnalysisView.UpdateAll(0, true);

            Message(Text001);
        end;
    end;


    procedure FinancialVoidCashAdvance(PostedPaymentHeader: Record "Posted Payment Header"; ReversedByPV: Boolean; PostingDate: Date; ShowMessage: Boolean)
    var
        TransactionBalance: Decimal;
        VATPostingSetup: Record "VAT Posting Setup";
        Currency: Record Currency;
        EmpLedgerEntry2: Record "Employee Ledger Entry";
        PaymentVoucher: Record "Payment Header";
        PostedPaymentVoucher: Record "Posted Payment Header";
        ConfirmFinVoid: Page "Confirm Pmt Financial Void";
        AmountToVoid: Decimal;
        PaymentAmountLCY: Decimal;
        BalanceAmountLCY: Decimal;
        CurrencyRoundingDebitAccount: Code[20];
        CurrencyRoundingCreditAccount: Code[20];
    begin
        with PostedPaymentHeader do begin
            SourceCodeSetup.Get;
            TestField("Entry Status", "entry status"::Posted);
            if "Retirement Status" <> "retirement status"::Open then
                Error(Text007);

            //Check if voucher is raised for Cash Advance
            if not (ReversedByPV) then begin
                if PostedPaymentHeader."Voucher No." <> '' then
                    if (PaymentVoucher.Get(PaymentVoucher."document type"::"Payment Voucher", PostedPaymentHeader."Voucher No."))
                     and (not (PaymentVoucher."Entry Status" in [1, 3])) then
                        Error(Text009);
            end;

            if not (ReversedByPV) then begin
                Clear(ConfirmFinVoid);
                ConfirmFinVoid.SetPostedPaymentHeader(PostedPaymentHeader);
                if ConfirmFinVoid.RunModal <> Action::Yes then
                    exit;
                PostingDate := ConfirmFinVoid.GetVoidDate;
            end;
            CalcFields(Amount, "Amount (LCY)", "WHT Amount");
            EmployeePostingGrp.Get("Employee Posting Group");
            EmployeePostingGrp.TestField("Cash Adv. Receivable Acc.");

            AmountToVoid := Amount - "WHT Amount";

            GenJnlLine2.Init;
            GenJnlLine2."System-Created Entry" := true;
            GenJnlLine2."Financial Void" := true;
            GenJnlLine2."Document No." := PostedPaymentHeader."No.";
            GenJnlLine2."Posting Date" := PostingDate;
            GenJnlLine2.Description := StrSubstNo(Text008, PostedPaymentHeader."No.");
            GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Payments";
            GenJnlLine2."Allow Zero-Amount Posting" := true;
            GenJnlLine2."Account Type" := GenJnlLine2."account type"::"G/L Account";
            GenJnlLine2.Validate("Account No.", EmployeePostingGrp."Cash Adv. Receivable Acc.");
            GenJnlLine2.Validate("Currency Code", "Currency Code");
            GenJnlLine2.Description := StrSubstNo(Text008, PostedPaymentHeader."No.");
            GenJnlLine2.Validate(Amount, -Amount);
            BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
            GenJnlLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            GenJnlLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
            GenJnlLine2."Gen. Posting Type" := 0;
            GenJnlLine2."Gen. Bus. Posting Group" := '';
            GenJnlLine2."Gen. Prod. Posting Group" := '';
            GenJnlLine2."VAT Bus. Posting Group" := '';
            GenJnlLine2."VAT Prod. Posting Group" := '';
            GenJnlLine2."Applies-to ID" := '';
            GenJnlLine2."Applies-to Doc. Type" := 0;
            GenJnlLine2."Applies-to Doc. No." := '';
            GenJnlPostLine.RunWithCheck(GenJnlLine2);

            EmpLedgerEntry2.SetCurrentkey("Document No.", "Posting Date");
            EmpLedgerEntry2.SetRange("Document No.", PostedPaymentHeader."No.");
            EmpLedgerEntry2.SetRange("Employee No.", PostedPaymentHeader."Bal. Account No.");
            if EmpLedgerEntry2.FindFirst then begin
                GenJnlLine2.Init;
                GenJnlLine2."System-Created Entry" := true;
                GenJnlLine2."Financial Void" := true;
                GenJnlLine2."Document No." := PostedPaymentHeader."No.";
                GenJnlLine2."Posting Date" := PostingDate;
                GenJnlLine2.Description := StrSubstNo(Text008, PostedPaymentHeader."No.");
                GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Payments";
                GenJnlLine2."Allow Zero-Amount Posting" := true;
                GenJnlLine2."Account Type" := GenJnlLine2."account type"::Employee;
                GenJnlLine2.Validate("Account No.", PostedPaymentHeader."Bal. Account No.");
                GenJnlLine2.Validate("Currency Code", EmpLedgerEntry2."Currency Code");
                EmpLedgerEntry2.CalcFields("Original Amount", "Original Amt. (LCY)");
                GenJnlLine2.Validate(Amount, -EmpLedgerEntry2."Original Amount");
                BalanceAmountLCY := BalanceAmountLCY + GenJnlLine2."Amount (LCY)";
                GenJnlLine2."Applies-to Doc. Type" := EmpLedgerEntry2."Document Type";
                GenJnlLine2."Applies-to Doc. No." := EmpLedgerEntry2."Document No.";
                GenJnlLine2."Allow Application" := true;
                GenJnlLine2."Shortcut Dimension 1 Code" := EmpLedgerEntry2."Global Dimension 1 Code";
                GenJnlLine2."Shortcut Dimension 2 Code" := EmpLedgerEntry2."Global Dimension 2 Code";
                GenJnlLine2."Dimension Set ID" := EmpLedgerEntry2."Dimension Set ID";
                GenJnlLine2."Gen. Posting Type" := 0;
                GenJnlLine2."Gen. Bus. Posting Group" := '';
                GenJnlLine2."Gen. Prod. Posting Group" := '';
                GenJnlLine2."VAT Bus. Posting Group" := '';
                GenJnlLine2."VAT Prod. Posting Group" := '';
                GenJnlLine2."Entry Type" := EmpLedgerEntry2."Entry Type";
                GenJnlLine2."Cash Advance Doc. No." := EmpLedgerEntry2."Cash Advance Doc. No.";
                GenJnlPostLine.RunWithCheck(GenJnlLine2);
            end;
            if BalanceAmountLCY <> 0 then begin  // rounding error from currency conversion
                Currency.Get("Currency Code");
                Currency.TestField("Conv. LCY Rndg. Debit Acc.");
                Currency.TestField("Conv. LCY Rndg. Credit Acc.");
                GenJnlLine2.Init;
                GenJnlLine2."System-Created Entry" := true;
                //GenJnlLine2."Financial Void" := TRUE;
                GenJnlLine2."Document No." := PostedPaymentHeader."No.";
                GenJnlLine2."Account Type" := GenJnlLine2."account type"::"G/L Account";
                GenJnlLine2."Posting Date" := PostingDate;
                if -(BalanceAmountLCY) > 0 then
                    GenJnlLine2.Validate("Account No.", Currency."Conv. LCY Rndg. Debit Acc.")
                else
                    GenJnlLine2.Validate("Account No.", Currency."Conv. LCY Rndg. Credit Acc.");
                GenJnlLine2.Validate("Currency Code", "Currency Code");
                GenJnlLine2.Description := StrSubstNo(Text008, PostedPaymentHeader."No.");
                GenJnlLine2."Source Code" := SourceCodeSetup."Financially Voided Payments";
                GenJnlLine2."Allow Zero-Amount Posting" := true;
                GenJnlLine2.Validate(Amount, 0);
                GenJnlLine2."Amount (LCY)" := -(BalanceAmountLCY);
                GenJnlLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJnlLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
                GenJnlLine2."Gen. Posting Type" := 0;
                GenJnlLine2."Gen. Bus. Posting Group" := '';
                GenJnlLine2."Gen. Prod. Posting Group" := '';
                GenJnlLine2."VAT Bus. Posting Group" := '';
                GenJnlLine2."VAT Prod. Posting Group" := '';
                GenJnlLine2."Applies-to Doc. Type" := 0;
                GenJnlLine2."Applies-to Doc. No." := '';

                GenJnlPostLine.RunWithCheck(GenJnlLine2);
            end;
            PostedPaymentHeader."Voucher No." := '';
            PostedPaymentHeader."Entry Status" := PostedPaymentHeader."entry status"::"Financially Voided";
            PostedPaymentHeader."Voided By" := UpperCase(UserId);
            PostedPaymentHeader."Date-Time Voided" := CreateDatetime(Today, Time);
            PostedPaymentHeader.Modify;

            //Delete commitment
            CommitmentEntry.SetRange("Document No.", PostedPaymentHeader."No.");
            CommitmentEntry.DeleteAll;

            Commit;
            UpdateAnalysisView.UpdateAll(0, true);

            if ShowMessage then
                Message(Text001);

        end;
    end;

    local procedure UnApplyVendInvoices(var PostedPaymentHeaderEntry: Record "Posted Payment Header"; VoidDate: Date): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentVendLedgEntry: Record "Vendor Ledger Entry";
        PaymentDetVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        VendLedgEntry3: Record "Vendor Ledger Entry";
        AppliesID: Code[50];
    begin
        // first, find first original payment line, if any
        case PostedPaymentHeaderEntry."Document Type" of
            PostedPaymentHeaderEntry."document type"::"Payment Voucher":
                begin
                    BankAccLedgEntry.Get(BankLedgerNo);
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
                end;
            PostedPaymentHeaderEntry."document type"::"Cash Advance":
                begin
                    VendLedgEntry3.Get(VendLedgerNo);
                    if GLEntry."Source Type" = GLEntry."source type"::Vendor then begin
                        with OrigPaymentVendLedgEntry do begin
                            SetCurrentkey("Transaction No.");
                            SetRange("Transaction No.", VendLedgEntry3."Transaction No.");
                            SetRange("Document No.", VendLedgEntry3."Document No.");
                            SetRange("Posting Date", VendLedgEntry3."Posting Date");
                            SetRange("Vendor No.", GLEntry."Source No.");
                            SetRange("Entry No.", GLEntry."Entry No.");
                            if not FindFirst then
                                exit(false);
                        end;
                    end else
                        exit(false);
                end;
        end;
        AppliesID := PostedPaymentHeaderEntry."No.";
        if PostedPaymentHeaderEntry."Document Type" = 0 then begin
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
            case PostedPaymentHeaderEntry."Document Type" of
                PostedPaymentHeaderEntry."document type"::"Payment Voucher":
                    GenJnlLine3.Description := StrSubstNo(Text006, PostedPaymentHeaderEntry."No.");
                PostedPaymentHeaderEntry."document type"::"Cash Advance":
                    GenJnlLine3.Description := StrSubstNo(Text008, PostedPaymentHeaderEntry."No.");
            end;
            GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentVendLedgEntry."Global Dimension 1 Code";
            GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentVendLedgEntry."Global Dimension 2 Code";
            GenJnlLine3."Dimension Set ID" := OrigPaymentVendLedgEntry."Dimension Set ID";
            GenJnlLine3."Posting Group" := OrigPaymentVendLedgEntry."Vendor Posting Group";
            GenJnlLine3."Source Type" := GenJnlLine3."source type"::Vendor;
            GenJnlLine3."Source No." := OrigPaymentVendLedgEntry."Vendor No.";
            GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
            GenJnlLine3."Source Currency Code" := OrigPaymentVendLedgEntry."Currency Code";
            GenJnlLine3."System-Created Entry" := true;
            GenJnlPostLine.UnapplyVendLedgEntry(GenJnlLine3, PaymentDetVendLedgEntry);
        end;
        with OrigPaymentVendLedgEntry do begin
            FindSet(true, false);  // re-get the now-modified payment entry.
            repeat                // set up to be applied by upcoming voiding entry.
                MakeAppliesID(AppliesID, PostedPaymentHeaderEntry."No.");
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

    local procedure UnApplyCustInvoices(var PostedPaymentHeader: Record "Posted Payment Header"; VoidDate: Date): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentCustLedgEntry: Record "Cust. Ledger Entry";
        PaymentDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
    begin
        // first, find first original payment line, if any
        BankAccLedgEntry.Get(BankLedgerNo);
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

        AppliesID := PostedPaymentHeader."No.";

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
        GenJnlLine3.Description := StrSubstNo(Text006, PostedPaymentHeader."No.");
        GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentCustLedgEntry."Global Dimension 1 Code";
        GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentCustLedgEntry."Global Dimension 2 Code";
        GenJnlLine3."Posting Group" := OrigPaymentCustLedgEntry."Customer Posting Group";
        GenJnlLine3."Source Type" := GenJnlLine3."source type"::Customer;
        GenJnlLine3."Source No." := OrigPaymentCustLedgEntry."Customer No.";
        GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
        GenJnlLine3."Source Currency Code" := OrigPaymentCustLedgEntry."Currency Code";
        GenJnlLine3."System-Created Entry" := true;
        GenJnlPostLine.UnapplyCustLedgEntry(GenJnlLine3, PaymentDetCustLedgEntry);

        with OrigPaymentCustLedgEntry do begin
            FindSet(true, false);  // re-get the now-modified payment entry.
            repeat                // set up to be applied by upcoming voiding entry.
                MakeAppliesID(AppliesID, PostedPaymentHeader."No.");
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

    local procedure UnApplyEmpEntries(var PostedPaymentHeaderEntry: Record "Posted Payment Header"; VoidDate: Date): Boolean
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        OrigPaymentEmpLedgEntry: Record "Employee Ledger Entry";
        PaymentDetEmpLedgEntry: Record "Detailed Employee Ledger Entry";
        EmpLedgEntry3: Record "Employee Ledger Entry";
        GenJnlLine3: Record "Gen. Journal Line";
        AppliesID: Code[50];
    begin
        // first, find first original payment line, if any
        case PostedPaymentHeaderEntry."Document Type" of
            PostedPaymentHeaderEntry."document type"::"Payment Voucher":
                begin
                    BankAccLedgEntry.Get(BankLedgerNo);
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
                end;
            PostedPaymentHeaderEntry."document type"::"Cash Advance":
                begin
                    EmpLedgEntry3.Get(VendLedgerNo);
                    if GLEntry."Source Type" = GLEntry."source type"::Employee then begin
                        with OrigPaymentEmpLedgEntry do begin
                            SetCurrentkey("Transaction No.");
                            SetRange("Transaction No.", EmpLedgEntry3."Transaction No.");
                            SetRange("Document No.", EmpLedgEntry3."Document No.");
                            SetRange("Posting Date", EmpLedgEntry3."Posting Date");
                            SetRange("Employee No.", GLEntry."Source No.");
                            SetRange("Entry No.", GLEntry."Entry No.");
                            if not FindFirst then
                                exit(false);
                        end;
                    end else
                        exit(false);
                end;
        end;
        AppliesID := PostedPaymentHeaderEntry."No.";
        if PostedPaymentHeaderEntry."Document Type" = 0 then begin
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
            case PostedPaymentHeaderEntry."Document Type" of
                PostedPaymentHeaderEntry."document type"::"Payment Voucher":
                    GenJnlLine3.Description := StrSubstNo(Text006, PostedPaymentHeaderEntry."No.");
                PostedPaymentHeaderEntry."document type"::"Cash Advance":
                    GenJnlLine3.Description := StrSubstNo(Text008, PostedPaymentHeaderEntry."No.");
            end;
            GenJnlLine3."Shortcut Dimension 1 Code" := OrigPaymentEmpLedgEntry."Global Dimension 1 Code";
            GenJnlLine3."Shortcut Dimension 2 Code" := OrigPaymentEmpLedgEntry."Global Dimension 2 Code";
            GenJnlLine3."Dimension Set ID" := OrigPaymentEmpLedgEntry."Dimension Set ID";
            GenJnlLine3."Posting Group" := OrigPaymentEmpLedgEntry."Employee Posting Group";
            GenJnlLine3."Source Type" := GenJnlLine3."source type"::Employee;
            GenJnlLine3."Source No." := OrigPaymentEmpLedgEntry."Employee No.";
            GenJnlLine3."Source Code" := SourceCodeSetup."Financially Voided Check";
            GenJnlLine3."Source Currency Code" := OrigPaymentEmpLedgEntry."Currency Code";
            GenJnlLine3."System-Created Entry" := true;
            GenJnlPostLine.UnapplyEmplLedgEntry(GenJnlLine3, PaymentDetEmpLedgEntry);
        end;
        with OrigPaymentEmpLedgEntry do begin
            FindSet(true, false);  // re-get the now-modified payment entry.
            repeat                // set up to be applied by upcoming voiding entry.
                MakeAppliesID(AppliesID, PostedPaymentHeaderEntry."No.");
                "Applies-to ID" := AppliesID;
                CalcFields("Remaining Amount");
                "Amount to Apply" := "Remaining Amount";
                Modify;
            until Next = 0;
        end;
        exit(true);
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


    procedure GetTransactionDetails()
    begin
    end;

    local procedure CopyCommentLines(FromDocumentType: Integer; ToDocumentType: Integer; FromNumber: Code[20]; ToNumber: Code[20])
    begin
        PmtCommentLine.SetRange("Table Name", FromDocumentType);
        PmtCommentLine.SetRange("No.", FromNumber);
        if PmtCommentLine.FindSet then
            repeat
                PmtCommentLine2 := PmtCommentLine;
                PmtCommentLine2."Table Name" := ToDocumentType;
                PmtCommentLine2."No." := ToNumber;
                PmtCommentLine2.Insert;
            until PmtCommentLine.Next = 0;
    end;


    procedure CheckCurrCode(CurrencyCode: Code[20])
    begin
        GLSetup.Get;
        GLSetup.TestField("LCY Code");
        if GLSetup."LCY Code" = CurrencyCode then
            Error(CurrCodeErr, CurrencyCode);
    end;


    procedure GetCashAdvtoReverse(PaymentNo: Code[20])
    begin
        if PaymentNo = '' then
            exit;
        CashAdvtoReverse.DeleteAll;
        CashAdvance.Reset;
        CashAdvance.SetRange("Voucher No.", PaymentNo);
        if CashAdvance.Find('-') then
            repeat
                CashAdvtoReverse := CashAdvance;
                CashAdvtoReverse.Insert;
            until CashAdvance.Next = 0;
    end;
}

