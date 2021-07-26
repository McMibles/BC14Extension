Page 52092698 "Payment Request SubForm-ESS"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Payment Request Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = Description;
                field(RequestCode;"Request Code")
                {
                    ApplicationArea = Basic;
                }
                field(AccountName;"Account Name")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(JobNo;"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(JobTaskNo;"Job Task No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ConsignmentPONo;"Consignment PO No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ConsignmentCode;"Consignment Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ConsignmentChargeCode;"Consignment Charge Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MaintenanceCode;"Maintenance Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension1Code;"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(ShortcutDimension2Code;"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(AmountLCY;"Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    StyleExpr = StyleTxt;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Dimension)
            {
                ApplicationArea = Basic;
                Caption = 'Dimension';
                Image = Dimensions;

                trigger OnAction()
                begin
                    ShowDimensions;
                end;
            }
            action(Comments)
            {
                ApplicationArea = Basic;
                Image = ViewComments;
                RunObject = Page "Payment Comment Sheet";
                RunPageLink = "Table Name"=const("Payment Request"),
                              "No."=field("Document No."),
                              "Table Line No."=field("Line No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        PmtMgtSetup.Get;
        if (PmtMgtSetup."Budget Expense Control Enabled") and (
          BudgetControlMgt.ControlBudget ("Account No.")) then begin
          GetAmounts;
          GetCommitment;
          AvailableAmount := BudgetAmount - ExpenseAmount - CommitmentAmount;
         StyleTxt := SetStyle;
        end else
          StyleTxt := '';
    end;

    var
        PmtMgtSetup: Record "Payment Mgt. Setup";
        BudgetControlMgt: Codeunit "Budget Control Management";
        BudgetAmount: Decimal;
        ExpenseAmount: Decimal;
        CommitmentAmount: Decimal;
        AvailableAmount: Decimal;
        LineCommitmentAmount: Decimal;
        LineCommitmentQty: Decimal;
        StyleTxt: Text;


    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;


    procedure GetAmounts()
    var
        PaymentReqHeader: Record "Payment Request Header";
    begin
        if PaymentReqHeader.Get("Document Type","Document No.") then
          BudgetControlMgt.GetAmounts("Dimension Set ID",PaymentReqHeader."Document Date","Account No.",BudgetAmount,
            ExpenseAmount, CommitmentAmount);
    end;


    procedure GetCommitment()
    var
        PaymentReqHeader: Record "Payment Request Header";
    begin
        if PaymentReqHeader.Get("Document Type","Document No.") then
         BudgetControlMgt.GetCommitmentAmount("Dimension Set ID","Document No.","Line No.",PaymentReqHeader."Document Date","Account No.",
          LineCommitmentAmount);
    end;


    procedure SetStyle(): Text
    begin
        if AvailableAmount + LineCommitmentAmount < "Amount (LCY)" then
          exit('Unfavorable')
        else
          exit('Favorable');
    end;
}

