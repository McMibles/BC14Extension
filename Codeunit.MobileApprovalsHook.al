Codeunit 52092130 "Mobile Approvals Hook"
{

    // trigger OnRun()
    // begin
    // end;

    // var
    //     JsonTextWriter: dotnet JsonTextWriter;
    //     JsonTextReader: dotnet JsonTextReader;
    //     JArray: dotnet JArray;
    //     JObject: dotnet JObject;
    //     JToken: dotnet JToken;
    //     JTokenWriter: dotnet JTokenWriter;
    //     JTokenWriter2: dotnet JTokenWriter;
    //     NAVMobileApprovalSetup: Record "Mobile Approval Setup";
    //     NAVMobileUserSetup: Record "Mobile Approval User Setup";
    //     ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    //     Token: Text;
    //     LoginUserName: Text;
    //     LoginPassword: Text;
    //     LoginTenantID: Text;
    //     BaseUrl: Text;
    //     LoginMethod: Text;
    //     postString: Text;
    //     LoginRequestType: Text;
    //     DocumentPrint: Codeunit "Document-Print";
    //     ApprovalCommentLine: Record "Approval Comment Line";
    //     MFAPIN: Text;
    //     MobileApprovalDocumentMap: Record "Mobile Approval Document Map";
    //     TempBlob: Record TempBlob;
    //     PageManagement: Codeunit "Page Management";
    //     TempFolder: Text;
    //     ReportID: Integer;


    // procedure SendApprovalRequestToMobileApproval(ApprovalEntry: Record "Approval Entry")
    // var
    //     UserType: Text;
    //     BaseUrl: Text;
    //     Employee: Record Employee;
    //     Method: Text;
    //     HttpResponseMessage: dotnet HttpResponseMessage;
    //     StringContent: dotnet StringContent;
    //     ServiceResult: Text;
    //     ascii: dotnet Encoding;
    //     NAVMobileUserSetup: Record "Mobile Approval User Setup";
    //     Formatting: dotnet Formatting;
    //     Encoding: dotnet Encoding;
    //     jsonSting: dotnet String;
    //     MyStringBuilder: dotnet StringBuilder;
    //     MyStringWriter: dotnet StringWriter;
    //     MyJsonTextWriter: dotnet JTokenWriter;
    //     PaymentDate: Text;
    //     HttpContent: dotnet StringContent;
    //     BearerToken: Text;
    //     json: Text;
    //     RequestType: Text;
    //     NAVMobileApprovalSetup: Record "Mobile Approval Setup";
    //     MyJsonToken: dotnet JTokenWriter;
    // begin
    //     Login;
    //     NAVMobileApprovalSetup.Get;
    //     NAVMobileApprovalSetup.TestField("Base url");
    //     NAVMobileApprovalSetup.TestField("Send Approval Request Method");
    //     Method:= NAVMobileApprovalSetup."Send Approval Request Method";
    //     BaseUrl:= NAVMobileApprovalSetup."Base url";
    //     RequestType:= 'POST';

    //     MyJsonToken:= MyJsonToken.JTokenWriter;
    //     with MyJsonToken do
    //       begin
    //         MyJsonToken.WriteStartObject;
    //         MyJsonToken.WritePropertyName('approval_entry');
    //         MyJsonToken.WriteRawValue(ReadApprovalEntryRecAsJson(ApprovalEntry));
    //         MyJsonToken.WritePropertyName('attachment');
    //         MyJsonToken.WriteValue(ReadDocumentToApproveAsJson(ApprovalEntry));
    //         MyJsonToken.WriteEndObject;
    //         JObject:= MyJsonToken.Token;
    //       end;
    //           json := JObject.ToString;
    //     StringContent := StringContent.StringContent(json,Encoding.UTF8,'application/json');
    //     //MESSAGE('%1',json);

    //     CallRestWebService(BaseUrl,Method,RequestType,StringContent,HttpResponseMessage);
    //     ServiceResult := HttpResponseMessage.Content.ReadAsStringAsync.Result;
    //     Message(ServiceResult);
    // end;

    // procedure ApproveAnApprovalRequestToMobileApproval(ApprovalEntryNo: Integer;ApprovalUserID: Code[50];MobileApprovalAdminUserID: Code[50]): Text
    // var
    //     ApprovalEntry: Record "Approval Entry";
    //     Result: Text;
    // begin
    //     Result:= ValidateUserIDs(ApprovalUserID,MobileApprovalAdminUserID);
    //     if Result<>'' then
    //       exit(BuildJsonResponse('false',Result));

    //     ApprovalEntry.Reset;
    //     ApprovalEntry.SetRange("Entry No.",ApprovalEntryNo);
    //     if ApprovalEntry.FindFirst then
    //       begin
    //         if ApprovalEntry.Status<> ApprovalEntry.Status::Open then
    //           exit(BuildJsonResponse('false',StrSubstNo('you can not approved a %1 approval entry',ApprovalEntry.Status)));
    //         ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
    //         exit(BuildJsonResponse('true','The document have been succuessfully approved'));
    //       end
    //     else
    //       exit((BuildJsonResponse('false',StrSubstNo('Approval entry does not exist %1',ApprovalEntryNo))));
    // end;

    // procedure CancelAnApprovalRequestToMobileApproval(ApprovalEntryNo: Integer;SenderUserID: Code[50];MobileApprovalAdminUserID: Code[50]): Text
    // var
    //     ApprovalEntry: Record "Approval Entry";
    //     Result: Text;
    //     RecRef: RecordRef;
    //     ApprovalMgt: Codeunit "Approvals Hook";
    // begin
    // end;

    // procedure RejectAnApprovalRequestToMobileApproval(ApprovalEntryNo: Integer;ApprovalUserID: Code[50];MobileApprovalAdminUserID: Code[50];Reason: Text): Text
    // var
    //     ApprovalEntry: Record "Approval Entry";
    //     Result: Text;
    //     CommentLine: Record "Comment Line";
    // begin
    //     Result:= ValidateUserIDs(ApprovalUserID,MobileApprovalAdminUserID);
    //     if Result<>'' then
    //       exit(BuildJsonResponse('false',Result));
    //     ApprovalEntry.Reset;
    //     ApprovalEntry.SetRange("Entry No.",ApprovalEntryNo);
    //     if ApprovalEntry.FindFirst then
    //       begin
    //         if ApprovalEntry.Status<> ApprovalEntry.Status::Open then
    //           exit(BuildJsonResponse('false',StrSubstNo('you can not reject approval entry with status %1',ApprovalEntry.Status)));
    //         UpdateApprovalCommentline(Reason,ApprovalEntry);
    //         ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
    //         exit(BuildJsonResponse('true','The document have been succuessfully rejected'));
    //       end
    //     else
    //       exit((BuildJsonResponse('false',StrSubstNo('Approval entry does not exist %1',ApprovalEntryNo))));
    // end;

    // procedure DelegateAnApprovalRequestToMobileApproval(ApprovalEntryNo: Integer;ApprovalUserID: Code[50];MobileApprovalAdminUserID: Code[50];Reason: Text): Text
    // var
    //     ApprovalEntry: Record "Approval Entry";
    //     Result: Text;
    // begin
    //     Result:= ValidateUserIDs(ApprovalUserID,MobileApprovalAdminUserID);
    //     if Result<>'' then
    //       exit(BuildJsonResponse('false',Result));
    //     ApprovalEntry.Reset;
    //     ApprovalEntry.SetRange("Entry No.",ApprovalEntryNo);
    //     if ApprovalEntry.FindFirst then
    //       begin
    //         if ApprovalEntry.Status<> ApprovalEntry.Status::Open then
    //           exit(BuildJsonResponse('false',StrSubstNo('you can not delegate approval entry with status %1',ApprovalEntry.Status)));
    //         UpdateApprovalCommentline(Reason,ApprovalEntry);
    //         ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
    //         exit(BuildJsonResponse('true','The document have been succuessfully delegated'));
    //       end
    //     else
    //       exit((BuildJsonResponse('false',StrSubstNo('Approval entry does not exist %1',ApprovalEntryNo))));
    // end;


    // procedure ViewDocument(ApprovalEntry: Record "Approval Entry") DocTex: Text
    // var
    //     FileRec: File;
    //     MyInstream: InStream;
    //     myRecRef: RecordRef;
    //     myReportID: Integer;
    // begin
    //     myRecRef.Get(ApprovalEntry."Record ID to Approve");
    //     myReportID:= GetReportID(myRecRef);
    //     if myReportID <>0 then
    //       begin
    //         FileRec.Open(ReadDocumentAsStream(myReportID,ApprovalEntry));
    //         FileRec.CreateInstream(MyInstream);
    //         exit(ConvertStreamToBase64(MyInstream));
    //       end;
    // end;

    // procedure CallRestWebService(BaseUrl: Text;Method: Text;RestMethod: Text;var HttpContent: dotnet HttpContent;var HttpResponseMessage: dotnet HttpResponseMessage)
    // var
    //     HttpClient: dotnet HttpClient;
    //     Uri: dotnet Uri;
    // begin
    //     HttpClient := HttpClient.HttpClient();
    //     HttpClient.BaseAddress := Uri.Uri(BaseUrl);

    //     case RestMethod of
    //       'GET':
    //         begin
    //           if Token<>'' then
    //             HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer '+Token);
    //           HttpResponseMessage := HttpClient.GetAsync(Method).Result;
    //         end;
    //       'POST':
    //         begin
    //           if Token<>'' then
    //             HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer '+Token);
    //           HttpResponseMessage := HttpClient.PostAsync(Method,HttpContent).Result;
    //         end;
    //       'PUT':
    //         HttpResponseMessage := HttpClient.PutAsync(Method,HttpContent).Result;
    //       'DELETE':
    //         HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;
    //     end;
    // end;

    // [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterModifyEvent', '', false, false)]
    // local procedure OnModifyApprovaleEntry(var Rec: Record "Approval Entry";var xRec: Record "Approval Entry";RunTrigger: Boolean)
    // var
    //     NAVMobileUserSetup: Record "Mobile Approval User Setup";
    // begin
    //     if not NAVMobileUserSetup.Get(Rec."Approver ID") then
    //       exit;
    //     if Rec.Status <> Rec.Status::Open then
    //       exit;
    //     SendApprovalRequestToMobileApproval(Rec);
    // end;

    // local procedure ValidateUserIDs(ApprovalUserID: Code[50];MobileApprovalAdminUserID: Code[50]): Text
    // begin
    //     TestSetupValues;
    //     if NAVMobileApprovalSetup."Mobile Approval Administrator" <> MobileApprovalAdminUserID then
    //       exit('Mobile Approval Adminstrator not setup on NAV Mobile Approval Setup');

    //     if not NAVMobileUserSetup.Get(ApprovalUserID) then
    //       exit('User does not exist on mobile approval setup');
    // end;


    // procedure GetLoginCredentials() Result: Text
    // var
    //     RestMethod: Text;
    //     StringContent: dotnet StringContent;
    //     HttpResponseMessage: dotnet HttpResponseMessage;
    //     ascii: dotnet Encoding;
    //     APIResult: dotnet NAVWebRequest;
    //     JsonConvert: dotnet JsonConvert;
    //     RequestType: Text;
    //     HttpClient: dotnet HttpClient;
    //     Uri: dotnet Uri;
    //     String: dotnet String;
    // begin
    //     TestSetupValues;
    //     BaseUrl:= NAVMobileApprovalSetup."Base url";
    //     LoginMethod := NAVMobileApprovalSetup."Get Token Method";
    //     LoginUserName:= NAVMobileApprovalSetup."Log In User Name";
    //     LoginPassword:= NAVMobileApprovalSetup.Password;
    //     LoginTenantID:= NAVMobileApprovalSetup.TenantID;
    //     LoginRequestType:= NAVMobileApprovalSetup."Login Http Request Type";

    //     if CopyStr(NAVMobileApprovalSetup."Temp Folder Path",StrLen(NAVMobileApprovalSetup."Temp Folder Path"),1) <> '\' then
    //       TempFolder := NAVMobileApprovalSetup."Temp Folder Path" + '\'
    //     else
    //       TempFolder := NAVMobileApprovalSetup."Temp Folder Path";


    //     case NAVMobileApprovalSetup."Multi Factor Auth PIN To Prior" of
    //       NAVMobileApprovalSetup."multi factor auth pin to prior"::"Setup PIN":
    //         begin
    //           MFAPIN:= NAVMobileApprovalSetup."Multi Factor Auth PIN";
    //         end;
    //       NAVMobileApprovalSetup."multi factor auth pin to prior"::"User PIN":
    //         begin
    //           MFAPIN:= NAVMobileUserSetup."Multi Factor Auth PIN";
    //         end;
    //     end;
    // end;


    // procedure Login() Result: Text
    // var
    //     StringContent: dotnet StringContent;
    //     jsonSting: dotnet String;
    //     json: Text;
    //     Encoding: dotnet Encoding;
    //     HttpResponseMessage: dotnet HttpResponseMessage;
    // begin
    //     GetLoginCredentials;
    //     JTokenWriter := JTokenWriter.JTokenWriter;
    //     with JTokenWriter do begin
    //       WriteStartObject;
    //       CreateJSONAttribute('email',LoginUserName);
    //       CreateJSONAttribute('password',LoginPassword);
    //       CreateJSONAttribute('tenantID',LoginTenantID);
    //       WriteEndObject;
    //       JObject := Token;
    //     end;

    //     json := JObject.ToString;
    //     StringContent := StringContent.StringContent(json,Encoding.UTF8,'application/json');
    //     CallRestWebService(BaseUrl,LoginMethod,LoginRequestType,StringContent,HttpResponseMessage);
    //     Result := HttpResponseMessage.Content.ReadAsStringAsync.Result;
    //     JObject:=JObject.Parse(Result);
    //     Token:= JObject.GetValue('access_token').ToString;
    //     //MESSAGE(Token);
    // end;

    // local procedure SignOut()
    // begin
    //     TestSetupValues;
    // end;


    // procedure CreateJSONAttribute(AttributeName: Text;Value: Variant)
    // begin
    //     JTokenWriter.WritePropertyName(AttributeName);
    //     JTokenWriter.WriteValue(Format(Value,0,1));
    // end;

    // local procedure ReadApprovalEntryRecAsJson(MyApprovalEntry: Record "Approval Entry"): Text
    // begin
    //     JTokenWriter := JTokenWriter.JTokenWriter;
    //     with JTokenWriter do begin
    //       WriteStartArray;
    //       with MyApprovalEntry do begin
    //         WriteStartObject;
    //         CreateJSONAttribute('limit_type',MyApprovalEntry."Limit Type");
    //         CreateJSONAttribute('entry_no',MyApprovalEntry."Entry No.");
    //         CreateJSONAttribute('table_id',MyApprovalEntry."Table ID");
    //         CreateJSONAttribute('document_no',MyApprovalEntry."Document No.");
    //         CreateJSONAttribute('approval_type',MyApprovalEntry."Approval Type");
    //         //CreateJSONAttribute('document_type',MyApprovalEntry."Document Type");
    //         CreateJSONAttribute('document_type',1);
    //         CreateJSONAttribute('batch_name',MyApprovalEntry.Description);
    //         CreateJSONAttribute('sequence_no',MyApprovalEntry."Sequence No.");
    //         CreateJSONAttribute('approval_code',MyApprovalEntry."Approval Code");
    //         CreateJSONAttribute('nav_status',MyApprovalEntry.Status);
    //         CreateJSONAttribute('sender_id',MyApprovalEntry."Sender ID");
    //         CreateJSONAttribute('salespers_purch_code',MyApprovalEntry."Salespers./Purch. Code");
    //         CreateJSONAttribute('approver_id',MyApprovalEntry."Approver ID");
    //         CreateJSONAttribute('currency_code',MyApprovalEntry."Currency Code");
    //         CreateJSONAttribute('amount_lcy',MyApprovalEntry.Amount);
    //         CreateJSONAttribute('description',MyApprovalEntry.Description);
    //         CreateJSONAttribute('available_credit_limit_lcy',MyApprovalEntry."Available Credit Limit (LCY)");
    //         CreateJSONAttribute('date_time_sent_for_approval',MyApprovalEntry."Date-Time Sent for Approval");
    //         CreateJSONAttribute('last_date_time_modified',MyApprovalEntry."Last Date-Time Modified");
    //         CreateJSONAttribute('last_modified_by_id',MyApprovalEntry."Last Modified By User ID");
    //         CreateJSONAttribute('due_date',MyApprovalEntry."Due Date");
    //         CreateJSONAttribute('comment',MyApprovalEntry.Comment);
    //         CreateJSONAttribute('mfa_pin',MFAPIN);
    //         WriteEndObject;
    //       end;
    //       WriteEndArray;
    //       JObject := Token;
    //       exit(JObject.ToString);
    //     end;
    // end;

    // local procedure ReadDocumentToApproveAsJson(MyApprovalEntry: Record "Approval Entry"): Text
    // begin
    //     exit(ViewDocument(MyApprovalEntry));
    // end;

    // local procedure TestSetupValues()
    // begin
    //     NAVMobileApprovalSetup.Get;
    //     NAVMobileApprovalSetup.TestField("Get Token Method");
    //     NAVMobileApprovalSetup.TestField("Base url");
    //     NAVMobileApprovalSetup.TestField("Log In User Name");
    //     NAVMobileApprovalSetup.TestField("Login Http Request Type");
    //     NAVMobileApprovalSetup.TestField(Password);
    //     NAVMobileApprovalSetup.TestField(TenantID);
    //     NAVMobileApprovalSetup.TestField("Temp Folder Path");
    // end;

    // local procedure ReportIDSelection(MyApprovalEntry: Record "Approval Entry")
    // var
    //     ReportSelections: Record "Report Selections";
    // begin
    //     //ReportSelections
    // end;


    // procedure StreamToString(StreamToConvert: InStream) StreamContent: Text
    // var
    //     StringBuilder: dotnet StringBuilder;
    //     uriObj: dotnet Uri;
    //     HttpRequest: dotnet HttpWebRequest;
    //     stream: dotnet StreamWriter;
    //     HttpResponse: dotnet HttpWebResponse;
    //     str: dotnet Stream;
    //     reader: dotnet XmlTextReader;
    //     XMLDoc: dotnet XmlDocument;
    //     ascii: dotnet Encoding;
    //     credentials: dotnet CredentialCache;
    //     ServicePointManager: dotnet ServicePointManager;
    //     vBigText: BigText;
    //     ErrorMsg: Text;
    //     XMLDocNodeList: dotnet XmlNodeList;
    //     XMLDocNode: dotnet XmlNode;
    //     StatusOK: Boolean;
    // begin
    //     vBigText.Read(StreamToConvert);
    //     StringBuilder := StringBuilder.StringBuilder();
    //     StringBuilder.Append(vBigText);
    //     StreamContent:= StringBuilder.ToString;
    // end;

    // local procedure UpdateApprovalCommentline(CommentToUpdate: Text;MyApprovalEnrty: Record "Approval Entry")
    // begin
    //     if CommentToUpdate<>'' then
    //       begin
    //         ApprovalCommentLine.Init;
    //         ApprovalCommentLine."Entry No.":= MyApprovalEnrty."Entry No.";
    //         ApprovalCommentLine."Table ID":= MyApprovalEnrty."Table ID";
    //         ApprovalCommentLine."Document Type":= MyApprovalEnrty."Document Type";
    //         ApprovalCommentLine."Document No.":= MyApprovalEnrty."Document No.";
    //         ApprovalCommentLine."User ID":= MyApprovalEnrty."Approver ID";
    //         ApprovalCommentLine.Comment:= CommentToUpdate;
    //         ApprovalCommentLine."Workflow Step Instance ID":= MyApprovalEnrty."Workflow Step Instance ID";
    //         ApprovalCommentLine."Record ID to Approve":= MyApprovalEnrty."Record ID to Approve";
    //         ApprovalCommentLine.Insert;
    //       end;
    // end;

    // local procedure GETMfaPIN(UserID: Code[50]): Text
    // begin
    //     GetLoginCredentials;
    //     exit(MFAPIN);
    // end;

    // local procedure BuildJsonResponse(success: Text;ResponseMessage: Text): Text
    // begin
    //     JTokenWriter := JTokenWriter.JTokenWriter;
    //     with JTokenWriter do begin
    //         WriteStartObject;
    //         CreateJSONAttribute('success',success);
    //         CreateJSONAttribute('message',ResponseMessage);
    //         WriteEndObject;
    //         JObject:= Token;
    //       end;
    //     exit(JObject.ToString);
    // end;

    // local procedure GetReportID(RecRelated: Variant): Integer
    // begin
    //     if MobileApprovalDocumentMap.Get(PageManagement.GetPageID(RecRelated)) then
    //       exit(MobileApprovalDocumentMap."Report ID");
    // end;

    // local procedure ConvertStreamToBase64(DocStream: InStream): Text
    // var
    //     MyDocOutStream: OutStream;
    // begin
    //     TempBlob.Init;
    //     if not TempBlob.Insert(true) then
    //       TempBlob.Modify;
    //     TempBlob.Blob.CreateOutstream(MyDocOutStream,Textencoding::UTF8);
    //     CopyStream(MyDocOutStream,DocStream);
    //     exit(TempBlob.ToBase64String());
    // end;

    // local procedure ReadDocumentAsStream(myReportID: Integer;myApprovalEntry: Record "Approval Entry"): Text
    // var
    //     MyOutstr: OutStream;
    //     MyInstrm: InStream;
    //     myFile: File;
    //     myRecRef: RecordRef;
    //     SaveToTempPath: Text;
    // begin
    //     myRecRef.Get(myApprovalEntry."Record ID to Approve");
    //     SaveToTempPath:= TempFolder+'MobilDoc.txt';

    //     if Exists(SaveToTempPath) then
    //       Erase(SaveToTempPath);

    //     myFile.TextMode(true);
    //     myFile.Create(SaveToTempPath);
    //     myFile.CreateOutstream(MyOutstr);
    //     Report.SaveAs(myReportID,'',Reportformat::Pdf,MyOutstr,myRecRef);
    //     myFile.Close;
    //     exit(SaveToTempPath);
    // end;

    // local procedure SaveToTempPath(myApprovalEntry: Record "Approval Entry")
    // var
    //     FileManagement: Codeunit "File Management";
    //     myRecRef: RecordRef;
    //     PageID: Integer;
    //     TemServerFile: Text;
    // begin
    //     myRecRef.Get(myApprovalEntry."Record ID to Approve");
    //     PageID:= GetReportID(myRecRef);
    //     TemServerFile:= FileManagement.ServerTempFileName('.pdf');
    // end;

    // trigger Jobject::PropertyChanged(sender: Variant;e: dotnet PropertyChangedEventArgs)
    // begin
    // end;

    // trigger Jobject::PropertyChanging(sender: Variant;e: dotnet PropertyChangingEventArgs)
    // begin
    // end;

    // trigger Jobject::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    // begin
    // end;

    // trigger Jobject::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    // begin
    // end;

    // trigger Jobject::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    // begin
    // end;

    // trigger Jarray::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
    // begin
    // end;

    // trigger Jarray::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
    // begin
    // end;

    // trigger Jarray::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
    // begin
    // end;
}

