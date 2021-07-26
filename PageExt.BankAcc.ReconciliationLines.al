PageExtension 52000030 pageextension52000030 extends "Bank Acc. Reconciliation Lines" 
{
    layout
    {
        addafter(Description)
        {
            field("Unpresented Payment";"Unpresented Payment")
            {
                ApplicationArea = Basic;
            }
            field("Uncredited Payment";"Uncredited Payment")
            {
                ApplicationArea = Basic;
            }
            field("Unpresented Amount";"Unpresented Amount")
            {
                ApplicationArea = Basic;
            }
            field("Uncredited Amount";"Uncredited Amount")
            {
                ApplicationArea = Basic;
            }
            field("Credit in Statement";"Credit in Statement")
            {
                ApplicationArea = Basic;
            }
            field("Debit in Statement";"Debit in Statement")
            {
                ApplicationArea = Basic;
            }
            field("Exclude from Summation";"Exclude from Summation")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter(ApplyEntries)
        {
            action("Merge Statement Lines")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                var
                    BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
                    TempBankAccReconLine: Record "Bank Acc. Reconciliation Line" temporary;
                begin
                    CurrPage.SetSelectionFilter(BankAccReconciliationLine);
                    if BankAccReconciliationLine.FindSet then begin
                      repeat
                        BankAccReconciliationLine.TestField("Applied Amount",0);
                        if TempBankAccReconLine.IsEmpty then begin
                          TempBankAccReconLine := BankAccReconciliationLine;
                          TempBankAccReconLine.Insert;
                        end else begin
                          TempBankAccReconLine.FindFirst;
                          TempBankAccReconLine."Statement Amount" += BankAccReconciliationLine."Statement Amount";
                          TempBankAccReconLine.Modify;
                        end;
                      until BankAccReconciliationLine.Next = 0;
                      BankAccReconciliationLine.DeleteAll;
                      BankAccReconciliationLine := TempBankAccReconLine;
                      BankAccReconciliationLine.Validate("Statement Amount");
                      BankAccReconciliationLine.Insert;
                    end;
                end;
            }
        }
    }

    procedure ShowMatched()
    begin
        SetFilter(Difference,'%1',0);
        CurrPage.Update;
    end;
}

