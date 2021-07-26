TableExtension 52000050 tableextension52000050 extends "Approval Entry" 
{
    fields
    {
        modify("Document Type")
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';

            //Unsupported feature: Property Modification (OptionString) on ""Document Type"(Field 2)".

        }
        field(52092138;Description;Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(52092139;"Workflow User Group";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092140;"Approved By";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52092141;"Employee No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092142;"OTP Approval Required";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092143;"Random OTP";Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            ExtendedDatatype = Masked;
        }
        field(52092144;"Mobile Phone No";Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }
}

