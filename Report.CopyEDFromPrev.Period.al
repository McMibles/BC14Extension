Report 52092170 "Copy E/D From Prev. Period"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Copy ED From Prev. Period.rdlc';

    dataset
    {
        dataitem(Employee; "Payroll-Employee")
        {
            RequestFilterFields = "No.", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(ReportForNavId_7528; 7528)
            {
            }
            dataitem(Payslip; "Payroll-Payslip Line")
            {
                DataItemLink = "Employee No." = field("No.");
                RequestFilterFields = "Payroll Period", "E/D Code";
                column(ReportForNavId_4449; 4449)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(3, "E/D Code");

                    ProllPayslipLine := Payslip;
                    Payslip."Payroll Period" := PeriodRec."Period Code";
                    if not ProllPayslipLine.Modify then ProllPayslipLine.Insert;

                    Payslip.ReCalculateAmount;
                    ProllPayslipLine.Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(2, "No.");
                if not ProllPayslipHeader.Get(PeriodRec."Period Code", "No.") then
                    CurrReport.Skip;
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
        Window.Close;
        Message('FUNCTION COMPLETED!');
    end;

    trigger OnPreReport()
    begin
        PeriodRec.Get(Payslip.GetFilter(Payslip."Payroll Period"));
        PeriodRec.SetRange(PeriodRec."Employee Category", PeriodRec."Employee Category");
        PeriodRec.Next;

        Window.Open('Current Period   #1#####\' +
                    'Current Employee  #2####\' +
                    'Current E/D       #3###\');

        Window.Update(1, PeriodRec."Period Code");
    end;

    var
        PeriodRec: Record "Payroll-Period";
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        ProllPayslipLine: Record "Payroll-Payslip Line";
        Window: Dialog;
}

