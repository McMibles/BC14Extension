Codeunit 52092135 "GenJnline Hook"
{

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PayMgtSetup: Record "Payment Mgt. Setup";
        GenJnlBatch: Record "Gen. Journal Batch";
    /*
        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnAfterCheckGenJnlLine', '', false, false)]
        local procedure OnAfterCheckGenJnlLine(var GenJnlLine: Record "Gen. Journal Line")
        var
            Job: Record Job;
            GLAcc: Record "G/L Account";
        begin
            with GenJnlLine do begin
                TestField(Description);
                Clear(Job);
                if ("Account Type" = "account type"::"G/L Account") and ("Account No." <> '') then begin
                    GLAcc.Get("Account No.");
                    if GLAcc."Job No. Mandatory" then begin
                        if "FA WIP No." = '' then begin
                            TestField("Job No.");
                            Job.Get("Job No.");
                        end else begin
                            Job.Get("FA WIP No.");
                            TestField("Bal. Account No.", '');
                            //Job.TESTFIELD("Job Status",Job."Job Status"::Open);
                        end;
                    end;
                    if GLAcc."GIT Clearing Account" then begin
                        TestField("Consignment Code");
                        TestField("Order No.");
                        if (GenJnlLine."Direct Cost Invoice" = false) and (GenJnlLine."Final Invoice" = false) then
                            TestField("Consignment Charge Code");
                    end;
                    if GLAcc."Prepayment Control" then
                        TestField(GenJnlLine."Order No.");
                end;
                if ("Bal. Account Type" = "bal. account type"::"G/L Account") and ("Bal. Account No." <> '') then begin
                    GLAcc.Get("Bal. Account No.");
                    if GLAcc."Job No. Mandatory" then begin
                        if "FA WIP No." = '' then begin
                            TestField("Job No.");
                            Job.Get("Job No.");
                        end else begin
                            Job.Get("FA WIP No.");
                            TestField("Bal. Account No.", '');
                            //Job.TESTFIELD("Job Status",Job."Job Status"::Open);
                        end;
                    end;
                    if GLAcc."GIT Clearing Account" then begin
                        TestField("Consignment Code");
                        TestField("Order No.");
                        if (GenJnlLine."Direct Cost Invoice" = false) and (GenJnlLine."Final Invoice" = false) then
                            TestField("Consignment Charge Code");
                    end;
                    if GLAcc."Prepayment Control" then
                        TestField(GenJnlLine."Order No.");
                end;
            end;
        end;


        procedure FilterCheckLedgerOnGenJnlPostLine(GenJnlLine: Record "Gen. Journal Line"; var CheckLedgEntry: Record "Check Ledger Entry")
        begin
            PayMgtSetup.Get;
            CheckLedgEntry.SetRange("Document No.");
            CheckLedgEntry.SetRange("Check No.");
            case PayMgtSetup."Cheque Posting Type" of
                PayMgtSetup."cheque posting type"::"System Generated No.":
                    CheckLedgEntry.SetRange("Document No.", GenJnlLine."Document No.");
                PayMgtSetup."cheque posting type"::"Cheque No.":
                    CheckLedgEntry.SetRange("Check No.", GenJnlLine."Document No.");
            end;
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]

        procedure UpdateGLEntryONGenJnlPostLine(GenJnlLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
        begin
            GLEntry."Consignment Code" := GenJnlLine."Consignment Code";
        end;

        local procedure CheckGLAccDimError(GenJnlLine: Record "Gen. Journal Line"; GLAccNo: Code[20])
        var
            DimMgt: Codeunit DimensionManagement;
            TableID: array[10] of Integer;
            AccNo: array[10] of Code[20];
            DimensionUsedErr: label 'A dimension used in %1 %2, %3, %4 has caused an error. %5.';
        begin
            TableID[1] := Database::"G/L Account";
            AccNo[1] := GLAccNo;
            if DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") then
                exit;

            if GenJnlLine."Line No." <> 0 then
                Error(
                  DimensionUsedErr,
                  GenJnlLine.TableCaption, GenJnlLine."Journal Template Name",
                  GenJnlLine."Journal Batch Name", GenJnlLine."Line No.",
                  DimMgt.GetDimValuePostingErr);

            Error(DimMgt.GetDimValuePostingErr);
        end;


        procedure CheckBankReconciliation(BankAccountCode: Code[20]; PostingDate: Date)
        var
            PostedStatement: Record "Bank Account Statement";
        begin
            PayMgtSetup.Get;
            if PayMgtSetup."Check Bank Recon." then
                PostedStatement.CheckPostedRecon(BankAccountCode, PostingDate);
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldCustLedgEntry', '', false, false)]
        local procedure OnBeforeInsertDtldCustLedgEntry(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
        var
            CustLedgerEntry: Record "Cust. Ledger Entry";
        begin
            CustLedgerEntry.Get(DtldCustLedgEntry."Cust. Ledger Entry No.");
            DtldCustLedgEntry."Source Customer No." := CustLedgerEntry."Source Customer No.";
            DtldCustLedgEntry."WHT Posting Group" := CustLedgerEntry."WHT Posting Group";
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertDtldVendLedgEntry', '', false, false)]
        local procedure OnBeforeInsertDtldVendLedgEntry(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
        var
            VendLedgerEntry: Record "Vendor Ledger Entry";
        begin
            VendLedgerEntry.Get(DtldVendLedgEntry."Vendor Ledger Entry No.");
            //DtldVendLedgEntry."Source Vendor No." := VendLedgerEntry."Source Vendor No.";
            //DtldVendLedgEntry."WHT Posting Group" := VendLedgerEntry."WHT Posting Group";
        end;

        [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnPostBankAccOnBeforeInitBankAccLedgEntry', '', false, false)]
        local procedure OnPostBankAccOnBeforeInitBankAccLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; CurrencyFactor: Decimal; var NextEntryNo: Integer; var NextTransactionNo: Integer)
        begin
            CheckBankReconciliation(GenJournalLine."Account No.", GenJournalLine."Posting Date");
        end;
        */
}

