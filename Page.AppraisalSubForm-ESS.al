Page 52092413 "Appraisal SubForm-ESS"
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
                field(LineNo;"Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    HideValue = true;
                    Visible = false;
                }
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
                field(AppraiseeScoreCode;"Appraisee Score Code")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field(AppraiseeScore;"Appraisee Score")
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field(AppraiseeSectionalWeight;"Appraisee Sectional Weight")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Style = Strong;
                    StyleExpr = LineEmphasize;
                }
                field(SectionCode;"Section Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = true;
                    HideValue = true;
                    Visible = false;
                }
                field(TemplateCode;"Template Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    HideValue = true;
                    Visible = false;
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

