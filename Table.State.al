Table 52092189 State
{
    DrillDownPageID = States;
    LookupPageID = States;

    fields
    {
        field(1;"Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
        }
        field(3;"No. of Employees";Integer)
        {
            CalcFormula = count(Employee where ("State Code"=field(Code)));
            FieldClass = FlowField;
        }
        field(4;"Status Filter";Option)
        {
            FieldClass = FlowFilter;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
        }
        field(5;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(6;"Dimension 1 Filter";Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(7;"Record Type";Option)
        {
            OptionCaption = 'State,LG';
            OptionMembers = State,LG;
        }
        field(8;"State Code";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = State.Code where ("Record Type"=filter(State));

            trigger OnValidate()
            begin
                TestField("Record Type","record type"::LG);
            end;
        }
    }

    keys
    {
        key(Key1;"Record Type","Code")
        {
            Clustered = true;
        }
        key(Key2;"Code")
        {
        }
        key(Key3;Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Code",Description)
        {
        }
    }
}

