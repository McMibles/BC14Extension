Report 52092177 "Apply New Salary Scale"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            RequestFilterFields = "No.","Alt. Address Start Date","Alt. Address Code","Resource No.";
            column(ReportForNavId_7528; 7528)
            {
            }
            dataitem("Payroll-Payslip Line";"Payroll-Payslip Line")
            {
                DataItemLink = "Employee No."=field("No.");
                RequestFilterFields = "Payroll Period","E/D Code";
                RequestFilterHeading = 'Month End';
                column(ReportForNavId_4449; 4449)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,"E/D Code");
                    
                    // closed payroll cannot be adjusted
                    ProllPayslipHeader.Get("Payroll-Payslip Line","Employee No.");
                    if ProllPayslipHeader.Closed then
                      CurrReport.Skip;
                    
                    PayrollMgt.GetSalaryGroup("Employee No.",ProllPayslipHeader."Period Start",EmployeeGroup);
                    EmplGroupHeader.Get(EmployeeGroup);
                    EmplGroupLine.Get(EmplGroupHeader.Code,"E/D Code");
                    
                    if Amount = EmplGroupLine."Default Amount" then CurrReport.Skip;
                    
                    Amount := CheckRounding(EmplGroupLine."Default Amount");
                    Modify;
                    
                    /* If this new entry contributes in computing another, then compute that value
                      for that computed entry and insert it appropriately*/
                      CalcCompute ("Payroll-Payslip Line", Amount, false, "E/D Code");
                    /*BDC*/
                    
                      /* If this new entry is a contributory factor for the value of another line,
                        then compute that other line's value and insert it appropriately */
                      CalcFactor1 ("Payroll-Payslip Line");
                    
                      /* The two functions above have used this line to change others */
                      ChangeOthers := false;
                    
                      /* Go through all the lines and change where necessary */
                      ChangeAllOver ("Payroll-Payslip Line", false);
                    
                      /* Reset the ChangeOthers flag in all lines */
                      ResetChangeFlags("Payroll-Payslip Line");

                end;

                trigger OnPreDataItem()
                begin
                    if not (PayrollPeriod in [2,3]) then
                      CurrReport.Break;

                    if not EDFileRec.Get(GetFilter("E/D Code")) then
                      Error('One E/D Code must be specified on E/D Code filter!');

                    if not EDFileRec."Edit Amount" then
                      Error('%1 cannot be edited!');

                    RoundingPrecision := EDFileRec."Rounding Precision";
                    RoundingDirection := EDFileRec."Rounding Direction";
                end;
            }
            dataitem("Proll-Pslip Lines First Half";"Proll-Pslip Lines First Half")
            {
                DataItemLink = "Employee No."=field("No.");
                RequestFilterFields = "Payroll Period","E/D Code";
                RequestFilterHeading = 'First Half';
                column(ReportForNavId_9769; 9769)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,"E/D Code");
                    
                    // closed payroll cannot be adjusted
                    ProllPayslipHeader.Get("Payroll Period","Employee No.");
                    if ProllPayslipHeader.Closed then
                      CurrReport.Skip;
                    
                    PayrollMgt.GetSalaryGroup("Employee No.",ProllPayslipHeader."Period Start",EmployeeGroup);
                    EmplGroupHeader.Get(EmployeeGroup);
                    
                    EmplGroupFirstHalf.Get(EmplGroupHeader.Code,"E/D Code");
                    
                    if Amount = EmplGroupFirstHalf."Default Amount" then CurrReport.Skip;
                    
                    Amount := CheckRounding(EmplGroupFirstHalf."Default Amount");
                    Modify;
                    
                      /* If this new entry contributes in computing another, then compute that value
                        for that computed entry and insert it appropriately*/
                      CalcCompute ("Proll-Pslip Lines First Half", Amount, false, "E/D Code");
                    /*BDC*/
                    
                      /* If this new entry is a contributory factor for the value of another line,
                        then compute that other line's value and insert it appropriately */
                      CalcFactor1 ("Proll-Pslip Lines First Half");
                    
                      /* The two functions above have used this line to change others */
                      ChangeOthers := false;
                    
                      /* Go through all the lines and change where necessary */
                      ChangeAllOver ("Proll-Pslip Lines First Half", false);
                    
                      /* Reset the ChangeOthers flag in all lines */
                    /*    ResetChangeFlags ("Proll-Pslip Lines (First Half)");*/

                end;

                trigger OnPreDataItem()
                begin
                    if not (PayrollPeriod in [1,3]) then
                      CurrReport.Break;

                    if not EDFileRec.Get(GetFilter("E/D Code")) then
                      Error('One E/D Code must be specified on E/D Code filter!');

                    if not EDFileRec."Edit Amount" then
                      Error('%1 cannot be edited!');

                    RoundingPrecision := EDFileRec."Rounding Precision";
                    RoundingDirection := EDFileRec."Rounding Direction";
                end;
            }

            trigger OnAfterGetRecord()
            begin
                UserSetup.Get(UserId);
                if not(UserSetup."Payroll Administrator") then begin
                  FilterGroup(2);
                  SetFilter("Employee Category",UserSetup."Personnel Level");
                  FilterGroup(0);
                end else
                  SetRange("Employee Category");
                Window.Update(1,"No.");
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open ('Changing Monthly Salary\' +
                            'Current Employee No. #1####\'+
                            'Current E/D ................\'+
                            'Month End E/D        #2#####\'+
                            'First Half E/D       #3#####\');
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

    var
        EmplGroupHeader: Record "Payroll-Employee Group Header";
        EmplGroupLine: Record "Payroll-Employee Group Line";
        EmplGroupFirstHalf: Record "Proll-Emply Grp First Half";
        EDFileRec: Record "Payroll-E/D";
        UserSetup: Record "User Setup";
        EmployeeGroup: Code[20];
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        RoundingPrecision: Decimal;
        PayrollPeriod: Option " ","First Half","Month End",Both;
        RoundingDirection: Option Nearest,Higher,Lower;
        Window: Dialog;
        PayrollMgt: Codeunit "Payroll-Management";


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

