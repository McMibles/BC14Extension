Table 52092297 "Cheque File"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
        }
        field(2;"Creation Date";Date)
        {
            Editable = false;
        }
        field(3;Description;Text[70])
        {
        }
        field(4;Payee;Text[100])
        {

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
            end;
        }
        field(5;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Paid';
            OptionMembers = Open,Approved,"Pending Approval",Paid;
        }
        field(6;"Document No.";Code[20])
        {
            Editable = false;
        }
        field(7;Bank;Code[20])
        {
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                TestField("Check No.");
                CalcFields("Attached Amount");
                if ("Attached Amount" <> 0) and ("Entry No." <> 0) then
                  Error(Text003);

                if Bank <> '' then
                  if CheckUsedNo then
                    Error(Text006,FieldCaption("Check No."),"Check No.");
                CreateDim(Database::"Bank Account",Bank);
            end;
        }
        field(8;"Check No.";Code[20])
        {

            trigger OnValidate()
            begin
                if "Check No." <> '' then
                  if CheckUsedNo then
                    Error(Text006,FieldCaption("Check No."),"Check No.");
            end;
        }
        field(9;"Currency Code";Code[10])
        {
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                CalcFields("Attached Amount");
                TestField("Check Posting Date");
                if "Attached Amount" <> 0 then
                  Error(Text003);

                if "Currency Code" <> '' then begin
                  GetCurrency;
                  if ("Currency Code" <> xRec."Currency Code") or
                     ("Check Posting Date" <> xRec."Check Posting Date") or
                     (CurrFieldNo = FieldNo("Currency Code")) or
                     ("Currency Factor" = 0)
                  then
                    "Currency Factor" :=
                      CurrExchRate.ExchangeRate("Check Posting Date","Currency Code");
                end else
                  "Currency Factor" := 0;
                Validate("Currency Factor");
            end;
        }
        field(10;"Currency Factor";Decimal)
        {

            trigger OnValidate()
            begin
                TestField("Check Posting Date");
                if ("Currency Code" = '') and ("Currency Factor" <> 0) then
                  FieldError("Currency Factor",StrSubstNo(Text005,FieldCaption("Currency Code")));
                Validate(Amount);
            end;
        }
        field(11;"LedgerEntry Exist";Boolean)
        {
            CalcFormula = exist("Check Ledger Entry" where ("Bank Account No."=field(Bank),
                                                            "Check Entry No."=field("Entry No."),
                                                            "Check No."=field("Check No.")));
            FieldClass = FlowField;
        }
        field(12;"No. Printed";Integer)
        {
            Editable = false;
        }
        field(13;Amount;Decimal)
        {

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);

                if "Currency Code" = '' then
                  "Amount (LCY)" := Amount
                else
                  "Amount (LCY)" := ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Creation Date","Currency Code",
                      Amount,"Currency Factor"));
            end;
        }
        field(14;"Amount (LCY)";Decimal)
        {
            Editable = false;
        }
        field(15;"Check Posting Date";Date)
        {
        }
        field(16;"User ID";Code[50])
        {
            Editable = false;
        }
        field(17;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(18;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(19;"Dimension Set ID";Integer)
        {
        }
        field(100;"Attached Amount";Decimal)
        {
            CalcFormula = sum("Payment Line".Amount where ("Check Entry No."=field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101;"Attached Amount (LCY)";Decimal)
        {
            CalcFormula = sum("Payment Line"."Amount (LCY)" where ("Check Entry No."=field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(102;"WHT Amount";Decimal)
        {
            CalcFormula = sum("Payment Line"."WHT Amount" where ("Check Entry No."=field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(103;"WHT Amount (LCY)";Decimal)
        {
            CalcFormula = sum("Payment Line"."WHT Amount (LCY)" where ("Check Entry No."=field("Entry No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Status,Status::Open);
    end;

    trigger OnInsert()
    begin
        UserSetup.Get(UserId);
        if not (UserSetup."Cashier Type" in[UserSetup."cashier type"::All,UserSetup."cashier type"::Checks]) then
          Error(Text001);

        if "Entry No." = 0 then
          "Entry No." := GetNextLineNo;

        if "Document No." = '' then begin
          PmtMgtSetup.Get;
          case PmtMgtSetup."Cheque Posting Type" of
            PmtMgtSetup."cheque posting type"::"System Generated No.":
              begin
                PmtMgtSetup.TestField(PmtMgtSetup."Check Nos.");
                NoSeriesMgt.InitSeries(PmtMgtSetup."Check Nos.",PmtMgtSetup."Check Nos.",
                0D,"Document No.",PmtMgtSetup."Check Nos.");
              end;
            PmtMgtSetup."cheque posting type"::"Cheque No.":
              "Document No." := "Check No.";
          end;
        end;
        "User ID" := UserId;
        "Creation Date" := Today;
    end;

    var
        PmtMgtSetup: Record "Payment Mgt. Setup";
        CheckLedgerEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        BankAccount: Record "Bank Account";
        UserSetup: Record "User Setup";
        CurrencyCode: Code[20];
        CurrencyDate: Date;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        CheckManagement: Codeunit CheckManagement;
        Text001: label 'You do not have permission to perform this role\Contact Your Financial Director for Assistance.';
        Text002: label 'Are you sure you want to void %1?';
        Text003: label 'Cheque already apply to entry. Unapply the entries before this action.';
        Text004: label 'Inconsistency has occurred on the check application. The cheque amount does not agree with the attached documents.';
        Text005: label 'cannot be specified without %1';
        Text006: label '%1 %2 already used.';
        Text007: label 'Voucher(s) not attached';


    procedure GetNextLineNo(): Integer
    var
        EntryNo: Code[10];
        EntryNo2: Integer;
    begin
        PmtMgtSetup.Get;
        PmtMgtSetup.TestField(PmtMgtSetup."Check Entry No.");
        NoSeriesMgt.InitSeries(PmtMgtSetup."Check Entry No.",PmtMgtSetup."Check Entry No.",
          0D,EntryNo,PmtMgtSetup."Check Entry No.");
        Evaluate(EntryNo2,EntryNo);
        exit(EntryNo2);
    end;


    procedure CheckEntry()
    begin
        TestField("Check No.");
        TestField(Amount);
        TestField(Bank);
        TestField("Check Posting Date");
        TestField("Document No.");
        TestField(Payee);
        if (Bank <> '') and ("Currency Code" <> '') then begin
          BankAccount.Get(Bank);
          BankAccount.TestField("Currency Code","Currency Code");
        end;
        CalcFields("Attached Amount","WHT Amount");
        if "Attached Amount" = 0 then
          Error(Text007);
        if Amount <> ("Attached Amount" - "WHT Amount") then
          Error(Text004);
    end;


    procedure CheckUsedNo(): Boolean
    begin
        if (Bank = '') or ("Check No." = '') then
          exit(false);
        CheckLedgerEntry.SetCurrentkey("Bank Account No.","Entry Status","Check No.");
        CheckLedgerEntry.SetRange("Bank Account No.",Bank);
        CheckLedgerEntry.SetRange("Check No.","Check No.");
        exit(CheckLedgerEntry.FindFirst);
    end;


    procedure UpdateCheckLedger(UpdateOption: Option Insert,Delete,Void)
    begin
        case UpdateOption of
          0:begin
              TestField("Entry No.");
              TestField("Check No.");
              TestField(Bank);
              TestField(Payee);
              TestField(Amount);
              CalcFields("LedgerEntry Exist");
              if not("LedgerEntry Exist") then begin
                CheckLedgerEntry.Init;
                CheckLedgerEntry."Bank Account No." := Bank;
                CheckLedgerEntry."Posting Date" := "Check Posting Date";
                CheckLedgerEntry."Document Type" := 0;
                CheckLedgerEntry."Document No." :=  "Document No.";
                CheckLedgerEntry.Description := Description;
                CheckLedgerEntry.Amount := Amount;
                CheckLedgerEntry."Check No." := "Check No.";
                CheckLedgerEntry."Bank Payment Type" := CheckLedgerEntry."bank payment type"::"Computer Check";
                CheckLedgerEntry."Entry Status" := CheckLedgerEntry."entry status"::Printed;
                CheckLedgerEntry."Check Entry No." := "Entry No.";
                CheckLedgerEntry.Payee := Payee;
                CheckLedgerEntry."Check Date" := "Creation Date";
                CheckManagement.InsertCheck(CheckLedgerEntry,Rec.RecordId);
              end;
          end;
          1:begin
              CheckLedgerEntry.Reset;
              CheckLedgerEntry.SetCurrentkey("Bank Account No.","Entry Status","Check No.");
              CheckLedgerEntry.SetRange("Bank Account No.",Bank);
              CheckLedgerEntry.SetFilter(
                "Entry Status",'%1',
                CheckLedgerEntry."entry status"::Printed);
              CheckLedgerEntry.SetRange("Check No.","Check No.");
              CheckLedgerEntry.SetRange("Check Entry No.","Entry No.");
              CheckLedgerEntry.DeleteAll;
          end;
          2:begin
              TestField("Entry No.");
              TestField("Check No.");
              TestField(Bank);
              TestField(Payee);
              CalcFields("LedgerEntry Exist");
              if not("LedgerEntry Exist") then begin
                CheckLedgerEntry.Init;
                CheckLedgerEntry."Bank Account No." := Bank;
                CheckLedgerEntry."Posting Date" := "Check Posting Date";
                CheckLedgerEntry."Document Type" := 0;
                CheckLedgerEntry."Document No." :=  "Document No.";
                CheckLedgerEntry.Description := Description;
                CheckLedgerEntry.Amount := Amount;
                CheckLedgerEntry."Check No." := "Check No.";
                CheckLedgerEntry."Bank Payment Type" := CheckLedgerEntry."bank payment type"::"Computer Check";
                CheckLedgerEntry."Entry Status" := CheckLedgerEntry."entry status"::Voided;
                CheckLedgerEntry."Check Entry No." := "Entry No.";
                CheckLedgerEntry.Payee := Payee;
                CheckLedgerEntry."Check Date" := "Creation Date";
                CheckManagement.InsertCheck(CheckLedgerEntry,Rec.RecordId);
              end else begin
                CheckLedgerEntry.Reset;
                CheckLedgerEntry.SetCurrentkey("Bank Account No.","Entry Status","Check No.");
                CheckLedgerEntry.SetRange("Bank Account No.",Bank);
                CheckLedgerEntry.SetFilter(
                  "Entry Status",'%1',
                  CheckLedgerEntry."entry status"::Printed);
                CheckLedgerEntry.SetRange("Check No.","Check No.");
                CheckLedgerEntry.SetRange("Check Entry No.","Entry No.");
                CheckLedgerEntry.ModifyAll("Entry Status",CheckLedgerEntry."entry status"::Voided);
              end;
          end;

        end;
    end;


    procedure VoidCheck()
    begin
        CalcFields("Attached Amount");

        if not Confirm(Text002,false,"Check No.") then
          exit;

        if "Attached Amount" <> 0 then
          Error(Text003);

        UpdateCheckLedger(2);

        Delete;
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
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID,No,'',"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",0,0);

        if (OldDimSetID <> "Dimension Set ID") then begin
          Modify;
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
        if "Entry No." <> 0 then
          Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
          Modify;
        end;
    end;


    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet2(
            "Dimension Set ID",StrSubstNo('%1 %2','Check',"Check No."),
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
          Modify;
        end;
    end;
}

