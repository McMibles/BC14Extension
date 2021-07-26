TableExtension 52000036 tableextension52000036 extends "Requisition Line"
{
    fields
    {
        modify(Type)
        {
            OptionCaption = ' ,G/L Account,Item,Fixed Asset,Charge (Item)';
            trigger OnBeforeValidate()
            begin
                IF CurrFieldNo <> 0 THEN
                    PurchaseHook.CheckValidateReqType(Rec);
            end;

        }
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                PurchaseHook.ReqLineAccNoOnValidate(Rec);

            end;

            trigger OnAfterValidate()
            begin
                PurchaseHook.GetReqLineAccountNo(Rec);
                IF CurrFieldNo <> 0 THEN BEGIN
                    PurchReqType.ValidateDimCode(1, "Shortcut Dimension 1 Code");
                    PurchReqType.ValidateDimCode(2, "Shortcut Dimension 2 Code");
                END;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                "Est. Amount" := "Direct Unit Cost" * Quantity;
            end;
        }
        modify("Direct Unit Cost")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("Est. Amount", "Requested Quantity" * "Direct Unit Cost");
            end;
        }
        modify("Shortcut Dimension 1 Code")
        {
            trigger OnBeforeValidate()
            begin
                PurchaseHook.CheckValidateReqDim(Rec);
            end;
        }
        modify("Shortcut Dimension 2 Code")
        {
            trigger OnBeforeValidate()
            begin
                PurchaseHook.CheckValidateReqDim(Rec);
            end;
        }
        //Unsupported feature: Code Modification on "Type(Field 4).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF Type <> xRec.Type THEN BEGIN
          NewType := Type;

        #4..11
          INIT;
          Type := NewType;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        IF CurrFieldNo <> 0 THEN
          PurchaseHook.CheckValidateReqType(Rec);

        #1..14
        */
        //end;


        //Unsupported feature: Code Insertion (VariableCollection) on ""No."(Field 5).OnValidate".

        //trigger (Variable: PurchReqType)()
        //Parameters and return type have not been exported.
        //begin
        /*
        */
        //end;


        //Unsupported feature: Code Modification on ""No."(Field 5).OnValidate".

        //trigger "(Field 5)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CheckActionMessageNew;
        ReserveReqLine.VerifyChange(Rec,xRec);
        DeleteRelations;
        #4..23
          Type::Item:
            CopyFromItem;
        END;

        IF "Planning Line Origin" <> "Planning Line Origin"::"Order Planning" THEN
          IF ("Replenishment System" = "Replenishment System"::Purchase) AND
        #30..35
        CreateDim(
          DimMgt.TypeToTableID3(Type),
          "No.",DATABASE::Vendor,"Vendor No.");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        PurchaseHook.ReqLineAccNoOnValidate(Rec);
        #1..26
        PurchaseHook.GetReqLineAccountNo(Rec);
        #27..38
        //Inserted By Gems
        IF CurrFieldNo <> 0 THEN BEGIN
          PurchReqType.ValidateDimCode(1,"Shortcut Dimension 1 Code");
          PurchReqType.ValidateDimCode(2,"Shortcut Dimension 2 Code");
        END;
        */
        //end;


        //Unsupported feature: Code Modification on "Quantity(Field 8).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        "Quantity (Base)" := CalcBaseQty(Quantity);
        IF Type = Type::Item THEN BEGIN
          GetDirectCost(FIELDNO(Quantity));
        #4..19
              VALIDATE("Starting Time");
            END;
          ReserveReqLine.VerifyQuantity(Rec,xRec);
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..22
           //Inserted By Gems
          "Est. Amount" := "Direct Unit Cost" * Quantity;
        END;
        */
        //end;


        //Unsupported feature: Code Insertion on ""Direct Unit Cost"(Field 10)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
        /*
        VALIDATE("Est. Amount","Requested Quantity" * "Direct Unit Cost");
        */
        //end;


        //Unsupported feature: Code Modification on ""Shortcut Dimension 1 Code"(Field 15).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        PurchaseHook.CheckValidateReqDim(Rec);
        ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
        */
        //end;


        //Unsupported feature: Code Modification on ""Shortcut Dimension 2 Code"(Field 16).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        PurchaseHook.CheckValidateReqDim(Rec);
        ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
        */
        //end;
        field(52092337; "Last Direct Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "Direct Unit Cost" := "Last Direct Unit Cost";
                Validate("Requested Quantity");
            end;
        }
        field(52092338; "Est. Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092339; "Requested Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Requested Quantity" <> 0 then
                    TestField("No.");

                Validate(Quantity, "Requested Quantity");
                Validate("Est. Amount", "Requested Quantity" * "Direct Unit Cost");
            end;
        }
        field(52092340; "Offered Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092341; "Maintenance Code"; Code[10])
        {
            Caption = 'Maintenance Code';
            DataClassification = ToBeClassified;
            TableRelation = Maintenance;
        }
        field(52092342; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;
        }
        field(52092343; "Job Task No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(52092344; "Expected Receipt Date"; Date)
        {
            Caption = 'Need by Date';
            DataClassification = ToBeClassified;
        }
        field(52092345; "FA Posting Type"; Option)
        {
            Caption = 'FA Posting Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Acquisition Cost,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;

            trigger OnValidate()
            begin
                if "FA Posting Type" <> "fa posting type"::" " then
                    //TestField(Type, Type::"Fixed Asset");
                    TestField("Job No.", '');
                //end else
                //TestField(Type, Type::"Fixed Asset");
            end;
        }
        field(52092346; "Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092347; "Depreciation Book Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52092348; "Currency Code2"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52092349; "Est. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            var
                Currency: Record Currency;
                CurrExchRate: Record "Currency Exchange Rate";
            begin
                ReqWkshName.Get("Worksheet Template Name", "Journal Batch Name");
                "Currency Code2" := ReqWkshName."Currency Code";
                if "Currency Code2" = '' then begin
                    "Est. Amount (LCY)" := "Est. Amount";
                    if "Requested Quantity" <> 0 then
                        "Offered Unit Price" := ROUND("Est. Amount (LCY)" / "Requested Quantity");
                end else begin
                    "Est. Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        ReqWkshName."Creation Date", "Currency Code2",
                        "Est. Amount", ReqWkshName."Currency Factor"));
                    if "Requested Quantity" <> 0 then
                        "Offered Unit Price" := ROUND("Est. Amount (LCY)" / "Requested Quantity");
                end;
            end;
        }
        field(52092350; "Work Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092351; "Work Order Task No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ReqLine.RESET;
    ReqLine.GET("Worksheet Template Name","Journal Batch Name","Line No.");
    WHILE (ReqLine.NEXT <> 0) AND (ReqLine.Level > Level) DO
    #4..8
    TESTFIELD("Reserved Qty. (Base)",0);

    DeleteRelations;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11
    BudgetControlMgt.DeleteCommitment("Journal Batch Name","Line No.","Account No.");
    */
    //end;


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF CURRENTKEY <> Rec2.CURRENTKEY THEN BEGIN
      Rec2 := Rec;
      Rec2.SETRECFILTER;
    #4..10
    ReqWkshTmpl.GET("Worksheet Template Name");
    ReqWkshName.GET("Worksheet Template Name","Journal Batch Name");

    ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
    ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..13
    PurchaseHook.ReqLineOnInsert(Rec);

    ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
    ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
    */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ReserveReqLine.VerifyChange(Rec,xRec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    ReserveReqLine.VerifyChange(Rec,xRec);

    PurchaseHook.CheckFAAcquisitionOnReq(Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "CopyFromItem(PROCEDURE 78)".

    //procedure CopyFromItem();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetItem;
    OnBeforeCopyFromItem(Rec,Item,xRec,CurrFieldNo);

    #4..21
    "Accept Action Message" := TRUE;
    GetDirectCost(FIELDNO("No."));
    SetFromBinCode;

    OnAfterCopyFromItem(Rec,Item);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..24
    //Inserted By Gems - Begin
    IF "Direct Unit Cost" = 0 THEN
      VALIDATE("Last Direct Unit Cost",Item."Last Direct Cost");
    //End

    OnAfterCopyFromItem(Rec,Item);
    */
    //end;

    var
        PurchReqType: Record "Purchase Req. Type";
        ReqWkshName: Record "Requisition Wksh. Name";

    var
        PurchaseHook: Codeunit "Purchase Hook";
        BudgetControlMgt: Codeunit "Budget Control Management";
}

