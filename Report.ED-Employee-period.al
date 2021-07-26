Report 52092163 "E/D-Employee-period"
{
    // For upto 12 selected periods, this report prints the amounts for an E/D for
    // an employee, for each of this periods. The total amount for the periods is
    // also printed for each employee.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ED-Employee-period.rdlc';


    dataset
    {
        dataitem("Payroll-E/D"; "Payroll-E/D")
        {
            DataItemTableView = sorting("E/D Code");
            PrintOnlyIfDetail = false;
            column(ReportForNavId_9150; 9150)
            {
            }
            column(CompanyData_Name; CompanyData.Name)
            {
            }
            column(Today; Today)
            {
            }
            column(Employee_Entries_per_period_Caption; Employee_Entries_per_period_CaptionLbl)
            {
            }
            column(Report_print_date_Caption; Report_print_date_CaptionLbl)
            {
            }
            column(E_D_EMPLOYEE_PERIODCaption; E_D_EMPLOYEE_PERIODCaptionLbl)
            {
            }
            column(Payroll_E_D_Codes_E_D_Code; "E/D Code")
            {
            }
            dataitem(ClosedPayslipLine; "Closed Payroll-Payslip Line")
            {
                DataItemLink = "E/D Code" = field("E/D Code");
                DataItemTableView = sorting("E/D Code", "Employee No.", "Payroll Period");
                PrintOnlyIfDetail = false;
                RequestFilterFields = "Employee No.", "Global Dimension 1 Code", "Employee Category";
                RequestFilterHeading = 'Employees';
                column(ReportForNavId_4449; 4449)
                {
                }
                column(Payroll_E_D_Codes___E_D_Code_; "Payroll-E/D"."E/D Code")
                {
                }
                column(ReqPeriodsArray_1___Period_Code_; ReqPeriodsArray[1]."Period Code")
                {
                }
                column(ReqPeriodsArray_2___Period_Code_; ReqPeriodsArray[2]."Period Code")
                {
                }
                column(ReqPeriodsArray_3___Period_Code_; ReqPeriodsArray[3]."Period Code")
                {
                }
                column(ReqPeriodsArray_4___Period_Code_; ReqPeriodsArray[4]."Period Code")
                {
                }
                column(ReqPeriodsArray_5___Period_Code_; ReqPeriodsArray[5]."Period Code")
                {
                }
                column(ReqPeriodsArray_6___Period_Code_; ReqPeriodsArray[6]."Period Code")
                {
                }
                column(Payroll_E_D_Codes__Description; "Payroll-E/D".Description)
                {
                }
                column(ReqPeriodsArray_12___Period_Code_; ReqPeriodsArray[12]."Period Code")
                {
                }
                column(ReqPeriodsArray_11___Period_Code_; ReqPeriodsArray[11]."Period Code")
                {
                }
                column(ReqPeriodsArray_10___Period_Code_; ReqPeriodsArray[10]."Period Code")
                {
                }
                column(ReqPeriodsArray_9___Period_Code_; ReqPeriodsArray[9]."Period Code")
                {
                }
                column(ReqPeriodsArray_8___Period_Code_; ReqPeriodsArray[8]."Period Code")
                {
                }
                column(ReqPeriodsArray_7___Period_Code_; ReqPeriodsArray[7]."Period Code")
                {
                }
                column(EDAmountsArray_6_; EDAmountsArray[6])
                {
                }
                column(EDAmountsArray_7_; EDAmountsArray[7])
                {
                }
                column(EDAmountsArray_5_; EDAmountsArray[5])
                {
                }
                column(EDAmountsArray_4_; EDAmountsArray[4])
                {
                }
                column(EDAmountsArray_2_; EDAmountsArray[2])
                {
                }
                column(EDAmountsArray_3_; EDAmountsArray[3])
                {
                }
                column(EDAmountsArray_1_; EDAmountsArray[1])
                {
                }
                column(DELCHR__EmployeeName_______; DelChr(EmployeeName, '<>'))
                {
                }
                column(Payroll_Payslip_Lines__Employee_No_; "Employee No.")
                {
                }
                column(EDAmountsArray_13_; EDAmountsArray[13])
                {
                }
                column(EDAmountsArray_12_; EDAmountsArray[12])
                {
                }
                column(EDAmountsArray_11_; EDAmountsArray[11])
                {
                }
                column(EDAmountsArray_10_; EDAmountsArray[10])
                {
                }
                column(EDAmountsArray_9_; EDAmountsArray[9])
                {
                }
                column(EDAmountsArray_8_; EDAmountsArray[8])
                {
                }
                column(EmpCount; EmpCount)
                {
                }
                column(EmpText; EmpText)
                {
                }
                column(EDAmountsArray_6__Control24; EDAmountsArray[6])
                {
                }
                column(EDAmountsArray_7__Control25; EDAmountsArray[7])
                {
                }
                column(EDAmountsArray_5__Control26; EDAmountsArray[5])
                {
                }
                column(EDAmountsArray_4__Control27; EDAmountsArray[4])
                {
                }
                column(EDAmountsArray_2__Control28; EDAmountsArray[2])
                {
                }
                column(EDAmountsArray_3__Control29; EDAmountsArray[3])
                {
                }
                column(EDAmountsArray_1__Control30; EDAmountsArray[1])
                {
                }
                column(EDAmountsArray_13__Control51; EDAmountsArray[13])
                {
                }
                column(EDAmountsArray_12__Control52; EDAmountsArray[12])
                {
                }
                column(EDAmountsArray_11__Control53; EDAmountsArray[11])
                {
                }
                column(EDAmountsArray_10__Control54; EDAmountsArray[10])
                {
                }
                column(EDAmountsArray_9__Control55; EDAmountsArray[9])
                {
                }
                column(EDAmountsArray_8__Control56; EDAmountsArray[8])
                {
                }
                column(E_D_Code_Caption; E_D_Code_CaptionLbl)
                {
                }
                column(TotalsCaption; TotalsCaptionLbl)
                {
                }
                column(Number_of_employees______________________Caption; Number_of_employees______________________CaptionLbl)
                {
                }
                column(TOTAL_AMOUNTSCaption; TOTAL_AMOUNTSCaptionLbl)
                {
                }
                column(NB__Report_is_for_Employee_Numbers_Caption; NB__Report_is_for_Employee_Numbers_CaptionLbl)
                {
                }
                column(Payroll_Payslip_Lines_Payroll_Period; "Payroll Period")
                {
                }
                column(Payroll_Payslip_Lines_E_D_Code; "E/D Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    FoundPos := 0;
                    case "Payroll Period" of

                        ReqPeriodsArray[1]."Period Code":
                            begin
                                EDAmountsArray[1] := Amount;
                                FoundPos := 1;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[2]."Period Code":
                            begin
                                EDAmountsArray[2] := Amount;
                                FoundPos := 2;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[3]."Period Code":
                            begin
                                EDAmountsArray[3] := Amount;
                                FoundPos := 3;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[4]."Period Code":
                            begin
                                EDAmountsArray[4] := Amount;
                                FoundPos := 4;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[5]."Period Code":
                            begin
                                EDAmountsArray[5] := Amount;
                                FoundPos := 5;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[6]."Period Code":
                            begin
                                EDAmountsArray[6] := Amount;
                                FoundPos := 6;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[7]."Period Code":
                            begin
                                EDAmountsArray[7] := Amount;
                                FoundPos := 7;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[8]."Period Code":
                            begin
                                EDAmountsArray[8] := Amount;
                                FoundPos := 8;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[9]."Period Code":
                            begin
                                EDAmountsArray[9] := Amount;
                                FoundPos := 9;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[10]."Period Code":
                            begin
                                EDAmountsArray[10] := Amount;
                                FoundPos := 10;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[11]."Period Code":
                            begin
                                EDAmountsArray[11] := Amount;
                                FoundPos := 11;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                        ReqPeriodsArray[12]."Period Code":
                            begin
                                EDAmountsArray[12] := Amount;
                                FoundPos := 12;
                                EDAmountsArray[13] := EDAmountsArray[13] + Amount;
                            end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    // CurrReport.CreateTotals(EDAmountsArray[1], EDAmountsArray[2], EDAmountsArray[3],
                    //                  EDAmountsArray[4], EDAmountsArray[5], EDAmountsArray[6],
                    //                  EDAmountsArray[7], EDAmountsArray[8], EDAmountsArray[9],
                    //                  EDAmountsArray[10]);
                    // CurrReport.CreateTotals(EDAmountsArray[11], EDAmountsArray[12], EDAmountsArray[13]);

                    EmpText := GetFilter("Employee No.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                EmpCount := 0;
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

    var
        CompanyData: Record "Company Information";
        EmployeeRec: Record "Payroll-Employee Group Header";
        EmployeeName: Text[40];
        ReqPeriodsArray: array[12] of Record "Payroll-Period";
        EDAmountsArray: array[13] of Decimal;
        ArrayIndex: Integer;
        ArrayTop: Integer;
        FoundPos: Integer;
        EmpCount: Integer;
        EmpText: Text[50];
        Employee_Entries_per_period_CaptionLbl: label 'Employee Entries per period.';
        Report_print_date_CaptionLbl: label 'Report print date:';
        E_D_EMPLOYEE_PERIODCaptionLbl: label 'E/D EMPLOYEE PERIOD';
        E_D_Code_CaptionLbl: label 'E/D Code:';
        TotalsCaptionLbl: label 'Totals';
        Number_of_employees______________________CaptionLbl: label 'Number of employees.....................:';
        TOTAL_AMOUNTSCaptionLbl: label 'TOTAL AMOUNTS';
        NB__Report_is_for_Employee_Numbers_CaptionLbl: label 'NB: Report is for Employee Numbers:';
}

