Report 52092156 "payroll mo"
{
    // Create General Ledger Lines based on payroll details entries.
    // +------------------------------------+
    // | BackGround Information             |
    // +------------------------------------+
    // In the Booking Group File, an E/D Code is linked to a Debit account
    // and a Credit Account.
    // Each Employee belongs to a certain Booking Group.
    // Each Employee can be linked to a Department and/or a Project in the
    // Finance file
    // +------------------------------------+
    // | Calling parameters entered by User |
    // +------------------------------------+
    //  On calling the function the user may enter the following parameters:
    //    Period code    - one or a range
    //    Booking group  - one, a range or all
    //    Employee Codes - one, a range or all
    //    Name of General Ledger; If this is not entered the system will use the
    //                            default Ledger = PAYROLL DETAILS
    //    Booking date   - one

    ProcessingOnly = true;

    dataset
    {
        dataitem("Closed Payroll-Payslip Line";"Closed Payroll-Payslip Line")
        {
            DataItemTableView = sorting("Payroll Period","Global Dimension 1 Code","Global Dimension 2 Code","Job No.","Debit Acc. Type","Debit Account","Credit Acc. Type","Credit Account","Loan ID");
            RequestFilterFields = "Employee No.","Global Dimension 1 Code","Global Dimension 2 Code","Employee Category";
            column(ReportForNavId_4449; 4449)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PayrollHeader.Get("Payroll Period","Employee No.");
                PayrollHeader.TestField(PayrollHeader.Status,1);
                Window.Update (2,   "Global Dimension 1 Code");
                Window.Update (3,   "Global Dimension 2 Code");
                Window.Update (5,   "Job No.");
                Window.Update (6,   "Employee No.");
                Window.Update (7,   "E/D Code");
                InfoCounter := InfoCounter + 1;
                Window.Update (8,InfoCounter);

                if ("Debit Account" <> '') or ("Credit Account" <> '') then begin
                  Clear(PayrollBuffer[1]);
                  PayrollBuffer[1]."Payroll Period" := "Payroll Period";
                  PayrollBuffer[1]."Global Dimension 1 Code" := "Global Dimension 1 Code";
                  PayrollBuffer[1]."Global Dimension 2 Code" := "Global Dimension 2 Code";
                  PayrollBuffer[1]."Dimension Set ID" := "Dimension Set ID";
                  PayrollBuffer[1]."Job No."  := "Job No.";
                  PayrollBuffer[1]."Debit Acc. Type"  :=  "Debit Acc. Type";
                  PayrollBuffer[1]."Debit Account" :=  "Debit Account";
                  PayrollBuffer[1]."Credit Acc. Type" :=   "Credit Acc. Type";
                  PayrollBuffer[1]."Credit Account" := "Credit Account";
                  PayrollBuffer[1]."Loan ID" := "Loan ID";
                  PayrollHeader.Get("Payroll Period","Employee No.");
                  PayrollBuffer[1]."Currency Code" := PayrollHeader."Currency Code";
                  PayrollBuffer[1].Amount := Amount;
                  PayrollBuffer[2]  := PayrollBuffer[1];
                  if PayrollBuffer[2].Find then begin
                    PayrollBuffer[2].Amount := PayrollBuffer[2].Amount + PayrollBuffer[1].Amount;
                    PayrollBuffer[2].Modify;
                  end else
                    PayrollBuffer[1].Insert;
                end;
            end;

            trigger OnPostDataItem()
            begin
                ModifyAll(Status,Status::Posted);
            end;

            trigger OnPreDataItem()
            begin
                if not (SalaryType in [1,3]) then CurrReport.Break;

                SetRange("Payroll Period",PayrollPeriodCode);
            end;
        }
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_5444; 5444)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                  PayrollBuffer[1].FindFirst
                else
                  if PayrollBuffer[1].Next =0 then
                  CurrReport.Break;
                ConsecutiveNo :=
                    SEndToGL(TemplateName,PayrollBuffer[1]."Debit Account",PayrollBuffer[1]."Credit Account",BookingDate,VoucherNo,PostingDescription,
                          PayrollBuffer[1].Amount,PayrollBuffer[1]."Global Dimension 1 Code",PayrollBuffer[1]."Global Dimension 2 Code",
                          PayrollBuffer[1]."Job No.",ConsecutiveNo,PayrollBuffer[1]."Debit Acc. Type",PayrollBuffer[1]."Credit Acc. Type",BatchName,
                          '',PayrollBuffer[1]."Currency Code",PayrollBuffer[1]."Dimension Set ID");
            end;

            trigger OnPreDataItem()
            begin
                if PayrollBuffer[1].Count = 0 then
                  CurrReport.Break;
                Integer.SetRange(Number,1,PayrollBuffer[1].Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PayrollPeriodCode;PayrollPeriodCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Period';
                    TableRelation = "Payroll-Period";

                    trigger OnValidate()
                    begin
                        if PayrollPeriodCode <> '' then begin
                          PRollPeriodRec.Get(PayrollPeriodCode);
                          BookingDate := PRollPeriodRec."End Date";
                          MonthCode := Format(Date2dmy(PRollPeriodRec."End Date",2));
                          if StrLen(Format(Date2dmy(PRollPeriodRec."End Date",2))) < 2 then
                            MonthCode := '0' + Format(Date2dmy(PRollPeriodRec."End Date",2));
                          PeriodName := Format(Date2dmy(PRollPeriodRec."End Date",3));
                          //PeriodName := FORMAT(TODAY,0,'<MONTH TEXT>, <YEAR4>');
                          VoucherNo := 'SAL-' + DelChr(CopyStr(PeriodName,StrLen(PeriodName) - 3,4),'') + '-'
                            + MonthCode;
                          BatchName := 'PAYROLL';
                        end;
                    end;
                }
                field(BookingDate;BookingDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Posting Date';
                }
                field(BatchName;BatchName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Journal Batch';
                    Lookup = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        GenJnlBatch."Journal Template Name" := 'GENERAL';
                        GenJnlBatch.FilterGroup(2);
                        GenJnlBatch.SetRange("Journal Template Name",GenJnlBatch."Journal Template Name");
                        GenJnlBatch.FilterGroup(0);
                        if Page.RunModal(0,GenJnlBatch) = Action::LookupOK then begin
                          BatchName := GenJnlBatch.Name;
                        end;
                    end;
                }
                field(VoucherNo;VoucherNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Document No.';
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

    trigger OnInitReport()
    begin
        SalaryType := 1;
    end;

    trigger OnPostReport()
    begin
        PRollPeriodRec."Journal Created" := true;
        PRollPeriodRec.Modify;
    end;

    trigger OnPreReport()
    begin
        if (SalaryType in [1,3]) and (PayrollPeriodCode = '') then
          Error (Text001);
        
        if BookingDate = 0D then
          Error (Text002);
        
        if SalaryType = 0 then
          Error(Text003);
        
        TemplateName := 'GENERAL';
        
        PRollPeriodRec.Get(PayrollPeriodCode);
        if not(PRollPeriodRec.Closed) then
          Error(Text005);
        
        if PRollPeriodRec."Journal Created" = true then
          if not Confirm(Text004,true) then
              CurrReport.Break;
        
        
        /*The following is a constant used by PC&C. When a user creates a new line
          in the general ledger window, the line's Consecutive No is the value of the
          last ledger line plus 10,000*/
        
        "PC&CConstant" := 10000;
        PostingDescription := 'SALARY FOR ' + PRollPeriodRec.Name;
        
        
        Window.Open ('Total Number of Payroll Entry Lines   #1###\' +
                    'Current Station   #2####\'+
                    'Current Department    #3####\'+
                    'Current Job           #5####\'+
                    'Current Employee      #6####\'+
                    'Current E/D           #7####\'+
                    'Counter   #8###' );
        
        Window.Update (1, InfoCounter);
        InfoCounter := 0;
        
        
        ConsecutiveNo := 10000;

    end;

    var
        GLedgerReq: Record "Gen. Journal Template";
        GLHeader: Record "Gen. Journal Template";
        ProllLoanRec: Record "Payroll-Loan";
        GenJnlLine: Record "Gen. Journal Line";
        PRollPeriodRec: Record "Payroll-Period";
        LastPRollEntryRec: Record "Closed Payroll-Payslip Line";
        PayrollHeader: Record "Closed Payroll-Payslip Header";
        GenJnlBatch: Record "Gen. Journal Batch";
        LastPRollFirstHalfRec: Record "Proll-Pslip Lines First Half";
        GLAccount: Record "G/L Account";
        Cust: Record Customer;
        PayrollBuffer: array [2] of Record "Payroll Buffer" temporary;
        DimMgt: Codeunit DimensionManagement;
        VoucherNo: Code[20];
        DebugCode: Code[20];
        CompName: Code[10];
        BatchName: Code[20];
        TemplateName: Code[10];
        PayrollPeriodCode: Code[20];
        RecurringFrequency: DateFormula;
        PostingDescription: Text[50];
        AmtToBook: Decimal;
        PeriodName: Text[50];
        MonthCode: Text[30];
        RecurringFactor: Decimal;
        "PC&CConstant": Integer;
        ConsecutiveNo: Integer;
        NumOfRec: Integer;
        InfoCounter: Integer;
        SalaryType: Option " ","Month End","Mid Month",Both;
        UseRecurring: Boolean;
        ExpirationDate: Date;
        BookingDate: Date;
        Window: Dialog;
        Text001: label 'Period codes must be specified for the Month-End function';
        Text002: label 'Booking date must be specified for the function';
        Text003: label 'You must specify Mid Month or Month End!';
        Text004: label 'The Payroll Journal alreay created, do you really want to create the Payroll Journal again';
        Text005: label 'Payroll Period must be closed before you create a Journal';


    procedure SEndToGL(GLLName: Text[30];DebitAccNo: Code[20];CreditAccNo: Code[20];BookDate: Date;VouchNo: Text[30];GLLtext: Text[30];GLLAmount: Decimal;Dim1Code: Code[20];Dim2Code: Code[20];JobNo: Code[20];ConsNum: Integer;DebAccType: Integer;CredAccType: Integer;BatchName: Code[10];LoanID: Code[10];CurrencyCode: Code[20];DimSetID: Integer): Integer
    begin
        with GenJnlLine do begin
          if (DebitAccNo <> '') and (GLLAmount <> 0) then begin
            Init;
            GenJnlLine."Journal Template Name" := GLLName;
            GenJnlLine."Journal Batch Name" := BatchName;
            GenJnlLine."Line No."  := ConsNum;
            GenJnlLine."System-Created Entry" := true;
            GenJnlLine."Account Type"    := DebAccType;
            GenJnlLine."Account No."     := DebitAccNo;
            GenJnlLine."Posting Date"    := BookDate;
            GenJnlLine."Document No."    := VouchNo;
            GenJnlLine.Description := PostingDescription;
            GenJnlLine.Validate("Currency Code",CurrencyCode);
            GenJnlLine.Validate(Amount,GLLAmount);
            if JobNo <> '' then begin
              GenJnlLine.Validate("Job No.",JobNo);
              GenJnlLine.Validate("Job Quantity",1);
            end;
            GenJnlLine."Shortcut Dimension 1 Code" := Dim1Code;
            GenJnlLine."Shortcut Dimension 2 Code" := Dim2Code;
            GenJnlLine."Dimension Set ID" := DimSetID;
            GenJnlLine."Loan ID" := LoanID;
            GenJnlLine."Gen. Bus. Posting Group" := '';
            GenJnlLine."Gen. Prod. Posting Group" := '';
            GenJnlLine."Gen. Posting Type" := 0;
            GenJnlLine."VAT Prod. Posting Group" := '';
            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Prod. Posting Group" := '';
            GenJnlLine.Insert;
            ConsNum := ConsNum + "PC&CConstant";
          end;

          if (CreditAccNo <> '') and (GLLAmount <> 0) then begin
            Init;
            GenJnlLine."Journal Template Name"  := GLLName;
            GenJnlLine."Journal Batch Name" := BatchName;
            GenJnlLine."Line No.":= ConsNum;
            GenJnlLine."Account Type"   := CredAccType;
            GenJnlLine."Account No."    := CreditAccNo;
            GenJnlLine."Posting Date"   := BookDate;
            GenJnlLine."Document No."   := VouchNo;
            GenJnlLine.Description := PostingDescription;
            GenJnlLine.Validate("Currency Code",CurrencyCode);
            GenJnlLine.Validate(Amount,-GLLAmount);
            if JobNo <> '' then begin
              GenJnlLine.Validate("Job No.",JobNo);
              GenJnlLine.Validate("Job Quantity",1);
            end;
            GenJnlLine."Shortcut Dimension 1 Code" := Dim1Code;
            GenJnlLine."Shortcut Dimension 2 Code" := Dim2Code;
            GenJnlLine."Dimension Set ID" := DimSetID;
            GenJnlLine."Loan ID"   := LoanID;
            GenJnlLine."Gen. Bus. Posting Group" := '';
            GenJnlLine."Gen. Prod. Posting Group" := '';
            GenJnlLine."Gen. Posting Type" := 0;
            GenJnlLine."VAT Prod. Posting Group" := '';
            GenJnlLine."VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Bus. Posting Group" := '';
            GenJnlLine."Bal. VAT Prod. Posting Group" := '';
            GenJnlLine.Insert;
            ConsNum := ConsNum + "PC&CConstant";
          end;
          exit (ConsNum);
        end;
    end;
}

