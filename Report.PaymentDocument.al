Report 52092542 "Payment Document"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payment Document.rdlc';

    dataset
    {
        dataitem("Payment Header"; "Payment Header")
        {
            CalcFields = Amount, "WHT Amount", "Retirement Amount";
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(No_PaymentHeader; "Payment Header"."No.")
            {
            }
            column(DocumentType_PaymentHeader; Format("Payment Header"."Document Type"))
            {
            }
            column(PostingDescription_PaymentHeader; "Payment Header"."Posting Description")
            {
            }
            column(CurrencyCode_PaymentHeader; "Payment Header"."Currency Code")
            {
            }
            column(DocumentDate_PaymentHeader; "Payment Header"."Document Date")
            {
            }
            column(PaymentType_PaymentHeader; "Payment Header"."Payment Type")
            {
            }
            column(PaymentRequestNo_PaymentHeader; "Payment Header"."Payment Request No.")
            {
            }
            column(ShortcutDimension1Code_PaymentHeader; "Payment Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PaymentHeader; "Payment Header"."Shortcut Dimension 2 Code")
            {
            }
            column(CreationDate_PaymentHeader; Format("Payment Header"."Creation Date", 0, 4))
            {
            }
            column(CreationTime_PaymentHeader; Format("Payment Header"."Creation Time"))
            {
            }
            column(Payee_PaymentHeader; "Payment Header".Payee)
            {
            }
            column(Amount_PaymentHeader; "Payment Header".Amount)
            {
            }
            column(WHT_Amount_PaymentHeader; "Payment Header"."WHT Amount")
            {
            }
            column(Retire_Amount_PaymentHeader; "Payment Header"."Retirement Amount")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(CompanyAddr7; CompanyAddr[7])
            {
            }
            column(CompanyAddr8; CompanyAddr[8])
            {
            }
            column(ShowDraftLabel; ShowDraftLabel)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_1000000019; 1000000019)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(ReportForNavId_1000000018; 1000000018)
                    {
                    }
                    // column(CurrRepPageNo;StrSubstNo(Text005,Format(CurrReport.PageNo)))
                    // {
                    // }
                    column(OutputNo; OutputNo)
                    {
                    }
                    dataitem("Payment Line"; "Payment Line")
                    {
                        DataItemLink = "Document No." = field("No.");
                        DataItemLinkReference = "Payment Header";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                        column(ReportForNavId_1000000017; 1000000017)
                        {
                        }
                        column(LineAmt_PaymentLine; PaymentLine2.Amount)
                        {
                        }
                        column(AccountType_PaymentLine; "Payment Line"."Account Type")
                        {
                        }
                        column(AccountNo_PaymentLine; "Payment Line"."Account No.")
                        {
                        }
                        column(Description_PaymentLine; "Payment Line".Description)
                        {
                        }
                        column(ShortcutDimension1Code_PaymentLine; "Payment Line"."Shortcut Dimension 1 Code")
                        {
                        }
                        column(ShortcutDimension2Code_PaymentLine; "Payment Line"."Shortcut Dimension 2 Code")
                        {
                        }
                        column(JobNo_PaymentLine; "Payment Line"."Job No.")
                        {
                        }
                        column(JobTaskNo_PaymentLine; "Payment Line"."Job Task No.")
                        {
                        }
                        column(MaintenanceCode_PaymentLine; "Payment Line"."Maintenance Code")
                        {
                        }
                        column(ConsignmentPONo_PaymentLine; "Payment Line"."Consignment PO No.")
                        {
                        }
                        column(ConsignmentCode_PaymentLine; "Payment Line"."Consignment Code")
                        {
                        }
                        column(ConsignmentChargeCode_PaymentLine; "Payment Line"."Consignment Charge Code")
                        {
                        }
                        column(AccountName_PaymentLine; "Payment Line"."Account Name")
                        {
                        }
                        column(Amount_PaymentLine; "Payment Line".Amount)
                        {
                        }
                        column(WHTAmount_PaymentLine; "Payment Line"."WHT Amount")
                        {
                        }
                        column(AmountInWord_PaymentLine; AmountInWord[1] + ' ' + AmountInWord[2])
                        {
                        }
                        column(TotalAmount_PaymentLine; TotalAmount)
                        {
                        }
                        column(AccountType_PaymentLine_Caption; "Payment Line".FieldCaption("Account Type"))
                        {
                        }
                        column(AccountNo_PaymentLine_Caption; "Payment Line".FieldCaption("Account No."))
                        {
                        }
                        column(Description_PaymentLine_Caption; "Payment Line".FieldCaption(Description))
                        {
                        }
                        column(JobNo_PaymentLine_caption; "Payment Line".FieldCaption("Job No."))
                        {
                        }
                        column(JobTask_PaymentLine_caption; "Payment Line".FieldCaption("Job Task No."))
                        {
                        }
                        column(ConsignmentPO_PaymentLine_caption; "Payment Line".FieldCaption("Consignment PO No."))
                        {
                        }
                        column(ConsignmentCode_PaymentLine_caption; "Payment Line".FieldCaption("Consignment Code"))
                        {
                        }
                        column(ConsignmentCharge_PaymentLine_caption; "Payment Line".FieldCaption("Consignment Charge Code"))
                        {
                        }
                        column(Maintenance_PaymentLine_caption; "Payment Line".FieldCaption("Maintenance Code"))
                        {
                        }
                        column(ShortDim1_PaymentLine_caption; "Payment Line".FieldCaption("Shortcut Dimension 1 Code"))
                        {
                        }
                        column(ShortDim2_PaymentLine_caption; "Payment Line".FieldCaption("Shortcut Dimension 2 Code"))
                        {
                        }
                        column(Amount_PaymentLine_caption; "Payment Line".FieldCaption(Amount))
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtPurchLine: Record "Purchase Line" temporary;
                    TempPurchLine: Record "Purchase Line" temporary;
                begin
                    PaymentLine2.DeleteAll;
                    PaymentLine.SetRange("Document No.", "Payment Header"."No.");
                    if PaymentLine.FindSet then
                        repeat
                            PaymentLine2.Init;
                            PaymentLine2 := PaymentLine;
                            PaymentLine2.Insert;
                        until PaymentLine.Next = 0;


                    if Number > 1 then
                        CopyText := Text003;
                    //CurrReport.PageNo := 1;
                    OutputNo := OutputNo + 1;
                end;

                trigger OnPostDataItem()
                begin
                    //IF NOT CurrReport.PREVIEW THEN
                    //PaymentHeaderCountPrinted.RUN("Payment Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TestField(Payee);
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                CompanyAddr[4] := CompanyInfo.City;
                CompanyAddr[5] := StrSubstNo(Text000, CompanyInfo."Phone No.");
                CompanyAddr[6] := StrSubstNo(Text001, CompanyInfo."E-Mail");
                CompanyAddr[7] := StrSubstNo(Text002, CompanyInfo."Home Page");


                if ("Currency Code" = '') then begin
                    GLSetup.TestField("LCY Code");
                    CurrencyCode := GLSetup."LCY Code";
                end else
                    CurrencyCode := "Currency Code";

                ConvertAmtToText.InitTextVariable;
                ConvertAmtToText.FormatNoText(AmountInWord, Abs(Amount - "Retirement Amount" - "WHT Amount"), "Currency Code", '');
                if Status <> Status::"Pending Approval" then
                    ShowDraftLabel := true
                else
                    ShowDraftLabel := false
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
                    field(NoofCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Draft_Label = 'DRAFT';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(CompanyInfo.Picture);
        GLSetup.Get;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        PaymentLine: Record "Payment Line";
        PaymentLine2: Record "Payment Line" temporary;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CompanyAddr: array[8] of Text[50];
        CopyText: Text[30];
        AmountInWord: array[2] of Text;
        OutputNo: Integer;
        CurrencyCode: Code[10];
        MoreLines: Boolean;
        ShowDraftLabel: Boolean;
        TotalAmount: Decimal;
        ConvertAmtToText: Codeunit "Format No. to Text";
        Text000: label 'Phone No.: %1';
        Text001: label 'E-Mail: %1';
        Text002: label 'Website: %1';
        Text003: label ' COPY';
        Text005: label 'Page %1';
        //PaymentHeaderCountPrinted: Codeunit "Payment Header -Printed";
        FormatAddr: Codeunit "Format Address";
}

