Report 52092195 "Bank Schedule Summary"
{
    // This report prints the payment schedules to banks.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Schedule Summary.rdlc';


    dataset
    {
        dataitem(Station; "Dimension Value")
        {
            DataItemTableView = sorting("Dimension Code", Code) order(ascending) where("Dimension Code" = const('STATION'), "Global Dimension No." = const(1));
            column(ReportForNavId_8177; 8177)
            {
            }
            column(Station_Dimension_Code; "Dimension Code")
            {
            }
            column(Station_Code; Code)
            {
            }
            dataitem(Employee; "Payroll-Employee")
            {
                DataItemLink = "Global Dimension 1 Code" = field(Code);
                DataItemTableView = sorting("Global Dimension 1 Code", "Employment Status", "Global Dimension 2 Code");
                column(ReportForNavId_7528; 7528)
                {
                }
                column(FORMAT_TODAY_0___MONTH_text____day_____YEAR4___; Format(Today, 0, '<MONTH text>  <day>,  <YEAR4>'))
                {
                }
                column(CompanyData_Name; CompanyData.Name)
                {
                }
                column(SUMMARY_OF_BANK_SCHEDULE_FOR__________FORMAT_PeriodRec__Start_Date__0___month_text___year4___; 'SUMMARY OF BANK SCHEDULE FOR' + ' ' + Format(PeriodRec."Start Date", 0, '<month text>,<year4>'))
                {
                }
                //column(CurrReport_PAGENO; CurrReport.PageNo)
                //{
                // }
                column(Employee__Global_Dimension_1_Code_; "Global Dimension 1 Code")
                {
                }
                column(Employee_EDAmount; "ED Amount")
                {
                    DecimalPlaces = 2 : 2;
                }
                column(BankRec__Bank_Name_; BankRec.Name)
                {
                }
                column(BankRec__Bank_Code_; BankRec.Code)
                {
                }
                column(NoOfEmployee; NoOfEmployee)
                {
                }
                column(Station_Code_Control1000000001; Station.Code)
                {
                }
                column(EmpTotal; EmpTotal)
                {
                }
                column(TotalBasicAm; TotalBasicAm)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(DATE_Caption; DATE_CaptionLbl)
                {
                }
                column(PageCaption; PageCaptionLbl)
                {
                }
                column(Employee__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code"))
                {
                }
                column(BANK_CODECaption; BANK_CODECaptionLbl)
                {
                }
                column(DESCRIPTIONCaption; DESCRIPTIONCaptionLbl)
                {
                }
                column(NO__OF_EMPLOYEESCaption; NO__OF_EMPLOYEESCaptionLbl)
                {
                }
                column(CURRENT_AMOUNTCaption; CURRENT_AMOUNTCaptionLbl)
                {
                }
                column(TOTAL_AMOUNT_FOR_Caption; TOTAL_AMOUNT_FOR_CaptionLbl)
                {
                }
                column(Employee_No_; "No.")
                {
                }
                column(Employee_Main_Bank_Code; "Employment Status")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("ED Amount");
                    case PayrollType of
                        2:
                            BasicAm := "ED Amount";
                        //1: BasicAm := "ED FirstHalf Amount";
                        else
                            Error('You must specify whether First Half or Month End!');
                    end; /*end case*/
                    if "ED Amount" <> 0 then
                        PaySlipHeader.Get(PeriodFilter, "No.");

                    if (BasicAm <= 0) or (PaySlipHeader."WithHold Salary") then
                        CurrReport.Skip;

                    TotalBasicAm := TotalBasicAm + BasicAm;
                    EmpTotal := EmpTotal + 1

                end;

                trigger OnPreDataItem()
                begin
                    CompanyData.Get;
                    SetRange("ED Filter", BankReportCode);
                    SetRange("Period Filter", PeriodFilter);
                    //CurrReport.CreateTotals(BasicAm, "ED Amount");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                EmpTotal := 0;
                TotalBasicAm := 0;
            end;

            trigger OnPreDataItem()
            begin
                Station.SetFilter(Station.Code, StationFilter);
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

    trigger OnInitReport()
    begin
        PayrollType := 2;
    end;

    trigger OnPreReport()
    begin
        CompanyData.Get;
        if PeriodFilter <> '' then
            PeriodRec.Get(PeriodFilter)
        else
            Error(Text002);
    end;

    var
        Text001: label 'Please credit the following Account(s) with the amount(s}\indicated against them.';
        CompanyData: Record "Company Information";
        EDCode: Record "Payroll-E/D";
        HeaderText: Text[40];
        StoreRec: Record Employee;
        PeriodRec: Record "Payroll-Period";
        BankRec: Record Bank;
        PaySlipHeader: Record "Payroll-Payslip Header";
        BankReportCode: Code[20];
        NoOfEmployee: Integer;
        EmpTotal: Integer;
        PayrollType: Option " ","First Half","Month End";
        BasicAm: Decimal;
        TotalBasicAm: Decimal;
        GrpAmount: Decimal;
        NewBank: Boolean;
        PeriodFilter: Text[30];
        PayrollSetup: Record "Payroll-Setup";
        StationFilter: Text[250];
        Text002: label 'Period must be specified!';
        //DimMgt: Codeunit DimensionManagement;
        DATE_CaptionLbl: label 'DATE:';
        PageCaptionLbl: label 'Page';
        BANK_CODECaptionLbl: label 'BANK CODE';
        DESCRIPTIONCaptionLbl: label 'DESCRIPTION';
        NO__OF_EMPLOYEESCaptionLbl: label 'NO. OF EMPLOYEES';
        CURRENT_AMOUNTCaptionLbl: label 'CURRENT AMOUNT';
        TOTAL_AMOUNT_FOR_CaptionLbl: label 'TOTAL AMOUNT FOR:';
}

