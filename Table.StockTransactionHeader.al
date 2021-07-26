Table 52092350 "Stock Transaction Header"
{

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = 'SRN,STOCKRET';
            OptionMembers = SRN,STOCKRET;
        }
        field(2; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(8; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(10; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(11; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;

            trigger OnValidate()
            begin
                Job.Get("Job No.");
                Job.TestBlocked;
                "Job Description" := "Job Description";
            end;
        }
        field(12; "Job Description"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Job Task No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(14; "Location Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(15; "Requested By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(16; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(17; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(18; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Business Posting Group";
        }
        field(19; "No. Printed"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(20; "Issued By"; Code[20])
        {
            TableRelation = Employee;
        }
        field(21; "Received By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(22; "Returned By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(23; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(24; "Print Posted Documents"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Posting No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(26; "Last Posting No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6000; "Completely Shipped"; Boolean)
        {
            CalcFormula = min("Stock Transaction Line"."Completely Shipped" where("Document Type" = field("Document Type"),
                                                                                   "Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6001; "Completely Received"; Boolean)
        {
            CalcFormula = min("Stock Transaction Line"."Completely Received" where("Document Type" = field("Document Type"),
                                                                                    "Document No." = field("No.")));
            FieldClass = FlowField;
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
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        StockTranLine: Record "Stock Transaction Line";
    begin
        ApprovalMgt.DeleteApprovalEntries(RecordId);

        StockTranLine.LockTable;
        StockTranLine.SetRange("Document Type", "Document Type");
        StockTranLine.SetRange("Document No.", "No.");
        StockTranLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        //     if "No." = '' then begin
        //       InvtSetup.Get;
        //       CheckBlankDoc;
        //       case "Document Type" of
        //         "document type"::SRN :
        //           begin
        //             InvtSetup.TestField("SRN Nos.");
        //             NoSeriesMgt.InitSeries(InvtSetup."SRN Nos.",InvtSetup."SRN Nos.",0D,"No.",InvtSetup."SRN Nos.");
        //             NoSeriesMgt.SetDefaultSeries("Posting No. Series",InvtSetup."Posted SRN Nos.");
        //           end;
        //         "document type"::STOCKRET :
        //           begin
        //             InvtSetup.TestField("Stock Return Nos.");
        //             NoSeriesMgt.InitSeries(InvtSetup."Stock Return Nos.",InvtSetup."Stock Return Nos.",0D,"No.",InvtSetup."Stock Return Nos.");
        //             NoSeriesMgt.SetDefaultSeries("Posting No. Series",InvtSetup."Posted Stock Return Nos.");
        //           end;
        //       end;
        //     end;
        "User ID" := UserId;
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        "Requested By" := UserSetup."Employee No.";
        "Returned By" := UserSetup."Employee No.";
        "Document Date" := WorkDate;
        "Posting Date" := 0D;
    end;

    var
        InvtSetup: Record "Inventory Setup";
        UserSetup: Record "User Setup";
        Job: Record Job;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'New SRN number cannot be created because There is no line created for %1. Press Escape to use the number.';
        Text002: label 'You may have changed a dimension.\\Do you want to update the lines?';
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";


    procedure StockTranLineExist(): Boolean
    var
        StockTranLine: Record "Stock Transaction Line";
    begin
        StockTranLine.SetRange("Document Type", "Document Type");
        StockTranLine.SetRange("Document No.", "No.");
        exit(StockTranLine.FindFirst);
    end;


    procedure CheckBlankDoc()
    var
        StockTranHeader: Record "Stock Transaction Header";
    begin
        StockTranHeader.SetRange("Document Type", "Document Type");
        StockTranHeader.SetRange("User ID", UpperCase(UserId));
        StockTranHeader.SetRange(Status, StockTranHeader.Status::Open);
        if StockTranHeader.Find('-') then
            repeat
                if not StockTranHeader.StockTranLineExist then
                    Error(Text001, StockTranHeader."No.");
            until StockTranHeader.Next(1) = 0;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
        DimMgtHook: Codeunit "Dimension Hook";
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgtHook.GetMappedDimValue(ShortcutDimCode, "Dimension Set ID", FieldNumber, "Global Dimension 1 Code", "Global Dimension 2 Code");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if StockTranLineExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        StockTranLine: Record "Stock Transaction Line";
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text002) then
            exit;

        StockTranLine.Reset;
        StockTranLine.SetRange("Document Type", "Document Type");
        StockTranLine.SetRange("Document No.", "No.");
        StockTranLine.LockTable;
        if StockTranLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(StockTranLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if StockTranLine."Dimension Set ID" <> NewDimSetID then begin
                    StockTranLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      StockTranLine."Dimension Set ID", StockTranLine."Shortcut Dimension 1 Code", StockTranLine."Shortcut Dimension 2 Code");
                    StockTranLine.Modify;
                end;
            until StockTranLine.Next = 0;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", StrSubstNo('%1 %2', "Document Type", "No."),
            "Global Dimension 1 Code", "Global Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if StockTranLineExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;
}

