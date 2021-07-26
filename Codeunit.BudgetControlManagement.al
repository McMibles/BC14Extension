Codeunit 52092227 "Budget Control Management"
{
    Permissions = TableData "Analysis View" = rimd,
                  TableData "Analysis View Filter" = rimd,
                  TableData "Analysis View Entry" = rimd,
                  TableData "Analysis View Budget Entry" = rimd,
                  TableData "Commitment Entry" = rimd;

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PmtMgtSetup: Record "Payment Mgt. Setup";
        AnalysisView: Record "Analysis View";
        AnalysisEntry: Record "Analysis View Entry";
        AnalysisBudgetEntry: Record "Analysis View Budget Entry";
        DimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        CommitmentEntry: Record "Commitment Entry";
        Text001: label '%1 code must be specified';


    procedure GetAmounts(DimSetID: Integer; DocumentDate: Date; AccountNo: Code[20]; var BudgetAmount: Decimal; var ExpensedAmount: Decimal; var CommittedAmount: Decimal)
    var
        ShortCodeDim1: Code[20];
        ShortCodeDim2: Code[20];
        ShortCodeDim3: Code[20];
        ShortCodeDim4: Code[20];
        ShortCodeDim5: Code[20];
        ShortCodeDim6: Code[20];
        ShortCodeDim7: Code[20];
        ShortCodeDim8: Code[20];
        GLAcc: Record "G/L Account";
        StartPeriod: Date;
        EndPeriod: Date;
        CommitStartPeriod: Date;
        CommitEndPeriod: Date;
    begin
        CommittedAmount := 0;
        BudgetAmount := 0;
        ExpensedAmount := 0;
        if AccountNo = '' then
            exit;

        PmtMgtSetup.Get;
        GLAcc.Get(AccountNo);
        if not (PmtMgtSetup."Use Account Level Period Ctrl") then begin
            case PmtMgtSetup."Budget Control Period" of
                PmtMgtSetup."budget control period"::Day:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 0);
                PmtMgtSetup."budget control period"::Week:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 1);
                PmtMgtSetup."budget control period"::Month:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 2);
                PmtMgtSetup."budget control period"::Quarter:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 3);
                PmtMgtSetup."budget control period"::Year:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 4);
                PmtMgtSetup."budget control period"::"Accounting Period":
                    begin
                        StartPeriod := FindFiscalYear(DocumentDate);
                        EndPeriod := FindEndOfFiscalYear(DocumentDate);
                    end;
            end;
        end else begin
            case GLAcc."Budget Control Period" of
                GLAcc."budget control period"::Day:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 0);
                GLAcc."budget control period"::Week:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 1);
                GLAcc."budget control period"::Month:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 2);
                GLAcc."budget control period"::Quarter:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 3);
                GLAcc."budget control period"::Year:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 4);
                GLAcc."budget control period"::"Accounting Period":
                    begin
                        StartPeriod := FindFiscalYear(DocumentDate);
                        EndPeriod := FindEndOfFiscalYear(DocumentDate);
                    end;
            end;
        end;
        FindPeriod('', DocumentDate, CommitStartPeriod, CommitEndPeriod, 4);

        if (AccountNo <> '') then begin
            if PmtMgtSetup."Budget Analysis View Code" <> '' then begin
                AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");
                ShortCodeDim1 := GetDimVal(AnalysisView."Dimension 1 Code", DimSetID);
                ShortCodeDim2 := GetDimVal(AnalysisView."Dimension 2 Code", DimSetID);
                ShortCodeDim3 := GetDimVal(AnalysisView."Dimension 3 Code", DimSetID);
                ShortCodeDim4 := GetDimVal(AnalysisView."Dimension 4 Code", DimSetID);
                //Calculate Budget Amount
                AnalysisBudgetEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                AnalysisBudgetEntry.SetRange("G/L Account No.", AccountNo);
                AnalysisBudgetEntry.SetRange("Posting Date", StartPeriod, EndPeriod);
                if ShortCodeDim1 <> '' then
                    AnalysisBudgetEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                if ShortCodeDim2 <> '' then
                    AnalysisBudgetEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                if ShortCodeDim3 <> '' then
                    AnalysisBudgetEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                if ShortCodeDim4 <> '' then
                    AnalysisBudgetEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);
                AnalysisBudgetEntry.CalcSums(Amount);
                BudgetAmount := AnalysisBudgetEntry.Amount;

                //Calculate Expensed Amount
                AnalysisEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                AnalysisEntry.SetRange(AnalysisEntry."Account No.", AccountNo);
                AnalysisEntry.SetRange("Posting Date", StartPeriod, EndPeriod);
                if ShortCodeDim1 <> '' then
                    AnalysisEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                if ShortCodeDim2 <> '' then
                    AnalysisEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                if ShortCodeDim3 <> '' then
                    AnalysisEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                if ShortCodeDim4 <> '' then
                    AnalysisEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);
                AnalysisEntry.CalcSums(Amount);
                ExpensedAmount := AnalysisEntry.Amount;

                //Calculate Commitment Amount
                CommitmentEntry.Reset;
                CommitmentEntry.SetCurrentkey("Analysis View Code", "Account No.", "Dimension 1 Value Code", "Dimension 2 Value Code", "Dimension 3 Value Code",
                  "Dimension 4 Value Code", "Business Unit Code", "Posting Date");
                CommitmentEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                CommitmentEntry.SetRange(CommitmentEntry."Account No.", AccountNo);
                CommitmentEntry.SetRange("Posting Date", StartPeriod, EndPeriod);
                if ShortCodeDim1 <> '' then
                    CommitmentEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                if ShortCodeDim2 <> '' then
                    CommitmentEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                if ShortCodeDim3 <> '' then
                    CommitmentEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                if ShortCodeDim4 <> '' then
                    CommitmentEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);
                CommitmentEntry.CalcSums(Amount);
                CommittedAmount := CommitmentEntry.Amount;
            end;
        end;
    end;


    procedure GetBudgetAmount(DimSetID: Integer; DocumentDate: Date; AccountNo: Code[20]) BudgetAmount: Decimal
    var
        ShortCodeDim1: Code[20];
        ShortCodeDim2: Code[20];
        ShortCodeDim3: Code[20];
        ShortCodeDim4: Code[20];
        ShortCodeDim5: Code[20];
        ShortCodeDim6: Code[20];
        ShortCodeDim7: Code[20];
        ShortCodeDim8: Code[20];
        GLAcc: Record "G/L Account";
        StartPeriod: Date;
        EndPeriod: Date;
    begin
        BudgetAmount := 0;
        PmtMgtSetup.Get;

        case PmtMgtSetup."Budget Control Period" of
            PmtMgtSetup."budget control period"::Day:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 0);
            PmtMgtSetup."budget control period"::Week:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 1);
            PmtMgtSetup."budget control period"::Month:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 2);
            PmtMgtSetup."budget control period"::Quarter:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 3);
            PmtMgtSetup."budget control period"::Year:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 4);
            PmtMgtSetup."budget control period"::"Accounting Period":
                begin
                    StartPeriod := FindFiscalYear(DocumentDate);
                    EndPeriod := FindEndOfFiscalYear(DocumentDate);
                end;

        end;


        if (AccountNo <> '') then begin
            if PmtMgtSetup."Budget Analysis View Code" <> '' then begin
                AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");
                ShortCodeDim1 := GetDimVal(AnalysisView."Dimension 1 Code", DimSetID);
                ShortCodeDim2 := GetDimVal(AnalysisView."Dimension 2 Code", DimSetID);
                ShortCodeDim3 := GetDimVal(AnalysisView."Dimension 3 Code", DimSetID);
                ShortCodeDim4 := GetDimVal(AnalysisView."Dimension 4 Code", DimSetID);

                AnalysisBudgetEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                AnalysisBudgetEntry.SetRange("G/L Account No.", AccountNo);
                AnalysisBudgetEntry.SetRange("Posting Date", StartPeriod, EndPeriod);
                if ShortCodeDim1 <> '' then
                    AnalysisBudgetEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                if ShortCodeDim2 <> '' then
                    AnalysisBudgetEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                if ShortCodeDim3 <> '' then
                    AnalysisBudgetEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                if ShortCodeDim4 <> '' then
                    AnalysisBudgetEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);
                AnalysisBudgetEntry.CalcSums(Amount);
                BudgetAmount := AnalysisBudgetEntry.Amount;
            end else begin
                DimSetEntry.SetRange("Dimension Set ID", DimSetID);
                if DimSetEntry.FindSet then
                    repeat
                        case DimSetEntry."Dimension Code" of
                            GLSetup."Shortcut Dimension 1 Code":
                                ShortCodeDim1 := DimSetEntry."Dimension Value Code";
                            GLSetup."Shortcut Dimension 2 Code":
                                ShortCodeDim2 := DimSetEntry."Dimension Value Code";
                        end;
                    until DimSetEntry.Next = 0;

                GLAcc.Get(AccountNo);
                GLAcc.SetRange("Global Dimension 1 Filter", ShortCodeDim1);
                GLAcc.SetRange("Global Dimension 2 Filter", ShortCodeDim2);
                //the Budget is for the current fiscal year
                GLAcc.SetRange("Date Filter", StartPeriod, EndPeriod);
                GLAcc.CalcFields("Budgeted Amount");
                BudgetAmount := GLAcc."Budgeted Amount";
            end;
            exit(BudgetAmount);
        end;
    end;


    procedure GetExpensedAmount(DimSetID: Integer; DocumentDate: Date; AccountNo: Code[20]) ExpensedAmount: Decimal
    var
        ShortCodeDim1: Code[20];
        ShortCodeDim2: Code[20];
        ShortCodeDim3: Code[20];
        ShortCodeDim4: Code[20];
        ShortCodeDim5: Code[20];
        ShortCodeDim6: Code[20];
        ShortCodeDim7: Code[20];
        ShortCodeDim8: Code[20];
        GLAcc: Record "G/L Account";
        StartPeriod: Date;
        EndPeriod: Date;
    begin
        ExpensedAmount := 0;
        PmtMgtSetup.Get;

        case PmtMgtSetup."Budget Control Period" of
            PmtMgtSetup."budget control period"::Day:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 0);
            PmtMgtSetup."budget control period"::Week:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 1);
            PmtMgtSetup."budget control period"::Month:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 2);
            PmtMgtSetup."budget control period"::Quarter:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 3);
            PmtMgtSetup."budget control period"::Year:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 4);
            PmtMgtSetup."budget control period"::"Accounting Period":
                begin
                    StartPeriod := FindFiscalYear(DocumentDate);
                    EndPeriod := FindEndOfFiscalYear(DocumentDate);
                end;

        end;

        if (AccountNo <> '') then begin
            if PmtMgtSetup."Budget Analysis View Code" <> '' then begin
                AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");
                ShortCodeDim1 := GetDimVal(AnalysisView."Dimension 1 Code", DimSetID);
                ShortCodeDim2 := GetDimVal(AnalysisView."Dimension 2 Code", DimSetID);
                ShortCodeDim3 := GetDimVal(AnalysisView."Dimension 3 Code", DimSetID);
                ShortCodeDim4 := GetDimVal(AnalysisView."Dimension 4 Code", DimSetID);
                AnalysisEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                AnalysisEntry.SetRange(AnalysisEntry."Account No.", AccountNo);
                AnalysisEntry.SetRange("Posting Date", StartPeriod, EndPeriod);
                if ShortCodeDim1 <> '' then
                    AnalysisEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                if ShortCodeDim2 <> '' then
                    AnalysisEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                if ShortCodeDim3 <> '' then
                    AnalysisEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                if ShortCodeDim4 <> '' then
                    AnalysisEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);
                AnalysisEntry.CalcSums(Amount);
                ExpensedAmount := AnalysisEntry.Amount;
            end else begin
                DimSetEntry.SetRange("Dimension Set ID", DimSetID);
                if DimSetEntry.FindSet then
                    repeat
                        case DimSetEntry."Dimension Code" of
                            GLSetup."Shortcut Dimension 1 Code":
                                ShortCodeDim1 := DimSetEntry."Dimension Value Code";
                            GLSetup."Shortcut Dimension 2 Code":
                                ShortCodeDim2 := DimSetEntry."Dimension Value Code";
                        end;
                    until DimSetEntry.Next = 0;

                GLAcc.Get(AccountNo);
                GLAcc.SetRange("Global Dimension 1 Filter", ShortCodeDim1);
                GLAcc.SetRange("Global Dimension 2 Filter", ShortCodeDim2);
                //the Budget is for the current fiscal year
                GLAcc.SetRange("Date Filter", StartPeriod, EndPeriod);
                GLAcc.CalcFields("Net Change");
                ExpensedAmount := GLAcc."Net Change";
            end;
            exit(ExpensedAmount);
        end;
    end;


    procedure GetCommitmentAmount(DimSetID: Integer; DocumentNo: Code[20]; DocumentLineNo: Integer; DocumentDate: Date; AccountNo: Code[20]; var CommitmentAmount: Decimal)
    var
        ShortCodeDim1: Code[20];
        ShortCodeDim2: Code[20];
        ShortCodeDim3: Code[20];
        ShortCodeDim4: Code[20];
        ShortCodeDim5: Code[20];
        ShortCodeDim6: Code[20];
        ShortCodeDim7: Code[20];
        ShortCodeDim8: Code[20];
        GLAcc: Record "G/L Account";
        StartPeriod: Date;
        EndPeriod: Date;
    begin
        CommitmentAmount := 0;
        PmtMgtSetup.Get;

        case PmtMgtSetup."Budget Control Period" of
            PmtMgtSetup."budget control period"::Day:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 0);
            PmtMgtSetup."budget control period"::Week:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 1);
            PmtMgtSetup."budget control period"::Month:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 2);
            PmtMgtSetup."budget control period"::Quarter:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 3);
            PmtMgtSetup."budget control period"::Year:
                FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 4);
            PmtMgtSetup."budget control period"::"Accounting Period":
                begin
                    StartPeriod := FindFiscalYear(DocumentDate);
                    EndPeriod := FindEndOfFiscalYear(DocumentDate);
                end;

        end;

        if (AccountNo <> '') then begin
            if PmtMgtSetup."Budget Analysis View Code" <> '' then begin
                AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");
                ShortCodeDim1 := GetDimVal(AnalysisView."Dimension 1 Code", DimSetID);
                ShortCodeDim2 := GetDimVal(AnalysisView."Dimension 2 Code", DimSetID);
                ShortCodeDim3 := GetDimVal(AnalysisView."Dimension 3 Code", DimSetID);
                ShortCodeDim4 := GetDimVal(AnalysisView."Dimension 4 Code", DimSetID);
                CommitmentEntry.Reset;
                CommitmentEntry.SetCurrentkey("Analysis View Code", "Account No.", "Dimension 1 Value Code", "Dimension 2 Value Code", "Dimension 3 Value Code",
                  "Dimension 4 Value Code", "Business Unit Code", "Posting Date");
                CommitmentEntry.SetRange("Document No.", DocumentNo);
                CommitmentEntry.SetRange("Document Line No.", DocumentLineNo);
                CommitmentEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                CommitmentEntry.SetRange(CommitmentEntry."Account No.", AccountNo);
                CommitmentEntry.SetRange("Posting Date", StartPeriod, EndPeriod);

                if ShortCodeDim1 <> '' then
                    CommitmentEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                if ShortCodeDim2 <> '' then
                    CommitmentEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                if ShortCodeDim3 <> '' then
                    CommitmentEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                if ShortCodeDim4 <> '' then
                    CommitmentEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);
                CommitmentEntry.CalcSums(Amount);
                CommitmentAmount := CommitmentEntry.Amount;
            end;
        end;
    end;


    procedure UpdateCommitment(DocumentNo: Code[20]; DocumentLineNo: Integer; DocumentDate: Date; Amount: Decimal; AccountNo: Code[20]; DimSetID: Integer)
    var
        CommitmentEntry1: Record "Commitment Entry";
    begin
        PmtMgtSetup.Get;
        PmtMgtSetup.TestField(PmtMgtSetup."Budget Analysis View Code");
        AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");

        Clear(CommitmentEntry);
        Clear(CommitmentEntry1);

        CommitmentEntry1.Init;
        CommitmentEntry1."Document No." := DocumentNo;
        CommitmentEntry1."Document Line No." := DocumentLineNo;
        CommitmentEntry1."Account No." := AccountNo;
        CommitmentEntry := CommitmentEntry1;
        if CommitmentEntry.Find then begin
            CommitmentEntry."Analysis View Code" := PmtMgtSetup."Budget Analysis View Code";
            CommitmentEntry."Dimension 1 Value Code" := GetDimVal(AnalysisView."Dimension 1 Code", DimSetID);
            CommitmentEntry."Dimension 2 Value Code" := GetDimVal(AnalysisView."Dimension 2 Code", DimSetID);
            CommitmentEntry."Dimension 3 Value Code" := GetDimVal(AnalysisView."Dimension 3 Code", DimSetID);
            CommitmentEntry."Dimension 4 Value Code" := GetDimVal(AnalysisView."Dimension 4 Code", DimSetID);
            CommitmentEntry."Posting Date" := DocumentDate;
            CommitmentEntry.Amount := Amount;
            //CommitmentEntry.Confirmed := Confirmed;
            CommitmentEntry.Modify;
        end else begin
            CommitmentEntry1."Analysis View Code" := PmtMgtSetup."Budget Analysis View Code";
            CommitmentEntry1."Dimension 1 Value Code" := GetDimVal(AnalysisView."Dimension 1 Code", DimSetID);
            CommitmentEntry1."Dimension 2 Value Code" := GetDimVal(AnalysisView."Dimension 2 Code", DimSetID);
            CommitmentEntry1."Dimension 3 Value Code" := GetDimVal(AnalysisView."Dimension 3 Code", DimSetID);
            CommitmentEntry1."Dimension 4 Value Code" := GetDimVal(AnalysisView."Dimension 4 Code", DimSetID);
            CommitmentEntry1."Posting Date" := DocumentDate;
            CommitmentEntry1.Amount := Amount;

            //CommitmentEntry1.Confirmed := Confirmed;
            CommitmentEntry1.Insert;
        end;
    end;


    procedure DeleteCommitment(DocumentNo: Code[20]; DocumentLineNo: Integer; AccountNo: Code[20])
    begin
        CommitmentEntry."Document No." := DocumentNo;
        CommitmentEntry."Document Line No." := DocumentLineNo;
        CommitmentEntry."Account No." := AccountNo;
        if CommitmentEntry.Find then
            CommitmentEntry.Delete;
    end;


    procedure ResetCommitment(DocumentNo: Code[20]; DocumentLineNo: Integer; AccountNo: Code[20]; Amount: Decimal; Quantity: Decimal; ResetBy: Option Add,Substract)
    var
        CommitmentEntry1: Record "Commitment Entry";
    begin
        PmtMgtSetup.Get;
        PmtMgtSetup.TestField(PmtMgtSetup."Budget Analysis View Code");
        AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");

        Clear(CommitmentEntry);
        Clear(CommitmentEntry1);

        CommitmentEntry1.Init;
        CommitmentEntry1."Document No." := DocumentNo;
        CommitmentEntry1."Document Line No." := DocumentLineNo;
        CommitmentEntry1."Account No." := AccountNo;
        CommitmentEntry := CommitmentEntry1;
        if CommitmentEntry.Find then begin
            if ResetBy = 0 then begin
                CommitmentEntry.Amount += Amount;
                CommitmentEntry.Modify;
            end else begin
                CommitmentEntry.Amount := CommitmentEntry.Amount - Amount;
                CommitmentEntry.Modify;
            end;
        end;
    end;


    procedure ReverseCommitment(DocumentNo: Code[20]; DocumentLineNo: Integer)
    var
        CommitmentEntry1: Record "Commitment Entry";
    begin
        CommitmentEntry."Document No." := DocumentNo;
        CommitmentEntry."Document Line No." := DocumentLineNo;
        if CommitmentEntry.Find then begin
            CommitmentEntry1 := CommitmentEntry;
            CommitmentEntry1.Amount := CommitmentEntry1.Amount * -1;
            CommitmentEntry1.Insert;
        end;
    end;


    procedure CommitmentExist(DocumentNo: Code[20]; DocumentLineNo: Integer): Boolean
    var
        CommitmentEntry1: Record "Commitment Entry";
    begin
        CommitmentEntry."Document No." := DocumentNo;
        CommitmentEntry."Document Line No." := DocumentLineNo;
        if CommitmentEntry.Find then
            exit(true)
        else
            exit(false);
    end;

    local procedure GetDimVal(DimCode: Code[20]; DimSetID: Integer): Code[20]
    begin
        if TempDimSetEntry.Get(DimSetID, DimCode) then
            exit(TempDimSetEntry."Dimension Value Code");
        if DimSetEntry.Get(DimSetID, DimCode) then
            TempDimSetEntry := DimSetEntry
        else begin
            TempDimSetEntry."Dimension Set ID" := DimSetID;
            TempDimSetEntry."Dimension Code" := DimCode;
            TempDimSetEntry."Dimension Value Code" := '';
        end;
        TempDimSetEntry.Insert;
        exit(TempDimSetEntry."Dimension Value Code");
    end;


    procedure ShowAmounts(DimSetID: Integer; DocumentDate: Date; AccountNo: Code[20]; AmountType: Option Budget,Expense,Commitment)
    var
        ShortCodeDim1: Code[20];
        ShortCodeDim2: Code[20];
        ShortCodeDim3: Code[20];
        ShortCodeDim4: Code[20];
        ShortCodeDim5: Code[20];
        ShortCodeDim6: Code[20];
        ShortCodeDim7: Code[20];
        ShortCodeDim8: Code[20];
        GLAcc: Record "G/L Account";
        StartPeriod: Date;
        EndPeriod: Date;
        CommitStartPeriod: Date;
        CommitEndPeriod: Date;
        CommitmentEntries: Page "Commitment Entries";
        BudgetEntries: Page "Analysis View Budget Entries";
        ExpenseEntries: Page "Analysis View Entries";
        UserControl: Codeunit "User Permissions";
    begin
        //UserControl.UserPermissionNoError('DRILLBUDGET',FALSE);

        if AccountNo = '' then
            exit;
        PmtMgtSetup.Get;
        GLAcc.Get(AccountNo);
        if not (PmtMgtSetup."Use Account Level Period Ctrl") then begin
            case PmtMgtSetup."Budget Control Period" of
                PmtMgtSetup."budget control period"::Day:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 0);
                PmtMgtSetup."budget control period"::Week:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 1);
                PmtMgtSetup."budget control period"::Month:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 2);
                PmtMgtSetup."budget control period"::Quarter:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 3);
                PmtMgtSetup."budget control period"::Year:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 4);
                PmtMgtSetup."budget control period"::"Accounting Period":
                    begin
                        StartPeriod := FindFiscalYear(DocumentDate);
                        EndPeriod := FindEndOfFiscalYear(DocumentDate);
                    end;
            end;
        end else begin
            case GLAcc."Budget Control Period" of
                GLAcc."budget control period"::Day:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 0);
                GLAcc."budget control period"::Week:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 1);
                GLAcc."budget control period"::Month:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 2);
                GLAcc."budget control period"::Quarter:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 3);
                GLAcc."budget control period"::Year:
                    FindPeriod('', DocumentDate, StartPeriod, EndPeriod, 4);
                GLAcc."budget control period"::"Accounting Period":
                    begin
                        StartPeriod := FindFiscalYear(DocumentDate);
                        EndPeriod := FindEndOfFiscalYear(DocumentDate);
                    end;
            end;
        end;
        FindPeriod('', DocumentDate, CommitStartPeriod, CommitEndPeriod, 4);

        if (AccountNo <> '') then begin
            if PmtMgtSetup."Budget Analysis View Code" <> '' then begin
                AnalysisView.Get(PmtMgtSetup."Budget Analysis View Code");
                ShortCodeDim1 := GetDimVal(AnalysisView."Dimension 1 Code", DimSetID);
                ShortCodeDim2 := GetDimVal(AnalysisView."Dimension 2 Code", DimSetID);
                ShortCodeDim3 := GetDimVal(AnalysisView."Dimension 3 Code", DimSetID);
                ShortCodeDim4 := GetDimVal(AnalysisView."Dimension 4 Code", DimSetID);
                if (ShortCodeDim1 = '') and (AnalysisView."Dimension 1 Code" <> '') then
                    Error(Text001, AnalysisView."Dimension 1 Code");

                case AmountType of
                    Amounttype::Budget:
                        begin
                            //Show Budget
                            AnalysisBudgetEntry.Reset;
                            AnalysisBudgetEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                            AnalysisBudgetEntry.SetRange("G/L Account No.", AccountNo);
                            AnalysisBudgetEntry.SetRange("Posting Date", StartPeriod, EndPeriod);
                            if ShortCodeDim1 <> '' then
                                AnalysisBudgetEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                            if ShortCodeDim2 <> '' then
                                AnalysisBudgetEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                            if ShortCodeDim3 <> '' then
                                AnalysisBudgetEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                            if ShortCodeDim4 <> '' then
                                AnalysisBudgetEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);

                            BudgetEntries.SetTableview(AnalysisBudgetEntry);
                            BudgetEntries.Run;

                        end;

                    Amounttype::Expense:
                        begin
                            //Show Actual Expenses
                            AnalysisEntry.Reset;
                            AnalysisEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                            AnalysisEntry.SetRange(AnalysisEntry."Account No.", AccountNo);
                            AnalysisEntry.SetRange("Posting Date", StartPeriod, EndPeriod);
                            if ShortCodeDim1 <> '' then
                                AnalysisEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                            if ShortCodeDim2 <> '' then
                                AnalysisEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                            if ShortCodeDim3 <> '' then
                                AnalysisEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                            if ShortCodeDim4 <> '' then
                                AnalysisEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);

                            ExpenseEntries.SetTableview(AnalysisEntry);
                            ExpenseEntries.Run;


                        end;

                    Amounttype::Commitment:
                        begin
                            //Show Commitment
                            CommitmentEntry.Reset;
                            CommitmentEntry.SetCurrentkey("Analysis View Code", "Account No.", "Dimension 1 Value Code",
                            "Dimension 2 Value Code", "Dimension 3 Value Code", "Dimension 4 Value Code", "Business Unit Code", "Posting Date");
                            CommitmentEntry.SetRange("Analysis View Code", PmtMgtSetup."Budget Analysis View Code");
                            CommitmentEntry.SetRange(CommitmentEntry."Account No.", AccountNo);
                            CommitmentEntry.SetRange("Posting Date", StartPeriod, EndPeriod);
                            if ShortCodeDim1 <> '' then
                                CommitmentEntry.SetRange("Dimension 1 Value Code", ShortCodeDim1);
                            if ShortCodeDim2 <> '' then
                                CommitmentEntry.SetRange("Dimension 2 Value Code", ShortCodeDim2);
                            if ShortCodeDim3 <> '' then
                                CommitmentEntry.SetRange("Dimension 3 Value Code", ShortCodeDim3);
                            if ShortCodeDim4 <> '' then
                                CommitmentEntry.SetRange("Dimension 4 Value Code", ShortCodeDim4);
                            CommitmentEntries.SetTableview(CommitmentEntry);
                            CommitmentEntries.Run;
                        end;
                end;
            end;
        end;
    end;


    procedure FindPeriod(SearchText: Text[3]; DateFilter: Date; var StartPeriod: Date; var EndPeriod: Date; PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period")
    var
        Calendar: Record Date;
        PeriodFormMgt: Codeunit PeriodFormManagement;
    begin
        if DateFilter <> 0D then begin
            Calendar.SetRange("Period Start", DateFilter);
            if not PeriodFormMgt.FindDate('+', Calendar, PeriodType) then
                PeriodFormMgt.FindDate('+', Calendar, Periodtype::Day);
            Calendar.SetRange("Period Start");
        end;
        PeriodFormMgt.FindDate(SearchText, Calendar, PeriodType);
        StartPeriod := Calendar."Period Start";
        EndPeriod := Calendar."Period End";
    end;


    procedure FindFiscalYear(BalanceDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SetRange("New Fiscal Year", true);
        AccountingPeriod.SetRange("Starting Date", 0D, BalanceDate);
        if AccountingPeriod.Find('+') then
            exit(AccountingPeriod."Starting Date");
        AccountingPeriod.Reset;
        AccountingPeriod.Find('-');
        exit(AccountingPeriod."Starting Date");
    end;


    procedure FindEndOfFiscalYear(BalanceDate: Date): Date
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        AccountingPeriod.SetRange("New Fiscal Year", true);
        AccountingPeriod.SetFilter("Starting Date", '>%1', FindFiscalYear(BalanceDate));
        if AccountingPeriod.Find('-') then
            exit((CalcDate('<-1D>', AccountingPeriod."Starting Date")));
        exit((99991231D));
    end;


    procedure ControlBudget(AccountNo: Code[20]): Boolean
    var
        GLAcc: Record "G/L Account";
    begin
        PmtMgtSetup.Get;
        if AccountNo = '' then
            exit(false);
        GLAcc.Get(AccountNo);
        if not (GLAcc."Excl. from Budget Ctrl") then
            exit(true)
        else
            exit(false);
    end;
}

