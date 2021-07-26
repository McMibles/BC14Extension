TableExtension 52000041 tableextension52000041 extends "Bank Account Statement" 
{
    procedure CheckPostedRecon(BankCode: Code[20];PostingDate: Date)
    var
        Err001: label 'Bank account already reconciled for this period\Posting of this entry will distort reconciliation\Please contact your FC';
    begin
        SetRange("Bank Account No.",BankCode);
        if FindLast then begin
          if PostingDate <= "Statement Date" then
            Error(Err001)
        end;
    end;
}

