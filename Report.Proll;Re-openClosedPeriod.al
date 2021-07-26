Report 52092172 "Proll; Re-open Closed Period"
{
    // This Batch Job re-opens closed source period.

    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Period";"Payroll-Period")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem("Payroll-Payslip Header";"Payroll-Payslip Header")
            {
                DataItemLink = "Payroll Period"=field("Period Code");
                DataItemTableView = sorting("Payroll Period","Employee No.");
                RequestFilterFields = "Payroll Period","Employee No.","Employee Category";
                column(ReportForNavId_1435; 1435)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    LineCount := LineCount + 1;
                    Window.Update(2,LineCount);
                    Window.Update(3,ROUND(LineCount / NoOfRecords * 10000,1));
                    
                    /*Close  current header*/
                    begin
                      /* Set Closed to false in P.Roll Header file */
                      Closed := false;
                      Modify
                    end;

                end;

                trigger OnPostDataItem()
                begin
                    Window.Close;
                    Message('FUNCTION COMPLETED!');
                end;

                trigger OnPreDataItem()
                begin
                    Window.Open(
                        'Payroll Period     #1##########\\' +
                        'Enployee Counter   #2###### @3@@@@@@@@@@@@@');
                    Window.Update(1,GetFilter("Payroll Period"));

                    NoOfRecords := Count;
                    LineCount := 0;
                end;
            }

            trigger OnPreDataItem()
            begin
                if  GetFilter("Period Code") = '' then
                  Error (Text001);
                if not Confirm(Text002,false,GetFilter("Period Code")) then
                  CurrReport.Quit;
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

    var
        RequestPeriodRec: Record "Payroll-Period";
        ReqPeriod: Code[10];
        NoOfRecords: Integer;
        LineCount: Integer;
        Window: Dialog;
        Text001: label 'The Period(s) to open must be entered as a parameter';
        Text002: label 'Are you sure you want to re-open closed period(s) %1!';
}

