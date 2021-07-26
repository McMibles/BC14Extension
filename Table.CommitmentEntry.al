Table 52092307 "Commitment Entry"
{
    Caption = 'Analysis View Budget Entry';

    fields
    {
        field(1;"Analysis View Code";Code[10])
        {
            Caption = 'Analysis View Code';
            NotBlank = true;
            TableRelation = "Analysis View";
        }
        field(3;"Business Unit Code";Code[10])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
        }
        field(4;"Account No.";Code[20])
        {
            Caption = 'G/L Account No.';
            TableRelation = "G/L Account";
        }
        field(5;"Dimension 1 Value Code";Code[20])
        {
            CaptionClass = GetCaptionClass(1);
            Caption = 'Dimension 1 Value Code';
        }
        field(6;"Dimension 2 Value Code";Code[20])
        {
            CaptionClass = GetCaptionClass(2);
            Caption = 'Dimension 2 Value Code';
        }
        field(7;"Dimension 3 Value Code";Code[20])
        {
            CaptionClass = GetCaptionClass(3);
            Caption = 'Dimension 3 Value Code';
        }
        field(8;"Dimension 4 Value Code";Code[20])
        {
            CaptionClass = GetCaptionClass(4);
            Caption = 'Dimension 4 Value Code';
        }
        field(9;"Posting Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(10;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(11;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(12;"Document No.";Code[20])
        {
        }
        field(13;"Document Line No.";Integer)
        {
        }
    }

    keys
    {
        key(Key1;"Document No.","Document Line No.","Account No.")
        {
            Clustered = true;
        }
        key(Key2;"Analysis View Code","Account No.","Dimension 1 Value Code","Dimension 2 Value Code","Dimension 3 Value Code","Dimension 4 Value Code","Business Unit Code","Posting Date")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }


    procedure GetCaptionClass(AnalysisViewDimType: Integer): Text[250]
    var
        AnalysisViewEntry: Record "Analysis View Entry";
    begin
        AnalysisViewEntry.Init;
        AnalysisViewEntry."Analysis View Code" := "Analysis View Code";
        exit(AnalysisViewEntry.GetCaptionClass(AnalysisViewDimType));
    end;
}

