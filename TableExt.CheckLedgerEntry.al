TableExtension 52000038 tableextension52000038 extends "Check Ledger Entry"
{
    fields
    {
        field(52092287; Payee; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(52092288; "Check Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52092289; "Voucher No."; Code[20])
        {
            CalcFormula = lookup("Posted Payment Header"."No." where("Cheque Entry No." = field("Check Entry No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}

