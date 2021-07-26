Report 52092187 "Calculate Monthly Interest"
{
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Loan"; "Payroll-Loan")
        {
            DataItemTableView = where("Interest Rate (%)" = filter(<> 0));
            column(ReportForNavId_7474; 7474)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1, Counter);
                Window.Update(2, "Employee No.");
                Window.Update(3, "Loan ID");
                IncludeLoan := true;
                IncludeInterest := true;  //for interest calculation
                InterestAmt := 0;

                if (("Suspended(Y/N)") and ("Suspension Ending Date" > ProllPeriod."End Date"))
                  or ("Deduction Starting Date" > ProllPeriod."End Date") then
                    IncludeLoan := false;

                //check whether to deduct interest(declining Method)
                if ("Interest Starting Date" >= ProllPeriod."End Date") or ("Deduction Starting Date" > ProllPeriod."End Date") then
                    IncludeInterest := false;
                if (IncludeLoan = true) and (IncludeInterest = true) then begin
                    "Payroll-Loan".SetFilter("Date Filter", '..%1', ProllPeriod."Start Date" - 1);
                    CalcFields("Repaid Amount", "Remaining Amount");
                    if "Interest Chargeable Amount" = 0 then begin
                        InterestAmt := (("Remaining Amount") * "Interest Rate (%)") / (12 * 100);
                    end else begin
                        InterestAmt := ("Interest Chargeable Amount" * "Interest Rate (%)") / (12 * 100);
                    end;
                    if "Interest Calculation Method" = "interest calculation method"::"Straight with Ammortization" then
                        InterestAmt := "Payroll-Loan"."Interest Amount" / "Payroll-Loan"."Number of Payments";
                    "Payroll-Loan".SetRange("Date Filter", ProllPeriod."End Date");
                    CalcFields("Interest Repaid Amount", "Interest Remaining Amount");
                    if ("Interest Remaining Amount" = 0) and ("Interest Repaid Amount" <> 0) then
                        CurrReport.Skip;
                    if ("Interest Remaining Amount" <> 0) and ("Interest Calculation Method" <> 2) then
                        CurrReport.Skip;

                    if (InterestAmt > 0) then begin
                        if LoanInterestPosted then
                            CurrReport.Skip;
                        CreateLoanEntry;
                        PostLoanEntry;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            var
                Text001: label 'Function Completed';
            begin
                Window.Close;
                Message(Text001);
            end;

            trigger OnPreDataItem()
            begin
                if PeriodFilter = '' then
                    Error(Text005);
                PeriodCode := PeriodFilter;
                "Payroll-Loan".SetRange("Open(Y/N)", true);
                ProllPeriod.Get(PeriodCode);

                if ProllPeriod.Closed then
                    Error(Text004);

                Window.Open('Total Number of Interest Calculated   #1##########\' +
                            'Current Employee Number    #2##########\' +
                            'Current Loan Id   #3##########');

                Counter := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PeriodFilter; PeriodFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
                    TableRelation = "Payroll-Period";
                }
                field(Post; Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PayrollSetUp: Record "Payroll-Setup";
        EDLoan: Record "Payroll-Loan Entry";
        ProllPeriod: Record "Payroll-Period";
        IncludeLoan: Boolean;
        IncludeInterest: Boolean;
        InterestAmt: Decimal;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        EmpRec: Record "Payroll-Employee";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        PeriodFilter: Code[30];
        PeriodCode: Code[10];
        Window: Dialog;
        Counter: Integer;
        Post: Boolean;
        Text001: label 'Interest charge on Loan Id %1 for Period %2';
        Text002: label 'Processing multiple period is not possible!';
        Text003: label 'Function Completed!';
        Text004: label 'Period already closed';
        Text005: label 'Period Filter must be specified';

    local procedure LoanInterestPosted(): Boolean
    var
        ProllLoanEntry: Record "Payroll-Loan Entry";
    begin
        ProllLoanEntry.Reset;
        ProllLoanEntry.SetRange("Payroll Period", PeriodCode);
        ProllLoanEntry.SetRange("Employee No.", "Payroll-Loan"."Employee No.");
        ProllLoanEntry.SetRange("E/D Code", "Payroll-Loan"."Loan E/D");
        ProllLoanEntry.SetRange("Loan ID", "Payroll-Loan"."Loan ID");
        ProllLoanEntry.SetRange("Amount Type", ProllLoanEntry."amount type"::"Interest Amount");
        ProllLoanEntry.SetRange("Entry Type", ProllLoanEntry."entry type"::"Cost Amount");
        if ProllLoanEntry.FindFirst then
            exit(true)
        else
            exit(false);
    end;

    local procedure CreateLoanEntry()
    var
        ProllLoanEntry: Record "Payroll-Loan Entry";
        ProllLoanEntry2: Record "Payroll-Loan Entry";
    begin
        with "Payroll-Loan" do begin
            ProllLoanEntry.Init;
            ProllLoanEntry."Payroll Period" := PeriodCode;
            ProllLoanEntry.Date := ProllPeriod."End Date";
            ProllLoanEntry."Employee No." := "Payroll-Loan"."Employee No.";
            ProllLoanEntry."E/D Code" := "Payroll-Loan"."Loan E/D";
            ProllLoanEntry."Loan ID" := "Loan ID";
            if "Interest Calculation Method" = 2 then
                ProllLoanEntry.Amount := -InterestAmt
            else
                ProllLoanEntry.Amount := InterestAmt;
            ProllLoanEntry."Entry Type" := ProllLoanEntry."entry type"::"Cost Amount";
            ProllLoanEntry."Amount Type" := ProllLoanEntry."amount type"::"Interest Amount";
            if ProllLoanEntry2.FindLast then
                ProllLoanEntry."Entry No." := ProllLoanEntry2."Entry No." + 1
            else
                ProllLoanEntry."Entry No." := 1;
            ProllLoanEntry.Insert;
        end;
    end;

    local procedure PostLoanEntry()
    begin
        with "Payroll-Loan" do begin
            GenJnlLine.Init;
            GenJnlLine."Document No." := "Loan ID";
            GenJnlLine."External Document No." := "Loan ID";
            GenJnlLine."Loan ID" := "Loan ID";
            if "Interest Calculation Method" = "interest calculation method"::"Straight with Ammortization" then begin
                GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                GenJnlLine."Account No." := "Payroll-Loan"."Deferred Interest Account";
            end else begin
                GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
                GenJnlLine."Account No." := "Account No.";
            end;
            GenJnlLine."Posting Date" := ProllPeriod."End Date";
            GenJnlLine."Document Date" := ProllPeriod."End Date";
            GenJnlLine.Description := CopyStr(StrSubstNo(Text001, "Loan ID", PeriodCode), 1, MaxStrLen(GenJnlLine.Description));
            GenJnlLine.Validate(Amount, InterestAmt);
            GenJnlLine.Validate("Amount (LCY)", InterestAmt);
            GenJnlLine."Bal. Account Type" := GenJnlLine."bal. account type"::"G/L Account";
            GenJnlLine."Bal. Account No." := "Payroll-Loan"."Interest Account No.";
            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."VAT Prod. Posting Group" := '';
            GenJnlLine."Bal. VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Prod. Posting Group" := '';
            GenJnlLine.Validate("VAT %", 0);
            EmpRec.Get("Payroll-Loan"."Employee No.");
            GenJnlLine.Validate("Shortcut Dimension 1 Code", EmpRec."Global Dimension 1 Code");
            GenJnlLine.Validate("Shortcut Dimension 2 Code", EmpRec."Global Dimension 2 Code");
            GenJnlLine."System-Created Entry" := true;
            if Post then
                GenJnlPostLine.Run(GenJnlLine)
            else begin
                GenJnlLine."Journal Template Name" := 'GENERAL';
                GenJnlLine."Journal Batch Name" := 'INTEREST';
                GenJnlLine2.SetRange("Journal Template Name", 'GENERAL');
                GenJnlLine2.SetRange("Journal Batch Name", 'INTEREST');
                if GenJnlLine2.FindLast then
                    GenJnlLine."Line No." := GenJnlLine2."Line No." + 10000
                else
                    GenJnlLine."Line No." := 10000;
                GenJnlLine.Insert;
            end;
        end;
    end;
}

