Table 52092213 Referee
{

    fields
    {
        field(1; "No."; Code[20])
        {
            TableRelation = if ("Record Type" = const(Employee)) Employee
            else
            if ("Record Type" = const(Applicant)) Applicant;
        }
        field(2; Name; Text[50])
        {
        }
        field(3; "Name 2"; Text[50])
        {
        }
        field(4; Address; Text[50])
        {
        }
        field(5; "Address 2"; Text[50])
        {
        }
        field(6; City; Text[30])
        {
        }
        field(7; "Phone No."; Text[30])
        {
        }
        field(8; "E-Mail"; Text[30])
        {
        }
        field(9; Occupation; Text[30])
        {
        }
        field(10; "No. of Years"; Integer)
        {
        }
        field(11; "Business/Postal Address"; Text[60])
        {
        }
        field(12; Relationship; Text[30])
        {
        }
        field(13; "Mobile Phone No."; Text[30])
        {
        }
        field(14; "Record Type"; Option)
        {
            OptionCaption = 'Employee,Applicant';
            OptionMembers = Employee,Applicant;
        }
    }

    keys
    {
        key(Key1; "Record Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Referee Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Referee Nos.", xRec."No.", 0D, "No.", "No.");
        end;
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit 396;
}

