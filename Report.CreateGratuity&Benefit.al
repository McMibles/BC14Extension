Report 52092146 "Create Gratuity & Benefit"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Create Gratuity & Benefit.rdlc';

    dataset
    {
        dataitem(Employee; "Payroll-Employee")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Employment Date", "Termination Date";
            column(ReportForNavId_7528; 7528)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(UserId; UserId)
            {
            }
            // column(Page_____FORMAT_CurrReport_PAGENO_; 'Page ' + Format(CurrReport.PageNo))
            // {
            // }
            column(Today; Today)
            {
            }
            column(FORMAT_Percentage_______of_Benefit_Amount_; Format(Percentage) + '% of Benefit Amount')
            {
            }
            column(BenefitAmt; BenefitAmt)
            {
            }
            column(BenefitPercent; BenefitPercent)
            {
            }
            column(PayrollPayslipLine_Amount___12; PayrollPayslipLine.Amount / 12)
            {
            }
            column(Age; Age)
            {
            }
            column(nYear_; nYear)
            {
            }
            column(BenefitAmt_Control3; BenefitAmt)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(First_Name__________Middle_Name___________Last_Name_; "First Name" + ' ' + "Middle Name" + ' ' + "Last Name")
            {
            }
            column(LastPayrollPeriod; LastPayrollPeriod)
            {
            }
            column(SerialNo; SerialNo)
            {
            }
            column(BenefitPercent_Control20; BenefitPercent)
            {
            }
            column(PayrollPayslipLine_Amount___12_Control19; PayrollPayslipLine.Amount / 12)
            {
            }
            column(Employee__No___Control28; "No.")
            {
            }
            column(First_Name__________Middle_Name___________Last_Name__Control29; "First Name" + ' ' + "Middle Name" + ' ' + "Last Name")
            {
            }
            column(SerialNo_Control33; SerialNo)
            {
            }
            column(BenefitAmt_Control38; BenefitAmt)
            {
            }
            column(BenefitPercent_Control39; BenefitPercent)
            {
            }
            column(BenefitAmt_Control5; BenefitAmt)
            {
            }
            column(BenefitPercent_Control27; BenefitPercent)
            {
            }
            column(STAFF_GRATUITY___BENEFITS_REPORTCaption; STAFF_GRATUITY___BENEFITS_REPORTCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(First_Name__________Middle_Name___________Last_Name_Caption; First_Name__________Middle_Name___________Last_Name_CaptionLbl)
            {
            }
            column(Basic_SalaryCaption; Basic_SalaryCaptionLbl)
            {
            }
            column(No__of_Years_in_ServiceCaption; No__of_Years_in_ServiceCaptionLbl)
            {
            }
            column(Benefit_AmountCaption; Benefit_AmountCaptionLbl)
            {
            }
            column(Last_Payroll_PeriodCaption; Last_Payroll_PeriodCaptionLbl)
            {
            }
            column(AgeCaption; AgeCaptionLbl)
            {
            }
            column(S_No_Caption; S_No_CaptionLbl)
            {
            }
            column(continuedCaption; continuedCaptionLbl)
            {
            }
            column(DATE_NOT_SPECIFIED______Caption; DATE_NOT_SPECIFIED______CaptionLbl)
            {
            }
            column(continues_________Caption; continues_________CaptionLbl)
            {
            }
            column(Total_Caption; Total_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin

                // calculate no. of years in service and age
                NoDate := false;
                if (Employee."Termination Date" <> 0D) and ((not InclTerminatedStaff) or
                   (Employee."Termination Date" < CurrDate)) then
                    CurrReport.Skip;

                if Employee."Employment Date" > CurrDate then
                    CurrReport.Skip;

                if (Employee."Employment Date" = 0D) or
                   (Employee."Birth Date" = 0D) then begin
                    NoDate := true;
                    exit;
                end;

                Employee.TestField("Employment Date");
                Employee.TestField("Birth Date");
                if Employee."Termination Date" = 0D then
                    RefDate := CurrDate
                else
                    RefDate := Employee."Termination Date";

                if (RefDate < Employee."Employment Date") and (RefDate = CalcDate('CM', Today)) then
                    Error(Text001, Employee."No.");

                BenefitAmt := 0;
                BenefitAmtToDate := 0;
                BenefitPercent := 0;

                GratuityEntry.SetFilter("Employee No.", Employee."No.");
                GratuityEntry.SetFilter("Period End Date", '<%1', RefDate);
                if GratuityEntry.Find('+') then begin
                    if GratuityEntry."Period End Date" > CurrDate then
                        CurrReport.Skip;
                    PeriodLength := Abs(ROUND(((Date2dmy(RefDate, 3) - Date2dmy(GratuityEntry."Period End Date", 3)) * 12 +
                                (Date2dmy(RefDate, 2) - Date2dmy(GratuityEntry."Period End Date", 2))) / 12))
                end else
                    PeriodLength := Abs(ROUND(((Date2dmy(RefDate, 3) - Date2dmy("Employment Date", 3)) * 12 +
                                (Date2dmy(RefDate, 2) - Date2dmy("Employment Date", 2))) / 12));

                nYear := ROUND(((Date2dmy(RefDate, 3) - Date2dmy("Employment Date", 3)) * 12 +
                              (Date2dmy(RefDate, 2) - Date2dmy("Employment Date", 2))) / 12, 1, '=');

                Age := Date2dmy(RefDate, 3) - Date2dmy("Birth Date", 3);


                if PayrollPayslipLine.Get(LastPayrollPeriod, Employee."No.", PayrollSetup."Annual Gross Pay E/D Code") then begin
                    BenefitAmt := CalcGratuity();
                    BenefitPercent := BenefitAmt * Percentage / 100;
                end;

                Employee.SetFilter("Date Filter", '<%1', RefDate);
                Employee.CalcFields(Employee."Gratuity Amount");

                BenefitAmtToDate := BenefitAmt + Employee."Gratuity Amount";

                TotalBenefitAmt := TotalBenefitAmt + BenefitAmt;
                TotalBenefitPercent := TotalBenefitPercent + BenefitPercent;
                TotalBenefitAmtToDate := TotalBenefitAmtToDate + BenefitAmtToDate;
            end;

            trigger OnPreDataItem()
            begin
                PayrollSetup.Get;
                PayrollSetup.TestField(PayrollSetup."Annual Gross Pay E/D Code");
                PayrollSetup.TestField(PayrollSetup."Total Emolument Factor Lookup");
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
        if LastPayrollPeriod = '' then
            Error(Text002);

        ProllPeriod.Get(LastPayrollPeriod);
        CurrDate := ProllPeriod."End Date";

        if Percentage = 0 then Percentage := 100;
    end;

    var
        PayrollSetup: Record "Payroll-Setup";
        FactorLookRec: Record "Payroll-Factor Lookup";
        PayrollPayslipLine: Record "Payroll-Payslip Line";
        ProllPeriod: Record "Payroll-Period";
        GratuityEntry: Record "Gratuity Ledger Entry";
        LastPayrollPeriod: Code[10];
        nYear: Integer;
        Age: Integer;
        SerialNo: Integer;
        BenefitAmt: Decimal;
        BenefitAmtToDate: Decimal;
        BenefitPercent: Decimal;
        TotalBenefitAmt: Decimal;
        TotalBenefitAmtToDate: Decimal;
        TotalBenefitPercent: Integer;
        PeriodLength: Decimal;
        Percentage: Decimal;
        CurrDate: Date;
        RefDate: Date;
        NoDate: Boolean;
        InclTerminatedStaff: Boolean;
        CreateGratuityEntry: Boolean;
        Text001: label 'Inconsistency in Date on Employee No. %1!';
        Text002: label 'You must specify Payroll Period to be used!';
        STAFF_GRATUITY___BENEFITS_REPORTCaptionLbl: label 'STAFF GRATUITY & BENEFITS REPORT';
        First_Name__________Middle_Name___________Last_Name_CaptionLbl: label 'Label9';
        Basic_SalaryCaptionLbl: label 'Basic Salary';
        No__of_Years_in_ServiceCaptionLbl: label ' No. of Years in Service';
        Benefit_AmountCaptionLbl: label 'Benefit Amount';
        Last_Payroll_PeriodCaptionLbl: label 'Last Payroll Period';
        AgeCaptionLbl: label 'Age';
        S_No_CaptionLbl: label 'S/No.';
        continuedCaptionLbl: label '........ continued';
        DATE_NOT_SPECIFIED______CaptionLbl: label '------- DATE NOT SPECIFIED -----';
        continues_________CaptionLbl: label 'continues.........';
        Total_CaptionLbl: label 'Total:';


    procedure CalcGratuity() ReturnAmount: Decimal
    var
        BenefitTable: Record "Benefit Factor";
        GratuityEntry2: Record "Gratuity Ledger Entry";
    begin
        PayrollSetup.TestField(PayrollSetup."Gratuity Benefit Factor Code");
        ReturnAmount := 0;
        BenefitTable.SetRange(BenefitTable.Code, PayrollSetup."Gratuity Benefit Factor Code");

        BenefitTable.SetFilter(BenefitTable."Lower Limit", '<=%1', nYear);
        BenefitTable.Find('+');
        BenefitTable.SetRange(BenefitTable."Upper Limit", BenefitTable."Upper Limit");
        if BenefitTable.Count > 1 then begin
            BenefitTable.SetFilter(BenefitTable."Min. Age", '<=%1', Age);
            BenefitTable.Find('+');
        end;

        case BenefitTable.Basis of
            BenefitTable.Basis::"Monthly Basic":
                begin
                    ReturnAmount := (PayrollPayslipLine.Amount / 12) * nYear * BenefitTable."Factor %" / 100;
                end;
            BenefitTable.Basis::"Total Emolument":
                begin
                    FactorLookRec.Get(PayrollSetup."Total Emolument Factor Lookup");
                    ReturnAmount := FactorLookRec.CalcAmount(PayrollPayslipLine, PayrollSetup."Annual Gross Pay E/D Code", LastPayrollPeriod,
                                    Employee."No.") * nYear * BenefitTable."Factor %" / 100;
                end;
        end;
        //Create Gratuity Ledger Entries
        if CreateGratuityEntry then begin
            if not (GratuityEntry2.Get(Employee."No.", ProllPeriod."End Date")) then begin
                GratuityEntry2.Init;
                GratuityEntry2."Employee No." := PayrollPayslipLine."Employee No.";
                GratuityEntry2."Period End Date" := ProllPeriod."End Date";
                GratuityEntry2."Current Amount" := ReturnAmount;
                GratuityEntry2."Period Length" := PeriodLength;
                case BenefitTable.Basis of
                    BenefitTable.Basis::"Monthly Basic":
                        GratuityEntry2."Basic Salary" := (PayrollPayslipLine.Amount / 12);
                    BenefitTable.Basis::"Total Emolument":
                        begin
                            FactorLookRec.Get(PayrollSetup."Total Emolument Factor Lookup");
                            GratuityEntry2."Basic Salary" := FactorLookRec.CalcAmount(PayrollPayslipLine, PayrollSetup."Annual Gross Pay E/D Code",
                                                             LastPayrollPeriod, Employee."No.")
                        end;
                end;
                GratuityEntry2.Insert;
            end;
        end;
    end;
}

