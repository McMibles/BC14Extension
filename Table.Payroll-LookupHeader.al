Table 52092156 "Payroll-Lookup Header"
{
    DrillDownPageID = "Table Lookup-List";
    LookupPageID = "Table Lookup-List";

    fields
    {
        field(1; TableId; Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                "Search Name" := TableId;
            end;
        }
        field(2; Type; Option)
        {
            NotBlank = true;
            OptionMembers = Numeric,"Code",Tax;
        }
        field(3; Description; Text[50])
        {
        }
        field(4; "Search Name"; Code[20])
        {
        }
        field(6; "Max. Extract Amount"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(7; "Min. Extract Amount"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(8; "Input Factor"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            InitValue = 1;
            MinValue = 0;
            NotBlank = true;
        }
        field(9; "Output Factor"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            InitValue = 1;
            MinValue = 0;
            NotBlank = true;
        }
        field(10; "Rounding Precision"; Decimal)
        {
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(11; "Rounding Direction"; Option)
        {
            OptionMembers = Nearest,Higher,Lower;
        }
        field(12; "Max. Extract Percentage"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
        field(13; "Min. Extract Percentage"; Decimal)
        {
            DecimalPlaces = 0 : 5;
        }
    }

    keys
    {
        key(Key1; TableId)
        {
            Clustered = true;
        }
        key(Key2; "Search Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if not Confirm(Text001 + Text002, false) then
            Error('Nothing was deleted');

        LockTable(false);
        PayrollLookUpLine.LockTable(false);

        PayrollLookUpLine.SetRange(TableId, TableId);
        PayrollLookUpLine.DeleteAll;

        Delete;

        Commit;
    end;

    trigger OnRename()
    begin
        Error(Text004);
    end;

    var
        PayrollLookUpLine: Record "Payroll-Lookup Line";
        Text001: label 'All entries for this lookup table will be deleted!\\';
        Text002: label 'Proceed with Deletion?';
        Text003: label 'Nothing was deleted';
        Text004: label 'Renaming of the table look up not allowed!';


    procedure SpecialRelation("FieldNo.": Integer)
    begin
        exit;
    end;
}

