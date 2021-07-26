TableExtension 52000057 tableextension52000057 extends "Employee Qualification" 
{
    fields
    {
        field(52092187;"Course Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Course.Code where ("Record Type"=const(Course));
        }
    }
}

