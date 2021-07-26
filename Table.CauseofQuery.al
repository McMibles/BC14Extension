Table 52092215 "Cause of Query"
{
    DrillDownPageID = "Cause of Query";
    LookupPageID = "Cause of Query";

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[150])
        {
            Caption = 'Description';
        }
        field(3;"Action";Option)
        {
            OptionCaption = 'No Action,Advice,Warning,Suspension with pay,Suspension without pay,Dismissal';
            OptionMembers = "No Action",Advice,Warning,"Suspension with pay","Suspension without pay",Dismissal;
        }
        field(4;Level;Option)
        {
            OptionCaption = ' ,Category I,Category II,Category III,Category IV';
            OptionMembers = " ","Category I","Category II","Category III","Category IV";
        }
        field(15;"Suspension Duration";DateFormula)
        {

            trigger OnValidate()
            begin
                if Format("Suspension Duration") <> '' then begin
                  if not (Action in[3,4]) then
                    Error(StrSubstNo(Text001,Action::"Suspension with pay",Action::"Suspension without pay"));
                end;
            end;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
        key(Key2;Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        if Action in[3,4] then
          if Format("Suspension Duration") = '' then
            Error(Text002);
    end;

    var
        Text001: label 'This can only be used with the action %1 or %2';
        Text002: label 'Suspension duration must be specified';
}

