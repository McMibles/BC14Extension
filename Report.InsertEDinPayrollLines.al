Report 52092181 "Insert ED in Payroll Lines"
{
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-E/D"; "Payroll-E/D")
        {
            RequestFilterFields = "E/D Code";
            column(ReportForNavId_9150; 9150)
            {
            }
            dataitem("Payroll-Payslip Header"; "Payroll-Payslip Header")
            {
                RequestFilterFields = "Payroll Period", "Employee No.", "Employee Category";
                column(ReportForNavId_1435; 1435)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(1, "Payroll-E/D"."E/D Code");
                    Window.Update(2, "Payroll-Payslip Header"."Employee No.");

                    if not ProllLines.Get("Payroll Period", "Employee No.", "Payroll-E/D"."E/D Code") then begin
                        ProllLines.Init;
                        ProllLines."Payroll Period" := "Payroll-Payslip Header"."Payroll Period";
                        ProllLines."Employee No." := "Payroll-Payslip Header"."Employee No.";
                        ProllLines."E/D Code" := "Payroll-E/D"."E/D Code";
                        ProllLines."Global Dimension 1 Code" := "Payroll-Payslip Header"."Global Dimension 1 Code";
                        ProllLines."Global Dimension 2 Code" := "Payroll-Payslip Header"."Global Dimension 2 Code";
                        ProllLines.Validate("E/D Code");
                        ProllLines.Insert;

                        /* If this new entry contributes in computing another, then compute that value
                          for that computed entry and insert it appropriately*/
                        ProllLines.CalcCompute(ProllLines, ProllLines.Amount, false, ProllLines."E/D Code");
                        /*BDC*/

                        /* If this new entry is a contributory factor for the value of another line,
                          then compute that other line's value and insert it appropriately */
                        ProllLines.CalcFactor1(ProllLines);

                        /* The two functions above have used this line to change others */
                        ProllLines.ChangeOthers := false;

                        /* Go through all the lines and change where necessary */
                        ProllLines.ChangeAllOver(ProllLines, false);

                        /* Reset the ChangeOthers flag in all lines */
                        ProllLines.ResetChangeFlags(ProllLines);
                    end else
                        CurrReport.Skip;

                end;

                trigger OnPreDataItem()
                begin
                    if GetFilter("Payroll-Payslip Header"."Payroll Period") = '' then
                        Error('Payroll Period must be specified!');

                    if Closed then
                        Error(Text000);

                    TestField("Journal Posted", false);

                    UserSetup.Get(UserId);
                    if not (UserSetup."Payroll Administrator") then begin
                        FilterGroup(2);
                        SetFilter("Employee Category", UserSetup."Personnel Level");
                        FilterGroup(0);
                    end else
                        SetRange("Employee Category");
                end;
            }

            trigger OnPreDataItem()
            begin
                Window.Open('Updating ED #1#############\' +
                            'Updating Employee #2###########');
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
        ProllLines: Record "Payroll-Payslip Line";
        ProllPostGrpLine: Record "Payroll-Posting Group Line";
        EDRec: Record "Payroll-E/D";
        UserSetup: Record "User Setup";
        EDCode: Code[10];
        Text000: label 'Period already closed!';
        Window: Dialog;
}

