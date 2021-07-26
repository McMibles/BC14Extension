TableExtension 52000018 tableextension52000018 extends "Gen. Journal Line" 
{
    fields
    {
        field(52092144;"Loan ID";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52092287;"Cash Advance Doc. No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For Cash Advance Treatment';
        }
        field(52092288;"Entry Type";Option)
        {
            DataClassification = ToBeClassified;
            Description = 'For Cash Advance Treatment';
            OptionCaption = ' ,Cash Advance,Cash Adv. Payment,Retirement,Retirement Payment,Retirement Receipt';
            OptionMembers = " ","Cash Advance","Cash Adv. Payment",Retirement,"Retirement Payment","Retirement Receipt";
        }
        field(52092337;"Consignment Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092338;"Consignment Charge Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092339;"Order No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092340;"Direct Cost Invoice";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092341;"Final Invoice";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092342;"FA WIP No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Job;
        }
        field(52130423;"WHT Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130424;"WHT Amount (LCY)";Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130425;"WHT Posting Group";Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
            TableRelation = "WHT Posting Group";
        }
        field(52130426;"Source Vend/Cust  No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
            TableRelation = if ("Account Type"=const(Customer)) Customer where (Type=const(Customer))
                            else if ("Account Type"=const(Vendor)) Vendor where (Type=const("Trade Creditor"));
        }
        field(52130427;"Vend/Cust Entry No.";Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130428;"Source Invoice No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130429;"Source Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130430;"WHT Base Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';

            trigger OnValidate()
            begin
                /*GetCurrency;
                IF "Currency Code" = '' THEN
                  "WHT Base Amount (LCY)" := "WHT Base Amount"
                ELSE
                  "WHT Base Amount (LCY)" := ROUND(
                      CurrExchRate.ExchangeAmtFCYToLCY(
                        "Posting Date","Currency Code",
                        "WHT Base Amount","Currency Factor"));*/

            end;
        }
        field(52130431;"WHT Base Amount (LCY)";Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130432;"Source Curr. WHT Base Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Source Curr. VAT Base Amount';
            DataClassification = ToBeClassified;
            Description = 'For WHT';
            Editable = false;
        }
        field(52130433;"Source Curr. WHT Amount";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Source Curr. VAT Amount';
            DataClassification = ToBeClassified;
            Description = 'For WHT';
            Editable = false;
        }
        field(52130434;"WHT Line";Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130435;"Source Order No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
    }
}

