TableExtension 52000042 tableextension52000042 extends "Bank Account Statement Line" 
{
    fields
    {
        field(52092287;"Unpresented Payment";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092288;"Uncredited Payment";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092289;"Unpresented Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092290;"Uncredited Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092291;"Credit in Statement";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092292;"Debit in Statement";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092293;"Exclude from Summation";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

