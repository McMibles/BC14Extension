Table 52092364 "BFC Amended Details"
{
    Caption = 'BFC Amended Details';
    DataCaptionFields = "No.", Description;
    //DrillDownPageID = "BFC Amended List";
    //LookupPageID = "BFC Amended List";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    LCSetup.Get;
                    NoSeriesMgt.TestManual(LCSetup."Amended Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "BFC No."; Code[20])
        {
            Caption = 'LC No.';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(5; "Issued To/Received From"; Code[20])
        {
            Caption = 'Issued To/Received From';
            TableRelation = Vendor;
        }
        field(6; "Issuing Bank"; Code[20])
        {
            Caption = 'Issuing Bank';
            TableRelation = "Bank Account";
        }
        field(7; "Date of Issue"; Date)
        {
            Caption = 'Date of Issue';
        }
        field(8; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';

            trigger OnValidate()
            begin
                if "Date of Issue" <> 0D then
                    if "Date of Issue" > "Expiry Date" then
                        Error(Text003);
                BFCDetails.Get("BFC No.");
                BFCDetails."Expiry Date" := "Expiry Date";
                BFCDetails.Modify;
            end;
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(12; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(13; "BFC Amount"; Decimal)
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
                    "BFC Amount LCY" := ROUND("BFC Amount" * "Exchange Rate", Currency."Amount Rounding Precision");
                end else
                    "BFC Amount LCY" := "BFC Amount";


                /*BankCrLimit.SETRANGE("Bank No.","Issuing Bank");
                BankCrLimit.SETFILTER("From Date",'<= %1',"Date of Issue");
                BankCrLimit.SETFILTER("To Date",'>=%1',"Date of Issue");
                IF BankCrLimit.FINDLAST THEN BEGIN
                  BFCDetails.RESET;
                  BFCDetails.SETRANGE("Issuing Bank",BankCrLimit."Bank No.");
                  IF BankCrLimit."To Date" <> 0D THEN
                    BFCDetails.SETFILTER("Date of Issue",'%1..%2',BankCrLimit."From Date",BankCrLimit."To Date")
                  ELSE
                    BFCDetails.SETFILTER("Date of Issue",'>=%1',BankCrLimit."From Date");
                  BFCDetails.SETFILTER("No.",'<>%1',"BFC No.");
                  IF BFCDetails.FIND('-') THEN
                    REPEAT
                      IF BFCDetails."Latest Amended Value" = 0 THEN
                        TotalAmount := TotalAmount + BFCDetails."Amount LCY"
                      ELSE
                        TotalAmount := TotalAmount + BFCDetails."Latest Amended Value";
                    UNTIL BFCDetails.NEXT = 0;
                  IF TotalAmount + "BFC Amount LCY" > BankCrLimit.Amount THEN
                    ERROR(Text004);
                END ELSE
                  IF "BFC Amount" <> 0 THEN
                    ERROR(Text005);
                
                
                //CALCFIELDS("Value Utilised");
                IF "BFC Amount LCY" < "Value Utilised" THEN
                  ERROR(Text006);
                "Remaining Amount" := "BFC Amount LCY" - "Value Utilised";*/
                BFCDetails.Get("BFC No.");
                BFCDetails."Latest Amended Value" := "BFC Amount LCY";
                if "BFC Amount" <> 0 then
                    BFCDetails.Amount := "BFC Amount";
                //BFCDetails."Remaining Amount" := "BFC Amount LCY" - "Value Utilised";
                BFCDetails."Amount LCY" := "BFC Amount LCY";
                BFCDetails.Modify;

            end;
        }
        field(14; "Value Utilised"; Decimal)
        {
            Caption = 'Value Utilised';
            Editable = false;
            FieldClass = Normal;
        }
        field(15; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining Amount';
            Editable = false;
        }
        field(16; "BFC Amended Date"; Date)
        {
            Caption = 'LC Amended Date';
        }
        field(17; Released; Boolean)
        {
            Caption = 'Released';
            Editable = false;
        }
        field(18; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(21; "Exchange Rate"; Decimal)
        {
            Caption = 'Exchange Rate';
        }
        field(22; "BFC Amount LCY"; Decimal)
        {
            Caption = 'LC Value LCY';
            Editable = false;
        }
        field(23; "Receiving Bank"; Code[20])
        {
            Caption = 'Receiving Bank';
        }
        field(25; "Bank Amended No."; Code[20])
        {
            Caption = 'Bank Amended No.';
        }
        field(26; "Revolving Cr. Limit Types"; Option)
        {
            Caption = 'Revolving Cr. Limit Types';
            OptionCaption = ' ,Automatic,Manual';
            OptionMembers = " ",Automatic,Manual;
        }
        field(27; "Previous BFC Amount"; Decimal)
        {
            Caption = 'Previous LC Value';
        }
        field(28; "Previous Expiry Date"; Date)
        {
            Caption = 'Previous Expiry Date';
        }
    }

    keys
    {
        key(Key1; "No.", "BFC No.")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if Released then
            Error(Text002);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            LCSetup.Get;
            //LCSetup.TestField("Amended Nos.");
            NoSeriesMgt.InitSeries(LCSetup."Amended Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    trigger OnModify()
    begin
        if Closed then
            Error(Text001);
    end;

    var
        LCSetup: Record "LC Setup";
        BFCDetails: Record "Bills for Collection";
        //BankCrLimit: Record "Bank LC Limit Details";
        BFCADetails: Record "BFC Amended Details";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'You cannot modify the Document.';
        Text002: label 'You cannot delete the document.';
        Text003: label 'Expiry Date cannot be before Issue Date.';
        Text004: label 'Bills for Collection(s) Amount exceeds the credit limit available for this bank.';
        Text005: label 'Banks credit limit is Zero.';
        Text006: label 'Bills for Collection Amount cannot be lower than the Value Utilised.';


    procedure AssistEdit(OldBFCADetails: Record "BFC Amended Details"): Boolean
    begin
        with BFCADetails do begin
            BFCADetails := Rec;
            LCSetup.Get;
            //LCSetup.TestField("Amended Nos.");
            if NoSeriesMgt.SelectSeries(LCSetup."Amended Nos.", OldBFCADetails."No. Series", "No. Series") then begin
                LCSetup.Get;
                //LCSetup.TestField("Amended Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := BFCADetails;
                exit(true);
            end;
        end;
    end;
}

