Report 52092144 "Payroll Account Total"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Account Total.rdlc';

    dataset
    {
        dataitem("Payroll-E/D"; "Payroll-E/D")
        {
            DataItemTableView = sorting("E/D Code");
            column(ReportForNavId_9150; 9150)
            {
            }
            column(Today; Today)
            {
            }
            column(UserId; UserId)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(AccountNo; AccountNo)
            {
            }
            column(PayrollPeriod; PayrollPeriod)
            {
            }
            column(Payroll_E_D_Codes__E_D_Code_; "E/D Code")
            {
            }
            column(DebitAmount; DebitAmount)
            {
            }
            column(CreditAmount; CreditAmount)
            {
            }
            column(Payroll_E_D_Codes_Description; Description)
            {
            }
            column(DebitAmount_Control16; DebitAmount)
            {
            }
            column(CreditAmount_Control17; CreditAmount)
            {
            }
            column(DebitAmount___CreditAmount; DebitAmount - CreditAmount)
            {
            }
            column(CreditAmount____DebitAmount_; CreditAmount - DebitAmount)
            {
            }
            column(Report_print_date_Caption; Report_print_date_CaptionLbl)
            {
            }
            column(Report_page_Caption; Report_page_CaptionLbl)
            {
            }
            column(Account_No_Caption; Account_No_CaptionLbl)
            {
            }
            column(Payroll_Period_Caption; Payroll_Period_CaptionLbl)
            {
            }
            column(TOTAL_ED_AMOUNT_PER_ACCOUNT_NUMBERCaption; TOTAL_ED_AMOUNT_PER_ACCOUNT_NUMBERCaptionLbl)
            {
            }
            column(Payroll_E_D_Codes__E_D_Code_Caption; FieldCaption("E/D Code"))
            {
            }
            column(Debit_AmountCaption; Debit_AmountCaptionLbl)
            {
            }
            column(Credit_AmountCaption; Credit_AmountCaptionLbl)
            {
            }
            column(DescriptionCaption; DescriptionCaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }
            column(Difference_Caption; Difference_CaptionLbl)
            {
            }
            column(Difference_Caption_Control27; Difference_Caption_Control27Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DebitAmount := 0;
                CreditAmount := 0;


                ProllPslipLine.SetRange(ProllPslipLine."E/D Code", "Payroll-E/D"."E/D Code");

                if not ProllPslipLine.Find('-') then CurrReport.Skip;

                // filters for debit account and calculate amount
                ProllPslipLine.SetRange(ProllPslipLine."Debit Account", AccountNo);
                ProllPslipLine.CalcSums(ProllPslipLine.Amount);
                DebitAmount := ProllPslipLine.Amount;
                ProllPslipLine.SetRange(ProllPslipLine."Debit Account");

                // filters for Credit account and calculate amount
                ProllPslipLine.SetRange(ProllPslipLine."Credit Account", AccountNo);
                ProllPslipLine.CalcSums(ProllPslipLine.Amount);
                CreditAmount := ProllPslipLine.Amount;
                ProllPslipLine.SetRange(ProllPslipLine."Credit Account");

                if (DebitAmount = 0) and (CreditAmount = 0) then CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                ProllPslipLine.SetCurrentkey("Payroll Period", "Global Dimension 1 Code", "Global Dimension 2 Code", "Job No.", "Debit Acc. Type",
                "Debit Account",
                                        "Credit Acc. Type", "Credit Account", "Loan ID");

                ProllPslipLine.SetRange("Payroll Period", PayrollPeriod);
                //CurrReport.CreateTotals(DebitAmount, CreditAmount);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PayrollPeriod; PayrollPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Period';
                    TableRelation = "Payroll-Period";
                }
                field(AccountNo; AccountNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Account Number';
                    TableRelation = "G/L Account";
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

    trigger OnPreReport()
    begin
        if AccountNo = '' then Error('Account Number must be specified');
        if PayrollPeriod = '' then Error('Payroll Period must be specified');
    end;

    var
        ProllPslipLine: Record "Payroll-Payslip Line";
        AccountNo: Code[20];
        PayrollPeriod: Code[10];
        DebitAmount: Decimal;
        CreditAmount: Decimal;
        Report_print_date_CaptionLbl: label 'Report print date:';
        Report_page_CaptionLbl: label 'Report page:';
        Account_No_CaptionLbl: label 'Account No:';
        Payroll_Period_CaptionLbl: label 'Payroll Period:';
        TOTAL_ED_AMOUNT_PER_ACCOUNT_NUMBERCaptionLbl: label 'TOTAL ED AMOUNT PER ACCOUNT NUMBER';
        Debit_AmountCaptionLbl: label ' Debit Amount';
        Credit_AmountCaptionLbl: label 'Credit Amount';
        DescriptionCaptionLbl: label 'Description';
        Total_CaptionLbl: label 'Total:';
        Difference_CaptionLbl: label 'Difference:';
        Difference_Caption_Control27Lbl: label 'Difference:';
}

