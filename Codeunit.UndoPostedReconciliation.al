Codeunit 52092224 "Undo Posted Reconciliation"
{
    // Option A Start
    //   lBankAccLedgEntry := BankAccLedgEntry;
    //   lBankAccLedgEntry.Open := TRUE;
    //   lBankAccLedgEntry."Statement Status" := lBankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied";
    //   lBankAccLedgEntry.MODIFY;
    // Option A End
    // 
    // Option B Start
    //   BankAccLedgEntry.Modifyall(open,TRUE);
    //   BankAccLedgEntry.Modifyall("Statement Status",BankAccLedgEntry."Statement Status"::"Bank Acc. Entry Applied");
    // Option B End

    Permissions = TableData "Bank Account Ledger Entry"=rimd,
                  TableData "Check Ledger Entry"=rimd,
                  TableData "Bank Account Statement"=rimd,
                  TableData "Bank Account Statement Line"=rimd;
    TableNo = "Bank Account Statement";

    trigger OnRun()
    begin
        Window.Open(
          '#1#################################\\' +
          Text000);
        Window.Update(1,StrSubstNo('%1 %2',"Bank Account No.","Statement No."));

        TestField("Statement Date");
        CheckLaterStatements(Rec);
        Post(Rec);

        // Copy and delete statement
        BankAcctStmtLine.Reset;
        BankAcctStmtLine.SetRange("Bank Account No.","Bank Account No.");
        BankAcctStmtLine.SetRange("Statement No.","Statement No.");
        if BankAcctStmtLine.Find('-') then
          repeat
            BankAccReconLine.TransferFields(BankAcctStmtLine);
            BankAccReconLine.Insert;
          until BankAcctStmtLine.Next = 0;
        BankAcctStmtLine.DeleteAll;

        BankAccRecon.TransferFields(Rec);
        BankAccRecon.Insert;
        Delete;

        Window.Close;
    end;

    var
        BankAcctStmtLine: Record "Bank Account Statement Line";
        BankAcctStmtLine2: Record "Bank Account Statement Line";
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        BankAccRecon: Record "Bank Acc. Reconciliation";
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
        TotalAmount: Decimal;
        TotalAppliedAmount: Decimal;
        TotalDiff: Decimal;
        Lines: Integer;
        Window: Dialog;
        Text000: label 'Reversing lines              #2######';
        Text001: label '%1 is not equal to Total Balance';
        Text002: label 'Nothing to reverse';
        Text003: label 'The application is not correct. The total amount applied is %1; it should be %2.';
        Text004: label 'The total difference is %1. It must be %2.';
        Text005: label 'This reconciliation can not be reversed because there is a reconciliation %1 in a later date\You must first reverse the later date reconciliation';

    local procedure CheckLaterStatements(lBankAccStmt: Record "Bank Account Statement")
    var
        BankAccStmt: Record "Bank Account Statement";
    begin
        //Check if there are no later date statements
        BankAccStmt.Reset;
        BankAcc.LockTable;
        BankAcc.Get(lBankAccStmt."Bank Account No.");
        BankAcc.TestField(BankAcc.Blocked,false);
        BankAccStmt.SetRange("Bank Account No.",lBankAccStmt."Bank Account No.");
        BankAccStmt.SetFilter("Statement Date",'>%1',lBankAccStmt."Statement Date");
        if BankAccStmt.FindFirst then
          Error(Text005,BankAccStmt."Statement No.");
    end;

    local procedure Post(lBankAccStmt: Record "Bank Account Statement")
    var
        AppliedAmount: Decimal;
        BankStmtLineDiffAmt: Decimal;
        BankStmtLineStmtAmt: Decimal;
    begin
        //Run through lines
        BankAcctStmtLine.Reset;
        BankAcctStmtLine.SetRange("Bank Account No.",lBankAccStmt."Bank Account No.");
        BankAcctStmtLine.SetRange("Statement No.",lBankAccStmt."Statement No.");
        BankAcctStmtLine.CalcSums(Difference);
        BankStmtLineDiffAmt := BankAcctStmtLine.Difference;


        TotalAmount := 0;
        TotalAppliedAmount := 0;
        TotalDiff := 0;
        Lines := 0;
        if BankAcctStmtLine.Find('-') then begin
          BankAccLedgEntry.LockTable;
          CheckLedgEntry.LockTable;
          repeat
            Lines := Lines + 1;
            Window.Update(2,Lines);
            AppliedAmount := 0;
            // Adjust entries
            // Test amount and settled amount
            case BankAcctStmtLine.Type of
              BankAcctStmtLine.Type::"Bank Account Ledger Entry":
                OpenBankLedgerEntry(BankAcctStmtLine,AppliedAmount);
              BankAcctStmtLine.Type::"Check Ledger Entry":
                OpenCheckLedgerEntry(BankAcctStmtLine,AppliedAmount);
              BankAcctStmtLine.Type::Difference:
                TotalDiff := TotalDiff + BankAcctStmtLine."Statement Amount";
            end;
            BankAcctStmtLine.TestField("Applied Amount",AppliedAmount);
            TotalAmount := TotalAmount + BankAcctStmtLine."Statement Amount";
            TotalAppliedAmount := TotalAppliedAmount + AppliedAmount;
          until BankAcctStmtLine.Next = 0;

        end else
          Error(Text002);

        // Test amount
        if TotalAmount <> TotalAppliedAmount + TotalDiff then
          Error(
            Text003,
            TotalAppliedAmount + TotalDiff,TotalAmount);

        if BankStmtLineDiffAmt  <> TotalDiff then
          Error(Text004,BankStmtLineDiffAmt,TotalDiff);

        UpdateBank(lBankAccStmt,TotalAmount);
    end;

    local procedure OpenBankLedgerEntry(BankAcctStmtLine: Record "Bank Account Statement Line";var AppliedAmount: Decimal)
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        lBankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
    begin
        with BankAcctStmtLine do begin
          BankAccLedgEntry.Reset;
          BankAccLedgEntry.SetCurrentkey("Bank Account No.",Open);
          BankAccLedgEntry.SetRange("Bank Account No.",BankAcctStmtLine."Bank Account No.");
          BankAccLedgEntry.SetRange(Open,false);
          BankAccLedgEntry.SetRange(
            "Statement Status",BankAccLedgEntry."statement status"::Closed);
          BankAccLedgEntry.SetRange("Statement No.",BankAcctStmtLine."Statement No.");
          BankAccLedgEntry.SetRange("Statement Line No.",BankAcctStmtLine."Statement Line No.");
          if BankAccLedgEntry.Find('-') then
            repeat
              AppliedAmount := AppliedAmount + BankAccLedgEntry.Amount;
              BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
              lBankAccLedgEntry := BankAccLedgEntry;
              lBankAccLedgEntry.Open := true;
              lBankAccLedgEntry."Statement Status" := lBankAccLedgEntry."statement status"::"Bank Acc. Entry Applied";
              lBankAccLedgEntry.Modify;

              CheckLedgEntry.Reset;
              CheckLedgEntry.SetCurrentkey("Bank Account Ledger Entry No.");
              CheckLedgEntry.SetRange(
                "Bank Account Ledger Entry No.",BankAccLedgEntry."Entry No.");
              CheckLedgEntry.SetRange(CheckLedgEntry.Open,false);
              if CheckLedgEntry.Find('-') then
                repeat
                  CheckLedgEntry.TestField(Open,false);
                  CheckLedgEntry.TestField(
                    "Statement Status",
                    CheckLedgEntry."statement status"::Closed);
                  CheckLedgEntry.TestField("Statement No.",'');
                  CheckLedgEntry.TestField("Statement Line No.",0);
                  CheckLedgEntry.Open := true;
                  CheckLedgEntry."Statement Status" := CheckLedgEntry."statement status"::"Bank Acc. Entry Applied";
                  CheckLedgEntry.Modify;
                until CheckLedgEntry.Next = 0;
            until BankAccLedgEntry.Next = 0;
            BankAccLedgEntry.Modify;
        end;
    end;

    local procedure OpenCheckLedgerEntry(BankAcctStmtLine: Record "Bank Account Statement Line";var AppliedAmount: Decimal)
    var
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
    begin
        with BankAcctStmtLine do begin
          CheckLedgEntry.Reset;
          CheckLedgEntry.SetCurrentkey("Bank Account No.",Open);
          CheckLedgEntry.SetRange("Bank Account No.",BankAcctStmtLine."Bank Account No.");
          CheckLedgEntry.SetRange(Open,false);
          CheckLedgEntry.SetRange(
            "Statement Status",CheckLedgEntry."statement status"::Closed);
          CheckLedgEntry.SetRange("Statement No.",BankAcctStmtLine."Statement No.");
          CheckLedgEntry.SetRange("Statement Line No.",BankAcctStmtLine."Statement Line No.");
          if CheckLedgEntry.Find('-') then
            repeat
              AppliedAmount -= CheckLedgEntry.Amount;
              CheckLedgEntry.Open := true;
              CheckLedgEntry."Statement Status" := CheckLedgEntry."statement status"::"Check Entry Applied";
              CheckLedgEntry.Modify;

              BankAccLedgEntry.Get(CheckLedgEntry."Bank Account Ledger Entry No.");
              BankAccLedgEntry.TestField(Open,false);
              BankAccLedgEntry.TestField(
              "Statement Status",BankAccLedgEntry."statement status"::Closed);
              BankAccLedgEntry."Statement No." := '';
              BankAccLedgEntry."Statement Line No." := 0;
              BankAccLedgEntry."Remaining Amount" :=
                BankAccLedgEntry."Remaining Amount" - CheckLedgEntry.Amount;
              BankAccLedgEntry."Statement Status" := BankAccLedgEntry."statement status"::"Check Entry Applied";
              if BankAccLedgEntry."Remaining Amount" <> 0 then
                BankAccLedgEntry.Open := true;
              BankAccLedgEntry.Modify;
          until CheckLedgEntry.Next = 0;
        end;
    end;

    local procedure UpdateBank(lBankAccStmt: Record "Bank Account Statement";TotalAmount: Decimal)
    var
        BankAccStmt: Record "Bank Account Statement";
    begin
        with BankAcc do begin
          LockTable;
          Get(lBankAccStmt."Bank Account No.");
          TestField(Blocked,false);
          BankAccStmt.SetCurrentkey("Bank Account No.","Statement Date");
          BankAccStmt.SetRange("Bank Account No.",lBankAccStmt."Bank Account No.");
          BankAccStmt.SetFilter("Statement Date",'<%1',lBankAccStmt."Statement Date");
          if BankAccStmt.FindLast then
            "Last Statement No." := BankAccStmt."Statement No."
          else
            "Last Statement No." := '';
          "Balance Last Statement" := "Balance Last Statement" - TotalAmount ;
          Modify;
        end;
    end;
}

