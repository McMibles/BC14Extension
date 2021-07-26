Codeunit 52092128 "Process Notif Email Queue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        NotifEmailQueue: Record "Notification Email Queue";
        NotifEmailQueue2: Record "Notification Email Queue";
        NotifMailMgt: Codeunit NotifMailManagement;
    begin
        NotifEmailQueue.Reset;
        NotifEmailQueue.SetCurrentkey(Status);
        NotifEmailQueue.SetRange(Status,NotifEmailQueue.Status::" ");
        if NotifEmailQueue.Find('-') then
          repeat
            Clear(NotifMailMgt);
            if NotifMailMgt.Run(NotifEmailQueue) then begin
              NotifEmailQueue2.Get(NotifEmailQueue."Entry No.");
              NotifEmailQueue2.Status := NotifEmailQueue2.Status::Processed;
              NotifEmailQueue2.Modify;
            end else begin
              NotifEmailQueue2.Get(NotifEmailQueue."Entry No.");
              NotifEmailQueue2.Status := NotifEmailQueue2.Status::Error;
              NotifEmailQueue2.Modify;
            end;
            Commit;
            Sleep(200);
          until NotifEmailQueue.Next = 0;
    end;

    local procedure CreateNotifQueue()
    begin
    end;
}

