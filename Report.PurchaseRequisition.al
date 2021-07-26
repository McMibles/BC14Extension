Report 52092643 "Purchase Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Requisition.rdlc';

    dataset
    {
        dataitem("Requisition Header"; "Requisition Wksh. Name")
        {
            DataItemTableView = sorting("Worksheet Template Name", Name);
            RequestFilterFields = Name, Type, "User ID";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(Worksheet_Template_Name; "Worksheet Template Name")
            {
            }
            column(Requisition_No; Name)
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(PRN___No_CaptionLbl; PRN___No_CaptionLbl)
            {
            }
            column(GlobalDim1Code; GlobalDim1Code)
            {
            }
            column(Dim1Name; Dim1Name)
            {
            }
            column(RequesterName__CaptionLbl; RequesterName__CaptionLbl)
            {
            }
            column(EmployeeName; Employee.FullName)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_1000000031; 1000000031)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(ReportForNavId_1000000030; 1000000030)
                    {
                    }
                    // column(CurrRepPageNo;StrSubstNo(Text005,Format(CurrReport.PageNo)))
                    // {
                    // }
                    column(OutputNo; OutputNo)
                    {
                    }
                    dataitem("Requisition Line"; "Requisition Line")
                    {
                        DataItemLink = "Worksheet Template Name" = field("Worksheet Template Name"), "Journal Batch Name" = field(Name);
                        DataItemLinkReference = "Requisition Header";
                        DataItemTableView = sorting("Worksheet Template Name", "Journal Batch Name", "Line No.");
                        column(ReportForNavId_1000000012; 1000000012)
                        {
                        }
                        column(ExpectedReceiptDate_RequisitionLine; "Requisition Line"."Expected Receipt Date")
                        {
                            IncludeCaption = true;
                        }
                        column(DirectUnitCost_RequisitionLine; "Requisition Line"."Direct Unit Cost")
                        {
                            IncludeCaption = true;
                        }
                        column(RequestedQuantity_RequisitionLine; "Requisition Line"."Requested Quantity")
                        {
                            IncludeCaption = true;
                        }
                        column(Type; "Requisition Line".Type)
                        {
                            IncludeCaption = true;
                        }
                        column(No_RequisitionLine; "Requisition Line"."No.")
                        {
                            IncludeCaption = true;
                        }
                        column(Description_RequisitionLine; "Requisition Line".Description)
                        {
                            IncludeCaption = true;
                        }
                        column(Description2_RequisitionLine; "Requisition Line"."Description 2")
                        {
                        }
                        column(Quantity_RequisitionLine; "Requisition Line".Quantity)
                        {
                        }
                        column(UnitofMeasureCode_RequisitionLine; "Requisition Line"."Unit of Measure Code")
                        {
                        }
                        column(EstAmount_RequisitionLine; "Requisition Line"."Est. Amount (LCY)")
                        {
                        }
                        column(No__CaptionLbl; No__CaptionLbl)
                        {
                        }
                        column(Description__CaptionLbl; Description__CaptionLbl)
                        {
                        }
                        column(RequestedQty__CaptionLbl; RequestedQty__CaptionLbl)
                        {
                        }
                        column(UOM__CaptionLbl; UOM__CaptionLbl)
                        {
                        }
                        column(BudgetPrice__CaptionLbl; BudgetPrice__CaptionLbl)
                        {
                        }
                        column(EstimatedAmt__CaptionLbl; EstimatedAmt__CaptionLbl)
                        {
                        }
                        column(RequiredDate__CaptionLbl; RequiredDate__CaptionLbl)
                        {
                        }
                        column(SerialNo__CaptionLbl; SerialNo__CaptionLbl)
                        {
                        }
                        column(Purchase_Requisition; Purchase_Requisition)
                        {
                        }
                        column(SerialNo; SerialNo)
                        {
                        }
                        column(TotalCost; TotalCost)
                        {
                        }
                        column(Total_Txt; Total_Txt)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Type <> 0 then
                                SerialNo := SerialNo + 1;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        SerialNo := 0;
                    end;

                    trigger OnPostDataItem()
                    begin
                        CurrReport.Break;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;
                    // CurrReport.PageNo := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TotalCost := GetEstimatedCost;
                Clear(PurchReqType);
                if PurchReqType.Get("Purchase Req. Code") then;
                PRNType := StrSubstNo(Text000, PurchReqType.Type, PurchReqType.Description);
                SerialNo := 0;
                Dim1Name := DimMgtHook.ReturnDimName(1, "Shortcut Dimension 1 Code");
                if Employee.Get("Beneficiary No.") then;
                //Copy Comment

                PurchCommentLnTemp.DeleteAll;
                PurchCommentLn.SetCurrentkey("Document Type", "No.", "Document Line No.", "Line No.");
                PurchCommentLn.SetRange("Document Type", 0);
                PurchCommentLn.SetRange("No.", Name);
                if PurchCommentLn.FindFirst then
                    repeat
                        PurchCommentLnTemp.Init;
                        PurchCommentLnTemp := PurchCommentLn;
                        PurchCommentLnTemp.Insert;
                    until PurchCommentLn.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                CompanyInfo.CalcFields(Picture);
                FullCompanyName := COMPANYNAME;
                PurchCommentLnTemp.DeleteAll;
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
                    field(NoOfCopies; NoOfCopies)
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
    }

    trigger OnInitReport()
    begin
        PurchSetup.Get;
        NoOfCopies := 0
    end;

    trigger OnPreReport()
    begin
        GLSetup.Get;
        GlobalDim1Code := GLSetup."Global Dimension 1 Code";
    end;

    var
        Employee: Record Employee;
        PurchSetup: Record "Purchases & Payables Setup";
        CompanyInfo: Record "Company Information";
        PurReqLine: Record "Requisition Line" temporary;
        PurchReqType: Record "Purchase Req. Type";
        GLSetup: Record "General Ledger Setup";
        PurchCommentLn: Record "Purch. Comment Line";
        PurchCommentLnTemp: Record "Purch. Comment Line" temporary;
        DimMgtHook: Codeunit "Dimension Hook";
        CompanyAddr: array[8] of Text[50];
        FullCompanyName: Text[50];
        Text000: label 'PRN Type: %1 (%2)';
        Text003: label 'COPY';
        Text005: label 'Page %1';
        Purchase_Requisition: label 'PURCHASE REQUISITION';
        CopyText: Text[30];
        PRNType: Text[250];
        Dim1Name: Text[50];
        PRN___No_CaptionLbl: label 'PRN No.';
        PageText: label 'Page';
        GlobalDim1Code: Code[20];
        NoOfLoops: Integer;
        NoOfCopies: Integer;
        OutputNo: Integer;
        SerialNo: Integer;
        MoreLines: Boolean;
        No__CaptionLbl: label 'No.';
        Description__CaptionLbl: label 'Description';
        RequestedQty__CaptionLbl: label 'Requested Qty.';
        UOM__CaptionLbl: label 'UOM';
        BudgetPrice__CaptionLbl: label 'Estimated Price';
        EstimatedAmt__CaptionLbl: label 'Estimated Amount';
        RequiredDate__CaptionLbl: label 'Need by Date';
        SerialNo__CaptionLbl: label 'S/n';
        RequesterName__CaptionLbl: label 'Requester Name';
        PageCaptionLbl: label 'Page';
        TotalCost: Decimal;
        Total_Txt: label 'Total';


    procedure InsertTempPurchLine()
    var
        OriginalPurReqLine: Record "Requisition Line";
    begin
        Clear(OriginalPurReqLine);
        OriginalPurReqLine.SetRange("Worksheet Template Name", "Requisition Header"."Worksheet Template Name");
        OriginalPurReqLine.SetRange("Journal Batch Name", "Requisition Header".Name);
        if OriginalPurReqLine.FindFirst then
            repeat
                PurReqLine.Init;
                PurReqLine := OriginalPurReqLine;
                PurReqLine.Insert;
            until OriginalPurReqLine.Next = 0;
    end;
}

