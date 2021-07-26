Report 52092548 "Posted Payment - Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Posted Payment - Receipt.rdlc';

    dataset
    {
        dataitem("Posted Cash Receipt Header";"Posted Cash Receipt Header")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(CompanyInfoPicture;CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_Authorised_Signature;CompanyInfo."Authorised Signature")
            {
            }
            column(CompanyAddr1;CompanyAddr[1])
            {
            }
            column(CompanyAddr2;CompanyAddr[2])
            {
            }
            column(CompanyAddr3;CompanyAddr[3])
            {
            }
            column(CompanyAddr4;CompanyAddr[4])
            {
            }
            column(CompanyAddr5;CompanyAddr[5])
            {
            }
            column(CompanyAddr6;CompanyAddr[6])
            {
            }
            column(CompanyAddr7;CompanyAddr[7])
            {
            }
            column(CompanyAddr8;CompanyAddr[8])
            {
            }
            column(Tittle;Tittle)
            {
            }
            column(PostingDate;Format("Posting Date"))
            {
            }
            column(ReceiptNo;"No.")
            {
            }
            column(Received_from;"Posted Cash Receipt Header".Payee)
            {
            }
            column(AmountInWord;AmountInWord[1] + ' ' + AmountInWord[2])
            {
            }
            column(Receipt___No_CaptionLbl;Receipt___No_CaptionLbl)
            {
            }
            column(Receipt___Posting_Date_CaptionLbl;Receipt___Posting_Date_CaptionLbl)
            {
            }
            column(PostingDescription_CashReceiptHeader;"Posting Description")
            {
            }
            column(Amount_Text;Amount)
            {
                DecimalPlaces = 0:2;
            }
            column(CurrencyCode;Currency.Code)
            {
            }
            column(Receipt___Payment_Document_No_CaptionLbl;"Payment Document No.")
            {
            }
            column(ShowDraftLabel;ShowDraftLabel)
            {
            }
            dataitem("Posted Cash Receipt Line";"Posted Cash Receipt Line")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Document No.","Line No.");
                column(ReportForNavId_1000000011; 1000000011)
                {
                }
                column(SourceName;"Source Name")
                {
                }
                column(SourceNo;"Source No.")
                {
                }
                column(STRSUBSTNO_Text003_SourceName_;StrSubstNo(Text003))
                {
                }
                column(Amount_CaptionLbl;Amount_CaptionLbl)
                {
                }
                column(STRSUBSTNO_Text005_Description;StrSubstNo(Text005))
                {
                }
                column(STRSUBSTNO_Text006_Draft_No;StrSubstNo(Text006))
                {
                }
                column(SalutationFooterText;SalutationFooterText)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if "Currency Code" <> '' then begin
                  Currency.Get("Currency Code");
                  Currency.TestField("Lower Unit Code");
                  CurrText1 := "Currency Code";
                  CurrText2 := Currency."Lower Unit Code";
                end else begin
                  Currency.Code := GLSetup."LCY Code";
                  CurrText1 := '';
                  CurrText2 := '';
                end;

                CalcFields(Amount,"WHT Amount");
                AmountInFigure := Amount - "WHT Amount";
                ConvertAmtToText.InitTextVariable;
                ConvertAmtToText.FormatNoText(AmountInWord,Abs(AmountInFigure),CurrText1,CurrText2);

                if Status <> Status::"Pending Approval" then
                  ShowDraftLabel := true
                else
                  ShowDraftLabel := false
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                if not UseLetterHeadPaper then begin
                  CompanyInfo.CalcFields(Picture);
                  if ShowSignature then
                    CompanyInfo.CalcFields("Authorised Signature");
                  FormatAddr.Company(CompanyAddr,CompanyInfo);
                  //Update Company ddress
                  CompanyAddr[4] := CompanyInfo.City;
                  CompanyAddr[5] := StrSubstNo(Text000,CompanyInfo."Phone No.");
                  CompanyAddr[6] := StrSubstNo(Text001,CompanyInfo."E-Mail");
                  CompanyAddr[7] := StrSubstNo(Text002,CompanyInfo."Home Page");
                end;
                Tittle := StrSubstNo(Text004);
                SalutationFooterText :=  StrSubstNo(Text1000,COMPANYNAME);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Show Signature";ShowSignature)
                    {
                        ApplicationArea = Basic;
                    }
                    field("Use Letter Head Paper";UseLetterHeadPaper)
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ShowSignature := true;
        end;
    }

    labels
    {
        Draft_Label = 'DRAFT COPY';
    }

    trigger OnPreReport()
    begin
        GLSetup.Get;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PostedRcptLn: Record "Posted Cash Receipt Line";
        CompanyInfo: Record "Company Information";
        Currency: Record Currency;
        FormatAddr: Codeunit "Format Address";
        ConvertAmtToText: Codeunit "Format No. to Text";
        CompanyAddr: array [8] of Text[50];
        Text000: label 'Phone No.: %1';
        Text001: label 'E-Mail: %1';
        Text002: label 'Website: %1';
        Text003: label 'Received with thanks from';
        Text004: label 'RECEIPT';
        Tittle: Text[30];
        Text005: label 'Being Part/Full Payment for:';
        Text006: label 'Cheque/Draft Particulars';
        Text1000: label 'For: %1';
        Receipt___No_CaptionLbl: label 'No.';
        Receipt___Posting_Date_CaptionLbl: label 'Date';
        Amount_CaptionLbl: label 'the sum of  ';
        AmountInWord: array [2] of Text[150];
        CurrText1: Text[30];
        CurrText2: Text[30];
        SalutationFooterText: Text[100];
        AmountInFigure: Decimal;
        ShowSignature: Boolean;
        UseLetterHeadPaper: Boolean;
        ShowDraftLabel: Boolean;
}

