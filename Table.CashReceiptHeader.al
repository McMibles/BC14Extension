Table 52092299 "Cash Receipt Header"
{
    Permissions = TableData "Posted Payment Header" = rimd,
                  TableData "Posted Payment Line" = rimd;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(3; "Mode of Payment"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,Draft,Teller,Bank Transfer';
            OptionMembers = " ",Cash,Cheque,Draft,Teller,"Bank Transfer";

            trigger OnValidate()
            begin
                TestStatusOpen;
                if CurrFieldNo = FieldNo("Mode of Payment") then
                    "Account No." := '';
                "Date Lodged" := 0D;
                "Bank Lodged" := '';
            end;
        }
        field(4; "Payment Document No."; Code[20])
        {

            trigger OnValidate()
            begin
                TestField("Mode of Payment");
                TestStatusOpen;
                if CurrFieldNo = FieldNo("Payment Document No.") then begin
                    ReceiptHeader.Reset;
                    ReceiptHeader.SetFilter("No.", '<>%1', "No.");
                    ReceiptHeader.SetRange("Payment Document No.", "Payment Document No.");
                    ReceiptHeader.SetRange("Document Bank Code", "Document Bank Code");
                    ReceiptHeader.SetFilter("Entry Status", '%1|%2', "entry status"::Voided, "entry status"::"Financially Voided");
                    if ReceiptHeader.Find('-') then
                        Error(StrSubstNo(Text012, "Payment Document No."));
                end;
            end;
        }
        field(5; "Posting Description"; Text[100])
        {
        }
        field(8; "Last Modified By ID"; Code[50])
        {
        }
        field(9; Amount; Decimal)
        {
            CalcFormula = sum("Cash Receipt Line".Amount where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Document Date"; Date)
        {

            trigger OnValidate()
            begin
                TestField("Mode of Payment");
                TestStatusOpen;
            end;
        }
        field(11; "No. Printed"; Integer)
        {
        }
        field(12; Void; Boolean)
        {
        }
        field(13; "Document Bank Name"; Text[50])
        {
            Editable = false;
        }
        field(14; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(15; "User ID"; Code[50])
        {
        }
        field(16; "Document Bank Code"; Code[10])
        {
            TableRelation = Bank;

            trigger OnValidate()
            begin
                if "Document Bank Code" <> '' then begin
                    DocBank.Get("Document Bank Code");
                    "Document Bank Name" := DocBank.Name
                end else
                    "Document Bank Name" := ''
            end;
        }
        field(17; "No. Series"; Code[10])
        {
        }
        field(18; "Account Type"; Option)
        {
            Editable = false;
            InitValue = "Bank Account";
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner,Employee';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;

            trigger OnValidate()
            begin
                if "Account Type" <> xRec."Account Type" then
                    "Account No." := '';
            end;
        }
        field(19; "Account No."; Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                if "Account No." = '' then
                    exit;
                CreateDim(Database::"Bank Account", "Account No.");
                if ("Mode of Payment" in ["mode of payment"::Cash, "mode of payment"::Draft]) and (CurrFieldNo = FieldNo("Account No.")) then
                    if not Confirm(Text022, false) then
                        Error(Text000, "Mode of Payment");

                if "Mode of Payment" = "mode of payment"::Teller then begin
                    Bank.Get("Account No.");
                    "Document Bank Name" := Bank.Name;
                end;
            end;
        }
        field(20; "Currency Code"; Code[10])
        {
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if CurrFieldNo <> 0 then
                    TestField(Status, Status::Open);

                if SetCurrencyCode("Account Type", "Account No.") then begin
                    Bank.Get("Account No.");
                    Bank.TestField("Currency Code")
                end;

                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        RecreateRcptLines(FieldCaption("Currency Code"));
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(21; "Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Cash Receipt Line"."Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22; "Currency Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdateReceiptLines(FieldCaption("Currency Factor"), false);
            end;
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(24; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(25; "Dimension Set ID"; Integer)
        {
        }
        field(26; "WHT Amount"; Decimal)
        {
            CalcFormula = sum("Cash Receipt Line"."WHT Amount" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(27; "WHT Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Cash Receipt Line"."WHT Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Payer Type"; Option)
        {
            OptionCaption = 'Customer,Vendor,Employee,Others';
            OptionMembers = Customer,Vendor,Employee,Others;

            trigger OnValidate()
            begin
                if (xRec."Payer Type" <> "Payer Type") and ReceiptLinesExist then begin
                    if not Confirm(Text011, false, FieldCaption("Payer Type")) then
                        Error(Text012);
                    ReceiptLine.SetRange("Document No.", "No.");
                    ReceiptLine.DeleteAll(true);
                end;
            end;
        }
        field(29; "Payer No."; Code[20])
        {
            TableRelation = if ("Payer Type" = const(Customer)) Customer
            else
            if ("Payer Type" = const(Vendor)) Vendor
            else
            if ("Payer Type" = const(Employee)) Employee;

            trigger OnValidate()
            begin
                if (xRec."Payer No." <> "Payer No.") and ReceiptLinesExist then
                    if not Confirm(Text011, false, FieldCaption("Payer No.")) then
                        Error(Text012);
                if "Payer No." <> '' then
                    CheckPayerValidity;
            end;
        }
        field(30; "Transaction Time"; Time)
        {
        }
        field(31; "Last Date-Time Modified"; DateTime)
        {
        }
        field(32; "Voided By"; Code[50])
        {
        }
        field(33; "Applying Entry Exist"; Boolean)
        {
        }
        field(34; "External Document No."; Code[20])
        {
        }
        field(35; "Date Lodged"; Date)
        {
        }
        field(36; "Bank Lodged"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(37; "Date-Time Voided"; DateTime)
        {
        }
        field(38; "Confirmation Date"; Date)
        {
        }
        field(39; "Creation Date"; Date)
        {
        }
        field(40; "Posting Date"; Date)
        {
        }
        field(41; "Received from"; Text[100])
        {
        }
        field(42; "Payment Document Date"; Date)
        {
        }
        field(43; "Entry Status"; Option)
        {
            Editable = false;
            OptionCaption = ',Voided,Posted,Financially Voided';
            OptionMembers = ,Voided,Posted,"Financially Voided";
        }
        field(44; "Responsibility Center"; Code[10])
        {
            TableRelation = "Responsibility Center";
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
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error(Text009, TableCaption);
    end;

    trigger OnInsert()
    begin
        PmtMgtSetup.Get;
        UserSetup.Get(UserId);
        if not (UserSetup."Cashier Type" in [UserSetup."cashier type"::All, UserSetup."cashier type"::Receiving]) then
            Error(Text004);

        if "No." = '' then begin
            CheckBlankDoc;
            PmtMgtSetup.TestField("Receipt Nos.");
            NoSeriesMgt.InitSeries(PmtMgtSetup."Receipt Nos.", xRec."No. Series", WorkDate, "No.", "No. Series");
        end;
        "Creation Date" := WorkDate;
        "User ID" := UserId;
        "Transaction Time" := Time;
        "Document Date" := WorkDate;
        //"Responsibility Center" := UserSetupMgt.GetTreasuryFilter;
    end;

    trigger OnRename()
    begin
        Error(Text010, TableCaption);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PmtMgtSetup: Record "Payment Mgt. Setup";
        UserSetup: Record "User Setup";
        Bank: Record "Bank Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Employee: Record Employee;
        DocBank: Record Bank;
        ReceiptHeader: Record "Cash Receipt Header";
        ReceiptLine: Record "Cash Receipt Line";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyCode: Code[20];
        CurrencyDate: Date;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        UserSetupMgt: Codeunit "User Setup Management";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text000: label 'Account selection is not allowed for %1.';
        Text001: label 'Do you want to update the exchange rate?';
        Text002: label 'You have modified %1.\\';
        Text003: label 'Do you want to update the lines?';
        Text004: label 'You do not have permission to perform this role\Contact Your Administrator for Assistance.';
        Text006: label 'If you change %1, the existing receipt lines will be deleted and new receipt lines based on the new information on the header will be created.\\';
        Text007: label 'Do you want to change %1?';
        Text008: label 'You must delete the existing receipt lines before you can change %1.';
        Text009: label 'You can''t delete a %1.';
        Text010: label 'You can''t rename a %1.';
        Text011: label 'If you change %1, the existing receipt lines will be deleted\\ Do you want to continue?';
        Text013: label 'Action aborted';
        Text012: label 'Receipt has already been issued on the document %1.';
        Text022: label 'Your action will change the default cash account. Are you sure you want to continue?';
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text065: label 'New receipt number cannot be created because There is no line created for %1. Press Escape to use the number.';
        Text080: label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text081: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text082: label 'The dimensions used in %1 %2 are invalid. %3';
        Text083: label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';


    procedure AssitEdit(): Boolean
    begin
        PmtMgtSetup.Get;
        PmtMgtSetup.TestField("Receipt Nos.");
        if NoSeriesMgt.SelectSeries(PmtMgtSetup."Receipt Nos.", xRec."No. Series", "No. Series") then begin
            NoSeriesMgt.SetSeries("No.");
            exit(true);
        end;
    end;


    procedure SetCurrencyCode(AccType2: Option "G/L Account",Customer,Vendor,"Bank Account"; AccNo2: Code[20]): Boolean
    var
        BankAcc2: Record "Bank Account";
    begin
        "Currency Code" := '';
        if AccNo2 <> '' then
            if AccType2 = Acctype2::"Bank Account" then
                if BankAcc2.Get(AccNo2) then
                    "Currency Code" := BankAcc2."Currency Code";
        exit("Currency Code" <> '');
    end;


    procedure CheckBlankDoc()
    begin
        ReceiptHeader.SetRange("No.", "No.");
        ReceiptHeader.SetRange("User ID", UpperCase(UserId));
        ReceiptHeader.SetRange(Status, ReceiptHeader.Status::Open);
        if ReceiptHeader.Find('-') then
            repeat
                if not ReceiptHeader.ReceiptLinesExist then
                    Error(Text065, ReceiptHeader."No.");
            until ReceiptHeader.Next(1) = 0;
    end;


    procedure TestStatusOpen()
    begin
        TestField(Status, Status::Open);
    end;


    procedure ReceiptLinesExist(): Boolean
    begin
        ReceiptLine.Reset;
        ReceiptLine.SetRange("Document No.", "No.");
        exit(ReceiptLine.FindFirst);
    end;


    procedure RecreateRcptLines(ChangedFieldName: Text[100])
    var
        ReceiptLineTemp: Record "Cash Receipt Line" temporary;
    begin
        if ReceiptLinesExist then begin
            if HideValidationDialog or not GuiAllowed then
                Confirmed := true
            else
                Confirmed :=
                  Confirm(
                    Text006 +
                    Text007, false, ChangedFieldName);
            if Confirmed then begin
                ReceiptLine.LockTable;
                Modify;

                ReceiptLine.Reset;
                ReceiptLine.SetRange("Document No.", "No.");
                if ReceiptLine.FindSet then begin
                    repeat
                        ReceiptLineTemp := ReceiptLine;
                        ReceiptLineTemp.Insert;
                    until ReceiptLine.Next = 0;

                    ReceiptLine.DeleteAll(true);

                    ReceiptLine.Init;
                    ReceiptLine."Line No." := 0;
                    ReceiptLineTemp.FindSet;
                    repeat
                        ReceiptLine := ReceiptLineTemp;
                        ReceiptLine."Currency Code" := "Currency Code";
                        ReceiptLine.Validate(Amount, ReceiptLineTemp.Amount);
                        ReceiptLine.Insert;
                    until ReceiptLineTemp.Next = 0;
                end;
            end else
                Error(
                  Text008, ChangedFieldName);
        end;
    end;


    procedure UpdateReceiptLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        Question: Text[250];
    begin
        if not (ReceiptLinesExist) then
            exit;

        if AskQuestion then begin
            Question := StrSubstNo(
              Text002 +
              Text003, ChangedFieldName);
            if GuiAllowed then
                if not Dialog.Confirm(Question, true) then
                    exit;
        end;

        ReceiptLine.LockTable;
        Modify;

        ReceiptLine.Reset;
        ReceiptLine.SetRange("Document No.", "No.");
        if ReceiptLine.FindSet then
            repeat
                case ChangedFieldName of
                    FieldCaption("Currency Factor"):
                        begin
                            ReceiptLine.Validate(Amount);
                        end;
                end;
                ReceiptLine.Modify(true);
            until ReceiptLine.Next = 0;
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
            if ("Document Date" = 0D) then
                CurrencyDate := WorkDate
            else
                CurrencyDate := "Document Date";

            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;


    procedure ConfirmUpdateCurrencyFactor()
    begin
        if HideValidationDialog then
            Confirmed := true
        else
            Confirmed := Confirm(Text001, false);
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;


    procedure CheckDocEntry()
    begin
        if ("Account Type" = "account type"::"Bank Account") and ("Account No." <> '') then begin
            Bank.Get("Account No.");
            if ("Currency Code" = '') and (Bank."Currency Code" <> '') then
                TestField("Currency Code", Bank."Currency Code");
            Bank.TestField(Blocked, false);
        end;

        /*IF "Mode of Payment" <> "Mode of Payment"::Cash THEN BEGIN
          TESTFIELD("Payment Document No.");
          TESTFIELD("Payment Document Date");
        END ELSE BEGIN
          TESTFIELD("Payment Document No.",'');
          TESTFIELD("Payment Document Date",0D);
        END;*/

        TestField("Posting Description");
        if "Date Lodged" <> 0D then begin
            TestField("Bank Lodged");
            TestField("Account No.", "Bank Lodged");
        end;

        if "Mode of Payment" in ["mode of payment"::Cash, "mode of payment"::Teller] then
            TestField("Account No.");

        if "Bank Lodged" <> '' then
            TestField("Date Lodged")
        else
            TestField("Date Lodged", 0D);


        if "Mode of Payment" in ["mode of payment"::Cheque, "mode of payment"::Draft] then begin
            TestField("Document Date");
            TestField("Document Bank Name");
            TestField("Payment Document No.");
        end;

        //Check Lines
        ReceiptLine.Reset;
        ReceiptLine.SetRange("Document No.", "No.");
        ReceiptLine.FindSet;
        repeat
            ReceiptLine.TestField("Source No.");
            ReceiptLine.TestField("Source Name");
            ReceiptLine.TestField(Amount);
        until ReceiptLine.Next = 0;

        CheckDim;

    end;


    procedure CreateDim(Type1: Integer; No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No, '', "Global Dimension 1 Code", "Global Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and ReceiptLinesExist then begin
            Modify;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if ReceiptLinesExist then
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
            "Dimension Set ID", StrSubstNo('%1 %2', 'Receipt', "No."),
            "Global Dimension 1 Code", "Global Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if ReceiptLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text064) then
            exit;

        ReceiptLine.Reset;
        ReceiptLine.SetRange("Document No.", "No.");
        ReceiptLine.LockTable;
        if ReceiptLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(ReceiptLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ReceiptLine."Dimension Set ID" <> NewDimSetID then begin
                    ReceiptLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      ReceiptLine."Dimension Set ID", ReceiptLine."Global Dimension 1 Code", ReceiptLine."Global Dimension 2 Code");
                    ReceiptLine.Modify;
                end;
            until ReceiptLine.Next = 0;
    end;


    procedure CheckDim()
    var
        ReceiptLine2: Record "Cash Receipt Line";
    begin
        ReceiptLine2."Line No." := 0;
        CheckDimValuePosting(ReceiptLine2);
        CheckDimComb(ReceiptLine2);

        ReceiptLine2.SetRange("Document No.", "No.");
        if ReceiptLine2.FindSet then
            repeat
            begin
                CheckDimComb(ReceiptLine2);
                CheckDimValuePosting(ReceiptLine2);
            end
            until ReceiptLine2.Next = 0;
    end;

    local procedure CheckDimComb(ReceiptLine: Record "Cash Receipt Line")
    begin
        if ReceiptLine."Line No." = 0 then
            if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                Error(
                  Text080,
                  'Receipt', "No.", DimMgt.GetDimCombErr);

        if ReceiptLine."Line No." <> 0 then
            if not DimMgt.CheckDimIDComb(ReceiptLine."Dimension Set ID") then
                Error(
                  Text081,
                  'Receipt Line', "No.", ReceiptLine."Line No.", DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(var ReceiptLine2: Record "Cash Receipt Line")
    var
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        if ReceiptLine2."Line No." = 0 then begin
            TableIDArr[1] := Database::"Bank Account";
            NumberArr[1] := "Account No.";
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, "Dimension Set ID") then
                Error(
                  Text082,
                  'Receipt', "No.", DimMgt.GetDimValuePostingErr);
        end else begin
            TableIDArr[1] := DimMgt.TypeToTableID1(ReceiptLine2."Source Type");
            NumberArr[1] := ReceiptLine2."Source No.";
            TableIDArr[2] := Database::Job;
            NumberArr[2] := '';
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, ReceiptLine2."Dimension Set ID") then
                Error(
                  Text083,
                  'Receipt Line', "No.", ReceiptLine2."Line No.", DimMgt.GetDimValuePostingErr);
        end;
    end;


    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;


    procedure CheckPayerValidity()
    begin
        case "Payer Type" of
            0:
                begin
                    Customer.Get("Payer No.");
                    Customer.TestField("Customer Posting Group");
                    //Customer.TESTFIELD(Status,Customer.Status::Approved);
                    Customer.TestField(Blocked, 0);
                    "Received from" := Customer.Name;
                end;
            1:
                begin
                    Vendor.Get("Payer No.");
                    Vendor.TestField("Vendor Posting Group");
                    Vendor.TestField(Blocked, 0);
                    //Vendor.TESTFIELD(Status,Vendor.Status::Approved);
                    "Received from" := Vendor.Name;
                end;
            2:
                begin
                    Employee.Get("Payer No.");
                    //Employee.TESTFIELD(Status,Vendor.Status::Approved);
                    "Received from" := Employee.FullName;
                end;
        end;
    end;


    procedure CalcNetAmount(LCY: Boolean): Decimal
    begin
        CalcFields("Amount (LCY)", Amount, "WHT Amount", "WHT Amount (LCY)");
        if LCY then
            exit("Amount (LCY)" - "WHT Amount (LCY)")
        else
            exit(Amount - "WHT Amount")
    end;
}

