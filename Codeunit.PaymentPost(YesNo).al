Codeunit 52092231 "Payment Post (Yes/No)"
{
    TableNo = "Payment Header";

    trigger OnRun()
    begin
        PaymentHeader.Copy(Rec);
        Code;
        Rec := PaymentHeader;
    end;

    var
        PaymentHeader: Record "Payment Header";
        Selection: Integer;
        Text000: label '&Post Cash Advance,Post Cash Adv. &and Create Voucher';
        Text001: label 'Do you want to post the %1?';

    local procedure "Code"()
    begin
        with PaymentHeader do begin
          case "Document Type" of
            "document type"::"Cash Advance":
              begin
                Selection := StrMenu(Text000,2);
                if Selection = 0 then
                  exit;
                "Create Voucher" := Selection in [2];
              end;
            else
              if not
                 Confirm(
                   Text001,false,
                   "Document Type")
              then
                exit;
          end;
          Codeunit.Run(Codeunit::"Payment - Post",PaymentHeader);
        end;
    end;
}

