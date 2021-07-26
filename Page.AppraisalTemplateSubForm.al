Page 52092402 "Appraisal Template SubForm"
{
    AutoSplitKey = true;
    Caption = 'Performance Template SubForm';
    PageType = ListPart;
    SourceTable = "Appraisal Template Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field(LineType;"Line Type")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field("<WeightingPercent>";"Weighting Percent")
                {
                    ApplicationArea = Basic;
                    Caption = 'Weighting Percent';
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        LineEmphasize := "Line Type" <> "line type"::Standard;
    end;

    var
        [InDataSet]
        LineEmphasize: Boolean;
}

