Report 52092201 "Import Payroll Var.- Excel"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll Buffer";"Payroll Buffer")
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if (Amount = 0) and (Quantity = 0) then
                  CurrReport.Skip;
                PayrollPayslipVariable.Init;
                PayrollPayslipVariable.Validate("Employee No.","Employee No.");
                PayrollPayslipVariable."Payroll Period"  := PayrollPeriod;
                PayrollPayslipVariable.Validate("E/D Code",GlobalEDCode);
                if not(PayrollED."Yes/No Req.") then begin
                  if PayrollED.Units = '' then
                    PayrollPayslipVariable.Amount := Amount
                  else
                    PayrollPayslipVariable.Quantity := Quantity;
                end else
                  PayrollPayslipVariable.Validate(Flag,true);

                if not PayrollPayslipVariable.Insert(true) then
                  if not OverwriteExistingEntry then
                    Error(Text104,"Employee No.",GlobalEDCode)
                  else
                    PayrollPayslipVariable.Modify(true);

                TotalRecNo := TotalRecNo + 1;
            end;

            trigger OnPostDataItem()
            begin
                DeleteAll;
                Message(Text103,TotalRecNo);
            end;

            trigger OnPreDataItem()
            begin
                TotalRecNo := 0;
                PayrollED.Get(GlobalEDCode);
                PayrollED.TestField(Blocked,false);
                PayrollPeriodRec.Get(PayrollPeriod);
                PayrollPeriodRec.TestField(Closed,false);
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
                group(Options)
                {
                    Caption = 'Options';
                    field(GlobalEDCode;GlobalEDCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'ED Code';
                        Editable = false;
                        TableRelation = "Payroll-E/D";
                    }
                    field(PayrollPeriod;PayrollPeriod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Code';
                        Editable = false;
                        TableRelation = "Payroll-Period";
                    }
                    field(OverwriteExistingEntry;OverwriteExistingEntry)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Overwrite Existing Entry';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnQueryClosePage(CloseAction: action): Boolean
        var
            FileMgt: Codeunit "File Management";
        begin
            if CloseAction = Action::OK then begin
              if ServerFileName = '' then
                ServerFileName := FileMgt.UploadFile(Text006,ExcelFileExtensionTok);
              if ServerFileName = '' then
                exit(false);
            end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        ExcelBuf.DeleteAll;
        Commit;
        if SheetName = '' then
          SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
        if (GlobalEDCode = '') or (PayrollPeriod = '') then
          Error(Text030);
        ExcelBuf.OpenBook(ServerFileName,SheetName);
        ExcelBuf.ReadSheet;
        PayrollBuffer.DeleteAll;
        AnalyzeData;
    end;

    var
        PayrollPayslipVariable: Record "Payroll Payslip Variable";
        PayrollPeriodRec: Record "Payroll-Period";
        PayrollED: Record "Payroll-E/D";
        PayrollBuffer: Record "Payroll Buffer";
        ExcelBuf: Record "Excel Buffer";
        ServerFileName: Text;
        SheetName: Text[250];
        ReadingText: Text[250];
        Window: Dialog;
        DecimalValue: Decimal;
        TotalRecNo: Integer;
        RecNo: Integer;
        NoOfColumn: Integer;
        Uploaded: Boolean;
        MidMonthSalary: Boolean;
        OverwriteExistingEntry: Boolean;
        LastColumnLabel: Code[10];
        FieldTypeText: Code[50];
        GlobalEDCode: Code[20];
        PayrollPeriod: Code[20];
        OptionValue: Variant;
        DateValue: Date;
        Text001: label 'Data';
        Text002: label 'Data';
        Text003: label 'Company Name';
        Text006: label 'Import Excel File';
        Text007: label 'Analyzing Data...\\';
        Text010: label 'Employee No.';
        Text011: label 'Amount/Quantity';
        Text014: label 'Nothing to process.';
        Text018: label 'Salary Group';
        Text030: label 'Please fill the option form correctly.';
        Text050: label '%1 entries updated';
        Text054: label 'Action aborted.';
        Text056: label 'User ID';
        Text057: label 'Date';
        Text058: label 'Remark';
        Text059: label 'Updated';
        Text101: label 'There is no column in %1 as either %2 or %3.';
        Text102: label 'Duplication found on the file. The system will only use the first entry for processing. Are you sure you want to continue?';
        Text103: label '%1 lines were succeffully processed. Please note tht you must run recalculate lines to effect this change on the netpay. ';
        Text104: label 'Employee %1 has an existing line for %2.';
        ExcelFileExtensionTok: label '.xlsx', Locked=true;
        QtyColumnLabel: label 'Quantity';
        AmtColumnLabel: label 'Amount';
        Evaluator: Codeunit "Type Helper";

    local procedure AnalyzeData()
    var
        HeaderRowNo: Integer;
        CountDim: Integer;
        TestDateTime: DateTime;
        OldRowNo: Integer;
    begin
        Window.Open(
          Text007 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1,0);
        TotalRecNo := ExcelBuf.Count;
        RecNo := 0;
        ExcelBuf.SetFilter("Row No.",'>1');
        if not ExcelBuf.FindFirst then
          Error(Text014);
        repeat
          RecNo := RecNo + 1;
          Window.Update(1,ROUND(RecNo / TotalRecNo * 10000,1));
          case UpperCase(GetColumnFieldCaption(ExcelBuf.xlColID)) of
            UpperCase(Format(Text010)):begin
              PayrollBuffer.Init;
              ExcelBuf.Comment := Text010;
              PayrollBuffer."ED Code" := GlobalEDCode;
              PayrollBuffer."Payroll Period" := PayrollPeriod;
              PayrollBuffer."Employee No." := ExcelBuf."Cell Value as Text";
            end;
            UpperCase(QtyColumnLabel),UpperCase(AmtColumnLabel):begin
              ExcelBuf.Comment := Text011;
              if UpperCase(GetColumnFieldCaption(ExcelBuf.xlColID)) = UpperCase(QtyColumnLabel) then
                Evaluate(PayrollBuffer.Quantity,ExcelBuf."Cell Value as Text")
              else
                Evaluate(PayrollBuffer.Amount,ExcelBuf."Cell Value as Text");
              if not PayrollBuffer.Insert then
                if not Confirm(Text102,false) then
                  Error(Text054);
            end;
          end;
        until ExcelBuf.Next = 0;
        Window.Close;
    end;

    local procedure FormatData(TextToFormat: Text[250]): Text[250]
    var
        FormatInteger: Integer;
        FormatDecimal: Decimal;
        FormatDate: Date;
    begin
        case true of
          Evaluate(FormatInteger,TextToFormat):
            exit(Format(FormatInteger));
          Evaluate(FormatDecimal,TextToFormat):
            exit(Format(FormatDecimal));
          Evaluate(FormatDate,TextToFormat):
            exit(Format(FormatDate));
          else
            exit(TextToFormat);
        end;
    end;


    procedure GetColumnFieldCaption(CloumnID: Text[1]): Text[50]
    var
        ExcelBuf2: Record "Excel Buffer";
    begin
        ExcelBuf2.Reset;
        ExcelBuf2.SetRange("Row No.",1);
        ExcelBuf2.SetRange(xlColID,CloumnID);
        ExcelBuf2.FindFirst;
        exit(ExcelBuf2."Cell Value as Text");
    end;


    procedure SetParameters(Period: Code[20];EDCode: Code[20])
    begin
        GlobalEDCode := EDCode;
        PayrollPeriod := Period;
    end;
}

