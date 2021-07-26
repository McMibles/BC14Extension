TableExtension 52000002 tableextension52000002 extends "G/L Account" 
{
    fields
    {
        field(60001;"Job No. Mandatory";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60011;"Creation Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60012;"Created By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(60013;"Last Modified By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52092307;"Excl. from Budget Ctrl";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092308;"Budget Control Period";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
            OptionMembers = Day,Week,Month,Quarter,Year,"Accounting Period";
        }
        field(52092337;"GIT Clearing Account";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092338;"Prepayment Control";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

