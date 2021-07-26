Report 52092366 "Clear Rolled Over Leave"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Leave Schedule Header";"Leave Schedule Header")
        {
            DataItemTableView = sorting("Year No.","Employee No.","Absence Code") where(Closed=const(false));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("No. of Days B/F","No. of Days Utilised","No. of Days Subtracted","No. of Approved Committed Days");
                if "No. of Days B/F" = 0 then
                  CurrReport.Skip;

                if "No. of Days B/F" > ("No. of Days Utilised" + "No. of Days Subtracted" + "No. of Approved Committed Days") then begin
                  Window.Update(1,Text001);
                  ClearRolledlOverBalance("No. of Days B/F" - ("No. of Days Utilised" + "No. of Days Subtracted" + "No. of Approved Committed Days"));
                  CheckDeletePendingLeave;
                  CheckDelAffectedSchLine;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm(ConfirmText) then begin
                  Message(ConfirmMsg);
                  CurrReport.Quit;
                end;

                HRSetup.Get;
                CauseofAbsence.Get(HRSetup."Annual Leave Code");
                SetRange("Absence Code",HRSetup."Annual Leave Code");
                SetFilter("Year Filter",'..%1',Date2dmy(Today,3) - 1);

                Window.Open('Clearing Rolled Over Leave');

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(YearNo;YearNo)
                {
                    ApplicationArea = Basic;
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if YearNo = 0 then
              YearNo := Date2dmy(Today,3);
        end;
    }

    labels
    {
    }

    var
        CauseofAbsence: Record "Cause of Absence";
        Employee: Record Employee;
        HRSetup: Record "Human Resources Setup";
        YearNo: Integer;
        GlobalSender: Text[80];
        Body: Text[500];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
        LeaveMgt: Codeunit LeaveManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecRef: RecordRef;
        ApprovalsMgmt: Codeunit "Approvals Hook";
        Window: Dialog;
        Text001: label 'You are hereby advised to reschedule your leave because the balance of your leave for the previous year has been removed. You are also advised to reapply for your annual leave application that is pending approval';
        ConfirmText: label 'Do you want to clear rolled over leave?';
        ConfirmMsg: label 'Action Cancelled';

    local procedure ClearRolledlOverBalance(NoOfDays: Decimal)
    var
        LeaveApplication: Record "Leave Application";
    begin
        with "Leave Schedule Header" do begin
          LeaveApplication.Init;
          LeaveApplication."Document No." := NoSeriesMgt.GetNextNo(HRSetup."Employee Absence No.",WorkDate,true);
          LeaveApplication."Employee No." := "Employee No.";
          LeaveApplication."Employee Name" := "Employee Name";
          //LeaveApplication."Employee Category" := Employee."Employee Category";
          LeaveApplication."From Date" := WorkDate;
          LeaveApplication."Cause of Absence Code" := "Absence Code";
          LeaveApplication."Year No." := "Year No.";
          LeaveApplication."Entry Type" := LeaveApplication."entry type"::"Negative Adjustment";
          LeaveApplication.Description := 'Rolled Over Leave Cancellation';
          LeaveApplication.Validate("Unit of Measure Code",CauseofAbsence."Unit of Measure Code");
          LeaveApplication.Validate(Quantity,NoOfDays);
          LeaveApplication.Insert;
          LeaveMgt.PostLeave(LeaveApplication);
        end;
    end;

    local procedure CheckDeletePendingLeave()
    var
        LeaveApplication: Record "Leave Application";
    begin
        with "Leave Schedule Header" do begin
          LeaveApplication.SetRange("Year No.","Year No.");
          LeaveApplication.SetRange("Employee No.","Employee No.");
          LeaveApplication.SetRange("Cause of Absence Code","Absence Code");
          LeaveApplication.SetFilter(Status,'%1|%2',LeaveApplication.Status::Open,LeaveApplication.Status::"Pending Approval");
          if LeaveApplication.FindFirst then begin
            case LeaveApplication.Status of
              LeaveApplication.Status::"Pending Approval": begin
                RecRef.GetTable(LeaveApplication);
                ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
              end;
            end;
          LeaveApplication.DeleteAll(true);
          end;
        end;
    end;

    local procedure CheckDelAffectedSchLine()
    var
        LeaveScheduleLine: Record "Leave Schedule Line";
    begin
        with "Leave Schedule Header" do begin
          LeaveScheduleLine.SetRange("Year No.","Year No.");
          LeaveScheduleLine.SetRange("Employee No.","Employee No.");
          LeaveScheduleLine.SetRange("Absence Code","Absence Code");
          LeaveScheduleLine.SetRange("No. of Days Taken",0);
          LeaveScheduleLine.ModifyAll("No. of Days Scheduled",0);
          LeaveScheduleLine.ModifyAll("Outstanding No. of Days",0)
        end;
    end;
}

