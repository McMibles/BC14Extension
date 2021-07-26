Report 52092199 "Payslip Via Email"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Payroll-Period";"Payroll-Period")
        {
            DataItemTableView = sorting("Period Code");
            RequestFilterFields = "Period Code";
            column(ReportForNavId_2; 2)
            {
            }
            dataitem(Employee;"Payroll-Employee")
            {
                DataItemTableView = sorting("No.");
                RequestFilterFields = "No.","Global Dimension 1 Code","Global Dimension 2 Code";
                column(ReportForNavId_1; 1)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if SkipRecord then
                      CurrReport.Skip;

                    if not IncludeAlreadySentMail then
                      if GetMonthsSentMail <> 0 then
                        CurrReport.Skip;

                    if Employee."Company E-Mail" = '' then
                      CurrReport.Skip;

                    FileNameServer := FileManagement.ServerTempFileName('pdf');
                    Subject := UpperCase(PayAdviceTitle + ' '+ 'PAYSLIP');
                    Clear(PayslipHeader);
                    PayslipHeader.SetRange("Employee No.",Employee."No.");
                    PayslipHeader.SetRange("Payroll Period","Payroll-Period"."Period Code");
                    Payslip.SetShowHistorical(ShowHistorical);
                    Payslip.SetASCalledFromEmail(PayrollType);
                    Payslip.SetTableview(PayslipHeader);
                    Payslip.SaveAsPdf(FileNameServer);
                    SMTP.CreateMessage(COMPANYNAME,UserSetUp."E-Mail",Employee."E-Mail",Subject,Body,true);
                    SMTP.AppendBody('Dear ' + Employee.FullName + ',');
                    SMTP.AppendBody('<br><br>');
                    SMTP.AppendBody('Attached is your payslip for the month as contained in the title.');
                    SMTP.AppendBody('<br><br>');
                    SMTP.AppendBody('If you experience any difficulty viewing this document or questions thereon, kindly contact the IT Department.');
                    SMTP.AppendBody('<HR>');
                    SMTP.AppendBody('<BR>');
                    SMTP.AppendBody('Human Resource Department');
                    SMTP.AppendBody('<br><br>');
                    SMTP.AddAttachment(FileNameServer,StrSubstNo('Payslip %1.pdf',PayAdviceTitle));
                    SMTP.Send;
                    if Erase(FileNameServer) then;
                    Clear(Payslip);
                    Commit;
                end;

                trigger OnPreDataItem()
                begin
                    if not(UserSetUp."Payroll Administrator") then begin
                      FilterGroup(2);
                      SetFilter("Employee Category",UserSetUp."Personnel Level");
                      FilterGroup(0);
                    end else
                      SetRange("Employee Category");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Name <> '' then
                  PayAdviceTitle := DelChr (Name, '<>')
                else
                  PayAdviceTitle := DelChr ("Period Code", '<>');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(IncludeAlreadySentMail;IncludeAlreadySentMail)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Include Already Sent Mail';
                    }
                    field(ShowHistorical;ShowHistorical)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Historical';
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
        Message('FUNCTION COMPLETED!');
    end;

    trigger OnPreReport()
    begin
        UserSetUp.Get(UserId);
        UserSetUp.TestField("E-Mail");
    end;

    var
        PayslipHeader: Record "Payroll-Payslip Header";
        UserRec: Record "User Setup";
        UserSetUp: Record "User Setup";
        EmployeeEmail: Record "User Setup";
        Payslip: Report "Payroll Payslip";
        PeriodRec: Record "Payroll-Period";
        SMTP: Codeunit "SMTP Mail";
        FileManagement: Codeunit "File Management";
        PayrollPeriod: Code[20];
        PermittedRange: Text[250];
        EmployeeNoFilter: Text[30];
        Subject: Text[250];
        Body: Text[250];
        FileNameServer: Text;
        PayAdviceTitle: Text[80];
        PayAdviceTYPE: Text[50];
        IncludeAlreadySentMail: Boolean;
        ShowHistorical: Boolean;
        Text001: label 'Dear %1, Attached is your Salary payslip for the month. If you have any problem viewing this document or questions thereon, do not hesitate to contact the undersigned..Thanks, %2';
        Text002: label 'PAYSLIP.html';
        Text003: label 'PAY ADVICE FOR';
        IsClosedPeriod: Boolean;
        PayrollType: Option SALARY,REIMBURSABLE,BOTH;


    procedure SkipRecord(): Boolean
    var
        PayslipLine: Record "Payroll-Payslip Line";
        ClosedPayslipLine: Record "Closed Payroll-Payslip Line";
    begin
        if not("Payroll-Period".Closed) then begin
          PayslipLine.SetRange("Payroll Period","Payroll-Period"."Period Code");
          PayslipLine.SetRange("Employee No.",Employee."No.");
          if PayslipLine.FindFirst then
            exit(false)
          else
            exit(true);
        end;
        if "Payroll-Period".Closed then begin
          ClosedPayslipLine.SetRange("Payroll Period","Payroll-Period"."Period Code");
          ClosedPayslipLine.SetRange("Employee No.",Employee."No.");
          if ClosedPayslipLine.FindFirst then
            exit(false)
          else
            exit(true);
        end;
    end;


    procedure GetMonthsSentMail(): Integer
    var
        PayslipHeader2: Record "Payroll-Payslip Header";
        ClosedPayslipHeader: Record "Closed Payroll-Payslip Header";
    begin
        if not("Payroll-Period".Closed) then
          if PayslipHeader2.Get("Payroll-Period"."Period Code",Employee."No.") then
            exit(PayslipHeader2."No. of Month End E-mail Sent");

        if "Payroll-Period".Closed then
          if ClosedPayslipHeader.Get("Payroll-Period"."Period Code",Employee."No.") then
            exit(ClosedPayslipHeader."No. of Month End E-mail Sent")
    end;
}

