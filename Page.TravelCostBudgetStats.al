Page 52092465 "Travel Cost Budget Stats"
{
    PageType = CardPart;
    SourceTable = "Travel Cost";

    layout
    {
        area(content)
        {
            field("Account No."; ShowNo)
            {
                ApplicationArea = Basic;
                Caption = 'Account No.';
            }
            field(BudgetAmount; BudgetAmount)
            {
                ApplicationArea = Basic;
                Caption = 'Budget Amount';

                trigger OnDrillDown()
                begin
                    DrillDown(0)
                end;
            }
            field(ExpenseAmount; ExpenseAmount)
            {
                ApplicationArea = Basic;
                Caption = 'Expense Amount';

                trigger OnDrillDown()
                begin
                    DrillDown(1)
                end;
            }
            field(CommitmentAmount; CommitmentAmount)
            {
                ApplicationArea = Basic;
                Caption = 'Commitment Amount';

                trigger OnDrillDown()
                begin
                    DrillDown(2)
                end;
            }
            field(AvailableAmount; AvailableAmount)
            {
                ApplicationArea = Basic;
                Caption = 'Available Amount';
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        GetAmounts;
        AvailableAmount := BudgetAmount - ExpenseAmount - CommitmentAmount;
    end;

    var
        GLAcc: Record "G/L Account";
        TravelHeader: Record "Travel Header";
        TravelLine: Record "Travel Line";
        BudgetControlMgt: Codeunit "Budget Control Management";
        BudgetAmount: Decimal;
        ExpenseAmount: Decimal;
        CommitmentAmount: Decimal;
        AvailableAmount: Decimal;


    procedure ShowNo(): Code[20]
    begin
        if not (GLAcc.Get("Account Code")) then
            exit('');
        exit("Account Code");
    end;


    procedure GetAmounts()
    begin
        if TravelHeader.Get("Document No.") then begin
            TravelLine.Get("Document No.", "Line No.");
            BudgetControlMgt.GetAmounts(TravelLine."Dimension Set ID", TravelHeader."Document Date", "Account Code", BudgetAmount,
              ExpenseAmount, CommitmentAmount);
        end
    end;


    procedure DrillDown(ShowWhat: Integer)
    begin
        TravelHeader.Get("Document No.");
        TravelLine.Get("Document No.", "Line No.");
        BudgetControlMgt.ShowAmounts(TravelLine."Dimension Set ID", TravelHeader."Document Date", "Account Code", ShowWhat);
    end;
}

