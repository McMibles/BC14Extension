Codeunit 52092262 "Warehouse Hook"
{

    //     trigger OnRun()
    //     begin
    //     end;

    //     var
    //         PurchLineTemp: Record "Purchase Line" temporary;
    //         WhseSetup: Record "Warehouse Setup";
    //         Text100: label 'Do you want to post & print  the receipt?';
    //         lDeliveryToleranceMgt: Codeunit "Delivery Tolerance Mgt";


    //     procedure GetConfirmationBeforePosting(): Boolean
    //     begin
    //         if GuiAllowed then
    //           if not Confirm(Text100,false) then
    //             exit(false)
    //           else
    //             exit(true);
    //     end;


    //     procedure CalcItemChargeValuetoReceive(PurchLine: Record "Purchase Line")
    //     var
    //         PurchLine2: Record "Purchase Line";
    //         ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
    //         ItemChargeQty: Decimal;
    //     begin
    //         ItemChargeQty := 0;
    //         Clear(PurchLine2);
    //         PurchLine2.SetRange("Document Type",PurchLine."document type"::Order);
    //         PurchLine2.SetRange("Document No.",PurchLine."Document No.");
    //         PurchLine2.SetFilter(Type,'=%1',PurchLine2.Type::"Charge (Item)");
    //         if PurchLine2.FindFirst then
    //           repeat
    //             ItemChargeQty := 0;
    //             Clear(ItemChargeAssgntPurch);
    //             ItemChargeAssgntPurch.SetCurrentkey("Document Type","Document No.","Document Line No.","Line No.");
    //             ItemChargeAssgntPurch.SetFilter("Document Type",'=%1',PurchLine2."Document Type");
    //             ItemChargeAssgntPurch.SetFilter("Document No.",PurchLine2."Document No.");
    //             ItemChargeAssgntPurch.SetRange("Applies-to Doc. Type",PurchLine."Document Type");
    //             ItemChargeAssgntPurch.SetRange("Applies-to Doc. No.",PurchLine."Document No.");
    //             ItemChargeAssgntPurch.SetRange("Applies-to Doc. Line No.",PurchLine."Line No.");
    //             ItemChargeAssgntPurch.SetRange("Document Line No.",PurchLine2."Line No.");
    //             if ItemChargeAssgntPurch.FindFirst then begin
    //               repeat
    //                 //Insert it as temp
    //                 ItemChargeQty := ItemChargeAssgntPurch."Original Qty. to Assign" / PurchLine.Quantity *
    //                   PurchLine."Qty. to Receive";
    //                  if not PurchLineTemp.Get(PurchLine2."Document Type",PurchLine2."Document No.",PurchLine2."Line No.") then
    //                    begin
    //                      PurchLineTemp.Init;
    //                      PurchLineTemp."Document Type" := PurchLine2."Document Type";
    //                      PurchLineTemp."Document No." := PurchLine2."Document No.";
    //                      PurchLineTemp."Line No." := PurchLine2."Line No.";
    //                      PurchLineTemp."Qty. to Receive" := ItemChargeQty;
    //                      PurchLineTemp.Insert;
    //                    end else begin
    //                      PurchLineTemp."Qty. to Receive" := PurchLineTemp."Qty. to Receive" + ItemChargeQty;
    //                      PurchLineTemp.Modify;
    //                    end;
    //               until ItemChargeAssgntPurch.Next = 0;
    //             end;
    //           until PurchLine2.Next = 0;
    //     end;


    //     procedure UpdatePurchLineWithItemChargeReceived(WhseRcptLine2: Record "Warehouse Receipt Line")
    //     var
    //         PurchLine2: Record "Purchase Line";
    //     begin
    //         Clear(PurchLine2);
    //         PurchLine2.SetRange("Document Type",WhseRcptLine2."Source Subtype");
    //         PurchLine2.SetRange("Document No.",WhseRcptLine2."Source No.");
    //         PurchLine2.SetFilter(Type,'=%1',PurchLine2.Type::"Charge (Item)");
    //         if PurchLine2.FindFirst then
    //           repeat
    //             if PurchLineTemp.Get(PurchLine2."Document Type",PurchLine2."Document No.",PurchLine2."Line No.") then begin
    //               if PurchLineTemp."Qty. to Receive" <= PurchLine2."Outstanding Quantity" then
    //                 PurchLine2.Validate("Qty. to Receive",PurchLineTemp."Qty. to Receive")
    //               else
    //                 PurchLine2.Validate("Qty. to Receive",PurchLine2."Outstanding Quantity");
    //               PurchLine2.Modify;
    //             end else begin
    //               PurchLine2.Validate("Qty. to Receive",0);
    //               PurchLine2.Modify;
    //             end;
    //           until PurchLine2.Next = 0;
    //     end;


    //     procedure UpdatePurchHeaderOnPostWhseReceipt(WhseRcptLine: Record "Warehouse Receipt Line";var PurchHeader: Record "Purchase Header")
    //     var
    //         WhseRcptHeader: Record "Warehouse Receipt Header";
    //     begin
    //         WhseSetup.Get;
    //         with WhseRcptLine do begin
    //           WhseRcptHeader.Get("No.");
    //           if "Source Document" = "source document"::"Purchase Order" then begin
    //             case WhseSetup."Whse. Receipt Posting Limit" of
    //               WhseSetup."whse. receipt posting limit"::"Receipt Only":begin
    //                 PurchHeader.Receive := true;
    //                 PurchHeader.Invoice := false;
    //               end;
    //               WhseSetup."whse. receipt posting limit"::"Receipt & Invoice":begin
    //                 WhseRcptHeader.TestField("Vendor Invoice No.");
    //                 PurchHeader."Vendor Invoice No." := WhseRcptHeader."Vendor Invoice No.";
    //                 PurchHeader.Receive := true;
    //                 PurchHeader.Invoice := true;
    //               end;
    //             end;
    //           end else begin
    //             PurchHeader.Ship := true;
    //             PurchHeader.Invoice := false;
    //           end;
    //         end;
    //     end;


    //     procedure ResetWhseRcptHeaderAfterPosting(var WhseRcptHeader: Record "Warehouse Receipt Header")
    //     begin
    //         WhseRcptHeader."Posting Date" := 0D;
    //         WhseRcptHeader."Vendor Shipment No." := '';
    //         WhseRcptHeader."Received By" := '';
    //         WhseRcptHeader."Inspected By" := '';
    //     end;


    //     procedure FilterPurchLineOnOnPostWhseReceipt(var PurchLine: Record "Purchase Line")
    //     begin
    //         PurchLine.SetRange(Type,1,3);
    //     end;


    //     procedure CheckDeliveryTolerance(lCurrFieldNo: Integer;var WhseRcptLine: Record "Warehouse Receipt Line")
    //     var
    //         lLicPermission: Record "License Permission";
    //         lDeliveryToleranceEntry: Record "Delivery Tolerance Entry";
    //     begin
    //         lLicPermission.Get(lLicPermission."object type"::Codeunit, Codeunit::"Delivery Tolerance Mgt");
    //         if lLicPermission."Execute Permission" = lLicPermission."execute permission"::Yes then begin
    //           lDeliveryToleranceMgt.CheckWhseRcpLineDelivTolerance(WhseRcptLine,lCurrFieldNo);
    //         end;
    //     end;


    //     procedure ClearPurChLineTemp()
    //     begin
    //         PurchLineTemp.DeleteAll;
    //     end;


    //     procedure CheckBlankDocumentExist(WhseRcptHeader: Record "Warehouse Receipt Header")
    //     var
    //         Text105: label 'You cannot create a new receipt number. Receipt number %1 not yet used. Press escape to select %1.';
    //     begin
    //         WhseRcptHeader.SetRange("User ID",UserId);
    //         if WhseRcptHeader.FindFirst then
    //           repeat
    //             if not DocumentLineExist(WhseRcptHeader) then
    //               Error(Text105);
    //           until WhseRcptHeader.Next = 0;
    //     end;


    //     procedure DocumentLineExist(WhseRcptHeader: Record "Warehouse Receipt Header"): Boolean
    //     var
    //         WhseRcptLine: Record "Warehouse Receipt Line";
    //     begin
    //         with WhseRcptHeader do begin
    //           WhseRcptLine.SetRange("No.","No.");
    //           exit(WhseRcptLine.FindFirst);
    //         end;
    //     end;

    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterCheckWhseRcptLines', '', false, false)]
    //     [TryFunction]

    //     procedure OnAfterCheckWhseRcptLines(var WhseRcptHeader: Record "Warehouse Receipt Header";var WhseRcptLine: Record "Warehouse Receipt Line")
    //     begin
    //         WhseRcptHeader.TestField("Vendor Shipment No.");
    //         WhseRcptHeader.TestField("Posting Date");
    //         WhseRcptHeader.TestField("Received By");
    //         WhseRcptHeader.TestField("Inspected By");
    //     end;

    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnInitSourceDocumentHeaderOnBeforePurchHeaderModify', '', false, false)]

    //     procedure OnInitSourceDocumentHeaderOnBeforePurchHeaderModify(var PurchaseHeader: Record "Purchase Header";var WarehouseReceiptHeader: Record "Warehouse Receipt Header";var ModifyHeader: Boolean)
    //     begin
    //         if PurchaseHeader."Receiving No." <> WarehouseReceiptHeader."Receiving No." then begin
    //           PurchaseHeader."Receiving No." := WarehouseReceiptHeader."Receiving No.";
    //           ModifyHeader := true;
    //         end;
    //     end;

    //     [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify', '', false, false)]
    //     local procedure OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify(var SalesHeader: Record "Sales Header";var WarehouseReceiptHeader: Record "Warehouse Receipt Header";var ModifyHeader: Boolean)
    //     begin
    //         if SalesHeader."Return Receipt No." <> WarehouseReceiptHeader."Receiving No." then begin
    //           SalesHeader."Return Receipt No." := WarehouseReceiptHeader."Receiving No.";
    //           ModifyHeader := true;
    //         end;
    //     end;
}

