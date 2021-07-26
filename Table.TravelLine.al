Table 52092237 "Travel Line"
{

    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "From Destination"; Text[30])
        {
        }
        field(4; "To Destination"; Text[30])
        {
        }
        field(5; "Travel Group"; Code[10])
        {
            TableRelation = "Travel Group";

            trigger OnValidate()
            begin
                GetTravelHeader;
                TravelHeader.TestField("Departure Date");
                TravelHeader.TestField("Return Date");
                if ("Travel Group" <> xRec."Travel Group") and (xRec."Travel Group" <> '') then
                    RecreateTravelCost(FieldCaption("Travel Group"));
            end;
        }
        field(6; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                TestField("No. of Nights", 0);
                if "Start Date" <> 0D then
                    CheckDates(FieldCaption("Start Date"));
            end;
        }
        field(7; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                HumanResSetup.Get;
                TestField("No. of Nights", 0);
                if "End Date" <> 0D then begin
                    CheckDates(FieldCaption("End Date"));
                    Validate("No. of Nights Calc.", ("End Date" - "Start Date") + HumanResSetup."Travel Tolerance Day(s)");
                end;
            end;
        }
        field(8; "No. of Nights Calc."; Decimal)
        {
            Editable = false;
        }
        field(9; "Total Cost"; Decimal)
        {
            Editable = false;
        }
        field(11; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(12; "Total Cost (LCY)"; Decimal)
        {
            CalcFormula = sum("Travel Cost"."Amount (LCY)" where("Document No." = field("Document No."),
                                                                  "Line No." = field("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Accommodation Provided"; Boolean)
        {

            trigger OnValidate()
            begin
                if ("Accommodation Provided" <> xRec."Accommodation Provided") then
                    RecreateTravelCost(FieldCaption("Accommodation Provided"));
            end;
        }
        field(14; "No. of Nights"; Decimal)
        {

            trigger OnValidate()
            begin
                if "No. of Nights" <> 0 then begin
                    TestField("Start Date");
                    TestField("End Date");
                end;
                if "No. of Nights" > "No. of Nights Calc." then
                    Error(Text022, "No. of Nights Calc.");

                if ("No. of Nights" <> xRec."No. of Nights") and (xRec."No. of Nights" <> 0) then
                    RecreateTravelCost(FieldCaption("No. of Nights"));
            end;
        }
        field(15; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(17; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            TableRelation = Job;

            trigger OnValidate()
            begin
                if ("Total Cost (LCY)" = xRec."Total Cost (LCY)") then
                    exit;

                if "Job No." <> '' then begin
                    Job.Get("Job No.");
                    //Job.TESTFIELD("Job Status",Job."Job Status"::Order);
                    //"Capex Code" := Job."Capex Code";
                end;
            end;
        }
        field(18; "Job Task No."; Code[20])
        {
            TableRelation = "Job Task"."Job Task No." where("Job No." = field("Job No."));
        }
        field(20; "Dimension Set ID"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
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
        DeleteCostLines;
    end;

    trigger OnInsert()
    begin
        GetTravelHeader;
        if not EmpCategory.Get(TravelHeader."Employee Category") then
            Error(Text023, TravelHeader."Employee Category");

        TestStatusOpen;
        CheckDates('');

        if "Global Dimension 1 Code" = '' then
            "Global Dimension 1 Code" := TravelHeader."Global Dimension 1 Code";

        if "Global Dimension 2 Code" = '' then
            "Global Dimension 2 Code" := TravelHeader."Global Dimension 2 Code";
    end;

    trigger OnModify()
    begin
        TestStatusOpen;
    end;

    trigger OnRename()
    begin
        TestStatusOpen;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        TravelHeader: Record "Travel Header";
        TravelEmpCatSetup: Record "Employee Travel Setup";
        TravelLine: Record "Travel Line";
        Job: Record Job;
        EmpCategory: Record "Employee Category";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        StatusCheckSuspended: Boolean;
        NoSeriesMgt: Codeunit 396;
        Text001: label 'Travel Type must be specified on the header';
        Text002: label 'Staff Category must be specified on the header';
        Text003: label 'No. of Nights must be specified.';
        Text004: label 'Creating travel cost';
        Text005: label '%1 %2 must not be before the departure date %3';
        Text006: label '%1 %2 must not be after the arrival date %3';
        Text007: label 'There is a travel Line that has a start date later than this!\ Entry not allowed.';
        Text008: label 'There is a travel line that has end date later than this!\ Entry not allowed.';
        Text009: label 'The end date of this line will be greater than the start date of some lines. Adjust the lines appropriately';
        Text018: label 'You must delete the existing travel cost before you can change %1.';
        Text019: label 'If you change %1, the existing travel cost will be deleted and new travel cost based on the new information on the header will be created.\\';
        Text020: label 'Do you want to change %1?';
        BudgetControlMgt: Codeunit "Budget Control Management";
        DimMgt: Codeunit 408;
        Window: Dialog;
        Text022: label 'No. of Nights cannot be more %1';
        Text023: label 'Staff Category %1 does not exist. Please contact your system Administrator for assistance.';


    procedure GetTravelHeader()
    begin
        TravelHeader.Get("Document No.");
    end;


    procedure CreateCostLines(ShowWindow: Boolean)
    var
        TravelCost: Record "Travel Cost";
        TravelCostGrp: Record "Travel Cost Group";
        IncludeCost: Boolean;
    begin
        if ShowWindow then
            Window.Open(Text004);

        GetTravelHeader;
        if TravelHeader."Travel Type" = 0 then
            Error(Text001);
        if TravelHeader."Employee Category" = '' then
            Error(Text002);
        if "No. of Nights" = 0 then
            Error(Text003);
        TravelEmpCatSetup.SetRange("Employee Catgory", TravelHeader."Employee Category");
        TravelEmpCatSetup.SetRange("Travel Type", TravelHeader."Travel Type");
        TravelEmpCatSetup.SetRange("Travel Group", "Travel Group");
        if TravelEmpCatSetup.FindSet then begin
            repeat
                IncludeCost := true;
                TravelEmpCatSetup.TestField("Travel Cost Code");
                TravelCostGrp.Get(TravelEmpCatSetup."Travel Cost Code");
                if TravelCostGrp.Accommodation then
                    IncludeCost := not ("Accommodation Provided");
                TravelCost.Init;
                TravelCost."Document No." := "Document No.";
                TravelCost."Line No." := "Line No.";
                TravelCost."No. of Nights" := "No. of Nights";
                TravelEmpCatSetup.TestField("Travel Cost Code");
                TravelCost.Validate("Cost Code", TravelEmpCatSetup."Travel Cost Code");
                if not (TravelCost.Insert) then
                    TravelCost.Modify;
            until TravelEmpCatSetup.Next = 0;
        end;

        if ShowWindow then
            Window.Close;
    end;


    procedure DeleteCostLines()
    var
        TravelCost: Record "Travel Cost";
    begin
        TravelCost.SetRange("Document No.", "Document No.");
        TravelCost.SetRange("Line No.", "Line No.");
        TravelCost.DeleteAll;
    end;


    procedure UpdateCostLines()
    var
        TravelCost: Record "Travel Cost";
    begin
        TravelCost.SetRange("Document No.", "Document No.");
        TravelCost.SetRange("Line No.", "Line No.");
        if TravelCost.FindSet then begin
        end;
    end;


    procedure TravelCostExist(): Boolean
    var
        TravelCost: Record "Travel Cost";
    begin
        Clear(TravelCost);
        TravelCost.SetRange("Document No.", "Document No.");
        TravelCost.SetRange("Line No.", "Line No.");
        exit(TravelCost.FindFirst);
    end;


    procedure RecreateTravelCost(ChangedFieldName: Text[100])
    var
        TravelCostTemp: Record "Travel Cost" temporary;
        TravelCost: Record "Travel Cost";
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
        if TravelCostExist then begin
            if HideValidationDialog or not GuiAllowed then
                Confirmed := true
            else
                Confirmed :=
                  Confirm(
                    Text019 +
                    Text020, false, ChangedFieldName);
            if Confirmed then begin
                TravelCost.LockTable;
                xRecRef.GetTable(xRec);
                Modify;
                RecRef.GetTable(Rec);
                TravelCost.Reset;
                TravelCost.SetRange("Document No.", "Document No.");
                TravelCost.SetRange("Line No.", "Line No.");
                TravelCost.SetFilter("Cost Code", '<>%1', '');
                if TravelCost.FindSet then begin
                    repeat
                        TravelCostTemp := TravelCost;
                        TravelCostTemp.Insert;
                    until TravelCost.Next = 0;

                    TravelCost.DeleteAll(true);

                    TravelCost.Reset;
                    TravelCost.Init;
                    TravelCost."Line No." := 0;
                    TravelCostTemp.FindSet;
                    repeat
                        TravelCost := TravelCostTemp;
                        TravelCost.Validate("Cost Code", TravelCostTemp."Cost Code");
                        TravelCost.Insert;
                    until TravelCostTemp.Next = 0;
                end;
            end else
                Error(
                  Text018, ChangedFieldName);
        end;
    end;


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
            exit;
        GetTravelHeader;
        TravelHeader.TestField(Status, TravelHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(var Suspend: Boolean): Boolean
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure CheckDates(CheckFieldName: Text[100])
    begin
        GetTravelHeader;
        case CheckFieldName of
            FieldCaption("Start Date"):
                begin
                    if "Start Date" = 0D then
                        exit;
                    if ("Start Date" < TravelHeader."Departure Date") and (TravelHeader."Departure Date" <> 0D) then
                        Error(Text005, FieldCaption("Start Date"), "Start Date", TravelHeader."Departure Date");
                    if ("Start Date" > TravelHeader."Return Date") and (TravelHeader."Return Date" <> 0D) then
                        Error(Text006, FieldCaption("Start Date"), "Start Date", TravelHeader."Return Date");

                    // Checks proper order of start and end dates
                    TravelLine.Reset;
                    TravelLine.SetCurrentkey("Document No.", "Line No.");
                    TravelLine.SetRange("Document No.", "Document No.");
                    TravelLine.SetFilter("Line No.", '<>%1', "Line No.");
                    TravelLine.SetFilter("Start Date", '>%1', "Start Date");
                    if TravelLine.FindSet then
                        Error(Text007);


                    TravelLine.SetRange("Start Date");
                    TravelLine.SetFilter("End Date", '<%1&<>%2', "Start Date", 0D);
                    if TravelLine.FindSet then
                        Error(Text008);
                end;
            FieldCaption("End Date"):
                begin
                    TestField("Start Date");
                    if "End Date" = 0D then
                        exit;
                    if ("End Date" < TravelHeader."Departure Date") and (TravelHeader."Departure Date" <> 0D) then
                        Error(Text005, FieldCaption("End Date"), "End Date", TravelHeader."Departure Date");
                    if ("End Date" > TravelHeader."Return Date") and (TravelHeader."Return Date" <> 0D) then
                        Error(Text006, FieldCaption("End Date"), "End Date", TravelHeader."Return Date");

                    if "Line No." <> 0 then begin
                        TravelLine.Reset;
                        TravelLine.SetCurrentkey("Document No.", "Line No.");
                        TravelLine.SetRange("Document No.", "Document No.");
                        TravelLine.SetFilter("Line No.", '<>%1', "Line No.");
                        TravelLine.SetFilter("Start Date", '<%1', "End Date");
                        TravelLine.SetFilter("End Date", '>%1', "End Date");
                        if TravelLine.FindSet then
                            Error(Text009);
                    end;
                end;
            '':
                begin
                    if "End Date" <> 0D then begin
                        if ("End Date" < TravelHeader."Departure Date") and (TravelHeader."Departure Date" <> 0D) then
                            Error(Text005, FieldCaption("End Date"), "End Date", TravelHeader."Departure Date");
                        if ("End Date" > TravelHeader."Return Date") and (TravelHeader."Return Date" <> 0D) then
                            Error(Text006, FieldCaption("End Date"), "End Date", TravelHeader."Return Date");
                        if "Line No." <> 0 then begin
                            TravelLine.Reset;
                            TravelLine.SetCurrentkey("Document No.", "Line No.");
                            TravelLine.SetRange("Document No.", "Document No.");
                            TravelLine.SetFilter("Line No.", '<>%1', "Line No.");
                            TravelLine.SetFilter("Start Date", '<%1', "End Date");
                            TravelLine.SetFilter("End Date", '>%1', "End Date");
                            if TravelLine.FindSet then
                                Error(Text009);
                        end;
                    end;
                    if "Start Date" <> 0D then begin
                        // Checks proper order of start and end dates
                        TravelLine.Reset;
                        TravelLine.SetCurrentkey("Document No.", "Line No.");
                        TravelLine.SetRange("Document No.", "Document No.");
                        TravelLine.SetFilter("Line No.", '<>%1', "Line No.");
                        TravelLine.SetFilter("Start Date", '>%1', "Start Date");
                        if TravelLine.FindSet then
                            Error(Text007);

                        if ("Start Date" < TravelHeader."Departure Date") and (TravelHeader."Departure Date" <> 0D) then
                            Error(Text005, FieldCaption("Start Date"), "Start Date", TravelHeader."Departure Date");
                        if ("Start Date" > TravelHeader."Return Date") and (TravelHeader."Return Date" <> 0D) then
                            Error(Text006, FieldCaption("Start Date"), "Start Date", TravelHeader."Return Date");
                    end;
                end;
        end;
    end;


    procedure DeleteCommitment()
    var
        TravelCost: Record "Travel Cost";
    begin
        with TravelCost do begin
            SetRange("Document No.", Rec."Document No.");
            SetRange("Line No.", Rec."Line No.");
            SetFilter("Account Code", '<>%1', '');
            if Find('-') then
                repeat
                    BudgetControlMgt.DeleteCommitment(TravelCost."Document No.", TravelCost."Line No.", "Account Code");
                until Next = 0;
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        ChangeLogMgt: Codeunit "Change Log Management";
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', 'Travel Line', "Document No.", "Line No."));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
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


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        GetTravelHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID, No, '',
            "Global Dimension 1 Code", "Global Dimension 2 Code",
            TravelHeader."Dimension Set ID", Database::Employee);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Global Dimension 1 Code", "Global Dimension 2 Code");
    end;
}

