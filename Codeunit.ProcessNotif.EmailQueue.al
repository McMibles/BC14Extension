Codeunit 52092268 "Process Notif. Email Queue"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    var
        ServEmailQueue: Record "Service Email Queue";
        ServEmailQueue2: Record "Service Email Queue";
        ServMailMgt: Codeunit ServMailManagement;
        RecRef: RecordRef;
        Success: Boolean;
    begin
        if RecRef.Get("Record ID to Process") then begin
          RecRef.SetTable(ServEmailQueue);
          if not ServEmailQueue.Find then
            exit;
          ServEmailQueue.SetRecfilter;
        end else begin
          ServEmailQueue.Reset;
          ServEmailQueue.SetCurrentkey(Status,"Sending Date","Document Type","Document No.");
          ServEmailQueue.SetRange(Status,ServEmailQueue.Status::" ");
        end;
        ServEmailQueue.LockTable;
        if ServEmailQueue.FindSet then
          repeat
            Clear(ServMailMgt);
            ServMailMgt.Run(ServEmailQueue);
            ServEmailQueue2.Get(ServEmailQueue."Entry No.");
            ServEmailQueue2.Status := ServEmailQueue2.Status::Processed;
            ServEmailQueue2.Modify;
            Commit;
            Sleep(200);
          until ServEmailQueue.Next = 0;
    end;
}

