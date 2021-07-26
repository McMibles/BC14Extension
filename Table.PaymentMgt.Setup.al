Table 52092306 "Payment Mgt. Setup"
{

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(2;"Payment Request Nos.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3;"Cash Advance Nos.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(4;"Receipt Nos.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(5;"Payment Voucher Nos.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(6;"Check Entry No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(7;"Cash Adv. Retirement Nos.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(8;"Check Nos.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(9;"Cash Lodgement Nos.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(10;"Check Bank Recon.";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11;"Archive Payment Request";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12;"Alert on Voucher Creation";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Cash Adv. Due Period";DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(14;"Copy Comments Pmt to Posted";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15;"Budget Analysis View Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Analysis View";
        }
        field(16;"Budget Expense Control Enabled";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Budget Expense Control Enabled" then
                  TestField("Budget Analysis View Code");
            end;
        }
        field(17;"Budget Control Period";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
            OptionMembers = Day,Week,Month,Quarter,Year,"Accounting Period";
        }
        field(18;"Enforce Budget on Vouchers";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(19;"Cheque Posting Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'System Generated No.,Cheque No.';
            OptionMembers = "System Generated No.","Cheque No.";
        }
        field(20;"Posted Cheque Voiding  By";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Standard Code,Custom Code';
            OptionMembers = "Standard Code","Custom Code";
        }
        field(21;"Cash. Adv. Due Alert Days";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(22;"Use Account Level Period Ctrl";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(23;"Send Vendor Payment Advice";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(24;"Payable Ticket Alert E-mail";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25;"Leave Vouch. Alert E-mail";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(26;"Travel Vouch. Alert E-mail";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(27;"Employee Req. Alert E-mail";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(28;"Loan Request Alert E-mail";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(29;"Loan Voucher Alert E-mail";Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(30;"Travel Request Alert E-mail";Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

