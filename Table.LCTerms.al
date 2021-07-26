Table 52092362 "LC Terms"
{
    Caption = 'LC Terms';

    fields
    {
        field(1;"LC No.";Code[20])
        {
            Caption = 'LC No.';
        }
        field(2;Description;Text[30])
        {
            Caption = 'Description';
        }
        field(3;"Attachment No.";Integer)
        {
            Caption = 'Attachment No.';
        }
        field(4;"Line No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'Line No.';
        }
        field(5;Date;Date)
        {
            Caption = 'Date';
        }
        field(6;Released;Boolean)
        {
            Caption = 'Released';
        }
    }

    keys
    {
        key(Key1;"LC No.","Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text000: label 'You have canceled the create process.';
        Text001: label 'Replace existing attachment?';
        Text002: label 'You have canceled the import process.';


    procedure ImportAttachment()
    var
        Attachment: Record Attachment;
        TempAttachment: Record Attachment temporary;
        AttachmentManagement: Codeunit AttachmentManagement;
    begin
        if "Attachment No." <> 0 then begin
          if Attachment.Get("Attachment No.") then
            Attachment.TestField("Read Only",false);
          if not Confirm(Text001,false) then
            exit;
        end;

        Clear(TempAttachment);
        if TempAttachment.ImportAttachmentFromClientFile('',true,true) then begin
          if "Attachment No." = 0 then
            Attachment.Get(AttachmentManagement.InsertAttachment(0))
          else
            Attachment.Get("Attachment No.");
          TempAttachment."No." := Attachment."No.";
          TempAttachment."Storage Pointer" := Attachment."Storage Pointer";
          TempAttachment.WizSaveAttachment;
          Attachment."Storage Type" := TempAttachment."Storage Type";
          Attachment."Storage Pointer" := TempAttachment."Storage Pointer";
          Attachment."Attachment File" := TempAttachment."Attachment File";
          Attachment."File Extension" := TempAttachment."File Extension";
          Attachment.Modify;
          "Attachment No." := Attachment."No.";
          Modify;
        end else
          Error(Text002);
    end;


    procedure OpenAttachment()
    var
        Attachment: Record Attachment;
    begin
        if "Attachment No." = 0 then
          exit;
        Attachment.Get("Attachment No.");
        Attachment.OpenAttachment("LC No." + ' ' + Description,false,'');
    end;


    procedure CreateAttachment()
    var
        Attachment: Record Attachment;
        WordManagement: Codeunit WordManagement;
        NewAttachNo: Integer;
    begin
        if "Attachment No." <> 0 then begin
          if Attachment.Get("Attachment No.") then
            Attachment.TestField("Read Only",false);
          if not Confirm(Text001,false) then
            exit;
        end;

        if WordManagement.IsWordDocumentExtension('DOC') then;

        NewAttachNo := WordManagement.CreateWordAttachment("LC No." + ' ' + Description,'');
        if NewAttachNo <> 0 then begin
          if "Attachment No." <> 0 then
            RemoveAttachment(false);
          "Attachment No." := NewAttachNo;
          Modify;
        end else
          Error(Text000);
    end;


    procedure ExportAttachment()
    var
        Attachment: Record Attachment;
        FileName: Text[1024];
    begin
        if Attachment.Get("Attachment No.") then
          Attachment.ExportAttachmentToClientFile(FileName);
    end;


    procedure RemoveAttachment(Prompt: Boolean)
    var
        Attachment: Record Attachment;
    begin
        if Attachment.Get("Attachment No.") then
          if Attachment.RemoveAttachment(Prompt) then begin
            "Attachment No." := 0;
            Modify;
          end;
    end;
}

