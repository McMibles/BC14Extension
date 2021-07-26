Report 52092154 "PRoll; Amend Payslip details"
{
    // This function copies any changes made in the fields Payslip appearance,
    // Payslip Group ID, Pos. In Payslip Grp., from the E/D file to the
    // Payslip file.

    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-E/D";"Payroll-E/D")
        {
            DataItemTableView = sorting("E/D Code");
            RequestFilterFields = "E/D Code";
            column(ReportForNavId_9150; 9150)
            {
            }
            dataitem("Payroll-Payslip Header";"Payroll-Payslip Header")
            {
                DataItemTableView = sorting("Payroll Period","Employee No.");
                RequestFilterFields = "Employee No.","Employee Category";
                column(ReportForNavId_1435; 1435)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update (2,"Payroll Period");
                    Window.Update (3,"Employee No.");
                    InfoCounter := InfoCounter + 1;
                    Window.Update (4,InfoCounter);

                    EntryFile.Reset;
                    EntryFile.SetRange("Payroll Period", "Payroll Period");
                    EntryFile.SetRange("Employee No.", "Employee No.");
                    EntryFile.SetRange("E/D Code","Payroll-E/D"."E/D Code");

                    EntryFile.ModifyAll("Global Dimension 1 Code",
                                "Payroll-Payslip Header"."Global Dimension 1 Code");

                    EntryFile.ModifyAll("Statistics Group Code",
                                "Payroll-E/D"."Statistics Group Code");
                    EntryFile.ModifyAll("Pos. In Payslip Grp.",
                                "Payroll-E/D"."Pos. In Payslip Grp.");
                    EntryFile.ModifyAll("Payslip Appearance",
                                "Payroll-E/D"."Payslip appearance");
                    EntryFile.ModifyAll("Overline Column",
                                "Payroll-E/D"."Overline Column");
                    EntryFile.ModifyAll("Underline Amount",
                                "Payroll-E/D"."Underline Amount");
                    EntryFile.ModifyAll("Payslip Column",
                                "Payroll-E/D"."Payslip Column");
                    if "Payroll-E/D"."Payslip Appearance Text" <> '' then
                      EntryFile.ModifyAll("Payslip Text",
                                "Payroll-E/D"."Payslip Appearance Text")
                    else
                      EntryFile.ModifyAll("Payslip Text",
                                "Payroll-E/D".Description);
                end;

                trigger OnPreDataItem()
                begin
                    if PayrollPeriod.Closed then
                      CurrReport.Break;

                    UserSetup.Get(UserId);
                    if not(UserSetup."Payroll Administrator") then begin
                      FilterGroup(2);
                      SetFilter("Employee Category",UserSetup."Personnel Level");
                      FilterGroup(0);
                    end;

                    SetRange("Payroll Period",PayrollPeriodCode);
                end;
            }
            dataitem("Closed Payroll-Payslip Header";"Closed Payroll-Payslip Header")
            {
                DataItemTableView = sorting("Payroll Period","Employee No.");
                column(ReportForNavId_1; 1)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update (2,"Payroll Period");
                    Window.Update (3,"Employee No.");
                    InfoCounter := InfoCounter + 1;
                    Window.Update (4,InfoCounter);

                    EntryFile2.Reset;
                    EntryFile2.SetRange("Payroll Period","Payroll Period");
                    EntryFile2.SetRange("Employee No.", "Employee No.");
                    EntryFile2.SetRange("E/D Code","Payroll-E/D"."E/D Code");

                    EntryFile2.ModifyAll("Global Dimension 1 Code",
                                "Payroll-Payslip Header"."Global Dimension 1 Code");

                    EntryFile2.ModifyAll("Statistics Group Code",
                                "Payroll-E/D"."Statistics Group Code");
                    EntryFile2.ModifyAll("Pos. In Payslip Grp.",
                                "Payroll-E/D"."Pos. In Payslip Grp.");
                    EntryFile2.ModifyAll("Payslip Appearance",
                                "Payroll-E/D"."Payslip appearance");
                    EntryFile2.ModifyAll("Overline Column",
                                "Payroll-E/D"."Overline Column");
                    EntryFile2.ModifyAll("Underline Amount",
                                "Payroll-E/D"."Underline Amount");
                    EntryFile2.ModifyAll("Payslip Column",
                                "Payroll-E/D"."Payslip Column");
                    if "Payroll-E/D"."Payslip Appearance Text" <> '' then
                      EntryFile2.ModifyAll("Payslip Text",
                                "Payroll-E/D"."Payslip Appearance Text")
                    else
                      EntryFile2.ModifyAll("Payslip Text",
                                "Payroll-E/D".Description);
                end;

                trigger OnPreDataItem()
                begin
                    if not(PayrollPeriod.Closed) then
                      CurrReport.Break;

                    "Closed Payroll-Payslip Header".SetView("Payroll-Payslip Header".GetView);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Open ('Current E/D         #1#####\' +
                            'Current Period      #2####\'+
                            'Current Employee    #3###\'+
                            'Counter    #4###' );
                Window.Update (1,"E/D Code");
            end;

            trigger OnPreDataItem()
            begin
                InfoCounter := 0;
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
                    field(PayrollPeriodCode;PayrollPeriodCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Select Payroll Period';
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

    trigger OnPostReport()
    begin
        Window.Close
    end;

    trigger OnPreReport()
    begin
        if PayrollPeriodCode = '' then
          Error(Text001);
        PayrollPeriod.Get(PayrollPeriodCode);
    end;

    var
        EntryFile: Record "Payroll-Payslip Line";
        EntryFile2: Record "Closed Payroll-Payslip Line";
        UserSetup: Record "User Setup";
        PayrollPeriod: Record "Payroll-Period";
        PayrollPeriodCode: Code[20];
        InfoCounter: Integer;
        Window: Dialog;
        Text001: label 'Payroll Period must be specified';
}

