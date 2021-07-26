TableExtension 52000065 tableextension52000065 extends "Employee Payment Buffer" 
{
    fields
    {
        field(52092287;"Paying Account No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(52092288;"Entry Type";Integer)
        {
            DataClassification = ToBeClassified;
        }
    }
}

