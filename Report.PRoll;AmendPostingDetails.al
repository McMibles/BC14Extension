Report 52092155 "PRoll; Amend Posting Details"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;"Payroll-Employee")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Global Dimension 1 Code","Global Dimension 2 Code";
            column(ReportForNavId_7528; 7528)
            {
            }
            dataitem("Payroll-Payslip Header";"Payroll-Payslip Header")
            {
                DataItemLink = "Employee No."=field("No.");
                DataItemTableView = sorting("Employee No.","Payroll Period");
                RequestFilterFields = "Payroll Period";
                column(ReportForNavId_1435; 1435)
                {
                }
                dataitem("Payroll-Payslip Line";"Payroll-Payslip Line")
                {
                    DataItemLink = "Employee No."=field("Employee No."),"Payroll Period"=field("Payroll Period");
                    DataItemTableView = sorting("Employee No.","Payroll Period");
                    RequestFilterFields = "Payroll Period","E/D Code";
                    RequestFilterHeading = 'Month End';
                    column(ReportForNavId_4449; 4449)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Window.Update (3,"Payroll Period");
                        Window.Update (4,"E/D Code");
                        InfoCounter := InfoCounter + 1;
                        Window.Update (5,InfoCounter);

                        "Employee Category" :="Payroll-Payslip Header"."Employee Category";

                        if BookGrLinesRec.Get(Employee."Posting Group", "E/D Code")
                        then begin
                          begin
                            "Debit Account" := BookGrLinesRec."Debit Account No.";
                            "Credit Account" := BookGrLinesRec."Credit Account No.";
                            "Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
                            "Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";
                            "Global Dimension 1 Code" := BookGrLinesRec."Global Dimension 1 Code";
                            "Global Dimension 2 Code" := BookGrLinesRec."Global Dimension 2 Code";
                          end;
                          if not BookGrLinesRec."Transfer Global Dim. 1 Code" then
                            "Global Dimension 1 Code" := ''
                          else
                            if "Global Dimension 1 Code" = '' then
                              "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";

                          if not BookGrLinesRec."Transfer Global Dim. 2 Code" then
                            "Global Dimension 2 Code" := ''
                          else
                            if "Global Dimension 2 Code" = '' then
                              "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";

                          if (BookGrLinesRec."Debit Acc. Type" = 1) then
                            if Employee."Customer No." <> '' then
                              "Debit Account" := Employee."Customer No.";
                          if (BookGrLinesRec."Credit Acc. Type" = 1) then
                            if Employee."Customer No." <> '' then
                              "Credit Account" := Employee."Customer No.";


                        end else begin
                          "Global Dimension 1 Code" := '';
                          "Global Dimension 2 Code" := '';
                          "Job No." := '';
                          "Debit Account"  := '';
                          "Credit Account" := '';
                        end;

                        "Payroll-Payslip Line".Modify;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Employee.SetRange(Employee."Period Filter","Payroll Period");
                    Employee.CalcFields(Employee."ED Closed Amount");
                    if (Employee."ED Closed Amount" = 0) and (Employee."Posting Group" = '') then
                      CurrReport.Skip;

                    PostingGroup.Get(Employee."Posting Group");
                    "Employee Name" := Employee.FullName;
                    "Employee Category" := Employee."Employee Category";
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    "Payroll-Payslip Header"."Tax State" :=  Employee."Tax State";
                    "Payroll-Payslip Header"."Pension Adminstrator Code" := Employee."Pension Administrator Code";
                    Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update (2,"No.");
            end;

            trigger OnPreDataItem()
            begin
                Window.Open ('Total Employees Selected   #1##\' +
                            'Current Employee Number    #2###\'+
                            'Current Period     #3####\'+
                            'Current E/D        #4###\'+
                            'Counter   #5###' );
                Window.Update (1, Count);
                InfoCounter := 0;
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
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        PostingGroup: Record "Payroll-Posting Group Header";
        InfoCounter: Integer;
        Window: Dialog;
}

