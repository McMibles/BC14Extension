Codeunit 52000057 "Document Totals57"
{
    var
        SalesSetup: Record "Sales & Receivables Setup";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        PreviousTotalSalesHeader: Record "Sales Header";
        PreviousTotalPurchaseHeader: Record "Purchase Header";
        SalesCalcDiscount: Codeunit "Sales-Calc. Discount";
        PurchCalcDiscount: Codeunit "Purch.-Calc.Discount";
        ForceTotalsRecalculation: Boolean;
        PreviousTotalSalesVATDifference: Decimal;
        PreviousTotalPurchVATDifference: Decimal;
        SalesLinesExist: Boolean;
        PurchaseLinesExist: Boolean;
        TotalsUpToDate: Boolean;
        NeedRefreshSalesLine: Boolean;
        NeedRefreshPurchaseLine: Boolean;
        TotalVATLbl: Label 'Total VAT';
        TotalAmountInclVatLbl: Label 'Total Incl. VAT';
        TotalAmountExclVATLbl: Label 'Total Excl. VAT';
        InvoiceDiscountAmountLbl: Label 'Invoice Discount Amount';
        RefreshMsgTxt: Label 'Totals or discounts may not be up-to-date. Choose the link to update.';
        TotalLineAmountLbl: Label 'Subtotal';
        TotalWHTAmoutLbl: Label 'Total WHT';
    /*
        Procedure CalculateSalesPageTotals(VAR TotalSalesLine: Record "Sales Line"; VAR VATAmount: Decimal; VAR SalesLine: Record "Sales Line")
        var
            TotalSalesLine2: Record "Sales Line";
        begin
            TotalSalesLine2 := TotalSalesLine;
            TotalSalesLine2.SETRANGE("Document Type", SalesLine."Document Type");
            TotalSalesLine2.SETRANGE("Document No.", SalesLine."Document No.");
            OnAfterSalesLineSetFilters(TotalSalesLine2, SalesLine);
            TotalSalesLine2.CALCSUMS("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount", "With-Holding Tax Amt");
            VATAmount := TotalSalesLine2."Amount Including VAT" - TotalSalesLine2.Amount;
            TotalSalesLine := TotalSalesLine2;
        end;

        Procedure CalculateSalesSubPageTotals(VAR TotalSalesHeader: Record "Sales Header"; VAR TotalSalesLine: Record "Sales Line"; VAR VATAmount: Decimal; VAR InvoiceDiscountAmount: Decimal; VAR InvoiceDiscountPct: Decimal)
        var
            SalesLine2: Record "Sales Line";
            TotalSalesLine2: Record "Sales Line";
        begin
            IF TotalsUpToDate THEN
                EXIT;
            TotalsUpToDate := TRUE;
            NeedRefreshSalesLine := FALSE;

            SalesSetup.GetRecordOnce;
            TotalSalesLine2.COPY(TotalSalesLine);
            TotalSalesLine2.RESET;
            TotalSalesLine2.SETRANGE("Document Type", TotalSalesHeader."Document Type");
            TotalSalesLine2.SETRANGE("Document No.", TotalSalesHeader."No.");
            OnCalculateSalesSubPageTotalsOnAfterSetFilters(TotalSalesLine2, TotalSalesHeader);

            IF SalesSetup."Calc. Inv. Discount" AND (TotalSalesHeader."No." <> '') AND
               (TotalSalesHeader."Customer Posting Group" <> '')
            THEN BEGIN
                TotalSalesHeader.CALCFIELDS("Recalculate Invoice Disc.");
                IF TotalSalesHeader."Recalculate Invoice Disc." THEN
                    IF TotalSalesLine2.FINDFIRST THEN BEGIN
                        SalesCalcDiscount.CalculateInvoiceDiscountOnLine(TotalSalesLine2);
                        NeedRefreshSalesLine := TRUE;
                    END;
            END;

            TotalSalesLine2.CALCSUMS(Amount, "Amount Including VAT", "Line Amount", "Inv. Discount Amount", "With-Holding Tax Amt");
            VATAmount := TotalSalesLine2."Amount Including VAT" - TotalSalesLine2.Amount;
            InvoiceDiscountAmount := TotalSalesLine2."Inv. Discount Amount";

            IF (InvoiceDiscountAmount = 0) OR (TotalSalesLine2."Line Amount" = 0) THEN
                InvoiceDiscountPct := 0
            ELSE
                WITH TotalSalesHeader DO
                    CASE "Invoice Discount Calculation" OF
                        "Invoice Discount Calculation"::"%":
                            InvoiceDiscountPct := "Invoice Discount Value";
                        "Invoice Discount Calculation"::None,
                        "Invoice Discount Calculation"::Amount:
                            BEGIN
                                SalesLine2.COPYFILTERS(TotalSalesLine2);
                                SalesLine2.SETRANGE("Allow Invoice Disc.", TRUE);
                                SalesLine2.CALCSUMS("Line Amount");
                                InvoiceDiscountPct := ROUND(InvoiceDiscountAmount / SalesLine2."Line Amount" * 100, 0.00001);
                            END;
                    END;

            OnAfterCalculateSalesSubPageTotals(
              TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct, TotalSalesLine2);

            TotalSalesLine := TotalSalesLine2;
        end;

        Procedure CalculatePostedSalesInvoiceTotals(VAR SalesInvoiceHeader: Record "Sales Invoice Header"; VAR VATAmount: Decimal; SalesInvoiceLine: Record "Sales Invoice Line")

        begin
            IF SalesInvoiceHeader.GET(SalesInvoiceLine."Document No.") THEN BEGIN
                SalesInvoiceHeader.CALCFIELDS(Amount, "Amount Including VAT", "Invoice Discount Amount", "With-Holding Tax Amt");
                VATAmount := SalesInvoiceHeader."Amount Including VAT" - SalesInvoiceHeader.Amount;
            END;
        end;

        Procedure CalculatePostedSalesCreditMemoTotals(VAR SalesCrMemoHeader: Record "Sales Cr.Memo Header"; VAR VATAmount: Decimal; SalesCrMemoLine: Record "Sales Cr.Memo Line")
        var

        begin
            IF SalesCrMemoHeader.GET(SalesCrMemoLine."Document No.") THEN BEGIN
                SalesCrMemoHeader.CALCFIELDS(Amount, "Amount Including VAT", "Invoice Discount Amount", "With-Holding Tax Amt");
                VATAmount := SalesCrMemoHeader."Amount Including VAT" - SalesCrMemoHeader.Amount;
            END;
        end;

        Procedure SalesDeltaUpdateTotals()
        var
            InvDiscountBaseAmount: Decimal;
        begin
            TotalSalesLine."Line Amount" += SalesLine."Line Amount" - xSalesLine."Line Amount";
            TotalSalesLine."Amount Including VAT" += SalesLine."Amount Including VAT" - xSalesLine."Amount Including VAT";
            TotalSalesLine.Amount += SalesLine.Amount - xSalesLine.Amount;
            TotalSalesLine."With-Holding Tax Amt" += SalesLine."With-Holding Tax Amt" - xSalesLine."With-Holding Tax Amt";
            VATAmount := TotalSalesLine."Amount Including VAT" - TotalSalesLine.Amount;
            IF SalesLine."Inv. Discount Amount" <> xSalesLine."Inv. Discount Amount" THEN BEGIN
                IF (InvoiceDiscountPct > -0.01) AND (InvoiceDiscountPct < 0.01) THEN // To avoid decimal overflow later
                    InvDiscountBaseAmount := 0
                ELSE
                    InvDiscountBaseAmount := InvoiceDiscountAmount / InvoiceDiscountPct * 100;
                InvoiceDiscountAmount += SalesLine."Inv. Discount Amount" - xSalesLine."Inv. Discount Amount";
                IF (InvoiceDiscountAmount = 0) OR (InvDiscountBaseAmount = 0) THEN
                    InvoiceDiscountPct := 0
                ELSE
                    InvoiceDiscountPct := ROUND(100 * InvoiceDiscountAmount / InvDiscountBaseAmount, 0.00001);
            END;

        end;

        Local Procedure PurchaseUpdateTotals(VAR PurchaseHeader: Record "Purchase Header"; CurrentPurchaseLine: Record "Purchase Line"; VAR TotalsPurchaseLine: Record "Purchase Line"; VAR VATAmount: Decimal; Force: Boolean): Boolean
        var
            myInt: Integer;
        begin
            PurchaseHeader.CALCFIELDS(Amount, "Amount Including VAT", "Invoice Discount Amount", "With-Holding Tax Amt");

            IF (PreviousTotalPurchaseHeader.Amount = PurchaseHeader.Amount) AND
               (PreviousTotalPurchaseHeader."Amount Including VAT" = PurchaseHeader."Amount Including VAT") AND
               (PreviousTotalPurchVATDifference = CalcTotalPurchVATDifference(PurchaseHeader))
            THEN
                EXIT(TRUE);

            IF NOT Force THEN
                IF NOT PurchaseCheckNumberOfLinesLimit(PurchaseHeader) THEN
                    EXIT(FALSE);

            PurchaseCalculateTotalsWithInvoiceRounding(CurrentPurchaseLine, VATAmount, TotalsPurchaseLine);
            EXIT(TRUE);

        end;

        Procedure PurchaseDeltaUpdateTotals(VAR PurchaseLine: Record "Purchase Line"; VAR xPurchaseLine: Record "Purchase Line"; VAR TotalPurchaseLine: Record "Purchase Line"; VAR VATAmount: Decimal; VAR InvoiceDiscountAmount: Decimal; VAR InvoiceDiscountPct: Decimal)
        var
            InvDiscountBaseAmount: Decimal;
        begin
            TotalPurchaseLine."Line Amount" += PurchaseLine."Line Amount" - xPurchaseLine."Line Amount";
            TotalPurchaseLine."Amount Including VAT" += PurchaseLine."Amount Including VAT" - xPurchaseLine."Amount Including VAT";
            TotalPurchaseLine.Amount += PurchaseLine.Amount - xPurchaseLine.Amount;
            TotalPurchaseLine."With-Holding Tax Amt" += PurchaseLine."With-Holding Tax Amt" - xPurchaseLine."With-Holding Tax Amt";
            VATAmount := TotalPurchaseLine."Amount Including VAT" - TotalPurchaseLine.Amount;
            IF PurchaseLine."Inv. Discount Amount" <> xPurchaseLine."Inv. Discount Amount" THEN BEGIN
                IF (InvoiceDiscountPct > -0.01) AND (InvoiceDiscountPct < 0.01) THEN // To avoid decimal overflow later
                    InvDiscountBaseAmount := 0
                ELSE
                    InvDiscountBaseAmount := InvoiceDiscountAmount / InvoiceDiscountPct * 100;
                InvoiceDiscountAmount += PurchaseLine."Inv. Discount Amount" - xPurchaseLine."Inv. Discount Amount";
                IF (InvoiceDiscountAmount = 0) OR (InvDiscountBaseAmount = 0) THEN
                    InvoiceDiscountPct := 0
                ELSE
                    InvoiceDiscountPct := ROUND(100 * InvoiceDiscountAmount / InvDiscountBaseAmount, 0.00001);
            END;
        end;
           */
    //      { CodeModification  ;OriginalCode=BEGIN
    //                                          TotalPurchaseLine2 := TotalPurchaseLine;
    //                                          TotalPurchaseLine2.SETRANGE("Document Type",PurchaseLine."Document Type");
    //                                          TotalPurchaseLine2.SETRANGE("Document No.",PurchaseLine."Document No.");
    //                                          OnAfterPurchaseLineSetFilters(TotalPurchaseLine2,PurchaseLine);
    //                                          TotalPurchaseLine2.CALCSUMS("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount");
    //                                          VATAmount := TotalPurchaseLine2."Amount Including VAT" - TotalPurchaseLine2.Amount;
    //                                          TotalPurchaseLine := TotalPurchaseLine2;
    //                                        END;
    //  
    //                           ModifiedCode=BEGIN
    //                                          #1..4
    //                                          TotalPurchaseLine2.CALCSUMS("Line Amount",Amount,"Amount Including VAT","Inv. Discount Amount","With-Holding Tax Amt");
    //                                          VATAmount := TotalPurchaseLine2."Amount Including VAT" - TotalPurchaseLine2.Amount;
    //                                          TotalPurchaseLine := TotalPurchaseLine2;
    //                                        END;
    //  
    //                           Target=CalculatePurchasePageTotals(PROCEDURE 52) }
    //      { CodeModification  ;OriginalCode=BEGIN
    //                                          IF TotalsUpToDate THEN
    //                                            EXIT;
    //                                          TotalsUpToDate := TRUE;
    //                                          #4..19
    //                                              END;
    //                                          END;
    //  
    //                                          TotalPurchaseLine2.CALCSUMS(Amount,"Amount Including VAT","Line Amount","Inv. Discount Amount");
    //                                          VATAmount := TotalPurchaseLine2."Amount Including VAT" - TotalPurchaseLine2.Amount;
    //                                          InvoiceDiscountAmount := TotalPurchaseLine2."Inv. Discount Amount";
    //  
    //                                          IF (InvoiceDiscountAmount = 0) OR (TotalPurchaseLine2."Line Amount" = 0) THEN BEGIN
    //                                            InvoiceDiscountPct := 0;
    //                                            TotalPurchaseHeader."Invoice Discount Value" := 0;
    //                                          END ELSE
    //                                            WITH TotalPurchaseHeader DO
    //                                              CASE "Invoice Discount Calculation" OF
    //                                                "Invoice Discount Calculation"::"%":
    //                                          #34..38
    //                                                    PurchaseLine2.SETRANGE("Allow Invoice Disc.",TRUE);
    //                                                    PurchaseLine2.CALCSUMS("Line Amount");
    //                                                    InvoiceDiscountPct := ROUND(InvoiceDiscountAmount / PurchaseLine2."Line Amount" * 100,0.00001);
    //                                                    "Invoice Discount Value" := InvoiceDiscountAmount;
    //                                                  END;
    //                                              END;
    //  
    //                                          OnAfterCalculatePurchaseSubPageTotals(
    //                                            TotalPurchaseHeader,TotalPurchaseLine,VATAmount,InvoiceDiscountAmount,InvoiceDiscountPct,TotalPurchaseLine2);
    //  
    //                                          TotalPurchaseLine := TotalPurchaseLine2;
    //                                        END;
    //  
    //                           ModifiedCode=BEGIN
    //                                          #1..22
    //                                          TotalPurchaseLine2.CALCSUMS(Amount,"Amount Including VAT","Line Amount","Inv. Discount Amount","With-Holding Tax Amt");
    //                                          #24..26
    //                                          IF (InvoiceDiscountAmount = 0) OR (TotalPurchaseLine2."Line Amount" = 0) THEN
    //                                            InvoiceDiscountPct := 0
    //                                          ELSE
    //                                          #31..41
    //                                          #43..49
    //                                        END;
    //  
    //                           Target=CalculatePurchaseSubPageTotals(PROCEDURE 42) }
    //      { CodeModification  ;OriginalCode=BEGIN
    //                                          IF PurchInvHeader.GET(PurchInvLine."Document No.") THEN BEGIN
    //                                            PurchInvHeader.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount");
    //                                            VATAmount := PurchInvHeader."Amount Including VAT" - PurchInvHeader.Amount;
    //                                          END;
    //                                        END;
    //  
    //                           ModifiedCode=BEGIN
    //                                          IF PurchInvHeader.GET(PurchInvLine."Document No.") THEN BEGIN
    //                                            PurchInvHeader.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount","With-Holding Tax Amt");
    //                                            VATAmount := PurchInvHeader."Amount Including VAT" - PurchInvHeader.Amount;
    //                                          END;
    //                                        END;
    //  
    //                           Target=CalculatePostedPurchInvoiceTotals(PROCEDURE 5) }
    //      { CodeModification  ;OriginalCode=BEGIN
    //                                          IF PurchCrMemoHdr.GET(PurchCrMemoLine."Document No.") THEN BEGIN
    //                                            PurchCrMemoHdr.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount");
    //                                            VATAmount := PurchCrMemoHdr."Amount Including VAT" - PurchCrMemoHdr.Amount;
    //                                          END;
    //                                        END;
    //  
    //                           ModifiedCode=BEGIN
    //                                          IF PurchCrMemoHdr.GET(PurchCrMemoLine."Document No.") THEN BEGIN
    //                                            PurchCrMemoHdr.CALCFIELDS(Amount,"Amount Including VAT","Invoice Discount Amount","With-Holding Tax Amt");
    //                                            VATAmount := PurchCrMemoHdr."Amount Including VAT" - PurchCrMemoHdr.Amount;
    //                                          END;
    //                                        END;
    //  
    //                           Target=CalculatePostedPurchCreditMemoTotals(PROCEDURE 7) }
    //      { Deletion          ;Target=GetTotalSalesHeaderAndCurrency(PROCEDURE 138).SalesHeader(Variable 1003);
    //                           ChangedElements=VariableCollection
    //                           {
    //                             SalesHeader@1003 : Record "Sales Header";
    //                           }
    //                            }
    //      { CodeModification  ;OriginalCode=BEGIN
    //                                          IF NOT SalesLinesExist THEN
    //                                            SalesLinesExist := NOT SalesLine.ISEMPTY;
    //                                          IF NOT SalesLinesExist OR
    //                                          #4..12
    //                                            CLEAR(Currency);
    //                                            Currency.Initialize(TotalSalesHeader."Currency Code");
    //                                          END;
    //                                          IF SalesHeader.GET(TotalSalesHeader."Document Type",TotalSalesHeader."No.") THEN
    //                                            IF SalesHeader."Invoice Discount Value" <> TotalSalesHeader."Invoice Discount Value" THEN
    //                                              TotalsUpToDate := FALSE;
    //                                        END;
    //  
    //                           ModifiedCode=BEGIN
    //                                          #1..15
    //                                        END;
    //  
    //                           Target=GetTotalSalesHeaderAndCurrency(PROCEDURE 138) }
    //      { Deletion          ;Target=GetTotalPurchaseHeaderAndCurrency(PROCEDURE 46).PurchaseHeader(Variable 1003);
    //                           ChangedElements=VariableCollection
    //                           {
    //                             PurchaseHeader@1003 : Record "Purchase Header";
    //                           }
    //                            }
    //      { CodeModification  ;OriginalCode=BEGIN
    //                                          IF NOT PurchaseLinesExist THEN
    //                                            PurchaseLinesExist := NOT PurchaseLine.ISEMPTY;
    //                                          IF NOT PurchaseLinesExist OR
    //                                          #4..13
    //                                            CLEAR(Currency);
    //                                            Currency.Initialize(TotalPurchaseHeader."Currency Code");
    //                                          END;
    //                                          IF PurchaseHeader.GET(TotalPurchaseHeader."Document Type",TotalPurchaseHeader."No.") THEN
    //                                            IF PurchaseHeader."Invoice Discount Value" <> TotalPurchaseHeader."Invoice Discount Value" THEN
    //                                              TotalsUpToDate := FALSE;
    //                                        END;
    //  
    //                           ModifiedCode=BEGIN
    //                                          #1..16
    //                                        END;
    //  
    //                           Target=GetTotalPurchaseHeaderAndCurrency(PROCEDURE 46) }
    //      { Insertion         ;InsertAfter=OnCalculateSalesSubPageTotalsOnAfterSetFilters(PROCEDURE 59);
    //                           ChangedElements=PROCEDURECollection
    //                           {
    //                             PROCEDURE GetTotalWHTCaption@60000(CurrencyCode@1000 : Code[10]) : Text;
    //                             BEGIN
    //                               EXIT(GetCaptionClassWithCurrencyCode(TotalWHTAmoutLbl,CurrencyCode));
    //                             END;
    //  
    //                             PROCEDURE CalculateVoucherTotals@60001(VAR TotalPaymentLine@1000 : Record "Payment Line";VAR PaymentLine@1001 : Record "Payment Line");
    //                             BEGIN
    //                               TotalPaymentLine.SETRANGE("Document Type",PaymentLine."Document Type");
    //                               TotalPaymentLine.SETRANGE("Document No.",PaymentLine."Document No.");
    //                               TotalPaymentLine.CALCSUMS(Amount,"WHT Amount");
    //                             END;
    //  
    //                           }
    //                            }
    //      { Insertion         ;InsertAfter=NeedRefreshPurchaseLine(Variable 1019);
    //                           ChangedElements=VariableCollection
    //                           {
    //                             TotalWHTAmoutLbl@60000 : TextConst 'ENU=Total WHT';
    //                           }
    //                            }
    //      { PropertyModification;
    //                           Property=Version List;
    //                           OriginalValue=NAVW114.21;
    //                           ModifiedValue=NAVW114.06 }
    //    }
    //    CODE
    //    {
    //  
    //      BEGIN
    //      END.
    //    }
    //  }
    //  
    //  

    //end;
}

