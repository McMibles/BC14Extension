Table 52092344 "Purchase Req. Header"
{
    Caption = 'Purchase Req. Header';
    DataCaptionFields = "No.", Description;

    fields
    {
        field(1; "Worksheet Template Name"; Code[10])
        {
            Caption = 'Worksheet Template Name';
            NotBlank = true;
            TableRelation = "Req. Wksh. Template";
        }
        field(2; "No."; Code[20])
        {
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(21; "Template Type"; Option)
        {
            CalcFormula = lookup("Req. Wksh. Template".Type where(Name = field("Worksheet Template Name")));
            Caption = 'Template Type';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Req.,For. Labor,Planning';
            OptionMembers = "Req.","For. Labor",Planning;
        }
        field(22; Recurring; Boolean)
        {
            CalcFormula = lookup("Req. Wksh. Template".Recurring where(Name = field("Worksheet Template Name")));
            Caption = 'Recurring';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1000; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(1001; "Order Creation Date"; Date)
        {
            Editable = false;
        }
        field(1002; "Order Approved Date"; Date)
        {
            Editable = false;
        }
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
            OptionCaption = ' ,Account (G/L),Item,Fixed Asset,Charge (Item)';
            OptionMembers = " ","Account (G/L)",Item,"Fixed Asset","Charge (Item)";
        }
        field(52092338; "Purchase Req. Code"; Code[10])
        {
            TableRelation = "Purchase Req. Type";

            trigger OnValidate()
            begin
                if "Purchase Req. Code" <> xRec."Purchase Req. Code" then begin
                    TestField(Status, Status::Open);
                    if PRNLinesExist then begin
                        if Confirm(Text60003 + Text60004, false) then begin
                            ReqLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
                            ReqLine.SetRange("Journal Batch Name", "No.");
                            if ReqLine.FindSet then
                                ReqLine.DeleteAll(true);
                        end;
                    end;
                end;
            end;
        }
        field(52092339; "Expected Quote Return Date"; Date)
        {
        }
        field(52092340; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Cancelled,LPO Raised';
            OptionMembers = Open,Approved,"Pending Approval",Cancelled,"LPO Raised";

            trigger OnValidate()
            begin
                if "Worksheet Template Name" = 'BIDEVA' then begin
                    if (Status = Status::Approved) then begin
                        PurchHeader.Reset;
                        PurchHeader.SetRange(PurchHeader."Document Type", PurchHeader."document type"::Order);
                        PurchHeader.SetRange(PurchHeader."RFQ No.", "RFQ No.");
                        if PurchHeader.Find('-') then
                            Error(Text60005);

                        PurchHeader.Reset;
                        PurchHeader.SetRange(PurchHeader."Document Type", 0);
                        PurchHeader.SetRange(PurchHeader."RFQ No.", "RFQ No.");
                        PurchHeader.ModifyAll(PurchHeader.Status, PurchHeader.Status::Open);

                        /*PurchLine.SetCurrentkey("RFQ No.", "PRN No.", "Line No.", "Line Amount (LCY)", "Document No.", Selected);
                        PurchLine.Ascending(true);
                        PurchLine.SetRange(PurchLine."Document Type", 0);
                        PurchLine.SetRange(PurchLine."RFQ No.", "RFQ No.");
                        PurchLine.SetRange(PurchLine.Selected, true);
                        if PurchLine.Find('-') then begin
                            repeat
                                PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
                                PurchHeader.Status := PurchHeader.Status::Released;
                                PurchHeader.Modify;
                            until PurchLine.Next = 0
                        end else
                            Error(Text60006);*/
                    end else begin
                        PurchHeader.SetRange(PurchHeader."Document Type", 0);
                        PurchHeader.SetRange(PurchHeader."RFQ No.", "RFQ No.");
                        PurchHeader.ModifyAll(PurchHeader.Status, PurchHeader.Status::Open);
                    end;
                end;

                if ("Worksheet Template Name" = 'P-REQ') and (Status = Status::Approved) then
                    "PRN Approved Date" := Today
                else
                    "PRN Approved Date" := 0D;//If Re-opened
            end;
        }
        field(52092341; "Originated By"; Code[20])
        {
        }
        field(52092342; "User ID"; Code[50])
        {
        }
        field(52092343; "Creation Date"; Date)
        {
        }
        field(52092344; "Date Last Updated"; Date)
        {
        }
        field(52092345; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ReqLine.SetRange(ReqLine."Worksheet Template Name", "Worksheet Template Name");
                ReqLine.SetRange(ReqLine."Journal Batch Name", "No.");
                if ReqLine.FindSet then begin
                    ReqLine.Validate(ReqLine."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    ReqLine.Modify;
                end;
            end;
        }
        field(52092346; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ReqLine.SetRange(ReqLine."Worksheet Template Name", "Worksheet Template Name");
                ReqLine.SetRange(ReqLine."Journal Batch Name", "No.");
                if ReqLine.FindSet then begin
                    ReqLine.Validate(ReqLine."Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    ReqLine.Modify;
                end;
            end;
        }
        field(52092347; "Expected Receipt Date"; Date)
        {
            Caption = 'Need by Date';
        }
        field(52092348; "Due Date"; Date)
        {
        }
        field(52092349; "Shipment Method Code"; Code[10])
        {
            TableRelation = "Shipment Method";
        }
        field(52092350; "Entry Point"; Code[10])
        {
            TableRelation = "Entry/Exit Point";
        }
        field(52092351; "PRN No."; Code[20])
        {
        }
        field(52092352; "PRN Approved Date"; Date)
        {
        }
        field(52092353; "Suffix No."; Code[20])
        {
        }
        field(52092354; "No. of Line"; Integer)
        {
            CalcFormula = count("Requisition Line" where("Worksheet Template Name" = field("Worksheet Template Name"),
                                                          "Journal Batch Name" = field("No."),
                                                          "No." = filter(<> ''),
                                                          Type = filter(<> " "),
                                                          Quantity = filter(<> 0)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(52092355; "Manual PRN No."; Code[20])
        {
        }
        field(52092356; "Requested By"; Code[20])
        {
        }
        field(52092357; "RFQ Created By"; Code[50])
        {
        }
        field(52092358; "RFQ No."; Code[20])
        {
        }
        field(52092359; "Responsibility Center"; Code[10])
        {
            Caption = 'Procurement Unit';
            TableRelation = "Responsibility Center";
        }
        field(52092360; "Last Updated By"; Code[50])
        {
        }
        field(52092361; "PO Status"; Option)
        {
            OptionCaption = ' ,Posted,Fully Received,Partially Received,Discontinued,Cancelled';
            OptionMembers = " ",Posted,"Fully Received","Partially Received",Discontinued,Cancelled;
        }
        field(52092362; "Evaluation Criterion"; Option)
        {
            Editable = false;
            OptionMembers = " ","Lowest Total Price","Cheapest Within","Specific Supplier","Fastest To Supply";
        }
        field(52092363; "Purchaser Code"; Code[10])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(52092364; "Job No."; Code[20])
        {
            TableRelation = Job;
        }
        field(52092365; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(52092366; "Order Type"; Option)
        {
            OptionCaption = 'Invt PO,Service PO';
            OptionMembers = "Invt PO","Service PO";
        }
        field(52092372; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(52092373; "Currency Factor"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Worksheet Template Name", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ReqLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", "No.");
        ReqLine.DeleteAll(true);

        PlanningErrorLog.SetRange("Worksheet Template Name", "Worksheet Template Name");
        PlanningErrorLog.SetRange("Journal Batch Name", "No.");
        PlanningErrorLog.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if "Worksheet Template Name" = 'P-REQ' then begin
            PurchaseReqList.Editable := false;
            PurchaseReqList.LookupMode := true;
            if PurchaseReqList.RunModal = Action::LookupOK then begin
                PurchaseReqList.GetRecord(PurchaseReqType);
                if PurchaseReqType.Blocked then
                    Error(Text60001, PurchaseReqType.Code);
                "Purchase Req. Code" := PurchaseReqType.Code;
            end else
                Error(Text60002);
        end;


        LockTable;
        ReqWkshTmpl.Get("Worksheet Template Name");

        //Inserted By Gems -Begin
        PurchSetup.Get;
        //Ensure that all unused docs are reused
        if "Worksheet Template Name" in ['P-REQ'] then begin
            ReqWkshName.SetRange(ReqWkshName."Worksheet Template Name", "Worksheet Template Name");
            ReqWkshName.SetRange(ReqWkshName."User ID", UserId);
            ReqWkshName.SetRange("Purchase Req. Code", "Purchase Req. Code");
            if ReqWkshName.Find('-') then
                repeat
                    ReqWkshName.CalcFields(ReqWkshName."No. of Line");
                    if ReqWkshName."No. of Line" = 0 then
                        Error(Text60000, 'Requisition', ReqWkshName.Name);
                until ReqWkshName.Next = 0;
        end;

        if "Worksheet Template Name" in ['P-REQ', 'RFQ', 'BIDEVA'] then begin
            if PurchSetup."Use Same No." then begin
                if "Suffix No." = '' then begin
                    PurchSetup.TestField(PurchSetup."Generic Nos.");
                    NoSeriesMgt.InitSeries(PurchSetup."Generic Nos.", PurchSetup."Generic Nos.",
                    0D, "Suffix No.", PurchSetup."Generic Nos.");
                end;
                TestField("Suffix No.");
                ReqWkshTmpl.TestField(ReqWkshTmpl."Prefix Code");
                "No." := ReqWkshTmpl."Prefix Code" + "Suffix No.";
            end;
        end;

        if ("Worksheet Template Name" = 'P-REQ') and ("No." = '') then begin
            PurchSetup.TestField(PurchSetup."Purch. Req. Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."Purch. Req. Nos.", PurchSetup."Purch. Req. Nos.",
            0D, "No.", PurchSetup."Purch. Req. Nos.");
        end;

        if ("Worksheet Template Name" = 'RFQ') and ("No." = '') then begin
            PurchSetup.TestField(PurchSetup."RFQ Nos.");
            NoSeriesMgt.InitSeries(PurchSetup."RFQ Nos.", PurchSetup."RFQ Nos.",
            0D, "No.", PurchSetup."RFQ Nos.");
        end;
        if ("Worksheet Template Name" = 'BIDEVA') and ("No." = '') then begin
            PurchSetup.TestField(PurchSetup."Bid Analysis No.");
            NoSeriesMgt.InitSeries(PurchSetup."Bid Analysis No.", PurchSetup."Bid Analysis No.",
            0D, "No.", PurchSetup."Bid Analysis No.");
        end;

        if "User ID" = '' then
            "User ID" := UserId;

        Validate("Creation Date", Today);
        // Insertion - End
    end;

    trigger OnModify()
    begin
        "Date Last Updated" := Today;
        TestField(Status, Status::Open);
    end;

    trigger OnRename()
    begin
        ReqLine.SetRange("Worksheet Template Name", xRec."Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", xRec."No.");
        while ReqLine.Find('-') do
            ReqLine.Rename("Worksheet Template Name", "No.", ReqLine."Line No.");

        PlanningErrorLog.SetRange("Worksheet Template Name", xRec."Worksheet Template Name");
        PlanningErrorLog.SetRange("Journal Batch Name", xRec."No.");
        while PlanningErrorLog.Find('-') do
            PlanningErrorLog.Rename("Worksheet Template Name", "No.", PlanningErrorLog."Entry No.");
    end;

    var
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqLine: Record "Requisition Line";
        PlanningErrorLog: Record "Planning Error Log";
        PurchaseReqType: Record "Purchase Req. Type";
        PurchSetup: Record "Purchases & Payables Setup";
        ReqWkshName: Record "Requisition Wksh. Name";
        PurchReqSuppCombination: Record "Purch. Doc./Supp. Combination";
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        Text60000: label 'Created %1 No. %2 not used!\New %1 No. cannot be created!';
        Text60001: label 'Purchase Requisition Type %1 is blocked!';
        Text60002: label 'Action Aborted.';
        Text60003: label 'If you change Purchase Req. Code, the existing PRN lines will be deleted and new PRN lines based on the new information in the header will be created';
        Text60004: label 'Do you want to change  Purchase Req. Code?';
        PurchReqSuppAttach: Page "Purch. Doc./Supp. Attach";
        PurchaseReqList: Page "Purchase Req. Types";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text60005: label 'Order already created';
        Text60006: label 'No quote is selected!';
        Text60007: label 'The approval process must be cancelled or completed to reopen this document.';
        Text60008: label 'Only approved quote can be re-opened.';


    procedure PRNLinesExist(): Boolean
    var
        ReqLine2: Record "Requisition Line";
    begin
        ReqLine2.Reset;
        ReqLine2.SetRange("Worksheet Template Name", "Worksheet Template Name");
        ReqLine2.SetRange("Journal Batch Name", "No.");
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

        PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.", "No.");
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

        PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.", "No.");
        if CheckApproved then
            PurchReqSuppCombination.SetRange(PurchReqSuppCombination.Confirmed, true);
        exit(PurchReqSuppCombination.Find('-'));
    end;


    procedure UpdatePRNPOStatus()
    var
        iCount: Integer;
        PurchHeader2: Record "Purchase Header";
    begin
        /*IF ("PO Status" IN [4,5]) {OR Blocked} THEN
          EXIT;
        
        PurchHeader2.SETCURRENTKEY("Document Type","No.");
        PurchHeader2.SETRANGE("Document Type",PurchHeader2."Document Type"::Order);
        PurchHeader2.SETRANGE(PurchHeader2."PRN No.","No.");
        IF NOT PurchHeader2.FIND('-') THEN
          EXIT;
        
        iCount := 0;
        
        REPEAT
          iCount := iCount + 1;
        
          IF (iCount = 1) THEN
            "PO Status" := PurchHeader2."Posted Status";
        
          IF (PurchHeader2."Posted Status" <> "PO Status") THEN BEGIN
            CASE PurchHeader2."Posted Status" OF
             1 : BEGIN                                  // posted
               IF "PO Status" = 0 THEN
                 "PO Status" := "PO Status"::"Partially Received";
               IF NOT ("PO Status" IN [2,3]) THEN
                 "PO Status" := PurchHeader2."Posted Status";
             END;
             2 : BEGIN                                  // fully received
               IF "PO Status" = 0 THEN
                 "PO Status" := "PO Status"::"Partially Received";
               IF NOT ("PO Status" IN [3]) THEN
                 "PO Status" := PurchHeader2."Posted Status";
             END;
             3: BEGIN                                   // partially received
               "PO Status" := PurchHeader2."Posted Status";
             END;
             0 : BEGIN                                  // blank
               IF ("PO Status" IN [1,2,3]) THEN
                 "PO Status" := "PO Status"::"Partially Received";
             END;
        
            END; {end case}
          END; {end if}
        
        UNTIL PurchHeader2.NEXT = 0;
        
        MODIFY;*/

    end;


    procedure CheckSelectedVendor()
    begin
        //Selected vendor must have quote
        ReqLine.SetRange("Worksheet Template Name", "Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", "No.");
    end;


    procedure ReOpenEvaluation()
    begin
        if Status = Status::Open then
            exit;


        if Status = Status::"Pending Approval" then
            Error(Text60007);

        if Status > Status::Approved then
            Error(Text60008);

        Validate(Status, Status::Open);
        Modify;
    end;
}

