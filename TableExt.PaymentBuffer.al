TableExtension 52000046 tableextension52000046 extends "Payment Buffer" 
{
    fields
    {
        field(52092287;"Paying Account No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
    }
}

