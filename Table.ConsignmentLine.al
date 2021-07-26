Table 52092338 "Consignment Line"
{
    //     //DrillDownPageID = UnknownPage60629;
    //     //LookupPageID = UnknownPage60629;

    fields
    {
        field(1; "Consignment Code"; Code[10])
        {
            TableRelation = "Consignment Header";
        }
        field(2; "PO No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order),
                                                                   Status = filter(Released | "Pending Prepayment"));
            //This property is currently not supported
            //TestTableRelation = false;

            //             trigger OnValidate()
            //             begin
            //                 if ("PO No." <> '') then begin
            //                     GetConsignmentHeader;
            //                     PurchHeader.Get(PurchHeader."document type"::Order, "PO No.");
            //                     PurchHeader.TestField(Status, PurchHeader.Status::Released);
            //                     "Vendor No." := PurchHeader."Buy-from Vendor No.";
            //                     "Vendor Name" := PurchHeader."Buy-from Vendor Name";
            //                     "Currency Code" := PurchHeader."Currency Code";
            //                     "GIT Account" := Consignment."GIT Account";
            //                 end else begin
            //                     "Vendor No." := '';
            //                     "Vendor Name" := '';
            //                     "Currency Code" := '';
            //                 end;
            //                 DeleteConsignmentPOLines(Rec);
            //             end;
        }
        field(3; "Total Cost of Goods"; Decimal)
        {
            Editable = false;
        }
        field(4; "GIT Account"; Code[20])
        {
            TableRelation = "G/L Account";

            //             trigger OnValidate()
            //             begin
            //                 GetConsignmentHeader;
            //                 Consignment.TestField(Open, true);
            //                 if "GIT Account" <> '' then begin
            //                     GLAcc.Get("GIT Account");
            //                     if not (GLAcc."GIT Clearing Account") then
            //                         Error(Text001, "GIT Account");
            //                 end;

            //                 if (xRec."GIT Account" <> "GIT Account") and (xRec."GIT Account" <> '') then begin
            //                     CalcFields("Balance Amount");
            //                     if "Balance Amount" <> 0 then
            //                         Error(Text002);
            //                 end;
            //             end;
        }
        //         field(35; "Vendor No."; Code[20])
        //         {
        //             Editable = false;
        //             TableRelation = Vendor;
        //         }
        //         field(36; "Currency Code"; Code[10])
        //         {
        //             Editable = false;
        //         }
        //         field(37; "Vendor Name"; Text[80])
        //         {
        //             Editable = false;
        //         }
        //         field(38; "Balance Amount"; Decimal)
        //         {
        //             // CalcFormula = sum("Consignment Ledger Entry".Amount where ("Consignment Code"=field("Consignment Code"),
        //             "PO No." =field("PO No.")));
        //             Editable = false;
        //             FieldClass = FlowField;
        //         }
        //         field(39;"Consignment Amount";Decimal)
        //         {
        //            // CalcFormula = sum("Consignment/Purch. Order Line".Amount where ("Consignment Code"=field("Consignment Code"),
        //                                                                             "PO No."=field("PO No.")));
        //             Editable = false;
        //             FieldClass = FlowField;
        //         }
        //         field(40;"Consignment Amount (LCY)";Decimal)
        //         {
        //             CalcFormula = sum("Consignment/Purch. Order Line"."Amount (LCY)" where ("Consignment Code"=field("Consignment Code"),
        //                                                                                     "PO No."=field("PO No.")));
        //             Editable = false;
        //             FieldClass = FlowField;
        //         }
        //         field(50;"Mode of Finance";Option)
        //         {
        //             OptionCaption = ' ,CASH,CHEQUE,IFF,BANK TRANSFER,LC';
        //             OptionMembers = " ",CASH,CHEQUE,IFF,"BANK TRANSFER",LC;
        //         }
        //         field(51;Invoiced;Boolean)
        //         {
        //         }
        //         field(52;"GIT Cost Recognised";Boolean)
        //         {
        //         }
        //         field(53;"VAT Amount";Decimal)
        //         {
        //             CalcFormula = sum("Consignment/Purch. Order Line"."VAT Amount" where ("Consignment Code"=field("Consignment Code"),
        //                                                                                   "PO No."=field("PO No.")));
        //             Editable = false;
        //             FieldClass = FlowField;
        //         }
        //     }

        //     keys
        //     {
        //         key(Key1;"Consignment Code","PO No.")
        //         {
        //             Clustered = true;
        //         }
        //     }

        //     fieldgroups
        //     {
        //     }

        //     trigger OnDelete()
        //     begin
        //         Consignment.Get("Consignment Code");
        //         Consignment.TestField(Open,true);
        //         CalcFields("Balance Amount");
        //         if "Balance Amount" <> 0 then
        //           Error(Text002);
        //         DeleteConsignmentPOLines(Rec);
        //     end;

        //     trigger OnInsert()
        //     begin
        //         GetConsignmentHeader;
        //         Consignment.TestField(Open,true);
        //         "GIT Account" := Consignment."GIT Account";
        //         //Copy Purchase order lines to consignment PO Lines
        //         CreateConsignmentLines(Rec);
        //     end;

        //     trigger OnRename()
        //     begin
        //         Consignment.Get("Consignment Code");
        //         Consignment.TestField(Open,true);
        //         CalcFields("Balance Amount");
        //         if "Balance Amount" <> 0 then
        //           Error(Text002);
        //         DeleteConsignmentPOLines(Rec);
        //         //Copy Purchase order lines to consignment PO Lines
        //         CreateConsignmentLines(Rec);
        //     end;

        //     var
        //         PurchSetup: Record "Purchases & Payables Setup";
        //         Consignment: Record "Consignment Header";
        //         ConsignmentPoLine: Record "Consignment/Purch. Order Line";
        //         PurchHeader: Record "Purchase Header";
        //         PurchLine: Record "Purchase Line";
        //         Text001: label 'The Account  %1 selected cannot be used as a GIT Account';
        //         Text002: label 'There are ledger entries already created; GIT Account cannnot be changed';
        //         GLAcc: Record "G/L Account";
        //         Text003: label 'Quantity cannot be less than zero.';
        //         Text004: label 'Nothing to process!';
        //         //UserControl: Codeunit "User Permissions";
        //         Text005: label 'Prepayment invoice must be posted before this action.';
        //         Text100: label 'Charge item must be assigned on order %1.';
        //         IgnoreOutstandingQtyCheck: Boolean;
        //         Text101: label 'Recreating the line will delete all exisiting lines. Are you sure you want to continue?';


        //     procedure CreateConsignmentLines(var ConsignmentLine: Record "Consignment Line")
        //     var
        //         ConsignmentPOLine: Record "Consignment/Purch. Order Line";
        //         EntryCreated: Boolean;
        //     begin
        //         PurchSetup.Get;
        //         TestField("GIT Cost Recognised",false);
        //         Clear(PurchLine);
        //         EntryCreated := false;
        //         Clear(ConsignmentPOLine);
        //         PurchLine.SetRange("Document Type",PurchLine."document type"::Order);
        //         PurchLine.SetRange("Document No.","PO No.");
        //         /*IF NOT IgnoreOutstandingQtyCheck THEN
        //           PurchLine.SETFILTER("Outstanding Quantity",'<>0')
        //         ELSE
        //           PurchLine.SETRANGE("Outstanding Quantity");*/
        //         PurchLine.SetRange(Type,1,3);
        //         if PurchLine.Find('-') then
        //           repeat
        //             PurchLine.CalcFields("Qty. on Consignment");
        //             if PurchLine."Qty. on Consignment" <> PurchLine.Quantity then begin
        //               ConsignmentPOLine.Init;
        //               ConsignmentPOLine."Consignment Code" := "Consignment Code";
        //               ConsignmentPOLine."PO No." := PurchLine."Document No.";
        //               ConsignmentPOLine."PO Line No." := PurchLine."Line No.";
        //               ConsignmentPOLine."Ignore Quantity Check" := IgnoreOutstandingQtyCheck;
        //               ConsignmentPOLine.Type := PurchLine.Type ;
        //               ConsignmentPOLine."Currency Code" := PurchLine."Currency Code";
        //               ConsignmentPOLine."No." := PurchLine."No." ;
        //               ConsignmentPOLine.Description := PurchLine.Description ;
        //               ConsignmentPOLine."Unit of Measure Code"  := PurchLine."Unit of Measure Code" ;
        //               ConsignmentPOLine."Direct Unit Cost"  := PurchLine."Direct Unit Cost";
        //               ConsignmentPOLine."Unit Cost (LCY)"  :=  PurchLine."Unit Cost (LCY)";
        //               if not IgnoreOutstandingQtyCheck then
        //                 ConsignmentPOLine.Validate(Quantity,PurchLine."Outstanding Quantity")
        //               else
        //                 ConsignmentPOLine.Validate(Quantity,PurchLine.Quantity);
        //               ConsignmentPOLine."VAT Amount" := ConsignmentPOLine.Amount * PurchLine."VAT %" / 100;
        //               if PurchLine."Prepayment %" <> 0 then begin
        //                 if PurchLine."Prepmt. Amt. Inv." = 0 then
        //                   Error(Text005);
        //                 ConsignmentPOLine."Prepmt. Amt. Inv." := PurchLine."Prepmt. Amt. Inv."  * ConsignmentPOLine.Quantity / PurchLine.Quantity;
        //                 ConsignmentPOLine."Prepmt. Amount Inv. Incl. VAT" := PurchLine."Prepmt. Amount Inv. (LCY)"
        //                   * ConsignmentPOLine.Quantity / PurchLine.Quantity;
        //                 ConsignmentPOLine."Prepmt. Amt. Incl. VAT" := PurchLine."Prepmt. Amt. Incl. VAT"
        //                     * ConsignmentPOLine.Quantity / PurchLine.Quantity;
        //               end;
        //               //Provoke error when negative
        //               if ConsignmentPOLine.Quantity < 0 then
        //                 Error(Text003);
        //               ConsignmentPOLine.Insert;
        //               EntryCreated := true;
        //             end;
        //           until  PurchLine.Next = 0;

        //         if not EntryCreated then
        //           Error(Text004);
        //         InsertAssignmentLine(ConsignmentPOLine,0);

        //     end;


        //     procedure CheckWhereUsed(ConsignmentCode: Code[20];PurchOrderNo: Code[20])
        //     var
        //         PaymentReqLine: Record "Payment Request Line";
        //         PaymentVoucherLine: Record "Payment Line";
        //         PurchLine: Record "Purchase Line";
        //         ConsigmentLedgerEntry: Record "Consignment Ledger Entry";
        //     begin
        //         CalcFields("Balance Amount");
        //         if "Balance Amount" <> 0 then
        //           Error(Text001);
        //     end;


        //     procedure GetConsignmentHeader()
        //     begin
        //         TestField("Consignment Code");
        //         Consignment.Get("Consignment Code");
        //     end;


        //     procedure DeleteConsignmentPOLines(var ConsignmentLine2: Record "Consignment Line")
        //     begin
        //         ConsignmentPoLine.SetRange("Consignment Code",ConsignmentLine2."Consignment Code");
        //         ConsignmentPoLine.SetRange("PO No.",ConsignmentLine2."PO No.");
        //         ConsignmentPoLine.DeleteAll(true);
        //     end;


        //     procedure InsertAssignmentLine(CurrentConsignmentPoLine: Record "Consignment/Purch. Order Line";CurrentQty: Decimal)
        //     var
        //         PurchLine2: Record "Purchase Line";
        //         ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        //         TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary;
        //         ConsignmentLine: Record "Consignment Line";
        //         ItemChargeQty: Decimal;
        //     begin
        //         TempItemChargeAssgntPurch.DeleteAll;
        //         ConsignmentPoLine.Reset;
        //         ConsignmentPoLine.SetRange("Consignment Code","Consignment Code");
        //         ConsignmentPoLine.SetRange("PO No.","PO No.");
        //         ConsignmentPoLine.SetRange(Type,ConsignmentPoLine.Type::Item);
        //         if not ConsignmentPoLine.FindFirst then
        //           exit;
        //         PurchLine2.SetRange("Document Type",PurchLine2."document type"::Order);
        //         PurchLine2.SetRange("Document No.","PO No.");
        //         PurchLine2.SetFilter(Type,'=%1',PurchLine2.Type::"Charge (Item)");
        //         if not PurchLine2.FindFirst then
        //           exit;

        //         if CurrFieldNo = 0 then
        //           Commit;

        //         repeat
        //           ItemChargeQty := 0;
        //           Clear(ItemChargeAssgntPurch);
        //           ItemChargeAssgntPurch.SetCurrentkey("Document Type","Document No.","Document Line No.","Line No.");
        //           ItemChargeAssgntPurch.SetFilter("Document Type",'=%1',PurchLine2."Document Type");
        //           ItemChargeAssgntPurch.SetFilter("Document No.",PurchLine2."Document No.");
        //           ItemChargeAssgntPurch.SetRange("Document Line No.",PurchLine2."Line No.");
        //           if ItemChargeAssgntPurch.FindFirst then begin
        //             repeat
        //               if ConsignmentPoLine.Get("Consignment Code","PO No.",ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
        //                 if CurrentQty <> 0 then
        //                   if CurrentConsignmentPoLine."PO Line No." = ConsignmentPoLine."PO Line No." then
        //                     ConsignmentPoLine.Quantity := CurrentQty;
        //                 GetPurchaseLine;
        //                 if not TempItemChargeAssgntPurch.Get(
        //                   ItemChargeAssgntPurch."Document Type",ItemChargeAssgntPurch."Document No.",PurchLine2."Line No.") then begin
        //                   TempItemChargeAssgntPurch.Init;
        //                   TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
        //                   TempItemChargeAssgntPurch."Document Line No." := PurchLine2."Line No.";
        //                   ItemChargeQty := ItemChargeAssgntPurch."Qty. to Assign" / PurchLine.Quantity * ConsignmentPoLine.Quantity;
        //                   TempItemChargeAssgntPurch."Qty. to Assign" := ItemChargeQty;
        //                   TempItemChargeAssgntPurch."Line No." := 0;
        //                   TempItemChargeAssgntPurch.Insert;
        //                 end else begin
        //                   ItemChargeQty := ItemChargeAssgntPurch."Qty. to Assign" / PurchLine.Quantity * ConsignmentPoLine.Quantity;
        //                   TempItemChargeAssgntPurch."Qty. to Assign" := TempItemChargeAssgntPurch."Qty. to Assign" + ItemChargeQty;
        //                   TempItemChargeAssgntPurch.Modify;
        //                 end
        //               end;
        //             until ItemChargeAssgntPurch.Next = 0;
        //           end else begin//Test the sitem charge assignment
        //             ItemChargeAssgntPurch.Reset;
        //             ItemChargeAssgntPurch.SetCurrentkey("Document Type","Document No.","Document Line No.","Line No.");
        //             ItemChargeAssgntPurch.SetFilter("Document Type",'=%1',PurchLine2."Document Type");
        //             ItemChargeAssgntPurch.SetFilter("Document No.",PurchLine2."Document No.");
        //             if not ItemChargeAssgntPurch.FindFirst then
        //               Error(Text100,CurrentConsignmentPoLine."PO No.");
        //           end;
        //         until PurchLine2.Next = 0;

        //         Clear(PurchLine);
        //         if TempItemChargeAssgntPurch.FindFirst then
        //           repeat
        //             Clear(ConsignmentPoLine);
        //             ConsignmentPoLine.Init;
        //             //Get PO Line
        //             PurchLine.Get(TempItemChargeAssgntPurch."Document Type",TempItemChargeAssgntPurch."Document No.",
        //               TempItemChargeAssgntPurch."Document Line No.");
        //             ConsignmentPoLine."Consignment Code" := "Consignment Code";
        //             ConsignmentPoLine."PO No." := "PO No.";
        //             ConsignmentPoLine."PO Line No." := TempItemChargeAssgntPurch."Document Line No.";
        //             ConsignmentPoLine.Type := PurchLine.Type::"Charge (Item)" ;
        //             ConsignmentPoLine."No." := TempItemChargeAssgntPurch."Item Charge No." ;
        //             ConsignmentPoLine."Currency Code" := PurchLine."Currency Code";
        //             ConsignmentPoLine.Description := TempItemChargeAssgntPurch.Description ;
        //             ConsignmentPoLine."Unit of Measure Code"  := PurchLine."Unit of Measure Code" ;
        //             ConsignmentPoLine."Direct Unit Cost"  := PurchLine."Direct Unit Cost";
        //             ConsignmentPoLine."Unit Cost (LCY)"  :=  PurchLine."Unit Cost (LCY)";
        //             ConsignmentPoLine.Validate(Quantity,TempItemChargeAssgntPurch."Qty. to Assign") ;
        //             ConsignmentPoLine."VAT Amount" := ConsignmentPoLine.Amount * PurchLine."VAT %" / 100;
        //             if PurchLine."Prepayment %" <> 0 then begin
        //               PurchLine.TestField("Order Prepmt. Amt. Inv.");
        //               ConsignmentPoLine."Prepmt. Amt. Inv." :=
        //                 PurchLine."Order Prepmt. Amt. Inv."  * ConsignmentPoLine.Quantity / PurchLine.Quantity;
        //               ConsignmentPoLine."Prepmt. Amount Inv. Incl. VAT" := PurchLine."Prepmt. Amount Inv. (LCY)"
        //                 * ConsignmentPoLine.Quantity / PurchLine.Quantity;
        //               ConsignmentPoLine."Prepmt. Amt. Incl. VAT" := PurchLine."Prepmt. Amt. Incl. VAT"
        //                  * ConsignmentPoLine.Quantity / PurchLine.Quantity;
        //             end;

        //             ConsignmentPoLine.Insert;
        //           until TempItemChargeAssgntPurch.Next = 0;
        //     end;


        //     procedure GetPurchaseLine()
        //     begin
        //         Clear(PurchLine);
        //         if ("PO No." <> '') and (ConsignmentPoLine."PO Line No." <> 0) then
        //           PurchLine.Get(PurchLine."document type"::Order,"PO No.",ConsignmentPoLine."PO Line No.");
        //     end;


        //     procedure RecreateLine()
        //     begin
        //         if not Confirm(Text101,false) then
        //           exit;
        //         ConsignmentPoLine.Reset;
        //         ConsignmentPoLine.SetRange("Consignment Code","Consignment Code");
        //         ConsignmentPoLine.SetRange("PO No.","PO No.");
        //         ConsignmentPoLine.SetRange(Type,ConsignmentPoLine.Type::Item);
        //         ConsignmentPoLine.DeleteAll(true);
        //         ConsignmentPoLine.Reset;

        //         IgnoreOutstandingQtyCheck := true;
        //         CreateConsignmentLines(Rec);
        //     end;
    }
}