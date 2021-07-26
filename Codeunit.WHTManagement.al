Codeunit 52130423 "WHT Management"
{

    trigger OnRun()
    begin
    end;

    var
        WHTPostingGroup: Record "WHT Posting Group";
        WHTEntry: Record "WHT Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        Currency: Record Currency;
        TempWHTtoApply: Record "WHT to Apply Entry" temporary;
        PurchSetup: Record "Purchases & Payables Setup";
        SalesSetup: Record "Sales & Receivables Setup";


    procedure GetCustWHTAmount(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJnlLine: Record "Gen. Journal Line"; TableID: Integer)
    var
        WHTToApplyEntry: Record "WHT to Apply Entry";
        TempLineFound: Boolean;
    begin
        with CustLedgerEntry do begin
            if "Amount to Apply" = 0 then
                exit;
            GetCurrency("Currency Code");
            WHTToApplyEntry.SetRange(WHTToApplyEntry."Table ID", Database::"Cust. Ledger Entry");
            WHTToApplyEntry.SetRange("Document No.", "Document No.");
            WHTToApplyEntry.SetRange("Document Entry No.", "Entry No.");
            if WHTToApplyEntry.Find('-') then
                repeat
                    WHTPostingGroup.Get(WHTToApplyEntry."WHT Posting Group");
                    WHTEntry.SetRange("Document No.", GenJnlLine."Document No.");
                    WHTEntry.SetRange("Document Line No.", GenJnlLine."Line No.");
                    WHTEntry.SetRange("WHT Posting Group", WHTToApplyEntry."WHT Posting Group");
                    WHTEntry.SetRange("Invoice No.", WHTToApplyEntry."Document No.");
                    TempLineFound := WHTEntry.FindFirst;
                    if TempLineFound then begin
                        WHTEntry."WHT Invoice Base Amount" := WHTEntry."WHT Invoice Base Amount" + ROUND("Amount to Apply" * WHTToApplyEntry."Proportion of  Total Amount",
                          Currency."Amount Rounding Precision");
                        WHTEntry."WHT Invoice Amount" := WHTEntry."WHT Invoice Amount" + ROUND(("Amount to Apply" * WHTToApplyEntry."Proportion of  Total Amount") *
                          (WHTPostingGroup."WithHolding Tax %" / 100), Currency."Amount Rounding Precision");
                        WHTEntry.Modify;
                    end else begin
                        WHTEntry.Init;
                        WHTEntry."Document No." := GenJnlLine."Document No.";
                        WHTEntry."Document Line No." := GenJnlLine."Line No.";
                        WHTEntry."WHT Posting Group" := WHTToApplyEntry."WHT Posting Group";
                        WHTEntry."Table ID" := TableID;
                        WHTEntry."Invoice No." := WHTToApplyEntry."Document No.";
                        WHTEntry."Document Entry No." := WHTToApplyEntry."Document Entry No.";
                        WHTEntry."Invoice Amount" := WHTToApplyEntry."Invoice Amount";
                        WHTEntry."WHT Invoice Base Amount" := ROUND("Amount to Apply" * WHTToApplyEntry."Proportion of  Total Amount", Currency."Amount Rounding Precision");
                        WHTEntry."WHT Invoice Amount" := ROUND(WHTEntry."WHT Invoice Base Amount" * (WHTPostingGroup."WithHolding Tax %" / 100),
                                                  Currency."Amount Rounding Precision");
                        WHTEntry.Insert;
                    end;
                until WHTToApplyEntry.Next = 0;
            WHTEntry.Reset;
            WHTEntry.SetRange("Document No.", GenJnlLine."Document No.");
            WHTEntry.SetRange("Document Line No.", GenJnlLine."Line No.");
            if WHTEntry.Find('-') then begin
                GetCurrency(GenJnlLine."Currency Code");
                repeat
                    WHTEntry."WHT Payment Base Amount" := CurrExchRate.ExchangeAmount(WHTEntry."WHT Invoice Base Amount",
                      "Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                    WHTEntry."WHT Payment Base Amount" := ROUND(WHTEntry."WHT Payment Base Amount", Currency."Amount Rounding Precision");
                    WHTEntry."WHT Payment Amount" := CurrExchRate.ExchangeAmount(WHTEntry."WHT Invoice Amount",
                      "Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                    WHTEntry."WHT Payment Amount" := ROUND(WHTEntry."WHT Payment Amount", Currency."Amount Rounding Precision");
                    if GenJnlLine."Currency Code" = '' then begin
                        WHTEntry."WHT Pmt. Base Amount (LCY)" := WHTEntry."WHT Payment Base Amount";
                        WHTEntry."WHT Pmt. Base Amount (LCY)" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code",
                              WHTEntry."WHT Payment Base Amount", GenJnlLine."Currency Factor"));
                        WHTEntry."WHT Pmt. Amount(LCY)" := WHTEntry."WHT Payment Amount";
                    end else begin
                        WHTEntry."WHT Pmt. Base Amount (LCY)" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code",
                              WHTEntry."WHT Payment Base Amount", GenJnlLine."Currency Factor"));

                        WHTEntry."WHT Pmt. Amount(LCY)" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code",
                              WHTEntry."WHT Payment Amount", GenJnlLine."Currency Factor"));
                    end;
                    WHTEntry.Modify;
                until WHTEntry.Next = 0;
            end;
        end;
    end;


    procedure GetVendWHTAmount(var VendLedgerEntry: Record "Vendor Ledger Entry"; GenJnlLine: Record "Gen. Journal Line"; TableID: Integer)
    var
        WHTToApplyEntry: Record "WHT to Apply Entry";
        TempLineFound: Boolean;
    begin
        with VendLedgerEntry do begin
            if "Amount to Apply" = 0 then
                exit;
            GetCurrency("Currency Code");
            WHTToApplyEntry.SetRange(WHTToApplyEntry."Table ID", Database::"Vendor Ledger Entry");
            WHTToApplyEntry.SetRange("Document No.", "Document No.");
            WHTToApplyEntry.SetRange("Document Entry No.", "Entry No.");
            if not (WHTToApplyEntry.Find('-')) then
                exit
            else
                repeat
                    WHTPostingGroup.Get(WHTToApplyEntry."WHT Posting Group");
                    WHTEntry.SetRange("Document No.", GenJnlLine."Document No.");
                    WHTEntry.SetRange("Document Line No.", GenJnlLine."Line No.");
                    WHTEntry.SetRange("WHT Posting Group", WHTToApplyEntry."WHT Posting Group");
                    WHTEntry.SetRange(WHTEntry."Document Entry No.", WHTToApplyEntry."Document Entry No.");
                    TempLineFound := WHTEntry.FindFirst;
                    if TempLineFound then begin
                        WHTEntry."WHT Invoice Base Amount" := WHTEntry."WHT Invoice Base Amount" + ROUND("Amount to Apply" * WHTToApplyEntry."Proportion of  Total Amount",
                          Currency."Amount Rounding Precision");
                        WHTEntry."WHT Invoice Amount" := WHTEntry."WHT Invoice Amount" + ROUND(("Amount to Apply" * WHTToApplyEntry."Proportion of  Total Amount") *
                          (WHTPostingGroup."WithHolding Tax %" / 100), Currency."Amount Rounding Precision");
                        WHTEntry.Modify;
                    end else begin
                        WHTEntry.Init;
                        WHTEntry."Document No." := GenJnlLine."Document No.";
                        WHTEntry."Document Line No." := GenJnlLine."Line No.";
                        WHTEntry."WHT Posting Group" := WHTToApplyEntry."WHT Posting Group";
                        WHTEntry."Table ID" := TableID;
                        WHTEntry."Document Entry No." := WHTToApplyEntry."Document Entry No.";
                        WHTEntry."Invoice No." := WHTToApplyEntry."Document No.";
                        WHTEntry."Invoice Amount" := WHTToApplyEntry."Invoice Amount";
                        WHTEntry."WHT Invoice Base Amount" := ROUND("Amount to Apply" * WHTToApplyEntry."Proportion of  Total Amount", Currency."Amount Rounding Precision");
                        WHTEntry."WHT Invoice Amount" := ROUND(WHTEntry."WHT Invoice Base Amount" * (WHTPostingGroup."WithHolding Tax %" / 100),
                                                  Currency."Amount Rounding Precision");
                        WHTEntry.Insert;
                    end;
                until WHTToApplyEntry.Next = 0;
            WHTEntry.Reset;
            WHTEntry.SetRange("Document No.", GenJnlLine."Document No.");
            WHTEntry.SetRange("Document Line No.", GenJnlLine."Line No.");
            if WHTEntry.Find('-') then begin
                GetCurrency(GenJnlLine."Currency Code");
                repeat
                    WHTEntry."WHT Payment Base Amount" := CurrExchRate.ExchangeAmount(WHTEntry."WHT Invoice Base Amount",
                      "Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                    WHTEntry."WHT Payment Base Amount" := ROUND(WHTEntry."WHT Payment Base Amount", Currency."Amount Rounding Precision");
                    WHTEntry."WHT Payment Amount" := CurrExchRate.ExchangeAmount(WHTEntry."WHT Invoice Amount",
                      "Currency Code", GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                    WHTEntry."WHT Payment Amount" := ROUND(WHTEntry."WHT Payment Amount", Currency."Amount Rounding Precision");
                    if GenJnlLine."Currency Code" = '' then begin
                        WHTEntry."WHT Pmt. Base Amount (LCY)" := WHTEntry."WHT Payment Base Amount";
                        WHTEntry."WHT Pmt. Base Amount (LCY)" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code",
                              WHTEntry."WHT Payment Base Amount", GenJnlLine."Currency Factor"));
                        WHTEntry."WHT Pmt. Amount(LCY)" := WHTEntry."WHT Payment Amount";
                    end else begin
                        WHTEntry."WHT Pmt. Base Amount (LCY)" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code",
                              WHTEntry."WHT Payment Base Amount", GenJnlLine."Currency Factor"));

                        WHTEntry."WHT Pmt. Amount(LCY)" := ROUND(
                            CurrExchRate.ExchangeAmtFCYToLCY(GenJnlLine."Posting Date", GenJnlLine."Currency Code",
                              WHTEntry."WHT Payment Amount", GenJnlLine."Currency Factor"));
                    end;
                    WHTEntry.Modify;
                until WHTEntry.Next = 0;
            end;
        end;
    end;


    procedure GetCurrency(CurrencyCode: Code[20])
    begin
        if CurrencyCode = '' then
            Currency.InitRoundingPrecision
        else begin
            Currency.Get(CurrencyCode);
            Currency.TestField("Amount Rounding Precision");
        end;
    end;


    procedure ResetWHTJnlBuffer(GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        WHTEntry.Reset;
        WHTEntry.SetRange("Document No.", GenJnlLine."Document No.");
        WHTEntry.SetRange("Document Line No.", GenJnlLine."Line No.");
        if WHTEntry.Find('-') then
            repeat
                if WHTEntry."Payment Line No." <> 0 then begin
                    if GenJnlLine2.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name", WHTEntry."Payment Line No.") then
                        GenJnlLine2.Delete;
                end;
            until WHTEntry.Next = 0;
        WHTEntry.DeleteAll;
    end;


    procedure ResetWHTDocBuffer(DocNo: Code[20]; DocLineNo: Integer; TableID: Integer)
    begin
        /*WHTEntry.RESET;
        WHTEntry.SETRANGE("Document No.",DocNo);
        WHTEntry.SETRANGE("Document Line No.",DocLineNo);
        IF WHTEntry.FIND('-') THEN
          REPEAT
            IF WHTEntry."Payment Line No." <> 0 THEN BEGIN
              CASE TableID OF
                60214: BEGIN
                  CashReceiptLine.GET(WHTEntry."Document No.",WHTEntry."Payment Line No.");
                  CashReceiptLine.DELETE;
                END;
                60203: BEGIN
                  PaymentLine.GET(PaymentLine."Document Type"::"0",WHTEntry."Document No.",
                    WHTEntry."Payment Line No.");
                  PaymentLine.DELETE;
                END;
              END;
            END;
          UNTIL WHTEntry.NEXT = 0;
        WHTEntry.DELETEALL;*/

    end;


    procedure CreateWHTJnlLine(var GenJnlLine: Record "Gen. Journal Line"; EntryType: Option Purchase,Sales)
    var
        GenJnlLine2: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        with GenJnlLine do begin
            LineNo := 0;
            WHTEntry.Reset;
            WHTEntry.SetRange("Document No.", GenJnlLine."Document No.");
            WHTEntry.SetRange("Document Line No.", GenJnlLine."Line No.");
            if WHTEntry.Find('-') then
                repeat
                    LineNo := LineNo + 1000;
                    WHTPostingGroup.Get(WHTPostingGroup.Code);
                    GenJnlLine2."Journal Template Name" := GenJnlLine."Journal Template Name";
                    GenJnlLine2."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                    GenJnlLine2."Line No." := GenJnlLine."Line No." + LineNo;
                    GenJnlLine2."WHT Line" := true;
                    if EntryType = 1 then begin
                        GenJnlLine2."Account Type" := GenJnlLine2."account type"::Customer;
                        GenJnlLine2.Validate("Account No.", WHTPostingGroup.GetSalesWHTTaxAccount);
                    end else begin
                        GenJnlLine2."Account Type" := GenJnlLine2."account type"::Vendor;
                        GenJnlLine2.Validate("Account No.", WHTPostingGroup.GetPurchWHTTaxAccount);
                    end;
                    GenJnlLine2."Posting Date" := GenJnlLine."Posting Date";
                    GenJnlLine2."Document Type" := GenJnlLine."Document Type";
                    GenJnlLine2."Document No." := GenJnlLine."Document No.";
                    //Code changed because the WIth-Holding Tax is processed in LCY
                    /*GenJnlLine2."Currency Code" := GenJnlLine."Currency Code";
                    GenJnlLine2."Currency Factor" := GenJnlLine."Currency Factor";
                    GenJnlLine2.VALIDATE(Amount, WHTEntry."WHT Payment Base Amount");
                    GenJnlLine2.VALIDATE("WHT Base Amount",WHTEntry."WHT Payment Base Amount");
                    GenJnlLine2."Source Curr. WHT Base Amount" := WHTEntry."WHT Invoice Base Amount";
                    GenJnlLine2."Source Curr. WHT Amount" := WHTEntry."WHT Invoice Amount"; */
                    //@08 Aug 2016
                    GenJnlLine2."Currency Code" := '';
                    GenJnlLine2.Validate(Amount, WHTEntry."WHT Pmt. Amount(LCY)");
                    GenJnlLine2.Validate("WHT Base Amount", WHTEntry."WHT Pmt. Base Amount (LCY)");
                    GenJnlLine2."Source Curr. WHT Base Amount" := WHTEntry."WHT Invoice Base Amount";
                    GenJnlLine2."Source Curr. WHT Amount" := WHTEntry."WHT Invoice Amount";
                    GenJnlLine2."WHT Posting Group" := WHTEntry."WHT Posting Group";
                    GenJnlLine2."Source Vend/Cust  No." := GenJnlLine."Account No.";
                    GenJnlLine2."Sell-to/Buy-from No." := GenJnlLine."Account No.";
                    GenJnlLine2."Vend/Cust Entry No." := WHTEntry."Document Entry No.";
                    GenJnlLine2."Source Invoice No." := GenJnlLine."Document No.";
                    GenJnlLine2."Source Amount" := WHTEntry."WHT Payment Base Amount";
                    GenJnlLine2.Insert;
                    WHTEntry."Payment Line No." := GenJnlLine2."Line No.";
                    WHTEntry.Modify;
                until WHTEntry.Next = 0;
        end;

    end;


    procedure CreateWHTPaymentLine(var PaymentLine: Record "Payment Line"; EntryType: Option Purchase,Sales)
    var
        LineNo: Integer;
    begin
        with PaymentLine do begin
            WHTEntry.Reset;
            WHTEntry.SetRange("Document No.", PaymentLine."Document No.");
            WHTEntry.SetRange("Document Line No.", PaymentLine."Line No.");
            WHTEntry.CalcSums(WHTEntry."WHT Payment Amount", WHTEntry."WHT Pmt. Amount(LCY)");
            PaymentLine."WHT Amount" := Abs(WHTEntry."WHT Payment Amount");
            PaymentLine."WHT Amount (LCY)" := Abs(WHTEntry."WHT Pmt. Amount(LCY)");
            PaymentLine.Modify;
        end;
    end;


    procedure CreateWHTCashReceiptLine(var CashReceiptLine: Record "Cash Receipt Line"; EntryType: Option Purchase,Sales)
    var
        LineNo: Integer;
    begin
        with CashReceiptLine do begin
            WHTEntry.Reset;
            WHTEntry.SetRange("Document No.", CashReceiptLine."Document No.");
            WHTEntry.SetRange("Document Line No.", CashReceiptLine."Line No.");
            WHTEntry.CalcSums(WHTEntry."WHT Payment Amount", WHTEntry."WHT Pmt. Amount(LCY)");
            CashReceiptLine."WHT Amount" := Abs(WHTEntry."WHT Payment Amount");
            CashReceiptLine."WHT Amount (LCY)" := Abs(WHTEntry."WHT Pmt. Amount(LCY)");
            CashReceiptLine.Modify;
        end;
    end;


    procedure DeleteWHTDocBuffer(DocNo: Code[20])
    begin
        WHTEntry.Reset;
        WHTEntry.SetRange("Document No.", DocNo);
        WHTEntry.DeleteAll;
    end;


    procedure GetVendLedgeEntryWHTAmount(DocNo: Code[20]; VendorEntryNo: Integer): Decimal
    var
        WHTToApply: Record "WHT to Apply Entry";
    begin
        WHTToApply.SetRange("Document No.", DocNo);
        WHTToApply.SetRange("Document Entry No.", VendorEntryNo);
        WHTToApply.CalcSums(WHTToApply."WHT Amount");
        exit(WHTToApply."WHT Amount");
    end;

    /*
        procedure FillPurchTempWHTtoApply(PurchHeader: Record "Purchase Header"; GenJnlLineDocNo: Code[20]; PurchLine: Record "Purchase Line")
        var
            TempLineFound: Boolean;
            Factor: Integer;
        begin
            if not (PurchHeader.Invoice) then
                exit;
            with PurchLine do begin
                if PurchLine."With-Holding Tax Amt" = 0 then
                    exit;
                if "Document Type" in ["document type"::"Return Order", "document type"::"Credit Memo"] then
                    Factor := -1
                else
                    Factor := 1;
                TempWHTtoApply.SetRange("Table ID", Database::"Purchase Header");
                TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                TempWHTtoApply.SetRange("Document Entry No.", 1);
                TempWHTtoApply.SetRange("WHT Posting Group", PurchLine."WHT Posting Group");
                TempLineFound := TempWHTtoApply.FindFirst;
                if TempLineFound then begin
                    TempWHTtoApply."WHT Base Amount" += PurchLine.Amount * Factor;
                    TempWHTtoApply."WHT Amount" += PurchLine."With-Holding Tax Amt" * Factor;
                    TempWHTtoApply.Modify;
                end else begin
                    TempWHTtoApply.Init;
                    TempWHTtoApply."Table ID" := Database::"Purchase Header";
                    TempWHTtoApply."Document No." := GenJnlLineDocNo;
                    TempWHTtoApply."Document Entry No." := 1;
                    TempWHTtoApply."WHT Posting Group" := PurchLine."WHT Posting Group";
                    TempWHTtoApply."WHT Base Amount" := PurchLine.Amount * Factor;
                    TempWHTtoApply."WHT Amount" := PurchLine."With-Holding Tax Amt" * Factor;
                    TempWHTtoApply.Insert;
                end;
            end;
        end;


        procedure CreateVendLedgerTempWHTtoApply(GenJnlLineDocNo: Code[20]; GenJnlLineDocType: Integer; PurchHeader: Record "Purchase Header")
        var
            WHTtoApply: Record "WHT to Apply Entry";
            VendorLedgerEntry: Record "Vendor Ledger Entry";
        begin
            FindVendorLedgerEntry(GenJnlLineDocType, GenJnlLineDocNo, VendorLedgerEntry);
            case PurchHeader."WithHolding Tax Posting" of
                PurchHeader."withholding tax posting"::Payment:
                    begin
                        TempWHTtoApply.Reset;
                        TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                        TempWHTtoApply.SetFilter("WHT Amount", '<>0');
                        VendorLedgerEntry.CalcFields("Original Amount");
                        if TempWHTtoApply.Find('-') then
                            repeat
                                WHTtoApply."Table ID" := Database::"Vendor Ledger Entry";
                                WHTtoApply."Document No." := VendorLedgerEntry."Document No.";
                                WHTtoApply."Document Entry No." := VendorLedgerEntry."Entry No.";
                                WHTtoApply."WHT Posting Group" := TempWHTtoApply."WHT Posting Group";
                                WHTtoApply."Invoice Amount" := VendorLedgerEntry."Original Amount";
                                WHTtoApply.Validate("WHT Base Amount", -TempWHTtoApply."WHT Base Amount");
                                WHTtoApply."WHT Amount" := -TempWHTtoApply."WHT Amount";
                                WHTtoApply.Insert;
                            until TempWHTtoApply.Next = 0;
                        TempWHTtoApply.DeleteAll;
                    end;
                PurchHeader."withholding tax posting"::Invoice:
                    begin
                        TempWHTtoApply.Reset;
                        TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                        TempWHTtoApply.SetFilter("WHT Amount", '<>0');
                        if TempWHTtoApply.Find('-') then
                            repeat
                                WHTtoApply := TempWHTtoApply;
                                WHTtoApply."WHT Amount" := -TempWHTtoApply."WHT Amount";
                                WHTtoApply."WHT Amount (LCY)" := -TempWHTtoApply."WHT Amount (LCY)";
                                WHTtoApply."WHT Base Amount" := -TempWHTtoApply."WHT Base Amount";
                                WHTtoApply."Document Entry No." := VendorLedgerEntry."Entry No.";
                                WHTtoApply.Insert;
                            until TempWHTtoApply.Next = 0;
                        TempWHTtoApply.DeleteAll;
                    end;
            end;
        end;


        procedure ResetTempWHTtoApply()
        begin
            TempWHTtoApply.DeleteAll;
        end;


        procedure FillPurchPrepmtTempWHTtoApply(PurchHeader: Record "Purchase Header"; GenJnlLineDocNo: Code[20]; DocumentType: Option Invoice,"Credit Memo"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer")
        var
            TempLineFound: Boolean;
            Factor: Integer;
        begin
            ResetTempWHTtoApply;
            with PrepmtInvLineBuf do begin
                if not Find('-') then
                    exit;

                repeat
                    if DocumentType = Documenttype::"Credit Memo" then
                        Factor := -1
                    else
                        Factor := 1;

                    TempWHTtoApply.SetRange("Table ID", Database::"Purchase Header");
                    TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                    TempWHTtoApply.SetRange("Document Entry No.", 1);
                    TempWHTtoApply.SetRange("WHT Posting Group", PrepmtInvLineBuf."WHT Posting Group");
                    TempLineFound := TempWHTtoApply.FindFirst;
                    if TempLineFound then begin
                        TempWHTtoApply."WHT Base Amount" += PrepmtInvLineBuf.Amount * Factor;
                        TempWHTtoApply."WHT Amount" += PrepmtInvLineBuf."WHT Amount" * Factor;
                        TempWHTtoApply.Modify;
                    end else begin
                        TempWHTtoApply.Init;
                        TempWHTtoApply."Table ID" := Database::"Purchase Header";
                        TempWHTtoApply."Document No." := GenJnlLineDocNo;
                        TempWHTtoApply."Document Entry No." := 1;
                        TempWHTtoApply."WHT Posting Group" := PrepmtInvLineBuf."WHT Posting Group";
                        TempWHTtoApply."WHT Base Amount" := PrepmtInvLineBuf.Amount * Factor;
                        TempWHTtoApply."WHT Amount" := PrepmtInvLineBuf."WHT Amount" * Factor;
                        TempWHTtoApply.Insert;
                    end;
                until PrepmtInvLineBuf.Next = 0;
                TempWHTtoApply.Reset;
                TempWHTtoApply.SetRange("Table ID", Database::"Purchase Header");
                TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                if TempWHTtoApply.Find('-') then begin
                    repeat
                        if PurchHeader."Currency Code" = '' then
                            TempWHTtoApply."WHT Amount (LCY)" := TempWHTtoApply."WHT Amount"
                        else
                            TempWHTtoApply."WHT Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(PurchHeader."Posting Date",
                              PurchHeader."Currency Code", TempWHTtoApply."WHT Amount", PurchHeader."Currency Factor"));
                        TempWHTtoApply.Modify;
                    until TempWHTtoApply.Next = 0;
                end;
            end;
        end;

        local procedure FindVendorLedgerEntry(DocType: Option; DocNo: Code[20]; var VendorLedgerEntry: Record "Vendor Ledger Entry")
        begin
            VendorLedgerEntry.SetRange("Document Type", DocType);
            VendorLedgerEntry.SetRange("Document No.", DocNo);
            VendorLedgerEntry.FindLast;
        end;


        procedure UpdateWHTAmountOnPurchPrepmtPost(var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; PurchLine: Record "Purchase Line")
        begin
            if PurchLine."With-Holding Tax%" <> 0 then begin
                PrepmtInvLineBuf."WHT Amount" := ROUND(PrepmtInvLineBuf.Amount * PurchLine."With-Holding Tax%" / 100);
                PrepmtInvLineBuf."WHT Posting Group" := PurchLine."WHT Posting Group";
            end;
        end;


        procedure UpdateGenJnlOnPurchPrepmtPost(PurchHeader: Record "Purchase Header"; var GenJnlLine: Record "Gen. Journal Line"; TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer")
        begin
            GenJnlLine."Order No." := PurchHeader."No.";
            if TotalPrepmtInvLineBuffer."WHT Amount" <> 0 then begin
                case PurchHeader."WithHolding Tax Posting" of
                    PurchHeader."withholding tax posting"::Invoice:
                        begin
                            GenJnlLine.Amount := GenJnlLine.Amount + TotalPrepmtInvLineBuffer."WHT Amount";
                            GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                            GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" + TotalPrepmtInvLineBufferLCY."WHT Amount";
                        end;
                end;
            end;
        end;


        procedure UpdateGenJnlOnPurchPost(PurchHeader: Record "Purchase Header"; var GenJnlLine: Record "Gen. Journal Line"; WHTAmount: Decimal; WHTAmountLCY: Decimal)
        begin
            case PurchHeader."Document Type" of
                PurchHeader."document type"::Order:
                    GenJnlLine."Order No." := PurchHeader."No.";
                PurchHeader."document type"::Invoice:
                    GenJnlLine."Order No." := PurchHeader."Order No.";
            end;
            case PurchHeader."WithHolding Tax Posting" of
                PurchHeader."withholding tax posting"::Invoice:
                    begin
                        GenJnlLine.Amount := GenJnlLine.Amount + WHTAmount;
                        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                        GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" + WHTAmountLCY;
                    end;
            end;
        end;


        procedure GetWHTPurchAccountNo(PurchHeader: Record "Purchase Header"): Code[20]
        var
            WHTPostingGrp: Record "WHT Posting Group";
        begin
            with PurchHeader do begin
                WHTPostingGrp.Get("WHT Posting Group");
                WHTPostingGrp.TestField(WHTPostingGrp."Purchase WHT Tax Account");
                exit(WHTPostingGrp."Purchase WHT Tax Account");
            end;
        end;


        procedure GetWHTSalesAccountNo(SalesHeader: Record "Purchase Header"): Code[20]
        var
            WHTPostingGrp: Record "WHT Posting Group";
        begin
            with SalesHeader do begin
                WHTPostingGrp.Get("WHT Posting Group");
                WHTPostingGrp.TestField(WHTPostingGrp."Sales WHT Tax Account");
                exit(WHTPostingGrp."Sales WHT Tax Account");
            end;
        end;


        procedure GetCustLedgeEntryWHTAmount(DocNo: Code[20]; CustEntryNo: Integer): Decimal
        var
            WHTToApply: Record "WHT to Apply Entry";
        begin
            WHTToApply.SetRange("Document No.", DocNo);
            WHTToApply.SetRange("Document Entry No.", CustEntryNo);
            WHTToApply.CalcSums(WHTToApply."WHT Amount");
            exit(WHTToApply."WHT Amount");
        end;


        procedure FillSalesTempWHTtoApply(SalesHeader: Record "Sales Header"; GenJnlLineDocNo: Code[20]; SalesLine: Record "Sales Line")
        var
            TempLineFound: Boolean;
            Factor: Integer;
        begin
            if not (SalesHeader.Invoice) then
                exit;
            with SalesLine do begin
                if SalesLine."With-Holding Tax Amt" = 0 then
                    exit;
                if ("Document Type" in ["document type"::"Return Order", "document type"::"Credit Memo"]) then
                    Factor := -1
                else
                    Factor := 1;
                TempWHTtoApply.SetRange("Table ID", Database::"Sales Header");
                TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                TempWHTtoApply.SetRange("Document Entry No.", 1);
                TempWHTtoApply.SetRange("WHT Posting Group", SalesLine."WHT Posting Group");
                TempLineFound := TempWHTtoApply.FindFirst;
                if TempLineFound then begin
                    TempWHTtoApply."WHT Base Amount" += SalesLine.Amount * Factor;
                    TempWHTtoApply."WHT Amount" += SalesLine."With-Holding Tax Amt" * Factor;
                    TempWHTtoApply.Modify;
                end else begin
                    TempWHTtoApply.Init;
                    TempWHTtoApply."Table ID" := Database::"Sales Header";
                    TempWHTtoApply."Document No." := GenJnlLineDocNo;
                    TempWHTtoApply."Document Entry No." := 1;
                    TempWHTtoApply."WHT Posting Group" := SalesLine."WHT Posting Group";
                    TempWHTtoApply."WHT Base Amount" := SalesLine.Amount * Factor;
                    TempWHTtoApply."WHT Amount" := SalesLine."With-Holding Tax Amt" * Factor;
                    TempWHTtoApply.Insert;
                end;

            end;
        end;


        procedure CreateCustLedgerTempWHTtoApply(GenJnlLineDocNo: Code[20]; GenJnlLineDocType: Integer; SalesHeader: Record "Sales Header")
        var
            WHTtoApply: Record "WHT to Apply Entry";
            CustLedgerEntry: Record "Cust. Ledger Entry";
        begin
            FindCustLedgerEntry(GenJnlLineDocType, GenJnlLineDocNo, CustLedgerEntry);
            case SalesHeader."WithHolding Tax Posting" of
                SalesHeader."withholding tax posting"::Payment:
                    begin
                        TempWHTtoApply.Reset;
                        TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                        TempWHTtoApply.SetFilter("WHT Amount", '<>0');
                        CustLedgerEntry.CalcFields("Original Amount");
                        if TempWHTtoApply.Find('-') then
                            repeat
                                WHTtoApply."Table ID" := Database::"Cust. Ledger Entry";
                                WHTtoApply."Document No." := CustLedgerEntry."Document No.";
                                WHTtoApply."Document Entry No." := CustLedgerEntry."Entry No.";
                                WHTtoApply."WHT Posting Group" := TempWHTtoApply."WHT Posting Group";
                                WHTtoApply."Invoice Amount" := CustLedgerEntry."Original Amount";
                                WHTtoApply.Validate("WHT Base Amount", TempWHTtoApply."WHT Base Amount");
                                WHTtoApply."WHT Amount" := TempWHTtoApply."WHT Amount";
                                WHTtoApply.Insert;
                            until TempWHTtoApply.Next = 0;
                        TempWHTtoApply.DeleteAll;
                    end;
                SalesHeader."withholding tax posting"::Invoice:
                    begin
                        TempWHTtoApply.Reset;
                        TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                        TempWHTtoApply.SetFilter("WHT Amount", '<>0');
                        if TempWHTtoApply.Find('-') then
                            repeat
                                WHTtoApply := TempWHTtoApply;
                                WHTtoApply."WHT Amount" := TempWHTtoApply."WHT Amount";
                                WHTtoApply."WHT Amount (LCY)" := TempWHTtoApply."WHT Amount (LCY)";
                                WHTtoApply."WHT Base Amount" := TempWHTtoApply."WHT Base Amount";
                                WHTtoApply."Document Entry No." := CustLedgerEntry."Entry No.";
                                WHTtoApply.Insert;
                            until TempWHTtoApply.Next = 0;
                        TempWHTtoApply.DeleteAll;
                    end;
            end;
        end;


        procedure FillSalesPrepmtTempWHTtoApply(SalesHeader: Record "Sales Header"; GenJnlLineDocNo: Code[20]; DocumentType: Option Invoice,"Credit Memo"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer")
        var
            TempLineFound: Boolean;
            Factor: Integer;
        begin
            ResetTempWHTtoApply;
            with PrepmtInvLineBuf do begin
                if not Find('-') then
                    exit;
                repeat
                    if DocumentType = Documenttype::"Credit Memo" then
                        Factor := -1
                    else
                        Factor := 1;
                    TempWHTtoApply.SetRange("Table ID", Database::"Sales Header");
                    TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                    TempWHTtoApply.SetRange("Document Entry No.", 1);
                    TempWHTtoApply.SetRange("WHT Posting Group", PrepmtInvLineBuf."WHT Posting Group");
                    TempLineFound := TempWHTtoApply.FindFirst;
                    if TempLineFound then begin
                        TempWHTtoApply."WHT Base Amount" += PrepmtInvLineBuf.Amount * Factor;
                        TempWHTtoApply."WHT Amount" += PrepmtInvLineBuf."WHT Amount" * Factor;
                    end else begin
                        TempWHTtoApply.Init;
                        TempWHTtoApply."Table ID" := Database::"Sales Header";
                        TempWHTtoApply."Document No." := GenJnlLineDocNo;
                        TempWHTtoApply."Document Entry No." := 1;
                        TempWHTtoApply."WHT Posting Group" := PrepmtInvLineBuf."WHT Posting Group";
                        TempWHTtoApply."WHT Base Amount" := PrepmtInvLineBuf.Amount * Factor;
                        TempWHTtoApply."WHT Amount" := PrepmtInvLineBuf."WHT Amount" * Factor;
                        TempWHTtoApply.Insert;
                    end;
                until PrepmtInvLineBuf.Next = 0;
                TempWHTtoApply.Reset;
                TempWHTtoApply.SetRange("Table ID", Database::"Sales Header");
                TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
                if TempWHTtoApply.Find('-') then begin
                    repeat
                        if SalesHeader."Currency Code" = '' then
                            TempWHTtoApply."WHT Amount (LCY)" := TempWHTtoApply."WHT Amount"
                        else
                            TempWHTtoApply."WHT Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(SalesHeader."Posting Date",
                                SalesHeader."Currency Code", TempWHTtoApply."WHT Amount", SalesHeader."Currency Factor"));
                        TempWHTtoApply.Modify;
                    until TempWHTtoApply.Next = 0;
                end;
            end;
        end;

        local procedure FindCustLedgerEntry(DocType: Option; DocNo: Code[20]; var CustLedgerEntry: Record "Cust. Ledger Entry")
        begin
            CustLedgerEntry.SetRange("Document Type", DocType);
            CustLedgerEntry.SetRange("Document No.", DocNo);
            CustLedgerEntry.FindLast;
        end;


        procedure ReverseSalesAmount(var SalesLine: Record "Sales Line")
        begin
            with SalesLine do begin
                Amount := -Amount;
                "With-Holding Tax Amt" := -"With-Holding Tax Amt"
            end;
        end;


        procedure UpdateWHTAmountOnSalesPrepmtPost(var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; SalesLine: Record "Sales Line")
        begin
            if SalesLine."With-Holding Tax%" <> 0 then begin
                PrepmtInvLineBuf."WHT Amount" := ROUND(PrepmtInvLineBuf.Amount * SalesLine."With-Holding Tax%" / 100);
                PrepmtInvLineBuf."WHT Posting Group" := SalesLine."WHT Posting Group";
            end;
        end;


        procedure UpdateGenJnlOnSalesPrepmtPost(SalesHeader: Record "Sales Header"; var GenJnlLine: Record "Gen. Journal Line"; TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer")
        begin
            //GenJnlLine."Order No." := SalesHeader."No.";
            if TotalPrepmtInvLineBuffer."WHT Amount" <> 0 then begin
                case SalesHeader."WithHolding Tax Posting" of
                    SalesHeader."withholding tax posting"::Invoice:
                        begin
                            GenJnlLine.Amount := -TotalPrepmtInvLineBuffer."Amount Incl. VAT" + TotalPrepmtInvLineBuffer."WHT Amount";
                            GenJnlLine."Source Currency Amount" := -TotalPrepmtInvLineBuffer."Amount Incl. VAT" + TotalPrepmtInvLineBuffer."WHT Amount";
                            GenJnlLine."Amount (LCY)" := -TotalPrepmtInvLineBufferLCY."Amount Incl. VAT" + TotalPrepmtInvLineBufferLCY."WHT Amount";
                            GenJnlLine."Sales/Purch. (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;
                            GenJnlLine."Profit (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;
                        end;
                end;
            end;
        end;


        procedure UpdateGenJnlOnSalesPost(SalesHeader: Record "Sales Header"; var GenJnlLine: Record "Gen. Journal Line"; WHTAmount: Decimal; WHTAmountLCY: Decimal)
        begin
            case SalesHeader."WithHolding Tax Posting" of
                SalesHeader."withholding tax posting"::Invoice:
                    begin
                        GenJnlLine.Amount := GenJnlLine.Amount + WHTAmount;
                        GenJnlLine."Source Currency Amount" := GenJnlLine.Amount;
                        GenJnlLine."Amount (LCY)" := GenJnlLine."Amount (LCY)" + WHTAmountLCY;
                    end;
            end;
        end;

    */
    procedure GetGLAccountWHTAmount(PaymentLine: Record "Payment Line")
    var
        TempLineFound: Boolean;
    begin
        WHTPostingGroup.Get(PaymentLine."WHT Posting Group");
        WHTEntry.SetRange("Document No.", PaymentLine."Document No.");
        WHTEntry.SetRange("WHT Posting Group", PaymentLine."WHT Posting Group");
        TempLineFound := WHTEntry.FindFirst;
        if TempLineFound then begin
            WHTEntry."WHT Invoice Base Amount" += PaymentLine.Amount;
            WHTEntry."WHT Invoice Amount" += -PaymentLine."WHT Amount";
            WHTEntry."WHT Payment Base Amount" += PaymentLine.Amount;
            WHTEntry."WHT Payment Amount" += -PaymentLine."WHT Amount";
            WHTEntry."WHT Pmt. Base Amount (LCY)" += PaymentLine."Amount (LCY)";
            WHTEntry."WHT Pmt. Amount(LCY)" += -PaymentLine."WHT Amount (LCY)";
            WHTEntry.Modify;
        end else begin
            WHTEntry.Init;
            WHTEntry."Document No." := PaymentLine."Document No.";
            WHTEntry."WHT Posting Group" := PaymentLine."WHT Posting Group";
            WHTEntry."Table ID" := Database::"Payment Header";
            WHTEntry."Invoice No." := PaymentLine."Document No.";
            WHTEntry."Invoice Amount" := PaymentLine.Amount;
            WHTEntry."WHT Invoice Base Amount" := PaymentLine.Amount;
            WHTEntry."WHT Invoice Amount" := -PaymentLine."WHT Amount";
            WHTEntry."WHT Payment Base Amount" := PaymentLine.Amount;
            WHTEntry."WHT Payment Amount" := -PaymentLine."WHT Amount";
            WHTEntry."WHT Pmt. Base Amount (LCY)" := PaymentLine."Amount (LCY)";
            WHTEntry."WHT Pmt. Amount(LCY)" := -PaymentLine."WHT Amount (LCY)";
            WHTEntry.Insert;
        end;
    end;


    procedure UpdatePurchTempWHTtoApplyLCY(PurchHeader: Record "Purchase Header"; GenJnlLineDocNo: Code[20])
    var
        TempLineFound: Boolean;
    begin
        if not (PurchHeader.Invoice) then
            GetCurrency(PurchHeader."Currency Code");
        TempWHTtoApply.Reset;
        TempWHTtoApply.SetRange("Table ID", Database::"Purchase Header");
        TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
        if TempWHTtoApply.Find('-') then begin
            repeat
                if PurchHeader."Currency Code" = '' then
                    TempWHTtoApply."WHT Amount (LCY)" := TempWHTtoApply."WHT Amount"
                else
                    TempWHTtoApply."WHT Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(PurchHeader."Posting Date",
                        PurchHeader."Currency Code", TempWHTtoApply."WHT Amount", PurchHeader."Currency Factor"));
                TempWHTtoApply.Modify;
            until TempWHTtoApply.Next = 0;
        end;
    end;


    procedure UpdateSalesTempWHTtoApplyLCY(SalesHeader: Record "Sales Header"; GenJnlLineDocNo: Code[20])
    var
        TempLineFound: Boolean;
    begin
        if not (SalesHeader.Invoice) then
            exit;
        GetCurrency(SalesHeader."Currency Code");
        TempWHTtoApply.Reset;
        TempWHTtoApply.SetRange("Table ID", Database::"Sales Header");
        TempWHTtoApply.SetRange("Document No.", GenJnlLineDocNo);
        if TempWHTtoApply.Find('-') then begin
            repeat
                if SalesHeader."Currency Code" = '' then
                    TempWHTtoApply."WHT Amount (LCY)" := TempWHTtoApply."WHT Amount"
                else
                    TempWHTtoApply."WHT Amount (LCY)" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(SalesHeader."Posting Date",
                        SalesHeader."Currency Code", TempWHTtoApply."WHT Amount", SalesHeader."Currency Factor"));
                TempWHTtoApply.Modify;
            until TempWHTtoApply.Next = 0;
        end;
    end;

    /*
        procedure PurchPrepmtPostInsertPurchInvLine(PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; var PurchInvLine: Record "Purch. Inv. Line")
        begin
            with PrepmtInvLineBuffer do begin
                PurchInvLine."With-Holding Tax Amt" := "WHT Amount";
                PurchInvLine."WHT Posting Group" := "WHT Posting Group";
            end;
        end;


        procedure PurchPrepmtPostInsertPurchCrMemoLine(PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer"; var PurchCrMemoLine: Record "Purch. Cr. Memo Line")
        begin
            with PrepmtInvLineBuffer do begin
                PurchCrMemoLine."With-Holding Tax Amt" := "WHT Amount";
                PurchCrMemoLine."WHT Posting Group" := "WHT Posting Group";
            end;
        end;


        procedure CreatePremptLineSuspendStatusCheckOnPurchPost(var TempPrepmtPurchLine: Record "Purchase Line")
        begin
            TempPrepmtPurchLine.SuspendStatusCheck := true
        end;


        procedure CreatePremptLineOnPurchPost(var TempPrepmtPurchLine: Record "Purchase Line"; PurchLine: Record "Purchase Line")
        begin
            TempPrepmtPurchLine.Validate("WHT Posting Group", PurchLine."WHT Posting Group");
        end;


        procedure OnInitPurchHeader(var PurchHeader: Record "Purchase Header")
        begin
            PurchSetup.Get;
            PurchHeader."WithHolding Tax Posting" := PurchSetup."WithHolding Tax Posting";
        end;


        procedure GetPurchWHTInfo(var PurchHeader: Record "Purchase Header")
        var
            Vendor: Record Vendor;
        begin
            with PurchHeader do begin
                if "Buy-from Vendor No." = '' then
                    exit;
                Vendor.Get("Buy-from Vendor No.");
                if Vendor."WHT Posting Group" <> '' then
                    Validate("WHT Posting Group", Vendor."WHT Posting Group");
            end;
        end;


        procedure InitPurchHeaderWHTDefault(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line")
        var
            Vendor: Record Vendor;
        begin
            with PurchLine do begin
                "WHT Posting Group" := PurchHeader."WHT Posting Group";
                "With-Holding Tax%" := PurchHeader."With-Holding Tax%";
            end;
        end;


        procedure CreatePremptLineSuspendStatusCheckOnSalesPost(var TempPrepmtSalesLine: Record "Sales Line")
        begin
            TempPrepmtSalesLine.SuspendStatusCheck := true
        end;

        procedure CreatePremptLineOnSalesPost(var TempPrepmtSalesLine: Record "Sales Line"; SalesLine: Record "Sales Line")
        begin
            TempPrepmtSalesLine.Validate("WHT Posting Group", 'NOWHT');
        end;


        procedure OnInitSalesHeader(var SalesHeader: Record "Sales Header")
        begin
            SalesSetup.Get;
            SalesHeader."WithHolding Tax Posting" := SalesSetup."WithHolding Tax Posting";
        end;


        procedure GetSalesWHTInfo(var SalesHeader: Record "Sales Header")
        var
            Cust: Record Customer;
        begin
            with SalesHeader do begin
                if "Sell-to Customer No." = '' then
                    exit;
                Cust.Get("Sell-to Customer No.");
                if Cust."WHT Posting Group" <> '' then
                    Validate("WHT Posting Group", Cust."WHT Posting Group");
            end;
        end;

        [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitHeaderDefaults', '', false, false)]

        procedure OnAfterInitSalesHeaderDefaults(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
        var
            Vendor: Record Vendor;
        begin
            with SalesLine do begin
                "WHT Posting Group" := SalesHeader."WHT Posting Group";
                "With-Holding Tax%" := SalesHeader."With-Holding Tax%";
            end;
        end;

        [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
        local procedure OnAfterUpdateSalesAmountsDone(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
        begin
            with SalesLine do begin
                Validate("With-Holding Tax%");
            end;
        end;
    */
}

