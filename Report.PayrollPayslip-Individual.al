Report 52092189 "Payroll Payslip - Individual"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Payslip - Individual.rdlc';

    dataset
    {
        dataitem(Payslip; "Payroll-Payslip Header")
        {
            DataItemLinkReference = Payslip;
            DataItemTableView = sorting("Payroll Period", "Employee No.");
            RequestFilterFields = "Payroll Period", "Global Dimension 1 Code", "Global Dimension 2 Code", "Employee No.";
            RequestFilterHeading = 'Parameters for payslips';
            column(ReportForNavId_1435; 1435)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.Get("Employee No.");
                /*IF SkipRecord THEN
                  CurrReport.SKIP; */
                if "WithHold Salary" then
                    CurrReport.Skip;

                ColumnHasHistory := false;
                ColumnHasHistory := false;
                NCount := NCount + 1;
                PaylipHeaderTemp1.Init;
                PaylipHeaderTemp1.TransferFields(Payslip);
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
                UserSetup.Get(UserId);
                UserSetup.TestField(UserSetup."Employee No.");
                FilterGroup(2);
                SetFilter("Employee No.", UserSetup."Employee No.");
                FilterGroup(0);
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
                    //PayrollBuffer[1].SETCURRENTKEY(Sequence);
                    PayrollBuffer.SetCurrentkey("Payslip Column");
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
                    Clear(PayslipLine);
                    PayslipLine.SetCurrentkey("Employee No.", "Payroll Period");
                    PayslipLine.SetRange("Payroll Period", PaylipHeaderTemp1."Payroll Period");
                    PayslipLine.SetRange("Employee No.", PaylipHeaderTemp1."Employee No.");
                    if PayslipLine.FindFirst then
                        repeat
                            CreateTempPayslip;
                        until PayslipLine.Next = 0;

                    PayAdviceTitle2 := '';
                    PayAdviceTYPE2 := '';
                end;
            end;

            trigger OnPreDataItem()
            begin
                HistoricalPayrollBuffer.DeleteAll;
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

    trigger OnInitReport()
    begin
        //"Show Zero Values" := TRUE;
    end;

    trigger OnPostReport()
    begin
        PayrollBuffer.DeleteAll;
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
    end;

    var
        Text000: label 'ID %1';
        Text001: label 'PAY ADVICE FOR';
        Text002: label 'REIMBURSEMENT PAY ADVICE FOR ';
        Text003: label 'Unexpected error! Column setup wrong';
        Text004: label '%1 employee exempted for payslip via mail option.';
        Text005: label '%1 Y. T. D.';
        Text006: label '%1  BALANCE';
        Text007: label 'Payslip entries may not be correct. You must run Recalculate function before generating this report.';
        Text008: label 'EARNINGS';
        Text009: label 'DEDUCTIONS';
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
        NoOfEmailPayslipEmployee: Integer;
        PayrollType: Option SALARY,REIMBURSABLE,ALL;


    procedure CreateTempPayslip()
    begin
        Clear(PayrollED);
        HistoricalPayrollBuffer."Historical Amount" := 0;
        //HistoricalPayrollBuffer."Loan ID" := '';

        if PayrollED.Get(PayslipLine."E/D Code") then;
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
        //HistoricalPayrollBuffer."Loan ID" := '';
        if PayrollED.Historical then begin
            HistoricalPayrollBuffer.Init;
            HistoricalPayrollBuffer.TransferFields(PayrollBuffer);
            ColumnHasHistory := ColumnHasHistory or true;
            if PayrollBuffer."Loan ID" <> '' then begin
                HistoricalPayrollBuffer."Payslip Text" := StrSubstNo(Text006, PayrollBuffer."Payslip Text");
                /*IF PayrollLoan.GET(PayrollBuffer."Loan ID") THEN BEGIN
                  PayrollLoan.SETRANGE("Date Filter",0D,PeriodRec."End Date");
                  PayrollLoan.CALCFIELDS("Loan Balance");
                  HistoricalPayrollBuffer."Historical Amount" := PayrollLoan."Loan Balance";
                END;*/
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
                HistoricalPayslipLine.Reset;
                HistoricalPayslipLine.SetRange("Payroll Period", PayrollFirstPeriod, PayrollLastPeriod);
                HistoricalPayslipLine.SetRange("Employee No.", PayrollBuffer."Employee No.");
                HistoricalPayslipLine.SetRange("E/D Code", PayrollED."E/D Code");
                HistoricalPayslipLine.CalcSums(Amount);
                HistoricalPayrollBuffer."Historical Amount" := HistoricalPayslipLine.Amount;
            end;
            if HistoricalPayrollBuffer."Historical Amount" <> 0 then
                if not HistoricalPayrollBuffer.Insert then begin
                    HistoricalPayrollBuffer."Historical Amount" := HistoricalPayslipLine.Amount;
                    HistoricalPayrollBuffer.Modify;
                end;
        end;
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

        PayslipLine.SetRange("Payroll Period", Payslip."Payroll Period");
        PayslipLine.SetRange("Employee No.", Payslip."Employee No.");
        exit(not PayslipLine.FindFirst);
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

