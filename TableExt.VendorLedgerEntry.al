TableExtension 52000007 tableextension52000007 extends "Vendor Ledger Entry" 
{
    fields
    {
        field(52092287;"Payment Account No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = if ("Payment Currency Code"=filter('')) "Bank Account"
                            else if ("Payment Currency Code"=filter(<>'')) "Bank Account" where ("Currency Code"=field("Payment Currency Code"));
        }
        field(52092288;"Payment Method";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Cash,Cheque,E-Payment';
            OptionMembers = " ",Cash,Cheque,"E-Payment";
        }
        field(52092289;"Payment Currency Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Currency;
        }
        field(52092290;"Amount to Pay";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092291;"Mark to Pay";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092337;"PO No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52130423;"WHT Posting Group";Code[10])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130424;"Source Vendor No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130425;"Vendor Entry No.";Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130426;"Source PI No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130427;"Source PO No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130428;"Source Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
    }
}

