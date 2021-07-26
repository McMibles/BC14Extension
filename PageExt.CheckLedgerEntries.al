PageExtension 52000028 pageextension52000028 extends "Check Ledger Entries" 
{
    actions
    {

        //Unsupported feature: Code Modification on ""Void Check"(Action 36).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CheckManagement.FinancialVoidCheck(Rec);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            PaymentMgt.GET;
            CASE PaymentMgt."Posted Cheque Voiding  By" OF
              PaymentMgt."Posted Cheque Voiding  By"::"Standard Code":
                CheckManagement.FinancialVoidCheck(Rec);
              PaymentMgt."Posted Cheque Voiding  By"::"Custom Code":
                CustomCheckMgt.FinancialVoidCheck(Rec);
            END;
            */
        //end;
    }

    var
        CustomCheckMgt: Codeunit "Custom CheckManagement";
        PaymentMgt: Record "Payment Mgt. Setup";
}

