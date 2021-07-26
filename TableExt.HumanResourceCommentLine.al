TableExtension 52000061 tableextension52000061 extends "Human Resource Comment Line" 
{
    fields
    {
        field(52092186;"Training Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Header,Line,Attendance';
            OptionMembers = Header,Line,Attendance;
        }
        field(52092187;"Employee No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}

