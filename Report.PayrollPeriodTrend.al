Report 52092194 "Payroll Period Trend"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Period Trend.rdlc';

    dataset
    {
        dataitem("Payroll-Employee"; "Payroll-Employee")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(ReportForNavId_1575; 1575)
            {
            }
            column(Company_Info; DelChr(CompanyData.Name, '<>') + ', ' + CompanyData.Address)
            {
            }
            column(PayrollED_Description; PayrollED.Description)
            {
            }
            column(PeriodText_1_; PeriodText[1])
            {
            }
            column(PeriodText_2_; PeriodText[2])
            {
            }
            column(PeriodText_3_; PeriodText[3])
            {
            }
            column(PeriodText_4_; PeriodText[4])
            {
            }
            column(PeriodText_8_; PeriodText[8])
            {
            }
            column(PeriodText_7_; PeriodText[7])
            {
            }
            column(PeriodText_6_; PeriodText[6])
            {
            }
            column(PeriodText_5_; PeriodText[5])
            {
            }
            column(PeriodText_12_; PeriodText[12])
            {
            }
            column(PeriodText_11_; PeriodText[11])
            {
            }
            column(PeriodText_10_; PeriodText[10])
            {
            }
            column(PeriodText_9_; PeriodText[9])
            {
            }
            column(Payroll_Employee__FullName; "Payroll-Employee".FullName)
            {
            }
            column(Employee_No; "Payroll-Employee"."No.")
            {
            }
            column(EDAmountsArray_1_; EDAmountsArray[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_2_; EDAmountsArray[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_3_; EDAmountsArray[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_4_; EDAmountsArray[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_9_; EDAmountsArray[9])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_12_; EDAmountsArray[12])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_7_; EDAmountsArray[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_6_; EDAmountsArray[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_5_; EDAmountsArray[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_8_; EDAmountsArray[8])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_11_; EDAmountsArray[11])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsTotal; EDAmountsTotal)
            {
            }
            column(EDAmountsArray_10_; EDAmountsArray[10])
            {
                DecimalPlaces = 0 : 0;
            }
            column(SerialNo; SerialNo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ("Termination Date" <> 0D) and ("Termination Date" < StartDate) or
                   ("Employment Date" <> 0D) and ("Employment Date" > EndDate) then
                    CurrReport.Skip;

                EDAmountsTotal := 0;

                // ED Value for each period
                for i := 1 to ArrayTop do begin
                    if PayrollPayslipLine.Get(PeriodCode[i], "No.", EDCode) then
                        EDAmountsArray[i] := PayrollPayslipLine.Amount
                    else
                        EDAmountsArray[i] := 0;
                    EDAmountsTotal := EDAmountsTotal + EDAmountsArray[i];
                end;

                SerialNo := SerialNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                UserSetup.Get(UserId);
                if not (UserSetup."Payroll Administrator") then begin
                    FilterGroup(2);
                    SetFilter("Employee Category", UserSetup."Personnel Level");
                    FilterGroup(0);
                end else
                    SetRange("Employee Category");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartPeriod; StartPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'From Period';
                    TableRelation = "Payroll-Period";
                }
                field(EndPeriod; EndPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'To Period';
                    TableRelation = "Payroll-Period";
                }
                field(EDCode; EDCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'ED Filter';
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
        Report_Title = 'PAYROLL PERIOD TREND';
    }

    trigger OnPreReport()
    begin
        if (StartPeriod = '') or (EndPeriod = '') then
            Error(Text001);
        if EDCode = '' then
            Error(Text005);
        if StartPeriod > EndPeriod then Error(Text002);

        // get date range
        PeriodRec.Get(StartPeriod);
        StartDate := PeriodRec."Start Date";
        PeriodRec.Get(EndPeriod);
        EndDate := PeriodRec."End Date";

        PeriodRec.SetRange(PeriodRec."Period Code", StartPeriod, EndPeriod);
        ArrayTop := PeriodRec.Count;
        if ArrayTop > 12 then Error(Text003);

        // period text
        PeriodRec.Find('-');
        i := 1;
        repeat
            PeriodCode[i] := PeriodRec."Period Code";
            PeriodText[i] := Format(PeriodRec."End Date", 3, '<Month Text>');
            i := i + 1;
        until PeriodRec.Next = 0;

        if "Payroll-Employee".GetFilters <> '' then
            EmplHeadTxt := "Payroll-Employee".GetFilters
        else
            EmplHeadTxt := Text004;

        PayrollED.Get(EDCode);
    end;

    var
        CompanyData: Record "Company Information";
        PayrollPayslipLine: Record "Closed Payroll-Payslip Line";
        PeriodRec: Record "Payroll-Period";
        PayrollSetup: Record "Payroll-Setup";
        PayrollED: Record "Payroll-E/D";
        UserSetup: Record "User Setup";
        EDCode: Code[10];
        StartPeriod: Code[10];
        EndPeriod: Code[10];
        PeriodCode: array[12] of Code[10];
        PeriodText: array[12] of Text[10];
        EmplHeadTxt: Text[150];
        StartDate: Date;
        EndDate: Date;
        EDAmountsArray: array[12] of Decimal;
        EDAmountsTotal: Decimal;
        ArrayTop: Integer;
        i: Integer;
        SerialNo: Integer;
        Text001: label 'From Period and To Period must not be empty';
        Text002: label 'Period range not correct!';
        Text003: label 'Period range more than twelve months';
        Text004: label 'Schedule for All Employees.';
        Text005: Label 'E/D code must be specify';
}

