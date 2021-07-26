Report 52092145 "PRoll; Test Posting Details"
{
    // 
    // This batch job checkts payroll posting details for correctness
    // 
    // It ensures conformity with the e/d posting options and test account nos.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PRoll; Test Posting Details.rdlc';


    dataset
    {
        dataitem("Payroll-Payslip Line"; "Payroll-Payslip Line")
        {
            DataItemTableView = sorting("Payroll Period", "Employee No.", "E/D Code") order(ascending);
            RequestFilterFields = "Payroll Period", "Employee No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Employee Category";
            column(ReportForNavId_4449; 4449)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(Payroll_Payslip_Lines__GETFILTERS_____Month_End_; GetFilters + ' Month End')
            {
            }
            column(UserId; UserId)
            {
            }
            //column(CurrReport_PAGENO; CurrReport.PageNo)
            //{
            //}
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(Payroll_Payslip_Lines__Employee_No_; "Employee No.")
            {
            }
            column(Payroll_Payslip_Lines__E_D_Code_; "E/D Code")
            {
            }
            column(ErrorMsg; ErrorMsg)
            {
            }
            column(SerialNo; SerialNo)
            {
            }
            column(Payroll_Payslip_Lines__Debit_Account_; "Debit Account")
            {
            }
            column(Payroll_Payslip_Lines__Credit_Account_; "Credit Account")
            {
            }
            column(Payroll_Payslip_Lines__Debit_Acc__Type_; "Debit Acc. Type")
            {
            }
            column(Payroll_Payslip_Lines__Credit_Acc__Type_; "Credit Acc. Type")
            {
            }
            column(Payroll_Payslip_Lines_Amount; Amount)
            {
            }
            column(Total_for______Employee_No_; 'Total for ' + "Employee No.")
            {
            }
            column(AmountToGL; AmountToGL)
            {
            }
            column(TotalAmountToGL; TotalAmountToGL)
            {
            }
            column(Posting_Details___TestCaption; Posting_Details___TestCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No_Caption; No_CaptionLbl)
            {
            }
            column(Payroll_Payslip_Lines__E_D_Code_Caption; FieldCaption("E/D Code"))
            {
            }
            column(Error_MessageCaption; Error_MessageCaptionLbl)
            {
            }
            column(SerialNoCaption; SerialNoCaptionLbl)
            {
            }
            column(Payroll_Payslip_Lines__Debit_Account_Caption; FieldCaption("Debit Account"))
            {
            }
            column(Payroll_Payslip_Lines__Credit_Account_Caption; FieldCaption("Credit Account"))
            {
            }
            column(Payroll_Payslip_Lines__Debit_Acc__Type_Caption; FieldCaption("Debit Acc. Type"))
            {
            }
            column(Payroll_Payslip_Lines__Credit_Acc__Type_Caption; FieldCaption("Credit Acc. Type"))
            {
            }
            column(Payroll_Payslip_Lines_AmountCaption; FieldCaption(Amount))
            {
            }
            column(TotalAmountToGLCaption; TotalAmountToGLCaptionLbl)
            {
            }
            column(Payroll_Payslip_Lines_Payroll_Period; "Payroll Period")
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(2, "Payroll Period");
                Window.Update(3, "Employee No.");
                Window.Update(4, "E/D Code");
                InfoCounter := InfoCounter + 1;
                Window.Update(5, InfoCounter);
                AmountToGL := 0;
                // ignore if amount = 0
                if Amount = 0 then
                    CurrReport.Skip;

                EDFileRec.Get("E/D Code");
                ErrorMsg := '';

                // checks for conformity with e/d posting setup
                case EDFileRec.Posting of
                    1:
                        if ("Debit Account" <> '') or ("Credit Account" <> '') then
                            ErrorMsg := ' - Debit/Credit Account Nos. must not be specified!';
                    2:
                        begin
                            if "Debit Account" = '' then
                                ErrorMsg := ' - Debit Account must be specified!';
                            if "Credit Account" <> '' then
                                ErrorMsg := ErrorMsg + ' - Credit Account must not be specified!';
                        end;
                    3:
                        begin
                            if "Debit Account" <> '' then
                                ErrorMsg := ' - Debit Account must not be specified!';
                            if "Credit Account" = '' then
                                ErrorMsg := ErrorMsg + ' - Credit Account must be specified!';
                        end;
                    4:
                        if ("Debit Account" = '') or ("Credit Account" = '') then
                            ErrorMsg := ' - Debit/Credit Account Nos. must be specified!';
                end; /*end case*/

                if "Debit Account" <> '' then
                    case "Debit Acc. Type" of
                        0:
                            if not GLAccount.Get("Debit Account") then
                                ErrorMsg := ErrorMsg + ' - G/L Account No ' + "Debit Account" + ' does not exist';
                        1:
                            if not Customer.Get("Debit Account") then
                                ErrorMsg := ErrorMsg + ' - Customer Account No ' + "Debit Account" + ' does not exist';
                        2:
                            if not Vendor.Get("Debit Account") then
                                ErrorMsg := ErrorMsg + ' - Vendor Account No ' + "Debit Account" + ' does not exist';
                    end; /*end case*/

                if "Credit Account" <> '' then
                    case "Credit Acc. Type" of
                        0:
                            if not GLAccount.Get("Credit Account") then
                                ErrorMsg := ErrorMsg + ' - G/L Account No ' + "Credit Account" + ' does not exist';
                        1:
                            if not Customer.Get("Credit Account") then
                                ErrorMsg := ErrorMsg + ' - Customer Account No ' + "Credit Account" + ' does not exist';
                        2:
                            if not Vendor.Get("Credit Account") then
                                ErrorMsg := ErrorMsg + ' - Vendor Account No ' + "Credit Account" + ' does not exist';
                    end; /*end case*/
                // accummulates the amount to be journalised
                if "Debit Account" <> '' then begin
                    AmountToGL := AmountToGL + Amount;
                    TotalAmountToGL := TotalAmountToGL + Amount;
                    SerialNo := SerialNo + 1;
                end;
                if "Credit Account" <> '' then begin
                    AmountToGL := AmountToGL - Amount;
                    TotalAmountToGL := TotalAmountToGL - Amount;
                    SerialNo := SerialNo + 1;
                end;
                if (ErrorMsg = '') and (AmountToGL = 0) then
                    CurrReport.Skip;

            end;

            trigger OnPreDataItem()
            begin
                SerialNo := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        if "Payroll-Payslip Line".GetFilter("Payroll Period") = '' then
            Error(Text001);

        InfoCounter := "Payroll-Payslip Line".Count;

        if InfoCounter = 0 then
            Error(Text002);

        Window.Open('Total Number of Payroll Entry Lines   #1###\' +
                    'Current Period        #2####\' +
                    'Current Employee      #3####\' +
                    'Current E/D           #4####\' +
                    'Counter   #5###');

        Window.Update(1, InfoCounter);
        InfoCounter := 0;
        TotalAmountToGL := 0;
    end;

    var
        EDFileRec: Record "Payroll-E/D";
        GLAccount: Record "G/L Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        ErrorMsg: Text[120];
        AmountToGL: Decimal;
        TotalAmountToGL: Decimal;
        MaxValue: Decimal;
        MinValue: Decimal;
        InfoCounter: Integer;
        SerialNo: Integer;
        SalaryType: Option " ","Month End","Mid Month",Both;
        Window: Dialog;
        Text001: label 'Period codes must be specified for the function';
        Text002: label 'No Payroll Records satisfying this delimitations were found';
        Text003: label 'Min. Value cannot be greater than Max. Value!';
        Posting_Details___TestCaptionLbl: label 'Posting Details - Test';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No_CaptionLbl: label 'No.';
        Error_MessageCaptionLbl: label 'Error Message';
        SerialNoCaptionLbl: label 'S/No.';
        TotalAmountToGLCaptionLbl: label 'GRAND TOTAL';
}

