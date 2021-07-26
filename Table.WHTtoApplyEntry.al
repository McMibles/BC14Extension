Table 52130424 "WHT to Apply Entry"
{

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Document Entry No.";Integer)
        {
        }
        field(3;"WHT Posting Group";Code[20])
        {
            TableRelation = "WHT Posting Group";

            trigger OnValidate()
            begin
                if "WHT Posting Group" <> '' then begin
                  case "Table ID" of
                    25:begin
                      VedLedgerEntry.Get("Document Entry No.");
                      VedLedgerEntry.TestField(Open);
                      VedLedgerEntry.CalcFields("Original Amount");
                      "Invoice Amount" := VedLedgerEntry."Original Amount";
                      "WHT Base Amount" := VedLedgerEntry."Original Amount";
                    end;
                    21:begin
                      CustLedgerEntry.Get("Document Entry No.");
                      CustLedgerEntry.TestField(Open);
                      CustLedgerEntry.CalcFields("Original Amount");
                      "Invoice Amount" := CustLedgerEntry."Original Amount";
                      "WHT Base Amount" := CustLedgerEntry."Original Amount";
                    end;
                  end;
                  WHTPostingGroup.Get("WHT Posting Group");
                  WHTPostingGroup.TestField("WithHolding Tax %");
                  "WHT Amount" := "WHT Base Amount" * WHTPostingGroup."WithHolding Tax %"/100;
                  "Proportion of  Total Amount" := ROUND("WHT Base Amount"/"Invoice Amount");

                end;
            end;
        }
        field(4;"Invoice Amount";Decimal)
        {
            Editable = false;
        }
        field(5;"WHT Base Amount";Decimal)
        {

            trigger OnValidate()
            begin
                WHTPostingGroup.Get("WHT Posting Group");
                WHTPostingGroup.TestField("WithHolding Tax %");
                if Abs("WHT Base Amount") > Abs("Invoice Amount") then
                  Error(Text001);
                "WHT Amount" := "WHT Base Amount" * WHTPostingGroup."WithHolding Tax %"/100;
                "Proportion of  Total Amount" := "WHT Base Amount"/"Invoice Amount";
            end;
        }
        field(6;"WHT Amount";Decimal)
        {
        }
        field(7;"Proportion of  Total Amount";Decimal)
        {
            Editable = false;
        }
        field(8;"Table ID";Integer)
        {
        }
        field(9;"WHT Amount (LCY)";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Table ID","Document No.","Document Entry No.","WHT Posting Group")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        VedLedgerEntry: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        WHTPostingGroup: Record "WHT Posting Group";
        Text001: label 'WHT Base amount must not be higher than the invoice amount';
}

