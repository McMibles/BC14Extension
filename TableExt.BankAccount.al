TableExtension 52000037 tableextension52000037 extends "Bank Account" 
{
    fields
    {
        field(52092308;"CBN Bank Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;
        }
    }
}

