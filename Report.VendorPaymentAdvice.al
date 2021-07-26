Report 52130425 "Vendor Payment Advice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor Payment Advice.rdlc';

    dataset
    {
        dataitem("Posted Payment Header";"Posted Payment Header")
        {
            CalcFields = Amount,"WHT Amount";
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const("Payment Voucher"),"Payment Type"=const("Supp. Invoice"));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Posted_Payment_No;"Posted Payment Header"."No.")
            {
            }
            column(Posted_Payment_Currency;"Posted Payment Header"."Currency Code")
            {
            }
            column(Posted_Payment_Posting_Date;Format("Posted Payment Header"."Payment Date"))
            {
            }
            column(Posted_Payment_Method;"Posted Payment Header"."Payment Method")
            {
            }
            column(Payee;"Posted Payment Header".Payee)
            {
            }
            column(Payee_Bank_Code;"Posted Payment Header"."Payee Bank Code")
            {
            }
            column(Payee_Bank_Name;"Posted Payment Header"."Payee Bank Account Name")
            {
            }
            column(Payee_Bank_Account;"Posted Payment Header"."Payee Bank Account")
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Name;CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address;CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address_2;CompanyInfo."Address 2")
            {
            }
            column(CompanyInfo_City;CompanyInfo.City)
            {
            }
            column(CompanyInfo_Phone_No;CompanyInfo."Phone No.")
            {
            }
            column(Vendor_Address;Vendor.Address)
            {
            }
            column(Vendor_Address_2;Vendor."Address 2")
            {
            }
            column(Vendor_Phone_No;Vendor."Phone No.")
            {
            }
            column(AmountInWord_PaymentLine;AmountInWord[1] + ' '+AmountInWord[2])
            {
            }
            dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No."=field("Payee No.");
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                dataitem(DetailedVendorLedgEntry1;"Detailed Vendor Ledg. Entry")
                {
                    DataItemLink = "Applied Vend. Ledger Entry No."=field("Entry No.");
                    DataItemTableView = sorting("Applied Vend. Ledger Entry No.","Entry Type") where(Unapplied=const(false));
                    column(ReportForNavId_1; 1)
                    {
                    }
                    dataitem(VendLedgEntry1;"Vendor Ledger Entry")
                    {
                        DataItemLink = "Entry No."=field("Vendor Ledger Entry No.");
                        DataItemLinkReference = DetailedVendorLedgEntry1;
                        DataItemTableView = sorting("Entry No.");
                        column(ReportForNavId_10; 10)
                        {
                        }
                        column(PostingDate_VendLedgEntry1;Format("Posting Date"))
                        {
                        }
                        column(DocType_VendLedgEntry1;"Document Type")
                        {
                            IncludeCaption = true;
                        }
                        column(DocNo_VendLedgEntry1;"Document No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_VendLedgEntry1;Description)
                        {
                            IncludeCaption = true;
                        }
                        column(NegShowAmountVendLedgEntry1;-NegShowAmountVendLedgEntry1)
                        {
                        }
                        column(CurrCode_VendLedgEntry1;GetCurrencyCode("Currency Code"))
                        {
                        }
                        column(NegPmtDiscInvCurrVendLedgEntry1;-NegPmtDiscInvCurrVendLedgEntry1)
                        {
                        }
                        column(NegPmtTolInvCurrVendLedgEntry1;-NegPmtTolInvCurrVendLedgEntry1)
                        {
                        }
                        column(PO_No;"PO No.")
                        {
                        }
                        column(External_Document_No_VendLedgEntry1;"External Document No.")
                        {
                        }
                        column(VendLedgerEntry1_Remaining_Amount;Abs("Remaining Amount"))
                        {
                        }
                        column(VendLedgerEntry1_Original_Amount;Abs("Original Amount"))
                        {
                        }
                        column(WHTAmount;Abs(WHTAmount))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if "Entry No." = "Vendor Ledger Entry"."Entry No." then
                              CurrReport.Skip;
                            
                            NegPmtDiscInvCurrVendLedgEntry1 := 0;
                            NegPmtTolInvCurrVendLedgEntry1 := 0;
                            PmtDiscPmtCurr := 0;
                            PmtTolPmtCurr := 0;
                            WHTAmountLCY := 0;
                            WHTAmount := 0;
                            
                            WHTEntry.SetRange("Document No.","Vendor Ledger Entry"."Document No.");
                            WHTEntry.SetRange("Document Entry No.",VendLedgEntry1."Entry No.");
                            WHTEntry.CalcSums(WHTEntry."WHT Invoice Amount");
                            WHTAmount := WHTEntry."WHT Invoice Amount";
                            NegShowAmountVendLedgEntry1 := -DetailedVendorLedgEntry1.Amount;
                            
                            if "Vendor Ledger Entry"."Currency Code" <> "Currency Code" then begin
                              NegPmtDiscInvCurrVendLedgEntry1 := ROUND("Pmt. Disc. Rcd.(LCY)" * "Original Currency Factor");
                              NegPmtTolInvCurrVendLedgEntry1 := ROUND("Pmt. Tolerance (LCY)" * "Original Currency Factor");
                              AppliedAmount :=
                                ROUND(
                                  -DetailedVendorLedgEntry1.Amount / "Original Currency Factor" * "Original Currency Factor",
                                  Currency."Amount Rounding Precision");
                              //WHTAmount := ROUND(-WHTAmountLCY / "Original Currency Factor" * "Original Currency Factor",Currency."Amount Rounding Precision");
                            end else begin
                              NegPmtDiscInvCurrVendLedgEntry1 := ROUND("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                              NegPmtTolInvCurrVendLedgEntry1 := ROUND("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                              AppliedAmount := -DetailedVendorLedgEntry1.Amount;
                              //WHTAmount := -WHTAmountLCY;
                            end;
                            
                            PmtDiscPmtCurr := ROUND("Pmt. Disc. Rcd.(LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                            
                            PmtTolPmtCurr := ROUND("Pmt. Tolerance (LCY)" * "Vendor Ledger Entry"."Original Currency Factor");
                            
                            RemainingAmount := (RemainingAmount - AppliedAmount) + PmtDiscPmtCurr + PmtTolPmtCurr;
                            
                            /*IF "Posted Payment Header"."Payment Method" <> "Posted Payment Header"."Payment Method"::Cheque THEN
                              SETFILTER("Date Filter",'..%1',"Posted Payment Header"."Payment Date" - 1)
                            ELSE
                              SETFILTER("Date Filter",'..%1',CheckLedgerEntry."Posting Date" - 1);*/
                            CalcFields("Original Amount","Remaining Amount");

                        end;
                    }
                }

                trigger OnPreDataItem()
                begin
                    if "Posted Payment Header"."Payment Method" <> "Posted Payment Header"."payment method"::Cheque then
                      SetRange("Document No." ,"Posted Payment Header"."No.")
                    else begin
                      CheckLedgerEntry.Reset;
                      CheckLedgerEntry.SetRange("Check Entry No." ,"Posted Payment Header"."Cheque Entry No.");
                      if CheckLedgerEntry.FindFirst then
                        SetRange("Document No." ,CheckLedgerEntry."Document No.");
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TestField(Payee);
                Vendor.Get("Payee No.");

                if ("Currency Code" = '') then begin
                  GLSetup.TestField("LCY Code");
                  CurrencyCode := GLSetup."LCY Code";
                end else
                  CurrencyCode := "Currency Code";

                ConvertAmtToText.InitTextVariable;
                ConvertAmtToText.FormatNoText(AmountInWord,Abs(Amount - "WHT Amount"),"Currency Code",'');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(CompanyInfo.Picture);
        GLSetup.Get;
    end;

    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        WHTEntry: Record "WHT Entry";
        Vendor: Record Vendor;
        RemainingAmount: Decimal;
        Currency: Record Currency;
        AppliedAmount: Decimal;
        NegPmtDiscInvCurrVendLedgEntry1: Decimal;
        NegPmtTolInvCurrVendLedgEntry1: Decimal;
        PmtDiscPmtCurr: Decimal;
        PmtTolPmtCurr: Decimal;
        NegShowAmountVendLedgEntry1: Decimal;
        WHTAmount: Decimal;
        WHTAmountLCY: Decimal;
        AmountInWord: array [2] of Text;
        CurrencyCode: Code[10];
        ConvertAmtToText: Codeunit "Format No. to Text";
        CheckLedgerEntry: Record "Check Ledger Entry";

    local procedure GetCurrencyCode(SrcCurrCode: Code[10]): Code[10]
    begin
        if SrcCurrCode = '' then
          exit(GLSetup."LCY Code");

        exit(SrcCurrCode);
    end;
}

