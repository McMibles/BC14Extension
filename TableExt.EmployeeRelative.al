TableExtension 52000058 tableextension52000058 extends "Employee Relative" 
{
    fields
    {
        field(52092192;"Next of Kin";Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CheckDuplicate;
            end;
        }
    }

    local procedure CheckDuplicate()
    var
        EmpRelative: Record "Employee Relative";
        NextKinDupError: label 'Next of Kin already picked for this employee\\ Action not allowed';
    begin
        EmpRelative.SetRange("Next of Kin",true);
        EmpRelative.SetFilter("Line No.",'<>%1',"Line No.");
        if EmpRelative.FindFirst then
          Error(NextKinDupError);
    end;
}

