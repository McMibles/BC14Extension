Codeunit 52092259 "Purchase Hook"
{

    //     trigger OnRun()
    //     begin
    //     end;

    var
        PurchSetup: Record "Purchases & Payables Setup";
        Text035: label 'No Budget Entry created for Account %1, please Contact your Budget Control Unit';
        Text036: label 'Your Expense for this Period have been Exceeded by =N= %1,Please Contact your Budget Control Unit';
        Text037: label 'Your Expense for this Period have been Exceeded by =N= %1, Do want to Continue?';
        Text038: label 'Transaction blocked to respect budget control';
        Text039: label 'The amount for account %1 will make you go above your budget\\ Please Contact your Budget Control Unit';
        Text040: label 'The amount for account %1 will make you go above your budget\\ Do you want to continue?';
        Text101: label 'PURCHASE ORDER';
        Text102: label 'Find Attached Purchase Order %1.';
        Text103: label 'CANCELLATION OF PURCHASE ORDER %1 for %2';
        Text104: label 'Attached PO has been cancelled, please do not act on this transaction. ';
        Text105: label 'PURCHASE ORDER %1 (Version %2) for %3';
        Text999: label 'Invoice Posting date cannot be earlier than Receipt posting date.';
        Text1000: label 'There is an error in line %1 returning base quantity without quantity.';
        Text1001: label 'You must run the function for calculating landed cost before posting the invoice.';
        Text1002: label 'Your posting will leave %1 in the Goods in transit account. Are you sure you ant to continue?';
        Text1003: label 'Contact your system Administrator for Assistance.';
        GLSetup: Record "General Ledger Setup";
        PayMgtSetup: Record "Payment Mgt. Setup";
        UserSetup: Record "User Setup";
        InvtSetup: Record "Inventory Setup";
        CurrExchRate: Record "Currency Exchange Rate";
        Text1004: label 'Consignment %1 has no quantity line. Contact your System Administrator for assistance.';
        Currency: Record Currency;
        TempWHTtoApply: Record "WHT to Apply Entry" temporary;
        Vendor: Record Vendor;
        //lDeliveryToleranceMgt: Codeunit "Delivery Tolerance Mgt";
        Text1005: label 'You are not setup for the creation of purchase order in any responsibility centre. Contact your System Administrator for Assistance.';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        // PurchMgt: Codeunit UnknownCodeunit52092258;
        FAAcqErr: label 'You can not select this asset because it is already in use';
        TINErr: label 'This vendor does not have TIN so VAT cannot be applied';
        BudgetControlMgt: Codeunit "Budget Control Management";
        Text1006: label 'Do you want to send PO cancellation email to the Vendor?';

    //     [IntegrationEvent(false, false)]

    //     procedure OnInsertPurchHeaderRec(var PurchHeader: Record "Purchase Header")
    //     begin
    //     end;

    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchase Hook", 'OnInsertPurchHeaderRec', '', false, false)]
    //     local procedure OnInsertPurchHeader(var PurchHeader: Record "Purchase Header")
    //     var
    //         ErroMsg: Text;
    //     begin
    //         PurchSetup.Get;
    //         GLSetup.Get;
    //         with PurchHeader do begin
    //           if (PurchSetup."Resp. Centre Mandatory") and ("Document Type" = "document type"::Order) then begin
    //             UserSetup.Get(UpperCase(UserId));
    //             if UserSetup."Purchase Resp. Ctr. Filter" = '' then
    //               Error(Text1005);
    //           end;

    //           if "No." = '' then begin
    //             if BlankDocumentExist(ErroMsg,PurchHeader) then
    //               Error(ErroMsg);

    //             PurchHeader.TestNoSeries;
    //             if (PurchSetup."Use Same No.") and ("Document Type" in [0,1]) then begin
    //               if "Suffix No." = '' then
    //                NoSeriesMgt.InitSeries(PurchSetup."Generic Nos.",PurchSetup."Generic Nos.",0D,
    //                 "Suffix No.",PurchSetup."Generic Nos.");
    //               case "Document Type" of
    //                 0: PurchMgt.GetNoSeries(3,"Suffix No.","No.");
    //                 1: begin
    //                     case "Order Type" of
    //                       0:PurchMgt.GetNoSeries(4,"Suffix No.","No.");
    //                       1:PurchMgt.GetNoSeries(5,"Suffix No.","No.");
    //                     end;
    //                 end;
    //               end;
    //               if "Original Suffix No." = '' then
    //                 "Original Suffix No." := "Suffix No.";
    //             end else
    //              if "Document Type" in [0,1] then
    //                NoSeriesMgt.InitSeries(PurchHeader.GetNoSeriesCode,"No. Series","Posting Date","No.","No. Series")
    //              else
    //                exit;
    //           end;
    //         end;
    //     end;

    //     local procedure TestNoSeries(var PurchHeader: Record "Purchase Header")
    //     begin
    //         PurchSetup.Get;
    //         with PurchHeader do begin
    //           case "Document Type" of
    //             "document type"::Quote:
    //               PurchSetup.TestField("Quote Nos.");
    //             "document type"::Order: begin
    //               if "Order Type" = 0 then
    //                 PurchSetup.TestField("Order Nos.")
    //               else
    //                 PurchSetup.TestField("Service PO Nos.")
    //             end;

    //             "document type"::Invoice:
    //               begin
    //                 PurchSetup.TestField("Invoice Nos.");
    //                 PurchSetup.TestField("Posted Invoice Nos.");
    //               end;
    //             "document type"::"Return Order":
    //               PurchSetup.TestField("Return Order Nos.");
    //             "document type"::"Credit Memo":
    //               begin
    //                 PurchSetup.TestField("Credit Memo Nos.");
    //                 PurchSetup.TestField("Posted Credit Memo Nos.");
    //               end;
    //             "document type"::"Blanket Order":
    //               PurchSetup.TestField("Blanket Order Nos.");
    //           end;
    //         end;
    //     end;

    //     local procedure GetNoSeriesCode(var PurchHeader: Record "Purchase Header"): Code[10]
    //     begin
    //         with PurchHeader do begin
    //           case "Document Type" of
    //             "document type"::Quote:
    //               exit(PurchSetup."Quote Nos.");
    //             "document type"::Order: begin
    //               if "Order Type" = 0 then
    //                 exit(PurchSetup."Order Nos.")
    //               else
    //                 exit(PurchSetup."Service PO Nos.")
    //             end;
    //             "document type"::Invoice:
    //               exit(PurchSetup."Invoice Nos.");
    //             "document type"::"Return Order":
    //               exit(PurchSetup."Return Order Nos.");
    //             "document type"::"Credit Memo":
    //               exit(PurchSetup."Credit Memo Nos.");
    //             "document type"::"Blanket Order":
    //               exit(PurchSetup."Blanket Order Nos.");
    //           end;
    //         end;
    //     end;


    //     procedure PurchHeaderInitRecord(var PurchHeader: Record "Purchase Header")
    //     begin
    //         PurchSetup.Get;
    //         with PurchHeader do begin
    //           "User ID" := UserId;
    //           "Validity Period" := PurchSetup."PO Expiration Period";
    //         end
    //     end;

    //     [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    //     local procedure OnAfterAssignItemValuesOnPurLine(var PurchLine: Record "Purchase Line";Item: Record Item)
    //     begin
    //         PurchLine."Delivery Tolerance Code" :=  Item."Purch. Delivery Tolerance Code"
    //     end;

    //     [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterUpdateAmounts', '', false, false)]
    //     local procedure OnAfterPurchLineUpdateAmounts(var PurchLine: Record "Purchase Line";var xPurchLine: Record "Purchase Line";CurrFieldNo: Integer)
    //     var
    //         PurchHeader: Record "Purchase Header";
    //     begin
    //         with PurchLine do begin
    //           PurchHeader.Get(PurchLine."Document Type",PurchLine."Document No.");
    //           GetCurrency(PurchHeader."Currency Code");
    //           if PurchHeader."Currency Code" <> '' then
    //             "Line Amount (LCY)" :=
    //               ROUND(
    //                 CurrExchRate.ExchangeAmtFCYToLCY(
    //                   GetDate,"Currency Code",
    //                   "Line Amount",PurchHeader."Currency Factor"),
    //                 Currency."Amount Rounding Precision")
    //           else
    //             "Line Amount (LCY)" :=
    //               ROUND("Line Amount",Currency."Amount Rounding Precision");
    //         end;
    //     end;

    //     [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    //     local procedure OnAfterUpdatePurchLineAmountsDone(var PurchLine: Record "Purchase Line";var xPurchLine: Record "Purchase Line";CurrFieldNo: Integer)
    //     begin
    //         PurchLine.Validate("With-Holding Tax%");
    //     end;


    //     procedure CopyDocTermsOnPurchPost(FromDocumentType: Integer;ToDocumentType: Integer;FromNumber: Code[20];ToNumber: Code[20])
    //     var
    //         FromDocTerm: Record "Document Term";
    //         ToDocTerm: Record "Document Term";
    //     begin
    //         FromDocTerm.SetRange("Document Type",FromDocumentType);
    //         FromDocTerm.SetRange("Document No.",FromNumber);
    //         if FromDocTerm.FindSet then
    //           repeat
    //             ToDocTerm := FromDocTerm;
    //             ToDocTerm."Document Type" := ToDocumentType;
    //             ToDocTerm."Document No." := ToNumber;
    //             ToDocTerm.Insert;
    //           until FromDocTerm.Next = 0;
    //     end;


    //     procedure CheckPurchRcptQtyOnPurchPost(PurchRcptLine: Record "Purch. Rcpt. Line")
    //     begin
    //         //IF (PurchRcptLine.Quantity = 0) AND (PurchRcptLine."Quantity (Base)" <> 0) THEN
    //           //ERROR(Text1000,PurchRcptLine."Line No.");
    //     end;


    //     procedure UpdateGenJnlOnPurchPost(var GenJnlLine: Record "Gen. Journal Line";InvPostingBuffer: Record "Invoice Post. Buffer")
    //     begin
    //         //GenJnlLine."Job Task No." := InvPostingBuffer."Job Task No.";
    //         GenJnlLine."Consignment Code" := InvPostingBuffer."Consignment Code";
    //         GenJnlLine."Consignment Charge Code" := InvPostingBuffer."Consignment Charge Code";
    //         GenJnlLine."Order No." := InvPostingBuffer."PO No.";
    //         GenJnlLine."Direct Cost Invoice" := InvPostingBuffer."Direct Cost Invoice";
    //     end;


    //     procedure ItsConsigmentPostingOnPurchPost(PurchaseHeader: Record "Purchase Header"): Boolean
    //     begin
    //         if PurchaseHeader."Consignment Code" = '' then
    //           exit(false)
    //         else
    //           exit(true);
    //     end;


    //     procedure UpdateCommitmentOnPurchPost(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line")
    //     var
    //         PurchHeader2: Record "Purchase Header";
    //         BudgetControl: Codeunit "Budget Control Management";
    //     begin
    //         GLSetup.Get;
    //         PayMgtSetup.Get;
    //         with PurchHeader do begin
    //           case "Document Type" of
    //             "document type"::Order:
    //               if Invoice then
    //                 if (PayMgtSetup."Budget Expense Control Enabled") and (BudgetControl.ControlBudget(PurchLine."Account No.")) then
    //                   begin
    //                     PurchHeader2.Get(PurchLine."document type"::Order,PurchLine."Document No.");
    //                     if PurchLine."Outstanding Amount (LCY)" <> 0  then
    //                       BudgetControl.UpdateCommitment(PurchLine."Document No.",PurchLine."Line No.",
    //                         PurchHeader2."Document Date",PurchLine."Outstanding Amount (LCY)",PurchLine."Account No.",PurchLine."Dimension Set ID")
    //                     else
    //                       BudgetControl.DeleteCommitment(PurchLine."Document No.",PurchLine."Line No.",PurchLine."Account No.");
    //                   end;
    //             "document type"::Invoice:
    //               if (PayMgtSetup."Budget Expense Control Enabled") and (BudgetControl.ControlBudget(PurchLine."Account No.")) then
    //                 begin
    //                   PurchHeader2.Get(PurchLine."document type"::Order,PurchLine."Document No.");
    //                   if PurchLine."Outstanding Amount (LCY)" <> 0  then
    //                     BudgetControl.UpdateCommitment(PurchLine."Document No.",PurchLine."Line No.",
    //                       PurchHeader2."Document Date",PurchLine."Outstanding Amount (LCY)",PurchLine."Account No.",PurchLine."Dimension Set ID")
    //                   else
    //                     BudgetControl.DeleteCommitment(PurchLine."Document No.",PurchLine."Line No.",PurchLine."Account No.");
    //                 end;
    //           end;
    //         end;
    //     end;


    //     procedure ArchiveCompletelyInvPO(PurchHeader: Record "Purchase Header")
    //     var
    //         PurchaseOrder: Record "Purchase Header";
    //         ArchiveManagement: Codeunit ArchiveManagement;
    //     begin
    //         with PurchHeader do begin
    //           if ("Document Type" = "document type"::Invoice) and ("Order No." <> '') then
    //             if PurchaseOrder.Get(PurchaseOrder."document type"::Order,"Order No.") then
    //               if PurchSetup."Archive Quotes and Orders"  and CompletelyInvoiced(PurchaseOrder) then begin
    //                  //ArchiveManagement.SetArchiveByDocNo("Document Type","No.");
    //                  ArchiveManagement.StorePurchDocument(PurchaseOrder,false);
    //                  if PurchaseOrder.Delete(true) then;
    //               end;
    //         end;
    //     end;


    //     procedure DeleteCommitmentOnPurchPost(PurchLine: Record "Purchase Line")
    //     var
    //         BudgetControl: Codeunit "Budget Control Management";
    //     begin
    //         BudgetControl.DeleteCommitment(PurchLine."Document No.",PurchLine."Line No.",PurchLine."Account No.");
    //     end;


    //     procedure DeleteCommitOnPurchHeaderDelete(PurchHeader: Record "Purchase Header")
    //     var
    //         Commitment: Record "Commitment Entry";
    //     begin
    //         with PurchHeader do begin
    //           Commitment.SetRange("Document No.","No.");
    //           Commitment.DeleteAll;
    //         end;
    //     end;


    //     procedure TreatExpensedVATOn(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var ItemJnlLine: Record "Item Journal Line";var QtyToBeInvoiced: Decimal;var QtyToBeInvoicedBase: Decimal;ItemChargeNo: Code[20];var RemAmt: Decimal;var RemDiscAmt: Decimal;QtyToBeReceived: Decimal)
    //     var
    //         Factor: Decimal;
    //     begin
    //         with PurchLine do begin
    //             ItemJnlLine."Unit Cost" := "Unit Cost (LCY)" * (1 + "VAT %" / 100);
    //             ItemJnlLine."Source Currency Code" := PurchHeader."Currency Code";
    //             ItemJnlLine."Unit Cost (ACY)" := "Unit Cost" * (1 + "VAT %" / 100);
    //             ItemJnlLine."Value Entry Type" := ItemJnlLine."value entry type"::"Direct Cost";
    //             if ItemChargeNo <> '' then begin
    //               ItemJnlLine."Item Charge No." := ItemChargeNo;
    //               "Qty. to Invoice" := QtyToBeInvoiced;
    //             end;

    //             if QtyToBeInvoiced <> 0 then begin
    //               if (QtyToBeInvoicedBase <> 0) and (Type= Type::Item)then
    //                 Factor := QtyToBeInvoicedBase / "Qty. to Invoice (Base)"
    //               else
    //                 Factor := QtyToBeInvoiced / "Qty. to Invoice";
    //               ItemJnlLine.Amount := Amount *(1 + "VAT %" / 100) * Factor + RemAmt;
    //               if PurchHeader."Prices Including VAT" then
    //                 ItemJnlLine."Discount Amount" :=
    //                   ("Line Discount Amount" + "Inv. Discount Amount") / (1 + "VAT %" / 100) * Factor + RemDiscAmt
    //               else
    //                   ItemJnlLine."Discount Amount" :=
    //                     ("Line Discount Amount" + "Inv. Discount Amount") * Factor + RemDiscAmt;
    //               RemAmt := ItemJnlLine.Amount - ROUND(ItemJnlLine.Amount);
    //               RemDiscAmt := ItemJnlLine."Discount Amount" - ROUND(ItemJnlLine."Discount Amount");
    //               ItemJnlLine.Amount := ROUND(ItemJnlLine.Amount);
    //               ItemJnlLine."Discount Amount" := ROUND(ItemJnlLine."Discount Amount");
    //             end else begin
    //               if PurchHeader."Prices Including VAT" then
    //                 ItemJnlLine.Amount :=
    //                   (QtyToBeReceived * "Direct Unit Cost" * (1 - PurchLine."Line Discount %" / 100) / (1 + "VAT %" / 100)) + RemAmt
    //               else
    //                 ItemJnlLine.Amount :=
    //                   (QtyToBeReceived * "Direct Unit Cost" * (1 - PurchLine."Line Discount %" / 100)) + RemAmt;
    //               RemAmt := ItemJnlLine.Amount - ROUND(ItemJnlLine.Amount);
    //               if PurchHeader."Currency Code" <> '' then
    //                 ItemJnlLine.Amount :=
    //                   ROUND(
    //                     CurrExchRate.ExchangeAmtFCYToLCY(
    //                       PurchHeader."Posting Date",PurchHeader."Currency Code",
    //                       ItemJnlLine.Amount,PurchHeader."Currency Factor"))
    //               else
    //                 ItemJnlLine.Amount := ROUND(ItemJnlLine.Amount);
    //             end;
    //         end;
    //     end;


    //     procedure UpdateItemJnlOnPurchPost(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";var ItemJnlLine: Record "Item Journal Line")
    //     begin
    //         with PurchLine do begin
    //           /*ItemJnlLine."Work Order No." := "Work Order No.";
    //           ItemJnlLine."Work Order Task No." := "Work Order Task No.";
    //           ItemJnlLine."Capex Code" := "Capex Code";*/
    //           if PurchHeader."Document Type" = PurchHeader."document type"::Order then
    //             ItemJnlLine."PO No." := "Document No."
    //           else if PurchHeader."Document Type" in[PurchHeader."document type"::Invoice,
    //             PurchHeader."document type"::"Credit Memo"] then
    //             ItemJnlLine."PO No." := PurchHeader."Order No.";
    //           ItemJnlLine."Consignment Code" := PurchHeader."Consignment Code";
    //         end;

    //     end;


    //     procedure TreatItemChargeVAT(var ItemJnlLine: Record "Item Journal Line";ItemChargePurchLine: Record "Purchase Line")
    //     begin
    //         if (ItemChargePurchLine."VAT Treatment" <> ItemChargePurchLine."vat treatment"::Recovered) then
    //           ItemJnlLine.Amount := ItemJnlLine.Amount * (1 + ItemChargePurchLine."VAT %" / 100);
    //     end;


    //     procedure CheckDateOnFillInvPostBufferOnPurchPost(PurchLine: Record "Purchase Line")
    //     var
    //         PurchHeader: Record "Purchase Header";
    //         PurchRcptHeader: Record "Purch. Rcpt. Header";
    //         ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    //     begin
    //         PurchHeader.Get(PurchLine."Document Type",PurchLine."Document No.");
    //         PurchHeader.TestField("Posting Date");
    //         if PurchLine."Receipt No." <> '' then begin
    //           PurchRcptHeader.Get(PurchLine."Receipt No.");
    //           if PurchHeader."Posting Date" < PurchRcptHeader."Posting Date" then
    //             Error(Text999);
    //         end;
    //         if PurchLine.Type = PurchLine.Type::"Charge (Item)" then begin
    //           ItemChargeAssgntPurch.SetRange("Document Type",PurchLine."Document Type");
    //           ItemChargeAssgntPurch.SetRange("Document No.",PurchLine."Document No.");
    //           ItemChargeAssgntPurch.SetRange("Document Line No.",PurchLine."Line No.");
    //           ItemChargeAssgntPurch.FindFirst;
    //           repeat
    //             if ItemChargeAssgntPurch."Applies-to Doc. Type" = ItemChargeAssgntPurch."applies-to doc. type"::Receipt then begin
    //               PurchRcptHeader.Get(ItemChargeAssgntPurch."Applies-to Doc. No.");
    //               if PurchHeader."Posting Date" < PurchRcptHeader."Posting Date" then
    //                 Error(Text999);
    //             end;
    //           until ItemChargeAssgntPurch.Next = 0;
    //         end;
    //         if PurchLine."Job No." <> '' then
    //           PurchLine.TestField(Type,PurchLine.Type::"G/L Account");
    //     end;


    //     procedure FillInvPostBufferOnPurchPost(PurchLine: Record "Purchase Line";PurchLineACY: Record "Purchase Line";var InvPostingBuffer: Record "Invoice Post. Buffer")
    //     var
    //         ConsignmentHeader: Record "Consignment Header";
    //     begin
    //         if PurchLine."Prepayment Line" then
    //           InvPostingBuffer."PO No." := PurchLine."Document No.";

    //         if PurchLine."Job Task No." <> '' then begin
    //           PurchLine.TestField("Job No.");
    //           //InvPostingBuffer."Job Task No." := PurchLine."Job Task No.";
    //         end;

    //         if (PurchLine."VAT Treatment" <> PurchLine."vat treatment"::Recovered) and (PurchLine."Prepayment Line" = false)  then
    //           begin
    //             InvPostingBuffer.Amount := InvPostingBuffer.Amount + InvPostingBuffer."VAT Amount";
    //             InvPostingBuffer."VAT Amount" := 0;
    //           end;
    //         InvPostingBuffer."Direct Cost Invoice" := PurchLine."Direct Cost Invoice";
    //         if PurchLine."Consignment Code" <> '' then begin
    //           PurchLine.TestField("Job No.",'');
    //           PurchLine.TestField("Job Task No.",'');
    //           InvPostingBuffer."Consignment Code" := PurchLine."Consignment Code";
    //           InvPostingBuffer."Consignment Charge Code" := PurchLine."Consignment Charge Code";
    //           InvPostingBuffer."PO No." := PurchLine."Order No.";
    //           ConsignmentHeader.Get(PurchLine."Consignment Code");
    //           if not ConsignmentHeader.ConsignmentQtyLineExsists then
    //             Error(Text1004,ConsignmentHeader."No.");
    //         end;
    //     end;


    //     procedure UpdateInvPostBufferOnPurchPost(var InvPostingBuffer1: Record "Invoice Post. Buffer";var InvPostingBuffer2: Record "Invoice Post. Buffer")
    //     begin
    //     end;


    //     procedure CreatePremptLineSuspendStatusCheckOnPurchPost(var TempPrepmtPurchLine: Record "Purchase Line")
    //     begin
    //         TempPrepmtPurchLine.SuspendStatusCheck := true
    //     end;


    //     procedure CreatePremptLineOnPurchPost(var TempPrepmtPurchLine: Record "Purchase Line";PurchLine: Record "Purchase Line")
    //     begin
    //         TempPrepmtPurchLine.Validate("WHT Posting Group",PurchLine."WHT Posting Group");
    //     end;


    //     procedure AllowArchivingOfOrder(PurchHeader: Record "Purchase Header"): Boolean
    //     begin
    //         PurchSetup.Get;
    //         if PurchSetup."Archive Order on Invoice only" and (not PurchHeader.Invoice) then
    //           exit(false)
    //         else
    //           exit(true)
    //     end;


    //     procedure UpdatePurchLineOnPrepmtInvPost(var PurchLine: Record "Purchase Line")
    //     begin
    //         PurchLine."Order Prepmt. Amt. Inv." := PurchLine."Prepmt. Amt. Inv.";
    //         PurchLine."Order Prepmt. Amt. Incl. VAT" := PurchLine."Prepmt. Amt. Incl. VAT";
    //         PurchLine."Order Prep. Amt Inv. Incl. VAT" := PurchLine."Prepmt. Amount Inv. Incl. VAT";
    //         PurchLine."Original Prepmt. Amt Inv.(LCY)" := PurchLine."Prepmt. Amount Inv. (LCY)";
    //     end;


    //     procedure UpdatePurchLineOnPrepmtCrdMemoPost(var PurchLine: Record "Purchase Line")
    //     begin
    //         PurchLine."Order Prepmt. Amt. Inv." := PurchLine."Prepmt. Amt. Inv.";
    //         PurchLine."Order Prepmt. Amt. Incl. VAT" := PurchLine."Prepmt. Amt. Incl. VAT";
    //         PurchLine."Order Prep. Amt Inv. Incl. VAT" := PurchLine."Prepmt. Amount Inv. Incl. VAT";
    //         PurchLine."Original Prepmt. Amt Inv.(LCY)" := PurchLine."Prepmt. Amount Inv. (LCY)";
    //     end;


    //     procedure ReleasePurchDocumentCheck(var PurchHeader: Record "Purchase Header";Prepayment: Boolean)
    //     var
    //         PurchReqHeader: Record "Purchase Req. Header";
    //     begin
    //         if PurchHeader."Consignment Recognition" then//Created from Consignment Recognition
    //           exit;
    //         if Prepayment then begin
    //            CheckForConfirmation(PurchHeader);
    //            CreateCommitment(PurchHeader);
    //            exit;
    //         end else begin
    //           if (PurchHeader."Document Type" = PurchHeader."document type"::Order) then begin
    //             CheckForConfirmation(PurchHeader);
    //             if PurchHeader."PRN No." <> '' then begin
    //               PurchReqHeader.SetRange("No.",PurchHeader."PRN No.");
    //               PurchReqHeader.ModifyAll("Order Approved Date",Today);
    //             end;
    //             PurchHeader."Order Date" := Today;
    //           end;
    //           PurchHeader."Receiving No. Series" := GetReceiptNo(PurchHeader);
    //           if PurchHeader."Document Type"  in[1,2] then
    //             CreateCommitment(PurchHeader);
    //         end;
    //         if (PurchHeader."Document Type" = PurchHeader."document type"::Order) and (PurchHeader."Order Type" = PurchHeader."order type"::"Service PO") then
    //           PurchHeader."Service Posting Date" := 0D;
    //     end;


    //     procedure UpdateItemChargePurchAssgnment(var ItemChargeAssgntPurch2: Record "Item Charge Assignment (Purch)")
    //     begin
    //         ItemChargeAssgntPurch2."Original Qty. to Assign" := ItemChargeAssgntPurch2."Qty. to Assign";
    //     end;


    //     procedure MarkDeliveryToleranceEntry(PurchHeader: Record "Purchase Header";PurchLine: Record "Purchase Line";PurchRcptLine: Record "Purch. Rcpt. Line")
    //     var
    //         lLicPermission: Record "License Permission";
    //         lDeliveryToleranceEntry: Record "Delivery Tolerance Entry";
    //     begin
    //         lLicPermission.Get(lLicPermission."object type"::Codeunit, Codeunit::"Delivery Tolerance Mgt");
    //         if lLicPermission."Execute Permission" = lLicPermission."execute permission"::Yes then begin

    //           if PurchLine."Delivery Tolerance Code" <> '' then begin

    //             lDeliveryToleranceEntry.Reset;
    //             lDeliveryToleranceEntry.SetCurrentkey("Source Type 1", "Source Subtype 1", "Source ID 1", "Source Ref. No. 1");
    //             lDeliveryToleranceEntry.SetRange("Source Type 1", Database::"Purchase Line");
    //             lDeliveryToleranceEntry.SetRange("Source Subtype 1", PurchLine."Document Type");
    //             lDeliveryToleranceEntry.SetRange("Source ID 1", PurchLine."Document No.");
    //             lDeliveryToleranceEntry.SetRange("Source Ref. No. 1", PurchLine."Line No.");
    //             lDeliveryToleranceEntry.SetRange(Open, true);
    //             if lDeliveryToleranceEntry.FindFirst then begin
    //               lDeliveryToleranceEntry."Source Type 2" := Database::"Purch. Rcpt. Line";
    //               lDeliveryToleranceEntry."Source Subtype 2" := 0;
    //               lDeliveryToleranceEntry."Source ID 2" := PurchRcptLine."Document No.";
    //               lDeliveryToleranceEntry."Source Ref. No. 2" := PurchRcptLine."Line No.";
    //               lDeliveryToleranceEntry."Posting Date" := PurchHeader."Posting Date";
    //               lDeliveryToleranceEntry."Document Date" := PurchHeader."Document Date";
    //               lDeliveryToleranceEntry."External Document No." := PurchHeader."Vendor Shipment No.";
    //               lDeliveryToleranceEntry."Qty. to Handle" := PurchLine."Qty. to Receive";
    //               lDeliveryToleranceEntry."Qty. to Handle (Base)" := PurchLine."Qty. to Receive (Base)";
    //               lDeliveryToleranceEntry.Open := false;
    //               lDeliveryToleranceEntry.Modify;
    //             end;

    //           end;

    //         end;
    //     end;


    //     procedure UndoDeliveryTolerance(lPurchRcptLine: Record "Purch. Rcpt. Line")
    //     var
    //         lLicPermission: Record "License Permission";
    //         lDeliveryToleranceEntry: Record "Delivery Tolerance Entry";
    //     begin
    //         lLicPermission.Get(lLicPermission."object type"::Codeunit, Codeunit::"Delivery Tolerance Mgt");
    //         if lLicPermission."Execute Permission" = lLicPermission."execute permission"::Yes then begin
    //           lDeliveryToleranceMgt.UndoPurchLineDelivTolerance(lPurchRcptLine);
    //         end;
    //     end;


    //     procedure CheckDeliveryTolerance(lCurrFieldNo: Integer;var PurchLine: Record "Purchase Line")
    //     var
    //         lLicPermission: Record "License Permission";
    //         lDeliveryToleranceEntry: Record "Delivery Tolerance Entry";
    //     begin
    //         lLicPermission.Get(lLicPermission."object type"::Codeunit, Codeunit::"Delivery Tolerance Mgt");
    //         if lLicPermission."Execute Permission" = lLicPermission."execute permission"::Yes then begin
    //           lDeliveryToleranceMgt.CheckPurchLineDelivTolerance(PurchLine,lCurrFieldNo);
    //         end;
    //     end;


    //     procedure DeleteDeliveryToleranceEntry(var PurchLine: Record "Purchase Line")
    //     var
    //         lLicPermission: Record "License Permission";
    //         lDeliveryToleranceEntry: Record "Delivery Tolerance Entry";
    //     begin
    //         lLicPermission.Get(lLicPermission."object type"::Codeunit, Codeunit::"Delivery Tolerance Mgt");
    //         if lLicPermission."Execute Permission" = lLicPermission."execute permission"::Yes then begin
    //           lDeliveryToleranceMgt.DeleteDeliveryToleranceEntry(Database::"Purchase Line",PurchLine."Document Type",
    //             PurchLine."Document No.",PurchLine."Line No.");
    //         end;
    //     end;


    procedure GetReqLineAccountNo(var PurchReqLine: Record "Requisition Line")
    var
        InvtPostingSetup: Record "Inventory Posting Setup";
        Item: Record Item;
        FAPostingGr: Record "FA Posting Group";
        FADeprBook: Record "FA Depreciation Book";
    begin
        with PurchReqLine do begin
            case PurchReqLine.Type of
                PurchReqLine.Type::"G/L Account":
                    PurchReqLine."Account No." := PurchReqLine."No.";
                PurchReqLine.Type::Item:
                    begin
                        Item.Get(PurchReqLine."No.");
                        Item.TestField("Inventory Posting Group");
                        if InvtPostingSetup.Get(PurchReqLine."Location Code", Item."Inventory Posting Group") then
                            PurchReqLine."Account No." := InvtPostingSetup."Inventory Account"
                    end;
            /*PurchReqLine.Type::"Fixed Asset":
                begin
                    if PurchReqLine."Depreciation Book Code" = '' then
                        exit;
                    FADeprBook.Get("No.", "Depreciation Book Code");
                    FADeprBook.TestField("FA Posting Group");
                    FAPostingGr.Get(FADeprBook."FA Posting Group");
                    case PurchReqLine."FA Posting Type" of
                        PurchReqLine."fa posting type"::"Acquisition Cost":
                            PurchReqLine."Account No." := FAPostingGr."Acquisition Cost Account";
                        PurchReqLine."fa posting type"::Maintenance:
                            PurchReqLine."Account No." := FAPostingGr."Maintenance Expense Account";
                    end;
                end;*/
            end;
        end;
    end;

    //     local procedure GetFAPostingGroup(var PurchReqLine: Record "Requisition Line")
    //     var
    //         LocalGLAcc: Record "G/L Account";
    //         FAPostingGr: Record "FA Posting Group";
    //         FA: Record "Fixed Asset";
    //         FADeprBook: Record "FA Depreciation Book";
    //         FASetup: Record "FA Setup";
    //     begin
    //         with PurchReqLine do begin
    //           if (Type <> Type::"Fixed Asset") or ("No." = '') then
    //             exit;
    //           if "Depreciation Book Code" = '' then begin
    //             FASetup.Get;
    //             "Depreciation Book Code" := FASetup."Default Depr. Book";
    //             if not FADeprBook.Get("No.","Depreciation Book Code") then
    //               "Depreciation Book Code" := '';
    //             if "Depreciation Book Code" = '' then
    //               exit;
    //           end;
    //           if "FA Posting Type" = "fa posting type"::" " then
    //             "FA Posting Type" := "fa posting type"::"Acquisition Cost";
    //           FADeprBook.Get("No.","Depreciation Book Code");
    //           FADeprBook.TestField("FA Posting Group");
    //           FAPostingGr.Get(FADeprBook."FA Posting Group");
    //           if "FA Posting Type" = "fa posting type"::"Acquisition Cost" then begin
    //             FAPostingGr.TestField("Acquisition Cost Account");
    //             LocalGLAcc.Get(FAPostingGr."Acquisition Cost Account");
    //           end else begin
    //             FAPostingGr.TestField("Maintenance Expense Account");
    //             LocalGLAcc.Get(FAPostingGr."Maintenance Expense Account");
    //           end;
    //           LocalGLAcc.CheckGLAcc;
    //           LocalGLAcc.TestField("Gen. Prod. Posting Group");
    //         end;
    //     end;


    //     procedure ReqLineOnInsert(var PurchReqLine: Record "Requisition Line")
    //     var
    //         ReqWkshName: Record "Requisition Wksh. Name";
    //         PurchReqType: Record "Purchase Req. Type";
    //     begin
    //         with PurchReqLine do begin
    //           ReqWkshName.Get("Worksheet Template Name","Journal Batch Name");
    //           ReqWkshName.TestField(Status,ReqWkshName.Status::Open);
    //           begin
    //             "Requester ID" := ReqWkshName."User ID";
    //             if "Shortcut Dimension 1 Code" = '' then
    //               "Shortcut Dimension 1 Code" := ReqWkshName."Shortcut Dimension 1 Code";
    //             if "Shortcut Dimension 2 Code" = '' then
    //               "Shortcut Dimension 2 Code" := ReqWkshName."Shortcut Dimension 2 Code";
    //             "Expected Receipt Date" := ReqWkshName."Expected Receipt Date";
    //             if "Job No." = '' then begin
    //               "Job No." := ReqWkshName."Job No.";
    //               "Job Task No." := ReqWkshName."Job Task No.";
    //             end;
    //             PurchReqType.Get(ReqWkshName."Purchase Req. Code");
    //             PurchReqType.ValidateDimCode(1,"Shortcut Dimension 1 Code");
    //             PurchReqType.ValidateDimCode(2,"Shortcut Dimension 2 Code");
    //           end;
    //         end;
    //         //
    //     end;


    procedure ReqLineAccNoOnValidate(var PurchReqLine: Record "Requisition Line")
    var
        ReqWkshName: Record "Requisition Wksh. Name";
        PurchReqType: Record "Purchase Req. Type";
    begin
        with PurchReqLine do begin
            if PurchReqLine."Worksheet Template Name" <> 'P-REQ' then
                exit;
            if (PurchReqLine."No." <> '') then begin
                ReqWkshName.Get("Worksheet Template Name", "Journal Batch Name");
                PurchReqType.Get(ReqWkshName."Purchase Req. Code");
                PurchReqType.ValidateAccountNo(Type, "No.");
                PurchReqType.ValidateDimCode(1, "Shortcut Dimension 1 Code");
                PurchReqType.ValidateDimCode(2, "Shortcut Dimension 2 Code");

                /*if PurchReqLine.Type = PurchReqLine.Type::"Fixed Asset" then
                  GetFAPostingGroup(PurchReqLine);
                GetReqLineAccountNo(PurchReqLine);*/
            end;
        end;
    end;


    procedure CheckValidateReqDim(var PurchReqLine: Record "Requisition Line")
    var
        ReqWkshName: Record "Requisition Wksh. Name";
        PurchReqType: Record "Purchase Req. Type";
    begin
        with PurchReqLine do begin

            if PurchReqLine."Worksheet Template Name" <> 'P-REQ' then
                exit;
            ReqWkshName.Get("Worksheet Template Name", "Journal Batch Name");
            PurchReqType.Get(ReqWkshName."Purchase Req. Code");
            PurchReqType.ValidateDimCode(1, "Shortcut Dimension 1 Code");
            PurchReqType.ValidateDimCode(2, "Shortcut Dimension 2 Code");
        end;
    end;


    procedure CheckValidateReqType(var PurchReqLine: Record "Requisition Line")
    var
        ReqWkshName: Record "Requisition Wksh. Name";
        PurchReqType: Record "Purchase Req. Type";
    begin
        with PurchReqLine do begin
            if PurchReqLine."Worksheet Template Name" <> 'P-REQ' then
                exit;

            ReqWkshName.Get("Worksheet Template Name", "Journal Batch Name");
            PurchReqType.Get(ReqWkshName."Purchase Req. Code");
            PurchReqType.ValidateAccountNo(Type, "No.");
        end;
    end;


    //     procedure CheckFAAcquisitionOnReq(var PurchReqLine: Record "Requisition Line")
    //     var
    //         FA: Record "Fixed Asset";
    //         FALedger: Record "FA Ledger Entry";
    //     begin
    //         with PurchReqLine do begin
    //           if PurchReqLine."Worksheet Template Name" <> 'P-REQ' then
    //             exit;

    //           if Type = Type::"Fixed Asset" then
    //             if "No." <> ''then begin
    //               FA.Get("No.");
    //               FALedger.SetRange("FA No.","No.");
    //               if (FALedger.FindFirst) and ("Maintenance Code" = '') then
    //                 Error(FAAcqErr);
    //             end;
    //         end;
    //     end;


    //     procedure GetPurchaserName(PurchaserCode: Code[10]): Text[50]
    //     var
    //         Purchaser: Record "Salesperson/Purchaser";
    //     begin
    //         if PurchaserCode <> '' then begin
    //           Purchaser.Get(PurchaserCode);
    //           exit(Purchaser.Name);
    //         end else
    //           exit('');
    //     end;


    //     procedure GetPurchaseReceiptDate(var ReceiptNo: Code[20]): Date
    //     var
    //         PurchReceiptHeader: Record "Purch. Rcpt. Header";
    //     begin
    //         if ReceiptNo <> '' then begin
    //           PurchReceiptHeader.Get(ReceiptNo);
    //           exit(PurchReceiptHeader."Posting Date");
    //         end else
    //           exit(0D);
    //     end;

    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnAfterManualReleasePurchaseDoc', '', false, false)]
    //     local procedure OnAfterManualReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header";PreviewMode: Boolean)
    //     begin
    //         if not(PreviewMode) then
    //           SendPOAsEmailAttachment(PurchaseHeader);
    //     end;


    //     procedure SendPOAsEmailAttachment(PurchHeader: Record "Purchase Header")
    //     var
    //         Vendor: Record Vendor;
    //         PurchaserCode: Record "Salesperson/Purchaser";
    //         PurchHeader2: Record "Purchase Header";
    //         ReportSelection: Record "Report Selections";
    //         FileNameServer: Text;
    //         Subject: Text;
    //         Body: Text;
    //         FileManagement: Codeunit "File Management";
    //         SMTP: Codeunit "SMTP Mail";
    //     begin
    //         PurchSetup.Get;
    //         if not (PurchSetup."Send PO on Approval") then
    //           exit;
    //         if PurchHeader.Status <> PurchHeader.Status::Released then
    //           exit;
    //         if PurchHeader."Document Type" <> PurchHeader."document type"::Order then
    //           exit;

    //         ReportSelection.SetRange(Usage,ReportSelection.Usage::"P.Order");
    //         ReportSelection.SetFilter("Report ID",'<>0');
    //         ReportSelection.Find('-');

    //         Vendor.Get(PurchHeader."Buy-from Vendor No.");
    //         PurchaserCode.Get(PurchHeader."Purchaser Code");
    //         PurchaserCode.TestField("E-Mail");
    //         Vendor.TestField("E-Mail");
    //         Subject := Text101;
    //         Body := StrSubstNo(Text102,PurchHeader."No.");
    //         PurchHeader2:= PurchHeader;
    //         PurchHeader2.SetRecfilter;
    //         FileNameServer := FileManagement.ServerTempFileName('pdf');
    //         Report.SaveAsPdf(ReportSelection."Report ID",FileNameServer,PurchHeader2);
    //         SMTP.CreateMessage(COMPANYNAME,PurchaserCode."E-Mail",Vendor."E-Mail",Subject,Body,true);
    //         SMTP.AddAttachment('Purchase Order',FileNameServer);
    //         SMTP.AddCC(PurchaserCode."E-Mail");
    //         SMTP.Send;
    //         if Erase(FileNameServer) then;
    //     end;


    //     procedure SendPOCancellationMail(PurchHeader: Record "Purchase Header")
    //     var
    //         Vendor: Record Vendor;
    //         PurchaserCode: Record "Salesperson/Purchaser";
    //         PurchHeader2: Record "Purchase Header";
    //         ReportSelection: Record "Report Selections";
    //         SMTPSetup: Record "SMTP Mail Setup";
    //         PurchOrder: Report "Order";
    //         FileNameServer: Text;
    //         Subject: Text;
    //         Body: Text;
    //         FileManagement: Codeunit "File Management";
    //         SMTP: Codeunit "SMTP Mail";
    //     begin
    //         PurchSetup.Get;
    //         if not (PurchSetup."Send PO on Approval") then
    //           exit;

    //         if PurchHeader."Document Type" <> PurchHeader."document type"::Order then
    //           exit;

    //         if not Confirm(Text1006,false) then
    //           exit;
    //         Vendor.Get(PurchHeader."Buy-from Vendor No.");
    //         PurchaserCode.Get(PurchHeader."Purchaser Code");
    //         PurchaserCode.TestField("E-Mail");
    //         Vendor.TestField("E-Mail");
    //         Subject := StrSubstNo(Text103,PurchHeader."No.",PurchHeader."Buy-from Vendor Name");
    //         Body := StrSubstNo(Text104,PurchHeader."No.");
    //         PurchHeader2:= PurchHeader;
    //         PurchHeader2.SetRecfilter;
    //         FileNameServer := FileManagement.ServerTempFileName('pdf');
    //         PurchOrder.SetTableview(PurchHeader2);
    //         //PurchOrder.SetCalledFromEmail(TRUE);
    //         PurchOrder.SaveAsPdf(FileNameServer);
    //         SMTPSetup.Get;
    //         SMTP.CreateMessage(COMPANYNAME,SMTPSetup."User ID",Vendor."E-Mail",Subject,Body,true);
    //         SMTP.AddAttachment(FileNameServer,StrSubstNo('%1.pdf','Purchase Order'));
    //         SMTP.AddCC(PurchaserCode."E-Mail");
    //         SMTP.Send;
    //         if Erase(FileNameServer) then;
    //     end;


    //     procedure CheckPOAttached(PurchLine: Record "Purchase Line")
    //     var
    //         PurchHeader2: Record "Purchase Header";
    //     begin
    //         with PurchLine do begin
    //           if ("Document Type" = "document type"::Invoice) then begin
    //             PurchHeader2.SetRange(PurchHeader2."Document Type","Document Type");
    //             PurchHeader2.SetRange(PurchHeader2."No.","Document No.");
    //             PurchHeader2.Find('-');
    //             if PurchHeader2."Order No." = '' then
    //               PurchHeader2.TestField(PurchHeader2."No PO Attached",true);
    //             if ("Receipt No." = '') then begin
    //               if not(Type in [Type::" ",Type::"Charge (Item)"]) then
    //                 PurchHeader2.TestField(PurchHeader2."No PO Attached",true);
    //             end;
    //           end;
    //         end;
    //     end;


    //     procedure CheckInvChange(PurchLine: Record "Purchase Line")
    //     var
    //         PurchHeader: Record "Purchase Header";
    //     begin
    //         with PurchLine do begin
    //           PurchHeader.Get("Document Type",PurchLine."Document No.");
    //           if ("Document Type" = "document type"::Invoice) then begin
    //             if (PurchHeader."No PO Attached" = false) or (PurchLine."PRN No." <> '') then
    //               Error('Entry cannot be changed');
    //           end;
    //         end
    //     end;


    procedure OnValidatePRNStatus(var PRN: Record "Requisition Wksh. Name")
    var
        Employee: Record Employee;
        GlobalSender: Text;
    begin
        with PRN do begin
            PurchSetup.Get;
            if Status <> Status::Open then
                TestField("Beneficiary No.");
            if (Status in [1, 2]) and ("Worksheet Template Name" = 'P-REQ') then begin
                "PRN Approved Date" := Today;
                CreatePRNCommitment(PRN);
            end else
                if (Status in [0, 3]) and ("Worksheet Template Name" = 'P-REQ') then
                    DeletePRNCommitment(PRN);
        end;
    end;


    //     procedure GetCurrency(CurrencyCode: Code[20])
    //     begin
    //         if CurrencyCode = '' then
    //           Currency.InitRoundingPrecision
    //         else begin
    //           Currency.Get(CurrencyCode);
    //           Currency.TestField("Amount Rounding Precision");
    //         end;
    //     end;

    //     [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateVATProdPostingGroupOnBeforeCheckVATCalcType', '', false, false)]

    //     procedure CheckTINOnValidateVAT(var PurchaseLine: Record "Purchase Line";VATPostingSetup: Record "VAT Posting Setup";var IsHandled: Boolean)
    //     var
    //         PurchHeader: Record "Purchase Header";
    //     begin
    //         PurchSetup.Get;
    //         if (PurchSetup."TIN Mandatory for VAT")  and (PurchaseLine."VAT %" <> 0) then begin
    //           PurchHeader.Get(PurchaseLine."Document Type",PurchaseLine."Document No.");
    //           Vendor.Get(PurchHeader."Buy-from Vendor No.");
    //           if Vendor."TIN Identification No." = '' then
    //             Error(TINErr)
    //         end;
    //     end;


    procedure CreatePRNCommitment(var PRN: Record "Requisition Wksh. Name")
    var
        PRNLine: Record "Requisition Line";
        AnalysisView: Record "Analysis View";
    begin
        GLSetup.Get;
        PayMgtSetup.Get;
        if PayMgtSetup."Budget Expense Control Enabled" then begin
            AnalysisView.Get(PayMgtSetup."Budget Analysis View Code");
            with PRNLine do begin
                SetRange("Worksheet Template Name", PRN."Worksheet Template Name");
                SetRange("Journal Batch Name", PRN.Name);
                SetFilter("Account No.", AnalysisView."Account Filter");
                if Find('-') then
                    repeat
                        if BudgetControlMgt.ControlBudget("Account No.") then
                            case PRN."Worksheet Template Name" of
                                'P-REQ':
                                    begin
                                        BudgetControlMgt.UpdateCommitment("Journal Batch Name", "Line No.", PRN."Creation Date",
                                          PRNLine."Est. Amount (LCY)", "Account No.", "Dimension Set ID");
                                    end;
                                'RFQ':
                                    begin
                                        BudgetControlMgt.UpdateCommitment("Journal Batch Name", "Line No.", PRN."Creation Date",
                                          PRNLine."Est. Amount (LCY)", "Account No.", "Dimension Set ID");
                                    end;
                            end;
                    until Next = 0;
            end;
        end;
    end;


    procedure DeletePRNCommitment(var PRN: Record "Requisition Wksh. Name")
    var
        PRNLine: Record "Requisition Line";
        AnalysisView: Record "Analysis View";
    begin
        GLSetup.Get;
        PayMgtSetup.Get;
        if PayMgtSetup."Budget Expense Control Enabled" then begin
            AnalysisView.Get(PayMgtSetup."Budget Analysis View Code");
            with PRNLine do begin
                SetRange("Worksheet Template Name", PRN."Worksheet Template Name");
                SetRange(PRNLine."Journal Batch Name", PRN.Name);
                SetFilter("Account No.", AnalysisView."Account Filter");
                if Find('-') then
                    repeat
                        BudgetControlMgt.DeleteCommitment("Journal Batch Name", "Line No.", "Account No.");
                    until Next = 0;
            end;
        end;
    end;


    procedure CheckPRNBudgetEntry(var PRN: Record "Requisition Wksh. Name")
    var
        RecRef: RecordRef;
        PRNLine: Record "Requisition Line";
        AnalysisView: Record "Analysis View";
        GLAccount: Record "G/L Account";
        TotalExpAmount: Decimal;
        TotalBudgetAmount: Decimal;
        TotalCommittedAmount: Decimal;
        Variance: Decimal;
        Text035: label 'No Budget Entry created for Account %1, please Contact your Budget Control Unit';
        Text036: label 'Your Expense for this Period have been Exceeded by =N= %1,Please Contact your Budget Control Unit';
        Text037: label 'Your Expense for this Period have been Exceeded by =N= %1, Do want to Continue?';
        Text038: label 'Transaction blocked to respect budget control';
        Text039: label 'The amount for account %1 will make you go above your budget\\ Please Contact your Budget Control Unit';
        Text040: label 'The amount for account %1 will make you go above your budget\\ Do you want to continue?';
        LineAmountLCY: Decimal;
        AboveBudget: Boolean;
        WorkflowMgt: Codeunit "Gems Workflow Event";
    begin
        GLSetup.Get;
        PayMgtSetup.Get;
        AboveBudget := false;
        if PayMgtSetup."Budget Expense Control Enabled" then begin
            AnalysisView.Get(PayMgtSetup."Budget Analysis View Code");
            PRNLine.SetRange("Journal Batch Name", PRN.Name);
            PRNLine.SetFilter(PRNLine."Account No.", AnalysisView."Account Filter");
            if PRNLine.Find('-') then begin
                repeat
                    if BudgetControlMgt.ControlBudget(PRNLine."Account No.") then begin
                        TotalExpAmount := 0;
                        TotalBudgetAmount := 0;
                        TotalCommittedAmount := 0;
                        Variance := 0;

                        BudgetControlMgt.GetAmounts(PRNLine."Dimension Set ID", PRN."Creation Date", PRNLine."Account No.",
                          TotalBudgetAmount, TotalExpAmount, TotalCommittedAmount);

                        if TotalBudgetAmount = 0 then
                            AboveBudget := true;
                        if (TotalBudgetAmount <> 0) then begin
                            if ((TotalExpAmount + TotalCommittedAmount) > TotalBudgetAmount) then
                                AboveBudget := true
                            else begin
                                LineAmountLCY := PRNLine."Est. Amount (LCY)";
                                if (TotalExpAmount + LineAmountLCY + TotalCommittedAmount) > TotalBudgetAmount then
                                    AboveBudget := true;

                            end;
                        end;
                    end;
                until PRNLine.Next = 0;
            end;
        end;
        RecRef.GetTable(PRN);
        if AboveBudget then
            WorkflowMgt.OnPurchaseRequisitionBudgetExceeded(RecRef)
        else
            WorkflowMgt.OnPurchaseRequisitionBudgetNotExceeded(RecRef);
    end;


    //     procedure OnInsertPO(var PurchHeader: Record "Purchase Header")
    //     var
    //         PRN: Record "Purchase Req. Header";
    //     begin
    //         if PurchHeader."Document Type" <> PurchHeader."document type"::Order then
    //           exit;
    //         if PurchHeader."PRN No." = '' then
    //           exit;
    //         PRN.Get('P-REQ',PurchHeader."PRN No.");
    //     end;


    //     procedure CheckPO(var PurchHeader: Record "Purchase Header")
    //     var
    //         Text001: label 'There is nothing to release for the document of type %1 with the number %2.';
    //         Text006: label '%1 must be specified.';
    //         PurchLine: Record "Purchase Line";
    //         Vend: Record Vendor;
    //         Text007: label '%1 must be %2 for %3 %4.';
    //         Text008: label '%1 %2 does not exist.';
    //         Text021: label '%1 must be 0 when %2 is 0.';
    //         Text041: label '%1 must not be %2 for %3 %4.';
    //         GLAcc: Record "G/L Account";
    //         Item: Record Item;
    //         FA: Record "Fixed Asset";
    //         InvtSetup: Record "Inventory Setup";
    //         TableID: array [10] of Integer;
    //         No: array [10] of Code[20];
    //         DimMgt: Codeunit DimensionManagement;
    //     begin
    //         with PurchHeader do begin
    //           if "Buy-from Vendor No." = '' then
    //             Error(StrSubstNo(Text006,FieldCaption("Buy-from Vendor No.")))
    //           else begin
    //             if Vend.Get("Buy-from Vendor No.") then begin
    //               if Vend.Blocked = Vend.Blocked::All then
    //                 Error(
    //                   StrSubstNo(
    //                     Text041,
    //                     Vend.FieldCaption(Blocked),Vend.Blocked,Vend.TableCaption,"Buy-from Vendor No."));
    //             end else
    //               Error(
    //                 StrSubstNo(
    //                   Text008,
    //                   Vend.TableCaption,"Buy-from Vendor No."));
    //           end;

    //           if "Pay-to Vendor No." = '' then
    //             Error(StrSubstNo(Text006,FieldCaption("Pay-to Vendor No.")))
    //           else
    //             if "Pay-to Vendor No." <> "Buy-from Vendor No." then begin
    //               if Vend.Get("Pay-to Vendor No.") then begin
    //                 if Vend.Blocked = Vend.Blocked::All then
    //                   Error(
    //                     StrSubstNo(
    //                       Text041,
    //                       Vend.FieldCaption(Blocked),Vend.Blocked::All,Vend.TableCaption,"Pay-to Vendor No."));
    //               end else
    //                 Error(
    //                   StrSubstNo(
    //                     Text008,
    //                     Vend.TableCaption,"Pay-to Vendor No."));
    //             end;
    //           if not DimMgt.CheckDimIDComb("Dimension Set ID") then
    //             Error(DimMgt.GetDimCombErr);
    //           case PurchHeader."Document Type" of
    //             PurchHeader."document type"::Invoice:
    //               begin
    //                 TableID[1] := Database::Vendor;
    //                 No[1] := "Pay-to Vendor No.";
    //                 TableID[3] := Database::"Salesperson/Purchaser";
    //                 No[3] := "Purchaser Code";
    //                 TableID[4] := Database::Campaign;
    //                 No[4] := "Campaign No.";
    //                 TableID[5] := Database::"Responsibility Center";
    //                 No[5] := "Responsibility Center";

    //                 if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
    //                   Error(DimMgt.GetDimValuePostingErr);
    //               end;
    //           end;
    //           PurchLine.SetRange("Document Type","Document Type");
    //           PurchLine.SetRange("Document No.","No.");
    //           PurchLine.SetFilter(Type,'>0');
    //           PurchLine.SetFilter(Quantity,'<>0');
    //           if not PurchLine.Find('-') then
    //             Error(Text001,"Document Type","No.");
    //           InvtSetup.Get;
    //           if InvtSetup."Location Mandatory" then begin
    //             PurchLine.SetRange(Type,PurchLine.Type::Item);
    //             if PurchLine.Find('-') then
    //               repeat
    //                 if not PurchLine.IsNonInventoriableItem then
    //                   PurchLine.TestField("Location Code");
    //               until PurchLine.Next = 0;
    //             PurchLine.SetFilter(Type,'>0');
    //           end;
    //           PurchLine.Find('-');
    //           with PurchLine do begin
    //             repeat
    //               if PurchLine.Quantity <> 0 then begin
    //                 if "No." = '' then
    //                   Error(StrSubstNo(Text006,FieldCaption("No.")));
    //                 if Type = 0 then
    //                   Error(StrSubstNo(Text006,FieldCaption(Type)));
    //               end else
    //                 if Amount <> 0 then
    //                   Error(StrSubstNo(Text021,FieldCaption(Amount),FieldCaption(Quantity)));

    //               if (PurchLine.Quantity <> 0) or (PurchLine.Amount <> 0) then
    //                 TestField("No.");

    //               case Type of
    //                 Type::"G/L Account":
    //                   begin
    //                     if ("No." = '') and (Amount = 0) then
    //                       exit;

    //                     if "No." <> '' then
    //                       if GLAcc.Get("No.") then begin
    //                         if GLAcc.Blocked then
    //                           Error(
    //                             StrSubstNo(
    //                               Text007,
    //                               GLAcc.FieldCaption(Blocked),false,GLAcc.TableCaption,"No."));
    //                       end else
    //                         Error(
    //                           StrSubstNo(
    //                             Text008,
    //                             GLAcc.TableCaption,"No."));
    //                   end;
    //                 Type::Item:
    //                   begin
    //                     if ("No." = '') and (Quantity = 0) then
    //                       exit;

    //                     if "No." <> '' then
    //                       if Item.Get("No.") then begin
    //                         if Item.Blocked then
    //                           Error(
    //                             StrSubstNo(
    //                               Text007,
    //                               Item.FieldCaption(Blocked),false,Item.TableCaption,"No."));
    //                       end else
    //                         Error(
    //                           StrSubstNo(
    //                             Text008,
    //                             Item.TableCaption,"No."));
    //                   end;
    //                 Type::"Fixed Asset":
    //                   begin
    //                     if ("No." = '') and (Quantity = 0) then
    //                       exit;

    //                     if "No." <> '' then
    //                       if FA.Get("No.") then begin
    //                         if FA.Blocked then
    //                           Error(
    //                             StrSubstNo(
    //                               Text007,
    //                               FA.FieldCaption(Blocked),false,FA.TableCaption,"No."));
    //                         if FA.Inactive then
    //                           Error(
    //                             StrSubstNo(
    //                               Text007,
    //                               FA.FieldCaption(Inactive),false,FA.TableCaption,"No."));
    //                       end else
    //                         Error(
    //                           StrSubstNo(
    //                             Text008,
    //                             FA.TableCaption,"No."));
    //                   end;
    //               end;
    //               if not DimMgt.CheckDimIDComb("Dimension Set ID") then
    //                 Error(DimMgt.GetDimCombErr);

    //               TableID[1] := DimMgt.TypeToTableID3(Type);
    //               No[1] := "No.";
    //               TableID[2] := Database::Job;
    //               No[2] := "Job No.";
    //               TableID[3] := Database::"Work Center";
    //               No[3] := "Work Center No.";
    //               if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
    //                 Error(DimMgt.GetDimValuePostingErr);
    //             until PurchLine.Next = 0;
    //           end;
    //         end;
    //     end;


    //     procedure PRNInitOutstanding(var PRNLine: Record "Requisition Line")
    //     begin
    //         /*WITH PRNLine DO BEGIN
    //           "Outstanding Quantity" := "Requested Quantity" - "Quantity on RFQ";
    //         END;*/

    //     end;


    //     procedure GetPurchLineAccountNo(var PurchLine: Record "Purchase Line")
    //     var
    //         InvtPostingSetup: Record "Inventory Posting Setup";
    //         Item: Record Item;
    //         FAPostingGr: Record "FA Posting Group";
    //         FADeprBook: Record "FA Depreciation Book";
    //     begin
    //         with PurchLine do begin
    //           case PurchLine.Type of
    //             PurchLine.Type::"G/L Account": PurchLine."Account No." := PurchLine."No.";
    //             PurchLine.Type::Item:
    //               begin
    //                 Item.Get(PurchLine."No.");
    //                 Item.TestField("Inventory Posting Group");
    //                 InvtPostingSetup.Get(PurchLine."Location Code",Item."Inventory Posting Group");
    //                 PurchLine."Account No." := InvtPostingSetup."Inventory Account";
    //               end;
    //             PurchLine.Type::"Fixed Asset":
    //               begin
    //                 if PurchLine."Depreciation Book Code" = '' then
    //                   exit;
    //                 FADeprBook.Get("No.","Depreciation Book Code");
    //                 FADeprBook.TestField("FA Posting Group");
    //                 FAPostingGr.Get(FADeprBook."FA Posting Group");
    //                 case PurchLine."FA Posting Type" of
    //                   PurchLine."fa posting type"::"Acquisition Cost" :
    //                     PurchLine."Account No." := FAPostingGr."Acquisition Cost Account";
    //                   PurchLine."fa posting type"::Maintenance :
    //                     PurchLine."Account No." := FAPostingGr."Maintenance Expense Account";
    //                 end;
    //               end;
    //           end;
    //         end;
    //     end;


    //     procedure OnValidateNoPOAttached(var PurchHeader: Record "Purchase Header")
    //     begin
    //     end;


    //     procedure BlankDocumentExist(var ErrorReport: Text[250];var PurchHeader: Record "Purchase Header"): Boolean
    //     var
    //         lPurchHeader: Record "Purchase Header";
    //         Text109: label 'No. %1 created for %2 is not used.\New no. cannot be created, press escape and get the %2  %1!';
    //         Text110: label 'There are no lines on the header %1!\Press Escape and use the no to create a new %2 ';
    //     begin
    //         with PurchHeader do begin
    //           if ("Quote No." <> '') or ("RFQ No." <> '') or ("PRN No." <> '') then
    //             exit(false);

    //           ErrorReport := '';
    //           Clear(lPurchHeader);
    //           lPurchHeader.SetRange("Document Type","Document Type");
    //           lPurchHeader.SetFilter("No.",'<>%1','');
    //           lPurchHeader.SetRange("User ID",UpperCase(UserId));
    //           lPurchHeader.SetFilter("Buy-from Vendor No.",'=%1','');
    //           if "Document Type" in["document type"::Quote,"document type"::Order] then
    //             lPurchHeader.SetRange("Purchase Req. Code","Purchase Req. Code");
    //           if lPurchHeader.FindFirst then begin
    //             ErrorReport := StrSubstNo(Text109,lPurchHeader."No.",lPurchHeader."Document Type");
    //             exit(ErrorReport <> '');
    //           end;

    //           lPurchHeader.Reset;
    //           lPurchHeader.SetFilter("No.",'<>%1','');
    //           lPurchHeader.SetRange("Document Type","Document Type");
    //           lPurchHeader.SetFilter("Buy-from Vendor No.",'<>%1','');
    //           lPurchHeader.SetRange("User ID",UpperCase(UserId));
    //           if "Document Type" in["document type"::Quote,"document type"::Order] then
    //             lPurchHeader.SetRange("Purchase Req. Code","Purchase Req. Code");

    //           if lPurchHeader.FindFirst then
    //             repeat
    //               if not lPurchHeader.PurchLinesExist then
    //                 if ErrorReport = '' then
    //                   ErrorReport := StrSubstNo(Text110,lPurchHeader."No.",lPurchHeader."Document Type");
    //             until lPurchHeader.Next = 0;
    //             exit(ErrorReport <> '');

    //           Clear(lPurchHeader);
    //         end;
    //     end;


    //     procedure GetDocType(PurchHeader: Record "Purchase Header"): Integer
    //     begin
    //         with PurchHeader do begin
    //           case "Document Type" of
    //             "document type"::Quote:
    //               exit(2);
    //             "document type"::Order:
    //               exit(3);
    //           end; /*end case*/
    //         end;

    //     end;


    //     procedure CalculateExpiryDate(var PurchHeader: Record "Purchase Header")
    //     begin
    //         with PurchHeader do begin
    //           if "Document Type" <> "document type"::Order then
    //             exit;

    //           if (CalcDate("Validity Period",Today) = Today) or ("Order Date" = 0D) then
    //              exit;

    //           if "Revalidation Date" = 0D then
    //             "Expiry Date" := CalcDate("Validity Period","Order Date")
    //           else
    //             "Expiry Date" := CalcDate("Validity Period","Revalidation Date")
    //         end;
    //     end;


    //     procedure POAlreadyExpired(PurchHeader: Record "Purchase Header"): Boolean
    //     begin
    //         with PurchHeader do begin
    //           exit(("Expiry Date" < Today) and ("Expiry Date" <> 0D));
    //         end;
    //     end;


    //     procedure RevalidatePO(var PurchHeader: Record "Purchase Header")
    //     var
    //         Text60001: label 'Do you want to revalidate order %1?';
    //         Text60002: label 'PO fully serviced. Action aborted.';
    //         Text60003: label 'PO not yet expired.';
    //         PurchLine: Record "Purchase Line";
    //     begin
    //         with PurchHeader do begin
    //           if not Confirm(Text60001,false,"No.") then
    //             exit;
    //           with PurchHeader do begin
    //             PurchLine.SetRange("Document Type","Document Type");
    //             PurchLine.SetRange("Document No.","No.");
    //             PurchLine.SetFilter("Outstanding Quantity",'<>0');
    //             if not PurchLine.Find('-') then
    //               Error(Text60002);

    //             if not POAlreadyExpired(PurchHeader) then begin
    //               Message(Text60003);
    //               exit;
    //             end;

    //             "Revalidation Date" := Today;
    //             CalculateExpiryDate(PurchHeader);
    //             Modify;
    //           end
    //         end;
    //     end;


    //     procedure GetPurchaseRequestCode(var PurchHeader: Record "Purchase Header")
    //     var
    //         PurchaseReqTypeList: Page "Purchase Req. Types";
    //         PurchaseReqType: Record "Purchase Req. Type";
    //         Text60018: label 'Purchase Requisition Type %1 is blocked!';
    //         Text60019: label 'Action Aborted.';
    //     begin
    //         Clear(PurchaseReqTypeList);
    //         with PurchHeader do begin
    //           PurchaseReqTypeList.Editable := false;
    //           PurchaseReqTypeList.LookupMode := true;
    //           if PurchaseReqTypeList.RunModal = Action::LookupOK then begin
    //             PurchaseReqTypeList.GetRecord(PurchaseReqType);
    //             if PurchaseReqType.Blocked then
    //               Error(Text60018,PurchaseReqType.Code);
    //             "Purchase Req. Code" := PurchaseReqType.Code;
    //             "Order Type" := PurchaseReqType."Order Type";
    //             "Purchase Req. Type" := PurchaseReqType.Type;
    //             "Order Type" := "order type"::"Service PO";
    //             if ("Purchase Req. Type" = "purchase req. type"::Item) then
    //               "Order Type" := "order type"::"Invt PO";
    //           end else
    //             Error(Text60019);
    //         end;
    //     end;


    //     procedure CheckSource(PurchHeader: Record "Purchase Header")
    //     var
    //         Text60022: label 'Action not allowed.';
    //     begin
    //         with PurchHeader do begin
    //           if ("PRN No." <>'') or ("RFQ No." <> '') then
    //             Error(Text60022);
    //         end;
    //     end;


    //     procedure CheckForConfirmation(PurchHeader: Record "Purchase Header")
    //     var
    //         InvtPostSetup: Record "Inventory Posting Setup";
    //         GenPostingSetup: Record "General Posting Setup";
    //         VendPostingGr: Record "Vendor Posting Group";
    //         VATPostingSetup: Record "VAT Posting Setup";
    //         Item: Record Item;
    //         Job: Record Job;
    //         PurchLine: Record "Purchase Line";
    //         GLAcc: Record "G/L Account";
    //         Vend: Record Vendor;
    //         PurchReqType: Record "Purchase Req. Type";
    //         ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    //         Purchaser: Record "Salesperson/Purchaser";
    //         LastLineType: Option " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
    //         LastGenProdPstGrp: Code[10];
    //         LastCapexCode: Code[20];
    //         TableID: array [10] of Integer;
    //         No: array [10] of Code[20];
    //         Text115: label 'Line %1 does not have quantity. To Continue, press escape and fill the quantity field for the line.';
    //         Text117: label 'Nothing to process.';
    //         DimMgt: Codeunit DimensionManagement;
    //         Text121: label '%1 %2, %3 is not properly setup for advance payment processing. %4 is not specified for the posting. Contact your System Administrator for Assistance.';
    //         Text60028: label 'All the charge item lines must be fully assigned.';
    //     begin
    //         with PurchHeader do begin
    //           if Status = Status::Released then
    //             exit;
    //           TestField("Payment Terms Code");
    //           TestField("Expected Receipt Date");

    //           PurchSetup.Get;
    //           InvtSetup.Get;
    //           if not PurchLinesExist then
    //             Error(Text117);

    //           PurchLine.SetFilter(Type,'<>%1',0);
    //           PurchLine.SetFilter(Quantity,'=%1',0);

    //           if PurchLine.Find('-') then
    //             Error(Text115,PurchLine."Line No.");

    //           Vend.Get("Pay-to Vendor No.");
    //           Vend.TestField("Vendor Posting Group");
    //           VendPostingGr.Get(Vend."Vendor Posting Group");
    //           VendPostingGr.TestField("Payables Account");
    //           //Check Dimension function to be introduced here
    //           case "Document Type" of
    //             "document type"::Invoice:
    //               begin
    //                 TableID[1] := Database::Vendor;
    //                 No[1] := "Pay-to Vendor No.";
    //                 TableID[3] := Database::"Salesperson/Purchaser";
    //                 No[3] := "Purchaser Code";
    //                 TableID[4] := Database::Campaign;
    //                 No[4] := "Campaign No.";
    //                 TableID[5] := Database::"Responsibility Center";
    //                 No[5] := "Responsibility Center";

    //                 if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
    //                   Error(DimMgt.GetDimValuePostingErr);
    //               end;
    //             "document type"::Order:
    //               begin
    //                 Vend.Get("Buy-from Vendor No.");
    //                 TestField("Purchaser Code");
    //                 Purchaser.Get("Purchaser Code");
    //                 if PurchSetup."Send PO on Approval" then
    //                   begin
    //                     Vend.TestField("E-Mail");
    //                     Purchaser.TestField("E-Mail");
    //                   end;
    //               end;
    //           end;


    //           PurchLine.Reset;
    //           PurchLine.SetRange("Document Type","Document Type");
    //           PurchLine.SetRange("Document No.","No.");
    //           if PurchLine.FindFirst then
    //             repeat
    //               if PurchLine.Quantity <> 0 then begin
    //                 PurchLine.TestField("Gen. Bus. Posting Group");
    //                 PurchLine.TestField("Gen. Prod. Posting Group");
    //                 PurchLine.TestField("Direct Unit Cost");

    //                 //Check VAT in line with the setup
    //                 VATPostingSetup.Get(PurchLine."VAT Bus. Posting Group",PurchLine."VAT Prod. Posting Group");
    //                 PurchLine.TestField("VAT %",VATPostingSetup."VAT %");
    //               end;
    //               if PurchLine.Type = PurchLine.Type::"Fixed Asset" then
    //                 if PurchLine."FA Posting Type" = 0 then
    //                   PurchLine.FieldError("FA Posting Type");
    //                 if (PurchLine.Type <> 0) then begin
    //                   PurchLine.TestField("Buy-from Vendor No.","Buy-from Vendor No.");
    //                   PurchLine.TestField("Pay-to Vendor No.","Pay-to Vendor No.");
    //                   GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group");
    //                   if PurchLine."Prepayment %" <> 0 then begin
    //                     if GenPostingSetup."Purch. Prepayments Account" = '' then
    //                       Error(Text121,GenPostingSetup.TableCaption,PurchLine."Gen. Bus. Posting Group"
    //                        ,PurchLine."Gen. Prod. Posting Group",GenPostingSetup.FieldCaption("Purch. Prepayments Account"));
    //                     GLAcc.Get(GenPostingSetup."Purch. Prepayments Account");
    //                     GLAcc.CheckGLAcc;
    //                   end;
    //                 end;

    //               if PurchLine."No." <> '' then begin
    //                 if PurchLine."Job No." <> '' then begin
    //                   PurchLine.TestField("Job Task No.");
    //                   PurchLine.TestField(Type,PurchLine.Type::"G/L Account");
    //                   GLAcc.Get(PurchLine."No.");
    //                   GLAcc.CheckGLAcc;
    //                   GLAcc.TestField("Job No. Mandatory");
    //                   Job.Get(PurchLine."Job No.");
    //                   //Job.TESTFIELD("Job Status",Job."Job Status"::Order);
    //                   Job.TestField(Blocked,Job.Blocked::" ");
    //                   /*IF Job."Capex Code" <> '' THEN BEGIN
    //                     Capex.GET(Job."Capex Code");
    //                     IF Capex.CheckCapexCost(FALSE,0) THEN
    //                       ERROR(Text124,Job."No.");
    //                   END;*/
    //                 end;
    //                 case PurchLine.Type of
    //                   PurchLine.Type::"G/L Account":begin
    //                     GLAcc.Get(PurchLine."No.");
    //                     GLAcc.CheckGLAcc;
    //                     if GLAcc."Job No. Mandatory" then begin
    //                       PurchLine.TestField("Job No.");
    //                       PurchLine.TestField("Job Task No.");
    //                     end;
    //                     //Check if Consignment Account
    //                     if GLAcc."GIT Clearing Account" then begin
    //                       PurchLine.TestField("Consignment Charge Code");
    //                       PurchLine.TestField("Consignment Code");
    //                       PurchLine.TestField("Order No.");
    //                     end;
    //                     CheckDimValue(PurchLine,PurchLine."No.");
    //                   end;
    //                   PurchLine.Type::Item:begin
    //                     if InvtSetup."Location Mandatory" then
    //                       PurchLine.TestField("Location Code");
    //                     Item.Get(PurchLine."No.");
    //                     Item.TestField("Inventory Posting Group");
    //                     PurchLine.TestField("Unit of Measure Code");
    //                     PurchLine.TestField("Unit of Measure");
    //                     InvtPostSetup.Get(PurchLine."Location Code",Item."Inventory Posting Group");
    //                     InvtPostSetup.TestField("Inventory Account");
    //                     CheckDimValue(PurchLine,InvtPostSetup."Inventory Account");
    //                     if GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group",PurchLine."Gen. Prod. Posting Group") then begin
    //                       CheckDimValue(PurchLine,GenPostingSetup."Purch. Account");
    //                       CheckDimValue(PurchLine,GenPostingSetup."Invt. Accrual Acc. (Interim)");
    //                     end;
    //                   end;
    //                   PurchLine.Type::"Charge (Item)":begin
    //                     ItemChargeAssgntPurch.SetRange("Document Type",PurchLine."Document Type");
    //                     ItemChargeAssgntPurch.SetRange("Document No.",PurchLine."Document No.");
    //                     ItemChargeAssgntPurch.SetRange("Document Line No.",PurchLine."Line No.");
    //                     if not ItemChargeAssgntPurch.FindFirst then
    //                       Error(Text60028);
    //                   end;
    //                 end;
    //               end;
    //             until PurchLine.Next(1) = 0;
    //         end;

    //     end;


    //     procedure ConsignmentLineExist(PurchHeader: Record "Purchase Header"): Boolean
    //     var
    //         ConsignmentLine: Record "Consignment Line";
    //     begin
    //         with PurchHeader do begin
    //           case "Document Type" of
    //              "document type"::Order:ConsignmentLine.SetRange("PO No.","No.");
    //              "document type"::Invoice:ConsignmentLine.SetRange("PO No.","Order No.");
    //              else
    //                exit(false);
    //           end;
    //           if ConsignmentLine.FindSet then
    //             exit(true)
    //           else
    //             exit(false);
    //         end;
    //     end;


    //     procedure CompletelyInvoiced(PurchHeader: Record "Purchase Header") Ok: Boolean
    //     var
    //         PurchLine: Record "Purchase Line";
    //     begin
    //         with PurchHeader do begin
    //           Ok := false;
    //           Clear(PurchLine);
    //           PurchLine.SetRange("Document Type","Document Type");
    //           PurchLine.SetRange("Document No.","No.");
    //           PurchLine.SetFilter(Quantity,'<>0');
    //           if not PurchLine.FindFirst then
    //             exit(false);

    //           TestField("Document Type","document type"::Order);

    //           repeat
    //             Ok := (PurchLine.Quantity = PurchLine."Quantity Invoiced");
    //             if not Ok then
    //               exit(false);
    //           until PurchLine.Next = 0;

    //           exit(Ok);
    //         end;
    //     end;


    //     procedure CheckLandCostCalculation(PurchHeader: Record "Purchase Header")
    //     var
    //         Text60023: label 'Recognize GIT function Cost must be run before this function. Contact your System Logistic Co-ordinator for Assistance.';
    //         Text60024: label 'You must run Calc. & Spread landing cost for the selected consignment before this action.';
    //         ConsignmentLine: Record "Consignment Line";
    //     begin
    //         with PurchHeader do begin
    //           if ("Document Type" <> "document type"::Invoice) or ("Order No." = '') or ((not ConsignmentLineExist(PurchHeader))
    //             or "Landing Cost Calculated") then
    //               exit;

    //           repeat
    //             if not ConsignmentLine."GIT Cost Recognised" then
    //               Error(Text60023);
    //           until ConsignmentLine.Next = 0;

    //           if not "Landing Cost Calculated" then
    //             Error(Text60024);
    //         end;
    //     end;


    //     procedure GetAmount(PurchHeader: Record "Purchase Header"): Decimal
    //     var
    //         VATAmountLine: Record "VAT Amount Line" temporary;
    //         PurchLine: Record "Purchase Line" temporary;
    //         PurchPost: Codeunit "Purch.-Post";
    //         VATAmount: Decimal;
    //         VATBaseAmount: Decimal;
    //         VATDiscountAmount: Decimal;
    //     begin
    //         with PurchHeader do begin
    //           VATAmountLine.DeleteAll;
    //           PurchLine.DeleteAll;
    //           PurchPost.GetPurchLines(PurchHeader,PurchLine,0);
    //           PurchLine.CalcVATAmountLines(0,PurchHeader,PurchLine,VATAmountLine);
    //           PurchLine.UpdateVATOnLines(0,PurchHeader,PurchLine,VATAmountLine);
    //           VATAmount := VATAmountLine.GetTotalVATAmount;
    //           VATBaseAmount := VATAmountLine.GetTotalVATBase;
    //           VATDiscountAmount :=
    //             VATAmountLine.GetTotalVATDiscount("Currency Code","Prices Including VAT");
    //           exit(VATAmountLine.GetTotalAmountInclVAT);
    //         end;
    //     end;


    //     procedure GetAmountText(Amt: Decimal;CurrencyCode: Code[10]) AmountInText: Text[250]
    //     var
    //         ConvertAmtToText: Codeunit "Format No. to Text";
    //         AmountInFigure: Decimal;
    //         AmountInWord: array [2] of Text[80];
    //     begin
    //         if Amt <> 0 then begin
    //           AmountInFigure := Amt;
    //           ConvertAmtToText.InitTextVariable;
    //           ConvertAmtToText.FormatNoText(AmountInWord,Abs(AmountInFigure),CurrencyCode,'');
    //         end;

    //         AmountInText := AmountInWord[1] + ' ' + AmountInWord[2];
    //     end;


    //     procedure GetReceiptNo(PurchHeader: Record "Purchase Header"): Code[20]
    //     var
    //         WhseSetup: Record "Warehouse Setup";
    //     begin
    //         with PurchHeader do begin
    //           if ("Document Type" <> "document type"::Order) then
    //             exit("Receiving No. Series");

    //           if "Order Type" = "order type"::"Invt PO" then begin
    //             WhseSetup.Get;
    //             WhseSetup.TestField("Posted Whse. Receipt Nos.");
    //             exit(WhseSetup."Posted Whse. Receipt Nos.");
    //           end else begin
    //             PurchSetup.Get;
    //             PurchSetup.TestField("Posted Receipt Nos.");
    //             exit(PurchSetup."Posted Receipt Nos.");
    //           end;
    //         end;
    //     end;


    procedure CheckBudgetLimit(PurchHeader: Record "Purchase Header")
    var
        RecRef: RecordRef;
        AnalysisView: Record "Analysis View";
        RePurchLine: Record "Purchase Line";
        PurchLine: Record "Purchase Line";
        GLAccount: Record "G/L Account";
        TotalExpAmount: Decimal;
        TotalBudgetAmount: Decimal;
        TotalCommittedAmount: Decimal;
        Variance: Decimal;
        PurchLCY: Decimal;
        AboveBudget: Boolean;
        WorkflowMgt: Codeunit "Gems Workflow Event";
        BudgetControlMgt: Codeunit "Budget Control Management";
        Text03: label 'Your Expense for this Period have been Exceeded by =N= %1, Do want to Continue?';
        Text04: label 'Your Expense for this Period have been Exceeded by =N= %1,Please Contact your Budget Control Unit';
        Text035: label 'No Budget Entry created for Account %1, please Contact your Budget Control Unit';
    begin
        with PurchHeader do begin
            GLSetup.Get;
            PayMgtSetup.Get;
            AboveBudget := false;
            if PayMgtSetup."Budget Expense Control Enabled" then begin
                AnalysisView.Get(PayMgtSetup."Budget Analysis View Code");
                RePurchLine.SetRange(RePurchLine."Document No.", "No.");
                RePurchLine.SetRange(RePurchLine.Type, RePurchLine.Type::"G/L Account");
                RePurchLine.SetFilter("No.", AnalysisView."Account Filter");
                if RePurchLine.FindFirst then begin
                    repeat
                        if GLAccount.Get(RePurchLine."No.") then
                            if not (GLAccount."Excl. from Budget Ctrl") then begin
                                TotalExpAmount := 0;
                                TotalBudgetAmount := 0;
                                TotalCommittedAmount := 0;
                                BudgetControlMgt.GetAmounts(RePurchLine."Dimension Set ID", PurchHeader."Document Date", RePurchLine."No.",
                                  TotalBudgetAmount, TotalExpAmount, TotalCommittedAmount);
                                if TotalBudgetAmount = 0 then
                                    AboveBudget := true;
                                if (TotalBudgetAmount <> 0) then begin
                                    if ((TotalExpAmount + TotalCommittedAmount) > TotalBudgetAmount) then
                                        AboveBudget := true
                                    else begin
                                        PurchLCY := RePurchLine."Outstanding Amount (LCY)";
                                        if (TotalExpAmount + PurchLCY + TotalCommittedAmount) > TotalBudgetAmount then
                                            AboveBudget := true;
                                    end;
                                end;
                            end;
                    until RePurchLine.Next = 0;
                end;
            end;
            RecRef.GetTable(PurchHeader);
            if AboveBudget then
                WorkflowMgt.OnPurchaseDocumentBudgetExceeded(RecRef)
            else
                WorkflowMgt.OnPurchaseDocumentBudgetNotExceeded(RecRef);
        end;
    end;


    //     procedure CreateCommitment(PurchHeader: Record "Purchase Header")
    //     var
    //         PurchLine: Record "Purchase Line";
    //         BudgetControlMgt: Codeunit "Budget Control Management";
    //         AnalysisView: Record "Analysis View";
    //     begin
    //         with PurchHeader do begin
    //           GLSetup.Get;
    //           PayMgtSetup.Get;
    //           if PayMgtSetup."Budget Expense Control Enabled" then begin
    //             AnalysisView.Get(PayMgtSetup."Budget Analysis View Code");
    //             with PurchLine do begin
    //               SetRange("Document No.",PurchHeader."No.");
    //               SetFilter("Account No.",AnalysisView."Account Filter");
    //               if Find('-') then
    //                 repeat
    //                   if BudgetControlMgt.ControlBudget("Account No.") then
    //                     case "Document Type" of
    //                       "document type"::Invoice:
    //                         if (PurchLine."Receipt No." = '') then
    //                           BudgetControlMgt.UpdateCommitment("Document No.","Line No.",PurchHeader."Document Date",
    //                             "Outstanding Amount (LCY)","No.","Dimension Set ID");
    //                       "document type"::Order:
    //                         begin
    //                           BudgetControlMgt.UpdateCommitment("Document No.","Line No.",PurchHeader."Document Date",
    //                             "Outstanding Amount (LCY)","No.","Dimension Set ID");
    //                         end;
    //                     end;
    //                 until Next = 0;
    //             end;
    //           end;
    //         end;
    //     end;


    //     procedure DeleteCommitment(PurchHeader: Record "Purchase Header")
    //     var
    //         PurchLine: Record "Purchase Line";
    //         BudgetControlMgt: Codeunit "Budget Control Management";
    //         AnalysisView: Record "Analysis View";
    //     begin
    //         with PurchHeader do begin
    //           GLSetup.Get;
    //           PayMgtSetup.Get;
    //           if PayMgtSetup."Budget Expense Control Enabled" then begin
    //             AnalysisView.Get(PayMgtSetup."Budget Analysis View Code");
    //             with PurchLine do begin
    //               SetRange("Document No.",PurchHeader."No.");
    //               SetFilter("Account No.",AnalysisView."Account Filter");
    //               if Find('-') then
    //                 repeat
    //                   case "Document Type" of
    //                     "document type"::Order:
    //                       begin
    //                         if ("PRN No." = '') and ("Requisition Line No." = 0) then
    //                           BudgetControlMgt.DeleteCommitment("Document No.","Line No.","Account No.");
    //                       end;
    //                     "document type"::Invoice:
    //                       begin
    //                         if (PurchLine."Receipt No." = '') then
    //                           BudgetControlMgt.DeleteCommitment("Document No.","Line No.","Account No.");
    //                       end;
    //                   end;
    //                 until Next = 0;
    //             end;
    //           end;
    //         end;
    //     end;


    //     procedure UpdatePOLineOnReceipt(PurchHeader: Record "Purchase Header")
    //     var
    //         Text60032: label 'PO fully serviced. Action aborted.';
    //         PurchLine: Record "Purchase Line";
    //     begin
    //         with PurchHeader do begin
    //           PurchLine.Reset;
    //           PurchLine.SetRange("Document Type","Document Type");
    //           PurchLine.SetRange("Document No.","No.");
    //           if not(PurchLine.FindFirst) then
    //             Error(Text60032);

    //           repeat
    //             if PurchLine."Quantity to Receive" = 0 then begin
    //               PurchLine.Validate("Qty. to Receive",0);
    //               PurchLine.Modify;
    //             end;
    //           until PurchLine.Next = 0;
    //         end;
    //     end;


    //     procedure GetPrepaymenttoDeductLCY(PurchHeader: Record "Purchase Header") TotalAmtLCY: Decimal
    //     var
    //         OrderPurchLine: Record "Purchase Line";
    //     begin
    //         with PurchHeader do begin
    //           TotalAmtLCY := 0;
    //           OrderPurchLine.Reset;
    //           OrderPurchLine.SetRange("Document Type","Document Type");
    //           OrderPurchLine.SetRange("Document No.","No.");
    //           if not OrderPurchLine.FindFirst then
    //             exit(0);

    //           repeat
    //             TotalAmtLCY := TotalAmtLCY + OrderPurchLine."Prepmt. Amount Inv. (LCY)";
    //           until OrderPurchLine.Next = 0;

    //           exit(TotalAmtLCY);
    //         end;
    //     end;


    //     procedure CheckConsignment(PurchHeader: Record "Purchase Header")
    //     var
    //         Text60033: label 'You cannot post prepayment when the consignment line already created or cost recognized.';
    //     begin
    //         if not ConsignmentLineExist(PurchHeader) then
    //           exit;

    //         Error(Text60033);
    //     end;


    //     procedure ResetCalculateLandingCost(var PurchHeader: Record "Purchase Header")
    //     var
    //         PurchLine: Record "Purchase Line";
    //         Text60034: label 'Your action will delete the existing lines. Are you sure you want to continue?';
    //     begin
    //         with PurchHeader do begin
    //           if PurchLinesExist then
    //             if not Confirm(Text60034,false) then
    //               exit;
    //           repeat
    //             PurchLine.Delete(true);
    //           until PurchLine.Next = 0;

    //           "Landing Cost Calculated" := false;
    //           Modify;
    //         end;
    //     end;


    //     procedure CheckDocumentDeletion(): Boolean
    //     begin
    //         //Called on DeleteRecord of respective Pages
    //         //Inserted by Gems
    //         PurchSetup.Get;
    //         exit(PurchSetup."Allow Purchase Header Deletion");
    //     end;

    //     local procedure CheckDimValue(PurchLine: Record "Purchase Line";GLAcc: Code[20])
    //     var
    //         TableID: array [10] of Integer;
    //         No: array [10] of Code[20];
    //         DimMgt: Codeunit DimensionManagement;
    //     begin
    //         with PurchLine do begin
    //           TableID[1] := Database::"G/L Account";
    //           No[1] := GLAcc;
    //           TableID[2] := Database::Job;
    //           No[2] := "Job No.";
    //           TableID[3] := Database::"Work Center";
    //           No[3] := "Work Center No.";
    //           if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
    //             Error(DimMgt.GetDimValuePostingErr);
    //         end;
    //     end;


    //     procedure OnValidatePurchLineType(PurchLine: Record "Purchase Line";lCurrFieldNo: Integer)
    //     var
    //         PurchHeader: Record "Purchase Header";
    //         PurchReqType: Record "Purchase Req. Type";
    //     begin
    //         with PurchLine do begin
    //           if "Document No." = '' then
    //             exit;
    //           PurchHeader.Get("Document Type","Document No.");
    //           if lCurrFieldNo <> 0 then begin
    //             if "Document Type" in [0,1,4] then begin
    //               PurchReqType.Get(PurchHeader."Purchase Req. Code");
    //               case Type of
    //                 0,1,2:begin
    //                   PurchReqType.ValidateAccountNo(Type,"No.");
    //                   PurchReqType.ValidateItemCategory(Type,"No.");
    //                 end;
    //                 4,5: PurchReqType.ValidateAccountNo(Type -1,"No.");
    //               end;
    //             end
    //           end;
    //         end;                                                                //
    //     end;

    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitItemLedgEntry', '', false, false)]
    //     local procedure OnInitItemLedgEntry(var ItemJnlLine: Record "Item Journal Line";var ItemLedgEntry: Record "Item Ledger Entry")
    //     begin
    //         ItemLedgEntry."PO No." := ItemJnlLine."PO No.";
    //     end;
}

