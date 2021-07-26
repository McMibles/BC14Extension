TableExtension 52000040 tableextension52000040 extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        field(52092287; "Unpresented Payment"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Uncredited Payment", false);
                if Type = Type::Difference
                  then
                    Error(Text60005);
                RemoveApplication(Type);
                if "Unpresented Payment" then begin
                    TestField("Statement Amount");
                    if "Statement Amount" > 0 then Error(Text60003);
                    "Unpresented Amount" := "Statement Amount";
                    "Statement Amount" := 0;
                    Difference := 0;
                    Modify
                end else begin
                    TestField("Unpresented Amount");
                    "Statement Amount" := "Unpresented Amount";
                    Difference := "Statement Amount";
                    "Unpresented Amount" := 0;
                    Modify;
                end;
            end;
        }
        field(52092288; "Uncredited Payment"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Unpresented Payment", false);
                if Type = Type::Difference then Error(Text60005);
                RemoveApplication(Type);
                if "Uncredited Payment" then begin
                    TestField("Statement Amount");
                    if "Statement Amount" < 0 then Error(Text60004);
                    "Uncredited Amount" := "Statement Amount";
                    "Statement Amount" := 0;
                    Difference := 0;
                    Modify;
                end else begin
                    TestField("Uncredited Amount");
                    "Statement Amount" := "Uncredited Amount";
                    Difference := "Statement Amount";
                    "Uncredited Amount" := 0;
                    Modify;
                end;
            end;
        }
        field(52092289; "Unpresented Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092290; "Uncredited Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092291; "Credit in Statement"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Uncredited Payment", false);
                TestField("Unpresented Payment", false);
                TestField("Debit in Statement", false);
                Validate(Type, Type::Difference);
                if ("Statement Amount" <> 0) and ("Statement Amount" < 0) then
                    Error(Text60006);
            end;
        }
        field(52092292; "Debit in Statement"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TestField("Uncredited Payment", false);
                TestField("Unpresented Payment", false);
                TestField("Credit in Statement", false);
                Validate(Type, Type::Difference);
                if ("Statement Amount" <> 0) and ("Statement Amount" > 0) then
                    Error(Text60007);
            end;
        }
        field(52092293; "Exclude from Summation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    Local procedure RemoveApplication(AppliedType: Option)
    begin
        IF "Statement Type" = "Statement Type"::"Bank Reconciliation" THEN
            CASE AppliedType OF
                Type::"Bank Account Ledger Entry":
                    BEGIN
                        BankAccLedgEntry.RESET;
                        BankAccLedgEntry.SETCURRENTKEY("Bank Account No.", Open);
                        BankAccLedgEntry.SETRANGE("Bank Account No.", "Bank Account No.");
                        BankAccLedgEntry.SETRANGE(Open, TRUE);
                        BankAccLedgEntry.SETRANGE(
                          "Statement Status", BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
                        BankAccLedgEntry.SETRANGE("Statement No.", "Statement No.");
                        BankAccLedgEntry.SETRANGE("Statement Line No.", "Statement Line No.");
                        BankAccLedgEntry.LOCKTABLE;
                        CheckLedgEntry.LOCKTABLE;
                        IF BankAccLedgEntry.FIND('-') THEN
                            REPEAT
                                BankAccSetStmtNo.RemoveReconNo(BankAccLedgEntry, Rec, TRUE);
                            UNTIL BankAccLedgEntry.NEXT = 0;
                        "Applied Entries" := 0;
                        VALIDATE("Applied Amount", 0);
                        MODIFY;
                    END;
                Type::"Check Ledger Entry":
                    BEGIN
                        CheckLedgEntry.RESET;
                        CheckLedgEntry.SETCURRENTKEY("Bank Account No.", Open);
                        CheckLedgEntry.SETRANGE("Bank Account No.", "Bank Account No.");
                        CheckLedgEntry.SETRANGE(Open, TRUE);
                        CheckLedgEntry.SETRANGE(
                          "Statement Status", CheckLedgEntry."Statement Status"::"Check Entry Applied");
                        CheckLedgEntry.SETRANGE("Statement No.", "Statement No.");
                        CheckLedgEntry.SETRANGE("Statement Line No.", "Statement Line No.");
                        BankAccLedgEntry.LOCKTABLE;
                        CheckLedgEntry.LOCKTABLE;
                        IF CheckLedgEntry.FIND('-') THEN
                            REPEAT
                                CheckSetStmtNo.RemoveReconNo(CheckLedgEntry, Rec, TRUE);
                            UNTIL CheckLedgEntry.NEXT = 0;
                        "Applied Entries" := 0;
                        VALIDATE("Applied Amount", 0);
                        "Check No." := '';
                        MODIFY;
                    END;
            END;
    end;

    var

        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        BankAccSetStmtNo: Codeunit "Bank Acc. Entry Set Recon.-No.";
        CheckSetStmtNo: Codeunit "Check Entry Set Recon.-No.";

        Text60003: label 'Unpresented cheque amount can not be positive';
        Text60004: label 'Uncredited cheque amount can not be negative';
        Text60005: label 'Operation can not be performed';
        Text60006: label 'Credit in statement amount can not be negative';
        Text60007: label 'Debit in statement amount can not be positive';

}

