Table 52092287 "Payment Request Header"
{
    //LookupPageID = "Payment Request List - X";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Posting Description"; Text[100])
        {
        }
        field(3; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(4; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(5; "Dimension Set ID"; Integer)
        {

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(6; "Document Date"; Date)
        {
        }
        field(7; "Document Type"; Option)
        {
            OptionCaption = 'Cash Account,Float Account';
            OptionMembers = "Cash Account","Float Account";
        }
        field(11; "Currency Code"; Code[10])
        {
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if not (CurrFieldNo in [0, FieldNo("Document Date")]) or ("Currency Code" <> xRec."Currency Code") then
                    TestField(Status, Status::Open);
                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        RecreatePymtReqLines(FieldCaption("Currency Code"));
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(12; "Currency Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdatePaymentReqLines(FieldCaption("Currency Factor"), false);
            end;
        }
        field(13; "Creation Date"; Date)
        {
            Editable = false;
        }
        field(14; "Creation Time"; Time)
        {
            Editable = false;
        }
        field(15; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(16; "Preferred Pmt. Method"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,E-Payment';
            OptionMembers = " ",Cash,Cheque,"E-Payment";

            trigger OnValidate()
            begin
                case "Preferred Pmt. Method" of
                    0, 1, 2:
                        begin
                            "Preferred  Bank Code" := '';
                            "Payee Bank Account No." := '';
                            "Payee Bank Account Name" := '';
                        end;
                end;
            end;
        }
        field(17; "User ID"; Code[50])
        {
            Editable = false;
        }
        field(18; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Voided';
            OptionMembers = Open,Approved,"Pending Approval",Voided;

            trigger OnValidate()
            begin
                PaymentMgtSetup.Get;
                case Status of
                    Status::Approved, Status::"Pending Approval":
                        begin
                            if PaymentMgtSetup."Budget Expense Control Enabled" then
                                CreateCommitment;
                        end;
                    Status::Open, Status::Voided:
                        begin
                            if PaymentMgtSetup."Budget Expense Control Enabled" then
                                DeleteCommitment;
                        end;

                end;
            end;
        }
        field(19; "Voided By"; Code[50])
        {
            Editable = false;
        }
        field(20; "Date-Time Voided"; DateTime)
        {
            Editable = false;
        }
        field(21; "Last Date Modified"; Date)
        {
        }
        field(22; "Last Modified By"; Code[50])
        {
        }
        field(23; "System Created"; Boolean)
        {
            Editable = false;
        }
        field(24; Beneficiary; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if (xRec.Beneficiary <> Beneficiary) and (xRec.Beneficiary <> '') then begin
                    "Beneficiary Name" := '';
                    "Preferred  Bank Code" := '';
                    "Payee Bank Account No." := '';
                    "Payee Bank Account Name" := '';
                end;
                if Beneficiary <> '' then begin
                    Employee.Get(Beneficiary);
                    "Beneficiary Name" := Employee.FullName;
                    case "Request Type" of
                        "request type"::"Cash Advance":
                            begin
                                "Employee Posting Group" := Employee."Employee Posting Group";
                            end;
                    end;
                end;

                CreateDim(
                  Database::Employee, Beneficiary)
            end;
        }
        field(25; "Beneficiary Name"; Text[100])
        {
            Editable = false;
        }
        field(27; "Preferred  Bank Code"; Code[10])
        {
            TableRelation = "Employee Bank Account".Code where("Employee No." = field(Beneficiary));

            trigger OnValidate()
            begin
                if "Preferred  Bank Code" <> '' then begin
                    EmployeeBank.Get(Beneficiary, "Preferred  Bank Code");
                    "Payee Bank Account No." := EmployeeBank."Bank Account No.";
                    "Payee Bank Account Name" := EmployeeBank."Bank Account Name";
                end;
            end;
        }
        field(28; "Payee Bank Account No."; Text[30])
        {
        }
        field(29; "Payee Bank Account Name"; Text[80])
        {
        }
        field(32; "No. Printed"; Integer)
        {
            Editable = false;
        }
        field(33; "Voucher No."; Code[20])
        {
        }
        field(34; "Request Type"; Option)
        {
            OptionCaption = ' ,Direct Expense,Cash Advance,Float Reimbursement';
            OptionMembers = " ","Direct Expense","Cash Advance","Float Reimbursement";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                case "Request Type" of
                    "request type"::"Cash Advance":
                        begin
                            if Beneficiary <> '' then begin
                                Employee.Get(Beneficiary);
                                "Employee Posting Group" := Employee."Employee Posting Group";
                            end;
                        end;
                    "request type"::"Float Reimbursement":
                        begin
                            UserSetup.Get(UserId);
                            if not (UserSetup."Float Administrator") then
                                Error(Text010);
                            UserSetup.TestField("Float Account No.");
                            "Float Account" := UserSetup."Float Account No.";
                        end;
                end;
            end;
        }
        field(35; "Employee Posting Group"; Code[10])
        {
            TableRelation = "Vendor Posting Group";
        }
        field(36; "Float Account"; Code[20])
        {
        }
        field(100; Amount; Decimal)
        {
            CalcFormula = sum("Payment Request Line".Amount where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Amount (LCY)"; Decimal)
        {
            CalcFormula = sum("Payment Request Line"."Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5002; "Payment Date"; Date)
        {
        }
        field(5003; "Posted By"; Code[50])
        {
        }
        field(5004; "Entry Status"; Option)
        {
            OptionCaption = ' ,Posted';
            OptionMembers = " ",Posted;
        }
        field(5049; "Responsibility Center"; Code[10])
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
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ApprovalMgt.DeleteApprovalEntries(RecordId);
        PaymentReqLine.LockTable;

        PaymentReqLine.SetRange("Document No.", "No.");
        DeleteRequestLines;

        PmtCommentLine.SetRange("Table Name", 0);
        PmtCommentLine.SetRange("No.", "No.");
        PmtCommentLine.DeleteAll;
    end;

    trigger OnInsert()
    begin
        InitRecord;
        PaymentMgtSetup.Get;
        UserSetup.Get(UserId);

        if "No." = '' then begin
            PaymentMgtSetup.TestField("Payment Request Nos.");
            NoSeriesMgt.InitSeries(PaymentMgtSetup."Payment Request Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        UserSetup.TestField("Employee No.");
        Validate(Beneficiary, UserSetup."Employee No.");
        case "Document Type" of
            "document type"::"Cash Account":
                "Responsibility Center" := UserSetupMgt.GetRespCenter(3, "Responsibility Center");
            "document type"::"Float Account":
                begin
                    UserSetup.TestField("Float Resp. Ctr Filter");
                    "Responsibility Center" := UserSetupMgt.GetRespCenter(4, "Responsibility Center");
                end;
        end;
    end;

    trigger OnModify()
    begin
        if Status = Status::Voided then
            Error(Text004);

        "Last Date Modified" := Today;
        "Last Modified By" := UpperCase(UserId);
    end;

    var
        Text001: label 'Do you want to update the exchange rate?';
        Text002: label 'You have modified %1.\\';
        Text003: label 'Do you want to update the lines?';
        Text004: label 'Voided payment request cannot be modified.';
        Text006: label 'If you change %1, the existing request lines will be deleted and new request lines based on the new information on the header will be created.\\';
        Text007: label 'Do you want to change %1?';
        Text008: label 'You must delete the existing payment request lines before you can change %1.';
        Text009: label 'Request type must be specified';
        Text010: label 'This function can only be performed by a Float Administrator\\ Kindly contact your Administrator';
        Text021: label 'Nothing to process.';
        Text035: label 'No Budget Entry created for Account %1, please Contact your Budget Control Unit';
        Text036: label 'Your Expense for this Period have been Exceeded by =N= %1,Please Contact your Budget Control Unit';
        Text037: label 'Your Expense for this Period have been Exceeded by =N= %1, Do want to Continue?';
        Text038: label 'Transaction blocked to respect budget control';
        Text039: label 'The amount for account %1 will make you go above your budget\\ Please Contact your Budget Control Unit';
        Text040: label 'The amount for account %1 will make you go above your budget\\ Do you want to continue?';
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        PaymentMgtSetup: Record "Payment Mgt. Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        PaymentReqLine: Record "Payment Request Line";
        Employee: Record Employee;
        EmployeeBank: Record "Employee Bank Account";
        PmtCommentLine: Record "Payment Comment Line";
        Vendor: Record Vendor;
        EmployeeBanks: Page "Employee Bank Account List";
        CurrencyCode: Code[20];
        CurrencyDate: Date;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        BudgetControlMgt: Codeunit "Budget Control Management";
        UserSetupMgt: Codeunit "User Setup Management";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text080: label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text081: label 'The combination of dimensions used in %1 %2, line no. %3 is blocked. %4';
        Text082: label 'The dimensions used in %1 %2 are invalid. %3';
        Text083: label 'The dimensions used in %1 %2, line no. %3 are invalid. %4';


    procedure InitRecord()
    begin
        "User ID" := UpperCase(UserId);
        "Creation Date" := Today;
        "Creation Time" := Time;
        "Document Date" := Today;
        "Date-Time Voided" := 0DT;
        "Voided By" := '';
        "Voucher No." := '';
        "Date-Time Voided" := 0DT;
        Beneficiary := '';
        "Beneficiary Name" := '';
        "Preferred  Bank Code" := '';
        "Payee Bank Account No." := '';
        "Payee Bank Account Name" := '';
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
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No, '', "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and PaymentReqLinesExist then begin
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
        DimMgtHook.GetMappedDimValue(ShortcutDimCode, "Dimension Set ID", FieldNumber, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if PaymentReqLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    procedure PaymentReqLinesExist(): Boolean
    begin
        PaymentReqLine.Reset;
        PaymentReqLine.SetRange("Document No.", "No.");
        exit(PaymentReqLine.FindFirst);
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID", StrSubstNo('%1 %2', 'Payment Request', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if PaymentReqLinesExist then
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

        PaymentReqLine.Reset;
        PaymentReqLine.SetRange("Document No.", "No.");
        PaymentReqLine.LockTable;
        if PaymentReqLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(PaymentReqLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if PaymentReqLine."Dimension Set ID" <> NewDimSetID then begin
                    PaymentReqLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PaymentReqLine."Dimension Set ID", PaymentReqLine."Shortcut Dimension 1 Code", PaymentReqLine."Shortcut Dimension 2 Code");
                    PaymentReqLine.Modify;
                end;
            until PaymentReqLine.Next = 0;
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


    procedure RecreatePymtReqLines(ChangedFieldName: Text[100])
    var
        PaymentReqLineTemp: Record "Payment Request Line" temporary;
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
        if PaymentReqLinesExist then begin
            if HideValidationDialog or not GuiAllowed then
                Confirmed := true
            else
                Confirmed :=
                  Confirm(
                    Text006 +
                    Text007, false, ChangedFieldName);
            if Confirmed then begin
                PaymentReqLine.LockTable;
                Modify;

                PaymentReqLine.Reset;
                PaymentReqLine.SetRange("Document No.", "No.");
                if PaymentReqLine.FindSet then begin
                    repeat
                        PaymentReqLine.TestField("Job No.", '');
                        PaymentReqLineTemp := PaymentReqLine;
                        PaymentReqLineTemp.Insert;
                    until PaymentReqLine.Next = 0;

                    PaymentReqLine.DeleteAll(true);

                    PaymentReqLine.Init;
                    PaymentReqLine."Line No." := 0;
                    PaymentReqLineTemp.FindSet;
                    repeat
                        PaymentReqLine := PaymentReqLineTemp;
                        PaymentReqLine."Currency Code" := "Currency Code";
                        PaymentReqLine.Validate(Amount, PaymentReqLineTemp.Amount);
                        PaymentReqLine.Insert;
                    until PaymentReqLineTemp.Next = 0;
                end;
            end else
                Error(
                  Text008, ChangedFieldName);
        end;
    end;


    procedure UpdatePaymentReqLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        Question: Text[250];
    begin
        if not (PaymentReqLinesExist) then
            exit;

        if AskQuestion then begin
            Question := StrSubstNo(
              Text002 +
              Text003, ChangedFieldName);
            if GuiAllowed then
                if not Dialog.Confirm(Question, true) then
                    exit;
        end;

        PaymentReqLine.LockTable;
        Modify;

        PaymentReqLine.Reset;
        PaymentReqLine.SetRange("Document No.", "No.");
        if PaymentReqLine.FindSet then
            repeat
                case ChangedFieldName of
                    FieldCaption("Currency Factor"):
                        begin
                            PaymentReqLine.Validate(Amount);
                            PaymentReqLine.Validate("Amount (LCY)");
                        end;
                end;
                PaymentReqLine.Modify(true);
            until PaymentReqLine.Next = 0;
    end;


    procedure DeleteRequestLines()
    begin
        if PaymentReqLine.FindSet then begin
            repeat
                PaymentReqLine.SuspendStatusCheck(true);
                PaymentReqLine.Delete(true);
            until PaymentReqLine.Next = 0;
        end;
    end;


    procedure CreateCommitment()
    var
        AnalysisView: Record "Analysis View";
    begin
        PaymentMgtSetup.Get;
        if (PaymentMgtSetup."Budget Expense Control Enabled") then begin
            AnalysisView.Get(PaymentMgtSetup."Budget Analysis View Code");
            with PaymentReqLine do begin
                SetRange("Document No.", "No.");
                SetRange("Account Type", "account type"::"G/L Account");
                SetFilter("Account No.", AnalysisView."Account Filter");
                if Find('-') then
                    repeat
                        if BudgetControlMgt.ControlBudget("Account No.") then
                            BudgetControlMgt.UpdateCommitment("Document No.", "Line No.", Rec."Document Date", "Amount (LCY)",
                              "Account No.", "Dimension Set ID");
                    until Next = 0;
            end;
        end;
    end;


    procedure DeleteCommitment()
    var
        AnalysisView: Record "Analysis View";
    begin
        PaymentMgtSetup.Get;
        if (PaymentMgtSetup."Budget Expense Control Enabled") then begin
            AnalysisView.Get(PaymentMgtSetup."Budget Analysis View Code");
            with PaymentReqLine do begin
                SetRange("Document No.", "No.");
                SetRange("Account Type", "account type"::"G/L Account");
                SetFilter("Account No.", AnalysisView."Account Filter");
                if Find('-') then
                    repeat
                        if BudgetControlMgt.ControlBudget("Account No.") then
                            BudgetControlMgt.DeleteCommitment("Document No.", "Line No.", "Account No.");
                    until Next = 0;
            end;
        end;
    end;


    procedure CheckEntryForApproval()
    begin
        TestField("Posting Description");
        TestField(Beneficiary);
        if "Request Type" = 0 then
            Error(Text009);
        PaymentReqLine.SetRange("Document No.", "No.");
        PaymentReqLine.SetFilter(Amount, '<>0');
        if not PaymentReqLine.FindFirst then
            Error(Text021);

        PaymentReqLine.SetRange(Amount);
        PaymentReqLine.Find('-');
        repeat
            PaymentReqLine.TestField("Request Code");
            PaymentReqLine.TestField(Amount);
            PaymentReqLine.TestField(Description);
        until PaymentReqLine.Next(1) = 0;
        CheckDim;
    end;


    procedure CheckDim()
    var
        PaymentReqLine2: Record "Payment Request Line";
    begin
        PaymentReqLine2."Line No." := 0;
        CheckDimValuePosting(PaymentReqLine2);
        CheckDimComb(PaymentReqLine2);

        PaymentReqLine2.SetRange("Document No.", "No.");
        if PaymentReqLine2.FindSet then
            repeat
            begin
                CheckDimComb(PaymentReqLine2);
                CheckDimValuePosting(PaymentReqLine2);
            end
            until PaymentReqLine2.Next = 0;
    end;

    local procedure CheckDimComb(PaymentReqLine: Record "Payment Request Line")
    begin
        if PaymentReqLine."Line No." = 0 then
            if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                Error(
                  Text080,
                  'Payment Request', "No.", DimMgt.GetDimCombErr);

        if PaymentReqLine."Line No." <> 0 then
            if not DimMgt.CheckDimIDComb(PaymentReqLine."Dimension Set ID") then
                Error(
                  Text081,
                  'Payment Request', "No.", PaymentReqLine."Line No.", DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(var PaymentReqLine2: Record "Payment Request Line")
    var
        TableIDArr: array[10] of Integer;
        NumberArr: array[10] of Code[20];
    begin
        if PaymentReqLine2."Line No." = 0 then begin
            exit;
        end else begin
            TableIDArr[1] := DimMgt.TypeToTableID1(PaymentReqLine2."Account Type");
            NumberArr[1] := PaymentReqLine2."Account No.";
            TableIDArr[2] := Database::Job;
            NumberArr[2] := PaymentReqLine2."Job No.";
            if not DimMgt.CheckDimValuePosting(TableIDArr, NumberArr, PaymentReqLine2."Dimension Set ID") then
                Error(
                  Text083,
                  'Payment Request', "No.", PaymentReqLine2."Line No.", DimMgt.GetDimValuePostingErr);
        end;
    end;


    procedure CheckBudgetLimit()
    var
        RecRef: RecordRef;
        AnalysisView: Record "Analysis View";
        GLAccount: Record "G/L Account";
        TotalExpAmount: Decimal;
        TotalBudgetAmount: Decimal;
        TotalCommittedAmount: Decimal;
        Variance: Decimal;
        LineAmountLCY: Decimal;
        AboveBudget: Boolean;
        WorkflowMgt: Codeunit "Gems Workflow Event";
    begin
        PaymentMgtSetup.Get;
        AboveBudget := false;
        if PaymentMgtSetup."Budget Expense Control Enabled" then begin
            AnalysisView.Get(PaymentMgtSetup."Budget Analysis View Code");
            PaymentReqLine.SetRange("Document No.", "No.");
            PaymentReqLine.SetRange("Account Type", PaymentReqLine."account type"::"G/L Account");
            PaymentReqLine.SetFilter("Account No.", AnalysisView."Account Filter");
            if PaymentReqLine.FindFirst then begin
                repeat
                    if BudgetControlMgt.ControlBudget(PaymentReqLine."Account No.") then begin
                        TotalExpAmount := 0;
                        TotalBudgetAmount := 0;
                        TotalCommittedAmount := 0;
                        BudgetControlMgt.GetAmounts(PaymentReqLine."Dimension Set ID", Rec."Document Date", PaymentReqLine."Account No.",
                          TotalBudgetAmount, TotalExpAmount, TotalCommittedAmount);
                        if TotalBudgetAmount = 0 then
                            AboveBudget := true;
                        if (TotalBudgetAmount <> 0) then begin
                            if ((TotalExpAmount + TotalCommittedAmount) > TotalBudgetAmount) then begin
                                AboveBudget := true;
                            end else begin
                                LineAmountLCY := PaymentReqLine."Amount (LCY)";
                                if (TotalExpAmount + LineAmountLCY + TotalCommittedAmount) > TotalBudgetAmount then
                                    AboveBudget := true;
                            end;
                        end;
                    end;
                until PaymentReqLine.Next = 0;
            end;
        end;
        RecRef.GetTable(Rec);
        if AboveBudget then
            WorkflowMgt.OnPaymentRequestBudgetExceeded(RecRef)
        else
            WorkflowMgt.OnPaymentRequestBudgetNotExceeded(RecRef);
    end;
}

