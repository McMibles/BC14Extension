TableExtension 52000006 tableextension52000006 extends Vendor 
{
    fields
    {
        field(60000;Type;Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Trade Creditor,Loan Creditor';
            OptionMembers = "Trade Creditor","Loan Creditor";
        }
        field(60002;"User ID";Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60003;"RC Number";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60005;"TIN Identification No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60006;"Creation Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52130423;"WHT Posting Group";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WHT Posting Group";
        }
    }
}

