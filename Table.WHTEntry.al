Table 52130425 "WHT Entry"
{

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Document Line No.";Integer)
        {
        }
        field(3;"WHT Posting Group";Code[20])
        {
            TableRelation = "WHT Posting Group";
        }
        field(4;"Invoice Amount";Decimal)
        {
            Editable = false;
        }
        field(5;"WHT Invoice Base Amount";Decimal)
        {
        }
        field(6;"WHT Invoice Amount";Decimal)
        {
        }
        field(7;"% of  Total Amount";Decimal)
        {
            Editable = false;
        }
        field(8;"Table ID";Integer)
        {
        }
        field(9;"Invoice No.";Code[20])
        {
        }
        field(10;"WHT Payment Amount";Decimal)
        {
        }
        field(11;"Payment Line No.";Integer)
        {
        }
        field(12;"WHT Payment Base Amount";Decimal)
        {
        }
        field(13;"Payment Currency";Code[10])
        {
        }
        field(14;"WHT Pmt. Base Amount (LCY)";Decimal)
        {
        }
        field(15;"WHT Pmt. Amount(LCY)";Decimal)
        {
        }
        field(16;"Document Entry No.";Integer)
        {
        }
        field(17;"PO No.";Code[20])
        {
        }
        field(18;"Payment Currency Amount";Decimal)
        {
        }
        field(19;"Payment Currency Amount (LCY)";Decimal)
        {
        }
        field(20;"Payment Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Document Line No.","WHT Posting Group","Invoice No.")
        {
            Clustered = true;
            SumIndexFields = "WHT Payment Amount","WHT Pmt. Amount(LCY)";
        }
    }

    fieldgroups
    {
    }

    var
        VedLedgerEntry: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        WHTPostingGroup: Record "WHT Posting Group";
}

