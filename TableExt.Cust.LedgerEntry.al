TableExtension 52000005 tableextension52000005 extends "Cust. Ledger Entry" 
{
    fields
    {
        field(52130423;"WHT Posting Group";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WHT Posting Group";
        }
        field(52130424;"Source Customer No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
            TableRelation = Customer;
        }
        field(52130425;"Customer Entry No.";Integer)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130426;"Source Amount";Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
        field(52130427;"Source Invoice No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'For WHT';
        }
    }
}

