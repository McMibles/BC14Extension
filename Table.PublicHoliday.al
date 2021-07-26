Table 52092190 "Public Holiday"
{

    fields
    {
        field(1;"Code";Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[30])
        {
            Caption = 'Description';
        }
        field(3;Date;Date)
        {

            trigger OnValidate()
            begin
                "Start Date" := Date;
                if ("End Date" = 0D) or ("End Date" < Date) then
                "End Date" := Date;

                Duration := Format("End Date" - "Start Date" + 1) + 'D';
            end;
        }
        field(4;"Start Date";Date)
        {
        }
        field(5;"End Date";Date)
        {

            trigger OnValidate()
            begin
                if "End Date" < "Start Date" then
                  Error(Text001);

                Duration := Format("End Date" - "Start Date" + 1) + 'D';
            end;
        }
        field(6;Duration;Code[10])
        {
            DateFormula = true;

            trigger OnValidate()
            begin
                if Duration <> '' then
                  "End Date" := CalcDate(Duration + '- 1D',"Start Date");
            end;
        }
        field(7;"User ID";Code[50])
        {
            TableRelation = User;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
        key(Key2;Date)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := UserId;
    end;

    trigger OnModify()
    begin
        Modify;
    end;

    var
        HolidayCalendar: Record "Public Holiday";
        Text001: label 'Date not correct!';
}

