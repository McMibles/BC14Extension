Report 52092151 "Payroll Top 10 Earners"
{
    // This Batch Job Copies the entries of one period to another for selected
    // employees or all employees.
    // Also you can choose whether to close the source entries or not.
    // Further you must select the target period.
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Payroll Top 10 Earners.rdlc';


    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=filter(1..));
            column(ReportForNavId_1; 1)
            {
            }
            column(Employee_No;Employee."No.")
            {
            }
            column(Employee_Name;Employee.FullName)
            {
            }
            column(Employee_GlobalDim1;DimMgt.ReturnDimName(1,Employee."Global Dimension 1 Code"))
            {
            }
            column(Employee_GlobalDim2;DimMgt.ReturnDimName(2,Employee."Global Dimension 2 Code"))
            {
            }
            column(Dimension1_Caption;Employee.FieldCaption("Global Dimension 1 Code"))
            {
            }
            column(Dimension2_Caption;Employee.FieldCaption("Global Dimension 2 Code"))
            {
            }
            column(Amount;Amount)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not PayrollTopQry.Read then
                  CurrReport.Break;
                Employee.Get(PayrollTopQry.No);
                Amount := PayrollTopQry.ED_Closed_Amount;
                if Amount = 0 then
                  CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                PayrollSetup.Get;
                PayrollTopQry.SetFilter(PayrollTopQry.Period_Filter,PeriodFilter);
                PayrollTopQry.SetFilter(PayrollTopQry.ED_Filter,PayrollSetup."Annual Gross Pay E/D Code");
                PayrollTopQry.Open;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    Caption = 'Option';
                    field(PeriodFilter;PeriodFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Enter Period';
                        TableRelation = "Payroll-Period";
                    }
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

    var
        PayrollSetup: Record "Payroll-Setup";
        Employee: Record "Payroll-Employee";
        PayrollTopQry: Query "Top 10 Earners";
        PeriodFilter: Text;
        Amount: Decimal;
        DimMgt: Codeunit "Dimension Hook";
}

