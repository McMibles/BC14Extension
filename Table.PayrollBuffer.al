Table 52092164 "Payroll Buffer"
{

    fields
    {
        field(1;"Payroll Period";Code[20])
        {
        }
        field(2;"Global Dimension 1 Code";Code[20])
        {
        }
        field(3;"Global Dimension 2 Code";Code[20])
        {
        }
        field(4;"Job No.";Code[20])
        {
        }
        field(5;"Debit Acc. Type";Option)
        {
            OptionCaption = 'Finance,Customer,Supplier';
            OptionMembers = Finance,Customer,Supplier;
        }
        field(6;"Debit Account";Code[20])
        {
        }
        field(7;"Credit Acc. Type";Option)
        {
            OptionCaption = 'Finance,Customer,Supplier';
            OptionMembers = Finance,Customer,Supplier;
        }
        field(8;"Credit Account";Code[20])
        {
        }
        field(9;Amount;Decimal)
        {
        }
        field(10;"Loan ID";Code[20])
        {
        }
        field(11;"ED Code";Code[20])
        {
        }
        field(12;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(13;"Historical Amount";Decimal)
        {
        }
        field(14;"Payslip Column";Option)
        {
            InitValue = "1";
            OptionMembers = "1","2","3";
        }
        field(15;"Payslip Text";Text[70])
        {
            Description = 'Longer than ED Text for Historical Extension Text';
        }
        field(16;Bold;Boolean)
        {
            Caption = 'Bold';
        }
        field(17;Italic;Boolean)
        {
            Caption = 'Italic';
        }
        field(18;Sequence;Integer)
        {
        }
        field(19;"Pay Apearance";Integer)
        {
        }
        field(20;Quantity;Decimal)
        {
        }
        field(21;"Underline Amount";Option)
        {
            InitValue = "None";
            OptionCaption = 'None,Underline,Double Underline';
            OptionMembers = "None",Underline,"Double Underline";
        }
        field(22;"Currency Code";Code[20])
        {
            TableRelation = Currency;
        }
        field(23;"Use as Group Total";Boolean)
        {
        }
        field(24;"Dimension Set ID";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Payroll Period","Job No.","Debit Acc. Type","Debit Account","Credit Acc. Type","Credit Account","Loan ID","ED Code","Employee No.","Currency Code","Dimension Set ID")
        {
            Clustered = true;
        }
        key(Key2;"Payslip Column")
        {
        }
    }

    fieldgroups
    {
    }
}

