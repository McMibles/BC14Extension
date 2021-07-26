Report 52092161 "Adjust Monthly Salary"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Payslip;"Payroll-Payslip Header")
        {
            DataItemTableView = sorting("Payroll Period","Employee No.");
            column(ReportForNavId_7528; 7528)
            {
            }
            dataitem(PayslipLine;"Payroll-Payslip Line")
            {
                DataItemLink = "Payroll Period"=field("Payroll Period"),"Employee No."=field("Employee No.");
                RequestFilterFields = "Payroll Period","E/D Code";
                RequestFilterHeading = 'Month End';
                column(ReportForNavId_4449; 4449)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,"E/D Code");

                    if Percentage <> 0 then
                      AmountDiff := Amount * Percentage / 100;

                    if "Add/Subtract" = 0 then
                      Amount := Amount + AmountDiff
                    else
                      Amount := Amount - AmountDiff;

                    Amount := CheckRounding(Amount);
                    PayslipLine.CalcAmountLCY;
                    Modify;

                    if AmountDiff = 0 then CurrReport.Skip;

                    CalcCompute (PayslipLine, Amount, false, "E/D Code");
                    CalcFactor1 (PayslipLine);
                    ChangeOthers := false;
                    ChangeAllOver (PayslipLine, false);
                    ResetChangeFlags(PayslipLine);
                end;

                trigger OnPreDataItem()
                begin
                    if not EDFileRec.Get(GetFilter("E/D Code")) then
                      Error(Text003);

                    if not EDFileRec."Edit Amount" then
                      Error(Text004,EDFileRec."E/D Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,Payslip."Employee No.");
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open (Text006 + Text007+Text008+Text009);
                UserSetup.Get(UserId);
                if not(UserSetup."Payroll Administrator") then begin
                  FilterGroup(2);
                  if UserSetup."Personnel Level" <> '' then
                    SetFilter("Employee Category",UserSetup."Personnel Level")
                  else
                    SetRange("Employee Category");
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
                field(Percentage;Percentage)
                {
                    ApplicationArea = Basic;
                    Caption = '% Adjustment';
                }
                field(AmountDiff;AmountDiff)
                {
                    ApplicationArea = Basic;
                    Caption = 'Specific Amount';
                }
                field(AddSubtract;"Add/Subtract")
                {
                    ApplicationArea = Basic;
                    Caption = 'Add/Subtract';
                }
                field(RoundingDirection;RoundingDirection)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rounding Direction';
                }
                field(RoundingPrecision;RoundingPrecision)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rounding Precision';
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

    trigger OnPostReport()
    begin
        Message(Text005);
    end;

    trigger OnPreReport()
    begin
        if (Percentage <> 0) and (AmountDiff <> 0) then
          Error(Text001);

        if RoundingPrecision = 0 then
          RoundingPrecision := 0.01;
    end;

    var
        EDFileRec: Record "Payroll-E/D";
        UserSetup: Record "User Setup";
        Window: Dialog;
        Percentage: Decimal;
        AmountDiff: Decimal;
        "Add/Subtract": Option Add,Subtract;
        RoundingDirection: Option Nearest,Higher,Lower;
        RoundingPrecision: Decimal;
        Text001: label 'AYou must not specify both % Adjusment and Specific Amount together!';
        Text002: label 'Payroll type must be specified!';
        Text003: label 'One E/D Code must be specified on E/D Code filter!';
        Text004: label '%1 cannot be edited!';
        Text005: label 'FUNCTION COMPLETED!';
        Text006: label 'Changing Monthly Salary\';
        Text007: label 'Current Employee No. #1##########\';
        Text008: label 'Current E/D ................\';
        Text009: label 'Month End E/D        #2##########\';


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

