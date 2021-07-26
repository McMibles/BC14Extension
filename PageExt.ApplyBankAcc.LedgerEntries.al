PageExtension 52000031 pageextension52000031 extends "Apply Bank Acc. Ledger Entries" 
{
    procedure ShowMatched()
    begin
        SetRange("Statement Status","statement status"::"Bank Acc. Entry Applied");
        SetFilter("Statement No.",'<>%1','');
        SetFilter("Statement Line No.",'<>0');
        CurrPage.Update;
    end;
}

