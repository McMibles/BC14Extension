TableExtension 52000035 tableextension52000035 extends "Requisition Wksh. Name"
{
    fields
    {

        //Unsupported feature: Property Deletion (NotBlank) on "Name(Field 2)".

        field(70000; "Portal ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Mobile User ID"; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                "User ID" := "Mobile User ID";
            end;
        }
        field(70002; "Created from External Portal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Created from External Portal such as Retail';
        }
        field(52092337; Type; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = ' ,Account (G/L),Item,Fixed Asset,Charge (Item)';
            OptionMembers = " ","Account (G/L)",Item,"Fixed Asset","Charge (Item)";
        }
        field(52092338; "Purchase Req. Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Purchase Req. Type";

            trigger OnValidate()
            begin
                if "Purchase Req. Code" <> xRec."Purchase Req. Code" then begin
                    TestField(Status, Status::Open);
                    if PRNLinesExist then begin
                        if Confirm(Text60003 + Text60004, false) then begin
                            ReqLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
                            ReqLine.SetRange("Journal Batch Name", Name);
                            if ReqLine.FindSet then
                                ReqLine.DeleteAll(true);
                        end;
                    end;
                end;
                PurchaseReqType.Get("Purchase Req. Code");
                "Order Type" := PurchaseReqType."Order Type";
                Type := PurchaseReqType.Type;
                Route := PurchaseReqType.Route;
            end;
        }
        field(52092339; "Expected Quote Return Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52092340; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Cancelled,LPO Raised';
            OptionMembers = Open,Approved,"Pending Approval",Cancelled,"LPO Raised";

            trigger OnValidate()
            var
                UserSetup2: Record "User Setup";
                Employee2: Record Employee;
                GlobalSender: Text[80];
                Body: Text[200];
                Subject: Text[200];
                SMTP: Codeunit "SMTP Mail";
            begin
                PurchaseHook.OnValidatePRNStatus(Rec);
            end;
        }
        field(52092341; "Originated By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52092342; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52092343; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52092344; "Date Last Updated"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52092345; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(52092346; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(52092347; "Expected Receipt Date"; Date)
        {
            Caption = 'Need by Date';
            DataClassification = ToBeClassified;
        }
        field(52092348; "Due Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52092349; "Shipment Method Code"; Code[10])
        {
            Caption = 'Incoterms';
            DataClassification = ToBeClassified;
            TableRelation = "Shipment Method";
        }
        field(52092350; "Entry Point"; Code[10])
        {
            Caption = 'Port of Discharge';
            DataClassification = ToBeClassified;
            TableRelation = "Entry/Exit Point";
        }
        field(52092351; "PRN No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092352; "PRN Approved Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52092353; "Suffix No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092354; "No. of Line"; Integer)
        {
            CalcFormula = count("Requisition Line" where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                          "Journal Batch Name" = field(Name),
                                                          "No." = filter(<> ''),
                                                          Type = filter(<> " "),
                                                          Quantity = filter(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52092355; "Manual PRN No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092356; "Beneficiary No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Beneficiary No." <> '' then begin
                    Employee.Get("Beneficiary No.");
                    Validate("Shortcut Dimension 1 Code", Employee."Global Dimension 1 Code");
                    Validate("Shortcut Dimension 2 Code", Employee."Global Dimension 2 Code");
                end;
            end;
        }
        field(52092357; "RFQ Created By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52092358; "RFQ No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092359; "Responsibility Center"; Code[10])
        {
            Caption = 'Procurement Unit';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";
        }
        field(52092360; "Last Updated By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52092361; "PO Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Posted,Fully Received,Partially Received,Discontinued,Cancelled';
            OptionMembers = " ",Posted,"Fully Received","Partially Received",Discontinued,Cancelled;
        }
        field(52092362; "Evaluation Criterion"; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionMembers = " ","Lowest Total Price","Cheapest Within","Specific Supplier","Fastest To Supply";
        }
        field(52092363; "Purchaser Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser";
        }
        field(52092364; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;
        }
        field(52092365; "Job Task No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(52092366; "Order Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Invt PO,Service PO';
            OptionMembers = "Invt PO","Service PO";
        }
        field(52092367; "Job No. Filter"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092368; "Total Estimated Amount"; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Est. Amount (LCY)" where("Job No." = field("Job No. Filter")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52092369; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(52092370; Amount; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Est. Amount" where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                                      "Journal Batch Name" = field(Name)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52092371; "Amount ( LCY)"; Decimal)
        {
            CalcFormula = sum("Requisition Line"."Est. Amount (LCY)" where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                                            "Journal Batch Name" = field(Name)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52092372; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                GLSetup.Get;
                GLSetup.TestField("LCY Code");
                if GLSetup."LCY Code" = Currency.Code then
                    Error(Text60019, Currency.Code);

                if CurrFieldNo <> 0 then
                    TestField(Status, Status::Open);
                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        RecreateReqLines(FieldCaption("Currency Code"));
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(52092373; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092374; "Total Quantity"; Decimal)
        {
            CalcFormula = sum("Requisition Line".Quantity where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                                 "Journal Batch Name" = field(Name)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52092375; "Actual RFQ Issue Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52092376; Route; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'PO,Invoice';
            OptionMembers = PO,Invoice;
        }
    }
    keys
    {
        key(Key1; Status)
        {
        }
    }


    //Unsupported feature: Code Modification on "OnInsert".

    //trigger OnInsert()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    LOCKTABLE;
    ReqWkshTmpl.GET("Worksheet Template Name");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF "Worksheet Template Name" = 'P-REQ' THEN BEGIN
      IF "Purchase Req. Code" = '' THEN BEGIN
        ReqWkshName.SETRANGE(ReqWkshName."Worksheet Template Name","Worksheet Template Name");
        ReqWkshName.SETRANGE(ReqWkshName."User ID",USERID);
        ReqWkshName.SETRANGE("Purchase Req. Code","Purchase Req. Code");
        ReqWkshName.SETRANGE(Status,0);
        IF ReqWkshName.FIND('-') THEN
          REPEAT
            ReqWkshName.CALCFIELDS("No. of Line");
            IF ReqWkshName."No. of Line" = 0 THEN
              ERROR(Text60000,'Requisition',ReqWkshName.Name);
          UNTIL ReqWkshName.NEXT = 0;
        PurchaseReqList.EDITABLE := FALSE;
        PurchaseReqList.LOOKUPMODE := TRUE;
        IF PurchaseReqList.RUNMODAL = ACTION::LookupOK THEN BEGIN
          PurchaseReqList.GETRECORD(PurchaseReqType);
          IF PurchaseReqType.Blocked THEN
            ERROR(Text60001,PurchaseReqType.Code);
        END ELSE
          ERROR(Text60002);
       "Purchase Req. Code" := PurchaseReqType.Code;
       "Order Type" := PurchaseReqType."Order Type";
       Type := PurchaseReqType.Type;
       Route := PurchaseReqType.Route;
      END ELSE BEGIN
        PurchaseReqType.GET("Purchase Req. Code");
        "Order Type" := PurchaseReqType."Order Type";
        Type := PurchaseReqType.Type;
        Route := PurchaseReqType.Route;
      END;
    END;


    LOCKTABLE;
    ReqWkshTmpl.GET("Worksheet Template Name");

    PurchSetup.GET;
    IF "Worksheet Template Name" IN ['P-REQ','RFQ','BIDEVA'] THEN BEGIN
      IF PurchSetup."Use Same No." THEN BEGIN
        IF "Suffix No." = '' THEN BEGIN
          PurchSetup.TESTFIELD(PurchSetup."Generic Nos.");
          NoSeriesMgt.InitSeries(PurchSetup."Generic Nos.",PurchSetup."Generic Nos.",
          0D,"Suffix No.",PurchSetup."Generic Nos.");
        END;
        TESTFIELD("Suffix No.");
        ReqWkshTmpl.TESTFIELD(ReqWkshTmpl."Prefix Code");
        Name := ReqWkshTmpl."Prefix Code" + "Suffix No.";
      END;
    END;

    IF ("Worksheet Template Name" = 'P-REQ') AND (Name = '') THEN BEGIN
      PurchSetup.TESTFIELD(PurchSetup."Purch. Req. Nos.");
      NoSeriesMgt.InitSeries(PurchSetup."Purch. Req. Nos.",PurchSetup."Purch. Req. Nos.",
      0D,Name,PurchSetup."Purch. Req. Nos.");
    END;

    IF ("Worksheet Template Name" = 'RFQ') AND (Name = '') THEN BEGIN
      PurchSetup.TESTFIELD(PurchSetup."RFQ Nos.");
      NoSeriesMgt.InitSeries(PurchSetup."RFQ Nos.",PurchSetup."RFQ Nos.",
      0D,Name,PurchSetup."RFQ Nos.");
    END;
    IF ("Worksheet Template Name" = 'BIDEVA') AND (Name = '') THEN BEGIN
      PurchSetup.TESTFIELD(PurchSetup."Bid Analysis No.");
      NoSeriesMgt.InitSeries(PurchSetup."Bid Analysis No.",PurchSetup."Bid Analysis No.",
      0D,Name,PurchSetup."Bid Analysis No.");
    END;

    IF  "User ID" = '' THEN
      "User ID" := USERID;
    UserSetup.GET(USERID);
    UserSetup.TESTFIELD("Employee No.");
    "Beneficiary No." := UserSetup."Employee No.";

    "Creation Date" := TODAY;
    // Insertion - End
    */
    //end;


    //Unsupported feature: Code Insertion on "OnModify".

    //trigger OnModify()
    //begin
    /*
    "Date Last Updated" := TODAY;
    */
    //end;

    procedure PRNLinesExist(): Boolean
    begin
        ReqLine2.Reset;
        ReqLine2.SetRange("Worksheet Template Name", "Worksheet Template Name");
        ReqLine2.SetRange("Journal Batch Name", Name);
        exit(ReqLine2.FindFirst);
    end;

    procedure SupplierAttach()
    begin
        Clear(PurchReqSuppAttach);
        PurchReqSuppCombination.Reset;
        if "Worksheet Template Name" = 'P-REQ' then
            PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type", PurchReqSuppCombination."document type"::Requisition);
        if "Worksheet Template Name" = 'RFQ' then
            PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type", PurchReqSuppCombination."document type"::Quote);
        if "Worksheet Template Name" = 'BIDEVA' then
            PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type", PurchReqSuppCombination."document type"::Quote);

        PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.", Name);
        PurchReqSuppAttach.LookupMode := false;
        PurchReqSuppAttach.SetTableview(PurchReqSuppCombination);
        PurchReqSuppAttach.Run;
        Clear(PurchReqSuppAttach);
    end;

    procedure SupplierExist(CheckApproved: Boolean): Boolean
    begin
        if "Worksheet Template Name" = 'P-REQ' then
            PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type", PurchReqSuppCombination."document type"::Requisition);
        if "Worksheet Template Name" = 'RFQ' then
            PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type", PurchReqSuppCombination."document type"::Quote);
        if "Worksheet Template Name" = 'BIDEVA' then
            PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type", PurchReqSuppCombination."document type"::Quote);

        PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.", Name);
        if CheckApproved then
            PurchReqSuppCombination.SetRange(PurchReqSuppCombination.Confirmed, true);
        exit(PurchReqSuppCombination.Find('-'));
    end;

    procedure CheckLineDetail()
    var
        FA: Record "Fixed Asset";
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Job: Record Job;
        InvtSetup: Record "Inventory Setup";
    begin
        ReqLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", Name);
        ReqLine.FindFirst;

        TestField("Beneficiary No.");
        TestField("Expected Receipt Date");

        repeat
            if ReqLine.Type <> 0 then
                ReqLine.TestField("No.");
            //Inserted to check for Capex Budget
            if ReqLine."Job No." <> '' then begin
                Job.Get(ReqLine."Job No.");
                Job.TestField(Blocked, Job.Blocked::" ");
                SetRange("Job No. Filter", Job."No.");
                CalcFields("Total Estimated Amount");
            end;
            case ReqLine.Type of
                /*ReqLine.Type::"Fixed Asset":
                    begin
                        ReqLine.TestField("FA Posting Type");
                        FA.Get(ReqLine."No.");
                        FA.TestField(Blocked, false);
                        FA.TestField("FA Class Code");
                        TestField("Job No.", '');
                        if ReqLine."FA Posting Type" = ReqLine."fa posting type"::Maintenance then
                            ReqLine.TestField("Maintenance Code");
                    end;*/
                ReqLine.Type::"G/L Account":
                    begin
                        GLAcc.Get(ReqLine."No.");
                        GLAcc.CheckGLAcc;
                        if GLAcc."Job No. Mandatory" then begin
                            ReqLine.TestField("Job No.");
                            ReqLine.TestField("Job Task No.");
                        end;
                    end;
                ReqLine.Type::Item:
                    begin
                        ReqLine.TestField("Job No.", '');
                        Item.Get(ReqLine."No.");
                        Item.TestField(Blocked, false);
                        Item.TestField("Inventory Posting Group");
                        Item.TestField(Description);
                        if InvtSetup."Location Mandatory" then
                            ReqLine.TestField("Location Code");
                        TestField("Job No.", '');
                    end;
            end;
        until ReqLine.Next = 0;
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.Purchases, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and PRNLinesExist then begin
            Modify;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
        DimMgtHook: Codeunit "Dimension Hook";
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        DimMgtHook.GetMappedDimValue(ShortcutDimCode, "Dimension Set ID", FieldNumber, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if Name <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if PRNLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", StrSubstNo('%1 %2', Text60009, Name),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if PRNLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text60010) then
            exit;


        ReqLine2.Reset;
        ReqLine2.SetRange("Worksheet Template Name", "Worksheet Template Name");
        ReqLine2.SetRange("Journal Batch Name", Name);
        ReqLine2.LockTable;
        if ReqLine2.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(ReqLine2."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ReqLine2."Dimension Set ID" <> NewDimSetID then begin
                    ReqLine2."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      ReqLine2."Dimension Set ID", ReqLine2."Shortcut Dimension 1 Code", ReqLine2."Shortcut Dimension 2 Code");
                    ReqLine2.Modify;
                end;
            until ReqLine2.Next = 0;
    end;

    procedure GetEstimatedCost(): Decimal
    begin
        ReqLine2.Reset;
        ReqLine2.SetRange("Worksheet Template Name", "Worksheet Template Name");
        ReqLine2.SetRange("Journal Batch Name", Name);
        ReqLine2.CalcSums("Est. Amount (LCY)");
        exit(ReqLine2."Est. Amount (LCY)");
    end;

    procedure GetCurrency()
    begin
        CurrencyCode := "Currency Code";

        if CurrencyCode = '' then begin
            Clear(Currency);
            Currency.InitRoundingPrecision
        end else
            if CurrencyCode <> Currency.Code then begin
                Currency.Get(CurrencyCode);
                Currency.TestField("Amount Rounding Precision");
            end;
    end;

    procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
            if ("Creation Date" = 0D) then
                CurrencyDate := WorkDate
            else
                CurrencyDate := "Creation Date";

            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    procedure ConfirmUpdateCurrencyFactor()
    begin
        if HideValidationDialog then
            Confirmed := true
        else
            Confirmed := Confirm(Text60013, false);
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;

    procedure RecreateReqLines(ChangedFieldName: Text[100])
    var
        ReqLineTemp: Record "Requisition Line" temporary;
    begin
        if PRNLinesExist then begin
            if HideValidationDialog or not GuiAllowed then
                Confirmed := true
            else
                Confirmed :=
                  Confirm(
                    Text60017 +
                    Text60018, false, ChangedFieldName);
            if Confirmed then begin
                ReqLine.LockTable;
                Modify;

                ReqLine.Reset;
                ReqLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
                ReqLine.SetRange("Journal Batch Name", Name);
                if ReqLine.FindSet then begin
                    repeat
                        ReqLineTemp := ReqLine;
                        ReqLineTemp.Insert;
                    until ReqLine.Next = 0;

                    ReqLine.DeleteAll(true);

                    ReqLine.Init;
                    ReqLine."Line No." := 0;
                    ReqLineTemp.FindSet;
                    repeat
                        ReqLine := ReqLineTemp;
                        ReqLine."Currency Code2" := "Currency Code";
                        ReqLine.Validate("Est. Amount", ReqLineTemp."Est. Amount");
                        ReqLine.Insert;
                    until ReqLineTemp.Next = 0;
                end;
            end else
                Error(
                  Text60014, ChangedFieldName);
        end;
    end;

    procedure UpdateReqLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        Question: Text[250];
    begin
        if not (PRNLinesExist) then
            exit;

        if AskQuestion then begin
            Question := StrSubstNo(
              Text60015 +
              Text60016, ChangedFieldName);
            if GuiAllowed then
                if not Dialog.Confirm(Question, true) then
                    exit;
        end;

        ReqLine.LockTable;
        Modify;

        ReqLine.Reset;
        ReqLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", Name);
        if ReqLine.FindSet then
            repeat
                case ChangedFieldName of
                    FieldCaption("Currency Factor"):
                        begin
                            ReqLine.Validate("Est. Amount");
                            ReqLine.Validate("Est. Amount (LCY)");
                        end;
                end;
                ReqLine.Modify(true);
            until ReqLine.Next = 0;
    end;

    procedure CheckDim()
    var
        PurchReqLine: Record "Requisition Line";
    begin
        PurchReqLine.SetRange(PurchReqLine."Journal Batch Name", Name);
        if PurchReqLine.FindSet then
            repeat
            begin
                CheckDimComb(PurchReqLine);
                CheckDimValuePosting(PurchReqLine);
            end
            until PurchReqLine.Next = 0;
    end;

    local procedure CheckDimComb(var PurchReqLine: Record "Requisition Line")
    begin
        if PurchReqLine."Line No." <> 0 then
            if not DimMgt.CheckDimIDComb(PurchReqLine."Dimension Set ID") then
                Error(
                  Text60081,
                  'Purchase Request', Name, PurchReqLine."Line No.", DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(var PurchReqLine2: Record "Requisition Line")
    var
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        if PurchReqLine2."Line No." = 0 then begin
            exit;
        end else begin
            TableIDArr[1] := DimMgtHook.TypeToTableID3(PurchReqLine2.Type);
            NumberArr[1] := PurchReqLine2."Account No.";
            TableIDArr[2] := Database::Job;
            NumberArr[2] := PurchReqLine2."Job No.";
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, PurchReqLine2."Dimension Set ID") then
                Error(
                  Text60083,
                  'Purchase Request', Name, PurchReqLine2."Line No.", DimMgt.GetDimValuePostingErr);
        end;
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    var
        PurchaseReqType: Record "Purchase Req. Type";
        PurchSetup: Record "Purchases & Payables Setup";
        ReqWkshName: Record "Requisition Wksh. Name";
        RespCenter: Record "Responsibility Center";
        PurchReqSuppCombination: Record "Purch. Doc./Supp. Combination";
        UserSetup: Record "User Setup";
        Employee: Record Employee;
        ReqLine2: Record "Requisition Line";
        ReqLine: Record "Requisition Line";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        CurrencyCode: Code[20];
        CurrencyDate: Date;
        PurchaseReqList: Page "Purchase Req. Types";
        Text60000: label 'Created %1 No. %2 not used!\New %1 No. cannot be created!';
        Text60001: label 'Purchase Requisition Type %1 is blocked!';
        Text60002: label 'Action Aborted.';
        Text60003: label 'If you change Purchase Req. Code, the existing PRN lines will be deleted and new PRN lines based on the new information in the header will be created';
        Text60004: label 'Do you want to change  Purchase Req. Code?';
        PurchReqSuppAttach: Page "Purch. Doc./Supp. Attach";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserMgt: Codeunit "User Setup Management";
        Text60005: label 'Your identification is set up to process from %1 %2 only.';
        Text60006: label 'PRN %1 is pending for your action';
        Text60007: label 'The Selected Request Type CAPEX ID Requires Approval\\ Contact Your Financial Administrator.';
        Text60008: label 'You request may not be converted to purchase order due to the Capex %1 budget which has been exceeded.';
        DimMgt: Codeunit DimensionManagement;
        Text60009: label 'Purchase Requisition';
        Text60010: label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text60011: label 'Estimated Amount must not be zero';
        Text60013: label 'Do you want to update the exchange rate?';
        Text60014: label 'You must delete the existing PRN lines before you can change %1.';
        Text60015: label 'You have modified %1.\\';
        Text60016: label 'Do you want to update the lines?';
        Text60017: label 'If you change %1, the existing prn lines will be deleted and new prn lines based on the new information on the header will be created.\\';
        Text60018: label 'Do you want to change %1?';
        Text60019: label 'If this transaction is in your operating currency %1\\ then the currency must be blank';
        PurchaseHook: Codeunit "Purchase Hook";
        Text60080: label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text60081: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text60082: label 'The dimensions used in %1 %2 are invalid. %3';
        Text60083: label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';
        DimMgtHook: Codeunit "Dimension Hook";
}

