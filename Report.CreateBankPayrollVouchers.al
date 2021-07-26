Report 52092147 "Create Bank Payroll Vouchers"
{
    // This report prints the payment schedules to banks.

    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Payslip Header";"Payroll-Payslip Header")
        {
            DataItemTableView = sorting("Payroll Period","Employee No.");
            RequestFilterFields = "Payroll Period","Salary Group";
            column(ReportForNavId_1435; 1435)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("ED Amount");
                if "Payroll-Payslip Header"."WithHold Salary" then
                  CurrReport.Skip;
                if "ED Amount" <= 0 then
                  CurrReport.Skip;
                BasicAm := BasicAm + "ED Amount";
            end;

            trigger OnPostDataItem()
            begin
                CreatePaymentHeader;
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
                Periodfilter := "Payroll-Payslip Header".GetFilter("Payroll Period");
                if Periodfilter = '' then
                  Error(Text001);
                SetRange("Period Filter","Payroll-Payslip Header"."Payroll Period");
                SetRange("ED Filter",EDCode);
                SetFilter("Currency Code",'%1',CurrencyCode);

                PaymentHeader.LockTable;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(EDCode;EDCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'E/D Code';
                    TableRelation = "Payroll-E/D";
                }
                field(PostingDate;PostingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                }
                field(AccountNo;AccountNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Wages/Salary Account';
                    TableRelation = "G/L Account";
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Description';
                }
                field(PayingBankAccount;PayingBankAccount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Paying Bank Account';
                    TableRelation = "Bank Account";
                }
                field(CurrencyCode;CurrencyCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code';
                    TableRelation = Currency;
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

    trigger OnPostReport()
    begin
        Message(Text007,VoucherNo);
    end;

    trigger OnPreReport()
    begin
        if Description = '' then
          Error(Text002);
        if PostingDate = 0D then
          Error(Text003);
        if AccountNo = '' then
          Error(Text004);

        if EDCode = '' then
          Error(Text005);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PaymentLine: Record "Payment Line";
        PeriodRec: Record "Payroll-Period";
        BankRec: Record Bank;
        BankAccountRec: Record "Bank Account";
        PaymentHeader: Record "Payment Header";
        VoucherNo: Code[10];
        EDCode: Code[20];
        AccountNo: Code[20];
        Description: Text[30];
        PayingBankAccount: Code[20];
        HeaderText: Text[40];
        PostingDate: Date;
        NoOfEmployee: Integer;
        TotalNoOfEmployee: Integer;
        SerialNo: Integer;
        BasicAm: Decimal;
        CurrencyCode: Code[20];
        Periodfilter: Text[250];
        Text001: label 'Period Filter must be specified!';
        Text002: label 'Posting Description must be entered!';
        Text003: label 'You must specify Posting Date!';
        Text004: label 'Salary control account must be specified!';
        Text005: label 'E/D Code must be specified!';
        Text006: label 'You hve chosen to create voucher(s) automatically!\Do you want to continue?';
        Text007: label 'Salary Voucher %1 is Successfully Created';


    procedure CreatePaymentHeader()
    begin
        PaymentHeader.Init;
        PaymentHeader."Document Type" := PaymentHeader."document type"::"Payment Voucher";
        PaymentHeader."Payment Type" := PaymentHeader."payment type"::Others;
        PaymentHeader."Bal. Account No." := '';
        PaymentHeader."Posting Description" := Description;
        PaymentHeader.Payee := BankRec."Search Name";
        PaymentHeader."Payment Source" := PayingBankAccount;
        PaymentHeader."Payment Date" := PostingDate;
        if CurrencyCode <> '' then
          PaymentHeader.Validate("Currency Code",CurrencyCode);
        PaymentHeader."User ID" := UserId;
        PaymentHeader.Insert(true);
        Commit;
        VoucherNo := PaymentHeader."No.";
        CreatePaymentLines;
    end;


    procedure CreatePaymentLines()
    begin
        //Create Payment Lines
        PaymentLine."Document No." := PaymentHeader."No." ;
        PaymentLine."Document Type" := PaymentHeader."Document Type";
        PaymentLine."Line No."  := 10000 ;
        PaymentLine.Description := PaymentHeader."Posting Description";
        PaymentLine.Validate("Account Type",PaymentLine."account type"::"G/L Account");
        PaymentLine.Validate("Account No.",AccountNo);
        PaymentLine."Payment Type"  :=  PaymentHeader."Payment Type";
        PaymentLine.Validate(Amount,BasicAm) ;
        PaymentLine.Insert;
    end;
}

