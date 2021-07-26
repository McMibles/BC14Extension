Codeunit 52092188 DocumentManagement
{

    //     trigger OnRun()
    //     begin
    //     end;

    //     var
    //         EmployeeQuery: Record "Employee Query Entry";
    //         EmployeeRequisition: Record "Employee Requisition";
    //         EmployeeCategory: Record "Employee Category";
    //         SalaryGroup: Record "Payroll-Employee Group Line";
    //         PayrollSetup: Record "Payroll-Setup";
    //         HRSetup: Record "Human Resources Setup";
    //         TrainingAttendance: Record "Training Attendance";
    //         InterviewHeader: Record "Interview Header";
    //         InterviewDetail: Record "Interview Line";
    //         Interviewer: Record Interviewer;
    //         Employee: Record Employee;
    //         Employee2: Record Employee;
    //         Applicant: Record Applicant;
    //         PromotionTransfer: Record "Employee Update Line";
    //         EmployeeLeave: Record "Leave Application";
    //         EmployeeExit: Record "Employee Exit";
    //         Venue: Record "Training Facility";
    //         FeedbackDate: Date;
    //         Window: Dialog;
    //         //[RunOnClient]
    //        // WordHelper: dotnet WordHelper;
    //         AttachmentManagement: Codeunit AttachmentManagement;
    //         DimensionMgt: Codeunit "Dimension Hook";
    //         MergeSourceBufferFileName: Text[260];
    //         MergeSourceBufferFile: File;
    //         RBAutoMgt: Codeunit "File Management";
    //         Text003: label 'Merging Microsoft Word Documents...\\';
    //         Text004: label 'Preparing';
    //         Text005: label 'Program status';
    //         Text006: label 'Preparing Merge...';
    //         Text007: label 'Waiting for print job...';
    //         Text008: label 'Transferring %1 data to Microsoft Word...';
    //         Text010: label '%1 %2 must have %3 DOC.';
    //         Text011: label 'Template file error';
    //         Text012: label 'Creating merge source...';
    //         Text013: label 'Microsoft Word is opening merge source...';
    //         Text014: label 'Merging %1 in Microsoft Word...';
    //         Text015: label 'FaxMailTo';
    //         Text017: label 'The merge source file is locked by another process.\';
    //         Text018: label 'Please try again later.';
    //         Text019: label ' Mail Address';
    //         Text020: label 'Document ';
    //         Text021: label 'Import attachment ';
    //         Text022: label 'Delete %1?';
    //         Text023: label 'Another user has modified the record for this %1\after you retrieved it from the database.\\';
    //         Text025: label 'Enter the changes again in the updated document.';
    //         Text027: label '\Doc';
    //         Text029: label '\MergeSource';
    //         Text030: label 'Formal Salutation';
    //         Text031: label 'Informal Salutation';
    //         Text032: label '*.htm|*.htm';
    //         Text033: label '*.doc|*.doc';
    //         Text034: label 'Download data source file';
    //         Text035: label 'Download main mail merge file';
    //         Text036: label 'Save main mail merge file to the database';
    //         Text037: label 'Default.doc';
    //         Text038: label 'You are accessing the Mail Merge functionality that allows you to create and edit messages. To continue working, download the template and data files.';
    //         Text039: label 'Do you want to upload the modified template file to the server?';
    //         FileMgt: Codeunit "File Management";
    //         CorrespondenceType: Option "Hard Copy","E-Mail",Fax;
    //         Text060: label 'Document selected cannot be used with this type of record.';


    //     procedure CreateWordAttachment(WordCaption: Text[260];var Template: Record "Document Template")
    //     var
    //         AttachmentManagement: Codeunit AttachmentManagement;
    //         [RunOnClient]
    //         WordApplication: dotnet ApplicationClass;
    //         [RunOnClient]
    //         WordDocument: dotnet Document;
    //         [RunOnClient]
    //         WordMergefile: dotnet MergeHandler;
    //         FileName: Text;
    //         MergeFileName: Text;
    //         ParamInt: Integer;
    //     begin
    //         WordMergefile := WordMergefile.MergeHandler;

    //         MergeFileName := FileMgt.ClientTempFileName('HTM');
    //         CreateHeader2(WordMergefile,true,MergeFileName,Template."MailMerge Table"); // Header without data

    //         WordApplication := WordApplication.ApplicationClass;
    //         Template."File Extension" := GetWordDocExt(WordApplication.Version);
    //         WordDocument := WordHelper.AddDocument(WordApplication);
    //         WordDocument.MailMerge.MainDocumentType := 0; // 0 = wdFormLetters
    //         ParamInt := 7; // 7 = HTML
    //         WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeFileName,ParamInt);

    //         FileName := Template.ConstFilename;
    //         WordHelper.CallSaveAs(WordDocument,FileName);
    //         if WordHandler(WordDocument,Template,WordCaption,false,FileName,false) then;

    //         Clear(WordMergefile);
    //         Clear(WordDocument);
    //         WordHelper.CallQuit(WordApplication,false);
    //         Clear(WordApplication);

    //         DeleteFile(MergeFileName);
    //     end;


    procedure OpenWordAttachment(var Template: Record "Document Template"; FileName: Text[260]; Caption: Text[260]; IsTemporary: Boolean)
    var
    //         [RunOnClient]
    //         WordApplication: dotnet ApplicationClass;
    //         [RunOnClient]
    //         WordDocument: dotnet Document;
    //         [RunOnClient]
    //         WordMergefile: dotnet MergeHandler;
    //         ParamFalse: Boolean;
    //         MergeFileName: Text[260];
    //         ParamInt: Integer;
    begin
        //         WordMergefile := WordMergefile.MergeHandler;

        //         MergeFileName := FileMgt.ClientTempFileName('HTM');
        //         CreateHeader2(WordMergefile,true,MergeFileName,Template."MailMerge Table");

        //         WordApplication := WordApplication.ApplicationClass;

        //         WordDocument := WordHelper.CallOpen(WordApplication,FileName,false,Template."Read Only");

        //         // Handle Word documents without mergefields
        //         if DocContainMergefields(Template) then
        //           if IsNull(WordDocument.MailMerge.MainDocumentType) then begin
        //             WordDocument.MailMerge.MainDocumentType := 0; // 0 = wdFormLetters
        //             WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeFileName,ParamInt);
        //           end;

        //         if WordDocument.MailMerge.Fields.Count > 0 then begin
        //           ParamInt := 7; // 7 = HTML
        //           WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeFileName,ParamInt);
        //         end;

        //         WordHandler(WordDocument,Template,Caption,IsTemporary,FileName,false);

        //         Clear(WordMergefile);
        //         Clear(WordDocument);
        //         WordHelper.CallQuit(WordApplication,false);
        //         Clear(WordApplication);

        //         DeleteFile(MergeFileName);
    end;


    //     procedure Send(var Template: Record "Document Template";var RecdRef: RecordRef)
    //     var
    //         RBAutoMgt: Codeunit "File Management";
    //         Mail: Codeunit Mail;
    //         FileName: Text[260];
    //         Window: Dialog;
    //         Text110: label 'Send attachments...\\';
    //         Text111: label 'Preparing';
    //         Text112: label 'Deliver misc.';
    //         Text115: label '\Attachment.%1';
    //         UseAutomation: Boolean;
    //     begin
    //         Window.Open(
    //           Text110 +
    //           '#1############ @2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
    //           '#3############ @4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    //         Window.Update(1,Text111);
    //         Window.Update(3,Text112);

    //         if RecdRef.Number <> Template."MailMerge Table" then
    //           Error(Text060);

    //         if Template.UseComServer(Template."File Extension",true) then
    //           // MS Word merge
    //           Merge(Template);
    //         /*ELSE IF CorrespondenceType = CorrespondenceType::"E-Mail" THEN BEGIN
    //           // Deliver other types
    //           Template.TESTFIELD("File Extension");
    //           FileName := RBAutoMgt.EnvironFileName(Text115,Template."File Extension");
    //           Template.ExportTemplate(FileName);
    //           Mail.NewMessage('t.olaniyan@gems-consult.com','','TEST','',FileName,FALSE);
    //           Template.DeleteFile(FileName);
    //         END;*/
    //         Window.Close;

    //     end;


    //     procedure Merge(var Template: Record "Document Template" temporary)
    //     var
    //         [RunOnClient]
    //         WordApplication: dotnet ApplicationClass;
    //         LastAttachmentNo: Integer;
    //         LastCorrType: Integer;
    //         LastSubject: Text[50];
    //         LastSendWordDocsAsAttmt: Boolean;
    //         LineCount: Integer;
    //         NoOfRecords: Integer;
    //         WordHided: Boolean;
    //         Param: Boolean;
    //         FirstRecord: Boolean;
    //     begin
    //         Window.Open(
    //           Text003 +
    //           '#1############ @2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\' +
    //           '#3############ @4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\\' +
    //           '#5############ #6################################');

    //         Window.Update(1,Text004);
    //         Window.Update(5,Text005);

    //         WordApplication := WordApplication.ApplicationClass;
    //         if WordApplication.Documents.Count > 0 then begin
    //           WordApplication.Visible := false;
    //           WordHided := true;
    //         end;


    //         ExecuteMerge(WordApplication,Template);
    //         ImportMergeSourceFile(Template.Code);

    //         if WordHided then
    //           WordApplication.Visible := true
    //         else begin
    //           // Wait for print job to finish
    //           if WordApplication.BackgroundPrintingStatus <> 0 then
    //             repeat
    //               Window.Update(6,Text007);
    //               Sleep(500);
    //             until WordApplication.BackgroundPrintingStatus = 0;

    //           Param := false;
    //           WordHelper.CallQuit(WordApplication,Param);
    //         end;

    //         Clear(WordApplication);
    //         Window.Close;
    //     end;

    //     local procedure ExecuteMerge(var WordApplication: dotnet ApplicationClass;var Template: Record "Document Template")
    //     var
    //         Attachment: Record Attachment;
    //         CompanyInfo: Record "Company Information";
    //         [RunOnClient]
    //         WordDocument: dotnet Document;
    //         [RunOnClient]
    //         WordInlineShape: dotnet InlineShape;
    //         [RunOnClient]
    //         WordMergefile: dotnet MergeHandler;
    //         [RunOnClient]
    //         WordOLEFormat: dotnet OLEFormat;
    //         [RunOnClient]
    //         WordLinkFormat: dotnet LinkFormat;
    //         [RunOnClient]
    //         WordShape: dotnet Shape;
    //         FormatAddr: Codeunit "Format Address";
    //         MergeClientFileName: Text;
    //         MainFileName: Text;
    //         NoOfRecords: Integer;
    //         ParamBln: Boolean;
    //         ParamInt: Integer;
    //         ContAddr: array [8] of Text[50];
    //         ContAddr2: array [8] of Text[50];
    //         MultiAddress: array [2] of Text[260];
    //         i: Integer;
    //         Row: Integer;
    //         MergeFile: File;
    //         ShapesIndex: Integer;
    //         HeaderIsReady: Boolean;
    //     begin
    //         Window.Update(
    //           6,StrSubstNo(Text008,
    //           Format(CorrespondenceType)));

    //         MainFileName := FileMgt.ServerTempFileName('DOC');
    //         if not IsWordDocumentExtension(Template."File Extension") then
    //           Error(StrSubstNo(Text010,Template.TableCaption,Template.Code,Template.FieldCaption("File Extension")));

    //         if not Template.ExportTemplatetoClientFile(MainFileName) then
    //           Error(Text011);

    //         Window.Update(6,Text012);
    //         Template.CalcFields(Contents);
    //         /*IF Template.Contents.HASVALUE THEN BEGIN
    //           MergeFile.WRITEMODE := TRUE;
    //           MergeFile.TEXTMODE := TRUE;
    //           MergeFileName := RBAutoMgt.ServerTempFileName(Text029,'HTM');
    //           MergeFile.CREATE(MergeFileName);
    //           CreateILEMergeSource(MergeFile,Template,1,
    //             HeaderIsReady,CorrespondenceType);
    //           MergeFile.WRITE('</table>');
    //           MergeFile.WRITE('</body>');
    //           MergeFile.WRITE('</html>');
    //           MergeFile.CLOSE;
    //           MergeFileName := RBAutoMgt.DownloadTempFile(MergeFileName);
    //         END ELSE BEGIN*/
    //           MergeClientFileName := FileMgt.ClientTempFileName('HTM');
    //           WordMergefile := WordMergefile.MergeHandler;
    //           CreateHeader2(WordMergefile,false,MergeClientFileName,Template."MailMerge Table");
    //           with WordMergefile do begin
    //             case Template."MailMerge Table" of
    //               Database::"Employee Query Entry":begin
    //                 if EmployeeQuery.FindFirst then
    //                   repeat
    //                     Employee2.Get(EmployeeQuery."Employee No.");
    //                     AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Employee2.FullName);
    //                     AddField(Employee2."First Name");
    //                     AddField(Format(EmployeeQuery."Date of Query",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format (EmployeeQuery."Date of Violation",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format(EmployeeQuery."Response Due Date",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format(EmployeeQuery.Offence));
    //                     AddField(DimensionMgt.ReturnDimName(1,EmployeeQuery."Global Dimension 1 Code"));
    //                     AddField(DimensionMgt.ReturnDimName(2,EmployeeQuery."Global Dimension 2 Code"));
    //                     AddField(Format(EmployeeQuery.Action));
    //                     AddField(Format(EmployeeQuery."Effective Date of Action",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format(EmployeeQuery."Suspension Duration"));
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                       AddField(Employee2."E-Mail")
    //                     else
    //                       AddField('');
    //                     WriteLine;
    //                   until EmployeeQuery.Next = 0;
    //                   WordMergefile.CloseMergeFile;
    //               end;
    //               Database::"Interview Line":begin
    //                 PayrollSetup.Get;
    //                 if InterviewDetail.FindFirst then
    //                   repeat
    //                     Applicant.Get(InterviewDetail."Applicant No.");
    //                     InterviewHeader.Get(InterviewDetail."Interview No.");
    //                     EmployeeRequisition.Get(InterviewHeader."Emp. Requisition Code");
    //                     EmployeeCategory.Get(EmployeeRequisition."Employee Category");
    //                     if InterviewDetail."Salary Group" <> '' then
    //                       SalaryGroup.Get(InterviewDetail."Salary Group",PayrollSetup."Basic E/D Code");
    //                     HRSetup.Get;
    //                     AddField(Applicant.Title);
    //                     AddField(Applicant."First Name");
    //                     AddField(Applicant."Last Name");
    //                     AddField(Applicant.Address);
    //                     AddField(Applicant."Address 2");
    //                     AddField(Applicant."Post Code");
    //                     AddField(Applicant.City);
    //                     AddField(Applicant."Job Applied For");
    //                     AddField(DimensionMgt.ReturnDimName(1,EmployeeRequisition."Global Dimension 1 Code"));
    //                     AddField(DimensionMgt.ReturnDimName(2,EmployeeRequisition."Global Dimension 2 Code"));
    //                     AddField(Format(SalaryGroup."Default Amount"));
    //                     AddField(Format(SalaryGroup."Default Amount" * 12));
    //                     AddField(Format(EmployeeCategory.GetLeaveDays(HRSetup."Annual Leave Code")));
    //                     AddField(Format(EmployeeCategory.GetAllowance(HRSetup."Annual Leave Code")));
    //                     AddField(InterviewHeader.Description);
    //                     AddField(Format(InterviewDetail.Date,0,'<WEEKDAY TEXT>'));
    //                     AddField(Format(InterviewDetail.Date,0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format(InterviewDetail.Time,0,'<Hours24,2>:<Minutes,2> <AM/PM>'));
    //                     AddField(InterviewHeader."Venue Description");
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                       AddField(Applicant."E-Mail")
    //                     else
    //                       AddField('');
    //                     WriteLine;
    //                   until InterviewDetail.Next = 0;
    //                 WordMergefile.CloseMergeFile;
    //               end;
    //               Database::Interviewer:begin
    //                 if Interviewer.FindFirst then
    //                   repeat
    //                     Employee2.Get(Interviewer."Employee Code");
    //                     InterviewHeader.Get(Interviewer."Schedule Code");
    //                     EmployeeRequisition.Get(InterviewHeader."Emp. Requisition Code");
    //                     EmployeeCategory.Get(EmployeeRequisition."Employee Category");
    //                     HRSetup.Get;
    //                     AddField(Employee2."First Name");
    //                     AddField(Employee2."Last Name");
    //                     AddField(EmployeeRequisition.Designation);
    //                     AddField(Format(Interviewer."Interview Date",0,'<WEEKDAY TEXT>'));
    //                     AddField(Format(Interviewer."Interview Date",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format(Interviewer."Interview Time",0,'<Hours24,2>:<Minutes,2> <AM/PM>'));
    //                     AddField(InterviewHeader."Venue Description");
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                       AddField(Interviewer."E-Mail")
    //                     else
    //                       AddField('');
    //                     WriteLine;
    //                   until Interviewer.Next = 0;
    //                 WordMergefile.CloseMergeFile;
    //               end;

    //               Database::Applicant:begin
    //                 if Applicant.FindFirst then
    //                   repeat
    //                     AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Applicant.Title);
    //                     AddField(Applicant."First Name");
    //                     AddField(Applicant."Last Name");
    //                     AddField(Applicant.Address);
    //                     AddField(Applicant."Address 2");
    //                     AddField(Applicant."Post Code");
    //                     AddField(Applicant.City);
    //                     AddField(Applicant."Job Applied For");
    //                     AddField(DimensionMgt.ReturnDimName(1,Applicant."Global Dimension 1 Code"));
    //                     AddField(DimensionMgt.ReturnDimName(2,Applicant."Global Dimension 2 Code"));
    //                     AddField('Basic Salary');
    //                     AddField('Annual Salary');
    //                     AddField('Annual Leave');
    //                     AddField('Leave Allowance');
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                       AddField(Applicant."E-Mail")
    //                     else
    //                       AddField('');
    //                     WriteLine;
    //                   until Applicant.Next = 0;
    //                 WordMergefile.CloseMergeFile
    //               end;
    //               Database::"Training Attendance": begin
    //                 if TrainingAttendance.FindFirst then
    //                   repeat
    //                     Employee2.Get(TrainingAttendance."Employee No.");
    //                     Venue.Get(Venue.Type::Venue,TrainingAttendance."Venue Code");
    //                     AddField(Format(Today));
    //                     AddField(Employee2."First Name");
    //                     AddField(TrainingAttendance."Description/Title");
    //                     AddField(Format(TrainingAttendance."Start Date"));
    //                     AddField(Venue.Description);
    //                     AddField(Format(TrainingAttendance."Begin Time"));
    //                     AddField(TrainingAttendance.Duration);
    //                     AddField(Format(FeedbackDate));
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                       AddField(Employee2."E-Mail")
    //                     else
    //                       AddField('');
    //                     WriteLine;
    //                   until TrainingAttendance.Next =0;
    //                   WordMergefile.CloseMergeFile;
    //               end;
    //               Database::"Employee Update Line": begin
    //                 if PromotionTransfer.FindFirst then
    //                   repeat
    //                     Employee2.Get(PromotionTransfer."Employee No.");
    //                     AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Employee2.FullName);
    //                     AddField(Employee2."First Name");
    //                     AddField(PromotionTransfer."New Designation");
    //                     AddField(Format(PromotionTransfer."New Gross Salary" * 12));
    //                     AddField(PromotionTransfer."New Grade Level");
    //                     AddField(Format(PromotionTransfer."Effective Date",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(DimensionMgt.ReturnDimName(1,PromotionTransfer."New Global Dimension 1 Code"));
    //                     AddField(DimensionMgt.ReturnDimName(2,PromotionTransfer."New Global Dimension 2 Code"));
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                       AddField(Employee2."E-Mail")
    //                     else
    //                       AddField('');
    //                     WriteLine;
    //                   until PromotionTransfer.Next = 0;
    //                   WordMergefile.CloseMergeFile;
    //               end;
    //               Database::Employee: begin
    //                 if  Employee.FindFirst then
    //                   repeat
    //                     AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Employee.FullName);
    //                     AddField(Employee."First Name");
    //                     AddField(Employee."Last Name");
    //                     AddField(Employee."Middle Name");
    //                     AddField(Employee.Address);
    //                     AddField(Employee."Address 2");
    //                     AddField(Format(Employee."Termination Date",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(DimensionMgt.ReturnDimName(1,Employee."Global Dimension 1 Code"));
    //                     AddField(DimensionMgt.ReturnDimName(2,Employee."Global Dimension 2 Code"));
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                       AddField(Employee."E-Mail")
    //                     else
    //                       AddField('');
    //                     WriteLine;
    //                   until Employee.Next = 0;
    //                   WordMergefile.CloseMergeFile;
    //               end;
    //               Database::"Leave Application": begin
    //                 if EmployeeLeave.FindFirst then
    //                   repeat
    //                     AddField(EmployeeLeave."Employee Name");
    //                     AddField(Format(EmployeeLeave."From Date",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format(EmployeeLeave."To Date",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format(EmployeeLeave."Resumption Date",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(Format(EmployeeLeave.Quantity));
    //                     AddField(EmployeeLeave.Description);
    //                     AddField(DimensionMgt.ReturnDimName(1,EmployeeLeave."Global Dimension 1 Code"));
    //                     AddField(DimensionMgt.ReturnDimName(2,EmployeeLeave."Global Dimension 2 Code"));
    //                     Employee.Get(EmployeeLeave."Employee No.");
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                       AddField(Employee."E-Mail")
    //                     else
    //                       AddField('');
    //                     WriteLine;
    //                   until EmployeeLeave.Next = 0;
    //                   WordMergefile.CloseMergeFile;
    //               end;
    //               Database::"Employee Exit": begin
    //                 if EmployeeExit.FindFirst then
    //                   repeat
    //                     Employee2.Get(EmployeeExit."Employee No.");
    //                     AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                     AddField(EmployeeExit."Employee Name");
    //                     AddField(Employee2.Address);
    //                     AddField(Employee2."Address 2");
    //                     AddField(Format(EmployeeExit."Exit Date",0,'<Month Text><Day>,<Year4>'));
    //                     AddField(EmployeeExit."Length of Service Text");
    //                     AddField(EmployeeExit.Designation);
    //                     AddField(EmployeeExit."Employee Category");
    //                     AddField(Format(EmployeeExit."Employee Age"));
    //                     AddField(DimensionMgt.ReturnDimName(1,Employee."Global Dimension 1 Code"));
    //                     AddField(DimensionMgt.ReturnDimName(2,Employee."Global Dimension 2 Code"));
    //                     if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                         AddField(Employee2."E-Mail")
    //                       else
    //                         AddField('');
    //                       WriteLine;
    //                   until EmployeeExit.Next = 0;
    //                   WordMergefile.CloseMergeFile;
    //                 end;
    //             end;
    //           end;

    //         //END;

    //         WordDocument := WordHelper.CallOpen(WordApplication,MainFileName,false,false);
    //         WordDocument.MailMerge.MainDocumentType := 0;

    //         Window.Update(6,Text013);
    //         ParamInt := 7; // 7 = HTML
    //         WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeClientFileName,ParamInt);
    //         Window.Update(6,StrSubstNo(Text014,Template.Code));

    //         for ShapesIndex := 1 to WordDocument.InlineShapes.Count do begin
    //           WordInlineShape := WordHelper.GetInlineShapeItem(WordDocument,ShapesIndex);
    //           if not IsNull(WordInlineShape) then begin
    //             WordLinkFormat := WordInlineShape.LinkFormat;
    //             WordOLEFormat := WordInlineShape.OLEFormat;
    //             if not IsNull(WordOLEFormat) then
    //               WordDocument.MailMerge.MailAsAttachment := WordDocument.MailMerge.MailAsAttachment or WordOLEFormat.DisplayAsIcon;
    //             if not IsNull(WordLinkFormat) then
    //               WordLinkFormat.SavePictureWithDocument := true;
    //           end;
    //         end;

    //         case CorrespondenceType of
    //           Correspondencetype::Fax:
    //             begin
    //               WordDocument.MailMerge.Destination := 3;
    //               WordDocument.MailMerge.MailAddressFieldName := Text015;
    //               WordDocument.MailMerge.MailAsAttachment := true;
    //               WordHelper.CallMailMergeExecute(WordDocument);
    //             end;
    //           Correspondencetype::"E-Mail":
    //             begin
    //               WordDocument.MailMerge.Destination := 2;
    //               WordDocument.MailMerge.MailAddressFieldName := Text015;
    //               WordDocument.MailMerge.MailSubject := Template.Description;
    //               WordDocument.MailMerge.MailAsAttachment :=
    //                 WordDocument.MailMerge.MailAsAttachment ;
    //               WordHelper.CallMailMergeExecute(WordDocument);
    //             end;
    //           Correspondencetype::"Hard Copy":
    //             begin
    //               WordDocument.MailMerge.Destination := 0; // 0 = wdSendToNewDocument
    //               WordHelper.CallMailMergeExecute(WordDocument);
    //               WordHelper.CallPrintOut(WordApplication.ActiveDocument);
    //               ParamBln := false;
    //               WordHelper.CallClose(WordApplication.ActiveDocument,ParamBln);
    //             end;
    //         end;

    //         ParamBln := false;
    //         WordHelper.CallClose(WordDocument,ParamBln);
    //         if not Template.Contents.Hasvalue then
    //           AppendToMergeSource(MergeClientFileName);
    //         DeleteFile(MainFileName);
    //         DeleteFile(MergeClientFileName);

    //         if not IsNull(WordLinkFormat) then
    //           Clear(WordLinkFormat);
    //         if not IsNull(WordOLEFormat) then
    //           Clear(WordOLEFormat);
    //         Clear(WordMergefile);
    //         Clear(WordDocument);

    //     end;


    procedure ShowMergedDocument(var Template: Record "Document Template"; WordCaption: Text[260]; IsTemporary: Boolean)
    var
    //     Salesperson: Record "Salesperson/Purchaser";
    //     Country: Record "Country/Region";
    //     Country2: Record "Country/Region";
    //     Contact: Record Contact;
    //     CompanyInfo: Record "Company Information";
    //     [RunOnClient]
    //     WordApplication: dotnet ApplicationClass;
    //     [RunOnClient]
    //     WordDocument: dotnet Document;
    //     [RunOnClient]
    //     WordMergefile: dotnet MergeHandler;
    //     MergeClientFileName: Text;
    //     FormatAddr: Codeunit "Format Address";
    //     MainFileName: Text[260];
    //     ParamInt: Integer;
    //     ParamFalse: Boolean;
    //     ContAddr: array [8] of Text[50];
    //     ContAddr2: array [8] of Text[50];
    //     MultiAddress: array [2] of Text[260];
    //     TempFileName: Text[1024];
    //     I: Integer;
    //     IsInherited: Boolean;
    //     MergeFile: File;
    //     HeaderIsReady: Boolean;
    //     MergeFileNameServer: Text[260];
    begin
        //     if not IsWordDocumentExtension(Template."File Extension") then
        //       Error(StrSubstNo(Text010,Template.TableCaption,Template.Code,
        //           Template.FieldCaption("File Extension")));

        //     MainFileName := FileMgt.ClientTempFileName('DOC');
        //     // Handle Word documents without mergefields
        //     if not DocContainMergefields(Template) then begin
        //       Template.ExportTemplatetoClientFile(MainFileName);
        //       WordApplication := WordApplication.ApplicationClass;
        //       WordDocument := WordHelper.CallOpen(WordApplication,MainFileName,false,Template."Read Only");
        //     end else begin
        //       // Merge possible
        //       if not Template.ExportTemplatetoClientFile(MainFileName) then
        //         Error(Text011);

        //         MergeClientFileName := FileMgt.ClientTempFileName('HTM');
        //         WordMergefile := WordMergefile.MergeHandler;
        //         CreateHeader2(WordMergefile,false,MergeClientFileName,Template."MailMerge Table");
        //         with WordMergefile do begin
        //           case Template."MailMerge Table" of
        //             Database::"Employee Query Entry":begin
        //               if EmployeeQuery.FindFirst then
        //                 repeat
        //                   Employee2.Get(EmployeeQuery."Employee No.");
        //                   AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
        //                   AddField(Employee2.FullName) ;
        //                   AddField(Employee2."First Name") ;
        //                   AddField(Format(EmployeeQuery."Date of Query",0,'<Month Text><Day>,<Year4>'));
        //                   AddField(Format (EmployeeQuery."Date of Violation",0,'<Month Text><Day>,<Year4>'));
        //                   AddField(Format(EmployeeQuery."Response Due Date",0,'<Month Text><Day>,<Year4>'));
        //                   AddField(Format(EmployeeQuery.Offence));
        //                   AddField(DimensionMgt.ReturnDimName(1,EmployeeQuery."Global Dimension 1 Code"));
        //                   AddField(DimensionMgt.ReturnDimName(2,EmployeeQuery."Global Dimension 2 Code"));
        //                   AddField(Format(EmployeeQuery.Action));
        //                   AddField(Format(EmployeeQuery."Effective Date of Action",0,'<Month Text><Day>,<Year4>'));
        //                   AddField(Format(EmployeeQuery."Suspension Duration"));
        //                   if CorrespondenceType = Correspondencetype::"E-Mail" then
        //                     AddField(Employee2."E-Mail")
        //                   else
        //                     AddField('');
        //                   WriteLine;
        //                 until EmployeeQuery.Next = 0;
        //               WordMergefile.CloseMergeFile;
        //             end;
        //             Database::"Interview Line":begin
        //               PayrollSetup.Get;
        //               if InterviewDetail.FindFirst then
        //                 repeat
        //                   Applicant.Get(InterviewDetail."Applicant No.");
        //                   InterviewHeader.Get(InterviewDetail."Interview No.");
        //                   EmployeeRequisition.Get(InterviewHeader."Emp. Requisition Code");
        //                   EmployeeCategory.Get(EmployeeRequisition."Employee Category");
        //                   if InterviewDetail."Salary Group" <> '' then
        //                     SalaryGroup.Get(InterviewDetail."Salary Group",PayrollSetup."Basic E/D Code");
        //                   HRSetup.Get;
        //                   AddField(Applicant.Title);
        //                   AddField(Applicant."First Name");
        //                   AddField(Applicant."Last Name");
        //                   AddField(Applicant.Address);
        //                   AddField(Applicant."Address 2");
        //                   AddField(Applicant."Post Code");
        //                   AddField(Applicant.City);
        //                   AddField(Applicant."Job Applied For");
        //                   AddField(DimensionMgt.ReturnDimName(1,EmployeeRequisition."Global Dimension 1 Code"));
        //                   AddField(DimensionMgt.ReturnDimName(2,EmployeeRequisition."Global Dimension 2 Code"));
        //                   AddField(Format(SalaryGroup."Default Amount"));
        //                   AddField(Format(SalaryGroup."Default Amount" * 12));
        //                   AddField(Format(EmployeeCategory.GetLeaveDays(HRSetup."Annual Leave Code")));
        //                   AddField(Format(EmployeeCategory.GetAllowance(HRSetup."Annual Leave Code")));
        //                   AddField(InterviewHeader.Description);
        //                   AddField(Format(InterviewDetail.Date,0,'<WEEKDAY TEXT>'));
        //                   AddField(Format(InterviewDetail.Date,0,'<Month Text><Day>,<Year4>'));
        //                   AddField(Format(InterviewDetail.Time,0,'<Hours24,2>:<Minutes,2> <AM/PM>'));
        //                   AddField(InterviewHeader."Venue Description");
        //                   if CorrespondenceType = Correspondencetype::"E-Mail" then
        //                     AddField(Applicant."E-Mail")
        //                   else
        //                     AddField('');
        //                   WriteLine;
        //                 until InterviewDetail.Next = 0;
        //               WordMergefile.CloseMergeFile;
        //             end;
        //             Database::Interviewer:begin
        //               if Interviewer.FindFirst then
        //                 repeat
        //                   Employee2.Get(Interviewer."Employee Code");
        //                   InterviewHeader.Get(Interviewer."Schedule Code");
        //                   EmployeeRequisition.Get(InterviewHeader."Emp. Requisition Code");
        //                   EmployeeCategory.Get(EmployeeRequisition."Employee Category");
        //                   HRSetup.Get;
        //                   AddField(Employee2."First Name");
        //                   AddField(Employee2."Last Name");
        //                   AddField(EmployeeRequisition.Designation);
        //                   AddField(Format(Interviewer."Interview Date",0,'<WEEKDAY TEXT>'));
        //                   AddField(Format(Interviewer."Interview Date",0,'<Month Text><Day>,<Year4>'));
        //                   AddField(Format(Interviewer."Interview Time",0,'<Hours24,2>:<Minutes,2> <AM/PM>'));
        //                   AddField(InterviewHeader."Venue Description");
        //                   if CorrespondenceType = Correspondencetype::"E-Mail" then
        //                     AddField(Interviewer."E-Mail")
        //                   else
        //                     AddField('');
        //                   WriteLine;
        //                 until Interviewer.Next = 0;
        //               WordMergefile.CloseMergeFile;
    end;

    //                 Database::Applicant:begin
    //                   if Applicant.FindFirst then
    //                     repeat
    //                       EmployeeCategory.Get(Applicant."Employee Category");
    //                       HRSetup.Get;
    //                       AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                       AddField(Applicant.Title);
    //                       AddField(Applicant."First Name");
    //                       AddField(Applicant."Last Name");
    //                       AddField(Applicant.Address);
    //                       AddField(Applicant."Address 2");
    //                       AddField(Applicant."Post Code");
    //                       AddField(Applicant.City);
    //                       AddField(Applicant."Job Applied For");
    //                       AddField(DimensionMgt.ReturnDimName(1,Applicant."Global Dimension 1 Code"));
    //                       AddField(DimensionMgt.ReturnDimName(2,Applicant."Global Dimension 2 Code"));
    //                       AddField(Format(Applicant."Expected Basic Salary"));
    //                       AddField(Format(Applicant."Expected Basic Salary" * 12));
    //                       AddField(Format(EmployeeCategory.GetLeaveDays(HRSetup."Annual Leave Code")));
    //                       AddField(Format(EmployeeCategory.GetAllowance(HRSetup."Annual Leave Code")));
    //                       if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                         AddField(Applicant."E-Mail")
    //                       else
    //                         AddField('');
    //                       WriteLine;
    //                     until Applicant.Next = 0;
    //                   WordMergefile.CloseMergeFile;
    //                 end;
    //                 Database::"Training Attendance": begin
    //                   if TrainingAttendance.FindFirst then
    //                     repeat
    //                       Employee2.Get(TrainingAttendance."Employee No.");
    //                       Venue.Get(Venue.Type::Venue,TrainingAttendance."Venue Code");
    //                       AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                       AddField(Employee2."First Name");
    //                       AddField(TrainingAttendance."Description/Title");
    //                       AddField(Format(TrainingAttendance."Start Date"));
    //                       AddField(Venue.Description);
    //                       AddField(Format(TrainingAttendance."Begin Time"));
    //                       AddField(TrainingAttendance.Duration);
    //                       AddField(Format(FeedbackDate));
    //                       if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                         AddField(Employee2."E-Mail")
    //                       else
    //                         AddField('');
    //                       WriteLine;
    //                     until TrainingAttendance.Next =0;
    //                     WordMergefile.CloseMergeFile;
    //                 end;
    //                 Database::"Employee Update Line": begin
    //                   if PromotionTransfer.FindFirst then
    //                     repeat
    //                       Employee2.Get(PromotionTransfer."Employee No.");
    //                       AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                       AddField(Employee2.FullName);
    //                       AddField(Employee2."First Name");
    //                       AddField(PromotionTransfer."New Designation");
    //                       AddField(Format(PromotionTransfer."New Gross Salary" * 12));
    //                       AddField(PromotionTransfer."New Grade Level");
    //                       AddField(Format(PromotionTransfer."Effective Date",0,'<Month Text><Day>,<Year4>'));
    //                       AddField(DimensionMgt.ReturnDimName(1,PromotionTransfer."New Global Dimension 1 Code"));
    //                       AddField(DimensionMgt.ReturnDimName(2,PromotionTransfer."New Global Dimension 2 Code"));
    //                       if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                         AddField(Employee2."E-Mail")
    //                       else
    //                         AddField('');
    //                       WriteLine;
    //                     until PromotionTransfer.Next = 0;
    //                     WordMergefile.CloseMergeFile;
    //                 end;
    //                 Database::Employee: begin
    //                   if Employee.FindFirst then
    //                     repeat
    //                       AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                       AddField(Employee.FullName);
    //                       AddField(Employee."First Name");
    //                       AddField(Employee."Last Name");
    //                       AddField(Employee."Middle Name");
    //                       AddField(Employee.Address);
    //                       AddField(Employee."Address 2");
    //                       AddField(Format(Employee."Termination Date",0,'<Month Text><Day>,<Year4>'));
    //                       AddField(DimensionMgt.ReturnDimName(1,Employee."Global Dimension 1 Code"));
    //                       AddField(DimensionMgt.ReturnDimName(2,Employee."Global Dimension 2 Code"));
    //                        if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                           AddField(Employee."E-Mail")
    //                         else
    //                           AddField('');
    //                         WriteLine;
    //                     until Employee.Next = 0;
    //                     WordMergefile.CloseMergeFile;
    //                 end;
    //                 Database::"Leave Application": begin
    //                   if EmployeeLeave.FindFirst then
    //                     repeat
    //                       AddField(EmployeeLeave."Employee Name");
    //                       AddField(Format(EmployeeLeave."From Date",0,'<Month Text><Day>,<Year4>'));
    //                       AddField(Format(EmployeeLeave."To Date",0,'<Month Text><Day>,<Year4>'));
    //                       AddField(Format(EmployeeLeave."Resumption Date",0,'<Month Text><Day>,<Year4>'));
    //                       AddField(Format(EmployeeLeave.Quantity));
    //                       AddField(EmployeeLeave.Description);
    //                       AddField(DimensionMgt.ReturnDimName(1,EmployeeLeave."Global Dimension 1 Code"));
    //                       AddField(DimensionMgt.ReturnDimName(2,EmployeeLeave."Global Dimension 2 Code"));
    //                       Employee.Get(EmployeeLeave."Employee No.");
    //                       if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                         AddField(Employee."E-Mail")
    //                       else
    //                         AddField('');
    //                       WriteLine;
    //                     until EmployeeLeave.Next = 0;
    //                     WordMergefile.CloseMergeFile;
    //                 end;
    //                 Database::"Employee Exit": begin
    //                   if EmployeeExit.FindFirst then
    //                     repeat
    //                       Employee2.Get(EmployeeExit."Employee No.");
    //                       AddField(Format(Today,0,'<Month Text><Day>,<Year4>'));
    //                       AddField(EmployeeExit."Employee Name");
    //                       AddField(Employee2.Address);
    //                       AddField(Employee2."Address 2");
    //                       AddField(Format(EmployeeExit."Exit Date",0,'<Month Text><Day>,<Year4>'));
    //                       AddField(EmployeeExit."Length of Service Text");
    //                       AddField(EmployeeExit.Designation);
    //                       AddField(EmployeeExit."Employee Category");
    //                       AddField(Format(EmployeeExit."Employee Age"));
    //                       AddField(DimensionMgt.ReturnDimName(1,Employee."Global Dimension 1 Code"));
    //                       AddField(DimensionMgt.ReturnDimName(2,Employee."Global Dimension 2 Code"));
    //                       if CorrespondenceType = Correspondencetype::"E-Mail" then
    //                           AddField(Employee2."E-Mail")
    //                         else
    //                           AddField('');
    //                         WriteLine;
    //                     until EmployeeExit.Next = 0;
    //                     WordMergefile.CloseMergeFile;
    //                 end;
    //               end;
    //             end;
    //           WordApplication := WordApplication.ApplicationClass;
    //           WordDocument := WordHelper.CallOpen(WordApplication,MainFileName,false,false);
    //           WordDocument.MailMerge.MainDocumentType := 0;
    //           ParamInt := 7; // 7 = HTML
    //           WordHelper.CallMailMergeOpenDataSource(WordDocument,MergeClientFileName,ParamInt);
    //           ParamInt := 9999998; // 9999998 = wdToggle
    //           WordDocument.MailMerge.ViewMailMergeFieldCodes(ParamInt);
    //         end;

    //         WordHandler(WordDocument,Template,WordCaption,IsTemporary,MainFileName,IsInherited);

    //         Clear(WordMergefile);
    //         Clear(WordDocument);
    //         WordHelper.CallQuit(WordApplication,false);
    //         Clear(WordApplication);

    //         DeleteFile(MergeClientFileName);
    //     end;


    //     procedure CreateHeader2(var WordMergefile: dotnet MergeHandler;MergeFieldsOnly: Boolean;MergeFileName: Text[260];MergeTableID: Integer)
    //     var
    //         I: Integer;
    //         MainLanguage: Integer;
    //         CreateOk: Boolean;
    //         OFile: File;
    //         Ostr: OutStream;
    //     begin
    //         CreateOk := true;
    //         if not WordMergefile.CreateMergeFile(MergeFileName) then
    //           Error(Text017+Text018);
    //         // Create HTML Header source
    //         with WordMergefile do begin
    //           case MergeTableID of
    //             Database::"Employee Query Entry":
    //               begin
    //                 AddField('Date');
    //                 AddField('Full Name') ;
    //                 AddField('First Name') ;
    //                 AddField(EmployeeQuery.FieldCaption("Date of Query"));
    //                 AddField(EmployeeQuery.FieldCaption("Date of Violation"));
    //                 AddField(EmployeeQuery.FieldCaption("Response Due Date"));
    //                 AddField(EmployeeQuery.FieldCaption(Offence));
    //                 AddField(EmployeeQuery.FieldCaption("Global Dimension 1 Code"));
    //                 AddField(EmployeeQuery.FieldCaption("Global Dimension 2 Code"));
    //                 AddField(EmployeeQuery.FieldCaption(Action));
    //                 AddField(EmployeeQuery.FieldCaption("Effective Date of Action"));
    //                 AddField(EmployeeQuery.FieldCaption(EmployeeQuery."Suspension Duration"));
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 13 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::Employee:
    //               begin
    //                 AddField('Date');
    //                 AddField('Full Name');
    //                 AddField('First Name');
    //                 AddField('Last Name');
    //                 AddField('Middle Name');
    //                 AddField('Address');
    //                 AddField('Address 2');
    //                 AddField('Effective Date');
    //                 AddField('Department');
    //                 AddField('Unit');
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 11 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::Applicant:
    //               begin
    //                 AddField('Date');
    //                 AddField(Applicant.FieldCaption(Title));
    //                 AddField(Applicant.FieldCaption(Applicant."First Name"));
    //                 AddField(Applicant.FieldCaption(Applicant."Last Name"));
    //                 AddField(Applicant.FieldCaption(Applicant.Address));
    //                 AddField(Applicant.FieldCaption(Applicant."Address 2"));
    //                 AddField(Applicant.FieldCaption(Applicant."Post Code"));
    //                 AddField(Applicant.FieldCaption(Applicant.City));
    //                 AddField('Designation');
    //                 AddField('Department');
    //                 AddField('Unit');
    //                 AddField('Basic Salary');
    //                 AddField('Annual Salary');
    //                 AddField('Annual Leave');
    //                 AddField('Leave Allowance');
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 16 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::"Training Attendance":
    //               begin
    //                 AddField('Date');
    //                 AddField('First Name');
    //                 AddField('Course');
    //                 AddField('Course Date');
    //                 AddField('Course Venue');
    //                 AddField('Course Time');
    //                 AddField('Course Fee/Duration');
    //                 AddField('Acceptance DeadLine');
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 9 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::"Interview Line":
    //               begin
    //                 AddField(Applicant.FieldCaption(Title));
    //                 AddField(Applicant.FieldCaption(Applicant."First Name"));
    //                 AddField(Applicant.FieldCaption(Applicant."Last Name"));
    //                 AddField(Applicant.FieldCaption(Applicant.Address));
    //                 AddField(Applicant.FieldCaption(Applicant."Address 2"));
    //                 AddField(Applicant.FieldCaption(Applicant."Post Code"));
    //                 AddField(Applicant.FieldCaption(Applicant.City));
    //                 AddField('Designation');
    //                 AddField('Department');
    //                 AddField('Unit');
    //                 AddField('Basic Salary');
    //                 AddField('Annual Salary');
    //                 AddField('Annual Leave');
    //                 AddField('Leave Allowance');
    //                 AddField('Position');
    //                 AddField('Interview Day');
    //                 AddField('Interview Date');
    //                 AddField('Interview Time');
    //                 AddField('Interview Venue');
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 20 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::Interviewer:
    //               begin
    //                 AddField('First Name');
    //                 AddField('Last Name');
    //                 AddField('Vacant Position');
    //                 AddField('Interview Day');
    //                 AddField('Interview Date');
    //                 AddField('Interview Time');
    //                 AddField('Interview Venue');
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 8 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::"Leave Application":
    //               begin
    //                 AddField(EmployeeLeave.FieldCaption("Employee Name"));
    //                 AddField(EmployeeLeave.FieldCaption("From Date"));
    //                 AddField(EmployeeLeave.FieldCaption("To Date"));
    //                 AddField(EmployeeLeave.FieldCaption("Resumption Date"));
    //                 AddField(EmployeeLeave.FieldCaption(Quantity));
    //                 AddField(EmployeeLeave.FieldCaption(Description));
    //                 AddField(EmployeeLeave.FieldCaption("Global Dimension 1 Code"));
    //                 AddField(EmployeeLeave.FieldCaption("Global Dimension 2 Code"));
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 9 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::"Employee Update Line":
    //               begin
    //                 AddField('Date');
    //                 AddField('Full Name');
    //                 AddField('First Name');
    //                 AddField('New Designation');
    //                 AddField('New Annual Salary');
    //                 AddField('New Grade Level');
    //                 AddField('Effective Date');
    //                 AddField('New Department');
    //                 AddField('New Unit');
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 10 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::"Employee Exit":
    //               begin
    //                 AddField('Date');
    //                 AddField('Full Name');
    //                 AddField('Address');
    //                 AddField('Address 2');
    //                 AddField('Exit Date');
    //                 AddField('Length of Service');
    //                 AddField('Designation');
    //                 AddField('Position before Exit');
    //                 AddField('Age');
    //                 AddField('Current Position Duration');
    //                 AddField(Employee.FieldCaption("Global Dimension 1 Code"));
    //                 AddField(Employee.FieldCaption("Global Dimension 2 Code"));
    //                 AddField(Text015);
    //                 WriteLine;
    //                 if MergeFieldsOnly then begin
    //                   for I := 1 to 13 do
    //                     AddField('');
    //                   WriteLine;
    //                   CloseMergeFile;
    //                 end;
    //               end;
    //             Database::"Appraisal Header":
    //               begin
    //               end;

    //           end;
    //         end;
    //     end;


    //     procedure WordHandler(var WordDocument: dotnet Document;var Template: Record "Document Template";Caption: Text[260];IsTemporary: Boolean;FileName: Text[260];IsInherited: Boolean) DocImported: Boolean
    //     var
    //         Template2: Record "Document Template";
    //         [RunOnClient]
    //         WordHandler: dotnet WordHandler;
    //         NewFileName: Text[260];
    //     begin
    //         WordHandler := WordHandler.WordHandler;

    //         WordDocument.ActiveWindow.Caption := Caption;
    //         WordDocument.Application.Visible := true; // Visible before WindowState KB176866 - http://support.microsoft.com/kb/176866
    //         WordDocument.ActiveWindow.WindowState := 1; // 1 = wdWindowStateMaximize
    //         WordDocument.Saved := true;
    //         WordDocument.Application.Activate;

    //         NewFileName := WordHandler.WaitForDocument(WordDocument);

    //         if not Template."Read Only" then
    //           if WordHandler.IsDocumentClosed then
    //             if WordHandler.HasDocumentChanged then begin
    //               Clear(WordHandler);
    //               if Confirm(Text021 + Caption + '?',true) then begin
    //                 if (not IsTemporary) and Template2.Get(Template.Code) then
    //                   if Template2."Last Time Modified" <> Template."Last Time Modified" then begin
    //                     DeleteFile(FileName);
    //                     if NewFileName <> FileName then
    //                       if Confirm(StrSubstNo(Text022,NewFileName),false) then
    //                         DeleteFile(NewFileName);
    //                     Error(StrSubstNo(Text023+Text025,Template.TableCaption));
    //                   end;
    //                 Template.ImportTemplateFromClientFile(NewFileName,IsTemporary,IsInherited);
    //                 DeleteFile(NewFileName);
    //                 DocImported := true;
    //               end;
    //             end;

    //         Clear(WordHandler);
    //         DeleteFile(FileName);
    //     end;


    //     procedure DeleteFile(FileName: Text[1024]) DeleteOk: Boolean
    //     var
    //         I: Integer;
    //     begin
    //         // Wait for Word to release the files
    //         if FileName = '' then
    //           exit(false);

    //         if not FileMgt.ClientFileExists(FileName) then
    //           exit(true);

    //         repeat
    //           Sleep(250);
    //           I := I + 1;
    //         until FileMgt.DeleteClientFile(FileName) or (I = 25);
    //         exit(not FileMgt.ClientFileExists(FileName));
    //     end;


    //     procedure GetWordDocExt(VersionTxt: Text[30]): Code[4]
    //     var
    //         Version: Decimal;
    //         SeparatorPos: Integer;
    //         CommaStr: Code[1];
    //         DefaultStr: Code[10];
    //         EvalOK: Boolean;
    //     begin
    //         DefaultStr := 'DOC';
    //         SeparatorPos := StrPos(VersionTxt,'.');
    //         if SeparatorPos = 0 then
    //           SeparatorPos := StrPos(VersionTxt,',');
    //         if SeparatorPos = 0 then
    //           EvalOK := Evaluate(Version,VersionTxt)
    //         else begin
    //           CommaStr := CopyStr(Format(11 / 10),2,1);
    //           EvalOK := Evaluate(Version,CopyStr(VersionTxt,1,SeparatorPos - 1) + CommaStr + CopyStr(VersionTxt,SeparatorPos + 1));
    //         end;
    //         if EvalOK and (Version >= 12.0) then
    //           exit('DOCX');
    //         exit(DefaultStr);
    //     end;


    //     procedure DocContainMergefields(var Template: Record "Document Template") MergeFields: Boolean
    //     var
    //         [RunOnClient]
    //         WordApplication: dotnet ApplicationClass;
    //         [RunOnClient]
    //         WordDocument: dotnet Document;
    //         ParamBln: Boolean;
    //         FileName: Text[260];
    //     begin
    //         WordApplication := WordApplication.ApplicationClass;
    //         if (UpperCase(Template."File Extension") <> 'DOC') and
    //            (UpperCase(Template."File Extension") <> 'DOCX')
    //         then
    //           exit(false);
    //         FileName := Template.ConstFilename;
    //         Template.ExportTemplatetoClientFile(FileName);
    //         WordDocument := WordHelper.CallOpen(WordApplication,FileName,false,false);

    //         MergeFields := (WordDocument.MailMerge.Fields.Count > 0);
    //         ParamBln := false;
    //         WordHelper.CallClose(WordDocument,ParamBln);
    //         DeleteFile(FileName);

    //         Clear(WordDocument);
    //         WordHelper.CallQuit(WordApplication,false);
    //         Clear(WordApplication);
    //     end;

    //     local procedure CreateILEMergeSource(var MergeFile: File;var Template: Record "Document Template";EntryNo: Integer;var HeaderIsReady: Boolean;CorrespondenceType: Option " ","Hard Copy","E-Mail",Fax) LineIsFound: Boolean
    //     var
    //         InteractLogEntry: Record "Interaction Log Entry";
    //         CurrentLine: Text[250];
    //         NewLine: Text[250];
    //         SearchValue: Text[30];
    //         InStreamBLOB: InStream;
    //     begin
    //         SearchValue := '<td>' + Format(EntryNo) + '</td>';
    //         Template.CalcFields(Template.Contents);
    //         Template.Contents.CreateInstream(InStreamBLOB);
    //         repeat
    //           InStreamBLOB.ReadText(CurrentLine);
    //           if (CurrentLine = '<tr>') and HeaderIsReady then begin
    //             InStreamBLOB.ReadText(NewLine);
    //             if NewLine = SearchValue then begin
    //               MergeFile.Write(CurrentLine);
    //               MergeFile.Write(NewLine);
    //               LineIsFound := true
    //             end
    //           end;

    //           if not HeaderIsReady then begin
    //             MergeFile.Write(CurrentLine);
    //             if (CurrentLine = '</tr>') then
    //               HeaderIsReady := true
    //           end
    //         until LineIsFound or InStreamBLOB.eos;

    //         if LineIsFound then begin
    //           InStreamBLOB.ReadText(NewLine);
    //           while (NewLine <> '</tr>') do begin
    //             CurrentLine := NewLine;
    //             InStreamBLOB.ReadText(NewLine);
    //             if NewLine <> '</tr>' then
    //               MergeFile.Write(CurrentLine);
    //           end;
    //           if InteractLogEntry.Get(EntryNo) then begin
    //             case CorrespondenceType of
    //               Correspondencetype::Fax:
    //                 MergeFile.Write('<td>' + AttachmentManagement.InteractionFax(InteractLogEntry) + '</td>');
    //               Correspondencetype::"E-Mail":
    //                 MergeFile.Write('<td>' + AttachmentManagement.InteractionEMail(InteractLogEntry) + '</td>')
    //               else
    //                 MergeFile.Write('<td></td>')
    //             end
    //           end
    //         end
    //     end;

    //     local procedure ImportMergeSourceFile(TemplateCode: Code[10])
    //     var
    //         Template: Record "Document Template";
    //     begin
    //         Template.Get(TemplateCode);
    //         Template.CalcFields(Contents);
    //         if not Template.Contents.Hasvalue then begin
    //           if not DocContainMergefields(Template) then
    //             exit;
    //           MergeSourceBufferFile.Write('</table>');
    //           MergeSourceBufferFile.Write('</body>');
    //           MergeSourceBufferFile.Write('</html>');
    //           MergeSourceBufferFile.Close;
    //           Template.Contents.Import(MergeSourceBufferFileName);
    //           Template.Modify;
    //           DeleteFile(MergeSourceBufferFileName);
    //           MergeSourceBufferFileName := ''
    //         end
    //     end;

    //     local procedure AppendToMergeSource(MergeFileName: Text[260])
    //     var
    //         SourceFile: File;
    //         CurrentLine: Text[250];
    //         SkipHeader: Boolean;
    //         MergeFileNameServer: Text[260];
    //     begin
    //         if MergeSourceBufferFileName = '' then begin
    //           MergeSourceBufferFileName := FileMgt.ServerTempFileName('HTM');
    //           MergeSourceBufferFile.WriteMode := true;
    //           MergeSourceBufferFile.TextMode := true;
    //           MergeSourceBufferFile.Create(MergeSourceBufferFileName);
    //         end else
    //           SkipHeader := true;
    //         SourceFile.TextMode := true;

    //         MergeFileNameServer :=  FileMgt.ServerTempFileName('HTM');
    //         Upload(Text021, '', Text032, MergeFileName, MergeFileNameServer);

    //         SourceFile.Open(MergeFileNameServer);
    //         if SkipHeader then
    //           repeat
    //             SourceFile.Read(CurrentLine)
    //           until (CurrentLine = '</tr>');
    //         while (CurrentLine <> '</table>') and (SourceFile.POS <> SourceFile.LEN) do begin
    //           SourceFile.Read(CurrentLine);
    //           if CurrentLine <> '</table>' then
    //             MergeSourceBufferFile.Write(CurrentLine);
    //         end;
    //         SourceFile.Close;

    //         Erase(MergeFileNameServer);
    //     end;


    //     procedure OpenMailMergeInRoleBasedClient(InvitationMessage: Text[1024];MainFileName: Text[1024];MergeFileName: Text[1024];UploadMessage: Text[1024]) ToFile: Text[1024]
    //     var
    //         FromFolder: Text[1024];
    //         FromFile: Text[255];
    //     begin
    //         if Confirm(InvitationMessage) then begin
    //           if StrPos(Text029,'\') <> 0 then
    //             ToFile := CopyStr(Text029,2,StrLen(Text029)-1) + '.HTM';
    //           Download(MergeFileName,Text034,'',Text032,ToFile);
    //           ToFile := Text037;
    //           Download(MainFileName,Text035,'',Text033,ToFile);

    //           GetFileFolderPart(ToFile,FromFolder,FromFile);
    //           ToFile := '';
    //           if UploadMessage <> '' then
    //             if Confirm(UploadMessage) then
    //               Upload(Text036,FromFolder,Text033,FromFile,ToFile);
    //         end
    //     end;


    procedure IsWordDocumentExtension(FileExtension: Text): Boolean
    begin
        if (UpperCase(FileExtension) <> 'DOC') and
           (UpperCase(FileExtension) <> 'DOCX') and
           (UpperCase(FileExtension) <> '.DOC') and
           (UpperCase(FileExtension) <> '.DOCX')
        then
            exit(false);

        exit(true);
    end;


    //     procedure GetFileFolderPart(FileName: Text[1024];var FolderPart: Text[1024];var FilePart: Text[1024])
    //     var
    //         i: Integer;
    //         returnStr: Integer;
    //         tempStr: Text[1024];
    //     begin
    //         tempStr := CopyStr(FileName,1,StrPos(FileName,'\'));
    //         FolderPart := tempStr;

    //         while (tempStr <> '') do begin
    //           FileName := CopyStr(FileName,StrLen(tempStr)+1,StrLen(FileName)-StrLen(tempStr));
    //           tempStr := CopyStr(FileName,1,StrPos(FileName,'\'));
    //           FolderPart := FolderPart + tempStr;
    //         end;
    //         FilePart := FileName;
    //     end;


    //     procedure SetEmployeeFilter(var Rec: Record Employee)
    //     begin
    //         Employee.CopyFilters(Rec);
    //     end;


    //     procedure SetApplicantFilter(var Rec: Record Applicant)
    //     begin
    //         Applicant.CopyFilters(Rec);
    //     end;


    //     procedure SetTrainingFilter(var Rec: Record "Training Attendance";var FeedbackDeadline: Date)
    //     begin
    //         TrainingAttendance.CopyFilters(Rec);
    //         FeedbackDate := FeedbackDeadline;
    //     end;


    //     procedure SetInterviewFilter(var Rec: Record "Interview Line")
    //     begin
    //         InterviewDetail.CopyFilters(Rec);
    //     end;


    //     procedure SetAbsenceFilter(var Rec: Record "Leave Application")
    //     begin
    //         EmployeeLeave.CopyFilters(Rec);
    //     end;


    //     procedure SetPromotionFilter(var Rec: Record "Employee Update Line")
    //     begin
    //         PromotionTransfer.CopyFilters(Rec);
    //     end;


    //     procedure SetQueryFilter(var Rec: Record "Employee Query Entry")
    //     begin
    //         EmployeeQuery.CopyFilters(Rec);
    //     end;


    //     procedure SetCorrespondenceType(var CorrespondenceType2: Option "Hard Copy","E-Mail",Fax)
    //     begin
    //         CorrespondenceType := CorrespondenceType2;
    //     end;


    //     procedure SetInterviewerFilter(var Rec: Record Interviewer)
    //     begin
    //         Interviewer.CopyFilters(Rec);
    //     end;

    //     local procedure SetEmployeeExitFilter(var Rec: Record "Employee Exit")
    //     begin
    //         EmployeeExit.CopyFilters(Rec);
    //     end;
}

