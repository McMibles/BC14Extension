Page 52092169 "Employee Group"
{
    PageType = Card;
    SourceTable = "Payroll-Employee Group Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Code)
                {
                    ApplicationArea = Basic;
                    Lookup = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory; "Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; "Currency Code")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000000; "Employee Group Subform")
            {
                SubPageLink = "Employee Group" = field(Code);
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = '&Functions';
                action(CopyLinesfromanothergroup)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy Lines from another group';
                    Ellipsis = false;
                    Image = Copy;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrentGrpHeader := Rec;
                        CurrentGrpHeader.SetRecfilter;
                        CopyGroup.SetTableview(CurrentGrpHeader);
                        CopyGroup.Run;
                        CurrPage.Update(true);
                    end;
                }
                action(RecalculateLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Recalculate Lines';
                    Image = Calculate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CurrentGrpLine.SetRange(CurrentGrpLine."Employee Group", Code);
                        RecalculateLine.SetTableview(CurrentGrpLine);
                        RecalculateLine.Run;
                        CurrPage.Update(true);
                        Commit;
                    end;
                }
            }
        }
    }

    var
        CurrentGrpHeader: Record "Payroll-Employee Group Header";
        CurrentGrpLine: Record "Payroll-Employee Group Line";
        RecalculateLine: Report "Recalculate Emp Grp. Lines";
        CopyGroup: Report "PRoll; Copy Emp. Group Lines";
}

