Page 52092350 "Leave FactBox"
{
    Caption = 'Leave FactBox';
    PageType = ListPart;
    SourceTable = "Leave Schedule Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; GetAbsenceName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                }
                field(NoofDaysEntitled; "No. of Days Entitled")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysBF; "No. of Days B/F")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysAdded; "No. of Days Added")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysUtilised; "No. of Days Utilised")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysSubtracted; "No. of Days Subtracted")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysCommitted; "No. of Days Committed")
                {
                    ApplicationArea = Basic;
                }
                field(Balance; LeaveBalance)
                {
                    ApplicationArea = Basic;
                    Caption = 'Balance';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CauseofAbsence.Get("Absence Code");
        CalcFields(Balance);
        LeaveBalance := Balance - "No. of Days Committed";

    end;

    trigger OnOpenPage()
    begin
        SetFilter("Year Filter", '..%1', Date2dmy(Today, 3) - 1);
    end;

    var
        CauseofAbsence: Record "Cause of Absence";
        LeaveBalance: Decimal;


    procedure GetAbsenceName(): Text[80]
    begin
        CauseofAbsence.Get("Absence Code");
        exit(CauseofAbsence.Description);
    end;
}

