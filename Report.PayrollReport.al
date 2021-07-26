Report 52092158 "Payroll Report"
{
    // This report prints a salary schedule for employees. The user should enter
    // the Payroll period and if necessary also the specific Employee number(s) that
    // are required to appear in the report. The E/Ds that are to appear in the
    // schedule MUST be entered.(In this revised edition default EDs have been entered.
    // The schedule is a matrix of employees on the vertical axis and the required
    // E/Ds in the Horizontal axis.
    // The user can specify that the ED.Descriptions appear in the column headers
    // instead of the ED.Codes.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Report.rdlc';


    dataset
    {
        dataitem(Employee; "Closed Payroll-Payslip Header")
        {
            CalcFields = "ED Amount";
            DataItemTableView = sorting("Global Dimension 1 Code", "Global Dimension 2 Code");
            RequestFilterFields = "Payroll Period";
            column(ReportForNavId_7528; 7528)
            {
            }
            column(CompanyData_Name; CompanyData.Name)
            {
            }
            column(EmplHeadTxt; EmplHeadTxt)
            {
            }
            column(Today; Today)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(EDText_1_1_; EDText[1, 1])
            {
            }
            column(EDText_3_2_; EDText[3, 2])
            {
            }
            column(EDText_4_1_; EDText[4, 1])
            {
            }
            column(EDText_4_2_; EDText[4, 2])
            {
            }
            column(EDText_5_1_; EDText[5, 1])
            {
            }
            column(EDText_5_2_; EDText[5, 2])
            {
            }
            column(EDText_6_1_; EDText[6, 1])
            {
            }
            column(EDText_6_2_; EDText[6, 2])
            {
            }
            column(EDText_7_1_; EDText[7, 1])
            {
            }
            column(EDText_7_2_; EDText[7, 2])
            {
            }
            column(EDText_8_1_; EDText[8, 1])
            {
            }
            column(EDText_8_2_; EDText[8, 2])
            {
            }
            column(EDText_9_1_; EDText[9, 1])
            {
            }
            column(EDText_9_2_; EDText[9, 2])
            {
            }
            column(EDText_10_1_; EDText[10, 1])
            {
            }
            column(EDText_10_2_; EDText[10, 2])
            {
            }
            column(EDText_11_1_; EDText[11, 1])
            {
            }
            column(EDText_11_2_; EDText[11, 2])
            {
            }
            column(EDText_12_1_; EDText[12, 1])
            {
            }
            column(EDText_12_2_; EDText[12, 2])
            {
            }
            column(EDText_16_1_; EDText[16, 1])
            {
            }
            column(EDText_16_2_; EDText[16, 2])
            {
            }
            column(EDText_13_1_; EDText[13, 1])
            {
            }
            column(EDText_13_2_; EDText[13, 2])
            {
            }
            column(EDText_15_1_; EDText[15, 1])
            {
            }
            column(EDText_15_2_; EDText[15, 2])
            {
            }
            column(EDText_14_1_; EDText[14, 1])
            {
            }
            column(EDText_14_2_; EDText[14, 2])
            {
            }
            column(UPPERCASE_USERID_; UpperCase(UserId))
            {
            }
            column(EDText_17_1_; EDText[17, 1])
            {
            }
            column(EDText_17_2_; EDText[17, 2])
            {
            }
            column(ReportDescription; ReportDescription)
            {
            }
            column(Employee__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Employee_Employee__Employee_Name_; Employee."Employee Name")
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
            column(EDAmountsArray_5_; EDAmountsArray[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_6_; EDAmountsArray[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_7_; EDAmountsArray[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(Employee_Employee__Employee_Name__Control27; Employee."Employee Name")
            {
            }
            column(EDAmountsArray_1__Control2; EDAmountsArray[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_2__Control23; EDAmountsArray[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_3__Control24; EDAmountsArray[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_4__Control25; EDAmountsArray[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_5__Control26; EDAmountsArray[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_6__Control29; EDAmountsArray[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_7__Control48; EDAmountsArray[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_8_; EDAmountsArray[8])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_9_; EDAmountsArray[9])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_10_; EDAmountsArray[10])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_12_; EDAmountsArray[12])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_11_; EDAmountsArray[11])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_13_; EDAmountsArray[13])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_16_; EDAmountsArray[16])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_14_; EDAmountsArray[14])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_15_; EDAmountsArray[15])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_17_; EDAmountsArray[17])
            {
                DecimalPlaces = 0 : 0;
            }
            column(Global_Dimension_1_Code________Total_; "Global Dimension 1 Code" + ' ' + 'Total')
            {
            }
            column(EDAmountsArray_1__Control1000000066; EDAmountsArray[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_2__Control1000000067; EDAmountsArray[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_3__Control1000000068; EDAmountsArray[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_4__Control1000000069; EDAmountsArray[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_5__Control1000000070; EDAmountsArray[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_6__Control1000000071; EDAmountsArray[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_7__Control1000000095; EDAmountsArray[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(Global_Dimension_1_Code_________Total_; "Global Dimension 1 Code" + ' ' + 'Total')
            {
            }
            column(EDAmountsArray_1__Control131; EDAmountsArray[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_2__Control132; EDAmountsArray[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_3__Control133; EDAmountsArray[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_4__Control134; EDAmountsArray[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_5__Control135; EDAmountsArray[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_6__Control136; EDAmountsArray[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_7__Control137; EDAmountsArray[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_16__Control1000000017; EDAmountsArray[16])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_17__Control1000000019; EDAmountsArray[17])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_15__Control1000000020; EDAmountsArray[15])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_14__Control1000000021; EDAmountsArray[14])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_13__Control1000000022; EDAmountsArray[13])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_12__Control1000000023; EDAmountsArray[12])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_11__Control1000000024; EDAmountsArray[11])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_10__Control1000000025; EDAmountsArray[10])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_9__Control1000000026; EDAmountsArray[9])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_8__Control1000000027; EDAmountsArray[8])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_1__Control1000000056; EDAmountsArray[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_2__Control1000000057; EDAmountsArray[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_3__Control1000000058; EDAmountsArray[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_4__Control1000000059; EDAmountsArray[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_5__Control1000000060; EDAmountsArray[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_6__Control1000000061; EDAmountsArray[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_7__Control1000000105; EDAmountsArray[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_1__Control42; EDAmountsArray[1])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_2__Control43; EDAmountsArray[2])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_3__Control44; EDAmountsArray[3])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_4__Control45; EDAmountsArray[4])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_5__Control46; EDAmountsArray[5])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_6__Control47; EDAmountsArray[6])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_7__Control30; EDAmountsArray[7])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_17__Control1000000028; EDAmountsArray[17])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_16__Control1000000029; EDAmountsArray[16])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_15__Control1000000030; EDAmountsArray[15])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_14__Control1000000031; EDAmountsArray[14])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_13__Control1000000033; EDAmountsArray[13])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_12__Control1000000034; EDAmountsArray[12])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_11__Control1000000036; EDAmountsArray[11])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_10__Control1000000037; EDAmountsArray[10])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_9__Control1000000038; EDAmountsArray[9])
            {
                DecimalPlaces = 0 : 0;
            }
            column(EDAmountsArray_8__Control1000000039; EDAmountsArray[8])
            {
                DecimalPlaces = 0 : 0;
            }
            column(Report_print_date_Caption; Report_print_date_CaptionLbl)
            {
            }
            column(Report_page_Caption; Report_page_CaptionLbl)
            {
            }
            column(NameCaption; NameCaptionLbl)
            {
            }
            column(Printed_By_Caption; Printed_By_CaptionLbl)
            {
            }
            column(Grand_TotalCaption; Grand_TotalCaptionLbl)
            {
            }
            column(Grand_TotalCaption_Control53; Grand_TotalCaption_Control53Lbl)
            {
            }
            column(Employee_Payroll_Period; "Payroll Period")
            {
            }
            column(Employee_Employee_No; "Employee No.")
            {
            }
            column(Employee_Global_Dimension_2_Code; "Global Dimension 2 Code")
            {
            }

            trigger OnAfterGetRecord()
            begin
                GLSetup.Get;
                if PayrollType = Payrolltype::"Month End" then
                    for i := 1 to ArrayTop do begin
                        SetRange("ED Filter", RequestEDsArray[i]."E/D Code");
                        CalcFields("ED Amount");
                        EDAmountsArray[i] := "ED Amount";
                    end;
                if DimValue.Get(GLSetup."Global Dimension 1 Code", Employee."Global Dimension 1 Code") then
                    Division := DimValue.Name
                else
                    Division := '';

                if DimValue.Get(GLSetup."Global Dimension 2 Code", Employee."Global Dimension 2 Code") then
                    BusinessUnit := DimValue.Name
                else
                    BusinessUnit := 'SHARED';
            end;

            trigger OnPreDataItem()
            begin
                UserSetup.Get(UserId);
                if not (UserSetup."Payroll Administrator") then begin
                    FilterGroup(2);
                    if UserSetup."Personnel Level" <> '' then
                        SetFilter("Employee Category", UserSetup."Personnel Level")
                    else
                        SetRange("Employee Category");
                    FilterGroup(0);
                end else
                    SetRange("Employee Category");

                // CurrReport.CreateTotals(EDAmountsArray[1], EDAmountsArray[2], EDAmountsArray[3],
                //                  EDAmountsArray[4], EDAmountsArray[5], EDAmountsArray[6],
                //                  EDAmountsArray[7], EDAmountsArray[8], EDAmountsArray[9],
                //                  EDAmountsArray[10]);

                // CurrReport.CreateTotals(EDAmountsArray[11], EDAmountsArray[12], EDAmountsArray[13],
                //                  EDAmountsArray[14], EDAmountsArray[15], EDAmountsArray[16], EDAmountsArray[17]);

                EmplCount := Count;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Control1000000001)
                {
                    field(Column1; RequestEDsArray[1]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 1';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column2; RequestEDsArray[2]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 2';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column3; RequestEDsArray[3]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 3';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column4; RequestEDsArray[4]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 4';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column5; RequestEDsArray[5]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 5';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column6; RequestEDsArray[6]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 6';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column7; RequestEDsArray[7]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 7';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column8; RequestEDsArray[8]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 8';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column9; RequestEDsArray[9]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 9';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column10; RequestEDsArray[10]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 10';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column11; RequestEDsArray[11]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 11';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column12; RequestEDsArray[12]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 12';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column13; RequestEDsArray[13]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 13';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column14; RequestEDsArray[14]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 14';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column15; RequestEDsArray[15]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 15';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column16; RequestEDsArray[16]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 16';
                        TableRelation = "Payroll-E/D";
                    }
                    field(Column17; RequestEDsArray[17]."E/D Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Column 17';
                        TableRelation = "Payroll-E/D";
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
    }

    trigger OnPreReport()
    begin
        ArrayTop := 17;
        EmplCount := 0;

        /*Get Period Records within the delimitation*/
        Employee.Copyfilter("Period Filter", PeriodRec."Period Code");

        if PeriodRec.Count > 1 then
            PeriodTxt := StrSubstNo('(#1 periods)', PeriodRec.Count);

        CompanyData.Get;
        Employee.SetRange(Employee."ED Filter");
        if Employee.GetFilters <> '' then
            EmplHeadTxt := Employee.GetFilters
        else
            EmplHeadTxt := 'Schedule for All Employees.';

        /*RequestEDsArray[1]."E/D Code":='';
        RequestEDsArray[2]."E/D Code":='';
        RequestEDsArray[3]."E/D Code":='';
        RequestEDsArray[4]."E/D Code":='';
        RequestEDsArray[5]."E/D Code":='';
        RequestEDsArray[6]."E/D Code":='';
        RequestEDsArray[7]."E/D Code":='';
        RequestEDsArray[8]."E/D Code":='';
        RequestEDsArray[9]."E/D Code":='';
        RequestEDsArray[10]."E/D Code":='';
        RequestEDsArray[11]."E/D Code":='';
        RequestEDsArray[12]."E/D Code":='';
        RequestEDsArray[13]."E/D Code":='';
        RequestEDsArray[14]."E/D Code":='';
        RequestEDsArray[15]."E/D Code":='';
        RequestEDsArray[16]."E/D Code":='';*/

        /* Create column header text*/
        for ArrayIndex := 1 to ArrayTop do
            if (RequestEDsArray[ArrayIndex]."E/D Code") <> '' then begin
                RequestEDsArray[ArrayIndex].Get(RequestEDsArray[ArrayIndex]."E/D Code");
                EDString := CopyStr(RequestEDsArray[ArrayIndex].Description, 1, 20);
                for i := 1 to 10 do begin
                    CharTest := CopyStr(EDString, i, 1);
                    if CharTest = ' ' then begin
                        EDText[ArrayIndex, 1] := CopyStr(EDString, 1, i - 1);
                        EDText[ArrayIndex, 2] := CopyStr(EDString, i + 1, 10);
                        i := 10;
                    end;
                end;
                if EDText[ArrayIndex, 1] = '' then begin
                    EDText[ArrayIndex, 1] := CopyStr(EDString, 1, 10);
                    EDText[ArrayIndex, 2] := CopyStr(EDString, 11, 10);
                end
            end;

    end;

    var
        CompanyData: Record "Company Information";
        PeriodRec: Record "Payroll-Period";
        RequestEDsArray: array[18] of Record "Payroll-E/D";
        DimValue: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        BusinessUnit: Text[50];
        Division: Text[50];
        EDAmountsArray: array[17] of Decimal;
        EDText: array[17, 2] of Text[20];
        EDString: Text[20];
        ArrayIndex: Integer;
        ArrayTop: Integer;
        EmplCount: Integer;
        EmplHeadTxt: Text[150];
        PeriodTxt: Text[150];
        "BANK/CASH": Text[30];
        IsDescription: Boolean;
        i: Integer;
        CharTest: Text[1];
        PayrollType: Option "Month End";
        ViewType: Option Payroll,Reimbursable;
        ReportDescription: Text[100];
        Report_print_date_CaptionLbl: label 'Report print date:';
        Report_page_CaptionLbl: label 'Report page:';
        NameCaptionLbl: label 'Name';
        Printed_By_CaptionLbl: label 'Printed By:';
        Grand_TotalCaptionLbl: label 'Grand Total';
        Grand_TotalCaption_Control53Lbl: label 'Grand Total';
}

