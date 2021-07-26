Codeunit 52092139 "Dimension Hook"
{

    trigger OnRun()
    begin
    end;

    var
        HasGotGLSetup: Boolean;
        GLSetupShortcutDimCode: array[8] of Code[20];
        DimMgt: Codeunit DimensionManagement;
        Text007: label 'Select %1 %2 for the %3 %4 for %5 %6.';

    local procedure GetGLSetup()
    var
        GLSetup: Record "General Ledger Setup";
    begin
        if not HasGotGLSetup then begin
            GLSetup.Get;
            GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
            GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
            GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
            GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
            GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
            GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
            GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
            GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
            HasGotGLSetup := true;
        end;
    end;


    procedure ReturnMainDimValue(var FieldNumber: Integer; var ShortcutDimCode: Code[20]): Boolean
    var
        DimValue: Record "Dimension Value";
        Dim: Record Dimension;
        i: Integer;
    begin
        /*GetGLSetup;
        
        IF NOT DimValue.GET(GLSetupShortcutDimCode[FieldNumber],ShortcutDimCode) THEN
          EXIT (FALSE);
        
        //IF (DimValue."Main Dim. Value Code" = '') THEN
          //EXIT (FALSE);
        
        IF NOT Dim.GET(GLSetupShortcutDimCode[FieldNumber]) THEN
          EXIT (FALSE);
        
        //IF Dim."Main Dimension Code" = '' THEN
          //EXIT(FALSE);
        
        FOR i := 1 TO 8 DO
          IF GLSetupShortcutDimCode[i] = Dim."Main Dimension Code" THEN BEGIN
            ShortcutDimCode := DimValue."Main Dim. Value Code";
            FieldNumber := i;
          END;
        EXIT (TRUE);*/

    end;


    procedure GetMappedDimValue(ShortcutDimCode: Code[20]; var DimensionSetID: Integer; var FieldNumber: Integer; var ShortcutDimCode1: Code[20]; var ShortcutDimCode2: Code[20])
    var
        TempShortcutDimCode: Code[20];
        MainExist: Boolean;
    begin
        TempShortcutDimCode := ShortcutDimCode;
        repeat
            DimMgt.ValidateShortcutDimValues(FieldNumber, TempShortcutDimCode, DimensionSetID);
            MainExist := ReturnMainDimValue(FieldNumber, TempShortcutDimCode);

            if (FieldNumber = 1) and (ShortcutDimCode1 <> TempShortcutDimCode) then
                ShortcutDimCode1 := TempShortcutDimCode;
            if (FieldNumber = 2) and (ShortcutDimCode2 <> TempShortcutDimCode) then
                ShortcutDimCode2 := TempShortcutDimCode;
        until not MainExist;
    end;


    procedure GetMappedDefaultDimValue(TableId: Integer; DefNo: Code[20]; ShortcutDimCode: Code[20]; FieldNumber: Integer; var ShortcutDimCode1: Code[20]; var ShortcutDimCode2: Code[20])
    var
        TempShortcutDimCode: Code[20];
        MainExist: Boolean;
    begin
        TempShortcutDimCode := ShortcutDimCode;
        repeat
            DimMgt.ValidateDimValueCode(FieldNumber, TempShortcutDimCode);
            MainExist := ReturnMainDimValue(FieldNumber, TempShortcutDimCode);

            if (FieldNumber = 1) and (ShortcutDimCode1 <> TempShortcutDimCode) then
                ShortcutDimCode1 := TempShortcutDimCode;
            if (FieldNumber = 2) and (ShortcutDimCode2 <> TempShortcutDimCode) then
                ShortcutDimCode2 := TempShortcutDimCode;
            DimMgt.SaveDefaultDim(TableId, DefNo, FieldNumber, TempShortcutDimCode);
        until not MainExist;
    end;


    procedure GetDefaultDimValueName(TableID: Integer; No: Code[20]; DimCode: Code[20]): Text
    var
        DefaultDimValue: Record "Default Dimension";
        DimValue: Record "Dimension Value";
    begin
        if DefaultDimValue.Get(TableID, No, DimCode) then begin
            DimValue.Get(DimCode, DefaultDimValue."Dimension Value Code");
            exit(DimValue.Name);
        end else
            exit('');
    end;


    procedure CheckDimValueMultiplePosting(var DefaultDim: Record "Default Dimension"; var DimSetEntry: Record "Dimension Set Entry"; var DimValuePostingErr: Text[250]): Boolean
    var
        ObjTransl: Record "Object Translation";
        DefaultDimMultiple: Record "Default Dim Value  Multiple";
        DimValueExist: Boolean;
    begin
        DimValueExist := false;
        case DefaultDim."Value Posting" of
            DefaultDim."value posting"::"Same Code":
                begin
                    if DimSetEntry.FindFirst then begin
                        DimValueExist := DefaultDimMultiple.Get(DefaultDim."Table ID", DefaultDim."No.", DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code");
                        if (DimValueExist = false)
                        then begin
                            DimValuePostingErr :=
                              StrSubstNo(
                                Text007,
                                DefaultDim.FieldCaption("Dimension Value Code"),
                                DefaultDim."Dimension Value Code",
                                DefaultDim.FieldCaption("Dimension Code"),
                                DefaultDim."Dimension Code",
                                ObjTransl.TranslateObject(ObjTransl."object type"::Table, DefaultDim."Table ID"),
                                DefaultDim."No.");
                            exit(false);
                        end;
                    end else begin
                        DimValuePostingErr :=
                          StrSubstNo(
                            Text007,
                            DefaultDim.FieldCaption("Dimension Value Code"),
                            DefaultDim."Dimension Value Code",
                            DefaultDim.FieldCaption("Dimension Code"),
                            DefaultDim."Dimension Code",
                            ObjTransl.TranslateObject(ObjTransl."object type"::Table, DefaultDim."Table ID"),
                            DefaultDim."No.");
                        exit(false);
                    end;
                end;
        end;
        exit(true);
    end;


    procedure ReturnDimName(GlobalDimNo: Integer; DimValueCode: Code[10]): Text[50]
    var
        DimValue: Record "Dimension Value";
    begin
        DimValue.SetRange(DimValue."Global Dimension No.", GlobalDimNo);
        DimValue.SetRange(DimValue.Code, DimValueCode);
        if DimValue.Find('-') then
            exit(DimValue.Name)
        else
            exit('');
    end;


    procedure TypeToTableID3(Type: Option " ","G/L Account",Item,"Fixed Asset","Charge (Item)"): Integer
    begin
        case Type of
            Type::" ":
                exit(0);
            Type::"G/L Account":
                exit(Database::"G/L Account");
            Type::Item:
                exit(Database::Item);
            Type::"Fixed Asset":
                exit(Database::"Fixed Asset");
            Type::"Charge (Item)":
                exit(Database::"Item Charge");
        end;
    end;
}

