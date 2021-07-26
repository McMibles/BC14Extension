Table 52092160 "Pension Administrator"
{
    DrillDownPageID = "Pension Administrators";
    LookupPageID = "Pension Administrators";

    fields
    {
        field(1;"Code";Code[10])
        {
        }
        field(2;Name;Text[50])
        {
        }
        field(3;"PFA Code";Code[20])
        {
        }
        field(4;"Receiving Bank";Text[30])
        {
        }
        field(5;"Receiving Account";Code[20])
        {
        }
        field(6;Address;Text[100])
        {
        }
        field(7;"Phone Number";Text[30])
        {
        }
        field(8;"PF Custodian";Text[30])
        {
        }
        field(9;"Receiving Account Name";Text[50])
        {
        }
        field(10;"Payroll Period Filter";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payroll-Period"."Period Code";
        }
        field(11;"Exist Payroll Period";Boolean)
        {
            CalcFormula = exist("Payroll-Payslip Header" where ("Payroll Period"=field("Payroll Period Filter"),
                                                                "Pension Adminstrator Code"=field("PFA Code")));
            FieldClass = FlowField;
        }
        field(12;"E/D Filter";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13;"Exist In Closed Payroll";Boolean)
        {
            CalcFormula = exist("Closed Payroll-Payslip Header" where ("Payroll Period"=field("Payroll Period Filter"),
                                                                       "Pension Adminstrator Code"=field("PFA Code")));
            FieldClass = FlowField;
        }
        field(14;"CBN Bank Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Bank;

            trigger OnValidate()
            begin
                if BankRec.Get("CBN Bank Code") then
                  Validate("Receiving Bank",BankRec.Name)
                else
                  Clear("Receiving Bank");
            end;
        }
        field(15;"E-Mail Address Of PFA";Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(16;"Mail Body File";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17;"Cc Mail Addresses";Text[250])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        BankRec: Record Bank;
}

