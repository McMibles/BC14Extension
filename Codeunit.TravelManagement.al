Codeunit 52092243 "Travel Management"
{
    Permissions = TableData "Payment Header"=rim,
                  TableData "Payment Line"=rim;

    trigger OnRun()
    begin
    end;

    var
        APaymentHeader: Record "Payment Header";
        VPaymentHeader: Record "Payment Header";
        PayMgtSetup: Record "Payment Mgt. Setup";
        UserSetup: Record "User Setup";
        Employee: Record Employee;
        CommitmentEntry: Record "Commitment Entry";
        CommitmentEntry2: Record "Commitment Entry";
        GlobalSender: Text[80];
        Body: Text[200];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
        BudgetControlMgt: Codeunit "Budget Control Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PaymentVouchNo: Code[20];
        AdvanceVouchNo: Code[20];
        VouchLineNo: Integer;
        AdvanceLineNo: Integer;
        TravelVouchAlert: label 'This is to notify you of the travel payment voucher %1  and travel cash advance %2 awaiting your processing.';
        PTravelVouchAlert: label 'This is to notify you of the travel payment voucher %1  awaiting your processing.';
        CTravelVouchAlert: label 'This is to notify you of the travel cash advance %1  awaiting your processing.';
        Text019: label 'Air Ticket is not part of this cost. Do you want to still close this request?';
        Text020: label 'Travel not closed';
        Text018: label 'This is to notify you that Travel Purchase Invoice %1 has been created for your processing.';
        Window: Dialog;


    procedure CreateVoucher(var TravelHeader: Record "Travel Header")
    var
        TravelCost: Record "Travel Cost";
        TravelLine: Record "Travel Line";
        PaymentHeader: Record "Payment Header";
        PaymentLine: Record "Payment Line";
    begin
        PayMgtSetup.Get;
        Window.Open('#1###################################');
        Window.Update(1,'Processing Travel Request');
        with TravelHeader do begin
          TestField(Status,Status::Approved);
          TestField("Voucher No.",'');
          TravelCost.SetRange("Document No.","No.");
          //TravelCost.SETRANGE("Voucher Type",TravelCost."Voucher Type"::"Direct Expense");
          if TravelCost.FindSet then begin
            repeat
              case TravelCost."Voucher Type" of
                TravelCost."voucher type"::"Direct Expense":
                  CreatePaymentVoucher(TravelHeader,TravelCost);
                TravelCost."voucher type"::"Cash Advance":
                  CreateCashAdvance(TravelHeader,TravelCost);
              end;
            until TravelCost.Next= 0;
          end;

          if PayMgtSetup."Travel Vouch. Alert E-mail" <> '' then
            begin
              if (PaymentVouchNo <> '') or (AdvanceVouchNo <> '') then
                begin
                  Window.Update(1,'Sending E-Mail alert to Finance');
                  UserSetup.Get(UserId);
                  UserSetup.TestField("E-Mail");
                  UserSetup.TestField("Employee No.");
                  Employee.Get(UserSetup."Employee No.");
                  GlobalSender := Employee."First Name" + '' + Employee."Last Name";

                  if (PaymentVouchNo <> '') or (AdvanceVouchNo <> '') then
                    Body := StrSubstNo(TravelVouchAlert,PaymentVouchNo,AdvanceVouchNo);
                  if (PaymentVouchNo <> '') and (AdvanceVouchNo = '') then
                    Body := StrSubstNo(PTravelVouchAlert,PaymentVouchNo);
                  if (PaymentVouchNo = '') and (AdvanceVouchNo <> '') then
                    Body := StrSubstNo(CTravelVouchAlert,AdvanceVouchNo);

                  Subject := 'ALERT FOR TRAVEL VOUCHER CREATED';
                  SMTP.CreateMessage(GlobalSender,UserSetup."E-Mail",PayMgtSetup."Travel Vouch. Alert E-mail",Subject,Body,false);
                  SMTP.Send;
                end;

            end;
          "Voucher No." := PaymentVouchNo;
        end;
        Window.Close;
        Message('Voucher(s) Created')
    end;

    local procedure CreatePaymentVoucher(TravelHeader: Record "Travel Header";TravelCost: Record "Travel Cost")
    begin
        Window.Update(1,'Creating Payment Voucher');
        with TravelHeader do begin
          if PaymentVouchNo = '' then begin
            VPaymentHeader.Init;
            VPaymentHeader."No." := '';
            VPaymentHeader."Document Type" := VPaymentHeader."document type"::"Payment Voucher";
            VPaymentHeader."Payment Type" := VPaymentHeader."payment type"::Others;
            VPaymentHeader."Document Date" := WorkDate;
            VPaymentHeader."System Created Entry" := true;
            VPaymentHeader."Currency Code" := "Currency Code";
            VPaymentHeader."Currency Factor" := "Currency Factor";
            VPaymentHeader."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
            VPaymentHeader."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
            VPaymentHeader."Dimension Set ID" := "Dimension Set ID";
            VPaymentHeader.Validate("Payee No.",Beneficiary);
            VPaymentHeader.Payee := TravelHeader."Employee Name";
            VPaymentHeader."Source Type" := VPaymentHeader."source type"::Travel;
            VPaymentHeader."Source No." := TravelHeader."No.";
            VPaymentHeader."Posting Description" := CopyStr(TravelHeader."Purpose of Travel",1,50);
            VPaymentHeader.Insert(true);
            VPaymentHeader.CopyLinks(TravelHeader);
            PaymentVouchNo := VPaymentHeader."No.";
            VouchLineNo += 1000;
            CreatePaymentLines(VPaymentHeader,TravelCost,VouchLineNo);
          end else begin
            VouchLineNo += 1000;
            CreatePaymentLines(VPaymentHeader,TravelCost,VouchLineNo);
          end;
        end;
    end;

    local procedure CreateCashAdvance(TravelHeader: Record "Travel Header";TravelCost: Record "Travel Cost")
    var
        APaymentHeader: Record "Payment Header";
    begin
        Window.Update(1,'Creating Cash Advance');
        with TravelHeader do begin
          if AdvanceVouchNo = '' then begin
            APaymentHeader.Init;
            APaymentHeader."No." := '';
            APaymentHeader."Document Type" := APaymentHeader."document type"::"Cash Advance";
            APaymentHeader."Payment Type" := APaymentHeader."payment type"::"Cash Advance";
            APaymentHeader."Document Date" := WorkDate;
            APaymentHeader."System Created Entry" := true;
            APaymentHeader."Currency Code" := "Currency Code";
            APaymentHeader."Currency Factor" := "Currency Factor";
            APaymentHeader."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
            APaymentHeader."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
            APaymentHeader."Dimension Set ID" := "Dimension Set ID";
            APaymentHeader."Source Type" := APaymentHeader."source type"::Travel;
            APaymentHeader."Source No." := TravelHeader."No.";
            APaymentHeader.Validate("Payee No.",Beneficiary);
            APaymentHeader.Payee := TravelHeader."Employee Name";
            APaymentHeader."Posting Description" := CopyStr(TravelHeader."Purpose of Travel",1,50);
            APaymentHeader.Insert(true);
            APaymentHeader.CopyLinks(TravelHeader);
            AdvanceVouchNo := APaymentHeader."No.";
            AdvanceLineNo += 1000;
            CreatePaymentLines(APaymentHeader,TravelCost,AdvanceLineNo);
          end else begin
            AdvanceLineNo += 1000;
            CreatePaymentLines(APaymentHeader,TravelCost,AdvanceLineNo);
          end;
        end;
    end;

    local procedure CreatePaymentLines(PaymentHeader: Record "Payment Header";TravelCost: Record "Travel Cost";LineNo: Integer)
    var
        TravelLine: Record "Travel Line";
        PaymentLine: Record "Payment Line";
    begin
        TravelLine.Get(TravelCost."Document No.",TravelCost."Line No.");
        PaymentLine.Init;
        PaymentLine."Document Type" := PaymentHeader."Document Type";
        PaymentLine."Document No." := PaymentHeader."No.";
        PaymentLine."Line No." := LineNo;
        PaymentLine."Account Type" := PaymentLine."account type"::"G/L Account";
        PaymentLine."Account No." := TravelCost."Account Code";
        PaymentLine."Account Name" := TravelCost."Account Name";
        PaymentLine.Description := TravelCost.Description;
        PaymentLine."Job No." := TravelLine."Job No.";
        PaymentLine."Job Task No." := TravelLine."Job Task No.";
        PaymentLine."Shortcut Dimension 1 Code" := TravelLine."Global Dimension 1 Code";
        PaymentLine."Shortcut Dimension 2 Code" := TravelLine."Global Dimension 2 Code";
        PaymentLine."Dimension Set ID" := TravelLine."Dimension Set ID";
        PaymentLine.Amount := TravelCost.Amount;
        PaymentLine."Amount (LCY)" := TravelCost."Amount (LCY)";
        PaymentLine."Request No." := TravelCost."Document No.";
        PaymentLine."Request Line No." := TravelCost."Line No.";
        PaymentLine.Insert;
        PaymentLine.CopyLinks(TravelLine);
    end;


    procedure CreatePurchInvFromTravelReq(var TravelHeader: Record "Travel Header")
    var
        TravelLine: Record "Travel Line";
        TravelCost: Record "Travel Cost";
        SourceCodeSetup: Record "Source Code Setup";
        PurchInvHeader: Record "Purchase Header";
        PurchInvLine: Record "Purchase Line";
        LineNo: Integer;
        ScrCode: Code[30];
    begin
        Window.Open('#1###################################');
        Window.Update(1,'Processing Travel Request');
        PayMgtSetup.Get;
        TravelHeader.TestField(Status,TravelHeader.Status::Approved);
        TravelHeader.TestField("Purchase Invoice No.",'');
        TravelCost.SetRange("Document No.",TravelHeader."No.");
        TravelCost.SetRange("Voucher Type",TravelCost."voucher type"::"Purchase Invoice");
        if TravelCost.FindFirst then begin
          Window.Update(1,'Creating Payable Invoice');
          //Create Purchase Invoice Header
          PurchInvHeader.Init;
          PurchInvHeader."Document Type" := PurchInvHeader."document type"::Invoice;
          PurchInvHeader."No.":= '';
          PurchInvHeader.Validate("Buy-from Vendor No.",TravelHeader."Ticket Vendor");
          PurchInvHeader."Posting Description"  := CopyStr(TravelHeader."Purpose of Travel",1,50);
          PurchInvHeader."Document Date" := WorkDate;
          PurchInvHeader."Posting Date" := WorkDate;
          PurchInvHeader."Shortcut Dimension 1 Code" := TravelHeader."Global Dimension 1 Code";
          PurchInvHeader."Shortcut Dimension 2 Code" := TravelHeader."Global Dimension 2 Code";
          PurchInvHeader."Vendor Invoice No." := TravelHeader."Vendor Invoice No.";
          PurchInvHeader.Insert(true);
          PurchInvHeader.Validate("Shortcut Dimension 1 Code");
          PurchInvHeader.Validate("Shortcut Dimension 2 Code");

          LineNo := 0;
          repeat
            LineNo := LineNo + 10000;
            TravelLine.Get(TravelHeader."No.",TravelCost."Line No.");
            PurchInvLine.Init;
            PurchInvLine."Document Type" := PurchInvHeader."Document Type";
            PurchInvLine."Document No." := PurchInvHeader."No.";
            PurchInvLine."Buy-from Vendor No." := PurchInvHeader."Buy-from Vendor No.";
            PurchInvLine."Line No." := LineNo;
            PurchInvLine.Type := PurchInvLine.Type::"G/L Account";
            PurchInvLine.Validate("No.",TravelCost."Account Code");
            PurchInvLine.Validate(Quantity,1);
            PurchInvLine.Validate("Direct Unit Cost",TravelHeader."Ticket Amount (LCY)");
            PurchInvLine.Description := CopyStr(TravelCost.Description,1,50);
            PurchInvLine."Job No." := TravelLine."Job No.";
            PurchInvLine."Job Task No." := TravelLine."Job Task No.";
            //PurchInvLine."Capex Code" := TravelLine."Capex Code";
            PurchInvLine."Shortcut Dimension 1 Code" := TravelLine."Global Dimension 1 Code";
            PurchInvLine."Shortcut Dimension 2 Code" := TravelLine."Global Dimension 2 Code";
            PurchInvLine.Insert;
            PurchInvLine.Validate("Shortcut Dimension 1 Code",TravelLine."Global Dimension 1 Code");
            PurchInvLine.Validate("Shortcut Dimension 2 Code",TravelLine."Global Dimension 2 Code");
            PurchInvLine.Modify;

            //Create Voucher Commitment
            if (PurchInvLine.Type = PurchInvLine.Type::"G/L Account") and
              (BudgetControlMgt.ControlBudget(TravelCost."Account Code")) then begin
                CommitmentEntry.SetRange("Document No.",TravelCost."Document No.");
                CommitmentEntry.SetRange("Document Line No.", TravelCost."Line No.");
                CommitmentEntry.SetRange("Account No." ,TravelCost."Account Code");
                if CommitmentEntry.Find('-') then
                  repeat
                    CommitmentEntry2 := CommitmentEntry;
                    CommitmentEntry2."Document No." := PurchInvLine."Document No.";
                    CommitmentEntry2."Document Line No." := PurchInvLine."Line No.";
                    CommitmentEntry2.Insert;
                  until CommitmentEntry.Next = 0;
                CommitmentEntry.DeleteAll;
            end;
          until TravelCost.Next(1) = 0;

          //Notify account payables
          if PayMgtSetup."Payable Ticket Alert E-mail" <> '' then
            begin
              Window.Update(1,'Sending E-Mail alert to Finance');
              UserSetup.Get(UserId);
              Employee.Get(UserSetup."Employee No.");
              GlobalSender := Employee.FullName();
              Body := StrSubstNo(Text018,PurchInvHeader."No.");
              Subject := 'Air Ticket Processing Fee';

              SMTP.CreateMessage(GlobalSender,Employee."Company E-Mail",PayMgtSetup."Payable Ticket Alert E-mail",
                Subject,Body,true);
              SMTP.Send;
            end;
          //Update Travel
          TravelHeader."Purchase Invoice No." := PurchInvHeader."No.";
          TravelHeader.Closed := true;
          TravelHeader.Modify;

        end else begin
          if not Confirm(Text019) then
            Error(Text020);

          //Update Travel
          TravelHeader."Purchase Invoice No." := '';
          TravelHeader.Closed := true;
          TravelHeader.Modify;
        end;
        Window.Close;
    end;
}

