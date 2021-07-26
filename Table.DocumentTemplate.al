Table 52092216 "Document Template"
{
    DrillDownPageID = "Document Templates List";
    LookupPageID = "Document Templates List";

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Contents; Blob)
        {
        }
        field(4; OleClassname; Code[30])
        {
        }
        field(5; Mailmerge; Option)
        {
            OptionMembers = " ",Employee,Applicant,Training,Appraisal,Recruitment,Leave,Scholarship,"Promotion/Transfer",Absence;
        }
        field(6; "Storage Pointer"; Text[250])
        {
        }
        field(7; "Term. Employees"; Boolean)
        {
        }
        field(9; "MailMerge Table"; Integer)
        {
            TableRelation = Object.ID where(Type = const(Table));
        }
        field(10; "File Extension"; Text[250])
        {
        }
        field(11; "Storage Type"; Option)
        {
            OptionCaption = 'Embedded,Disk File';
            OptionMembers = Embedded,"Disk File";
        }
        field(12; "Read Only"; Boolean)
        {
        }
        field(13; "Last Time Modified"; Time)
        {
        }
        field(14; "Correspondence Type"; Option)
        {
            OptionCaption = 'Hard Copy,E-Mail,Fax';
            OptionMembers = "Hard Copy","E-Mail",Fax;
        }
        field(15; "File Name"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        TempBlob: Record TempBlob;
        HRSetup: Record "Human Resources Setup";
        Text002: label 'The attachment is empty.';
        Text003: label 'Attachment is already in use on this machine.';
        Text004: label 'When you have saved your document, click Yes to import the document.';
        Text005: label 'Export Attachment';
        Text006: label 'Import Attachment';
        Text007: label 'All Files (*.*)|*.*';
        Text008: label 'Error during copying file.';
        Text009: label 'Do you want to remove %1?';
        Text010: label 'External file could not be removed.';
        Text012: label '\Doc';
        Text013: label 'You can only print Microsoft Word documents.';
        Text014: label 'You can only fax Microsoft Word documents.';
        Text015: label 'The e-mail has been deleted.';
        Text016: label 'When you have finished working with a document, you should delete the associated temporary file. Please note that this will not delete the document.\\Do you want to delete the temporary file?';
        Text017: label 'msg';
        Text018: label '*.msg|*.msg';
        Text019: label 'Open';
        FileMgt: Codeunit "File Management";


    procedure CreateTemplate(Caption: Text[260])
    var
        DocumentManagement: Codeunit DocumentManagement;
    begin
        //DocumentManagement.CreateWordAttachment(Caption,Rec);
    end;


    procedure ExportTemplatetoClientFile(var ExportToFile: Text[1024]): Boolean
    var
        FileFilter: Text;
        ServerFileName: Text;
        Path: Text;
    begin
        HRSetup.Get;
        if HRSetup."Document Temp. Storage Type" = HRSetup."document temp. storage type"::"Disk File" then
            HRSetup.TestField("Document Temp. Storage Path");

        ServerFileName := FileMgt.ServerTempFileName("File Extension");
        ExportTemplateToServerFile(ServerFileName);

        Path := FileMgt.Magicpath;
        if ExportToFile = '' then begin
            ExportToFile := FileMgt.GetFileName(FileMgt.ClientTempFileName("File Extension"));
            Path := '';
        end;

        FileFilter := UpperCase("File Extension") + ' (*.' + "File Extension" + ')|*.' + "File Extension";
        exit(Download(ServerFileName, Text005, Path, FileFilter, ExportToFile));
    end;


    procedure ExportTemplateToServerFile(var ExportToFile: Text): Boolean
    begin
        // This function assumes that CALCFIELDS on the attachment field has been called before
        HRSetup.Get;
        if HRSetup."Document Temp. Storage Type" = HRSetup."document temp. storage type"::"Disk File" then
            HRSetup.TestField("Document Temp. Storage Path");
        case "Storage Type" of
            "storage type"::Embedded:
                begin
                    CalcFields(Contents);
                    if Contents.Hasvalue then begin
                        TempBlob.Blob := Contents;
                        if ExportToFile = '' then
                            ExportToFile := FileMgt.ServerTempFileName("File Extension");
                        FileMgt.BLOBExportToServerFile(TempBlob, ExportToFile); // export BLOB to file on server (UNC location also)
                        exit(true);
                    end;
                    exit(false);
                end;
            "storage type"::"Disk File":
                begin
                    if ExportToFile = '' then
                        ExportToFile := TemporaryPath + FileMgt.GetFileName(ConstDiskFileName);
                    FileMgt.CopyServerFile(ConstDiskFileName, ExportToFile, false); // Copy from server location to another location (UNC location also)
                    exit(true);
                end;
        end;

        exit(false);
    end;


    procedure ImportTemplateFromClientFile(ImportFromFile: Text; IsTemporary: Boolean; IsInherited: Boolean): Boolean
    var
        FileName: Text;
        ServerFileName: Text;
        NewAttachmentNo: Integer;
    begin
        if IsTemporary then
            exit(ImportTemporaryTemplateFromClientFile(ImportFromFile));

        TestField("Read Only", false);
        HRSetup.Get;
        if HRSetup."Document Temp. Storage Type" = HRSetup."document temp. storage type"::"Disk File" then
            HRSetup.TestField("Document Temp. Storage Path");

        // passing to UPLOAD function when only server path is specified, not ALSO the file name,
        // then function updates the server file path with the actual client name
        ServerFileName := TemporaryPath;
        FileName := ImportFromFile;
        if not Upload(Text006, '', Text007, FileName, ServerFileName) then
            Error(Text008, GetLastErrorText);

        exit(ImportTemplateFromServerFile(ServerFileName, false, true));
    end;

    local procedure ImportTemporaryTemplateFromClientFile(ImportFromFile: Text): Boolean
    var
        FileName: Text;
    begin
        FileName := FileMgt.BLOBImport(TempBlob, ImportFromFile);

        if FileName <> '' then begin
            Contents := TempBlob.Blob;
            "Storage Type" := "storage type"::Embedded;
            "Storage Pointer" := '';
            "File Extension" := CopyStr(UpperCase(FileMgt.GetExtension(FileName)), 1, 250);
            exit(true);
        end;

        exit(false);
    end;


    procedure ImportTemplateFromServerFile(ImportFromFile: Text; IsTemporary: Boolean; Overwrite: Boolean): Boolean
    begin
        if IsTemporary then begin
            ImportTemporaryTemplateFromServerFile(ImportFromFile);
            exit(true);
        end;

        if not Overwrite then
            TestField("Read Only", false);

        HRSetup.Get;
        if HRSetup."Document Temp. Storage Type" = HRSetup."document temp. storage type"::"Disk File" then
            HRSetup.TestField("Document Temp. Storage Path");


        case HRSetup."Document Temp. Storage Type" of
            HRSetup."document temp. storage type"::Embedded:
                begin
                    Clear(TempBlob);
                    FileMgt.BLOBImportFromServerFile(TempBlob, ImportFromFile); // Copy from file on server (UNC location also)

                    Contents := TempBlob.Blob;
                    "Storage Type" := "storage type"::Embedded;
                    "Storage Pointer" := '';
                    "File Extension" := CopyStr(FileMgt.GetExtension(ImportFromFile), 1, 250);
                    Modify(true);
                    exit(true);
                end;
            "storage type"::"Disk File":
                begin
                    "Storage Type" := "storage type"::"Disk File";
                    "Storage Pointer" := HRSetup."Document Temp. Storage Path";
                    "File Extension" := CopyStr(FileMgt.GetExtension(ImportFromFile), 1, 250);
                    FileMgt.CopyServerFile(ImportFromFile, ConstDiskFileName, Overwrite); // Copy from UNC location to another UNC location
                    Modify(true);
                    exit(true);
                end;
        end;

        exit(false);
    end;

    local procedure ImportTemporaryTemplateFromServerFile(ImportFromFile: Text)
    begin
        FileMgt.BLOBImportFromServerFile(TempBlob, ImportFromFile);
        Contents := TempBlob.Blob;
        "Storage Type" := "storage type"::Embedded;
        "Storage Pointer" := '';
        "File Extension" := CopyStr(UpperCase(FileMgt.GetExtension(ImportFromFile)), 1, 250);
    end;


    procedure RemoveTemplate(Prompt: Boolean) DeleteOK: Boolean
    var
        DeleteYesNo: Boolean;
    begin
        DeleteOK := false;
        DeleteYesNo := true;
        if Prompt then
            if not Confirm(
              Text009, false, TableCaption)
            then
                DeleteYesNo := false;

        if DeleteYesNo then begin
            if "Storage Type" = "storage type"::"Disk File" then begin
                if not DeleteFile(ConstDiskFileName) then
                    Message(Text010);
            end;
            Rec.Delete(true);
            DeleteOK := true;
        end;
    end;


    procedure OpenAttachment(Caption: Text[260]; IsTemporary: Boolean)
    var
        WordManagement: Codeunit DocumentManagement;
        AttachmentManagement: Codeunit AttachmentManagement;
        FileName: Text[260];
    begin
        if "Storage Type" = "storage type"::Embedded then begin
            CalcFields(Contents);
            if not Contents.Hasvalue then
                Error(Text002);
        end;

        FileName := ConstFilename;
        if not DeleteFile(FileName) then
            Error(Text003);
        ExportTemplatetoClientFile(FileName);
        if WordManagement.IsWordDocumentExtension("File Extension") then begin
            WordManagement.OpenWordAttachment(Rec, FileName, Caption, IsTemporary);
        end else begin
            Hyperlink(FileName);
            if not "Read Only" then begin
                if Confirm(Text004, true) then
                    ImportTemplateFromClientFile(FileName, IsTemporary, false);
                DeleteFile(FileName);
            end else
                if Confirm(Text016, true) then
                    DeleteFile(FileName);
        end;
    end;


    procedure ShowAttachment(WordCaption: Text[260]; IsTemporary: Boolean)
    var
        WordManagement: Codeunit DocumentManagement;
        FileName: Text;
    begin
        if "Storage Type" = "storage type"::Embedded then
            CalcFields(Contents);

        if WordManagement.IsWordDocumentExtension("File Extension") then
            WordManagement.ShowMergedDocument(Rec, WordCaption, IsTemporary)
        else begin
            FileName := ConstFilename;
            ExportTemplatetoClientFile(FileName);
            Hyperlink(FileName);
            if not "Read Only" then begin
                if Confirm(Text004, true) then
                    ImportTemplateFromClientFile(FileName, IsTemporary, false);
                DeleteFile(FileName);
            end else
                if Confirm(Text016, true) then
                    DeleteFile(FileName);
        end;
    end;


    procedure ConstDiskFileName() DiskFileName: Text[260]
    begin
        DiskFileName := "Storage Pointer" + '\' + Format(Code) + '.';
    end;


    procedure ConstFilename() FileName: Text[260]
    var
        RBAutoMgt: Codeunit "File Management";
        I: Integer;
        DocNo: Text[30];
        p: Integer;
    begin
        FileName := FileMgt.ClientTempFileName("File Extension");
    end;


    procedure DeleteFile(FileName: Text[260]): Boolean
    var
        I: Integer;
    begin
        if FileName = '' then
            exit(false);

        if not FileMgt.ClientFileExists(FileName) then
            exit(true);

        repeat
            Sleep(250);
            I := I + 1;
        until FileMgt.DeleteClientFile(FileName) or (I = 25);
        exit(not FileMgt.ClientFileExists(FileName));
    end;


    procedure UseComServer(FileExtension: Text[250]; RequireAutomation: Boolean): Boolean
    var
        VersionNo: Decimal;
        DecimalSymbol: Text[1];
    begin
        if (UpperCase(FileExtension) <> 'DOC') and
           (UpperCase(FileExtension) <> 'DOCX')
        then
            exit(false);

        // 5.1 do not support Automation Server table. We assume that MS Word is installed and has a valid version.
        exit(true);
    end;
}

