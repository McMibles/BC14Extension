TableExtension 52000039 tableextension52000039 extends "Bank Acc. Reconciliation" 
{
    fields
    {

        //Unsupported feature: Code Modification on ""Bank Account No."(Field 1).OnValidate".

        //trigger "(Field 1)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF "Statement No." = '' THEN BEGIN
              BankAcc.GET("Bank Account No.");

              IF "Statement Type" = "Statement Type"::"Payment Application" THEN BEGIN
                SetLastPaymentStatementNo(BankAcc);
                "Statement No." := INCSTR(BankAcc."Last Payment Statement No.");
            #7..12
            END;

            CreateDim(DATABASE::"Bank Account",BankAcc."No.");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            IF "Statement No." = '' THEN BEGIN
              BankAcc.GET("Bank Account No.");
              "Bank Account Name" := BankAcc.Name;
            #4..15
            */
        //end;
        field(52132624;"Bank Account Name";Text[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
}

