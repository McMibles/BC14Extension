Table 52092133 "Sharing Setup"
{

    fields
    {
        field(1; "Sharing Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,IC Partner';
            OptionMembers = "G/L Account","IC Partner";
        }
        field(6; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Account Type" = const("IC Partner")) "IC Partner";

            trigger OnValidate()
            begin
                if "Account No." <> '' then begin
                    case "Account Type" of
                        "account type"::"G/L Account":
                            begin
                                GLAcc.Get("Account No.");
                                GLAcc.CheckGLAcc;
                                GLAcc.TestField("Direct Posting", true);
                                CreateDim(Database::"G/L Account", "Account No.");
                            end;
                        "account type"::"IC Partner":
                            begin
                                ICPartner.Get("Account No.");
                            end;
                    end
                end;
            end;
        }
        field(7; "Share %"; Decimal)
        {
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                Modify;
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                Modify;
            end;
        }
        field(11; "Dimension Set ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Sharing Account No.", "Account Type", "Account No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        GLAcc: Record "G/L Account";
        ICPartner: Record "IC Partner";
        DimMgt: Codeunit 408;


    procedure SharingExist(GLAccount: Code[20]): Boolean
    begin
        if GLAccount = '' then
            exit(false);
        SetRange("Sharing Account No.", GLAccount);
        if FindFirst then
            exit(true);
        exit(false);
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(Rec, CurrFieldNo, TableID, No, '', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2("Dimension Set ID",
            StrSubstNo('%1', 'Sharing Setup'),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;
}

