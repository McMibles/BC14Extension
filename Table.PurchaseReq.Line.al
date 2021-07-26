Table 52092345 "Purchase Req. Line"
{
    Caption = 'Requisition Line';
    DataCaptionFields = "Journal Batch Name", "Line No.";
    DrillDownPageID = "Requisition Lines";
    LookupPageID = "Requisition Lines";

    fields
    {
        field(1; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            TableRelation = "Req. Wksh. Template";
        }
        field(2; "Journal Batch Name"; Code[20])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("Worksheet Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,"Fixed Asset","Charge (Item)";
        }
        field(5; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const("Fixed Asset")) Resource;
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(7; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(8; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(9; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = "Purch. Doc./Supp. Combination"."Vendor No." where("Document No." = field("Journal Batch Name"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if "Vendor No." <> '' then
                    Vend.Get("Vendor No.");
            end;
        }
        field(10; "Direct Unit Cost"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Direct Unit Cost';
        }
        field(12; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(13; "Requester ID"; Code[50])
        {
            Caption = 'Requester ID';
            //TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;

            trigger OnValidate()
            var
                LoginMgt: Codeunit "User Management";
            begin
            end;
        }
        field(14; Confirmed; Boolean)
        {
            Caption = 'Confirmed';
        }
        field(15; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(16; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(17; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(18; "Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(19; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(20; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(21; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(22; "Vendor Item No."; Text[20])
        {
            Caption = 'Vendor Item No.';
        }
        field(23; "Sales Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(24; "Sales Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;
        }
        field(25; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
        field(26; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            Editable = false;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(28; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code where("Vendor No." = field("Vendor No."));
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            MinValue = 0;
        }
        field(31; "Reserved Quantity"; Decimal)
        {
            CalcFormula = sum("Reservation Entry".Quantity where("Source ID" = field("Worksheet Template Name"),
                                                                  "Source Ref. No." = field("Line No."),
                                                                  "Source Type" = const(246),
                                                                  "Source Subtype" = const(0),
                                                                  "Source Batch Name" = field("Journal Batch Name"),
                                                                  "Source Prod. Order Line" = const(0),
                                                                  "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5401; "Prod. Order No."; Code[20])
        {
            Caption = 'Prod. Order No.';
            Editable = false;
            TableRelation = "Production Order"."No." where(Status = const(Released));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(5402; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = if (Type = const(Item)) "Item Variant".Code where("Item No." = field("No."));
        }
        field(5403; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"),
                                            "Item Filter" = field("No."),
                                            "Variant Filter" = field("Variant Code"));
        }
        field(5404; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0 : 5;
            Editable = false;
            InitValue = 1;
        }
        field(5407; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."))
            else
            "Unit of Measure";
        }
        field(5408; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            DecimalPlaces = 0 : 5;
        }
        field(5431; "Reserved Qty. (Base)"; Decimal)
        {
            CalcFormula = sum("Reservation Entry"."Quantity (Base)" where("Source ID" = field("Worksheet Template Name"),
                                                                           "Source Ref. No." = field("Line No."),
                                                                           "Source Type" = const(246),
                                                                           "Source Subtype" = const(0),
                                                                           "Source Batch Name" = field("Journal Batch Name"),
                                                                           "Source Prod. Order Line" = const(0),
                                                                           "Reservation Status" = const(Reservation)));
            Caption = 'Reserved Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(5520; "Demand Type"; Integer)
        {
            Caption = 'Demand Type';
            Editable = false;
            TableRelation = Object.ID where(Type = const(Table));
        }
        field(5521; "Demand Subtype"; Option)
        {
            Caption = 'Demand Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9";
        }
        field(5522; "Demand Order No."; Code[20])
        {
            Caption = 'Demand Order No.';
            Editable = false;
        }
        field(5525; "Demand Line No."; Integer)
        {
            Caption = 'Demand Line No.';
            Editable = false;
        }
        field(5526; "Demand Ref. No."; Integer)
        {
            Caption = 'Demand Ref. No.';
            Editable = false;
        }
        field(5527; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(5530; "Demand Date"; Date)
        {
            Caption = 'Demand Date';
            Editable = false;
        }
        field(5532; "Demand Quantity"; Decimal)
        {
            Caption = 'Demand Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5533; "Demand Quantity (Base)"; Decimal)
        {
            Caption = 'Demand Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5538; "Needed Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Needed Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5539; "Needed Quantity (Base)"; Decimal)
        {
            BlankZero = true;
            Caption = 'Needed Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5540; Reserve; Boolean)
        {
            Caption = 'Reserve';
        }
        field(5541; "Qty. per UOM (Demand)"; Decimal)
        {
            Caption = 'Qty. per UOM (Demand)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5542; "Unit Of Measure Code (Demand)"; Code[10])
        {
            Caption = 'Unit Of Measure Code (Demand)';
            Editable = false;
            TableRelation = if (Type = const(Item)) "Item Unit of Measure".Code where("Item No." = field("No."));
        }
        field(5552; "Supply From"; Code[20])
        {
            Caption = 'Supply From';
            TableRelation = if ("Replenishment System" = const(Purchase)) Vendor
            else
            if ("Replenishment System" = const(Transfer)) Location where("Use As In-Transit" = const(false));
        }
        field(5553; "Original Item No."; Code[20])
        {
            Caption = 'Original Item No.';
            Editable = false;
            TableRelation = Item;
        }
        field(5554; "Original Variant Code"; Code[10])
        {
            Caption = 'Original Variant Code';
            Editable = false;
            TableRelation = "Item Variant".Code where("Item No." = field("Original Item No."));
        }
        field(5560; Level; Integer)
        {
            Caption = 'Level';
            Editable = false;
        }
        field(5563; "Demand Qty. Available"; Decimal)
        {
            Caption = 'Demand Qty. Available';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(5590; "User ID"; Code[20])
        {
            Caption = 'User ID';
            Editable = false;
            //TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(5701; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            TableRelation = if (Type = const(Item)) "Item Category";
        }
        field(5702; Nonstock; Boolean)
        {
            Caption = 'Nonstock';
        }
        field(5703; "Purchasing Code"; Code[10])
        {
            Caption = 'Purchasing Code';
            TableRelation = Purchasing;
        }
        field(5705; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "Item Category".Code;
        }
        field(5706; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            Editable = false;
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(5707; "Transfer Shipment Date"; Date)
        {
            Caption = 'Transfer Shipment Date';
            Editable = false;
        }
        field(7002; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50008; "Requested Qty."; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(52092337; "Last Direct Unit Cost"; Decimal)
        {
        }
        field(52092338; "Est. Amount (LCY)"; Decimal)
        {
        }
        field(52092339; "Requested Quantity"; Decimal)
        {
        }
        field(52092340; "Offered Unit Price"; Decimal)
        {
        }
        field(52092341; "Maintenance Code"; Code[10])
        {
            Caption = 'Maintenance Code';
            TableRelation = Maintenance;
        }
        field(52092342; "Job No."; Code[20])
        {
            TableRelation = Job;
        }
        field(52092343; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(52092344; "Expected Receipt Date"; Date)
        {
            Caption = 'Need by Date';
        }
        field(52092345; "FA Posting Type"; Option)
        {
            Caption = 'FA Posting Type';
            OptionCaption = ' ,Acquisition Cost,Maintenance';
            OptionMembers = " ","Acquisition Cost",Maintenance;
        }
        field(52092346; "Account No."; Code[20])
        {
        }
        field(52092347; "Depreciation Book Code"; Code[10])
        {
        }
        field(52092348; "Currency Code2"; Code[10])
        {
        }
        field(52092349; "Est. Amount"; Decimal)
        {
            Editable = false;
        }
        field(52092350; "Work Order No."; Code[20])
        {
            Editable = false;
        }
        field(52092351; "Work Order Task No."; Code[20])
        {
            Editable = false;
        }
        field(99000750; "Routing No."; Code[20])
        {
            Caption = 'Routing No.';
            TableRelation = "Routing Header";

            trigger OnValidate()
            var
                RtngDate: Date;
            begin
            end;
        }
        field(99000751; "Operation No."; Code[10])
        {
            Caption = 'Operation No.';
            TableRelation = "Prod. Order Routing Line"."Operation No." where(Status = const(Released),
                                                                              "Prod. Order No." = field("Prod. Order No."),
                                                                              "Routing No." = field("Routing No."));

            trigger OnValidate()
            var
                ProdOrderRtngLine: Record "Prod. Order Routing Line";
            begin
            end;
        }
        field(99000752; "Work Center No."; Code[20])
        {
            Caption = 'Work Center No.';
            TableRelation = "Work Center";
        }
        field(99000754; "Prod. Order Line No."; Integer)
        {
            Caption = 'Prod. Order Line No.';
            Editable = false;
            TableRelation = "Prod. Order Line"."Line No." where(Status = const(Finished),
                                                                 "Prod. Order No." = field("Prod. Order No."));
        }
        field(99000755; "MPS Order"; Boolean)
        {
            Caption = 'MPS Order';
        }
        field(99000756; "Planning Flexibility"; Option)
        {
            Caption = 'Planning Flexibility';
            OptionCaption = 'Unlimited,None';
            OptionMembers = Unlimited,"None";
        }
        field(99000757; "Routing Reference No."; Integer)
        {
            Caption = 'Routing Reference No.';
        }
        field(99000882; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(99000883; "Gen. Business Posting Group"; Code[10])
        {
            Caption = 'Gen. Business Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(99000884; "Low-Level Code"; Integer)
        {
            Caption = 'Low-Level Code';
            Editable = false;
        }
        field(99000885; "Production BOM Version Code"; Code[10])
        {
            Caption = 'Production BOM Version Code';
            TableRelation = "Production BOM Version"."Version Code" where("Production BOM No." = field("Production BOM No."));
        }
        field(99000886; "Routing Version Code"; Code[10])
        {
            Caption = 'Routing Version Code';
            TableRelation = "Routing Version"."Version Code" where("Routing No." = field("Routing No."));
        }
        field(99000887; "Routing Type"; Option)
        {
            Caption = 'Routing Type';
            OptionCaption = 'Serial,Parallel';
            OptionMembers = Serial,Parallel;
        }
        field(99000888; "Original Quantity"; Decimal)
        {
            BlankZero = true;
            Caption = 'Original Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000889; "Finished Quantity"; Decimal)
        {
            Caption = 'Finished Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(99000890; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining Quantity';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MinValue = 0;
        }
        field(99000891; "Original Due Date"; Date)
        {
            Caption = 'Original Due Date';
            Editable = false;
        }
        field(99000892; "Scrap %"; Decimal)
        {
            Caption = 'Scrap %';
            DecimalPlaces = 0 : 5;
        }
        field(99000894; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(99000895; "Starting Time"; Time)
        {
            Caption = 'Starting Time';
        }
        field(99000896; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(99000897; "Ending Time"; Time)
        {
            Caption = 'Ending Time';
        }
        field(99000898; "Production BOM No."; Code[20])
        {
            Caption = 'Production BOM No.';
            TableRelation = "Production BOM Header"."No." where(Status = const(Certified));

            trigger OnValidate()
            var
                BOMDate: Date;
            begin
            end;
        }
        field(99000899; "Indirect Cost %"; Decimal)
        {
            Caption = 'Indirect Cost %';
            DecimalPlaces = 0 : 5;
        }
        field(99000900; "Overhead Rate"; Decimal)
        {
            Caption = 'Overhead Rate';
            DecimalPlaces = 0 : 5;
        }
        field(99000901; "Unit Cost"; Decimal)
        {
            AutoFormatType = 2;
            Caption = 'Unit Cost';
            MinValue = 0;
        }
        field(99000902; "Cost Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Cost Amount';
            Editable = false;
            MinValue = 0;
        }
        field(99000903; "Replenishment System"; Option)
        {
            Caption = 'Replenishment System';
            OptionCaption = 'Purchase,Prod. Order,Transfer, ';
            OptionMembers = Purchase,"Prod. Order",Transfer," ";
        }
        field(99000904; "Ref. Order No."; Code[20])
        {
            Caption = 'Ref. Order No.';
            Editable = false;
            TableRelation = if ("Ref. Order Type" = const("Prod. Order")) "Production Order"."No." where(Status = field("Ref. Order Status"))
            else
            if ("Ref. Order Type" = const(Purchase)) "Purchase Header"."No." where("Document Type" = const(Order))
            else
            if ("Ref. Order Type" = const(Transfer)) "Transfer Header"."No." where("No." = field("Ref. Order No."));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                PurchHeader: Record "Purchase Header";
                ProdOrder: Record "Production Order";
                TransHeader: Record "Transfer Header";
            begin
            end;
        }
        field(99000905; "Ref. Order Type"; Option)
        {
            Caption = 'Ref. Order Type';
            Editable = false;
            OptionCaption = ' ,Purchase,Prod. Order,Transfer';
            OptionMembers = " ",Purchase,"Prod. Order",Transfer;
        }
        field(99000906; "Ref. Order Status"; Option)
        {
            BlankZero = true;
            Caption = 'Ref. Order Status';
            Editable = false;
            OptionCaption = ',Planned,Firm Planned,Released';
            OptionMembers = ,Planned,"Firm Planned",Released;
        }
        field(99000907; "Ref. Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Ref. Line No.';
            Editable = false;
        }
        field(99000908; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(99000909; "Expected Operation Cost Amt."; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Planning Routing Line"."Expected Operation Cost Amt." where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                                                            "Worksheet Batch Name" = field("Journal Batch Name"),
                                                                                            "Worksheet Line No." = field("Line No.")));
            Caption = 'Expected Operation Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000910; "Expected Component Cost Amt."; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Planning Component"."Cost Amount" where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                                        "Worksheet Batch Name" = field("Journal Batch Name"),
                                                                        "Worksheet Line No." = field("Line No.")));
            Caption = 'Expected Component Cost Amt.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(99000911; "Finished Qty. (Base)"; Decimal)
        {
            Caption = 'Finished Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000912; "Remaining Qty. (Base)"; Decimal)
        {
            Caption = 'Remaining Qty. (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000913; "Related to Planning Line"; Integer)
        {
            Caption = 'Related to Planning Line';
            Editable = false;
        }
        field(99000914; "Planning Level"; Integer)
        {
            Caption = 'Planning Level';
            Editable = false;
        }
        field(99000915; "Planning Line Origin"; Option)
        {
            Caption = 'Planning Line Origin';
            Editable = false;
            OptionCaption = ' ,Action Message,Planning,Order Planning';
            OptionMembers = " ","Action Message",Planning,"Order Planning";
        }
        field(99000916; "Action Message"; Option)
        {
            Caption = 'Action Message';
            OptionCaption = ' ,New,Change Qty.,Reschedule,Resched. & Chg. Qty.,Cancel';
            OptionMembers = " ",New,"Change Qty.",Reschedule,"Resched. & Chg. Qty.",Cancel;
        }
        field(99000917; "Accept Action Message"; Boolean)
        {
            Caption = 'Accept Action Message';
        }
        field(99000918; "Net Quantity (Base)"; Decimal)
        {
            Caption = 'Net Quantity (Base)';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(99000919; "Starting Date-Time"; DateTime)
        {
            Caption = 'Starting Date-Time';
        }
        field(99000920; "Ending Date-Time"; DateTime)
        {
            Caption = 'Ending Date-Time';
        }
        field(99000921; "Order Promising ID"; Code[20])
        {
            Caption = 'Order Promising ID';
        }
        field(99000922; "Order Promising Line No."; Integer)
        {
            Caption = 'Order Promising Line No.';
        }
        field(99000923; "Order Promising Line ID"; Integer)
        {
            Caption = 'Order Promising Line ID';
        }
    }

    keys
    {
        key(Key1; "Worksheet Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Worksheet Template Name", "Journal Batch Name", "Vendor No.", "Sell-to Customer No.", "Ship-to Code", "Order Address Code", "Currency Code", "Location Code", "Transfer-from Code")
        {
            MaintainSQLIndex = false;
        }
        key(Key3; Type, "No.", "Variant Code", "Location Code", "Sales Order No.", "Planning Line Origin", "Due Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Quantity (Base)";
        }
        key(Key4; Type, "No.", "Variant Code", "Location Code", "Sales Order No.", "Order Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Quantity (Base)";
        }
        key(Key5; Type, "No.", "Variant Code", "Location Code", "Starting Date")
        {
            MaintainSIFTIndex = false;
            SumIndexFields = "Quantity (Base)";
        }
        key(Key6; "Worksheet Template Name", "Journal Batch Name", Type, "No.", "Due Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key7; "Ref. Order Type", "Ref. Order Status", "Ref. Order No.", "Ref. Line No.")
        {
        }
        key(Key8; Type, "No.", "Variant Code", "Transfer-from Code", "Transfer Shipment Date")
        {
            MaintainSQLIndex = false;
        }
        key(Key9; "Order Promising ID", "Order Promising Line ID", "Order Promising Line No.")
        {
        }
        key(Key10; "User ID", "Demand Type", "Worksheet Template Name", "Journal Batch Name", "Line No.")
        {
        }
        key(Key11; "User ID", "Demand Type", "Demand Subtype", "Demand Order No.", "Demand Line No.", "Demand Ref. No.")
        {
        }
        key(Key12; "User ID", "Worksheet Template Name", "Journal Batch Name", "Line No.")
        {
            MaintainSQLIndex = false;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        Rec2: Record "Requisition Line";
    begin
    end;

    var
        Text003: label 'Change %1 from %2 to %3?';
        Text004: label 'You cannot rename a %1.';
        Text005: label '%1 %2 does not exist.';
        Text006: label 'You cannot change %1 when %2 is %3.';
        Text007: label 'There is no %1 for this line.';
        Text008: label 'There is no replenishment order for this line.';
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";
        ReqLine: Record "Requisition Line";
        TempReqLine: Record "Requisition Line";
        Item: Record Item;
        SKU: Record "Stockkeeping Unit" temporary;
        GLAcc: Record "G/L Account";
        Vend: Record Vendor;
        ItemVend: Record "Item Vendor";
        ItemTranslation: Record "Item Translation";
        Cust: Record Customer;
        ShipToAddr: Record "Ship-to Address";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ReservEntry: Record "Reservation Entry";
        ItemVariant: Record "Item Variant";
        WorkCenter: Record "Work Center";
        TransHeader: Record "Transfer Header";
        PlanningComponent: Record "Planning Component";
        PlanningRtngLine: Record "Planning Routing Line";
        ProdOrderCapNeed: Record "Prod. Order Capacity Need";
        ProdBOMHeader: Record "Production BOM Header";
        ProdBOMVersion: Record "Production BOM Version";
        RtngHeader: Record "Routing Header";
        RtngVersion: Record "Routing Version";
        MfgSetup: Record "Manufacturing Setup";
        Location: Record Location;
        Bin: Record Bin;
        PlanningElement: Record "Untracked Planning Element";
        TempPlanningErrorLog: Record "Planning Error Log" temporary;
        FA: Record "Fixed Asset";
        FALedger: Record "FA Ledger Entry";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveReqLine: Codeunit "Req. Line-Reserve";
        UOMMgt: Codeunit "Unit of Measure Management";
        AddOnIntegrMgt: Codeunit AddOnIntegrManagement;
        DimMgt: Codeunit DimensionManagement;
        LeadTimeMgt: Codeunit "Lead-Time Management";
        GetPlanningParameters: Codeunit "Planning-Get Parameters";
        VersionMgt: Codeunit VersionManagement;
        PlngLnMgt: Codeunit "Planning Line Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WMSManagement: Codeunit "WMS Management";
        BlockReservation: Boolean;
        Text028: label 'The %1 on this %2 must match the %1 on the sales order line it is associated with.';
        Subcontracting: Boolean;
        Text029: label 'Line %1 has a %2 that exceeds the %3.';
        Text030: label 'You cannot reserve components with status Planned.';
        PlanningResiliency: Boolean;
        Text031: label '%1 %2 is blocked.';
        Text032: label '%1 %2 has no %3 defined.';
        Text033: label '%1 %2 %3 is not certified.';
        Text034: label '%1 %2 %3 %4 %5 is not certified.';
        Text035: label '%1 %2 %3 specified on %4 %5 does not exist.';
        Text036: label '%1 %2 %3 does not allow default numbering.';
        Text037: label 'The currency exchange rate for the %1 %2 that vendor %3 uses on the order date %4, does not have an %5 specified.';
        Text038: label 'The currency exchange rate for the %1 %2 that vendor %3 uses on the order date %4, does not exist.';
        Text039: label 'You cannot assign new numbers from the number series %1 on %2.';
        Text040: label 'You cannot assign new numbers from the number series %1.';
        Text041: label 'You cannot assign new numbers from the number series %1 on a date before %2.';
        Text042: label 'You cannot assign new numbers from the number series %1 line %2 because the %3 is not defined.';
        Text043: label 'The number %1 on number series %2 cannot be extended to more than 20 characters.';
        Text044: label 'You cannot assign numbers greater than %1 from the number series %2.';
        Text60000: label 'You can not select this asset because it is already in use';

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
    end;

    local procedure GetCurrency()
    begin
    end;

    local procedure GetItem()
    begin
    end;


    procedure ShowReservation()
    begin
    end;


    procedure ShowReservationEntries(Modal: Boolean)
    begin
    end;


    procedure UpdateOrderReceiptDate(LeadTimeCalc: DateFormula)
    begin
    end;


    procedure LookupVendor(var Vend: Record Vendor): Boolean
    begin
    end;


    procedure LookupFromLocation(var Location: Record Location): Boolean
    begin
    end;


    procedure ItemAvailability(AvailabilityType: Option Date,Variant,Location,Bin)
    begin
    end;

    local procedure UpdateDescription()
    begin
    end;


    procedure BlockDynamicTracking(SetBlock: Boolean)
    begin
    end;


    procedure BlockDynamicTrackingOnComp(SetBlock: Boolean)
    begin
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
    end;


    procedure OpenItemTrackingLines()
    begin
    end;


    procedure DeleteRelations()
    begin
    end;


    procedure DeleteMultiLevel()
    var
        ReqLine2: Record "Requisition Line";
    begin
    end;


    procedure SetUpNewLine(LastReqLine: Record "Requisition Line")
    begin
    end;


    procedure CheckEndingDate(ShowWarning: Boolean)
    var
        CheckDateConflict: Codeunit "Reservation-Check Date Confl.";
    begin
    end;


    procedure SetDueDate()
    begin
    end;


    procedure CheckDueDateToDemandDate()
    begin
    end;


    procedure CheckActionMessageNew()
    begin
    end;


    procedure SetActionMessage()
    begin
    end;


    procedure GetProdOrderLine(ProdOrderLine: Record "Prod. Order Line")
    var
        ProdOrder: Record "Production Order";
    begin
    end;


    procedure GetPurchOrderLine(PurchOrderLine: Record "Purchase Line")
    var
        PurchHeader2: Record "Purchase Header";
    begin
    end;


    procedure GetTransLine(TransLine: Record "Transfer Line")
    begin
    end;


    procedure GetActionMessages()
    var
        GetActionMsgReport: Report "Get Action Messages";
    begin
    end;


    procedure TransferFromProdOrderLine(var ProdOrderLine: Record "Prod. Order Line")
    var
        ProdOrder: Record "Production Order";
    begin
    end;


    procedure TransferFromPurchaseLine(var PurchLine: Record "Purchase Line")
    var
        PurchHeader: Record "Purchase Header";
    begin
    end;


    procedure TransferFromTransLine(var TransLine: Record "Transfer Line")
    begin
    end;


    procedure GetDimFromRefOrderLine(AddToExisting: Boolean)
    begin
    end;

    local procedure InsertDimension(DimensionCode: Code[20]; DimensionValueCode: Code[20])
    begin
    end;


    procedure TransferFromActionMessage(var ActionMessageEntry: Record "Action Message Entry")
    var
        ReservEntry: Record "Reservation Entry";
        EndDate: Date;
    begin
    end;


    procedure TransferToTrackingEntry(var TrkgReservEntry: Record "Reservation Entry"; PointerOnly: Boolean)
    begin
    end;


    procedure UpdateDatetime()
    begin
    end;


    procedure GetDirectCost(CalledByFieldNo: Integer)
    begin
    end;


    procedure ValidateLocationChange()
    var
        Purchasing: Record Purchasing;
        SalesOrderLine: Record "Sales Line";
    begin
    end;


    procedure RowID1(): Text[250]
    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
    end;


    procedure CalcEndingDate(LeadTime: Code[20])
    begin
    end;


    procedure CalcStartingDate(LeadTime: Code[20])
    begin
    end;

    local procedure CalcTransferShipmentDate()
    var
        DateFormula: DateFormula;
        TransferRoute: Record "Transfer Route";
    begin
    end;

    local procedure GetLocation(LocationCode: Code[10])
    begin
    end;

    local procedure GetBin(LocationCode: Code[10]; BinCode: Code[20])
    begin
    end;


    procedure SetSubcontracting(IsSubcontracting: Boolean)
    begin
    end;


    procedure TransferFromUnplannedDemand(var UnplannedDemand: Record "Unplanned Demand")
    begin
    end;


    procedure SetSupplyDates(DemandDate: Date)
    var
        LeadTimeMgt: Codeunit "Lead-Time Management";
    begin
    end;


    procedure SetSupplyQty(DemandQtyBase: Decimal; NeededQtyBase: Decimal)
    begin
    end;


    procedure SetResiliencyOn(WkshTemplName: Code[10]; JnlBatchName: Code[10]; ItemNo: Code[20])
    begin
    end;


    procedure GetResiliencyError(var PlanningErrorLog: Record "Planning Error Log"): Boolean
    begin
    end;


    procedure SetResiliencyError(TheError: Text[250]; TheTableID: Integer; TheTablePosition: Text[250])
    begin
    end;


    procedure CheckExchRate()
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
    end;


    procedure CheckNoSeries(NoSeriesCode: Code[10]; SeriesDate: Date)
    var
        NoSeries: Record "No. Series";
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
    end;

    local procedure IncrementNoText(var No: Code[20]; IncrementByNo: Decimal): Boolean
    var
        DecimalNo: Decimal;
        StartPos: Integer;
        EndPos: Integer;
        NewNo: Text[30];
    begin
    end;

    local procedure ReplaceNoText(var No: Code[20]; NewNo: Code[20]; FixedLength: Integer; StartPos: Integer; EndPos: Integer): Boolean
    var
        StartNo: Code[20];
        EndNo: Code[20];
        ZeroNo: Code[20];
        NewLength: Integer;
        OldLength: Integer;
    begin
    end;

    local procedure GetIntegerPos(No: Code[20]; var StartPos: Integer; var EndPos: Integer)
    var
        IsDigit: Boolean;
        i: Integer;
    begin
    end;
}

