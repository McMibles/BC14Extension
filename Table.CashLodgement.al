Table 52092303 "Cash Lodgement"
{

    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;
        }
        field(2;Description;Text[100])
        {
        }
        field(4;"Lodgement Document No.";Code[20])
        {
        }
        field(5;"Lodgement Type";Option)
        {
            OptionCaption = ' ,Cash,Cheque,Draft';
            OptionMembers = " ",Cash,Cheque,Draft;
        }
        field(8;"Last Modified By ID";Code[50])
        {
        }
        field(9;Amount;Decimal)
        {

            trigger OnValidate()
            begin
                GetCurrency;
                if "Currency Code" = '' then
                  "Amount (LCY)" := Amount
                else
                  "Amount (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Document Date","Currency Code",
                      Amount,"Currency Factor"));

                Amount := ROUND(Amount,Currency."Amount Rounding Precision");
            end;
        }
        field(10;"Document Date";Date)
        {
        }
        field(14;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(15;"User ID";Code[50])
        {
        }
        field(17;"No. Series";Code[10])
        {
        }
        field(18;"Account Type";Option)
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
        field(19;"Account No.";Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                if "Account No." = '' then
                  exit;

                if "Account No." <> '' then begin
                  Bank.Get("Account No.");
                  Bank.TestField(Blocked,false);
                  CheckBankCurrency;
                end;

                CreateDim(Database::"Bank Account","Account No.");
            end;
        }
        field(20;"Currency Code";Code[10])
        {
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if CurrFieldNo <> 0 then
                  TestField(Status,Status::Open);
                if (CurrFieldNo <> FieldNo("Currency Code")) and ("Currency Code" = xRec."Currency Code") then
                  UpdateCurrencyFactor
                else begin
                  if "Currency Code" <> xRec."Currency Code" then begin
                    UpdateCurrencyFactor;
                  end else
                    if "Currency Code" <> '' then begin
                      UpdateCurrencyFactor;
                      if "Currency Factor" <> xRec."Currency Factor" then
                        ConfirmUpdateCurrencyFactor;
                    end;
                end;
            end;
        }
        field(21;"Amount (LCY)";Decimal)
        {
            Editable = false;
        }
        field(22;"Currency Factor";Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                if ("Currency Code" = '') and ("Currency Factor" <> 0) then
                  FieldError("Currency Factor",StrSubstNo(Text002,FieldCaption("Currency Code")));
                Validate(Amount);
            end;
        }
        field(23;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(24;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(25;"Dimension Set ID";Integer)
        {
        }
        field(30;"Transaction Time";Time)
        {
        }
        field(31;"Last Date-Time Modified";DateTime)
        {
        }
        field(35;"Date Lodged";Date)
        {
        }
        field(36;"Bank Lodged";Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(39;"Creation Date";Date)
        {
        }
        field(40;"Responsibility Center";Code[10])
        {
            TableRelation = "Responsibility Center";
        }
        field(43;"Entry Status";Option)
        {
            Editable = false;
            OptionCaption = ' ,Voided,Posted,Financially Voided';
            OptionMembers = " ",Voided,Posted,"Financially Voided";
        }
        field(60;"Voided By";Code[50])
        {
        }
        field(61;"Date-Time Voided";DateTime)
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        PmtMgtSetup.Get;
        UserSetup.Get(UserId);
        if not (UserSetup."Cashier Type" in[UserSetup."cashier type"::All,UserSetup."cashier type"::Receiving]) then
          Error(Text004);
        if "No." = '' then begin
          PmtMgtSetup.TestField("Cash Lodgement Nos.");
          NoSeriesMgt.InitSeries(PmtMgtSetup."Cash Lodgement Nos.",xRec."No. Series",WorkDate,"No.","No. Series");
        end;
        "Creation Date" := WorkDate;
        "User ID" := UserId;
        "Transaction Time" := Time;
        "Document Date" := WorkDate;
        "Responsibility Center" := UserSetupMgt.GetRespCenter(0,"Responsibility Center")
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PmtMgtSetup: Record "Payment Mgt. Setup";
        UserSetup: Record "User Setup";
        Text001: label 'Do you want to update the exchange rate?';
        Text002: label 'cannot be specified without %1';
        Text004: label 'You do not have permission to perform this role\Contact Your Administrator for Assistance.';
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Bank: Record "Bank Account";
        Bank2: Record "Bank Account";
        CurrencyCode: Code[20];
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        UserSetupMgt: Codeunit "User Setup Management";


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
          if  ("Document Date" = 0D) then
            CurrencyDate := WorkDate
          else
            CurrencyDate := "Document Date";

          "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate,"Currency Code");
        end else
          "Currency Factor" := 0;
    end;


    procedure ConfirmUpdateCurrencyFactor()
    begin
        if HideValidationDialog then
          Confirmed := true
        else
          Confirmed := Confirm(Text001,false);
        if Confirmed then
          Validate("Currency Factor")
        else
          "Currency Factor" := xRec."Currency Factor";
    end;


    procedure CreateDim(Type1: Integer;No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.Get;
        TableID[1] := Type1;
        No[1] := No1;
        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID,No,'',"Global Dimension 1 Code","Global Dimension 2 Code",0,0);

        if (OldDimSetID <> "Dimension Set ID") then
          Modify;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        if "No." <> '' then
          Modify;

        if OldDimSetID <> "Dimension Set ID" then
          Modify;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",StrSubstNo('%1 %2','Cash Lodgement',"No."),
            "Global Dimension 1 Code","Global Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then
          Modify;
    end;


    procedure CheckBankCurrency()
    begin
        if "Account No." <> '' then begin
          Bank2.Get("Account No.");
          if ("Currency Code" <> '') and (Bank2."Currency Code" <> '') then
            TestField("Currency Code",Bank2."Currency Code");
        end;

        if "Bank Lodged" <> '' then begin
          Bank2.Get("Bank Lodged");
          if ("Currency Code" <> '') and (Bank2."Currency Code" <> '') then
            TestField("Currency Code",Bank2."Currency Code");
        end;
    end;
}

