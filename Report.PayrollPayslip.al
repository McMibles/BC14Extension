Report 52092184 "Payroll Payslip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Payslip.rdlc';

    dataset
    {
        dataitem("Payroll-Payslip Header"; "Payroll-Payslip Header")
        {
            DataItemLinkReference = "Payroll-Payslip Header";
            DataItemTableView = sorting("Payroll Period", "Employee No.");
            RequestFilterFields = "Payroll Period", "Global Dimension 1 Code", "Global Dimension 2 Code", "Employee No.";
            RequestFilterHeading = 'Parameters for payslips';
            column(ReportForNavId_1435; 1435)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.Get("Employee No.");
                if SkipRecord then
                    CurrReport.Skip;
                if "WithHold Salary" then
                    CurrReport.Skip;

                ColumnHasHistory := false;
                NCount := NCount + 1;
                PaylipHeaderTemp1.Init;
                PaylipHeaderTemp1.TransferFields("Payroll-Payslip Header");
                PaylipHeaderTemp1.Insert;

                if CalledFromEmail then
                    "No. of Month End E-mail Sent" := "No. of Month End E-mail Sent" + 1
                else
                    "No. Printed" := "No. Printed" + 1;

                if not CurrReport.Preview or CalledFromEmail then
                    Modify;
            end;

            trigger OnPreDataItem()
            begin
                if not CalledFromEmail then begin
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
                end;
                ProllPeriod.Get(GetFilter("Payroll-Payslip Header"."Payroll Period"));
                PeriodIsClosed := ProllPeriod.Closed;
                if PeriodIsClosed then
                    CurrReport.Break;
            end;
        }
        dataitem("Closed Payroll-Payslip Header"; "Closed Payroll-Payslip Header")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.Get("Employee No.");
                if SkipRecord then
                    CurrReport.Skip;
                if "WithHold Salary" then
                    CurrReport.Skip;

                ColumnHasHistory := false;
                NCount := NCount + 1;
                PaylipHeaderTemp1.Init;
                PaylipHeaderTemp1.TransferFields("Closed Payroll-Payslip Header");
                PaylipHeaderTemp1.Insert;

                if CalledFromEmail then
                    "No. of Month End E-mail Sent" := "No. of Month End E-mail Sent" + 1
                else
                    "No. Printed" := "No. Printed" + 1;

                if not CurrReport.Preview or CalledFromEmail then
                    Modify;
            end;

            trigger OnPreDataItem()
            begin
                if not (PeriodIsClosed) then
                    CurrReport.Break;
                "Closed Payroll-Payslip Header".SetView("Payroll-Payslip Header".GetView);
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
            column(ReportForNavId_5444; 5444)
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(PayAdviceTitle_; UpperCase(PayAdviceTYPE + '  ' + PayAdviceTitle))
            {
            }
            column(Employee_Name; UpperCase(PaylipHeaderTemp1."Employee Name"))
            {
            }
            column(Employee1No; Employee1No)
            {
            }
            column(GlobalDim1_Name; UpperCase(GlobalDimValue1[1].Name))
            {
            }
            column(GlobalDim2_Name; UpperCase(GlobalDimValue2[1].Name))
            {
            }
            column(GlobalDim1_Caption; GlobalDimCaption1[1])
            {
            }
            column(GlobalDim2_Caption; GlobalDimCaption2[1])
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(PayrollType; PayrollType)
            {
            }
            column(Integer_Number; Number)
            {
            }
            dataitem("Print Payslip Line"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                column(ReportForNavId_5037; 5037)
                {
                }
                column(PayrollBuffer_Column; PayrollBuffer."Payslip Column")
                {
                }
                column(PayrollBuffer_UseasGroupTotal; PayrollBuffer."Use as Group Total")
                {
                }
                column(PayrollBuffer_Amount; PayrollBuffer.Amount)
                {
                }
                column(PayrollBuffer_PayslipText; PayrollBuffer."Payslip Text")
                {
                }
                column(PayrollBuffer_Quantity; PayrollBuffer.Quantity)
                {
                }
                column(AmountInWord; AmountInWord[1] + ' ' + AmountInWord[2])
                {
                }
                column(Print_Payslip_Line_Number; Number)
                {
                }
                column(PayrollBuffer_Bold; PayrollBuffer.Bold)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        if not PayrollBuffer.Find('-') then begin
                            PayrollBuffer.DeleteAll;
                            CurrReport.Break;
                        end;
                    end else
                        if PayrollBuffer.Next = 0 then begin
                            Clear(PayrollBuffer);
                            PayrollBuffer.SetRange("Employee No.", PaylipHeaderTemp1."Employee No.");
                            PayrollBuffer.SetRange("Payroll Period", PaylipHeaderTemp1."Payroll Period");
                            PayrollBuffer.DeleteAll;
                            CurrReport.Break;
                        end;
                end;

                trigger OnPreDataItem()
                begin
                    PayrollBuffer.SetCurrentkey("ED Code");
                    PayrollBuffer.SetRange("Employee No.", PaylipHeaderTemp1."Employee No.");
                    PayrollBuffer.SetRange("Payroll Period", PaylipHeaderTemp1."Payroll Period");
                end;
            }
            dataitem("Print Historical Line"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                column(ReportForNavId_7334; 7334)
                {
                }
                column(HistoricalPayrollBuffer_Payslip_Text; HistoricalPayrollBuffer."Payslip Text")
                {
                }
                column(HistoricalPayrollBuffer_Historical_Amount; HistoricalPayrollBuffer."Historical Amount")
                {
                }
                column(Print_Historical_Line_Number; Number)
                {
                }
                column(HistoryExist; HistoryExist)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then begin
                        if not HistoricalPayrollBuffer.Find('-') then begin
                            HistoricalPayrollBuffer.DeleteAll;
                            CurrReport.Break;
                        end
                    end else begin
                        if HistoricalPayrollBuffer.Next = 0 then begin
                            Clear(HistoricalPayrollBuffer);
                            HistoricalPayrollBuffer.SetRange("Employee No.", PaylipHeaderTemp1."Employee No.");
                            HistoricalPayrollBuffer.SetRange("Payroll Period", PaylipHeaderTemp1."Payroll Period");
                            HistoricalPayrollBuffer.DeleteAll;
                            CurrReport.Break;
                        end;
                    end;
                    HistoryExist := true;
                end;

                trigger OnPreDataItem()
                begin
                    if ((ColumnHasHistory = false) and (ColumnHasHistory)) or (not ShowHistorical) then
                        CurrReport.Break;

                    if (not ColumnHasHistory) then begin
                        HistoricalPayrollBuffer.SetRange("Employee No.", PaylipHeaderTemp1."Employee No.");
                        HistoricalPayrollBuffer.SetRange("Payroll Period", PaylipHeaderTemp1."Payroll Period");
                        HistoricalPayrollBuffer.DeleteAll;
                    end;


                    HistoricalPayrollBuffer.SetRange("Employee No.", PaylipHeaderTemp1."Employee No.");
                    HistoricalPayrollBuffer.SetRange("Payroll Period", PaylipHeaderTemp1."Payroll Period");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //CurrReport.PageNo := 1;
                if Number = 1 then begin
                    if not PaylipHeaderTemp1.Find('-') then
                        CurrReport.Break;
                end else
                    if PaylipHeaderTemp1.Next = 0 then
                        CurrReport.Break;
                HistoryExist := false;
                PayrollBuffer.DeleteAll;

                if PaylipHeaderTemp1."Employee No." <> '' then begin
                    if PaylipHeaderTemp1."Global Dimension 1 Code" <> '' then begin
                        GLSetup.TestField("Global Dimension 1 Code");
                        GlobalDimValue1[1].Get(GLSetup."Global Dimension 1 Code", PaylipHeaderTemp1."Global Dimension 1 Code");
                        GlobalDimCaption1[1] := GLSetup."Global Dimension 1 Code";
                    end;
                    if PaylipHeaderTemp1."Global Dimension 2 Code" <> '' then begin
                        GLSetup.TestField("Global Dimension 1 Code");
                        GlobalDimValue2[1].Get(GLSetup."Global Dimension 2 Code", PaylipHeaderTemp1."Global Dimension 2 Code");
                        GlobalDimCaption2[1] := GLSetup."Global Dimension 2 Code";
                    end;
                    PeriodRec.Get(PaylipHeaderTemp1."Payroll Period");
                    if PeriodRec.Name <> '' then
                        PayAdviceTitle := DelChr(PeriodRec.Name, '<>')
                    else
                        PayAdviceTitle := DelChr(PaylipHeaderTemp1."Payroll Period", '<>');

                    Employee1No := StrSubstNo(Text000, UpperCase(PaylipHeaderTemp1."Employee No."));
                    PayAdviceTYPE := Text001;
                    if not (PeriodIsClosed) then begin
                        Clear(PayslipLine);
                        PayslipLine.SetCurrentkey("Employee No.", "Payroll Period");
                        PayslipLine.SetRange("Payroll Period", PaylipHeaderTemp1."Payroll Period");
                        PayslipLine.SetRange("Employee No.", PaylipHeaderTemp1."Employee No.");
                        if PayslipLine.FindFirst then
                            repeat
                                CreateTempPayslip;
                            until PayslipLine.Next = 0;
                    end else begin
                        Clear(ClosedPayslipLine);
                        ClosedPayslipLine.SetCurrentkey("Employee No.", "Payroll Period");
                        ClosedPayslipLine.SetRange("Payroll Period", PaylipHeaderTemp1."Payroll Period");
                        ClosedPayslipLine.SetRange("Employee No.", PaylipHeaderTemp1."Employee No.");
                        if ClosedPayslipLine.FindFirst then
                            repeat
                                CreateTempClosedPayslip;
                            until ClosedPayslipLine.Next = 0;
                    end;
                    PayAdviceTitle2 := '';
                    PayAdviceTYPE2 := '';
                end;
            end;

            trigger OnPreDataItem()
            begin
                HistoricalPayrollBuffer.DeleteAll;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ExemptPayslipViaMail; ExemptPayslipViaMail)
                {
                    ApplicationArea = Basic;
                    Caption = 'Exempt Payslip Via Mail';
                }
                field(ShowHistorical; ShowHistorical)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Historical';
                }
                field(PayrollType; PayrollType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Payroll Type';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ExemptPayslipViaMail := true;
            ShowHistorical := true;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        PayrollBuffer.DeleteAll;
        if NoOfEmailPayslipEmployee <> 0 then
            Message(Text004, NoOfEmailPayslipEmployee);
    end;

    trigger OnPreReport()
    begin
        GLSetup.Get;
        PaySetup.Get;
        PaySetup.TestField("Net Pay E/D Code");
        CompanyInfo.Get;
        if PaySetup."Show Company Logo" then
            CompanyInfo.CalcFields(Picture);
        PayrollBuffer.DeleteAll;
        PayrollBuffer.DeleteAll;
        PaylipHeaderTemp1.DeleteAll;
        NoOfEmailPayslipEmployee := 0;
        HistoricalPayrollBuffer.DeleteAll;
        HistoricalPayrollBuffer.DeleteAll;
        PeriodIsClosed := false;
    end;

    var
        CompanyInfo: Record "Company Information";
        UserRec: Record "User Setup";
        PeriodRec: Record "Payroll-Period";
        ProllPeriod: Record "Payroll-Period";
        GlobalDimValue1: array[2] of Record "Dimension Value";
        GlobalDimValue2: array[2] of Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
        PaySetup: Record "Payroll-Setup";
        PaylipHeaderTemp1: Record "Payroll-Payslip Header" temporary;
        PayrollBuffer: Record "Payroll Buffer" temporary;
        PayrollBuffer2: Record "Payroll Buffer";
        HistoricalPayrollBuffer: Record "Payroll Buffer" temporary;
        PayslipLine: Record "Payroll-Payslip Line";
        ClosedPayslipLine: Record "Closed Payroll-Payslip Line";
        NetPayslipLine: Record "Payroll-Payslip Line";
        NetPayslipLine2: Record "Payroll-Payslip Line";
        PayrollED: Record "Payroll-E/D";
        Employee: Record "Payroll-Employee";
        PayrollLoan: Record "Payroll-Loan";
        HistoricalPayslipLine: Record "Payroll-Payslip Line";
        HistoricalClsdPayslipLine: Record "Closed Payroll-Payslip Line";
        UserSetup: Record "User Setup";
        ConvertAmtToText: Codeunit "Format No. to Text";
        TotalText: Text[50];
        PayAdviceTitle: Text[80];
        PayAdviceTitle2: Text[80];
        PayAdviceTYPE: Text[50];
        PayAdviceTYPE2: Text[50];
        Employee1No: Text[100];
        Employee2No: Text[100];
        GlobalDimCaption1: array[2] of Text[30];
        GlobalDimCaption2: array[2] of Text[30];
        AmountInWord: array[2] of Text[80];
        EmployeeNoFilter: Text[30];
        PayrollFirstPeriod: Code[20];
        PayrollLastPeriod: Code[20];
        AmountInFigure: Decimal;
        CalledFromEmail: Boolean;
        ExemptPayslipViaMail: Boolean;
        ColumnHasHistory: Boolean;
        ShowHistorical: Boolean;
        PeriodIsClosed: Boolean;
        HistoryExist: Boolean;
        NCount: Integer;
        Text000: label 'ID %1';
        Text001: label 'PAY ADVICE FOR';
        Text002: label 'REIMBURSEMENT PAY ADVICE FOR ';
        Text003: label 'Unexpected error! Column setup wrong';
        Text004: label '%1 employee exempted for payslip via mail option.';
        NoOfEmailPayslipEmployee: Integer;
        Text005: label '%1 Y. T. D.';
        Text006: label '%1  BALANCE';
        Text007: label 'Payslip entries may not be correct. You must run Recalculate function before generating this report.';
        Text008: label 'EARNINGS';
        Text009: label 'DEDUCTIONS';
        PayrollType: Option SALARY,REIMBURSABLE,ALL;


    procedure CreateTempClosedPayslip()
    begin
        Clear(PayrollED);
        HistoricalPayrollBuffer."Historical Amount" := 0;

        PayrollED.Get(ClosedPayslipLine."E/D Code");
        PayrollBuffer.Init;
        case PayrollType of
            Payrolltype::ALL:
                begin
                    case PayrollED."Payslip appearance" of
                        PayrollED."payslip appearance"::"Does not appear":
                            exit;
                        PayrollED."payslip appearance"::"Non-zero & Text":
                            begin
                                if ClosedPayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := ClosedPayslipLine."Payslip Text";
                            end;
                        PayrollED."payslip appearance"::"Non-zero & Code":
                            begin
                                if ClosedPayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := ClosedPayslipLine."E/D Code";
                            end;
                        PayrollED."payslip appearance"::"Always & Text":
                            PayrollBuffer."Payslip Text" := ClosedPayslipLine."Payslip Text";
                        PayrollED."payslip appearance"::"Always & Code":
                            PayrollBuffer."Payslip Text" := ClosedPayslipLine."E/D Code";
                    end;
                end;
            Payrolltype::SALARY:
                begin
                    if PayrollED."Appear On Reimburseable Report" then exit;
                    case PayrollED."Payslip appearance" of
                        PayrollED."payslip appearance"::"Does not appear":
                            exit;
                        PayrollED."payslip appearance"::"Non-zero & Text":
                            begin
                                if ClosedPayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := ClosedPayslipLine."Payslip Text";
                            end;
                        PayrollED."payslip appearance"::"Non-zero & Code":
                            begin
                                if ClosedPayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := ClosedPayslipLine."E/D Code";
                            end;
                        PayrollED."payslip appearance"::"Always & Text":
                            PayrollBuffer."Payslip Text" := ClosedPayslipLine."Payslip Text";
                        PayrollED."payslip appearance"::"Always & Code":
                            PayrollBuffer."Payslip Text" := ClosedPayslipLine."E/D Code";
                    end;
                end;
            Payrolltype::REIMBURSABLE:
                begin
                    if not PayrollED."Appear On Reimburseable Report" then exit;
                    case PayrollED."Payslip appearance" of
                        PayrollED."payslip appearance"::"Does not appear":
                            exit;
                        PayrollED."payslip appearance"::"Non-zero & Text":
                            begin
                                if ClosedPayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := PayrollED."Reimburseable Report Text";
                            end;
                        PayrollED."payslip appearance"::"Non-zero & Code":
                            begin
                                if ClosedPayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := ClosedPayslipLine."E/D Code";
                            end;
                        PayrollED."payslip appearance"::"Always & Text":
                            PayrollBuffer."Payslip Text" := ClosedPayslipLine."Payslip Text";
                        PayrollED."payslip appearance"::"Always & Code":
                            PayrollBuffer."Payslip Text" := ClosedPayslipLine."E/D Code";
                    end;
                end;


        end;
        PayrollBuffer."Employee No." := ClosedPayslipLine."Employee No.";
        PayrollBuffer."ED Code" := ClosedPayslipLine."E/D Code";
        PayrollBuffer.Amount := ClosedPayslipLine.Amount;
        PayrollBuffer.Quantity := ClosedPayslipLine.Quantity;
        PayrollBuffer."Payslip Column" := PayrollED."Payslip Column";
        PayrollBuffer."Payroll Period" := PaylipHeaderTemp1."Payroll Period";
        PayrollBuffer."Underline Amount" := PayrollED."Underline Amount";
        PayrollBuffer."Use as Group Total" := PayrollED."Use as Group Total";
        PayrollBuffer.Bold := PayrollED.Bold;
        PayrollBuffer.Italic := PayrollED.Italic;
        PayrollBuffer."Loan ID" := ClosedPayslipLine."Loan ID";
        HistoricalPayrollBuffer."Historical Amount" := 0;
        HistoricalPayrollBuffer."Payslip Column" := PayrollED."Payslip Column";
        if PayrollED.Historical then begin
            HistoricalPayrollBuffer.Init;
            HistoricalPayrollBuffer.TransferFields(PayrollBuffer);
            ColumnHasHistory := ColumnHasHistory or true;
            if PayrollBuffer."Loan ID" <> '' then begin
                HistoricalPayrollBuffer."Payslip Text" := StrSubstNo(Text006, PayrollBuffer."Payslip Text");
                if PayrollLoan.Get(PayrollBuffer."Loan ID") then begin
                    PayrollLoan.SetRange("Date Filter", 0D, PeriodRec."End Date");
                    PayrollLoan.CalcFields("Remaining Amount");
                    HistoricalPayrollBuffer."Historical Amount" := PayrollLoan."Remaining Amount";
                end;
            end else begin
                HistoricalPayrollBuffer."Payslip Text" := StrSubstNo(Text005, PayrollBuffer."Payslip Text");
                //Find year start period
                Clear(ProllPeriod);
                ProllPeriod.SetRange("Start Date", Dmy2date(1, 1, Date2dmy(PeriodRec."Start Date", 3)), PeriodRec."Start Date");
                if ProllPeriod.FindFirst then
                    PayrollFirstPeriod := ProllPeriod."Period Code"
                else
                    PayrollFirstPeriod := PeriodRec."Period Code";

                //Find year End period
                Clear(ProllPeriod);
                ProllPeriod.SetRange("End Date", Dmy2date(1, 1, Date2dmy(PeriodRec."End Date", 3)),
                  Dmy2date(31, 12, Date2dmy(PeriodRec."End Date", 3)));
                if ProllPeriod.FindLast then
                    PayrollLastPeriod := ProllPeriod."Period Code"
                else
                    PayrollLastPeriod := PeriodRec."Period Code";
                Employee.Get(PayrollBuffer."Employee No.");
                Employee.SetRange("Period Filter", PayrollFirstPeriod, PayrollLastPeriod);
                Employee.SetRange("ED Filter", PayrollBuffer."ED Code");
                Employee.CalcFields("ED Closed Amount");
                HistoricalPayrollBuffer."Historical Amount" := Employee."ED Closed Amount";
            end;
            if HistoricalPayrollBuffer."Historical Amount" <> 0 then
                if not HistoricalPayrollBuffer.Insert then
                    HistoricalPayrollBuffer.Modify;
        end;
        PayrollBuffer."ED Code" := PayrollBuffer."ED Code";
        PayrollBuffer.Insert;
    end;


    procedure CreateTempPayslip()
    begin
        Clear(PayrollED);
        HistoricalPayrollBuffer."Historical Amount" := 0;

        PayrollED.Get(PayslipLine."E/D Code");
        PayrollBuffer.Init;
        case PayrollType of
            Payrolltype::ALL:
                begin
                    case PayrollED."Payslip appearance" of
                        PayrollED."payslip appearance"::"Does not appear":
                            exit;
                        PayrollED."payslip appearance"::"Non-zero & Text":
                            begin
                                if PayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := PayslipLine."Payslip Text";
                            end;
                        PayrollED."payslip appearance"::"Non-zero & Code":
                            begin
                                if PayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := PayslipLine."E/D Code";
                            end;
                        PayrollED."payslip appearance"::"Always & Text":
                            PayrollBuffer."Payslip Text" := PayslipLine."Payslip Text";
                        PayrollED."payslip appearance"::"Always & Code":
                            PayrollBuffer."Payslip Text" := PayslipLine."E/D Code";
                    end;
                end;
            Payrolltype::SALARY:
                begin
                    if PayrollED."Appear On Reimburseable Report" then exit;
                    case PayrollED."Payslip appearance" of
                        PayrollED."payslip appearance"::"Does not appear":
                            exit;
                        PayrollED."payslip appearance"::"Non-zero & Text":
                            begin
                                if PayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := PayslipLine."Payslip Text";
                            end;
                        PayrollED."payslip appearance"::"Non-zero & Code":
                            begin
                                if PayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := PayslipLine."E/D Code";
                            end;
                        PayrollED."payslip appearance"::"Always & Text":
                            PayrollBuffer."Payslip Text" := PayslipLine."Payslip Text";
                        PayrollED."payslip appearance"::"Always & Code":
                            PayrollBuffer."Payslip Text" := PayslipLine."E/D Code";
                    end;
                end;
            Payrolltype::REIMBURSABLE:
                begin
                    if not PayrollED."Appear On Reimburseable Report" then exit;
                    case PayrollED."Payslip appearance" of
                        PayrollED."payslip appearance"::"Does not appear":
                            exit;
                        PayrollED."payslip appearance"::"Non-zero & Text":
                            begin
                                if PayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := PayrollED."Reimburseable Report Text";
                            end;
                        PayrollED."payslip appearance"::"Non-zero & Code":
                            begin
                                if PayslipLine.Amount = 0 then
                                    exit;
                                PayrollBuffer."Payslip Text" := PayslipLine."E/D Code";
                            end;
                        PayrollED."payslip appearance"::"Always & Text":
                            PayrollBuffer."Payslip Text" := PayslipLine."Payslip Text";
                        PayrollED."payslip appearance"::"Always & Code":
                            PayrollBuffer."Payslip Text" := PayslipLine."E/D Code";
                    end;
                end;


        end;
        PayrollBuffer."Employee No." := PayslipLine."Employee No.";
        PayrollBuffer."ED Code" := PayslipLine."E/D Code";
        PayrollBuffer.Amount := PayslipLine.Amount;
        PayrollBuffer.Quantity := PayslipLine.Quantity;
        PayrollBuffer."Payslip Column" := PayrollED."Payslip Column";
        PayrollBuffer."Payroll Period" := PaylipHeaderTemp1."Payroll Period";
        PayrollBuffer."Underline Amount" := PayrollED."Underline Amount";
        PayrollBuffer."Use as Group Total" := PayrollED."Use as Group Total";
        PayrollBuffer.Bold := PayrollED.Bold;
        PayrollBuffer.Italic := PayrollED.Italic;
        PayrollBuffer."Loan ID" := PayslipLine."Loan ID";
        HistoricalPayrollBuffer."Historical Amount" := 0;
        HistoricalPayrollBuffer."Payslip Column" := PayrollED."Payslip Column";
        if PayrollED.Historical then begin
            HistoricalPayrollBuffer.Init;
            HistoricalPayrollBuffer.TransferFields(PayrollBuffer);
            ColumnHasHistory := ColumnHasHistory or true;
            if PayrollBuffer."Loan ID" <> '' then begin
                HistoricalPayrollBuffer."Payslip Text" := StrSubstNo(Text006, PayrollBuffer."Payslip Text");
                if PayrollLoan.Get(PayrollBuffer."Loan ID") then begin
                    PayrollLoan.SetRange("Date Filter", 0D, PeriodRec."End Date");
                    PayrollLoan.CalcFields("Remaining Amount");
                    HistoricalPayrollBuffer."Historical Amount" := PayrollLoan."Remaining Amount";
                end;
            end else begin
                HistoricalPayrollBuffer."Payslip Text" := StrSubstNo(Text005, PayrollBuffer."Payslip Text");
                //Find year start period
                Clear(ProllPeriod);
                ProllPeriod.SetRange("Start Date", Dmy2date(1, 1, Date2dmy(PeriodRec."Start Date", 3)), PeriodRec."Start Date");
                if ProllPeriod.FindFirst then
                    PayrollFirstPeriod := ProllPeriod."Period Code"
                else
                    PayrollFirstPeriod := PeriodRec."Period Code";

                //Find year End period
                Clear(ProllPeriod);
                ProllPeriod.SetRange("End Date", Dmy2date(1, 1, Date2dmy(PeriodRec."End Date", 3)),
                  Dmy2date(31, 12, Date2dmy(PeriodRec."End Date", 3)));
                if ProllPeriod.FindLast then
                    PayrollLastPeriod := ProllPeriod."Period Code"
                else
                    PayrollLastPeriod := PeriodRec."Period Code";
                Employee.Get(PayrollBuffer."Employee No.");
                Employee.SetRange("Period Filter", PayrollFirstPeriod, PayrollLastPeriod);
                Employee.SetRange("ED Filter", PayrollBuffer."ED Code");
                Employee.CalcFields(Employee."ED Amount", "ED Closed Amount");
                HistoricalPayrollBuffer."Historical Amount" := Employee."ED Closed Amount" + Employee."ED Amount";

            end;
            if HistoricalPayrollBuffer."Historical Amount" <> 0 then
                if not HistoricalPayrollBuffer.Insert then
                    HistoricalPayrollBuffer.Modify;
        end;
        PayrollBuffer."ED Code" := PayrollBuffer."ED Code";
        PayrollBuffer.Insert;
    end;


    procedure SetEmployeeFilter(EmpNo: Code[20])
    begin
        EmployeeNoFilter := EmpNo;
    end;


    procedure SkipRecord(): Boolean
    var
        PayslipLine: Record "Payroll-Payslip Line";
    begin
        if ExemptPayslipViaMail and (not CalledFromEmail) and (Employee."Payslip Mode" = Employee."payslip mode"::"E-mail") then begin
            NoOfEmailPayslipEmployee := NoOfEmailPayslipEmployee + 1;
            exit(true);
        end;
        if not (PeriodIsClosed) then begin
            PayslipLine.SetRange("Payroll Period", "Payroll-Payslip Header"."Payroll Period");
            PayslipLine.SetRange("Employee No.", "Payroll-Payslip Header"."Employee No.");
            exit(not PayslipLine.FindFirst);
        end else begin
            ClosedPayslipLine.SetRange("Payroll Period", "Closed Payroll-Payslip Header"."Payroll Period");
            ClosedPayslipLine.SetRange("Employee No.", "Closed Payroll-Payslip Header"."Employee No.");
            exit(not ClosedPayslipLine.FindFirst);
        end;
    end;


    procedure SetASCalledFromEmail(PayType: Integer)
    begin
        CalledFromEmail := true;
        PayrollType := PayType;
    end;


    procedure SetShowHistorical(Historical: Boolean)
    begin
        ShowHistorical := Historical;
    end;
}

