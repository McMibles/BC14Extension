Table 52092363 "Bills for Collection"
{
    Caption = 'Bills for Collection';
    DataCaptionFields = "No.", Description;
    //DrillDownPageID = "Bill for Collections List";
    //LookupPageID = "Bill for Collections List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    LCSetup.Get;
                    NoSeriesMgt.TestManual(LCSetup."Bills for Collection Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Issued To/Received From"; Code[20])
        {
            Caption = 'Issued To/Received From';
            TableRelation = Vendor where(Type = const("Trade Creditor"));

            trigger OnValidate()
            begin
                if "Issued To/Received From" <> xRec."Issued To/Received From" then begin
                    "Issuing Bank" := '';
                    Amount := 0;
                end;
            end;
        }
        field(5; "Issuing Bank"; Code[20])
        {
            Caption = 'Issuing Bank';

            trigger OnLookup()
            begin
                Clear(Bankform);
                Bankform.LookupMode(true);
                Bankform.SetTableview(Bank);
                if Bankform.RunModal = Action::LookupOK then begin
                    Bankform.GetRecord(Bank);
                    if not Released then
                        "Issuing Bank" := Bank."No.";
                end;
            end;

            trigger OnValidate()
            begin
                if "Issuing Bank" <> xRec."Issuing Bank" then
                    Amount := 0;
            end;
        }
        field(6; "Date of Issue"; Date)
        {
            Caption = 'Date of Issue';

            trigger OnValidate()
            begin
                if "Expiry Date" <> 0D then
                    if "Date of Issue" > "Expiry Date" then
                        Error(Text13703);
            end;
        }
        field(7; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';

            trigger OnValidate()
            begin
                if "Date of Issue" <> 0D then
                    if "Date of Issue" > "Expiry Date" then
                        Error(Text13700);
            end;
        }
        field(10; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency.Code;

            trigger OnValidate()
            begin
                if "Currency Code" <> '' then begin
                    CurrExchRate.SetRange("Currency Code", "Currency Code");
                    CurrExchRate.SetRange("Starting Date", 0D, "Date of Issue");
                    CurrExchRate.FindLast;
                    "Exchange Rate" := CurrExchRate."Relational Exch. Rate Amount" / CurrExchRate."Exchange Rate Amount";
                end;
                Validate(Amount);
            end;
        }
        field(11; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(12; Amount; Decimal)
        {
            Caption = 'LC Value';

            trigger OnValidate()
            var
                Currency: Record Currency;
                TotalAmount: Decimal;
            begin
                Clear(TotalAmount);
                if "Currency Code" <> '' then begin
                    Currency.Get("Currency Code");
                    "Amount LCY" := ROUND(Amount * "Exchange Rate", Currency."Amount Rounding Precision");
                end else
                    "Amount LCY" := Amount;

                /*BankCrLimit.SETRANGE("Bank No.","Issuing Bank");
                BankCrLimit.SETFILTER("From Date",'<= %1',"Date of Issue");
                BankCrLimit.SETFILTER("To Date",'>=%1',"Date of Issue");
                IF BankCrLimit.FINDLAST THEN BEGIN
                  BillsForCollection.RESET;
                  BillsForCollection.SETRANGE("Issuing Bank",BankCrLimit."Bank No.");
                  IF BankCrLimit."To Date" <> 0D THEN
                    BillsForCollection.SETFILTER("Date of Issue",'%1..%2',BankCrLimit."From Date",BankCrLimit."To Date")
                  ELSE
                    BillsForCollection.SETFILTER("Date of Issue",'>=%1',BankCrLimit."From Date");
                  BillsForCollection.SETFILTER("No.",'<>%1',"No.");
                  IF BillsForCollection.FIND('-') THEN
                    REPEAT
                      IF BillsForCollection."Latest Amended Value" = 0 THEN
                        TotalAmount := TotalAmount + BillsForCollection."Amount LCY"
                      ELSE
                        TotalAmount := TotalAmount + BillsForCollection."Latest Amended Value";
                    UNTIL BillsForCollection.NEXT = 0;
                  IF TotalAmount + "Amount LCY"> BankCrLimit.Amount THEN
                    ERROR(Text13704);
                END ELSE
                  IF Amount <> 0 THEN
                    ERROR(Text13705);*/

                //CALCFIELDS("Value Utilised");
                //"Remaining Amount" := "Amount LCY" - "Value Utilised";
                "Latest Amended Value" := "Amount LCY";

            end;
        }
        field(13; "Value Utilised"; Decimal)
        {
            // CalcFormula = sum("LC Orders"."Order Value" where("LC No." = field("No.")));
            Caption = 'Value Utilised';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = false;
        }
        field(15; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(16; Released; Boolean)
        {
            Caption = 'Released';
            Editable = false;
        }
        field(18; "Latest Amended Value"; Decimal)
        {
            Caption = 'Latest Amended Value';
            Editable = false;
        }
        field(21; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';

            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(22; "Amount LCY"; Decimal)
        {
            Caption = 'LC Value LCY';
            Editable = false;
        }
        field(25; "Renewed Amount"; Decimal)
        {
            //CalcFormula = sum("LC Orders"."Order Value" where("LC No." = field("No."),
            //                                                  Renewed = const(true)));
            Caption = 'Renewed Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5002; "Consign. Shipment  Start Date"; Date)
        {

            trigger OnValidate()
            begin
                if Format("Payment Expiry No. of days") <> '' then
                    "Maturity Date" := CalcDate("Payment Expiry No. of days", "Consign. Shipment  Start Date");
            end;
        }
        field(5003; "Payment Expiry No. of days"; DateFormula)
        {

            trigger OnValidate()
            begin
                if Format("Payment Expiry No. of days") <> '' then
                    "Maturity Date" := CalcDate("Payment Expiry No. of days", "Consign. Shipment  Start Date");
            end;
        }
        field(5004; "Notification Start Date"; Date)
        {
        }
        field(5005; "Maturity Date"; Date)
        {
            Editable = false;
        }
        field(5006; "No. of Amendments"; Integer)
        {
            //CalcFormula = count("LC Amended Details" where("LC No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Date of Issue", "Issuing Bank")
        {
            SumIndexFields = Amount, "Amount LCY";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Released then
            Error(Text13702);

        BFCAmendments.LockTable;
        BFCAmendments.SetRange("BFC No.", "No.");
        BFCAmendments.DeleteAll;
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            LCSetup.Get;
            LCSetup.TestField("Bills for Collection Nos.");
            NoSeriesMgt.InitSeries(LCSetup."Bills for Collection Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
        "Date of Issue" := WorkDate;
    end;

    trigger OnModify()
    begin
        if Closed then
            Error(Text13701);
    end;

    var
        LCSetup: Record "LC Setup";
        BillsForCollection: Record "Bills for Collection";
        Bank: Record "Bank Account";
        BankCrLimit: Record "Bank LC Limit Details";
        LCTerms: Record "LC Terms";
        BFCAmendments: Record "BFC Amended Details";
        Bankform: Page "Bank Account List";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        VendBank: Record "Vendor Bank Account";
        VendBankForm: Page "Vendor Bank Account List";
        CurrExchRate: Record "Currency Exchange Rate";
        Text13700: label 'Expiry Date cannot be before Issue Date.';
        Text13701: label 'You cannot modify.';
        Text13702: label 'You cannot delete.';
        Text13703: label 'Issue Date cannot be after Expiry Date.';
        Text13704: label 'Bills for Collection(s) value exceeds the credit limit available for this bank.';
        Text13705: label 'Bank''''s credit limit is zero.';


    procedure AssistEdit(OldBillsForCollection: Record "Bills for Collection"): Boolean
    begin
        with BillsForCollection do begin
            BillsForCollection := Rec;
            LCSetup.Get;
            LCSetup.TestField("Bills for Collection Nos.");
            if NoSeriesMgt.SelectSeries(LCSetup."Bills for Collection Nos.", OldBillsForCollection."No. Series", "No. Series") then begin
                LCSetup.Get;
                LCSetup.TestField("Bills for Collection Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := BillsForCollection;
                exit(true);
            end;
        end;
    end;
}

