Table 52092155 "Payroll-Setup"
{

    fields
    {
        field(1;"Primary Key";Code[10])
        {
        }
        field(2;"Employee Nos";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(3;"Loan Nos.";Code[10])
        {
            TableRelation = "No. Series";
        }
        field(4;"Payroll/Personnel Integration";Boolean)
        {
        }
        field(5;"Annual Gross Pay E/D Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(6;"Total Emolument Factor Lookup";Code[20])
        {
            TableRelation = "Payroll-Factor Lookup";
        }
        field(7;"Pension Registration No.";Code[20])
        {
        }
        field(8;"Pension Employee E/D";Text[250])
        {
        }
        field(9;"Pension Employer E/D";Text[250])
        {
        }
        field(10;"Total Pension Contri. E/D";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-E/D";
        }
        field(13;"Overtime ED";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-E/D";
        }
        field(14;"Public Holiday ED";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-E/D";
        }
        field(15;"Net Pay E/D Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(16;"Gratuity Benefit Factor Code";Code[20])
        {
            TableRelation = "Payroll-Factor Lookup";
        }
        field(17;"Basic E/D Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(19;"No. of Working Days";Integer)
        {
        }
        field(20;"13TH Month ED Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-E/D";
        }
        field(24;"IOU Deduction ED Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(25;"Interest Account";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(26;"Interest Calculation Method";Option)
        {
            OptionCaption = 'Straight,Declining,Straight with Ammortization';
            OptionMembers = Straight,Declining,"Straight with Ammortization";
        }
        field(27;"ExGratia ED Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(28;"Leave ED Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(29;"Leave Accrual ED Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Payroll-E/D";
        }
        field(30;"Monthly Gross ED Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(31;"Show Company Logo";Boolean)
        {
        }
        field(32;"Reimbursable Pay E/D Code";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(33;"Total Net Pay E/D";Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(34;"Net Pay Statistical Group Code";Code[20])
        {
            TableRelation = "Payroll Statistical Group";
        }
        field(35;"Loan Deduction Starting Period";DateFormula)
        {
        }
        field(36;"Deferred Interest Account";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(37;"Staff  Debtor Posting Grp";Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(38;"Use DSR Limit";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(39;"Use Stakeholders Fund Limit";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(40;"StakeHolders Fund Limit";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(41;"DSR Limit  Calc. Value";Decimal)
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

