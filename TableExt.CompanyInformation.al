TableExtension 52000017 tableextension52000017 extends "Company Information" 
{
    fields
    {
        field(60000;"Authorised Signature";Blob)
        {
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(60001;"PENCOM Employer Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}

