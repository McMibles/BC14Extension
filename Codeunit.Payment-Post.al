Codeunit 52092222 "Payment - Post"
{
    Permissions = TableData "Cust. Ledger Entry" = rimd,
                  TableData "Vendor Ledger Entry" = rimd,
                  TableData "Bank Account Ledger Entry" = rimd,
                  TableData "Check Ledger Entry" = rimd,
                  TableData "FA Ledger Entry" = rimd;
    TableNo = "Payment Header";

    trigger OnRun()
    var
        PaymentLine: Record "Payment Line";
        PaymentHeader2: Record "Payment Header";
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        if PostingDateExists and (ReplacePostingDate or ("Payment Date" = 0D)) then begin
            "Payment Date" := PostingDate;
            Validate("Currency Code");
        end;

        if PostingDateExists and (ReplaceDocumentDate or ("Document Date" = 0D)) then
            Validate("Document Date", PostingDate);

        ClearAll;
        Clear(GenJnlPostLine);
        Clear(GenJnlLine);
        VoucherNo := '';
        CreateVoucher := false;

        PaymentHeader := Rec;
        GLSetup.Get;
        SourceCodeSetup.Get;
        with PaymentHeader do begin
            Window.Open(Text003);
            TestField("Payment Date");
            TestField("Document Date");
            TestField("Posting Description");
            if "Document Type" = "document type"::"Payment Voucher" then
                if ("Payment Method" = "payment method"::Cheque) or ("Check Entry No." <> 0) then
                    Error(Text002);

            if GenJnlCheckLine.DateNotAllowed("Payment Date") then
                FieldError("Payment Date", Text045);

            CheckDim;

            case "Document Type" of
                "document type"::"Payment Voucher":
                    PostPaymentVoucher(false, PaymentHeader."No.", PaymentHeader."Payment Date");
                "document type"::"Cash Advance":
                    PostCashAdvance(false, PaymentHeader."No.", PaymentHeader."Payment Date");
                "document type"::Retirement:
                    PostRetirement;
            end;

            //Create Payment Voucher
            if ("Document Type" = "document type"::"Cash Advance") and ("Create Voucher") then
                CreateCashAdvanceVoucher(PaymentHeader, PaymentHeader2);

            if ("Document Type" = "document type"::"Payment Voucher") and ("Create Voucher") then
                CreateFloatReimbVoucher(PaymentHeader, PaymentHeader2);

            //Move Entry to Posted Payment Transaction
            PostedPaymentHeader.TransferFields(PaymentHeader);
            PostedPaymentHeader."Entry Status" := PostedPaymentHeader."entry status"::Posted;
            if "Create Voucher" then
                PostedPaymentHeader."Voucher No." := PaymentHeader2."No.";
            PostedPaymentHeader.Insert;
            RecordLinkManagement.CopyLinks(PaymentHeader, PostedPaymentHeader);

            ApprovalMgt.PostApprovalEntries(RecordId, PostedPaymentHeader.RecordId, PostedPaymentHeader."No.");
            ApprovalMgt.DeleteApprovalEntries(RecordId);

            if PmtMgtSetup."Copy Comments Pmt to Posted" then begin
                case "Document Type" of
                    "document type"::"Payment Voucher":
                        CopyCommentLines(
                          1, 6,
                          "No.", PostedPaymentHeader."No.");

                    "document type"::"Cash Advance":
                        CopyCommentLines(
                          2, 7,
                          "No.", PostedPaymentHeader."No.");
                    "document type"::Retirement:
                        CopyCommentLines(
                          3, 8,
                          "No.", PostedPaymentHeader."No.");
                end;
            end;

            PaymentLine.Reset;
            PaymentLine.SetRange("Document Type", "Document Type");
            PaymentLine.SetRange("Document No.", "No.");
            PaymentLine.FindSet;
            repeat
                PostedPaymentLine.TransferFields(PaymentLine);
                PostedPaymentLine.Insert;
                RecordLinkManagement.CopyLinks(PaymentLine, PostedPaymentLine);
                if PaymentLine.HasLinks then
                    PaymentLine.DeleteLinks;
            until PaymentLine.Next = 0;

            OnBeforeDeletePostedPaymentDocument(Rec, PostedPaymentHeader);

            if HasLinks then
                DeleteLinks;

            CreateVoucher := "Create Voucher";
            VoucherNo := PaymentHeader2."No.";

            Delete;

            PaymentLine.DeleteAll;

            case "Document Type" of
                "document type"::"Payment Voucher":
                    PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Payment Voucher");
                "document type"::"Cash Advance":
                    PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Cash Advance");
                "document type"::Retirement:
                    PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Cash Adv. Retirement");
            end;
            PmtCommentLine.SetRange("No.", "No.");
            if not PmtCommentLine.IsEmpty then
                PmtCommentLine.DeleteAll;

            //Send Payment Advice
            SendEmailAlert(PostedPaymentHeader);

            Window.Close;
            if ShowMessage then begin
                if (PostedPaymentHeader."Document Type" = PostedPaymentHeader."document type"::"Cash Advance")
                  and (CreateVoucher) then
                    Message(Text006, PaymentHeader2."No.")
                else
                    Message(Text004, "No.");
            end;
            if not "Create Voucher" then begin
                Commit;
                UpdateAnalysisView.UpdateAll(0, true);
            end;
        end;
    end;

    var
        Text001: label 'Do you want to post the %1?';
        GLSetup: Record "General Ledger Setup";
        PmtMgtSetup: Record "Payment Mgt. Setup";
        PaymentHeader: Record "Payment Header";
        PostedPaymentHeader: Record "Posted Payment Header";
        PostedPaymentLine: Record "Posted Payment Line";
        CashAdvanceHeader: Record "Payment Header";
        CashAdvanceLine: Record "Payment Line";
        PayableSetup: Record "Purchases & Payables Setup";
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        Customer: Record Customer;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAccount: Record "Bank Account";
        PmtCommentLine: Record "Payment Comment Line";
        PmtCommentLine2: Record "Payment Comment Line Archive";
        CommitmentEntry: Record "Commitment Entry";
        Usersetup: Record "User Setup";
        EmployeePostingGrp: Record "Employee Posting Group";
        PayrollSetup: Record "Payroll-Setup";
        Employee: Record Employee;
        Vendor: Record Vendor;
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        FileNameServer: Text;
        Subject: Text;
        Body: Text;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        CheckManagement: Codeunit CheckManagement;
        BudgetControlMgt: Codeunit "Budget Control Management";
        FileManagement: Codeunit "File Management";
        SMTP: Codeunit "SMTP Mail";
        WHTMgt: Codeunit "WHT Management";
        RecordLinkManagement: Codeunit "Record Link Management";
        PostingDate: Date;
        LineCounter: Integer;
        Window: Dialog;
        PostingDateExists: Boolean;
        ReplacePostingDate: Boolean;
        ReplaceDocumentDate: Boolean;
        Text002: label 'This payment must be posted through cheque posting';
        Text003: label 'Checking Header\Checking Line #1#############\Posting Line #2##########\Posting #3##################';
        Text004: label '%1 successfully posted';
        Text005: label 'Nothing to post';
        Text006: label 'Cash Advance successfully posted and Payment Voucher No. % 1 created ';
        Text007: label 'This voucher must be applied to an invoice';
        Text013: label 'No voucher document is attached to this check payment!\\Nothing to Post';
        Text014: label 'Cheque Amount does not correspond to the attached vouchers.';
        Text045: label 'is not within your range of allowed posting dates.';
        Text046: label 'Checking Check Register\Checking Line #1#############\Posting Line #2##########\Posting #3##################';
        Text101: label 'PAYMENT ADVICE';
        Text102: label 'Find Attached Payment to %1.';
        ShowMessage: Boolean;
        CreateVoucher: Boolean;
        VoucherNo: Code[20];


    procedure PostPaymentVoucher(CalledFromCheckPayment: Boolean; DocNo: Code[20]; PaymentDate: Date)
    var
        PaymentLine: Record "Payment Line";
        UpdateCashAdvance: Record "Posted Payment Header";
    begin
        GLSetup.Get;
        with PaymentHeader do begin
            TestField("Payment Source");
            CalcFields(Amount, "Amount (LCY)", "WHT Amount", "WHT Amount (LCY)");
            PaymentLine.SetRange("Document Type", "Document Type");
            PaymentLine.SetRange("Document No.", "No.");
            PaymentLine.FindSet;
            repeat
                //Check the lines
                Window.Update(1, PaymentLine."Line No.");
                PaymentLine.TestField(Amount);
                PaymentLine.TestField("Amount (LCY)");
                PaymentLine.TestField("Account No.");
                case "Payment Type" of
                    "payment type"::"Supp. Invoice":
                        begin
                            if not (PaymentLine."WHT Line") then begin
                                PaymentLine.TestField("Account Type", PaymentLine."account type"::Vendor);
                                if (PaymentLine."Applies-to ID" = '') and (PaymentLine."Applies-to Doc. No." = '') then
                                    Error(Text007);
                            end;
                        end;
                end;

                // Post lines
                Window.Update(2, PaymentLine."Line No.");
                GenJnlLine.Init;
                GenJnlLine."Posting Date" := PaymentDate;
                GenJnlLine."Document Date" := PaymentDate;
                GenJnlLine.Description := PaymentLine.Description;
                GenJnlLine."Document No." := DocNo;
                GenJnlLine."External Document No." := PaymentHeader."External Document No.";
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine."Account Type" := PaymentLine."Account Type";
                GenJnlLine."Account No." := PaymentLine."Account No.";
                GenJnlLine.Validate("Job No.", PaymentLine."Job No.");
                GenJnlLine.Validate("Job Task No.", PaymentLine."Job Task No.");
                GenJnlLine."Loan ID" := PaymentLine."Loan ID";
                GenJnlLine."Document Type" := 0;
                GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                GenJnlLine.Amount := (PaymentLine.Amount + PaymentLine."Interest Amount");
                GenJnlLine."Source Currency Code" := PaymentHeader."Currency Code";
                GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                GenJnlLine."Amount (LCY)" := (PaymentLine."Amount (LCY)" + PaymentLine."Interest Amount (LCY)");
                if GenJnlLine."Job No." <> '' then
                    GenJnlLine.Validate("Job Quantity", 1);
                case PaymentLine."FA Posting Type" of
                    0, 1:
                        GenJnlLine."FA Posting Type" := PaymentLine."FA Posting Type";
                    else
                        GenJnlLine."FA Posting Type" := GenJnlLine."fa posting type"::Maintenance;
                end;
                GenJnlLine."Depreciation Book Code" := PaymentLine."Depreciation Book Code";
                GenJnlLine."Maintenance Code" := PaymentLine."Maintenance Code";
                GenJnlLine."Consignment Code" := PaymentLine."Consignment Code";
                GenJnlLine."Consignment Charge Code" := PaymentLine."Consignment Charge Code";
                GenJnlLine."Order No." := PaymentLine."Consignment PO No.";
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentLine."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Shortcut Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := PaymentLine."Dimension Set ID";
                if PaymentHeader."Currency Code" = '' then
                    GenJnlLine."Currency Factor" := 1
                else
                    GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
                GenJnlLine."Source Code" := SourceCodeSetup.Payments;
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                GenJnlLine."Applies-to Doc. Type" := PaymentLine."Applies-to Doc. Type";
                GenJnlLine."Applies-to Doc. No." := PaymentLine."Applies-to Doc. No.";
                GenJnlLine."Applies-to ID" := PaymentLine."Applies-to ID";
                GenJnlLine."WHT Amount" := -1 * PaymentLine."WHT Amount";
                GenJnlLine."WHT Posting Group" := PaymentLine."WHT Posting Group";
                GenJnlLine."WHT Base Amount" := -1 * PaymentLine.Amount;
                GenJnlLine."Source Curr. WHT Base Amount" := -1 * PaymentLine.Amount;
                GenJnlLine."Source Curr. WHT Amount" := -1 * PaymentLine.Amount;
                GenJnlLine."VAT %" := 0;
                GenJnlLine.UpdateSource;

                case "Payment Type" of
                    "payment type"::"Cash Advance":
                        GenJnlLine."Entry Type" := 2;
                    "payment type"::Retirement:
                        GenJnlLine."Entry Type" := 4;
                end;

                if PaymentLine."Account Type" = PaymentLine."account type"::"IC Partner" then
                    ProcessICLines(PaymentLine, GenJnlLine);

                GenJnlPostLine.RunWithCheck(GenJnlLine);

                //Post interest
                if PaymentLine."Interest Amount" <> 0 then begin
                    PaymentLine.TestField("Account Type", PaymentLine."account type"::Customer);
                    PaymentLine.TestField("Loan ID");
                    PostInterest(PaymentLine);
                end;

                //Update Loan
                if PaymentLine."Loan ID" <> '' then
                    UpdateLoan(PaymentHeader, PaymentLine);

                if (PaymentLine."Account Type" = PaymentLine."account type"::"G/L Account") and
                   (PmtMgtSetup."Budget Expense Control Enabled") then
                    BudgetControlMgt.DeleteCommitment(PaymentLine."Document No.", PaymentLine."Line No.", PaymentLine."Account No.");

                if (PaymentLine."Account Type" = PaymentLine."account type"::"G/L Account")
                  and (PaymentLine."WHT Amount" <> 0) then
                    WHTMgt.GetGLAccountWHTAmount(PaymentLine);

            until PaymentLine.Next = 0;

            if not (CalledFromCheckPayment) then begin
                //Post Cash/Bank
                Window.Update(3, "Payment Source");
                GenJnlLine.Init;
                GenJnlLine."Posting Date" := PaymentDate;
                GenJnlLine."Document Date" := PaymentDate;
                GenJnlLine.Description := "Posting Description";
                GenJnlLine."Document No." := DocNo;
                GenJnlLine."External Document No." := "External Document No.";
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := "Dimension Set ID";
                GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
                GenJnlLine."Account No." := "Payment Source";
                GenJnlLine."Document Type" := 0;
                GenJnlLine."Currency Code" := "Currency Code";
                GenJnlLine.Amount := -1 * (Amount - "WHT Amount");
                GenJnlLine."Source Currency Code" := "Currency Code";
                GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                GenJnlLine."Amount (LCY)" := -1 * ("Amount (LCY)" - "WHT Amount (LCY)");
                GenJnlLine."Source Code" := SourceCodeSetup.Payments;
                if "Currency Code" = '' then
                    GenJnlLine."Currency Factor" := 1
                else
                    GenJnlLine."Currency Factor" := "Currency Factor";
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                GenJnlLine."Applies-to Doc. Type" := 0;
                GenJnlLine."Applies-to Doc. No." := '';
                GenJnlLine."Applies-to ID" := '';
                GenJnlLine.Validate("VAT %", 0);

                GenJnlLine.UpdateSource;
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;

            PostWithHoldingTax(PaymentHeader, DocNo, PaymentDate);

            case "Payment Type" of
                "payment type"::"Cash Advance":
                    begin
                        UpdateCashAdvance.SetRange("Voucher No.", PaymentHeader."No.");
                        UpdateCashAdvance.Find('-');
                        repeat
                            UpdateCashAdvance."Due Date" := CalcDate("Due Date Calc. Period", PaymentHeader."Payment Date");
                            UpdateCashAdvance.Modify;
                        until UpdateCashAdvance.Next = 0;
                    end;
            end;
            UpdateSourceType(PaymentHeader);


        end;
    end;


    procedure PostCashAdvance(CalledFromCheckPayment: Boolean; DocNo: Code[20]; PaymentDate: Date)
    var
        PaymentLine: Record "Payment Line";
    begin
        with PaymentHeader do begin
            GLSetup.Get;
            if "Employee Posting Group" = '' then begin
                Employee.Get("Payee No.");
                "Employee Posting Group" := Employee."Employee Posting Group";
                "Bal. Account Type" := "bal. account type"::Employee;
                "Bal. Account No." := Employee."No.";
            end;

            TestField("Employee Posting Group");
            TestField("Retirement No.", '');
            TestField("Bal. Account Type", PaymentHeader."bal. account type"::Employee);
            TestField("Bal. Account No.");
            EmployeePostingGrp.Get("Employee Posting Group");
            EmployeePostingGrp.TestField("Cash Adv. Receivable Acc.");
            CalcFields(Amount, "Amount (LCY)");

            if "Amount (LCY)" = 0 then
                Error(Text005);

            // Post Employee (Employee Cash Advance Acct)
            Window.Update(2, 10000);
            GenJnlLine.Init;
            GenJnlLine."Posting Date" := PaymentDate;
            GenJnlLine."Document Date" := PaymentDate;
            GenJnlLine.Description := "Posting Description";
            GenJnlLine."Document No." := DocNo;
            GenJnlLine."External Document No." := "External Document No.";
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := "Dimension Set ID";
            GenJnlLine."Account Type" := GenJnlLine."account type"::Employee;
            GenJnlLine."Account No." := PaymentHeader."Bal. Account No.";
            GenJnlLine."Source Type" := GenJnlLine."source type"::Employee;
            GenJnlLine."Source No." := PaymentHeader."Bal. Account No.";
            GenJnlLine."Document Type" := 0;
            GenJnlLine."Currency Code" := "Currency Code";
            GenJnlLine.Amount := -Amount;
            GenJnlLine."Source Currency Code" := "Currency Code";
            GenJnlLine."Source Currency Amount" := -Amount;
            GenJnlLine."Amount (LCY)" := -"Amount (LCY)";
            GenJnlLine."Cash Advance Doc. No." := "No.";
            GenJnlLine."Entry Type" := 1;
            GenJnlLine."Source Code" := SourceCodeSetup.Payments;
            if "Currency Code" = '' then
                GenJnlLine."Currency Factor" := 1
            else
                GenJnlLine."Currency Factor" := "Currency Factor";
            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."VAT Prod. Posting Group" := '';
            GenJnlLine."Bal. VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Prod. Posting Group" := '';
            GenJnlLine."Applies-to Doc. Type" := 0;
            GenJnlLine."Applies-to Doc. No." := '';
            GenJnlLine."Applies-to ID" := '';
            GenJnlLine.Validate("VAT %", 0);
            GenJnlPostLine.RunWithCheck(GenJnlLine);

            //Post Cash Adv. Receivable
            GenJnlLine.Init;
            GenJnlLine."Posting Date" := "Payment Date";
            GenJnlLine."Document Date" := "Document Date";
            GenJnlLine.Description := "Posting Description";
            GenJnlLine."Document No." := "No.";
            GenJnlLine."External Document No." := "External Document No.";
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := "Dimension Set ID";
            GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
            GenJnlLine."Account No." := EmployeePostingGrp."Cash Adv. Receivable Acc.";
            GenJnlLine."Document Type" := 0;
            GenJnlLine."Currency Code" := "Currency Code";
            GenJnlLine.Amount := Amount;
            GenJnlLine."Source Currency Code" := "Currency Code";
            GenJnlLine."Source Currency Amount" := Amount;
            GenJnlLine."Amount (LCY)" := "Amount (LCY)";
            GenJnlLine."Source Code" := SourceCodeSetup.Payments;
            if "Currency Code" = '' then
                GenJnlLine."Currency Factor" := 1
            else
                GenJnlLine."Currency Factor" := "Currency Factor";
            GenJnlLine."Cash Advance Doc. No." := '';
            GenJnlLine."Entry Type" := 0;
            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."VAT Prod. Posting Group" := '';
            GenJnlLine."Bal. VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Prod. Posting Group" := '';
            GenJnlLine."Applies-to Doc. Type" := 0;
            GenJnlLine."Applies-to Doc. No." := '';
            GenJnlLine."Applies-to ID" := '';
            GenJnlLine.Validate("VAT %", 0);
            GenJnlPostLine.RunWithCheck(GenJnlLine);

            //Delete Commitment
            //CommitmentEntry.SETRANGE("Document No.",PaymentHeader."No.");
            //CommitmentEntry.DELETEALL;

        end;
    end;


    procedure PostRetirement()
    var
        PaymentLine: Record "Payment Line";
        CashAdvance: Record "Posted Payment Header";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        AdvanceAmount: Decimal;
        ActualAmount: Decimal;
        AdvanceAmountLCY: Decimal;
        ActualAmountLCY: Decimal;
        RetiredAmount: Decimal;
        RetiredAmountLCY: Decimal;
        TotalAmountLCY: Decimal;
        ClaimAmountLCY: Decimal;
    begin
        with PaymentHeader do begin
            TestField("Bal. Account Type", PaymentHeader."bal. account type"::Employee);
            TestField("Bal. Account No.");
            TotalAmountLCY := 0;
            CalcFields(Amount, "Amount (LCY)", "Retirement Amount", "Retirement Amount (LCY)");

            PaymentLine.SetRange("Document Type", "Document Type");
            PaymentLine.SetRange("Document No.", "No.");
            PaymentLine.SetFilter(Amount, '<>%1', 0);
            if PaymentLine.FindSet then
                repeat
                    //Check the lines
                    Window.Update(1, PaymentLine."Line No.");
                    if PaymentLine."WHT%" <> 0 then
                        PaymentLine.TestField("WHT Amount");
                    PaymentLine.TestField("Account No.");

                    // Post lines to recognise expenses
                    Window.Update(2, PaymentLine."Line No.");
                    GenJnlLine.Init;
                    GenJnlLine."Posting Date" := PaymentHeader."Payment Date";
                    GenJnlLine."Document Date" := PaymentHeader."Document Date";
                    GenJnlLine.Description := PaymentLine.Description;
                    GenJnlLine."Document No." := PaymentHeader."No.";
                    GenJnlLine."External Document No." := PaymentHeader."External Document No.";
                    GenJnlLine."System-Created Entry" := true;
                    GenJnlLine."Account Type" := PaymentLine."Account Type";
                    GenJnlLine."Account No." := PaymentLine."Account No.";
                    GenJnlLine.Validate("Job No.", PaymentLine."Job No.");
                    GenJnlLine.Validate("Job Task No.", PaymentLine."Job Task No.");
                    GenJnlLine."Loan ID" := PaymentLine."Loan ID";
                    GenJnlLine."Document Type" := 0;
                    GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                    GenJnlLine.Amount := (PaymentLine.Amount + PaymentLine."Interest Amount");
                    GenJnlLine."Source Currency Code" := PaymentHeader."Currency Code";
                    GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                    GenJnlLine."Amount (LCY)" := (PaymentLine."Amount (LCY)" + PaymentLine."Interest Amount (LCY)");
                    if GenJnlLine."Job No." <> '' then
                        GenJnlLine.Validate("Job Quantity", 1);
                    TotalAmountLCY += GenJnlLine."Amount (LCY)";
                    case PaymentLine."FA Posting Type" of
                        0, 1:
                            GenJnlLine."FA Posting Type" := PaymentLine."FA Posting Type";
                        else
                            GenJnlLine."FA Posting Type" := GenJnlLine."fa posting type"::Maintenance;
                    end;
                    GenJnlLine."Shortcut Dimension 1 Code" := PaymentLine."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := PaymentLine."Shortcut Dimension 2 Code";
                    GenJnlLine."Dimension Set ID" := PaymentLine."Dimension Set ID";
                    GenJnlLine."Depreciation Book Code" := PaymentLine."Depreciation Book Code";
                    GenJnlLine."Maintenance Code" := PaymentLine."Maintenance Code";
                    GenJnlLine."Source Code" := SourceCodeSetup.Payments;
                    GenJnlLine."Consignment Code" := PaymentLine."Consignment Code";
                    GenJnlLine."Consignment Charge Code" := PaymentLine."Consignment Charge Code";
                    GenJnlLine."Order No." := PaymentLine."Consignment PO No.";

                    if PaymentHeader."Currency Code" = '' then
                        GenJnlLine."Currency Factor" := 1
                    else
                        GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                    GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                    GenJnlLine."Applies-to Doc. Type" := 0;
                    GenJnlLine."Applies-to Doc. No." := '';
                    GenJnlLine."Applies-to ID" := '';
                    GenJnlLine."VAT %" := 0;
                    GenJnlLine.UpdateSource;

                    if PaymentLine."Account Type" = PaymentLine."account type"::"IC Partner" then
                        ProcessICLines(PaymentLine, GenJnlLine);
                    GenJnlPostLine.RunWithCheck(GenJnlLine);

                    //Post interest
                    if PaymentLine."Interest Amount" <> 0 then begin
                        PaymentLine.TestField("Account Type", PaymentLine."account type"::Customer);
                        PaymentLine.TestField("Loan ID");
                        PostInterest(PaymentLine);
                    end;

                    //Update Loan
                    if PaymentLine."Loan ID" <> '' then
                        UpdateLoan(PaymentHeader, PaymentLine);
                until PaymentLine.Next = 0;
            //Apply retirement to advance
            CashAdvance.SetRange("Retirement No.", "No.");
            CashAdvance.Find('-');
            repeat
                AdvanceAmount := 0;
                ActualAmount := 0;
                AdvanceAmountLCY := 0;
                ActualAmountLCY := 0;
                RetiredAmount := 0;
                RetiredAmountLCY := 0;
                ClaimAmountLCY := 0;
                CashAdvance.GetRetiredAmount(AdvanceAmount, ActualAmount, AdvanceAmountLCY, ActualAmountLCY);
                if AdvanceAmount <= ActualAmount then begin
                    CashAdvance."Retirement Status" := CashAdvance."retirement status"::Retired;
                    RetiredAmount := AdvanceAmount;
                    RetiredAmountLCY := AdvanceAmountLCY;
                    CashAdvance."Retirement Date" := "Payment Date";
                    ClaimAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Payment Date", "Currency Code",
                                        (AdvanceAmount - ActualAmount), "Currency Factor"));

                end else begin
                    CashAdvance."Retirement Status" := CashAdvance."retirement status"::"Partially Retired";
                    RetiredAmount := ActualAmount;
                    if CashAdvance."Currency Code" = '' then
                        RetiredAmountLCY := ActualAmountLCY
                    else
                        RetiredAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(CashAdvance."Document Date", CashAdvance."Currency Code",
                                            ActualAmount, CashAdvance."Currency Factor"));
                end;
                CashAdvance.Modify;

                //Clear Cash Adv. Receivable Account
                EmployeePostingGrp.Get(CashAdvance."Employee Posting Group");
                GenJnlLine.Init;
                GenJnlLine."Posting Date" := "Payment Date";
                GenJnlLine."Document Date" := "Document Date";
                GenJnlLine.Description := "Posting Description";
                GenJnlLine."Document No." := "No.";
                GenJnlLine."External Document No." := "External Document No.";
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := "Dimension Set ID";
                GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                GenJnlLine."Account No." := EmployeePostingGrp."Cash Adv. Receivable Acc.";
                GenJnlLine."Document Type" := 0;
                GenJnlLine."Currency Code" := CashAdvance."Currency Code";
                GenJnlLine.Amount := -1 * RetiredAmount;
                GenJnlLine."Source Currency Code" := CashAdvance."Currency Code";
                GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                GenJnlLine."Amount (LCY)" := -1 * RetiredAmountLCY;
                TotalAmountLCY += GenJnlLine."Amount (LCY)";
                GenJnlLine."Source Code" := SourceCodeSetup.Payments;
                if "Currency Code" = '' then
                    GenJnlLine."Currency Factor" := 1
                else
                    GenJnlLine."Currency Factor" := CashAdvance."Currency Factor";

                GenJnlLine."Cash Advance Doc. No." := '';
                GenJnlLine."Entry Type" := GenJnlLine."entry type"::Retirement;
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                GenJnlLine."Applies-to Doc. Type" := 0;
                GenJnlLine."Applies-to Doc. No." := '';
                GenJnlLine."Applies-to ID" := '';
                GenJnlLine."Allow Application" := true;
                GenJnlLine.Validate("VAT %", 0);
                GenJnlLine.UpdateSource;
                GenJnlPostLine.RunWithCheck(GenJnlLine);

                //Post Difference into Staff Account
                if (AdvanceAmount - ActualAmount < 0) then begin
                    GenJnlLine.Init;
                    GenJnlLine."Posting Date" := "Payment Date";
                    GenJnlLine."Document Date" := "Document Date";
                    GenJnlLine.Description := "Posting Description";
                    GenJnlLine."Document No." := "No.";
                    GenJnlLine."External Document No." := "External Document No.";
                    GenJnlLine."System-Created Entry" := true;
                    GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                    GenJnlLine."Dimension Set ID" := "Dimension Set ID";
                    GenJnlLine."Account Type" := GenJnlLine."account type"::Employee;
                    GenJnlLine."Account No." := PaymentHeader."Bal. Account No.";
                    GenJnlLine."Source Type" := GenJnlLine."source type"::Employee;
                    GenJnlLine."Source No." := PaymentHeader."Bal. Account No.";
                    GenJnlLine."Document Type" := 0;
                    GenJnlLine."Currency Code" := "Currency Code";
                    GenJnlLine.Amount := AdvanceAmount - ActualAmount;
                    GenJnlLine."Source Currency Code" := "Currency Code";
                    GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                    GenJnlLine."Amount (LCY)" := ClaimAmountLCY;
                    TotalAmountLCY += GenJnlLine."Amount (LCY)";
                    GenJnlLine."Source Code" := SourceCodeSetup.Payments;
                    if "Currency Code" = '' then
                        GenJnlLine."Currency Factor" := 1
                    else
                        GenJnlLine."Currency Factor" := "Currency Factor";

                    GenJnlLine."Cash Advance Doc. No." := '';
                    GenJnlLine."Entry Type" := 3;
                    GenJnlLine."VAT Bus. Posting Group" := '';
                    GenJnlLine."VAT Prod. Posting Group" := '';
                    GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                    GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                    GenJnlLine."Applies-to Doc. Type" := 0;
                    GenJnlLine."Applies-to Doc. No." := '';
                    GenJnlLine."Applies-to ID" := '';
                    GenJnlLine."Allow Application" := true;
                    GenJnlLine.Validate("VAT %", 0);
                    GenJnlLine."Cash Advance Doc. No." := CashAdvance."No.";
                    GenJnlLine.UpdateSource;
                    GenJnlPostLine.RunWithCheck(GenJnlLine);
                end;
                CommitmentEntry.SetRange("Document No.", CashAdvance."No.");
                CommitmentEntry.DeleteAll;
            until CashAdvance.Next = 0;
            if TotalAmountLCY <> 0 then begin
                GenJnlLine.Init;
                GenJnlLine."Posting Date" := "Payment Date";
                GenJnlLine."Document Date" := "Document Date";
                GenJnlLine.Description := 'Exchange Rate Difference';
                GenJnlLine."Document No." := "No.";
                GenJnlLine."External Document No." := "External Document No.";
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := "Dimension Set ID";
                Currency.Get("Currency Code");
                GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                if (-1 * TotalAmountLCY) < 0 then begin
                    Currency.TestField(Currency."Realized Gains Acc.");
                    GenJnlLine."Account No." := Currency."Realized Gains Acc.";
                end else begin
                    Currency.TestField(Currency."Realized Losses Acc.");
                    GenJnlLine."Account No." := Currency."Realized Losses Acc.";
                end;
                GenJnlLine."Document Type" := 0;
                GenJnlLine."Currency Code" := '';
                GenJnlLine.Amount := -1 * TotalAmountLCY;
                GenJnlLine."Amount (LCY)" := -1 * TotalAmountLCY;
                GenJnlLine."Source Code" := SourceCodeSetup.Payments;
                GenJnlLine."Currency Factor" := 1;
                GenJnlLine."Cash Advance Doc. No." := '';
                GenJnlLine."Entry Type" := 0;
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                GenJnlLine."Applies-to Doc. Type" := 0;
                GenJnlLine."Applies-to Doc. No." := '';
                GenJnlLine."Applies-to ID" := '';
                GenJnlLine.Validate("VAT %", 0);
                GenJnlLine.UpdateSource;
                GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;

            //Delete Commitment
            CommitmentEntry.SetRange("Document No.", PaymentHeader."No.");
            CommitmentEntry.DeleteAll;
        end;
    end;


    procedure PostCheckPayment(var CheckFile: Record "Cheque File")
    var
        PaymentLine: Record "Payment Line";
        CheckLedgerEntry: Record "Check Ledger Entry";
    begin
        Clear(GenJnlPostLine);
        Clear(GenJnlLine);
        SourceCodeSetup.Get;
        GLSetup.Get;

        Window.Open(Text046);
        //Check The Check File
        CheckFile.CalcFields(CheckFile."Attached Amount", CheckFile."WHT Amount");
        if CheckFile."Attached Amount" = 0 then Error(Text013);
        CheckFile.TestField(CheckFile.Bank);
        CheckFile.TestField(CheckFile."Document No.");
        CheckFile.TestField(CheckFile."Check Posting Date");
        CheckFile.TestField(CheckFile.Amount);
        if CheckFile.Amount <> (CheckFile."Attached Amount" - CheckFile."WHT Amount") then
            Error(Text014);

        if GenJnlCheckLine.DateNotAllowed(CheckFile."Check Posting Date") then
            CheckFile.FieldError("Check Posting Date", Text045);


        PaymentHeader.SetRange("Check Entry No.", CheckFile."Entry No.");
        PaymentHeader.Find('-');
        repeat
            with PaymentHeader do begin
                TestField(Status, Status::Approved);
                CheckDim;

                case PmtMgtSetup."Cheque Posting Type" of
                    PmtMgtSetup."cheque posting type"::"System Generated No.":
                        begin
                            case "Document Type" of
                                "document type"::"Payment Voucher":
                                    PostPaymentVoucher(true, CheckFile."Document No.", CheckFile."Check Posting Date");
                                "document type"::"Cash Advance":
                                    PostCashAdvance(true, CheckFile."Document No.", CheckFile."Check Posting Date");
                            end;
                        end;
                    PmtMgtSetup."cheque posting type"::"Cheque No.":
                        begin
                            case "Document Type" of
                                "document type"::"Payment Voucher":
                                    PostPaymentVoucher(true, CheckFile."Check No.", CheckFile."Check Posting Date");
                                "document type"::"Cash Advance":
                                    PostCashAdvance(true, CheckFile."Check No.", CheckFile."Check Posting Date");
                            end;
                        end;
                end;

                //Move Entry to Posted Payment Transaction
                PostedPaymentHeader.TransferFields(PaymentHeader);
                PostedPaymentHeader."Entry Status" := PostedPaymentHeader."entry status"::Posted;
                PostedPaymentHeader.Insert;
                PostedPaymentHeader.CopyLinks(PaymentHeader);
                ApprovalMgt.PostApprovalEntries(RecordId, PostedPaymentHeader.RecordId, PostedPaymentHeader."No.");
                ApprovalMgt.DeleteApprovalEntries(RecordId);

                if PmtMgtSetup."Copy Comments Pmt to Posted" then begin
                    case "Document Type" of
                        "document type"::"Payment Voucher":
                            CopyCommentLines(
                              1, 6,
                              "No.", PostedPaymentHeader."No.");

                        "document type"::"Cash Advance":
                            CopyCommentLines(
                              2, 7,
                              "No.", PostedPaymentHeader."No.");
                    end;
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
                if HasLinks then
                    DeleteLinks;
                Delete;
                PaymentLine.DeleteAll;

                case "Document Type" of
                    "document type"::"Payment Voucher":
                        PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Payment Voucher");
                    "document type"::"Cash Advance":
                        PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Cash Advance");
                end;
                PmtCommentLine.SetRange("No.", "No.");
                if not PmtCommentLine.IsEmpty then
                    PmtCommentLine.DeleteAll;
                if HasLinks then
                    DeleteLinks;

            end;
        until PaymentHeader.Next = 0;

        //Post Check Bank
        with CheckFile do begin
            CheckFile.CalcFields("LedgerEntry Exist");
            if not (CheckFile."LedgerEntry Exist") then begin
                CheckLedgerEntry.Init;
                CheckLedgerEntry."Bank Account No." := CheckFile.Bank;
                CheckLedgerEntry."Posting Date" := CheckFile."Check Posting Date";
                CheckLedgerEntry."Document Type" := 0;
                CheckLedgerEntry."Document No." := CheckFile."Document No.";
                CheckLedgerEntry.Description := CheckFile.Description;
                CheckLedgerEntry.Amount := CheckFile.Amount;
                CheckLedgerEntry."Check No." := CheckFile."Check No.";
                CheckLedgerEntry."Bank Payment Type" := CheckLedgerEntry."bank payment type"::"Computer Check";
                CheckLedgerEntry."Entry Status" := CheckLedgerEntry."entry status"::Printed;
                CheckLedgerEntry."Check Entry No." := CheckFile."Entry No.";
                CheckLedgerEntry.Payee := CheckFile.Payee;
                CheckLedgerEntry."Check Date" := CheckFile."Creation Date";
                CheckManagement.InsertCheck(CheckLedgerEntry, CheckFile.RecordId);
            end;

            GenJnlLine.Init;
            GenJnlLine."Posting Date" := CheckFile."Check Posting Date";
            GenJnlLine."Document Date" := CheckFile."Check Posting Date";
            GenJnlLine."Account Type" := GenJnlLine."account type"::"Bank Account";
            GenJnlLine."Account No." := CheckFile.Bank;
            BankAccount.Get(GenJnlLine."Account No.");
            BankAccount.TestField(Blocked, false);
            GenJnlLine.Description := CheckFile.Description;
            GenJnlLine."Document No." := CheckFile."Document No.";
            GenJnlLine."Document Type" := 0;
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine.Validate("VAT %", 0);
            GenJnlLine."Currency Code" := CheckFile."Currency Code";
            GenJnlLine.Amount := -CheckFile.Amount;
            GenJnlLine."Amount (LCY)" := -CheckFile."Amount (LCY)";
            GenJnlLine."Source Currency Code" := CheckFile."Currency Code";
            GenJnlLine."Source Currency Amount" := -CheckFile.Amount;
            GenJnlLine."Bank Payment Type" := GenJnlLine."bank payment type"::"Computer Check";
            GenJnlLine."Check Printed" := true;
            GenJnlLine."Source Code" := SourceCodeSetup.Payments;
            GenJnlLine."Shortcut Dimension 1 Code" := CheckFile."Shortcut Dimension 1 Code";
            GenJnlLine."Shortcut Dimension 2 Code" := CheckFile."Shortcut Dimension 2 Code";
            GenJnlLine."Dimension Set ID" := CheckFile."Dimension Set ID";
            GenJnlLine."Bal. Account No." := '';
            GenJnlLine."Gen. Bus. Posting Group" := '';
            GenJnlLine."Gen. Prod. Posting Group" := '';
            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."VAT Prod. Posting Group" := '';
            GenJnlLine."Gen. Posting Type" := 0;
            GenJnlLine.UpdateSource;
            GenJnlPostLine.RunWithCheck(GenJnlLine);

            ApprovalMgt.PostApprovalEntries(RecordId, CheckLedgerEntry.RecordId, CheckLedgerEntry."Document No.");
            ApprovalMgt.DeleteApprovalEntries(RecordId);

            Delete;

            Window.Close;
        end
    end;


    procedure PostInterest(PaymentLine: Record "Payment Line")
    var
        PaymentHeader2: Record "Payment Header";
        ProllLoan: Record "Payroll-Loan";
    begin
        with PaymentLine do begin
            PaymentHeader2.Get("Document Type", "Document No.");
            ProllLoan.Get("Loan ID");
            ProllLoan.TestField("Interest Amount");
            ProllLoan.TestField("Interest Account No.");
            GenJnlLine.Init;
            GenJnlLine."Posting Date" := PaymentHeader2."Payment Date";
            GenJnlLine."Document No." := PaymentHeader2."No.";
            GenJnlLine.Description := 'Loan Interest';
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Document Type" := 0;
            GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
            case ProllLoan."Interest Calculation Method" of
                ProllLoan."interest calculation method"::Straight:
                    GenJnlLine."Account No." := ProllLoan."Interest Account No.";
                ProllLoan."interest calculation method"::"Straight with Ammortization":
                    GenJnlLine."Account No." := ProllLoan."Deferred Interest Account";
            end;
            GenJnlLine.Amount := "Interest Amount" * (-1);
            GenJnlLine."Currency Code" := PaymentHeader2."Currency Code";
            GenJnlLine."Currency Factor" := PaymentHeader2."Currency Factor";
            GenJnlLine."Source Currency Code" := PaymentHeader2."Currency Code";
            GenJnlLine."Source Currency Amount" := "Interest Amount" * (-1);
            GenJnlLine."Amount (LCY)" := "Interest Amount (LCY)" * (-1);
            GenJnlLine."Source Code" := SourceCodeSetup.Payments;
            GenJnlLine."VAT %" := 0;
            GenJnlLine."Gen. Bus. Posting Group" := '';
            GenJnlLine."Gen. Prod. Posting Group" := '';
            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."VAT Prod. Posting Group" := '';
            GenJnlLine."Bal. VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Prod. Posting Group" := '';
            GenJnlLine."Applies-to Doc. Type" := 0;
            GenJnlLine."Applies-to Doc. No." := '';
            GenJnlLine."Applies-to ID" := '';
            GenJnlLine.UpdateSource;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;


    procedure UpdateLoan(var PaymentHeader2: Record "Payment Header"; var PaymentLine2: Record "Payment Line")
    var
        ProllLoan: Record "Payroll-Loan";
        LoanEntry: Record "Payroll-Loan Entry";
        ProllED: Record "Payroll-E/D";
    begin
        PayrollSetup.Get;
        if (PaymentLine2."Loan ID" <> '') and (PaymentLine2.Amount > 0) then begin
            ProllLoan.Get(PaymentLine2."Loan ID");
            ProllLoan.TestField(ProllLoan."Loan Amount");
            ProllLoan.TestField(ProllLoan."Loan E/D");
            ProllED.Get(ProllLoan."Loan E/D");
            if ProllLoan."Voucher No." = '' then begin
                ProllLoan."Voucher No." := PaymentLine2."Document No.";
            end;
            ProllLoan."Open(Y/N)" := true;
            ProllLoan.Posted := true;
            ProllLoan."Posting Date for Loan" := PaymentHeader."Payment Date";
            if Format(ProllED."Loan Deduction Starting Period") <> '' then
                ProllLoan."Deduction Starting Date" := CalcDate(ProllED."Loan Deduction Starting Period", PaymentHeader."Payment Date")
            else begin
                if Format(PayrollSetup."Loan Deduction Starting Period") <> '' then
                    ProllLoan."Deduction Starting Date" := CalcDate(PayrollSetup."Loan Deduction Starting Period", PaymentHeader."Payment Date")
                else
                    ProllLoan."Deduction Starting Date" := PaymentHeader."Payment Date";
            end;
            ProllLoan.Modify;
        end;
    end;


    procedure SetPostingDate(NewReplacePostingDate: Boolean; NewReplaceDocumentDate: Boolean; NewPostingDate: Date)
    begin
        PostingDateExists := true;
        ReplacePostingDate := NewReplacePostingDate;
        ReplaceDocumentDate := NewReplaceDocumentDate;
        PostingDate := NewPostingDate;
    end;

    local procedure CopyCommentLines(FromDocumentType: Option "Payment Request","Payment Voucher","Cash Advance","Cash Adv. Retirement","Cash Receipt","Archived Payment Request","Posted Payment Voucher","Posted Cash Advance","Posted Retirement","Posted Cash Receipt"; ToDocumentType: Option "Payment Request","Payment Voucher","Cash Advance","Cash Adv. Retirement","Cash Receipt","Archived Payment Request","Posted Payment Voucher","Posted Cash Advance","Posted Retirement","Posted Cash Receipt"; FromNumber: Code[20]; ToNumber: Code[20])
    begin
        PmtCommentLine.SetRange("Table Name", FromDocumentType);
        PmtCommentLine.SetRange("No.", FromNumber);
        if PmtCommentLine.FindSet then
            repeat
                PmtCommentLine2.TransferFields(PmtCommentLine);
                PmtCommentLine2."Table Name" := ToDocumentType;
                PmtCommentLine2."No." := ToNumber;
                PmtCommentLine2.Insert;
            until PmtCommentLine.Next = 0;
    end;


    procedure SendEmailAlert(var PostedPmtHeader: Record "Posted Payment Header")
    var
        Vendor: Record Vendor;
        PurchaserCode: Record "Salesperson/Purchaser";
        PostedPaymentHeader2: Record "Posted Payment Header";
        VendPmtAdviceReport: Report "Vendor Payment Advice";
        FileNameServer: Text;
    begin
        PmtMgtSetup.Get;
        if not PmtMgtSetup."Send Vendor Payment Advice" then
            exit;

        if not Vendor.Get(PostedPmtHeader."Payee No.") then
            exit;
        if Vendor."Purchaser Code" = '' then // To allow process in production while updating of the vendor card is ongoing
            exit;

        Vendor.TestField("Purchaser Code");
        PurchaserCode.Get(Vendor."Purchaser Code");
        PurchaserCode.TestField("E-Mail");
        Clear(VendPmtAdviceReport);
        Usersetup.Get(UpperCase(UserId));
        Subject := Text101;
        Body := StrSubstNo(Text102, Vendor.Name);
        Usersetup.TestField("E-Mail");
        PostedPaymentHeader2 := PostedPmtHeader;
        PostedPaymentHeader2.SetRecfilter;
        FileNameServer := FileManagement.ServerTempFileName('pdf');
        VendPmtAdviceReport.SetTableview(PostedPaymentHeader2);
        VendPmtAdviceReport.SaveAsPdf(FileNameServer);
        SMTP.CreateMessage(COMPANYNAME, Usersetup."E-Mail", Vendor."E-Mail", Subject, Body, true);
        SMTP.AddAttachment('Payment Advice', FileNameServer);
        SMTP.Send;
        if Erase(FileNameServer) then;

        Clear(VendPmtAdviceReport);
    end;


    procedure SetShowMessage(ShowMessage2: Boolean)
    begin
        ShowMessage := ShowMessage2;
    end;


    procedure GetVoucherNo(): Code[20]
    begin
        exit(VoucherNo);
    end;


    procedure PostWithHoldingTax(PaymentHeader: Record "Payment Header"; DocNo: Code[20]; PaymentDate: Date)
    var
        WHTEntry: Record "WHT Entry";
        WHTPostingGrp: Record "WHT Posting Group";
    begin
        WHTEntry.SetRange("Document No.", PaymentHeader."No.");
        if WHTEntry.FindSet then
            repeat
                WHTPostingGrp.Get(WHTEntry."WHT Posting Group");
                LineCounter := LineCounter + 1;
                GenJnlLine.Init;
                GenJnlLine."Posting Date" := PaymentDate;
                GenJnlLine."Document No." := DocNo;
                GenJnlLine.Description := PaymentHeader."Posting Description";
                GenJnlLine."System-Created Entry" := true;
                GenJnlLine."Document Type" := 0;
                GenJnlLine."Account Type" := GenJnlLine."account type"::Vendor;
                GenJnlLine."Account No." := WHTPostingGrp."Purchase WHT Tax Account";
                GenJnlLine.Amount := WHTEntry."WHT Payment Amount";
                GenJnlLine."Currency Code" := PaymentHeader."Currency Code";
                GenJnlLine."Currency Factor" := PaymentHeader."Currency Factor";
                GenJnlLine."Source Currency Code" := PaymentHeader."Currency Code";
                GenJnlLine."Source Currency Amount" := WHTEntry."WHT Payment Amount";
                GenJnlLine."Amount (LCY)" := WHTEntry."WHT Pmt. Amount(LCY)";
                GenJnlLine."Source Code" := SourceCodeSetup.Payments;
                GenJnlLine."VAT %" := 0;
                GenJnlLine."Gen. Bus. Posting Group" := '';
                GenJnlLine."Gen. Prod. Posting Group" := '';
                GenJnlLine."VAT Bus. Posting Group" := '';
                GenJnlLine."VAT Prod. Posting Group" := '';
                GenJnlLine."Bal. VAT Bus. Posting Group" := '';
                GenJnlLine."Bal. VAT Prod. Posting Group" := '';
                GenJnlLine."Applies-to Doc. Type" := 0;
                GenJnlLine."Applies-to Doc. No." := '';
                GenJnlLine."Applies-to ID" := '';
                GenJnlLine."Shortcut Dimension 1 Code" := PaymentHeader."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := PaymentHeader."Shortcut Dimension 2 Code";
                GenJnlLine."Dimension Set ID" := PaymentHeader."Dimension Set ID";
                GenJnlLine."Source Vend/Cust  No." := PaymentHeader."Payee No.";
                GenJnlLine."Vend/Cust Entry No." := WHTEntry."Document Entry No.";
                GenJnlLine."Source Invoice No." := PaymentHeader."No.";
                GenJnlLine."WHT Posting Group" := WHTEntry."WHT Posting Group";
                GenJnlLine.UpdateSource;
                //GenJnlLine."Source PI No." := Payline."Source Code";
                //GenJnlLine."Source PO No." := Payline."Source PO No.";
                GenJnlLine."Source Amount" := WHTEntry."WHT Payment Base Amount";

                GenJnlLine."Recurring Method" := GenJnlLine."recurring method"::"V  Variable";
                if GenJnlLine."Currency Code" <> '' then
                    GenJnlLine.TestField("Currency Factor");
                GenJnlPostLine.Run(GenJnlLine);
            until WHTEntry.Next = 0;
    end;

    local procedure CreateCashAdvanceVoucher(var lPaymentHeader: Record "Payment Header"; var lPaymentHeader2: Record "Payment Header")
    var
        PaymentLine2: Record "Payment Line";
    begin
        with lPaymentHeader do begin
            CalcFields(Amount, "Amount (LCY)");
            lPaymentHeader2.TransferFields(lPaymentHeader);
            lPaymentHeader2."Create Voucher" := false;
            lPaymentHeader2."Document Type" := lPaymentHeader2."document type"::"Payment Voucher";
            lPaymentHeader2."No." := '';
            lPaymentHeader2.Status := lPaymentHeader2.Status::Open;
            lPaymentHeader2."Payment Date" := 0D;
            lPaymentHeader2.Insert(true);
            RecordLinkManagement.CopyLinks(lPaymentHeader, lPaymentHeader2);

            PaymentLine2."Document Type" := lPaymentHeader2."Document Type";
            PaymentLine2."Document No." := lPaymentHeader2."No.";
            PaymentLine2."Line No." := 10000;
            PaymentLine2."Account Type" := PaymentLine2."account type"::Employee;
            PaymentLine2."Account No." := lPaymentHeader2."Bal. Account No.";
            PaymentLine2.Description := lPaymentHeader2."Posting Description";
            PaymentLine2."Payment Type" := lPaymentHeader2."Payment Type";
            PaymentLine2."Source Code" := lPaymentHeader."No.";
            PaymentLine2.Amount := lPaymentHeader.Amount;
            PaymentLine2."Amount (LCY)" := lPaymentHeader."Amount (LCY)";
            PaymentLine2."Applies-to Doc. Type" := 0;
            PaymentLine2."Applies-to Doc. No." := "No.";
            PaymentLine2.Insert(true);
        end;
    end;

    local procedure CreateFloatReimbVoucher(lPaymentHeader: Record "Payment Header"; var lPaymentHeader2: Record "Payment Header")
    var
        PaymentLine2: Record "Payment Line";
    begin
        with lPaymentHeader do begin
            CalcFields(Amount, "Amount (LCY)");
            lPaymentHeader2.TransferFields(PaymentHeader);
            lPaymentHeader2."Create Voucher" := false;
            lPaymentHeader2."Document Type" := lPaymentHeader2."document type"::"Payment Voucher";
            lPaymentHeader2."Payment Type" := lPaymentHeader2."payment type"::"Float Reimbursement";
            lPaymentHeader2."No." := '';
            lPaymentHeader2.Status := lPaymentHeader2.Status::Open;
            lPaymentHeader2."Payment Date" := 0D;
            lPaymentHeader2."Payment Source" := '';
            lPaymentHeader2.Insert(true);
            RecordLinkManagement.CopyLinks(lPaymentHeader, lPaymentHeader2);

            PaymentLine2."Document Type" := lPaymentHeader2."Document Type";
            PaymentLine2."Document No." := lPaymentHeader2."No.";
            PaymentLine2."Line No." := 10000;
            PaymentLine2."Account Type" := PaymentLine2."account type"::"Bank Account";
            PaymentLine2."Account No." := lPaymentHeader."Payment Source";
            PaymentLine2.Description := lPaymentHeader2."Posting Description";
            PaymentLine2."Payment Type" := lPaymentHeader2."Payment Type";
            PaymentLine2."Source Code" := lPaymentHeader."No.";
            PaymentLine2.Amount := lPaymentHeader.Amount;
            PaymentLine2."Amount (LCY)" := lPaymentHeader."Amount (LCY)";
            PaymentLine2."Applies-to Doc. Type" := 0;
            PaymentLine2."Applies-to Doc. No." := '';
            PaymentLine2.Insert(true);
        end;
    end;

    local procedure ProcessICLines(var PaymentLine: Record "Payment Line"; var GenJnlLine: Record "Gen. Journal Line")
    var
        OutBoxTransaction: Record "IC Outbox Transaction";
        ICInOutBoxMgt: Codeunit ICInboxOutboxMgt;
        ICOutboxExport: Codeunit "IC Outbox Export";
        ICTransactionNo: Integer;
    begin
        if PaymentLine."Account Type" = PaymentLine."account type"::"IC Partner" then begin
            GenJnlLine."IC Partner Code" := PaymentLine."Account No.";
            GenJnlLine."IC Direction" := GenJnlLine."ic direction"::Outgoing;
            ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(GenJnlLine, false);
            ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo, 1, GenJnlLine);
            ICOutboxExport.ProcessAutoSendOutboxTransactionNo(ICTransactionNo);
        end;
    end;

    local procedure UpdateSourceType(PaymentHeader: Record "Payment Header")
    var
        TravelHeader: Record "Travel Header";
        EmployeeAbsence: Record "Employee Absence";
    begin
        case PaymentHeader."Source Type" of
            PaymentHeader."source type"::Leave:
                begin
                    EmployeeAbsence.SetRange("Leave Application ID", PaymentHeader."Source No.");
                    EmployeeAbsence.ModifyAll("Leave Paid", true);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeletePostedPaymentDocument(var PaymentHeader: Record "Payment Header"; var PostedPaymentHeader: Record "Posted Payment Header")
    begin
    end;
}

