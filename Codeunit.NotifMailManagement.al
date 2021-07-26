Codeunit 52092127 NotifMailManagement
{
    TableNo = "Notification Email Queue";

    trigger OnRun()
    var
        TempEmailItem: Record "Email Item" temporary;
        MailManagement: Codeunit "Mail Management";
    begin
        if not MailManagement.IsEnabled then
          exit;

        InitTempEmailItem(TempEmailItem,Rec);

        MailManagement.SetHideMailDialog(true);
        MailManagement.SetHideSMTPError(false);
        if not MailManagement.Send(TempEmailItem) then
          Error(EmailSendErr,"From Name","Send to");
    end;

    var
        EmailSendErr: label 'The email to %1 with subject %2 has not been sent.', Comment='%1 - To address, %2 - Email subject';

    local procedure InitTempEmailItem(var TempEmailItem: Record "Email Item" temporary;NotifEmailQueue: Record "Notification Email Queue")
    begin
        with NotifEmailQueue do begin
          TempEmailItem.Initialize;
          TempEmailItem."Attachment File Path" := "Attachment File Path";
          //TempEmailItem.SetBodyText("Send CC");
          TempEmailItem."Send to" := "Send to";
          TempEmailItem."Send CC" := "Send CC";
          TempEmailItem.Subject := Subject;
          TempEmailItem.Insert;
        end;
    end;
}

