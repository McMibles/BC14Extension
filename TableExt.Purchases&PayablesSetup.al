TableExtension 52000044 tableextension52000044 extends "Purchases & Payables Setup" 
{
    fields
    {
        field(52092337;"Purch. Req. Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092338;"RFQ Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092339;"Consignment Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092340;"Generic Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092341;"Use Same No.";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092342;"PO Expiration Period";DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(52092343;"Bid Analysis No.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092344;"Send PRN Notification";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092345;"Service PO Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092346;"Service Receipt Nos.";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(52092347;"Resp. Centre Mandatory";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092348;"Vendor Purch. Code Mandatory";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092349;"Receipt Approval Level";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'None,Service Receipt,Warehouse Receipt,Both';
            OptionMembers = "None","Service Receipt","Warehouse Receipt",Both;
        }
        field(52092350;"Archive Order on Invoice only";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092351;"Send Payment Alert";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092352;"Copy Vendor on Payment Alert";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092353;"PRN Convertion Notification";Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'To notify the Requestor when PRN is converted to PO';
        }
        field(52092354;"Allow Purchase Header Deletion";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092355;"Send PO on Approval";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092356;"Allow PO Creation from RFQ";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092357;"Consignment Charge Option";Option)
        {
            DataClassification = ToBeClassified;
            Description = 'For closing the charge item on Consignment';
            OptionCaption = ' ,Indirect Cost,Item Charge';
            OptionMembers = " ","Indirect Cost","Item Charge";
        }
        field(52092358;"No. of PO Signatory";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52130423;"WithHolding Tax Posting";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Invoice,Payment';
            OptionMembers = Invoice,Payment;
        }
        field(52130424;"TIN Mandatory for VAT";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}

