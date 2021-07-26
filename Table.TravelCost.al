Table 52092238 "Travel Cost"
{
    DrillDownPageID = "Travel Request Line Cost";

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(3;"Line No.";Integer)
        {
        }
        field(4;"Cost Code";Code[10])
        {
            TableRelation = "Travel Cost Group";

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("Cost Code") then
                  TestStatusOpen;

                if "Cost Code" <> '' then begin
                  GetTravelHeader;
                  GetTravelLine;
                  TravelCostGrp.Get("Cost Code");
                  Description := TravelCostGrp.Description;
                  "Account Name" := TravelCostGrp."Account Name";
                  "Account Code" := TravelCostGrp."Account Code" ;
                  "Voucher Type"  := TravelCostGrp."Payment Request Type";
                  EmpTravelSetup.Get(TravelHeader."Employee Category",TravelHeader."Travel Type",TravelLine."Travel Group","Cost Code");

                  if  TravelHeader."Currency Code" =  EmpTravelSetup."Currency Code"  then
                    "Unit Amount" :=  EmpTravelSetup.Amount;

                  if (TravelHeader."Currency Code" <> '') and (EmpTravelSetup."Currency Code" <> '') then begin
                    if (EmpTravelSetup."Currency Code" <> TravelHeader."Currency Code") then
                      "Unit Amount" := CurrencyExchange.ExchangeAmtFCYToFCY(TravelHeader."Document Date",EmpTravelSetup."Currency Code",
                                        TravelHeader."Currency Code",EmpTravelSetup.Amount);
                    if (EmpTravelSetup."Currency Code" = TravelHeader."Currency Code") then
                      "Unit Amount" :=  EmpTravelSetup.Amount;
                  end;
                  if (TravelCostGrp.Accommodation) and (TravelLine."Accommodation Provided") then
                    "Unit Amount" := 0;

                  Validate("No. of Nights",TravelLine."No. of Nights");
                end;
            end;
        }
        field(5;"No. of Nights";Decimal)
        {
            Caption = 'No. of Days';

            trigger OnValidate()
            var
                Factor: Decimal;
            begin
                TravelCostGrp.Get("Cost Code");
                if "In Lieu" then
                  Factor := 0.5
                else
                  Factor := 1;

                if TravelCostGrp."Per Night" then
                  Validate(Amount,("No. of Nights" * "Unit Amount" * Factor))
                else
                  Validate(Amount,"Unit Amount" * Factor);

                Validate("Amount (LCY)");
            end;
        }
        field(6;"Unit Amount";Decimal)
        {
        }
        field(8;Amount;Decimal)
        {
        }
        field(9;"Amount (LCY)";Decimal)
        {

            trigger OnValidate()
            begin
                GetTravelHeader;
                TravelHeader.TestField("Document Date");
                if TravelHeader."Currency Code" <> '' then begin
                  TravelHeader.TestField("Currency Factor");
                  "Amount (LCY)" :=
                    CurrencyExchange.ExchangeAmtFCYToLCY(
                      TravelHeader."Document Date",TravelHeader."Currency Code",
                      Amount,TravelHeader."Currency Factor");
                end else
                  "Amount (LCY)" := Amount;
            end;
        }
        field(10;Description;Text[50])
        {
        }
        field(12;"Account Code";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(13;"Voucher Type";Option)
        {
            OptionCaption = 'Direct Expense,Cash Advance,Purchase Invoice';
            OptionMembers = "Direct Expense","Cash Advance","Purchase Invoice";
        }
        field(14;"In Lieu";Boolean)
        {

            trigger OnValidate()
            begin
                Validate("No. of Nights");
                if "In Lieu" then
                  "Voucher Type" := "voucher type"::"Direct Expense"
                else
                  "Voucher Type" := "voucher type"::"Cash Advance"
            end;
        }
        field(15;"Account Name";Text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.","Cost Code")
        {
            Clustered = true;
            SumIndexFields = "Amount (LCY)",Amount;
        }
        key(Key2;"Account Code","Document No.")
        {
            SumIndexFields = "Amount (LCY)",Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestStatusOpen
    end;

    trigger OnInsert()
    begin
        TestStatusOpen;
    end;

    trigger OnModify()
    begin
        TestStatusOpen
    end;

    trigger OnRename()
    begin
        TestStatusOpen
    end;

    var
        TravelHeader: Record "Travel Header";
        TravelLine: Record "Travel Line";
        EmpTravelSetup: Record "Employee Travel Setup";
        CurrencyExchange: Record "Currency Exchange Rate";
        TravelCostGrp: Record "Travel Cost Group";
        StatusCheckSuspended: Boolean;


    procedure GetTravelHeader()
    begin
        TravelHeader.Get("Document No.");
    end;


    procedure GetTravelLine()
    begin
        TravelLine.Get("Document No.","Line No.");
    end;


    procedure TestStatusOpen()
    begin
        if StatusCheckSuspended then
          exit;
        GetTravelHeader;
        TravelHeader.TestField(Status,TravelHeader.Status::Open);
    end;


    procedure SuspendStatusCheck(var Suspend: Boolean): Boolean
    begin
        StatusCheckSuspended := Suspend;
    end;
}

