Table 52092351 "Stock Transaction Line"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'SRN,STOCKRET';
            OptionMembers = SRN,STOCKRET;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;

            trigger OnValidate()
            begin
                GetStockTranHeader("Document Type", "Document No.");
                "Shortcut Dimension 1 Code" := StockTranHeader."Global Dimension 1 Code";
                "Shortcut Dimension 2 Code" := StockTranHeader."Global Dimension 2 Code";
                "Gen. Bus. Posting Group" := StockTranHeader."Gen. Bus. Posting Group";
                "Location Code" := StockTranHeader."Location Code";
                "Job No." := StockTranHeader."Job No.";
                "Job Task No." := StockTranHeader."Job Task No.";

                if "Item No." <> xRec."Item No." then begin
                    "Variant Code" := '';
                    "Bin Code" := '';
                    if ("Location Code" <> '') and ("Item No." <> '') then begin
                        GetLocation("Location Code");
                        if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                            WMSManagement.GetDefaultBin("Item No.", "Variant Code", "Location Code", "Bin Code")
                    end;
                end;

                GetItem;
                Item.TestField(Blocked, false);
                Item.TestField(Type, Item.Type::Inventory);
                Description := Item.Description;
                "Inventory Posting Group" := Item."Inventory Posting Group";
                "Item Category Code" := Item."Item Category Code";
                //"Product Group Code" := Item."Product Group Code";
                "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                "Unit Amount" := Item."Unit Cost";
                "Unit of Measure Code" := Item."Base Unit of Measure";
                CreateDim(Database::Item, Item."No.");
            end;
        }
        field(8; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(9; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;

            trigger OnValidate()
            begin
                GetUnitAmount(FieldNo("Location Code"));
                "Unit Cost" := UnitCost;
                Validate("Unit Amount");
                CheckItemAvailable(FieldNo("Location Code"));

                if "Location Code" <> xRec."Location Code" then begin
                    "Bin Code" := '';
                    if ("Location Code" <> '') and ("Item No." <> '') then begin
                        GetLocation("Location Code");
                        if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                            WMSManagement.GetDefaultBin("Item No.", "Variant Code", "Location Code", "Bin Code");
                    end;

                end;

                Validate("Unit of Measure Code");
            end;
        }
        field(10; "Inventory Posting Group"; Code[10])
        {
            Caption = 'Inventory Posting Group';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Inventory Posting Group";
        }
        field(11; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(12; "Description 2"; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(13; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                CallWhseCheck: Boolean;
            begin
                TestReleased;
                if Quantity <= 0 then
                    FieldError(Quantity, Text003);

                "Quantity (Base)" := CalcBaseQty(Quantity);
                if "Document Type" in ["document type"::STOCKRET] then begin
                    if (Quantity * "Return Qty. Received" < 0) or
                       ((Abs(Quantity) < Abs("Return Qty. Received")))
                    then
                        FieldError(Quantity, StrSubstNo(Text003, FieldCaption("Return Qty. Received")));
                    if ("Quantity (Base)" * "Return Qty. Received (Base)" < 0) or
                       ((Abs("Quantity (Base)") < Abs("Return Qty. Received (Base)")))
                    then
                        FieldError("Quantity (Base)", StrSubstNo(Text003, FieldCaption("Return Qty. Received (Base)")));
                end else begin
                    if (Quantity * "Qty. Shipped" < 0) or
                       ((Abs(Quantity) < Abs("Qty. Shipped")))
                    then
                        FieldError(Quantity, StrSubstNo(Text003, FieldCaption("Qty. Shipped")));
                    if ("Quantity (Base)" * "Qty. Shipped (Base)" < 0) or
                       ((Abs("Quantity (Base)") < Abs("Qty. Shipped (Base)")))
                    then
                        FieldError("Quantity (Base)", StrSubstNo(Text003, FieldCaption("Qty. Shipped (Base)")));
                end;

                if (xRec.Quantity <> Quantity) or (xRec."Quantity (Base)" <> "Quantity (Base)") then begin
                    InitOutstanding;
                    if "Document Type" in ["document type"::SRN] then
                        InitQtyToReceive
                    else
                        InitQtyToShip;

                end;

                //InitOutstandingQtys;

                GetUnitAmount(FieldNo(Quantity));

                UpdateAmount;

                CheckItemAvailable(FieldNo(Quantity));
            end;
        }
        field(14; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(19; "Qty. Outstanding"; Decimal)
        {
            Caption = 'Qty. Outstanding';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            var
                WMSMgt: Codeunit "WMS Management";
            begin
                GetLocation("Location Code");
                "Qty. Outstanding (Base)" := CalcBaseQty("Qty. Outstanding");
                case "Document Type" of
                    "document type"::SRN:
                        Validate("Qty. to ship", "Qty. Outstanding");
                end;
            end;
        }
        field(20; "Qty. Outstanding (Base)"; Decimal)
        {
            Caption = 'Qty. Outstanding (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(21; "Qty. to ship"; Decimal)
        {
            Caption = 'Qty. to Ship';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MinValue = 0;

            trigger OnValidate()
            var
                ATOLink: Record "Assemble-to-Order Link";
                Confirmed: Boolean;
            begin
                GetLocation("Location Code");
                if "Qty. to ship" > "Qty. Outstanding" then
                    Error(
                      Text000,
                      "Qty. Outstanding");

                if CurrFieldNo <> FieldNo("Qty. to Ship (Base)") then
                    "Qty. to Ship (Base)" := CalcBaseQty("Qty. to ship");
            end;
        }
        field(22; "Qty. to Ship (Base)"; Decimal)
        {
            Caption = 'Qty. to Ship (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                Validate("Qty. to ship", CalcQty("Qty. to Ship (Base)"));
            end;
        }
        field(23; "Qty. Shipped"; Decimal)
        {
            Caption = 'Qty. Shipped';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                "Qty. Shipped (Base)" := CalcBaseQty("Qty. Shipped");
            end;
        }
        field(24; "Qty. Shipped (Base)"; Decimal)
        {
            Caption = 'Qty. Shipped (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(29; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';
            DataClassification = ToBeClassified;

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Applies-to Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                ItemTrackingLines: Page "Item Tracking Lines";
            begin
                if "Applies-to Entry" <> 0 then begin
                    ItemLedgEntry.Get("Applies-to Entry");

                    TestField(Quantity);
                    if Signed(Quantity) * ItemLedgEntry.Quantity > 0 then begin
                        if Quantity > 0 then
                            FieldError(Quantity, Text030);
                        if Quantity < 0 then
                            FieldError(Quantity, Text029);
                    end;
                    ItemLedgEntry.TestField(Positive, true);
                    if ItemLedgEntry.TrackingExists then
                        Error(Text033, FieldCaption("Applies-to Entry"), ItemTrackingLines.Caption);

                    if Abs("Qty. to Ship (Base)") > ItemLedgEntry.Quantity then
                        Error(ShippingMoreUnitsThanReceivedErr, ItemLedgEntry.Quantity, ItemLedgEntry."Document No.");

                    if not ItemLedgEntry.Open then
                        Message(Text032, "Applies-to Entry");

                    "Location Code" := ItemLedgEntry."Location Code";
                    "Variant Code" := ItemLedgEntry."Variant Code";
                end;
            end;
        }
        field(30; "Unit Amount"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Amount';
            DataClassification = ToBeClassified;
        }
        field(31; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            DataClassification = ToBeClassified;
        }
        field(32; Amount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(34; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(35; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(36; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(57; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(58; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Product Posting Group";
        }
        field(1000; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            begin
                Job.Get("Job No.");
                Job.TestBlocked;
            end;
        }
        field(1001; "Job Task No."; Code[20])
        {
            Caption = 'Job Task No.';
            DataClassification = ToBeClassified;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));

            trigger OnValidate()
            begin
                TestReleased;
            end;
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestReleased;
            end;
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));

            trigger OnValidate()
            begin
                GetItem;
                "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, "Unit of Measure Code");

                GetUnitAmount(FieldNo("Unit of Measure Code"));

                ReadGLSetup;
                "Unit Cost" := ROUND(UnitCost * "Qty. per Unit of Measure", GLSetup."Unit-Amount Rounding Precision");

                Validate("Unit Amount");

                Validate(Quantity);
            end;
        }
        field(5704; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category";
        }
        field(5707; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Category".Code;
        }
        field(5708; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5709; "Overhead Rate"; Decimal)
        {
            Caption = 'Overhead Rate';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(5803; "Return Qty. to Receive"; Decimal)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            Caption = 'Return Qty. to Receive';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
            begin
                if "Return Qty. to Receive" = Quantity - "Return Qty. Received" then
                    InitQtyToReceive
                else
                    "Return Qty. to Receive (Base)" := CalcBaseQty("Return Qty. to Receive");

                if ("Return Qty. to Receive" * Quantity < 0) or
                   (Abs("Return Qty. to Receive") > Abs("Qty. Outstanding")) or
                   (Quantity * "Qty. Outstanding" < 0)
                then
                    Error(
                      Text020,
                      "Qty. Outstanding");
                if ("Return Qty. to Receive (Base)" * "Quantity (Base)" < 0) or
                   (Abs("Return Qty. to Receive (Base)") > Abs("Qty. Outstanding (Base)")) or
                   ("Quantity (Base)" * "Qty. Outstanding (Base)" < 0)
                then
                    Error(
                      Text021,
                      "Qty. Outstanding (Base)");

                if (CurrFieldNo <> 0) and ("Return Qty. to Receive" > 0) then
                    CheckApplFromItemLedgEntry(ItemLedgEntry);
            end;
        }
        field(5804; "Return Qty. to Receive (Base)"; Decimal)
        {
            Caption = 'Return Qty. to Receive (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TestField("Qty. per Unit of Measure", 1);
                Validate("Return Qty. to Receive", "Return Qty. to Receive (Base)");
            end;
        }
        field(5807; "Applies-from Entry"; Integer)
        {
            Caption = 'Applies-from Entry';
            DataClassification = ToBeClassified;
            MinValue = 0;

            trigger OnLookup()
            begin
                SelectItemEntry(FieldNo("Applies-from Entry"));
            end;

            trigger OnValidate()
            var
                ItemLedgEntry: Record "Item Ledger Entry";
                ItemTrackingLines: Page "Item Tracking Lines";
            begin
                if "Applies-from Entry" <> 0 then begin
                    TestField(Quantity);
                    if Signed(Quantity) < 0 then begin
                        if Quantity > 0 then
                            FieldError(Quantity, Text030);
                        if Quantity < 0 then
                            FieldError(Quantity, Text029);
                    end;
                    ItemLedgEntry.Get("Applies-from Entry");
                    ItemLedgEntry.TestField(Positive, false);
                    if ItemLedgEntry.TrackingExists then
                        Error(Text033, FieldCaption("Applies-from Entry"), ItemTrackingLines.Caption);
                    "Unit Cost" := CalcUnitCost(ItemLedgEntry);
                end;
            end;
        }
        field(5809; "Return Qty. Received"; Decimal)
        {
            AccessByPermission = TableData "Return Receipt Header" = R;
            Caption = 'Return Qty. Received';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5810; "Return Qty. Received (Base)"; Decimal)
        {
            Caption = 'Return Qty. Received (Base)';
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(6000; "Completely Shipped"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6001; "Completely Received"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Location: Record Location;
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
        StockTranHeader: Record "Stock Transaction Header";
        Job: Record Job;
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        WMSManagement: Codeunit "WMS Management";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        UOMMgt: Codeunit "Unit of Measure Management";
        DimMgt: Codeunit DimensionManagement;
        UnitCost: Decimal;
        GLSetupRead: Boolean;
        Text000: label 'You cannot handle more than the outstanding %1 units.';
        Text001: label 'must not be less than %1 units';
        Text003: label 'must be greater than zero';
        Text020: label 'You cannot return more than %1 units.';
        Text021: label 'You cannot return more than %1 base units.';
        Text029: label 'must be positive';
        Text030: label 'must be negative';
        Text032: label 'When posting, the entry %1 will be opened first.';
        Text033: label 'If the item carries serial or lot numbers, then you must use the %1 field in the %2 window.';
        Text040: label 'You must use form %1 to enter %2, if item tracking is used.';
        Text046: label 'You cannot return more than the %1 units that you have shipped for %2 %3.';
        ShippingMoreUnitsThanReceivedErr: label 'You cannot ship more than the %1 units that you have received for document no. %2.';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    local procedure GetItem()
    begin
        if Item."No." <> "Item No." then
            Item.Get("Item No.");
    end;

    local procedure CheckItemAvailable(CalledByFieldNo: Integer)
    var
        TempItemJnlLine: Record "Item Journal Line" temporary;
    begin
        if (CurrFieldNo = 0) or (CurrFieldNo <> CalledByFieldNo) then // Prevent two checks on quantity
            exit;

        if (CurrFieldNo <> 0) and ("Item No." <> '') and (Quantity <> 0)
          and ("Document Type" = "document type"::SRN) then begin
            Clear(TempItemJnlLine);
            TempItemJnlLine."Journal Template Name" := 'SRN';
            TempItemJnlLine."Journal Batch Name" := CopyStr("Document No.", 1, 10);
            TempItemJnlLine."Line No." := "Line No.";
            TempItemJnlLine."Location Code" := "Location Code";
            TempItemJnlLine.Quantity := Quantity;
            TempItemJnlLine.Insert;
            if ItemCheckAvail.ItemJnlCheckLine(TempItemJnlLine) then
                ItemCheckAvail.RaiseUpdateInterruptedError;
        end;
    end;

    local procedure GetUnitAmount(CalledByFieldNo: Integer)
    var
        UnitCostValue: Decimal;
    begin
        RetrieveCosts;
        UnitCostValue := UnitCost;
        if (CalledByFieldNo = FieldNo(Quantity)) and (Item."Costing Method" <> Item."costing method"::Standard) then
            UnitCostValue := "Unit Cost";

        case "Document Type" of
            "document type"::STOCKRET:
                "Unit Amount" :=
                  ROUND(
                    ((UnitCostValue - "Overhead Rate") * "Qty. per Unit of Measure") / (1 + "Indirect Cost %" / 100),
                    GLSetup."Unit-Amount Rounding Precision");
            "document type"::SRN:
                "Unit Amount" := UnitCostValue * "Qty. per Unit of Measure";
        end;
    end;

    local procedure RetrieveCosts()
    var
        StockkeepingUnit: Record "Stockkeeping Unit";
    begin
        ReadGLSetup;
        GetItem;
        if StockkeepingUnit.Get("Location Code", "Item No.", "Variant Code") then
            UnitCost := StockkeepingUnit."Unit Cost"
        else
            UnitCost := Item."Unit Cost";
        if Item."Costing Method" <> Item."costing method"::Standard then
            UnitCost := ROUND(UnitCost, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure ReadGLSetup()
    begin
        if not GLSetupRead then begin
            GLSetup.Get;
            GLSetupRead := true;
        end;
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(ROUND(Qty * "Qty. per Unit of Measure", 0.00001));
    end;


    procedure CalcQty(QtyBase: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(ROUND(QtyBase / "Qty. per Unit of Measure", 0.00001));
    end;

    local procedure UpdateAmount()
    begin
        Amount := ROUND(Quantity * "Unit Amount");
    end;

    local procedure TestReleased()
    begin
        TestField("Document No.");
        GetStockTranHeader("Document Type", "Document No.");
        StockTranHeader.TestField(Status, StockTranHeader.Status::Open);
    end;

    local procedure GetStockTranHeader(DocType: Integer; StockTranNo: Code[20])
    begin
        if StockTranHeader."No." <> StockTranNo then
            StockTranHeader.Get(DocType, StockTranNo);
    end;


    procedure InitOutstandingQtys()
    begin
        case "Document Type" of
            "document type"::SRN:
                begin
                    Validate("Qty. Outstanding", Quantity - "Qty. Shipped");
                    "Qty. Outstanding (Base)" := "Quantity (Base)" - "Qty. Shipped (Base)";
                end;
        end;
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetStockTranHeader("Document Type", "Document No.");
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, '',
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            StockTranHeader."Dimension Set ID", Database::Item);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', "Document Type", "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgtHook: Codeunit "Dimension Hook";
    begin
        DimMgtHook.GetMappedDimValue(ShortcutDimCode, "Dimension Set ID", FieldNumber, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    local procedure SelectItemEntry(CurrentFieldNo: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        lStockTranLine: Record "Stock Transaction Line";
    begin
        ItemLedgEntry.SetCurrentkey("Item No.", Positive);
        ItemLedgEntry.SetRange("Item No.", "Item No.");

        if "Location Code" <> '' then
            ItemLedgEntry.SetRange("Location Code", "Location Code");

        if CurrentFieldNo = FieldNo("Applies-to Entry") then begin
            ItemLedgEntry.SetCurrentkey("Item No.", Open);
            ItemLedgEntry.SetRange(Positive, (Signed(Quantity) < 0));
            ItemLedgEntry.SetRange(Open, true);
        end else
            ItemLedgEntry.SetRange(Positive, false);

        if Page.RunModal(Page::"Item Ledger Entries", ItemLedgEntry) = Action::LookupOK then begin
            lStockTranLine := Rec;
            if CurrentFieldNo = FieldNo("Applies-to Entry") then
                lStockTranLine.Validate("Applies-to Entry", ItemLedgEntry."Entry No.")
            else
                lStockTranLine.Validate("Applies-from Entry", ItemLedgEntry."Entry No.");
            CheckItemAvailable(CurrentFieldNo);
            Rec := lStockTranLine;
        end;
    end;

    procedure Signed(Value: Decimal): Decimal
    begin
        case "Document Type" of
            "document type"::STOCKRET:
                exit(Value);
            "document type"::SRN:
                exit(-Value);
        end;
    end;

    local procedure CalcUnitCost(ItemLedgEntry: Record "Item Ledger Entry"): Decimal
    var
        ValueEntry: Record "Value Entry";
        UnitCost: Decimal;
    begin
        with ValueEntry do begin
            Reset;
            SetCurrentkey("Item Ledger Entry No.");
            SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
            CalcSums("Cost Amount (Expected)", "Cost Amount (Actual)");
            UnitCost :=
              ("Cost Amount (Expected)" + "Cost Amount (Actual)") / ItemLedgEntry.Quantity;
        end;
        exit(Abs(UnitCost * "Qty. per Unit of Measure"));
    end;


    procedure InitOutstanding()
    begin
        if "Document Type" in ["document type"::SRN] then begin
            "Qty. Outstanding" := Quantity - "Qty. Shipped";
            "Qty. Outstanding (Base)" := "Quantity (Base)" - "Qty. Shipped (Base)";
        end else begin
            "Qty. Outstanding" := Quantity - "Return Qty. Received";
            "Qty. Outstanding (Base)" := "Quantity (Base)" - "Return Qty. Received (Base)";
        end;
    end;

    procedure InitQtyToReceive()
    begin
        "Return Qty. to Receive" := "Qty. Outstanding";
        "Return Qty. to Receive (Base)" := "Qty. Outstanding (Base)";
    end;

    procedure InitQtyToShip()
    begin
        "Qty. to ship" := "Qty. Outstanding";
        "Qty. to Ship (Base)" := "Qty. Outstanding (Base)";
    end;

    local procedure CheckApplFromItemLedgEntry(var ItemLedgEntry: Record "Item Ledger Entry")
    var
        ItemTrackingLines: Page "Item Tracking Lines";
        QtyNotReturned: Decimal;
        QtyReturned: Decimal;
    begin
        if "Applies-from Entry" = 0 then
            exit;

        //IF "Shipment No." <> '' THEN
        //EXIT;

        TestField(Quantity);
        if "Document Type" in ["document type"::STOCKRET] then begin
            if Quantity < 0 then
                FieldError(Quantity, Text029);
        end else begin
            if Quantity > 0 then
                FieldError(Quantity, Text030);
        end;

        ItemLedgEntry.Get("Applies-from Entry");
        ItemLedgEntry.TestField(Positive, false);
        ItemLedgEntry.TestField("Item No.", "Item No.");
        ItemLedgEntry.TestField("Variant Code", "Variant Code");
        if ItemLedgEntry.TrackingExists then
            Error(Text040, ItemTrackingLines.Caption, FieldCaption("Applies-from Entry"));

        if Abs("Quantity (Base)") > -ItemLedgEntry.Quantity then
            Error(
              Text046,
              -ItemLedgEntry.Quantity, ItemLedgEntry.FieldCaption("Document No."),
              ItemLedgEntry."Document No.");
    end;
}

