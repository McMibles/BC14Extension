Report 52092175 "Adjust Salary Scale"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(EmployeeGroup;"Payroll-Employee Group Line")
        {
            RequestFilterFields = "Employee Group","E/D Code";
            RequestFilterHeading = 'Empl Group Month End';
            column(ReportForNavId_4811; 4811)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"Employee Group");
                Window.Update(2,"E/D Code");

                if Percentage <> 0 then AmountDiff := "Default Amount" * Percentage / 100;

                if "Add/Subtract" = 0 then
                  "Default Amount" := CheckRounding("Default Amount" + AmountDiff)
                else
                  "Default Amount" := CheckRounding("Default Amount" - AmountDiff);

                Modify;

                if AmountDiff = 0 then CurrReport.Skip;

                Mark( true);
                CalcCompute (EmployeeGroup, "Default Amount", false);
                CalcFactor1 (EmployeeGroup);
                ChangeOthers := false;
                ChangeAllOver (EmployeeGroup, false);
                Mark( false)
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                RoundingDirection := EDFileRec."Rounding Direction";
                RoundingPrecision := EDFileRec."Rounding Precision";

                Window.Open (Text003 + Text004 + Text005);
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
        Message(Text002);
    end;

    trigger OnPreReport()
    begin
        if (Percentage <> 0) and (AmountDiff <> 0) then
          Error(Text001);
    end;

    var
        EDFileRec: Record "Payroll-E/D";
        Window: Dialog;
        Percentage: Decimal;
        AmountDiff: Decimal;
        "Add/Subtract": Option Add,Subtract;
        RoundingDirection: Option Nearest,Higher,Lower;
        RoundingPrecision: Decimal;
        RoundRec: Decimal;
        Text001: label 'You must not specify both % Adjusment and Specific amount together!';
        Text002: label 'FUNCTION COMPLETED!';
        Text003: label 'Month End Payroll\';
        Text004: label 'Current Employee Group  #1##########\';
        Text005: label 'Current E/D             #2############\';


    procedure CheckRounding(TheAmount: Decimal) TheAmount2: Decimal
    var
        RoundDir: Code[1];
    begin
        if RoundingPrecision = 0 then
          RoundRec := 0.01
        else
          RoundRec := RoundingPrecision;

        case RoundingDirection of
          1: RoundDir := '>';
          2: RoundDir := '<';
          else RoundDir := '=';
        end;

        TheAmount2 := ROUND(TheAmount,RoundRec,RoundDir);

        exit;
    end;
}

