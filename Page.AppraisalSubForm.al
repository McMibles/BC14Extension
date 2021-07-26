Page 52092405 "Appraisal SubForm"
{
    Caption = 'Performance SubForm';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Appraisal Lines";

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
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field(AppraiseeScore;"Appraisee Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(AppraiseeSectionalWeight;"Appraisee Sectional Weight")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(AppraiserScoreCode;"Appraiser Score Code")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field(AppraiserScore;"Appraiser Score")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field(AppraiserSectionalWeight;"Appraiser Sectional Weight")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Next)
            {
                ApplicationArea = Basic;
            }
            action(Previous)
            {
                ApplicationArea = Basic;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LineEmphasize := "Line Type" <> "line type"::Standard;
    end;

    var
        [InDataSet]
        LineEmphasize: Boolean;
}

