PageExtension 52000032 pageextension52000032 extends "Bank Account Statement"
{
    actions
    {
        addfirst(processing)
        {
            action("Print Statement")
            {
                ApplicationArea = Basic;
                Caption = 'Print Statement';
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";

                trigger OnAction()
                var
                    BankStmt: Record "Bank Account Statement";
                // BankStmtRpt: Report "Bank Account Statement";
                begin
                    BankStmt.SetFilter("Bank Account No.", "Bank Account No.");
                    BankStmt.SetFilter("Statement No.", "Statement No.");
                    //BankStmtRpt.SetTableview(BankStmt);
                    //BankStmtRpt.Run;
                end;
            }
            separator(Action7)
            {
            }
            separator(Action5)
            {
            }
            action("Undo Reconciliation")
            {
                ApplicationArea = Basic;
                Caption = 'Undo Reconciliation';
                Image = Undo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    BankStmt: Record "Bank Account Statement";
                    UndoPBankStatement: Codeunit "Undo Posted Reconciliation";
                begin
                    BankStmt.SetFilter("Bank Account No.", "Bank Account No.");
                    BankStmt.SetFilter("Statement No.", "Statement No.");
                    UndoPBankStatement.Run(BankStmt);
                    Message('Completed');
                end;
            }
        }
    }
}

