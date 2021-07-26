Table 52092293 "Payment Request Line Archive"
{

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
        }
        field(3;Description;Text[100])
        {
        }
        field(4;"Job No.";Code[20])
        {
        }
        field(5;"Job Task No.";Code[20])
        {
        }
        field(6;"Consignment PO No.";Code[20])
        {
            TableRelation = "Purchase Header"."No." where ("Document Type"=const(Order));
        }
        field(7;"Consignment Code";Code[20])
        {
        }
        field(8;"Consignment Charge Code";Code[20])
        {
        }
        field(9;"Maintenance Code";Code[20])
        {
        }
        field(10;"Document Type";Option)
        {
            OptionCaption = 'Cash Account,Float Account';
            OptionMembers = "Cash Account","Float Account";
        }
        field(11;"Currency Code";Code[20])
        {
            TableRelation = Currency;
        }
        field(12;"Shortcut Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,2,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(13;"Shortcut Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,2,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(14;"Dimension Set ID";Integer)
        {
        }
        field(15;"Request Code";Code[20])
        {
            TableRelation = "Payment Request Code";
        }
        field(16;"Account Type";Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(17;"Account No.";Code[20])
        {
            TableRelation = if ("Account Type"=const("G/L Account")) "G/L Account"."No."
                            else if ("Account Type"=const(Customer)) Customer
                            else if ("Account Type"=const(Vendor)) Vendor
                            else if ("Account Type"=const("Bank Account")) "Bank Account"
                            else if ("Account Type"=const("Fixed Asset")) "Fixed Asset"
                            else if ("Account Type"=const("IC Partner")) "IC Partner";
        }
        field(18;"Account Name";Text[100])
        {
            Editable = false;
        }
        field(19;"FA Posting Type";Option)
        {
            OptionCaption = ' ,Acquisition Cost,Depreciation,Write-Down,Appreciation,Custom 1,Custom 2,Disposal,Maintenance';
            OptionMembers = " ","Acquisition Cost",,,,,,,Maintenance;
        }
        field(100;Amount;Decimal)
        {
        }
        field(101;"Amount (LCY)";Decimal)
        {
            Editable = false;
        }
        field(5000;"Float Amount";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

