Table 52092236 "Travel Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; Beneficiary; Code[20])
        {
            Caption = 'Beneficiary No.';
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Beneficiary <> '' then begin
                    Employee.Get(Beneficiary);
                    "Employee Name" := Employee.FullName;
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    Designation := Employee.Designation;
                    Validate("Manager No.", Employee."Manager No.");
                    Employee.TestField("Employee Category");
                    "Employee Category" := Employee."Employee Category";
                    if not EmpCategory.Get("Employee Category") then
                        Error(Text008, "Employee Category");
                    Employee.TestField(Employee."E-Mail");
                    "Requestor E-Mail" := Employee."E-Mail";
                end;
                if Beneficiary <> xRec.Beneficiary then
                    RecreateTravelCost(FieldCaption(Beneficiary));
            end;
        }
        field(3; "Employee Name"; Text[150])
        {
            Editable = false;
        }
        field(4; "Global Dimension 1 Code"; Code[20])
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
        field(5; "Global Dimension 2 Code"; Code[20])
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
        field(6; "Dimension Set ID"; Integer)
        {
        }
        field(8; Designation; Text[40])
        {
            Editable = false;
        }
        field(11; "Manager No."; Code[20])
        {
            Caption = 'Manager No.';
            Editable = false;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if "Manager No." <> '' then begin
                    Employee.Get("Manager No.");
                    "Manager Name" := Employee.FullName;
                end else
                    "Manager Name" := '';
            end;
        }
        field(12; "Travel Type"; Option)
        {
            OptionCaption = ' ,Local,International';
            OptionMembers = " ","Local",International;

            trigger OnValidate()
            begin
                if ("Travel Type" <> xRec."Travel Type") and (xRec."Travel Type" <> 0) then
                    RecreateTravelCost(FieldCaption("Travel Type"));
            end;
        }
        field(13; "Document Date"; Date)
        {
            Editable = false;
        }
        field(14; "Employee Category"; Code[10])
        {
            Editable = false;
            TableRelation = "Employee Category";
        }
        field(15; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(16; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";

            trigger OnValidate()
            begin
                if Status = Status::Approved then begin
                    SendAdminNotification;
                    CreateCommitment;
                end else
                    if Status = Status::Open then
                        DeleteCommitment;
            end;
        }
        field(17; "Currency Code"; Code[10])
        {
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        RecreateTravelCost(FieldCaption("Currency Code"));
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(18; "Currency Factor"; Decimal)
        {
        }
        field(19; "Purpose of Travel"; Text[80])
        {
        }
        field(21; "Requestor E-Mail"; Text[80])
        {
        }
        field(23; Closed; Boolean)
        {
        }
        field(24; "Preferred Pmt. Method"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,Bank Transfer';
            OptionMembers = " ",Cash,Cheque,"Bank Transfer";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Preferred Pmt. Method" <> xRec."Preferred Pmt. Method" then
                    "Preferred  Bank Code" := '';

                if "Preferred Pmt. Method" = "preferred pmt. method"::Cash then begin
                    "Bank Account" := '';
                    "Bank Account Name" := '';
                end else
                    if "Bank Account Name" = '' then
                        "Bank Account Name" := "Employee Name";
            end;
        }
        field(25; "Preferred  Bank Code"; Code[20])
        {
            TableRelation = if ("Preferred Pmt. Method" = filter(Cheque | "Bank Transfer")) "Employee Bank Account".Code where("Employee No." = field(Beneficiary));

            trigger OnValidate()
            begin
                EmployeeBankAccounts.SetRange(EmployeeBankAccounts."Employee No.", Beneficiary);
                EmployeeBankAccounts.SetRange(EmployeeBankAccounts."CBN Bank Code", "Preferred  Bank Code");
                if EmployeeBankAccounts.FindFirst then begin
                    EmployeeBankAccounts.TestField(EmployeeBankAccounts.Code);
                    "Bank Account" := EmployeeBankAccounts.Code;
                    "Bank Account Name" := EmployeeBankAccounts."Employee Name";
                end;
            end;
        }
        field(26; "Bank Account"; Text[30])
        {
            Editable = false;
        }
        field(27; "Bank Account Name"; Text[50])
        {
            Editable = false;
        }
        field(28; "Voucher Paying Account"; Code[20])
        {
        }
        field(29; "Approved Pmt. Method"; Option)
        {
            OptionCaption = ' ,Cash,Cheque,E-Payment';
            OptionMembers = " ",Cash,Cheque,"E-Payment";
        }
        field(31; "Voucher Creation Date"; Date)
        {
        }
        field(32; "Voucher No."; Code[40])
        {
        }
        field(33; "Voucher Type"; Option)
        {
            OptionCaption = 'Payment Voucher,Cash Advance,Both';
            OptionMembers = "Payment Voucher","Cash Advance",Both;
        }
        field(34; Ticketed; Boolean)
        {

            trigger OnValidate()
            begin
                if Ticketed then
                    if "Voucher Status" in [0, 1] then
                        if not Confirm(Text006) then
                            TestField("Voucher Status", "voucher status"::"In-Process");
            end;
        }
        field(35; "Voucher Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Does Not Exist,In-Process,Voided,Completed';
            OptionMembers = "Does Not Exist","In-Process",Voided,Completed;
        }
        field(36; "Departure Date"; Date)
        {

            trigger OnValidate()
            begin
                if ("Departure Date" <> 0D) and ("Return Date" <> 0D) then
                    if "Departure Date" > "Return Date" then
                        Error(Text017);
            end;
        }
        field(37; "Return Date"; Date)
        {

            trigger OnValidate()
            begin
                if "Return Date" <> 0D then
                    TestField("Departure Date");
                if "Return Date" < "Departure Date" then
                    Error(Text017);
            end;
        }
        field(38; "Total Allowance Cost"; Decimal)
        {
            CalcFormula = sum("Travel Cost".Amount where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(39; "Total Allowance Cost (LCY)"; Decimal)
        {
            CalcFormula = sum("Travel Cost"."Amount (LCY)" where("Document No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Budgeted Total Cost"; Decimal)
        {
        }
        field(41; "Manager Name"; Text[150])
        {
            Editable = false;
        }
        field(42; "User ID"; Code[50])
        {
        }
        field(43; "Voucher Follow-up Status"; Option)
        {
            OptionCaption = 'Does Not Exist,In-Process,Voided,Completed';
            OptionMembers = "Does Not Exist","In-Process",Voided,Completed;
        }
        field(44; "Airport Pickup Provided"; Boolean)
        {
        }
        field(45; "Visa Provided"; Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Travel Type", "travel type"::International);
            end;
        }
        field(46; "Ticket Vendor"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No." where(Type = const("Trade Creditor"));
        }
        field(47; "Ticket Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(48; "Purchase Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(49; "Vendor Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
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
        DeleteCommitment;
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Travel Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Travel Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;

        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        Validate(Beneficiary, UserSetup."Employee No.");
        "User ID" := UserId;
        "Document Date" := WorkDate;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PaymentMgtSetup: Record "Payment Mgt. Setup";
        HumanResSetup: Record "Human Resources Setup";
        Employee: Record Employee;
        EmpCategory: Record "Employee Category";
        UserSetup: Record "User Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLAccount: Record "G/L Account";
        TravelCost: Record "Travel Cost";
        TravelLine: Record "Travel Line";
        DimMgt: Codeunit 408;
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        NoSeriesMgt: Codeunit 396;
        Text001: label 'Do you want to update the exchange rate?';
        Text004: label 'Nothing to approve. Ensure that the cost is calculated';
        Text002: label 'Kindly attend to my travel request %1 ';
        Text005: label 'No travel line exsists';
        Text006: label 'Payment Voucher has not been raised for this Request!\ Do you want to Continue Ticketing?';
        Text008: label 'Staff Category %1 does not eype %2xist. Please contact your system Administrator for assistance.';
        Text009: label 'There is no travel allowance for this trip - Staff Category %1, travel type %2 and Cost Group %3.';
        Text010: label 'No Budget Entry created for Dimension %1, in Account %2, please Contact your Budget Control Unit';
        Text018: label 'You must delete the existing transfer lines before you can change %1.';
        Text019: label 'If you change %1, the existing travel lines will be deleted and newtravel lines based on the new information on the header will be created.\\';
        Text020: label 'Do you want to change %1?';
        GlobalSender: Text[80];
        Body: Text[200];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
        BudgetControlMgt: Codeunit "Budget Control Management";
        EmployeeBankAccounts: Record "Employee Bank Account";
        Text013: label 'Your Expense for this Period with Account %1 have been Exceeded by =N= %2, Do want to Continue?';
        Text014: label 'Your Expense for this Period with Account %1 have been Exceeded by =N= %2,Please Contact your Budget Control Unit';
        Text015: label 'Information specified for bank payment will be removed. Are you sure you want to continue?';
        Text016: label 'Action Aborted.';
        Text017: label 'Departure date cannot be before arrival date';
        TravelCostLines: Record "Travel Cost";
        TravelCostLines2: Record "Travel Cost";
        PaymentVoucLine: Record "Payment Line";
        StartDate: Date;
        EndDate: Date;
        TravelHeader: Record "Travel Header";
        TravelHeader2: Record "Travel Header";
        PaymentReqLine: Record "Payment Request Line";
        PaymentReqHeader: Record "Payment Request Header";
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        AccountingPeriod: Record "Accounting Period";
        Text030: label 'Transaction blocked to respect budget control';
        Text031: label 'The amount for account %1 will make you go above your budget\\ Please Contact your Budget Control Unit';
        Text032: label 'The amount for account %1 will make you go above your budget\\ Do you want to continue?';
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';

    local procedure UpdateCurrencyFactor()
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

    local procedure ConfirmUpdateCurrencyFactor()
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


    procedure TravelLineExist(): Boolean
    var
        TravelLine: Record "Travel Line";
    begin
        TravelLine.Reset;
        TravelLine.SetRange("Document No.", "No.");
        exit(TravelLine.FindFirst);
    end;


    procedure TravelCostExist(): Boolean
    begin
        Clear(TravelCost);
        TravelCost.SetRange("Document No.", "No.");
        exit(TravelCost.FindFirst);
    end;


    procedure RecreateTravelCost(ChangedFieldName: Text[100])
    var
        TravelCostTemp: Record "Travel Cost" temporary;
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
                TravelCost.SetRange("Document No.", "No.");
                TravelCost.SetFilter("Cost Code", '<>%1', '');
                if TravelCost.FindSet then begin
                    repeat
                        TravelCostTemp := TravelCost;
                        TravelCostTemp.Insert;
                    until TravelCost.Next = 0;

                    TravelCost.DeleteAll(true);

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


    procedure CreateTravelCost()
    var
        TravelLine: Record "Travel Line";
    begin
        if not (TravelLineExist) then
            Error(Text005);

        TravelLine.SetRange("Document No.", "No.");
        TravelLine.SetFilter("Travel Group", '<>%1', '');
        TravelLine.SetFilter("No. of Nights", '<>%1', 0);
        if TravelLine.FindFirst then begin
            repeat
                TravelLine.CreateCostLines(true);
            until TravelLine.Next = 0;
        end;

        Commit;

        if not TravelCostExist then
            Message(Text009, "Employee Category", Format("Travel Type"), TravelLine."Travel Group");
    end;


    procedure SendAdminNotification()
    begin
        PaymentMgtSetup.Get;
        if PaymentMgtSetup."Travel Request Alert E-mail" <> '' then begin
            Employee.Get(Beneficiary);
            GlobalSender := "Employee Name";
            Body := StrSubstNo(Text002, "No.");
            Subject := Format("Travel Type") + 'Travel Request';
            SMTP.CreateMessage(GlobalSender, "Requestor E-Mail", PaymentMgtSetup."Travel Request Alert E-mail", Subject, Body, false);
            SMTP.Send;
        end;
    end;


    procedure CheckTravelDetails()
    var
        TravelLine: Record "Travel Line";
    begin
        CalcFields("Total Allowance Cost");

        if ("Total Allowance Cost" = 0) then
            Error(Text004);

        if not (TravelLineExist) then
            Error(Text004);

        TravelLine.SetRange("Document No.", "No.");
        TravelLine.FindFirst;
        repeat
            TravelLine.TestField("Start Date");
            TravelLine.TestField("End Date");
            TravelLine.CheckDates(TravelLine.FieldCaption("Start Date"));
            TravelLine.CheckDates(TravelLine.FieldCaption("End Date"));
        until TravelLine.Next = 0;
    end;


    procedure CheckBudgetEntry()
    var
        AnalysisView: Record "Analysis View";
        RecRef: RecordRef;
        TotalBudgetAmount: Decimal;
        TotalExpAmount: Decimal;
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
            TravelCost.SetRange("Document No.", "No.");
            TravelCost.SetFilter("Account Code", AnalysisView."Account Filter");
            if TravelCost.FindFirst then begin
                repeat
                    if GLAccount.Get(TravelCost."Account Code") then
                        if BudgetControlMgt.ControlBudget(TravelCost."Account Code") then begin
                            TotalExpAmount := 0;
                            TotalBudgetAmount := 0;
                            TotalCommittedAmount := 0;
                            TravelLine.Get(TravelCost."Document No.", TravelCost."Line No.");
                            BudgetControlMgt.GetAmounts(TravelLine."Dimension Set ID", Rec."Document Date", TravelCost."Account Code",
                              TotalBudgetAmount, TotalExpAmount, TotalCommittedAmount);
                            if TotalBudgetAmount = 0 then
                                AboveBudget := true;
                            if (TotalBudgetAmount <> 0) then begin
                                if ((TotalExpAmount + TotalCommittedAmount) > TotalBudgetAmount) then begin
                                    AboveBudget := true;
                                end else begin
                                    LineAmountLCY := TravelCost."Amount (LCY)";
                                    if (TotalExpAmount + LineAmountLCY + TotalCommittedAmount) > TotalBudgetAmount then
                                        AboveBudget := true;
                                end;
                            end;
                        end;
                until TravelCost.Next = 0;
            end;
        end;

        RecRef.GetTable(Rec);
        if AboveBudget then
            WorkflowMgt.OnTravelRequestBudgetExceeded(RecRef)
        else
            WorkflowMgt.OnTravelRequestBudgetNotExceeded(RecRef);
    end;


    procedure CreateCommitment()
    begin
        with TravelCost do begin
            PaymentMgtSetup.Get;
            ;
            SetRange("Document No.", "No.");
            SetFilter("Account Code", '<>%1', '');
            if Find('-') and (PaymentMgtSetup."Budget Expense Control Enabled") then
                repeat
                    TravelLine.Get("Document No.", "Line No.");
                    BudgetControlMgt.UpdateCommitment("Document No.", "Line No.", Rec."Document Date", "Amount (LCY)", "Account Code",
                    TravelLine."Dimension Set ID");
                until Next = 0;
        end;
    end;


    procedure DeleteCommitment()
    begin
        with TravelCost do begin
            SetRange("Document No.", "No.");
            SetFilter("Account Code", '<>%1', '');
            if Find('-') then
                repeat
                    BudgetControlMgt.DeleteCommitment("Document No.", "Line No.", "Account Code");
                until Next = 0;
        end;
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

        if (OldDimSetID <> "Dimension Set ID") and TravelLineExist then begin
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
            if TravelLineExist then
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
            "Dimension Set ID", StrSubstNo('%1 %2', 'Payment Request', "No."),
            "Global Dimension 1 Code", "Global Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if TravelLineExist then
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

        TravelLine.Reset;
        TravelLine.SetRange("Document No.", "No.");
        TravelLine.LockTable;
        if TravelLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(TravelLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if TravelLine."Dimension Set ID" <> NewDimSetID then begin
                    TravelLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      TravelLine."Dimension Set ID", TravelLine."Global Dimension 1 Code", TravelLine."Global Dimension 2 Code");
                    TravelLine.Modify;
                end;
            until TravelLine.Next = 0;
    end;
}

