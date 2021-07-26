Codeunit 52000012 "Gen. Jnl.-Post Line12"
{

    trigger OnRun()
    begin

        //  OBJECT Modification "Gen. Jnl.-Post Line"(Codeunit 12)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=05092020D;
        //      Time=113412T;
        //      Modified=Yes;
        //      Version List=NAVW114.06;
        //    }
        //    PROPERTIES
        //    {
        //      Target="Gen. Jnl.-Post Line"(Codeunit 12);
        //    }
        //    CHANGES
        //    {
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          SalesSetup.GET;
        //                                          WITH GenJnlLine DO BEGIN
        //                                            Cust.GET("Account No.");
        //                                          #4..52
        //                                            CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        //                                            CustLedgEntry."Amount to Apply" := 0;
        //                                            CustLedgEntry."Applies-to Doc. No." := '';
        //                                            CustLedgEntry."Applies-to ID" := '';
        //                                            IF SalesSetup."Copy Customer Name to Entries" THEN
        //                                              CustLedgEntry."Customer Name" := Cust.Name;
        //                                            OnBeforeCustLedgEntryInsert(CustLedgEntry,GenJnlLine);
        //                                          #60..75
        //                                          END;
        //  
        //                                          OnAfterPostCust(GenJnlLine,Balancing,TempGLEntryBuf,NextEntryNo,NextTransactionNo);
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..55
        //                                          #57..78
        //                                        END;
        //  
        //                           Target=PostCust(PROCEDURE 12) }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          PurchSetup.GET;
        //                                          WITH GenJnlLine DO BEGIN
        //                                            Vend.GET("Account No.");
        //                                          #4..54
        //                                            VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        //                                            VendLedgEntry."Amount to Apply" := 0;
        //                                            VendLedgEntry."Applies-to Doc. No." := '';
        //                                            VendLedgEntry."Applies-to ID" := '';
        //                                            IF PurchSetup."Copy Vendor Name to Entries" THEN
        //                                              VendLedgEntry."Vendor Name" := Vend.Name;
        //                                            OnBeforeVendLedgEntryInsert(VendLedgEntry,GenJnlLine);
        //                                          #62..73
        //                                          END;
        //  
        //                                          OnAfterPostVend(GenJnlLine,Balancing,TempGLEntryBuf,NextEntryNo,NextTransactionNo);
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..57
        //                                          #59..76
        //                                        END;
        //  
        //                           Target=PostVend(PROCEDURE 13) }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          WITH GenJnlLine DO BEGIN
        //                                            Employee.GET("Account No.");
        //                                            Employee.CheckBlockedEmployeeOnJnls(TRUE);
        //                                          #4..28
        //                                            EmployeeLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
        //                                            EmployeeLedgerEntry."Amount to Apply" := 0;
        //                                            EmployeeLedgerEntry."Applies-to Doc. No." := '';
        //                                            EmployeeLedgerEntry."Applies-to ID" := '';
        //                                            EmployeeLedgerEntry.INSERT(TRUE);
        //  
        //                                            // Post detailed employee entries
        //                                          #36..41
        //  
        //                                            OnMoveGenJournalLine(EmployeeLedgerEntry.RECORDID);
        //                                          END;
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..31
        //                                          #33..44
        //                                        END;
        //  
        //                           Target=PostEmployee(PROCEDURE 86) }
        //      { Insertion         ;Target=PostBankAcc(PROCEDURE 14);
        //                           InsertAfter=BankAccPostingGr(Variable 1001);
        //                           ChangedElements=VariableCollection
        //                           {
        //                             GenJnlLineHook@52092135 : Codeunit "GenJnline Hook";
        //                           }
        //                            }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          WITH GenJnlLine DO BEGIN
        //                                            BankAcc.GET("Account No.");
        //                                            BankAcc.TESTFIELD(Blocked,FALSE);
        //                                          #4..8
        //  
        //                                            BankAcc.TESTFIELD("Bank Acc. Posting Group");
        //                                            BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group");
        //  
        //                                            BankAccLedgEntry.LOCKTABLE;
        //  
        //                                            OnPostBankAccOnBeforeInitBankAccLedgEntry(GenJnlLine,CurrencyFactor,NextEntryNo,NextTransactionNo);
        //                                          #16..45
        //                                                    CheckLedgEntry.SETRANGE("Bank Account No.","Account No.");
        //                                                    CheckLedgEntry.SETRANGE("Entry Status",CheckLedgEntry."Entry Status"::Printed);
        //                                                    CheckLedgEntry.SETRANGE("Check No.","Document No.");
        //                                                    IF CheckLedgEntry.FINDSET THEN
        //                                                      REPEAT
        //                                                        CheckLedgEntry2 := CheckLedgEntry;
        //                                          #52..97
        //                                            DeferralPosting("Deferral Code","Source Code",BankAccPostingGr."G/L Bank Account No.",GenJnlLine,Balancing);
        //                                            OnMoveGenJournalLine(BankAccLedgEntry.RECORDID);
        //                                          END;
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..11
        //                                          #13..48
        //                                                    GenJnlLineHook.FilterCheckLedgerOnGenJnlPostLine(GenJnlLine,CheckLedgEntry);
        //                                          #49..100
        //                                        END;
        //  
        //                           Target=PostBankAcc(PROCEDURE 14) }
        //      { Deletion          ;Target=CalcPmtDiscPossible(PROCEDURE 71).PaymentDiscountDateWithGracePeriod(Variable 1002);
        //                           ChangedElements=VariableCollection
        //                           {
        //                             PaymentDiscountDateWithGracePeriod@1002 : Date;
        //                           }
        //                            }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          WITH GenJnlLine DO
        //                                            IF "Amount (LCY)" <> 0 THEN BEGIN
        //                                              PaymentDiscountDateWithGracePeriod := CVLedgEntryBuf."Pmt. Discount Date";
        //                                              GLSetup.GetRecordOnce;
        //                                              IF PaymentDiscountDateWithGracePeriod <> 0D THEN
        //                                                PaymentDiscountDateWithGracePeriod :=
        //                                                  CALCDATE(GLSetup."Payment Discount Grace Period",PaymentDiscountDateWithGracePeriod);
        //                                              IF (PaymentDiscountDateWithGracePeriod >= CVLedgEntryBuf."Posting Date") OR
        //                                                 (PaymentDiscountDateWithGracePeriod = 0D)
        //                                              THEN BEGIN
        //                                                IF GLSetup."Pmt. Disc. Excl. VAT" THEN BEGIN
        //                                                  IF "Sales/Purch. (LCY)" = 0 THEN
        //                                                    CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
        //                                                      ("Amount (LCY)" + TotalVATAmountOnJnlLines(GenJnlLine)) * Amount / "Amount (LCY)"
        //                                                  ELSE
        //                                                    CVLedgEntryBuf."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * Amount / "Amount (LCY)"
        //                                                END ELSE
        //                                                  CVLedgEntryBuf."Original Pmt. Disc. Possible" := Amount;
        //                                                CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
        //                                                  ROUND(
        //                                                    CVLedgEntryBuf."Original Pmt. Disc. Possible" * "Payment Discount %" / 100,AmountRoundingPrecision);
        //                                              END;
        //                                              CVLedgEntryBuf."Remaining Pmt. Disc. Possible" := CVLedgEntryBuf."Original Pmt. Disc. Possible";
        //                                            END;
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          WITH GenJnlLine DO
        //                                            IF "Amount (LCY)" <> 0 THEN BEGIN
        //                                              IF (CVLedgEntryBuf."Pmt. Discount Date" >= CVLedgEntryBuf."Posting Date") OR
        //                                                 (CVLedgEntryBuf."Pmt. Discount Date" = 0D)
        //                                          #10..24
        //                                        END;
        //  
        //                           Target=CalcPmtDiscPossible(PROCEDURE 71) }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          CASE VATEntry2."VAT Calculation Type" OF
        //                                            VATEntry2."VAT Calculation Type"::"Normal VAT",
        //                                            VATEntry2."VAT Calculation Type"::"Full VAT":
        //                                          #4..31
        //                                                VATAmount :=
        //                                                  ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
        //                                                VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
        //                                                IF PmtDiscLCY2 = 0 THEN
        //                                                  PmtDiscAddCurr2 := 0
        //                                              END;
        //                                            VATEntry2."VAT Calculation Type"::"Sales Tax":
        //                                              IF (VATEntry2.Type = VATEntry2.Type::Purchase) AND VATEntry2."Use Tax" THEN BEGIN
        //                                          #40..64
        //                                                  VATAmountAddCurr := 0;
        //                                                END;
        //                                          END;
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..34
        //                                          #37..67
        //                                        END;
        //  
        //                           Target=CalcPmtDiscVATAmounts(PROCEDURE 129) }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          IF NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf."Currency Code" THEN
        //                                            EXIT;
        //  
        //                                          ApplnRounding := -(NewCVLedgEntryBuf."Remaining Amount" + OldCVLedgEntryBuf."Remaining Amount");
        //                                          #5..9
        //                                          DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
        //                                            GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
        //                                            DtldCVLedgEntryBuf."Entry Type"::"Appln. Rounding",ApplnRounding,ApplnRoundingLCY,ApplnRounding,0,0,0);
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          IF ((NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Payment) AND
        //                                              (NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."Document Type"::Refund)) OR
        //                                             (NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf."Currency Code")
        //                                          THEN
        //                                          #2..12
        //                                        END;
        //  
        //                           Target=CalcCurrencyApplnRounding(PROCEDURE 51) }
        //      { Insertion         ;Target=GetApplnRoundPrecision(PROCEDURE 92);
        //                           InsertAfter=ApplnCurrency(Variable 1000);
        //                           ChangedElements=VariableCollection
        //                           {
        //                             CurrencyCode@1005 : Code[10];
        //                           }
        //                            }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          IF NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf."Currency Code" THEN
        //                                            EXIT(0);
        //  
        //                                          ApplnCurrency.Initialize(NewCVLedgEntryBuf."Currency Code");
        //                                          IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
        //                                            EXIT(ApplnCurrency."Appln. Rounding Precision");
        //  
        //                                          GetGLSetup;
        //                                          EXIT(GLSetup."Appln. Rounding Precision");
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          IF NewCVLedgEntryBuf."Currency Code" <> '' THEN
        //                                            CurrencyCode := NewCVLedgEntryBuf."Currency Code"
        //                                          ELSE
        //                                            CurrencyCode := OldCVLedgEntryBuf."Currency Code";
        //                                          IF CurrencyCode = '' THEN
        //                                            EXIT(0);
        //                                          ApplnCurrency.GET(CurrencyCode);
        //                                          IF ApplnCurrency."Appln. Rounding Precision" <> 0 THEN
        //                                            EXIT(ApplnCurrency."Appln. Rounding Precision");
        //                                          EXIT(GLSetup."Appln. Rounding Precision");
        //                                        END;
        //  
        //                           Target=GetApplnRoundPrecision(PROCEDURE 92) }
        //      { PropertyModification;
        //                           Property=Version List;
        //                           OriginalValue=NAVW114.22;
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

    end;
}

