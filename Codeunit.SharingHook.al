Codeunit 52092131 "Sharing Hook"
{

    trigger OnRun()
    begin
    end;

    var
        SharingBuffer: Record "Transaction Sharing Line" temporary;
        SharingFormula: Record "Sharing Setup";
        Text001: label '%1''s Share';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostInvPostBuffer', '', false, false)]
    local procedure OnAfterPostInvPostBuffer(var GenJnlLine: Record "Gen. Journal Line";var InvoicePostBuffer: Record "Invoice Post. Buffer";var SalesHeader: Record "Sales Header";GLEntryNo: Integer;CommitIsSuppressed: Boolean;var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        if SharingExist(InvoicePostBuffer."G/L Account") then begin
          CreateSharingBuffer2(InvoicePostBuffer."G/L Account",InvoicePostBuffer.Amount);

        end;
    end;


    procedure InitSharingBuffer()
    begin
        SharingBuffer.DeleteAll;
    end;


    procedure CreateSharingBuffer(AccountNo: Code[20];AmountToShare: Decimal;DimensionSetID: Integer;DocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;DocumentNo: Code[20];PostingDate: Date)
    var
        TotalAmountLCY: Decimal;
        TotalAmountLCY2: Decimal;
        TotalAmountLCYRnded: Decimal;
        TotalAmountLCYRnded2: Decimal;
        AmountShared: Decimal;
        LineNo: Integer;
    begin
        SharingFormula.Reset;
        SharingFormula.SetRange(SharingFormula."Sharing Account No.",AccountNo);
        SharingFormula.FindSet;
        TotalAmountLCY2 := 0;
        TotalAmountLCYRnded2 := 0;
        repeat
          AmountShared := 0;
          LineNo := LineNo + 1;
          TotalAmountLCY2 := TotalAmountLCY2 - AmountToShare * SharingFormula."Share %" / 100;
          AmountShared := ROUND(TotalAmountLCY2) - TotalAmountLCYRnded2;
          TotalAmountLCYRnded2 := TotalAmountLCYRnded2 + AmountShared;
          SharingBuffer.Init;
          SharingBuffer."Document Type" := DocumentType;
          SharingBuffer."Document No." := DocumentNo;
          SharingBuffer."Line No." := LineNo ;
          SharingBuffer."Posting Date" := PostingDate;
          SharingBuffer."Account Type" := SharingFormula."Account Type";
          SharingBuffer."Account No."  := SharingFormula."Account No.";
          SharingBuffer.Description := 'Shared';
          SharingBuffer.Amount := - 1* AmountShared;
          SharingBuffer."Bal. Account No." := AccountNo;
          SharingBuffer."Shortcut Dimension 1 Code" := SharingFormula."Shortcut Dimension 1 Code";
          SharingBuffer."Shortcut Dimension 2 Code" := SharingFormula."Shortcut Dimension 2 Code";
          SharingBuffer."Dimension Set ID" := SharingFormula."Dimension Set ID";
          SharingBuffer.Insert;
        until SharingFormula.Next = 0;
    end;


    procedure CreateSharingBuffer2(AccountNo: Code[20];AmountToShare: Decimal)
    var
        TotalAmountLCY: Decimal;
        TotalAmountLCY2: Decimal;
        TotalAmountLCYRnded: Decimal;
        TotalAmountLCYRnded2: Decimal;
        AmountShared: Decimal;
        LineNo: Integer;
    begin
        SharingFormula.Reset;
        SharingFormula.SetRange(SharingFormula."Sharing Account No.",AccountNo);
        SharingFormula.FindSet;
        TotalAmountLCY2 := 0;
        TotalAmountLCYRnded2 := 0;
        repeat
          AmountShared := 0;
          LineNo := LineNo + 1;
          TotalAmountLCY2 := TotalAmountLCY2 - AmountToShare * SharingFormula."Share %" / 100;
          AmountShared := ROUND(TotalAmountLCY2) - TotalAmountLCYRnded2;
          TotalAmountLCYRnded2 := TotalAmountLCYRnded2 + AmountShared;
          SharingBuffer.Init;
          //SharingBuffer."Document Type" := DocumentType;
          //SharingBuffer."Document No." := DocumentNo;
          SharingBuffer."Line No." := LineNo ;
          //SharingBuffer."Posting Date" := PostingDate;
          SharingBuffer."Account Type" := SharingFormula."Account Type";
          SharingBuffer."Account No."  := SharingFormula."Account No.";
          //SharingBuffer.Description := 'Shared';
          SharingBuffer.Amount := - 1* AmountShared;
          SharingBuffer."Bal. Account No." := AccountNo;
          SharingBuffer."Shortcut Dimension 1 Code" := SharingFormula."Shortcut Dimension 1 Code";
          SharingBuffer."Shortcut Dimension 2 Code" := SharingFormula."Shortcut Dimension 2 Code";
          SharingBuffer."Dimension Set ID" := SharingFormula."Dimension Set ID";
          SharingBuffer.Insert;
        until SharingFormula.Next = 0;
    end;


    procedure PostSharedAmount(SalesHeader: Record "Sales Header")
    var
        ICPartner: Record "IC Partner";
        GenJnlLine: Record "Gen. Journal Line";
        GLAcc: Record "G/L Account";
        OutBoxTransaction: Record "IC Outbox Transaction";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ICInOutBoxMgt: Codeunit ICInboxOutboxMgt;
        ICOutboxExport: Codeunit "IC Outbox Export";
        ICTransactionNo: Integer;
    begin
        /*IF SharingBuffer.FINDSET THEN
          REPEAT
            GenJnlLine.INIT;
            //GenJnlLine."Line No." := ICGenJnlLineNo;
            GenJnlLine.VALIDATE("Posting Date",SalesHeader."Posting Date");
            GenJnlLine."Document Date" := SalesHeader."Document Date";
            GenJnlLine."Reason Code" := SalesHeader."Reason Code";
            GenJnlLine."Document Type" := SharingBuffer."Document Type";
            GenJnlLine."Document No." := SharingBuffer."Document No.";
            //GenJnlLine."External Document No." := GenJnlLineExtDocNo;
            CASE SharingBuffer."Account Type" OF
              0:BEGIN
                GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
                GenJnlLine.VALIDATE("Account No.",SharingBuffer."Account No.");
                GenJnlLine.Description := SalesHeader."Posting Description" + '' + STRSUBSTNO(Text001,'OPR');
              END;
              1:BEGIN
                GenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"IC Partner");
                GenJnlLine.VALIDATE("Account No.",SharingBuffer."Account No.");
                ICPartner.GET(SharingBuffer."Account No.");
                GenJnlLine.Description := SalesHeader."Posting Description" + ' ' +STRSUBSTNO(Text001,ICPartner.Name);
              END;
            END;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine.Amount := SharingBuffer.Amount;
            GenJnlLine."Source Currency Code" := SalesHeader."Currency Code";
            GenJnlLine."Source Currency Amount" := SharingBuffer.Amount;
            GenJnlLine.Correction := SalesHeader.Correction;
            //GenJnlLine."Source Code" := SrcCode;
            GenJnlLine."Country/Region Code" := SalesHeader."VAT Country/Region Code";
            GenJnlLine."Source Type" := GenJnlLine."Source Type"::Customer;
            GenJnlLine."Source No." := SalesHeader."Bill-to Customer No.";
            GenJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            GenJnlLine.VALIDATE("Bal. Account Type",GenJnlLine."Bal. Account Type"::"G/L Account");
            GenJnlLine.VALIDATE("Bal. Account No.",SharingBuffer."Bal. Account No.");
            GenJnlLine."Dimension Set ID" := SharingBuffer."Shortcut Dimension 1 Code";
            GenJnlLine."Gen. Posting Type" := 0;
            GenJnlLine."Gen. Bus. Posting Group" := '';
            GenJnlLine."Gen. Prod. Posting Group" := '';
            GenJnlLine."Bal. Gen. Posting Type" := 0;
            GenJnlLine."Bal. Gen. Bus. Posting Group" := '';
            GenJnlLine."Bal. Gen. Prod. Posting Group" := '';
            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."VAT Prod. Posting Group" := '';
            GenJnlLine."Bal. VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Prod. Posting Group" := '';
            IF SharingBuffer."Account Type" = 1 THEN BEGIN
              GenJnlLine."IC Partner Code" := SharingBuffer."Account No.";
              GenJnlLine."IC Direction" := GenJnlLine."IC Direction"::Outgoing;
            END;
            GenJnlLine.VALIDATE(Amount);
            IF SharingBuffer."Account Type" = 1 THEN BEGIN
              ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(GenJnlLine,FALSE);
              ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo,1,GenJnlLine);
              ICOutboxExport.ProcessAutoSendOutboxTransactionNo(ICTransactionNo);
            END;
            GenJnlPostLine.RunWithCheck(GenJnlLine);
          UNTIL SharingBuffer.NEXT = 0;*/

    end;


    procedure PostSharedAmountGenJline(GenJnlLine: Record "Gen. Journal Line")
    var
        ICPartner: Record "IC Partner";
        GenJnlLine2: Record "Gen. Journal Line";
        OutBoxTransaction: Record "IC Outbox Transaction";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        ICInOutBoxMgt: Codeunit ICInboxOutboxMgt;
        ICOutboxExport: Codeunit "IC Outbox Export";
        ICTransactionNo: Integer;
    begin
        /*IF SharingBuffer.FINDSET THEN
          REPEAT
            GenJnlLine2.INIT;
            GenJnlLine2.VALIDATE("Posting Date",GenJnlLine."Posting Date");
            GenJnlLine2."Document Date" := GenJnlLine."Document Date";
            GenJnlLine2."Reason Code" := GenJnlLine."Reason Code";
            GenJnlLine2."Document Type" := SharingBuffer."Document Type";
            GenJnlLine2."Document No." := SharingBuffer."Document No.";
            //GenJnlLine."External Document No." := GenJnlLineExtDocNo;
            CASE SharingBuffer."Account Type" OF
              0:BEGIN
                GenJnlLine2.VALIDATE("Account Type",GenJnlLine2."Account Type"::"G/L Account");
                GenJnlLine2.VALIDATE("Account No.",SharingBuffer."Account No.");
                GenJnlLine2.Description := STRSUBSTNO(Text001,COMPANYNAME);
              END;
              1:BEGIN
                GenJnlLine2.VALIDATE("Account Type",GenJnlLine2."Account Type"::"IC Partner");
                GenJnlLine2.VALIDATE("Account No.",SharingBuffer."Account No.");
                ICPartner.GET(SharingBuffer."Account No.");
                GenJnlLine2.Description := STRSUBSTNO(Text001,ICPartner.Name);
              END;
            END;
            GenJnlLine2."System-Created Entry" := TRUE;
            GenJnlLine2.Amount := SharingBuffer.Amount;
            GenJnlLine2."Source Currency Code" := GenJnlLine."Currency Code";
            GenJnlLine2."Source Currency Amount" := SharingBuffer.Amount;
            GenJnlLine2.Correction := GenJnlLine.Correction;
            //GenJnlLine."Source Code" := SrcCode;
            GenJnlLine2.VALIDATE("Bal. Account Type",GenJnlLine2."Bal. Account Type"::"G/L Account");
            GenJnlLine2.VALIDATE("Bal. Account No.",SharingBuffer."Bal. Account No.");
            GenJnlLine2."Dimension Set ID" := SharingBuffer."Shortcut Dimension 1 Code";
            GenJnlLine2."Gen. Posting Type" := 0;
            GenJnlLine2."Gen. Bus. Posting Group" := '';
            GenJnlLine2."Gen. Prod. Posting Group" := '';
            GenJnlLine2."Bal. Gen. Posting Type" := 0;
            GenJnlLine2."Bal. Gen. Bus. Posting Group" := '';
            GenJnlLine2."Bal. Gen. Prod. Posting Group" := '';
            GenJnlLine2."VAT Bus. Posting Group" := '';
            GenJnlLine2."VAT Prod. Posting Group" := '';
            GenJnlLine2."Bal. VAT Bus. Posting Group" := '';
            GenJnlLine2."Bal. VAT Prod. Posting Group" := '';
            IF SharingBuffer."Account Type" = 1 THEN BEGIN
              GenJnlLine2."IC Partner Code" := SharingBuffer."Account No.";
              GenJnlLine2."IC Direction" := GenJnlLine2."IC Direction"::Outgoing;
            END;
            GenJnlLine.VALIDATE(Amount);
            IF SharingBuffer."Account Type" = 1 THEN BEGIN
              ICTransactionNo := ICInOutBoxMgt.CreateOutboxJnlTransaction(GenJnlLine2,FALSE);
              ICInOutBoxMgt.CreateOutboxJnlLine(ICTransactionNo,1,GenJnlLine2);
              ICOutboxExport.ProcessAutoSendOutboxTransactionNo(ICTransactionNo);
            END;
            GenJnlPostLine.RunWithCheck(GenJnlLine2);
          UNTIL SharingBuffer.NEXT = 0;*/

    end;


    procedure SharingExist(GLAccount: Code[20]): Boolean
    begin
        SharingFormula.SetRange(SharingFormula."Sharing Account No.",GLAccount);
        if SharingFormula.FindFirst then
          exit(true)
        else
          exit(false);
    end;
}

