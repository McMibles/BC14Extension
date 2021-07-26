Table 52092288 "Payment Request Line"
{
    //DrillDownPageID = "Payment Request Lines";
    //LookupPageID = "Payment Request Lines";
    Permissions = TableData "G/L Account" = r;

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Description; Text[100])
        {
        }
        field(4; "Job No."; Code[20])
        {
            TableRelation = Job;

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Job No." <> '' then begin
                    Job.Get("Job No.");
                    //Job.TESTFIELD("Job Status",Job."Job Status"::Order);

                end;
            end;
        }
        field(5; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));

            trigger OnValidate()
            begin
                TestStatusOpen
            end;
        }
        field(6; "Consignment PO No."; Code[20])
        {
            TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Consignment PO No." <> '' then begin
                    if "Consignment Code" <> '' then begin
                        ConsignmentLine.Get("Consignment Code", "Consignment PO No.");
                        //ConsignmentLine.TestField("GIT Account");
                        if CurrFieldNo = FieldNo("Consignment PO No.") then begin
                            Validate("Account Type", "account type"::"G/L Account");
                            Validate("Account No.", ConsignmentLine."GIT Account");
                        end;
                    end;
                end else
                    Validate("Account No.", '');
            end;
        }
        field(7; "Consignment Code"; Code[20])
        {

            trigger OnValidate()
            begin
                TestStatusOpen;

                if "Consignment Code" <> '' then begin
                    Consignment.Get("Consignment Code");
                    //Consignment.TestField(Open, true);
                    if "Consignment PO No." <> '' then begin
                        ConsignmentLine.Get("Consignment Code", "Consignment PO No.");
                        //ConsignmentLine.TestField("GIT Account");
                        if CurrFieldNo = FieldNo("Consignment Code") then begin
                            Validate("Account Type", "account type"::"G/L Account");
                            Validate("Account No.", ConsignmentLine."GIT Account");
                        end;
                    end else begin
                        //Consignment.TestField("GIT Account");
                        if CurrFieldNo = FieldNo("Consignment Code") then begin
                            Validate("Account Type", "account type"::"G/L Account");
                            Validate("Account No.", Consignment."GIT Account");
                        end;
                    end;
                end else begin
                    "Consignment Charge Code" := '';
                    "Consignment PO No." := '';
                end;
            end;
        }
        field(8; "Consignment Charge Code"; Code[20])
        {

            trigger OnValidate()
            begin
                TestStatusOpen;

                if "Consignment Charge Code" <> '' then
                    TestField("Consignment Code");
            end;
        }
        field(9; "Maintenance Code"; Code[20])
        {

            trigger OnValidate()
            begin
                TestStatusOpen;
                if "Maintenance Code" <> '' then
                    TestField("Account Type", "account type"::"Fixed Asset");
            end;
        }
        field(10; "Document Type"; Option)
        {
            OptionCaption = 'Cash Account,Float Account';
            OptionMembers = "Cash Account","Float Account";
        }
        field(11; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(12; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                TestStatusOpen;
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                TestStatusOpen;
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(14; "Dimension Set ID"; Integer)
        {

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(15; "Request Code"; Code[20])
        {
            TableRelation = "Payment Request Code";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Request Code" <> xRec."Request Code") and ("Request Code" <> '') then begin
                    PaymentReqCode.Get("Request Code");
                    Validate("Account Type", PaymentReqCode."Account Type");
                    Validate("Account No.", PaymentReqCode."Account No.");
                end;
                if "Request Code" = '' then
                    "Account No." := '';
            end;
        }
        field(16; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(17; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"."No."
            else
            if ("Account Type" = const(Customer)) Customer
            else
            if ("Account Type" = const(Vendor)) Vendor
            else
            if ("Account Type" = const("Bank Account")) "Bank Account"
            else
            if ("Account Type" = const("Fixed Asset")) "Fixed Asset"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                if "Account No." <> '' then begin
                    case "Account Type" of
                        "account type"::"G/L Account":
                            begin
                                GLAccount.Get("Account No.");
                                GLAccount.TestField(Blocked, false);
                                "Account Name" := GLAccount.Name;
                            end;
                        "account type"::Customer:
                            begin
                                Customer.Get("Account No.");
                                "Account Name" := Customer.Name;
                            end;
                        "account type"::Vendor:
                            begin
                                Vendor.Get("Account No.");
                                "Account Name" := Vendor.Name;
                            end;
                        "account type"::"Fixed Asset":
                            begin
                                FA.Get("Account No.");
                                FA.TestField(FA.Blocked, false);
                                "Account Name" := FA.Description;
                            end;
                        "account type"::"Bank Account":
                            begin
                                Bank.Get("Account No.");
                                Bank.TestField(Blocked, false);
                                "Account Name" := Bank.Name;
                            end;
                    end
                end else
                    "Account Name" := ''
            end;
        }
        field(18; "Account Name"; Text[100])
        {
            Editable = false;
        }
        field(19; "FA Posting Type"; Option)
        {
            OptionCaption = ' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance';
            OptionMembers = " ","Acquisition Cost",,,,,,,Maintenance;
        }
        field(100; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if ("Float Amount" <> 0) and (Amount > "Float Amount") then
                    Error(Text002);

                Validate("Amount (LCY)");
            end;
        }
        field(101; "Amount (LCY)"; Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                GetRequestHeader;
                PaymentReqHeader.TestField("Document Date");
                if PaymentReqHeader."Currency Code" <> '' then begin
                    PaymentReqHeader.TestField("Currency Factor");
                    "Amount (LCY)" :=
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        PaymentReqHeader."Document Date", PaymentReqHeader."Currency Code",
                        Amount, PaymentReqHeader."Currency Factor");
                end else
                    "Amount (LCY)" := Amount;
            end;
        }
        field(5000; "Float Amount"; Decimal)
        {
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

    trigger OnDelete()
    begin
        TestStatusOpen;

        PmtCommentLine.SetRange("Table Name", PmtCommentLine."table name"::"Payment Request");
        PmtCommentLine.SetRange("No.", "Document No.");
        PmtCommentLine.SetRange("Table Line No.", "Line No.");
        if not PmtCommentLine.IsEmpty then
            PmtCommentLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
        GetRequestHeader;
        if PaymentReqHeader."Request Type" = 0 then
            Error(Text001);

        Validate("Shortcut Dimension 1 Code", PaymentReqHeader."Shortcut Dimension 1 Code");
        Validate("Shortcut Dimension 2 Code", PaymentReqHeader."Shortcut Dimension 2 Code");
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
    end;

    var
        PaymentReqHeader: Record "Payment Request Header";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Job: Record Job;
        PmtCommentLine: Record "Payment Comment Line";
        PaymentReqCode: Record "Payment Request Code";
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        FA: Record "Fixed Asset";
        Bank: Record "Bank Account";
        Consignment: Record "Consignment Header";
        ConsignmentLine: Record "Consignment Line";
        StatusCheckSuspended: Boolean;
        DimMgt: Codeunit DimensionManagement;
        Text001: label 'Payment request type must be specified.';
        Text002: label 'Amount to retire must not be greater than amount spent';


    procedure GetRequestHeader()
    begin
        TestField("Document No.");
        if ("Document No." <> PaymentReqHeader."No.") then begin
            PaymentReqHeader.Get("Document Type", "Document No.");
            if PaymentReqHeader."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                PaymentReqHeader.TestField("Currency Factor");
                Currency.Get(PaymentReqHeader."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
        end;
    end;


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetRequestHeader;
        PaymentReqHeader.TestField(Status, PaymentReqHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', 'Payment Request Line', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
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
        GetRequestHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, '',
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code",
            PaymentReqHeader."Dimension Set ID", Database::Employee);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
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


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;
}

