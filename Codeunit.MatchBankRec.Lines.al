Codeunit 52001252 "Match Bank Rec. Lines1252"
{

    trigger OnRun()
    begin

        //  OBJECT Modification "Match Bank Rec. Lines"(Codeunit 1252)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=04272020D;
        //      Time=091748T;
        //      Modified=Yes;
        //      Version List=NAVW111.00;
        //    }
        //    PROPERTIES
        //    {
        //      Target="Match Bank Rec. Lines"(Codeunit 1252);
        //    }
        //    CHANGES
        //    {
        //      { Insertion         ;Target=MatchSingle(PROCEDURE 5);
        //                           InsertAfter=TempBankStatementMatchingBuffer(Variable 1000);
        //                           ChangedElements=VariableCollection
        //                           {
        //                             BankAccReconLine@1005 : Record "Bank Acc. Reconciliation Line";
        //                           }
        //                            }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          TempBankStatementMatchingBuffer.DELETEALL;
        //  
        //                                          Window.OPEN(ProgressBarMsg);
        //                                          SetMatchLengthTreshold(4);
        //                                          SetNormalizingFactor(10);
        //                                          BankRecMatchCandidates.SETRANGE(Rec_Line_Bank_Account_No,BankAccReconciliation."Bank Account No.");
        //                                          BankRecMatchCandidates.SETRANGE(Rec_Line_Statement_No,BankAccReconciliation."Statement No.");
        //                                          IF BankRecMatchCandidates.OPEN THEN
        //                                            WHILE BankRecMatchCandidates.READ DO BEGIN
        //                                              Score := 0;
        //  
        //                                              IF BankRecMatchCandidates.Rec_Line_Difference = BankRecMatchCandidates.Remaining_Amount THEN
        //                                                Score += 13;
        //  
        //                                              Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_Description,BankRecMatchCandidates.Description,
        //                                                  BankRecMatchCandidates.Document_No,BankRecMatchCandidates.External_Document_No);
        //  
        //                                              Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_RltdPty_Name,BankRecMatchCandidates.Description,
        //                                                  BankRecMatchCandidates.Document_No,BankRecMatchCandidates.External_Document_No);
        //  
        //                                              Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_Transaction_Info,BankRecMatchCandidates.Description,
        //                                                  BankRecMatchCandidates.Document_No,BankRecMatchCandidates.External_Document_No);
        //  
        //                                              IF BankRecMatchCandidates.Rec_Line_Transaction_Date <> 0D THEN
        //                                                CASE TRUE OF
        //                                                  BankRecMatchCandidates.Rec_Line_Transaction_Date = BankRecMatchCandidates.Posting_Date:
        //                                                    Score += 1;
        //                                                  ABS(BankRecMatchCandidates.Rec_Line_Transaction_Date - BankRecMatchCandidates.Posting_Date) > DateRange:
        //                                                    Score := 0;
        //                                                END;
        //  
        //                                              IF Score > 2 THEN
        //                                                TempBankStatementMatchingBuffer.AddMatchCandidate(BankRecMatchCandidates.Rec_Line_Statement_Line_No,
        //                                                  BankRecMatchCandidates.Entry_No,Score,0,'');
        //                                            END;
        //  
        //                                          SaveOneToOneMatching(TempBankStatementMatchingBuffer,BankAccReconciliation."Bank Account No.",
        //                                            BankAccReconciliation."Statement No.");
        //  
        //                                          Window.CLOSE;
        //                                          ShowMatchSummary(BankAccReconciliation);
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..5
        //                                          BankAccReconLine.SETCURRENTKEY("Statement Type","Bank Account No.","Statement No.","Statement Line No.");
        //                                          BankAccReconLine.SETRANGE("Bank Account No.",BankAccReconciliation."Bank Account No.");
        //                                          BankAccReconLine.SETRANGE("Statement No.",BankAccReconciliation."Statement No.");
        //                                          IF BankAccReconLine.FINDSET THEN BEGIN
        //                                            REPEAT
        //                                              BankRecMatchCandidates.SETRANGE(Rec_Line_Bank_Account_No,BankAccReconciliation."Bank Account No.");
        //                                              BankRecMatchCandidates.SETRANGE(Rec_Line_Statement_No,BankAccReconciliation."Statement No.");
        //                                              BankRecMatchCandidates.SETRANGE(Rec_Line_Statement_Line_No,BankAccReconLine."Statement Line No.");
        //                                              BankRecMatchCandidates.SETFILTER(Posting_Date,'..%1',BankAccReconciliation."Statement Date");
        //                                              BankRecMatchCandidates.SETRANGE(BankRecMatchCandidates.Remaining_Amount,BankAccReconLine."Statement Amount");
        //                                              IF BankRecMatchCandidates.OPEN THEN
        //                                                WHILE BankRecMatchCandidates.READ DO BEGIN
        //                                                  Score := 0;
        //  
        //                                                  IF BankRecMatchCandidates.Rec_Line_Difference = BankRecMatchCandidates.Remaining_Amount THEN
        //                                                    Score += 13;
        //  
        //                                                  Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_Description,BankRecMatchCandidates.Description,
        //                                                    BankRecMatchCandidates.Document_No,BankRecMatchCandidates.External_Document_No);
        //  
        //                                                  Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_RltdPty_Name,BankRecMatchCandidates.Description,
        //                                                    BankRecMatchCandidates.Document_No,BankRecMatchCandidates.External_Document_No);
        //  
        //                                                  Score += GetDescriptionMatchScore(BankRecMatchCandidates.Rec_Line_Transaction_Info,BankRecMatchCandidates.Description,
        //                                                    BankRecMatchCandidates.Document_No,BankRecMatchCandidates.External_Document_No);
        //  
        //                                                  IF BankRecMatchCandidates.Rec_Line_Transaction_Date <> 0D THEN
        //                                                    CASE TRUE OF
        //                                                      BankRecMatchCandidates.Rec_Line_Transaction_Date = BankRecMatchCandidates.Posting_Date:
        //                                                        Score += 1;
        //                                                      ABS(BankRecMatchCandidates.Rec_Line_Transaction_Date - BankRecMatchCandidates.Posting_Date) > DateRange:
        //                                                        Score := 0;
        //                                                   END;
        //  
        //                                                IF Score > 2 THEN
        //                                                  TempBankStatementMatchingBuffer.AddMatchCandidate(BankRecMatchCandidates.Rec_Line_Statement_Line_No,
        //                                                    BankRecMatchCandidates.Entry_No,Score,0,'');
        //                                              END;
        //                                            UNTIL BankAccReconLine.NEXT = 0;
        //                                          END;
        //                                          #37..41
        //                                        END;
        //  
        //                           Target=MatchSingle(PROCEDURE 5) }
        //    }
        //    CODE
        //    {
        //  
        //      BEGIN
        //      END.
        //    }
        //  }
        //  
        //  

    end;
}

