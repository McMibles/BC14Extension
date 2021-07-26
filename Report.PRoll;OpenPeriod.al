Report 52092152 "PRoll; Open Period"
{
    // This Batch Job open the source period.

    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Payslip Header"; "Payroll-Payslip Header")
        {
            DataItemTableView = sorting("Payroll Period", "Employee No.");
            column(ReportForNavId_1435; 1435)
            {
            }

            trigger OnAfterGetRecord()
            begin
                LineCount := LineCount + 1;
                Window.Update(1, "Payroll-Payslip Header"."Payroll Period");
                Window.Update(2, LineCount);
                Window.Update(3, ROUND(LineCount / NoOfRecords * 10000, 1));


                /*Close  current header*/
                begin
                    /* Set Closed to true in P.Roll Header file */
                    Closed := false;
                    Modify
                end;

            end;

            trigger OnPreDataItem()
            begin
                if PeriodFilter = '' then
                    Error('The Period must be entered as a parameter');
                if OpenOption in [0, 2] then
                    "Payroll-Payslip Header".SetFilter("Payroll Period", PeriodFilter)
                else
                    CurrReport.Break;
                if EmployeeFilter <> '' then
                    "Payroll-Payslip Header".SetFilter("Employee No.", EmployeeFilter)
                else
                    "Payroll-Payslip Header".SetRange("Employee No.");

                NoOfRecords := Count;
                LineCount := 0;
                Window.Open(
                    'Payroll Period     #1##########\\' +
                    'Enployee Counter   #2###### @3@@@@@@@@@@@@@');
            end;
        }
        dataitem("Payslip Header First Half"; "Payslip Header First Half")
        {
            DataItemTableView = sorting("Payroll Period", "Arrear Type", "Employee No");
            column(ReportForNavId_4442; 4442)
            {
            }

            trigger OnAfterGetRecord()
            begin
                LineCount := LineCount + 1;
                Window.Update(1, "Payslip Header First Half"."Payroll Period");
                Window.Update(2, LineCount);
                Window.Update(3, ROUND(LineCount / NoOfRecords * 10000, 1));

                /*Close  current header*/
                begin
                    /* Set Closed to true in P.Roll Header file */
                    "Closed?" := false;
                    Modify
                end;

            end;

            trigger OnPreDataItem()
            begin
                if PeriodFilter = '' then
                    Error('The Period must be entered as a parameter');

                if OpenOption in [1, 2] then
                    "Payslip Header First Half".SetFilter("Payroll Period", PeriodFilter)
                else
                    CurrReport.Break;
                if EmployeeFilter <> '' then
                    "Payslip Header First Half".SetFilter("Employee No", EmployeeFilter)
                else
                    "Payslip Header First Half".SetRange("Employee No");

                NoOfRecords := Count;
                LineCount := 0;
                Window.Open(
                    'Payroll Period     #1##########\\' +
                    'Enployee Counter   #2###### @3@@@@@@@@@@@@@');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(PeriodFilter; PeriodFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Filter';
                    TableRelation = "Payroll-Period";
                }
                field(EmployeeFilter; EmployeeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Filter';
                    TableRelation = "Payroll-Employee";
                }
                field(OpenOption; OpenOption)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
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
        Message(Text001, PeriodFilter);
    end;

    var
        RequestPeriodRec: Record "Payroll-Period";
        PeriodFilter: Text[250];
        Text001: label 'Period %1 has been re-opened';
        OpenOption: Option "Payslip Only","Arrears Only",Both;
        EmployeeFilter: Text[250];
        NoOfRecords: Integer;
        LineCount: Integer;
        Window: Dialog;
}

