Report 52092171 "ED Entries per Period"
{
    // For upto 12 selected periods, this report prints the amounts for an E/D for
    // an employee, for each of this periods. The total amount for the periods is
    // also printed for each employee.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ED Entries per Period.rdlc';


    dataset
    {
        dataitem(ED; "Payroll-E/D")
        {
            DataItemTableView = sorting("E/D Code") where(Posting = filter(<> None));
            PrintOnlyIfDetail = false;
            RequestFilterFields = "E/D Code";
            column(ReportForNavId_9150; 9150)
            {
            }
            column(CompanyData_Name; CompanyData.Name)
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
            column(EDAmountsArray_6_; EDAmountsArray[6])
            {
            }
            column(EDAmountsArrayTotal; EDAmountsArrayTotal)
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
            column(Payroll_E_D_Codes_Description; Description)
            {
            }
            column(Payroll_E_D_Codes__E_D_Code_; "E/D Code")
            {
            }
            column(EDAmountsArray_1__Control1000000002; EDAmountsArray[1])
            {
            }
            column(EDAmountsArray_2__Control1000000003; EDAmountsArray[2])
            {
            }
            column(EDAmountsArray_3__Control1000000004; EDAmountsArray[3])
            {
            }
            column(EDAmountsArray_4__Control1000000005; EDAmountsArray[4])
            {
            }
            column(EDAmountsArray_5__Control1000000006; EDAmountsArray[5])
            {
            }
            column(EDAmountsArray_6__Control1000000007; EDAmountsArray[6])
            {
            }
            column(EDAmountsArrayTotal_Control1000000008; EDAmountsArrayTotal)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "E/D Code");
                for ArrayIndex := 1 to ArrayTop do begin
                    EDAmountsArray[ArrayIndex] := 0;
                    if ReqPeriodsArray[ArrayIndex]."Period Code" <> '' then begin
                        PayrollPeriod.Get(ReqPeriodsArray[ArrayIndex]."Period Code");
                        ReqPeriodsArray[ArrayIndex].SetRange(ReqPeriodsArray[ArrayIndex]."ED Delimitation", ED."E/D Code");
                        if not (PayrollPeriod.Closed) then begin
                            ReqPeriodsArray[ArrayIndex].CalcFields(ReqPeriodsArray[ArrayIndex]."ED Amount");
                            EDAmountsArray[ArrayIndex] := ReqPeriodsArray[ArrayIndex]."ED Amount";
                        end else begin
                            ReqPeriodsArray[ArrayIndex].CalcFields(ReqPeriodsArray[ArrayIndex]."ED Closed Amount");
                            EDAmountsArray[ArrayIndex] := ReqPeriodsArray[ArrayIndex]."ED Closed Amount";
                        end;
                    end;
                    EDAmountsArrayTotal := EDAmountsArrayTotal + EDAmountsArray[ArrayIndex];
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('Processing E/D Code #1#########');

                // CurrReport.CreateTotals(EDAmountsArray[1],EDAmountsArray[2],EDAmountsArray[3],EDAmountsArray[4],EDAmountsArray[5],
                //                         EDAmountsArray[6],EDAmountsArrayTotal);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(EnterPeriod)
                {
                    Caption = 'Enter Period';
                    field("1"; ReqPeriodsArray[1]."Period Code")
                    {
                        ApplicationArea = Basic;
                        Caption = '1';
                        TableRelation = "Payroll-Period";
                    }
                    field("2"; ReqPeriodsArray[2]."Period Code")
                    {
                        ApplicationArea = Basic;
                        Caption = '2';
                        TableRelation = "Payroll-Period";
                    }
                    field("3"; ReqPeriodsArray[3]."Period Code")
                    {
                        ApplicationArea = Basic;
                        Caption = '3';
                        TableRelation = "Payroll-Period";
                    }
                    field("4"; ReqPeriodsArray[4]."Period Code")
                    {
                        ApplicationArea = Basic;
                        Caption = '4';
                        TableRelation = "Payroll-Period";
                    }
                    field("5"; ReqPeriodsArray[5]."Period Code")
                    {
                        ApplicationArea = Basic;
                        Caption = '5';
                        TableRelation = "Payroll-Period";
                    }
                    field("6"; ReqPeriodsArray[6]."Period Code")
                    {
                        ApplicationArea = Basic;
                        Caption = '6';
                        TableRelation = "Payroll-Period";
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Report_Title = 'Total ED Entries per Period';
    }

    trigger OnInitReport()
    begin
        ArrayTop := 6;
    end;

    var
        CompanyData: Record "Company Information";
        ReqPeriodsArray: array[6] of Record "Payroll-Period";
        PayrollPeriod: Record "Payroll-Period";
        EDAmountsArray: array[6] of Decimal;
        EDAmountsArrayTotal: Decimal;
        ArrayIndex: Integer;
        ArrayTop: Integer;
        Window: Dialog;
        StaffType: Option "Junior Staff","Senior Staff","Management Staff",Casual,All;
        Total_E_D_Entries_per_period_CaptionLbl: label 'Total E/D Entries per period.';
        Report_print_date_CaptionLbl: label 'Report print date:';
        PAYROLL_SCHEDULE___GRAND_TOTALCaptionLbl: label 'PAYROLL SCHEDULE - GRAND TOTAL';
        TotalsCaptionLbl: label 'Totals';
        TotalCaptionLbl: label 'Total';
}

