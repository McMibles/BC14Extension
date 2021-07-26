Report 52092183 "Flag Payroll Entries"
{
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Payslip Header"; "Payroll-Payslip Header")
        {
            RequestFilterFields = "Payroll Period", "Employee No.", "Salary Group";
            column(ReportForNavId_1435; 1435)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CreateandUpdate := true;
                EDRec.Get(EDCode);
                Window.Update(1, EDRec.Description);
                Employee.Get("Payroll-Payslip Header"."Employee No.");

                //Check Conditions
                if not (EDRec.CheckandAllow("Employee No.", "Salary Group")) then
                    CreateandUpdate := false;

                //Check Marital Status
                if EDRec."Marital Status" <> 0 then
                    if EDRec."Marital Status" <> Employee."Marital Status" then
                        CreateandUpdate := false;

                // check for common ids - E/Ds with same implications
                Found := false;
                if EDRec."Common Id" <> '' then begin
                    EDRec.SetRange(EDRec."Common Id", EDRec."Common Id");
                    EDRec.Find('-');
                    repeat
                        if EDRec."E/D Code" <> EDCode then
                            if ProllEntryRec.Get("Payroll Period", "Employee No.", EDRec."E/D Code") then begin
                                Found := true;
                                CreateandUpdate := false;
                            end;
                    until (EDRec.Next = 0) or Found;
                end;
                EDRec.Get(EDCode);

                if CreateandUpdate then begin
                    Window.Update(2, "Employee No.");
                    if not ProllLines.Get("Payroll Period", "Employee No.", EDCode) then begin
                        ProllLines.Init;
                        ProllLines."Payroll Period" := "Payroll-Payslip Header"."Payroll Period";
                        ProllLines."Employee No." := "Payroll-Payslip Header"."Employee No.";
                        ProllLines."E/D Code" := EDCode;
                        ProllLines.Validate("E/D Code");
                        ProllLines.Validate(Flag, true);
                        ProllLines."User Id" := UserId;

                        //check for maximum number of entries in the year
                        if EDRec."Max. Entries Per Year" <> 0 then
                            if EDRec."Max. Entries Per Year" <= ProllLines.CheckNoOfEntries then
                                CurrReport.Skip;
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

                    end else begin
                        EDRec.Get(EDCode);
                        //check for maximum number of entries in the year
                        if EDRec."Max. Entries Per Year" <> 0 then
                            if EDRec."Max. Entries Per Year" <= ProllLines.CheckNoOfEntries then
                                CurrReport.Skip;

                        ProllLines.Validate(Flag, true);
                        ProllLines.Validate("E/D Code");
                        ProllLines.Modify;
                        Commit;
                        /* If this new entry contributes in computing another, then compute that value
                          for that computed entry and insert it appropriately*/
                        ProllLines.CalcCompute(ProllLines, ProllLines.Amount, false, EDCode);
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
                    end;
                end;

            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                UserSetup.Get(UserId);
                if not (UserSetup."Payroll Administrator") then begin
                    FilterGroup(2);
                    SetFilter("Employee Category", UserSetup."Personnel Level");
                    FilterGroup(0);
                end else
                    SetRange("Employee Category");


                if GetFilter("Payroll-Payslip Header"."Payroll Period") = '' then
                    Error('Payroll Period must be specified!');
                if EDCode = '' then Error('ED Code must be specified!');

                if Closed then
                    Error(Text000);
                TestField("Journal Posted", false);

                Window.Open('Updating #1#############\' +
                            'Updating Employee #2###########');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(EDCode; EDCode)
                {
                    ApplicationArea = Basic;
                    TableRelation = "Payroll-E/D" where("Yes/No Req." = const(true));
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
        ProllLines: Record "Payroll-Payslip Line";
        ProllEntryRec: Record "Payroll-Payslip Line";
        ProllPostGrpLine: Record "Payroll-Posting Group Line";
        EDRec: Record "Payroll-E/D";
        Employee: Record "Payroll-Employee";
        UserSetup: Record "User Setup";
        EDCode: Code[10];
        Text000: label 'Period already closed!';
        CreateandUpdate: Boolean;
        Found: Boolean;
        Window: Dialog;
}

