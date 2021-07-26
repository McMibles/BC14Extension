Codeunit 52000225 "Gen. Jnl.-Apply225"
{
    var
        GenJnlLine: Record "Gen. Journal Line";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        WHTMgt: Codeunit "WHT Management";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        AccNo: Code[20];
        CurrencyCode2: Code[10];
        EntrySelected: Boolean;
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        Text000: Label 'You must specify %1 or %2.';
        ConfirmChangeQst: Label 'CurrencyCode in the %1 will be changed from %2 to %3.\Do you wish to continue?';
        UpdateInterruptedErr: Label 'The update has been interrupted to respect the warning.';
        Text005: Label 'The %1 or %2 must be Customer or Vendor.';
        Text006: Label 'All entries in one application must be in the same currency.';
        Text007: Label 'All entries in one application must be in the same currency or one or more of the EMU currencies.';

    Local Procedure UpdateVendLedgEntry(VAR
                                            VendLedgEntry: Record "Vendor Ledger Entry")
    var

    begin
        WITH GenJnlLine DO BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            VendLedgEntry."Remaining Amount" :=
              CurrExchRate.ExchangeAmount(
                VendLedgEntry."Remaining Amount", VendLedgEntry."Currency Code", "Currency Code", "Posting Date");
            VendLedgEntry."Remaining Amount" :=
              ROUND(VendLedgEntry."Remaining Amount", Currency."Amount Rounding Precision");
            VendLedgEntry."Remaining Pmt. Disc. Possible" :=
              CurrExchRate.ExchangeAmount(
                VendLedgEntry."Remaining Pmt. Disc. Possible", VendLedgEntry."Currency Code", "Currency Code", "Posting Date");
            VendLedgEntry."Remaining Pmt. Disc. Possible" :=
              ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible", Currency."Amount Rounding Precision");
            WHTMgt.GetVendWHTAmount(VendLedgEntry, GenJnlLine, DATABASE::"Gen. Journal Line");
            VendLedgEntry."Amount to Apply" :=
              CurrExchRate.ExchangeAmount(
                VendLedgEntry."Amount to Apply", VendLedgEntry."Currency Code", "Currency Code", "Posting Date");
            VendLedgEntry."Amount to Apply" :=
              ROUND(VendLedgEntry."Amount to Apply", Currency."Amount Rounding Precision");
        END;
    end;


    //  OBJECT Modification "Gen. Jnl.-Apply"(Codeunit 225)
    //  {
    //    OBJECT-PROPERTIES
    //    {
    //      Date=04242020D;
    //      Time=143104T;
    //      Modified=Yes;
    //      Version List=NAVW114.08;
    //    }
    //    PROPERTIES
    //    {
    //      Target="Gen. Jnl.-Apply"(Codeunit 225);
    //    }
    //    CHANGES
    //    {
    //      { CodeModification  ;OriginalCode=BEGIN
    //                                          WITH GenJnlLine DO BEGIN
    //                                            VendLedgEntry.CALCFIELDS("Remaining Amount");
    //                                            VendLedgEntry."Remaining Amount" :=
    //                                          #4..9
    //                                                VendLedgEntry."Remaining Pmt. Disc. Possible",VendLedgEntry."Currency Code","Currency Code","Posting Date");
    //                                            VendLedgEntry."Remaining Pmt. Disc. Possible" :=
    //                                              ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible",Currency."Amount Rounding Precision");
    //                                            VendLedgEntry."Amount to Apply" :=
    //                                              CurrExchRate.ExchangeAmount(
    //                                                VendLedgEntry."Amount to Apply",VendLedgEntry."Currency Code","Currency Code","Posting Date");
    //                                            VendLedgEntry."Amount to Apply" :=
    //                                              ROUND(VendLedgEntry."Amount to Apply",Currency."Amount Rounding Precision");
    //                                          END;
    //                                        END;
    //  
    //                           ModifiedCode=BEGIN
    //                                          #1..12
    //                                            WHTMgt.GetVendWHTAmount(VendLedgEntry,GenJnlLine,DATABASE::"Gen. Journal Line");
    //                                          #13..18
    //                                        END;
    //  
    //                           Target=UpdateVendLedgEntry(PROCEDURE 7) }
    //      { CodeModification  ;OriginalCode=BEGIN
    //                                          WITH GenJnlLine DO BEGIN
    //                                            EntrySelected := SelectVendLedgEntry(GenJnlLine);
    //                                            IF NOT EntrySelected THEN
    //                                              EXIT;
    //  
    //                                            VendLedgEntry.RESET;
    //                                            VendLedgEntry.SETCURRENTKEY("Vendor No.",Open,Positive);
    //                                            VendLedgEntry.SETRANGE("Vendor No.",AccNo);
    //                                          #9..33
    //                                              END ELSE
    //                                                REPEAT
    //                                                  CheckAgainstApplnCurrency(CurrencyCode2,VendLedgEntry."Currency Code",AccType::Vendor,TRUE);
    //                                                UNTIL VendLedgEntry.NEXT = 0;
    //                                              IF "Currency Code" <> CurrencyCode2 THEN
    //                                                IF Amount = 0 THEN BEGIN
    //                                          #40..51
    //                                            IF Amount <> 0 THEN
    //                                              IF NOT PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) THEN
    //                                                EXIT;
    //                                          END;
    //                                        END;
    //  
    //                           ModifiedCode=BEGIN
    //                                          #1..5
    //                                            WHTMgt.ResetWHTJnlBuffer(GenJnlLine);
    //                                          #6..36
    //                                                  WHTMgt.GetVendWHTAmount(VendLedgEntry,GenJnlLine,DATABASE::"Gen. Journal Line");
    //                                          #37..54
    //                                            WHTMgt.CreateWHTJnlLine(GenJnlLine,0);
    //                                          END;
    //                                        END;
    //  
    //                           Target=ApplyVendorLedgerEntry(PROCEDURE 24) }
    //      { Insertion         ;InsertAfter=PaymentToleranceMgt(Variable 1007);
    //                           ChangedElements=VariableCollection
    //                           {
    //                             WHTMgt@1002 : Codeunit "WHT Management";
    //                           }
    //                            }
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

}

