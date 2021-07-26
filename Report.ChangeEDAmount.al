Report 52092174 "Change E/D Amount"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Payslip;"Payroll-Payslip Line")
        {
            RequestFilterFields = "Payroll Period","Employee No.","E/D Code","Employee Category";
            RequestFilterHeading = 'Month End';
            column(ReportForNavId_4449; 4449)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window1.Update(1,"Payroll Period");
                Window1.Update(2,"Employee No.");
                Window1.Update(3,"E/D Code");
                
                EDFileRec.Get(Payslip."E/D Code");
                if EDFileRec."Yes/No Req." then
                  if (not Payslip.Flag) or (Payslip.Amount = 0) then
                    CurrReport.Skip;
                
                // closed payroll cannot be adjusted
                ProllPayslipHeader.Get("Payroll Period","Employee No.");
                if ProllPayslipHeader.Closed then
                  CurrReport.Skip;
                
                InitialAmount := Amount;
                // check employee delimitations
                ProllEmployee.Get("Employee No.");
                if (EmployeeGroupFilter <> '') then begin
                  if ProllPayslipHeader."Salary Group" <> EmployeeGroupFilter then
                    CurrReport.Skip;
                  /*ProllEmployeeGroupHeader.Code := ProllEmployee."Employee Group";
                  IF NOT ProllEmployeeGroupHeader.FIND('=') THEN CurrReport.SKIP;*/
                end;
                
                if FromDate <> 0D then
                  if ProllEmployee."Employment Date" < FromDate then CurrReport.Skip;
                
                if ToDate <> 0D then
                  if ProllEmployee."Employment Date" > ToDate then CurrReport.Skip;
                
                if (Amount = 0) and (not AdjustAnyway) then
                  CurrReport.Skip;
                
                if QuantityDiff <> 0 then begin
                  if "Add/Subtract" = 0 then
                    Validate(Quantity,Quantity + QuantityDiff)
                  else
                    Validate(Quantity,Quantity - QuantityDiff)
                end else begin
                  if CopyFromGroup then begin
                    ProllEmployeeGroupLine.Get(ProllPayslipHeader."Salary Group","E/D Code");
                    Amount := ProllEmployeeGroupLine."Default Amount";
                  end else begin
                    // use percentage
                    if Percentage <> 0 then AmountDiff := Amount * Percentage / 100;
                
                    if StaticAmount <> 0 then begin
                      AmountDiff := StaticAmount - Amount;
                      Amount := StaticAmount;
                    end else begin
                      if "Add/Subtract" = 0 then
                        Amount := Amount + AmountDiff
                      else
                        Amount := Amount - AmountDiff;
                    end;
                  end;
                end;
                
                if (MaxAmount <> 0) and (Amount > MaxAmount) then
                  Amount := MaxAmount;
                
                if (MinAmount <> 0) and (Amount < MinAmount) then
                  Amount := MinAmount;
                
                if RoundingPrecision <> 0 then
                  Amount := CheckRounding(Amount);
                
                Payslip.CalcAmountLCY;
                
                Modify;
                
                if InitialAmount = Amount then CurrReport.Skip;
                
                CalcCompute (Payslip, Amount, false, "E/D Code");
                CalcFactor1 (Payslip);
                ChangeOthers := false;
                ChangeAllOver (Payslip, false);
                ResetChangeFlags(Payslip);

            end;

            trigger OnPostDataItem()
            begin
                if PayrollPeriod in [2,3] then
                  Window1.Close;
            end;

            trigger OnPreDataItem()
            begin
                //IF NOT (PayrollPeriod IN [2,3]) THEN
                  //CurrReport.BREAK;

                if not EDFileRec.Get(GetFilter("E/D Code")) then
                  Error('One E/D Code must be specified on E/D Code filter!');

                if not EDFileRec."Edit Amount" and (QuantityDiff = 0) then
                  Error('%1 cannot be edited!',EDFileRec."E/D Code");

                if (QuantityDiff <> 0) then
                  EDFileRec.TestField(Units)
                else
                  EDFileRec.TestField(Units,'');

                RoundingDirection := EDFileRec."Rounding Direction";
                RoundingPrecision := EDFileRec."Rounding Precision";

                Window1.Open ('Month End Payroll\' +
                            'Current Period    #1#####\' +
                            'Current Employee  #2####\'+
                            'Current E/D       #3###\');
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

    trigger OnPostReport()
    begin
        Message('FUNCTION COMPLETED!');
    end;

    trigger OnPreReport()
    begin
        if (Percentage <> 0) and (AmountDiff <> 0) then
          Error('You must not specify both % Adjusment and Fixed amount together!');

        if (AmountDiff <> 0) and (QuantityDiff <> 0) then Error('You must not specify both % Amount and Quantity Diff. together!');
        //IF PayrollPeriod = 0 THEN ERROR('Payroll type must be specified!');
        if (MinAmount <> 0) and (MaxAmount <> 0) and (MinAmount > MaxAmount) then
          Error('Min. Amount must not be greater than Max. Amount!');

        if EmployeeGroupFilter <> '' then
          ProllEmployeeGroupHeader.SetFilter(ProllEmployeeGroupHeader.Code,EmployeeGroupFilter);
    end;

    var
        EDFileRec: Record "Payroll-E/D";
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        ProllEmployee: Record "Payroll-Employee";
        ProllEmployeeGroupHeader: Record "Payroll-Employee Group Header";
        ProllEmployeeGroupLine: Record "Payroll-Employee Group Line";
        ProllEmployeeGroupFHLine: Record "Proll-Emply Grp First Half";
        EmployeeGroupFilter: Code[120];
        FromDate: Date;
        ToDate: Date;
        Window1: Dialog;
        Window2: Dialog;
        InitialAmount: Decimal;
        Percentage: Decimal;
        AmountDiff: Decimal;
        StaticAmount: Decimal;
        MinAmount: Decimal;
        MaxAmount: Decimal;
        QuantityDiff: Integer;
        "Add/Subtract": Option Add,Subtract;
        PayrollPeriod: Option " ","First Half","Month End",Both;
        RoundingDirection: Option Nearest,Higher,Lower;
        RoundingPrecision: Decimal;
        AdjustAnyway: Boolean;
        CopyFromGroup: Boolean;


    procedure CheckRounding(TheAmount: Decimal) TheAmount2: Decimal
    var
        RoundDir: Code[1];
    begin
        /* Check for rounding */
        case RoundingDirection of
          1: RoundDir := '>';
          2: RoundDir := '<';
          else RoundDir := '=';
        end;
        
        TheAmount2 := ROUND(TheAmount,RoundingPrecision,RoundDir);
        
        exit;

    end;
}

