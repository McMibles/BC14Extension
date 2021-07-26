Report 52092169 "Payroll Variation Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Variation Report.rdlc';

    dataset
    {
        dataitem(ED;"Payroll-E/D")
        {
            DataItemTableView = where(Variable=const(true));
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000008; 1000000008)
            {
            }
            column(EDCode_PayrollEDCodes;ED."E/D Code")
            {
            }
            column(PayslipAppearanceText_PayrollEDCodes;ED."Payslip Appearance Text")
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Report_Title;'VARIATION REPORT FOR : ' + ' ' + Format(PayPeriod."Start Date",0,'<month text>,<year4>'))
            {
            }
            dataitem(Payslip;"Payroll-Payslip Line")
            {
                DataItemLink = "E/D Code"=field("E/D Code");
                DataItemTableView = sorting("Global Dimension 1 Code","E/D Code");
                RequestFilterFields = "Payroll Period","Global Dimension 1 Code";
                column(ReportForNavId_4449; 4449)
                {
                }
                column(EDCode_PayrollPayslipLines;Payslip."E/D Code")
                {
                }
                column(Payroll_Payslip_Lines__Global_Dimension_1_Code_;"Global Dimension 1 Code")
                {
                }
                column(Payroll_Payslip_Lines__Employee_No_;"Employee No.")
                {
                }
                column(Payroll_Payslip_Lines_Amount;Amount)
                {
                }
                column(Employee_FullName;Employee.FullName)
                {
                }
                column(Employee__Grade_Level_;Employee."Grade Level Code")
                {
                }
                column(Payroll_Payslip_Lines__Payroll_Payslip_Lines__Quantity;Payslip.Quantity)
                {
                }
                column(Payroll_Payslip_Lines__Global_Dimension_1_Code_Caption;FieldCaption("Global Dimension 1 Code"))
                {
                }
                column(Payroll_Payslip_Lines__Employee_No_Caption;FieldCaption("Employee No."))
                {
                }
                column(Payroll_Payslip_Lines_AmountCaption;FieldCaption(Amount))
                {
                }
                column(Payroll_Payslip_Lines_Payroll_Period;"Payroll Period")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Payslip.Amount = 0 then
                      CurrReport.Skip;
                    Employee.Get(Payslip."Employee No.");
                end;

                trigger OnPreDataItem()
                begin
                    PayPeriod.Get(Payslip.GetFilter(Payslip."Payroll Period"));
                    UserSetup.Get(UserId);
                    if not(UserSetup."Payroll Administrator") then begin
                      FilterGroup(2);
                      SetFilter("Employee Category",UserSetup."Personnel Level");
                      FilterGroup(0);
                    end else
                      SetRange("Employee Category");
                end;
            }
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

    trigger OnPreReport()
    begin
        if Payslip.GetFilter(Payslip."Payroll Period") = '' then
          Error(Text001);
    end;

    var
        Employee: Record "Payroll-Employee";
        EDFileRec: Record "Payroll-E/D";
        PayPeriod: Record "Payroll-Period";
        Text001: label 'Payroll Period must be specified';
        UserSetup: Record "User Setup";
}

