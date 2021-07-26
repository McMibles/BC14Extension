TableExtension 52000012 tableextension52000012 extends "Purchase Header"
{
    fields
    {

        //Unsupported feature: Code Modification on ""Buy-from Vendor No."(Field 2).OnValidate".

        //trigger "(Field 2)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "No." = '' THEN
          InitRecord;
        TestStatusOpen;
        IF ("Buy-from Vendor No." <> xRec."Buy-from Vendor No.") AND
           (xRec."Buy-from Vendor No." <> '')
        THEN BEGIN
          CheckDropShipmentLineExists;
          IF GetHideValidationDialog OR NOT GUIALLOWED THEN
            Confirmed := TRUE
        #10..43
        "Responsibility Center" := UserSetupMgt.GetRespCenter(1,Vend."Responsibility Center");
        ValidateEmptySellToCustomerAndLocation;
        OnAfterCopyBuyFromVendorFieldsFromVendor(Rec,Vend,xRec);

        IF "Buy-from Vendor No." = xRec."Pay-to Vendor No." THEN
          IF ReceivedPurchLinesExist OR ReturnShipmentExist THEN BEGIN
            TESTFIELD("VAT Bus. Posting Group",xRec."VAT Bus. Posting Group");
        #51..91

        IF (xRec."Buy-from Vendor No." <> '') AND (xRec."Buy-from Vendor No." <> "Buy-from Vendor No.") THEN
          RecallModifyAddressNotification(GetModifyVendorAddressNotificationId);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..6
          //Added by Gems to prevent the change of vendor if the PO source is
          // PRN and RFQ
           PurchHook.CheckSource(Rec);
          //End

        #7..46
        WHTMgt.GetPurchWHTInfo(Rec);
        #48..94
        */
        //end;


        //Unsupported feature: Code Insertion on "Status(Field 120)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        //Calculate PO exipry date and Commitment when it is approved
        CASE Status OF
          1,3:BEGIN
                IF "Document Type" = "Document Type"::Order  THEN
                  PurchHook.CalculateExpiryDate(Rec);
                IF "Document Type" IN[1,2] THEN
                  PurchHook.CreateCommitment(Rec);
              END;
          ELSE
            PurchHook.DeleteCommitment(Rec);
        END;
        */
        //end;
        /* field(13760; "LC No."; Code[20])
         {
             Caption = 'LC No.';
             DataClassification = ToBeClassified;
             TableRelation = "LC Detail"."No." where("Transaction Type" = const(Purchase),
                                                      "Issued To/Received From" = field("Pay-to Vendor No."),
                                                      Closed = const(false),
                                                      Released = const(true));

             trigger OnValidate()
             var
                 Text13700: label 'The LC which you have selected is Foreign type you cannot utilise for this order.';
                 LCMgt: Codeunit "Letter of Credit Mgt";
             begin
                 if "LC No." <> '' then
                     TestField("BFC No.", '');
                 if xRec."LC No." <> "LC No." then begin
                     if xRec."LC No." <> '' then
                         LCMgt.CreateLCOrder(Rec, xRec."LC No.", true);

                     if "LC No." <> '' then
                         LCMgt.CreateLCOrder(Rec, xRec."LC No.", false);
                 end;
             end;
         }
         field(13761; "BFC No."; Code[20])
         {
             DataClassification = ToBeClassified;
             TableRelation = "Bills for Collection";

             trigger OnValidate()
             var
                 BFCMgt: Codeunit "Bills for Collection Mgt";
             begin
                 if "BFC No." <> '' then
                     TestField("LC No.", '');
                 if xRec."BFC No." <> "BFC No." then begin
                     if xRec."BFC No." <> '' then
                         BFCMgt.CreateBFCOrder(Rec, xRec."BFC No.", true);

                     if "BFC No." <> '' then
                         BFCMgt.CreateBFCOrder(Rec, xRec."BFC No.", false);

                 end;
             end;
         }*/
        field(52092337; "RFQ No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092338; "PRN No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092339; "No PO Attached"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //TestField("Order No.", '');
                TestField("Buy-from Vendor No.");
            end;
        }
        field(52092340; "Validity Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092341; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092342; "Revalidation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092343; "Suffix No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092344; "Original Suffix No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092345; "Quote Evaluation No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092346; "Order Type"; Option)
        {
            DataClassification = ToBeClassified;
            Description = 'Used to Identify Invt PO and Service PO';
            OptionCaption = 'Invt PO,Service PO';
            OptionMembers = "Invt PO","Service PO";
        }
        field(52092347; "Purchase Req. Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Account (G/L),Item,Fixed Asset,Charge (Item)';
            OptionMembers = " ","Account (G/L)",Item,"Fixed Asset","Charge (Item)";

            trigger OnValidate()
            begin
                //TestField("Purchase Req. Code", '');
            end;
        }
        /*field(52092348; "Purchase Req. Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Req. Type" where(Type = field("Purchase Req. Type"));

            trigger OnValidate()
            var
                PurchaseReqType: Record "Purchase Req. Type";
                Text60020: label 'If you change Purchase Req. Code, the existing Purchase lines will be deleted ';
                Text60021: label 'Do you want to change  Purchase Req. Code?';
            begin
                if ("Purchase Req. Code" <> xRec."Purchase Req. Code") then begin
                    TestField(Status, Status::Open);
                    if "Purchase Req. Code" <> '' then begin
                        PurchaseReqType.Get("Purchase Req. Code");
                        if PurchaseReqType.Type <> PurchaseReqType.Type::Item then
                            "Order Type" := "order type"::"Service PO"
                        else
                            "Order Type" := "order type"::"Invt PO";
                        if PurchLinesExist then begin
                            if Confirm(Text60020 + Text60021, false) then begin
                                PurchLine.SetRange("Document Type", "Document Type");
                                PurchLine.SetRange(PurchLine."Document No.", "No.");
                                if PurchLine.FindSet then
                                    PurchLine.DeleteAll(true);
                            end;
                        end;
                    end else begin
                        if Confirm(Text60020 + Text60021, false) then begin
                            PurchLine.SetRange("Document Type", "Document Type");
                            PurchLine.SetRange(PurchLine."Document No.", "No.");
                            if PurchLine.FindSet then
                                PurchLine.DeleteAll(true);
                        end;
                    end;
                end;

                "Receiving No. Series" := PurchHook.GetReceiptNo(Rec);
            end;
        }
        field(52092349;"Consignment Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Consignment Header";

            trigger OnValidate()
            var
                ConsignmentLine: Record "Consignment Line";
                Text60023: label 'Recognize GIT function Cost must be run before this function. Contact your System Logistic Co-ordinator for Assistance.';
            begin
                if "Consignment Code" <> '' then begin
                  TestField("Order No.");
                  ConsignmentLine.Get("Consignment Code","Order No.");
                  if not ConsignmentLine."GIT Cost Recognised" then
                    Error(Text60023);
                  ConsignmentLine.TestField(Invoiced,false);
                end;
            end;
        }*/
        field(52092350; "Landing Cost Calculated"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092351; "Service Posting Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Posting Date" := "Service Posting Date";
            end;
        }
        /*  field(52092352;"Indirect Consignment Cost";Decimal)
          {
              CalcFormula = sum("Consignment Ledger Entry".Amount where ("Consignment Code"=field("Consignment Code"),
                                                                         "PO No."=field("Order No."),
                                                                         "Direct Cost Invoice"=const(false)));
              Editable = false;
              FieldClass = FlowField;
          }
          field(52092353;"Indirect Cost (LCY) Incl. VAT";Decimal)
          {
              CalcFormula = sum("Purchase Line"."Indirect Cost (LCY) Incl. VAT" where ("Document Type"=field("Document Type"),
                                                                                       "Document No."=field("No.")));
              Editable = false;
              FieldClass = FlowField;
          }*/
        field(52092354; "Consignment Recognition"; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        /*field(52092355;"Order No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Header"."No." where ("Document Type"=const(Order),
                                                           "Buy-from Vendor No."=field("Buy-from Vendor No."));

            trigger OnValidate()
            var
                Text60015: label 'Do you want to delete existing purchase lines';
                Text60016: label '%1 cannot be blank!';
                Text60017: label '%1 cannot be changed!\Delete existing Purchase lines!';
            begin
                if "Document Type" = "document type"::Invoice then begin
                  TestField("No PO Attached",false);
                  if "Order No." = xRec."Order No." then
                    exit;

                  if "Order No." = '' then begin
                    if PurchLinesExist() then begin
                      if not Confirm(Text60015,false) then
                        Error(Text60016,FieldName("Order No."));
                      PurchLine.SetRange(PurchLine."Document Type","Document Type");
                      PurchLine.SetRange(PurchLine."Document No.","No.");
                      PurchLine.DeleteAll;
                    end;
                    "Order Date" := 0D;
                    "RFQ No." := '';
                    "Quote No." := '';
                  end else begin
                    if PurchLinesExist then
                      Error(Text60017,FieldName("Order No."));

                    PurchHeader.Get(PurchHeader."document type"::Order,"Order No.");
                    "Order Date" := PurchHeader."Order Date";
                    "RFQ No." := PurchHeader."RFQ No.";
                    "Quote No." := PurchHeader."Quote No.";
                    "PRN No." := PurchHeader."PRN No.";
                    "Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
                    Validate("Currency Factor",PurchHeader."Currency Factor");
                    "Payment Terms Code" := PurchHeader."Payment Terms Code";
                    "Due Date" := PurchHeader."Due Date";
                    if "Applies-to Doc. No." <> '' then begin
                      "Applies-to Doc. Type" := 0;
                      "Applies-to Doc. No."  := '';
                    end;
                  end;
                end;
            end;
        }*/
        field(52092356; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52092357; "Beneficiary No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(52092358; "Vendor Quote No."; Code[20])
        {
            Caption = 'Vendor Quote No.';
            DataClassification = ToBeClassified;
        }
        /* field(52130423;"WHT Posting Group";Code[20])
         {
             DataClassification = ToBeClassified;
             TableRelation = "WHT Posting Group";

             trigger OnValidate()
             var
                 WHTPostngGrp: Record "WHT Posting Group";
                 Text60019: label 'Action Aborted.';
                 Text60026: label 'Existing Lines will be updated with the changed are you sure you want toc continue?';
             begin
                 if "WHT Posting Group" <> '' then begin
                   WHTPostngGrp.Get("WHT Posting Group");
                   if WHTPostngGrp."WithHolding Tax %" <> 0 then
                     WHTPostngGrp.TestField("Purchase WHT Tax Account");
                   Validate("With-Holding Tax%",WHTPostngGrp."WithHolding Tax %");
                 end;

                 if ("WHT Posting Group" <> xRec."WHT Posting Group") and PurchLinesExist then
                   if not Confirm(Text60026) then
                     Error(Text60019)
                   else
                     repeat
                       if PurchLine.Quantity <> 0 then begin
                         PurchLine.Validate("WHT Posting Group","WHT Posting Group");
                         PurchLine.Modify;
                       end;
                     until PurchLine.Next = 0;
             end;
         }
         field(52130424;"With-Holding Tax%";Decimal)
         {
             DataClassification = ToBeClassified;

             trigger OnValidate()
             begin
                 TestField("WHT Posting Group");
                 PurchLine.SetRange("Document Type","Document Type");
                 PurchLine.SetRange("Document No.","No.");
                 if PurchLine.Find('-') then
                 repeat
                   PurchLine.Validate("With-Holding Tax%", "With-Holding Tax%");
                   PurchLine.Modify;
                 until PurchLine.Next = 0;
             end;
         }
         field(52130425;"With-Holding Tax Amt";Decimal)
         {
             CalcFormula = sum("Purchase Line"."With-Holding Tax Amt" where ("Document Type"=field("Document Type"),
                                                                             "Document No."=field("No.")));
             Editable = false;
             FieldClass = FlowField;
         }*/
        field(52130426; "WithHolding Tax Posting"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Invoice,Payment';
            OptionMembers = Invoice,Payment;
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT UserSetupMgt.CheckRespCenter(1,"Responsibility Center") THEN
      ERROR(
        Text023,
    #4..36
       (PurchCrMemoHeaderPrepmt."No." <> '')
    THEN
      MESSAGE(PostedDocsToPrintCreatedMsg);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..39

    PurchHook.DeleteCommitOnPurchHeaderDelete(Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    InitInsert;

    IF GETFILTER("Buy-from Vendor No.") <> '' THEN
    #4..6
    IF "Purchaser Code" = '' THEN
      SetDefaultPurchaser;

    IF "Buy-from Vendor No." <> '' THEN
      StandardCodesMgt.CheckShowPurchRecurringLinesNotification(Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    PurchHook.OnInsertPurchHeaderRec(Rec);
    #1..9
    PurchHook.PurchHeaderInitRecord(Rec);
    WHTMgt.OnInitPurchHeader(Rec);
    IF "Buy-from Vendor No." <> '' THEN
      StandardCodesMgt.CheckShowPurchRecurringLinesNotification(Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "TransferSavedFields(PROCEDURE 72)".

    //procedure TransferSavedFields();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    DestinationPurchaseLine.VALIDATE("Unit of Measure Code",SourcePurchaseLine."Unit of Measure Code");
    DestinationPurchaseLine.VALIDATE("Variant Code",SourcePurchaseLine."Variant Code");
    DestinationPurchaseLine."Prod. Order No." := SourcePurchaseLine."Prod. Order No.";
    #4..23
    DestinationPurchaseLine."Work Center No." := SourcePurchaseLine."Work Center No.";
    DestinationPurchaseLine."Prod. Order Line No." := SourcePurchaseLine."Prod. Order Line No.";
    DestinationPurchaseLine."Overhead Rate" := SourcePurchaseLine."Overhead Rate";

    OnAfterTransferSavedFields(DestinationPurchaseLine,SourcePurchaseLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..26
    //Gems
    DestinationPurchaseLine."PRN No." := SourcePurchaseLine."PRN No.";
    DestinationPurchaseLine."RFQ No." := SourcePurchaseLine."RFQ No.";
    DestinationPurchaseLine."Requisition Line No." :=  SourcePurchaseLine."Requisition Line No.";
    DestinationPurchaseLine."Shortcut Dimension 1 Code" := SourcePurchaseLine."Shortcut Dimension 1 Code";
    DestinationPurchaseLine."Shortcut Dimension 2 Code" := SourcePurchaseLine."Shortcut Dimension 2 Code";
    DestinationPurchaseLine."Dimension Set ID" := SourcePurchaseLine."Dimension Set ID";
    //

    OnAfterTransferSavedFields(DestinationPurchaseLine,SourcePurchaseLine);
    */
    //end;

    var
        PurchHook: Codeunit "Purchase Hook";
        WHTMgt: Codeunit "WHT Management";
}

