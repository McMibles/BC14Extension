TableExtension 52000063 tableextension52000063 extends "Employee Posting Group" 
{
    fields
    {
        field(52092287;"Cash Adv. Receivable Acc.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
    }
}

