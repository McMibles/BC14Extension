Report 52092180 "PFA Global Summary By Dept."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PFA Global Summary By Dept..rdlc';

    dataset
    {
        dataitem(Employee; "Payroll-Payslip Header")
        {
            DataItemTableView = sorting("Global Dimension 1 Code", "Global Dimension 2 Code");
            RequestFilterFields = "Pension Adminstrator Code";
            RequestFilterHeading = 'PFA';
            column(ReportForNavId_7528; 7528)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(UserId; UserId)
            {
            }
            column(GetPFAName__Pension_Adminstrator_Code__; GetPFAName("Pension Adminstrator Code"))
            {
            }
            column(CompanyData_Name; CompanyData.Name)
            {
            }
            column(FORMAT_TODAY_0___MONTH_text____day_____YEAR4___; Format(Today, 0, '<MONTH text>  <day>,  <YEAR4>'))
            {
            }
            column(SUMMARY_BY_PFA_BY_DEPARTMENT_FOR_________UPPERCASE__DELCHR__PeriodRec_Name________; 'SUMMARY BY PFA BY DEPARTMENT FOR' + ' ' + UpperCase(DelChr(PeriodRec.Name, '<>')))
            {
            }
            column(Employee_Employee__Global_Dimension_1_Code_; Employee."Global Dimension 1 Code")
            {
            }
            column(PensionAmt; PensionAmt)
            {
            }
            column(EmpCount; EmpCount)
            {
            }
            column(NoofRecord; NoofRecord)
            {
            }
            column(PensionAmt_Control39; PensionAmt)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(PAYROLL_REPORT_BY_PENSION_FUND_ADMINCaption; PAYROLL_REPORT_BY_PENSION_FUND_ADMINCaptionLbl)
            {
            }
            column(OFFICE_LOCATIONCaption; OFFICE_LOCATIONCaptionLbl)
            {
            }
            column(NO__OF_EMPLOYEESCaption; NO__OF_EMPLOYEESCaptionLbl)
            {
            }
            column(CURRENT_AMOUNTCaption; CURRENT_AMOUNTCaptionLbl)
            {
            }
            column(PFACaption; PFACaptionLbl)
            {
            }
            column(DATE_Caption; DATE_CaptionLbl)
            {
            }
            column(Total_Number_of_records_Caption; Total_Number_of_records_CaptionLbl)
            {
            }
            column(Employee_Payroll_Period; "Payroll Period")
            {
            }
            column(Employee_Employee_No; "Employee No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not ProllPslipLines.Get(PayrollPeriod, Employee."Employee No.", EmployeeED) then
                    CurrReport.Skip
                else
                    EmployeePercent := ProllPslipLines.Amount;

                if not ProllPslipLines.Get(PayrollPeriod, Employee."Employee No.", EmployerED) then
                    CurrReport.Skip
                else
                    EmployerPercent := ProllPslipLines.Amount;

                if (EmployeePercent = 0) or (EmployerPercent = 0) then
                    CurrReport.Skip;

                PensionAmt := EmployeePercent + EmployerPercent;

                NoofRecord := NoofRecord + 1;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Payroll Period", PayrollPeriod);
                UserSetup.Get(UserId);
                if not (UserSetup."Payroll Administrator") then begin
                    FilterGroup(2);
                    SetFilter("Employee Category", UserSetup."Personnel Level");
                    FilterGroup(0);
                end else
                    SetRange("Employee Category");
                //CurrReport.CreateTotals(PensionAmt);
                NoofRecord := 0;
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
                field(EmployeeED; EmployeeED)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Employee ED';
                    TableRelation = "Payroll-E/D";
                }
                field(EmployerED; EmployerED)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pension Employer ED';
                    TableRelation = "Payroll-E/D";
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
        if PayrollPeriod = '' then
            Error(TEXT001);

        PFAName := Employee.GetFilter(Employee."Pension Adminstrator Code");
        if PFAName = '' then
            Error(TEXT002);
    end;

    var
        CompanyData: Record "Company Information";
        ProllPslipHeader: Record "Payroll-Payslip Header";
        ProllPslipLines: Record "Payroll-Payslip Line";
        UserSetup: Record "User Setup";
        PayrollPeriod: Code[10];
        BasicSalary: Decimal;
        GrossPay: Decimal;
        PensionAmt: Decimal;
        EmployeePercent: Decimal;
        EmployerPercent: Decimal;
        NoofRecord: Integer;
        PensionScheme: Code[20];
        EmployeeED: Code[10];
        EmployerED: Code[10];
        EmpCount: Integer;
        PeriodRec: Record "Payroll-Period";
        TEXT001: label 'Payroll Period must be specified!';
        PFAName: Text[80];
        TEXT002: label 'You must specify the Pension Administrator!';
        PageCaptionLbl: label 'Page';
        PAYROLL_REPORT_BY_PENSION_FUND_ADMINCaptionLbl: label 'PAYROLL REPORT BY PENSION FUND ADMIN';
        OFFICE_LOCATIONCaptionLbl: label 'OFFICE LOCATION';
        NO__OF_EMPLOYEESCaptionLbl: label 'NO. OF EMPLOYEES';
        CURRENT_AMOUNTCaptionLbl: label 'CURRENT AMOUNT';
        PFACaptionLbl: label 'PFA';
        DATE_CaptionLbl: label 'DATE:';
        Total_Number_of_records_CaptionLbl: label 'Total Number of records:';


    procedure GetPFAName(PFACode: Code[20]): Text[50]
    var
        PFARec: Record "Pension Administrator";
    begin
        if PFACode <> '' then begin
            PFARec.Get(PFACode);
            exit(PFARec.Name);
        end else
            exit('');
    end;
}

