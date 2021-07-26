TableExtension 52000004 tableextension52000004 extends Customer
{
    fields
    {
        field(60000; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Customer,Staff';
            OptionMembers = Customer,Staff;
        }
        field(60002; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(60003; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52130423; "WHT Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "WHT Posting Group";
        }
    }
}

