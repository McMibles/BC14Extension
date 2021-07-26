// Codeunit 52092129 "Token Authenticator"
// {

//     trigger OnRun()
//     begin
//         TokenAccepted := false;
//         TokenLogin;
//     end;

//     var
//         TokenSetup: Record "Token Setup";
//         UserSetup: Record "User Setup";
//         StringContent: dotnet StringContent;
//         json: Text;
//         RequestType: Text;
//         BaseUrl: Text;
//         ServiceResult: Text;
//         StringBuilder: dotnet StringBuilder;
//         StringWriter: dotnet StringWriter;
//         StringReader: dotnet StringReader;
//         JsonTextWriter: dotnet JsonTextWriter;
//         JsonTextReader: dotnet JsonTextReader;
//         HttpWebRequestMgt: Codeunit "Http Web Request Mgt.";
//         Result: Text;
//         null: dotnet Object;
//         String: dotnet String;
//         Token1: Text;
//         Token2: Text;
//         JArray: dotnet JArray;
//         JObject: dotnet JObject;
//         JToken: dotnet JToken;
//         LoginCredentials: Text;
//         AccessToken: Text;
//         Progress: Dialog;
//         ProgressCount: Integer;
//         JTokenWriter: dotnet JTokenWriter;
//         Method: Text;
//         BearerToken: Text;
//         AuthToken: Text;
//         AuthUserID: Text;
//         TokenPin: Text;
//         TokenAuthenticatorRep: Report "Token Authenticator";
//         ServicePointManager: dotnet ServicePointManager;
//         SecurityProtocolType: dotnet SecurityProtocolType;
//         Text001: label 'Token not generated!';
//         TokenAccepted: Boolean;
//         MyJObject: dotnet JObject;
//         MyJToken: dotnet JToken;
//         MyResult: Text;
//         ExpiryDT: DateTime;
//         Text002: label 'Token Counter Exceeded';
//         Text003: label 'Token Expired!';
//         TokType: Option SMS,EMail,TOTP,HOTP;
//         TokenOption: Page "Token Option";


//     procedure TokenLogin()
//     var
//         Encoding: dotnet Encoding;
//         HttpResponseMessage: dotnet HttpResponseMessage;
//         StatusRes: Boolean;
//     begin

//         TokenSetup.Get;
//         UserSetup.Get(UserId);

//         BaseUrl := TokenSetup."Base Url";
//         Method := TokenSetup."Login Method";

//         JTokenWriter := JTokenWriter.JTokenWriter;

//         with JTokenWriter do begin
//           WriteStartObject;
//           WritePropertyName('username');
//           WriteValue(TokenSetup."Url UserName");
//           WritePropertyName('password');
//           WriteValue(TokenSetup."Url Password");
//           WritePropertyName('realm');
//           WriteValue(TokenSetup.Realm);
//           WriteEndObject;
//           JObject:= Token;
//         end;
//         json := JObject.ToString;

//         StringContent := StringContent.StringContent(json,Encoding.UTF8,'application/json');
//         //MESSAGE(json);
//         RequestType:= 'POST';
//         BearerToken := '';

//         CallLoginRestWebServiceToken(BaseUrl,Method,RequestType,StringContent,HttpResponseMessage,BearerToken);

//         ServiceResult := HttpResponseMessage.Content.ReadAsStringAsync.Result;
//         //MESSAGE(ServiceResult);

//         JObject := JToken.Parse(ServiceResult);
//         Result := JObject.GetValue('result').ToString;
//         JObject := JToken.Parse(Result);
//         Result := JObject.GetValue('status').ToString;
//         if UpperCase(Result) = 'TRUE' then begin
//           Result := JObject.GetValue('value').ToString;
//           JObject := JToken.Parse(Result);
//           Result := JObject.GetValue('token').ToString;
//           AuthToken := Result;

//           if TokenSetup."Use Default Token Option" then begin
//             TokType := TokenSetup."Default Token Option";
//             TriggerChallenge(TokType);
//           end else begin
//             if TokenOption.RunModal = Action::Yes then begin
//               TokenOption.ReturnInfo(TokType);
//             end;
//             TriggerChallenge(TokType);
//           end;
//         end else begin
//           Result := JObject.GetValue('error').ToString;
//           JObject := JToken.Parse(Result);
//           Result := JObject.GetValue('message').ToString;
//           Error(Result);
//         end;
//     end;


//     procedure CallLoginRestWebServiceToken(BaseUrl: Text;Method: Text;RestMethod: Text;var HttpContent: dotnet HttpContent;var HttpResponseMessage: dotnet HttpResponseMessage;var Bearer: Text)
//     var
//         HttpClient: dotnet HttpClient;
//         Uri: dotnet Uri;
//         MSReqId: Guid;
//         MSCorrID: Guid;
//     begin
//         HttpClient := HttpClient.HttpClient();
//         HttpClient.BaseAddress := Uri.Uri(BaseUrl);
//         //Todo Resolve This and It will Work , Get Token is working Fine ,

//         case RestMethod of
//           'POST':
//             begin
//               //HttpClient.DefaultRequestHeaders.Add('Authorization', 'Bearer '+Bearer);
//               HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
//               //HttpClient.DefaultRequestHeaders.Add('Content-Type', 'application/json');
//               ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls12;
//               HttpResponseMessage := HttpClient.PostAsync(Method,HttpContent).Result;
//             end;
//         end;
//     end;

//     local procedure TriggerChallenge(var TokenType: Option SMS,EMail,TOTP,HOTP)
//     var
//         Encoding: dotnet Encoding;
//         HttpResponseMessage: dotnet HttpResponseMessage;
//         StreamOut: OutStream;
//         iCount: Integer;
//     begin
//         AuthUserID := CopyStr(UserId,GetStrPosition(UserId),StrLen(UserId));

//         TokenSetup.Get;
//         UserSetup.Get(UserId);

//         BaseUrl := TokenSetup."Base Url";
//         Method := TokenSetup."Trigger Challenge Method";

//         JTokenWriter := JTokenWriter.JTokenWriter;

//         with JTokenWriter do begin
//           WriteStartObject;
//           WritePropertyName('user');
//           WriteValue(AuthUserID);
//           //WriteValue('talade');
//           WritePropertyName('realm');
//           WriteValue(TokenSetup.Realm);
//           if TokenType = Tokentype::SMS then begin
//             WritePropertyName('type');
//             WriteValue('sms');
//           end else if TokenType = Tokentype::EMail then begin
//             WritePropertyName('type');
//             WriteValue('email');
//           end else if TokenType = Tokentype::TOTP then begin
//             WritePropertyName('type');
//             WriteValue('totp');
//           end else if TokenType = Tokentype::HOTP then begin
//             WritePropertyName('type');
//             WriteValue('hotp');
//           end;
//           WritePropertyName('exception');
//           WriteValue(1);
//           WriteEndObject;
//           JObject:= Token;
//         end;
//         json := JObject.ToString;

//         StringContent := StringContent.StringContent(json,Encoding.UTF8,'application/json');
//         //MESSAGE(json);
//         RequestType:= 'POST';
//         BearerToken := AuthToken;

//         CallChallengeRestWebServiceToken(BaseUrl,Method,RequestType,StringContent,HttpResponseMessage,BearerToken);

//         ServiceResult := HttpResponseMessage.Content.ReadAsStringAsync.Result;
//         //MESSAGE(ServiceResult);

//         JObject := JToken.Parse(ServiceResult);
//         Result := JObject.GetValue('result').ToString;
//         JObject := JToken.Parse(Result);
//         Result := JObject.GetValue('status').ToString;
//         if UpperCase(Result) = 'TRUE' then begin
//           Result := JObject.GetValue('value').ToString;
//           if (Result = '1') or (Result = '2') or(Result = '3') or(Result = '4') or (Result = '5') or (Result = '6') or (UpperCase(Result) = 'TRUE') then begin
//             if TokenType = Tokentype::SMS then begin
//               MyJObject := MyJToken.Parse(ServiceResult);
//               MyResult := MyJObject.GetValue('detail').ToString;
//               MyJObject := MyJToken.Parse(MyResult);
//               MyResult := MyJObject.GetValue('attributes').ToString;
//               MyJObject := MyJToken.Parse(MyResult);
//               MyResult := MyJObject.GetValue('valid_until').ToString;
//               GetValidExpiry(MyResult,ExpiryDT);
//               iCount := 0;
//               repeat
//                 Clear(TokenAuthenticatorRep);
//                 TokenAuthenticatorRep.PassAuth(AuthToken);
//                 TokenAuthenticatorRep.RunModal;
//                 TokenAuthenticatorRep.ValToken(TokenAccepted);
//                 iCount += 1;
//               until (iCount >= TokenSetup.Counter) or TokenAccepted or (CreateDatetime(Today,Time) >= ExpiryDT);
//             end else begin
//               iCount := 0;
//               repeat
//                 Clear(TokenAuthenticatorRep);
//                 TokenAuthenticatorRep.PassAuth(AuthToken);
//                 TokenAuthenticatorRep.RunModal;
//                 TokenAuthenticatorRep.ValToken(TokenAccepted);
//                 iCount += 1;
//               until (iCount >= TokenSetup.Counter) or TokenAccepted
//             end;
//             if not TokenAccepted then begin
//               if iCount >= TokenSetup.Counter then
//                 Error(Text002);
//               if CreateDatetime(Today,Time) >= ExpiryDT then
//                 Error(Text003);
//             end;
//           end else begin
//             JObject := JToken.Parse(ServiceResult);
//             Result := JObject.GetValue('detail').ToString;
//             JObject := JToken.Parse(Result);
//             Result := JObject.GetValue('message').ToString;
//             Error(CopyStr(Result,1,60));
//           end;
//         end else begin
//           Result := JObject.GetValue('error').ToString;
//           JObject := JToken.Parse(Result);
//           Result := JObject.GetValue('message').ToString;
//           Error(Result);
//         end;
//     end;


//     procedure CallChallengeRestWebServiceToken(BaseUrl: Text;Method: Text;RestMethod: Text;var HttpContent: dotnet HttpContent;var HttpResponseMessage: dotnet HttpResponseMessage;var Bearer: Text)
//     var
//         HttpClient: dotnet HttpClient;
//         Uri: dotnet Uri;
//         MSReqId: Guid;
//         MSCorrID: Guid;
//     begin
//         HttpClient := HttpClient.HttpClient();
//         HttpClient.BaseAddress := Uri.Uri(BaseUrl);
//         //Todo Resolve This and It will Work , Get Token is working Fine ,

//         case RestMethod of
//           'POST':
//             begin
//               HttpClient.DefaultRequestHeaders.Add('Authorization', AuthToken);
//               HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
//               //HttpClient.DefaultRequestHeaders.Add('Content-Type', 'application/json');
//               HttpResponseMessage := HttpClient.PostAsync(Method,HttpContent).Result;
//             end;
//         end;
//     end;

//     local procedure GetStrPosition(URLToChange: Text): Integer
//     var
//         DocLinkStr: Text;
//         DocLength: Integer;
//         i: Integer;
//     begin
//         DocLength := 0;
//         for i := 1 to StrLen(URLToChange) do begin
//           DocLinkStr := CopyStr(URLToChange,i,1);
//           if DocLinkStr = '\' then
//             exit(i+1);
//         end;
//         exit(1);
//     end;


//     procedure ValidateToken(TokenCode: Text;AuthToken2: Text;var AcceptToken: Boolean)
//     var
//         Encoding: dotnet Encoding;
//         HttpResponseMessage: dotnet HttpResponseMessage;
//     begin
//         AuthUserID := CopyStr(UserId,GetStrPosition(UserId),StrLen(UserId));

//         TokenSetup.Get;
//         UserSetup.Get(UserId);

//         TokenPin := UserSetup."Login Pin";
//         if TokenPin = '' then begin
//           if TokenSetup."Use Global Pin" then
//             TokenPin := TokenSetup."Global Login Pin";
//         end;

//         BaseUrl := TokenSetup."Base Url";
//         Method := TokenSetup."Validate Token Method";

//         JTokenWriter := JTokenWriter.JTokenWriter;

//         with JTokenWriter do begin
//           WriteStartObject;
//           WritePropertyName('user');
//           WriteValue(AuthUserID);
//           //WriteValue('gems');
//           WritePropertyName('realm');
//           WriteValue(TokenSetup.Realm);
//           WritePropertyName('pass');
//           WriteValue(TokenPin + TokenCode);
//           WriteEndObject;
//           JObject:= Token;
//         end;
//         json := JObject.ToString;

//         StringContent := StringContent.StringContent(json,Encoding.UTF8,'application/json');
//         //MESSAGE(json);
//         RequestType:= 'POST';
//         BearerToken := AuthToken2;

//         CallValTokenRestWebServiceToken(BaseUrl,Method,RequestType,StringContent,HttpResponseMessage,BearerToken);

//         ServiceResult := HttpResponseMessage.Content.ReadAsStringAsync.Result;
//         //MESSAGE(ServiceResult);

//         JObject := JToken.Parse(ServiceResult);
//         Result := JObject.GetValue('result').ToString;
//         JObject := JToken.Parse(Result);
//         Result := JObject.GetValue('status').ToString;
//         if UpperCase(Result) = 'TRUE' then begin
//           Result := JObject.GetValue('value').ToString;
//           if not((Result = '1') or (UpperCase(Result) = 'TRUE')) then begin
//             JObject := JToken.Parse(ServiceResult);
//             Result := JObject.GetValue('detail').ToString;
//             JObject := JToken.Parse(Result);
//             Result := JObject.GetValue('message').ToString;
//             Message(CopyStr(Result,1,60));
//           end else
//             AcceptToken := true;
//         end else begin
//           Result := JObject.GetValue('error').ToString;
//           JObject := JToken.Parse(Result);
//           Result := JObject.GetValue('message').ToString;
//           Message(Result);
//         end;
//     end;


//     procedure CallValTokenRestWebServiceToken(BaseUrl: Text;Method: Text;RestMethod: Text;var HttpContent: dotnet HttpContent;var HttpResponseMessage: dotnet HttpResponseMessage;var Bearer: Text)
//     var
//         HttpClient: dotnet HttpClient;
//         Uri: dotnet Uri;
//         MSReqId: Guid;
//         MSCorrID: Guid;
//     begin
//         HttpClient := HttpClient.HttpClient();
//         HttpClient.BaseAddress := Uri.Uri(BaseUrl);
//         //Todo Resolve This and It will Work , Get Token is working Fine ,

//         case RestMethod of
//           'POST':
//             begin
//               HttpClient.DefaultRequestHeaders.Add('Authorization', BearerToken);
//               HttpClient.DefaultRequestHeaders.Add('Accept', 'application/json');
//               //HttpClient.DefaultRequestHeaders.Add('Content-Type', 'application/json');
//               ServicePointManager.SecurityProtocol := SecurityProtocolType.Tls12;
//               HttpResponseMessage := HttpClient.PostAsync(Method,HttpContent).Result;
//             end;
//         end;
//     end;

//     local procedure GetValidExpiry(DTText: Text;var ExpiryDateTime: DateTime)
//     var
//         YearNo: Integer;
//         MonthNo: Integer;
//         DayNo: Integer;
//         ExpiryDate: Date;
//         TimeText: Text;
//         ExpirtyTime: Time;
//     begin
//         Evaluate(YearNo,CopyStr(DTText,1,4));
//         Evaluate(MonthNo,CopyStr(DTText,6,2));
//         Evaluate(DayNo,CopyStr(DTText,9,2));
//         ExpiryDate := Dmy2date(DayNo,MonthNo,YearNo);
//         TimeText := CopyStr(DTText,12,8);
//         Evaluate(ExpirtyTime,TimeText);
//         ExpiryDateTime := CreateDatetime(ExpiryDate,ExpirtyTime);
//     end;

//     trigger Jobject::PropertyChanged(sender: Variant;e: dotnet PropertyChangedEventArgs)
//     begin
//     end;

//     trigger Jobject::PropertyChanging(sender: Variant;e: dotnet PropertyChangingEventArgs)
//     begin
//     end;

//     trigger Jobject::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
//     begin
//     end;

//     trigger Jobject::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
//     begin
//     end;

//     trigger Jobject::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
//     begin
//     end;

//     trigger Jarray::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
//     begin
//     end;

//     trigger Jarray::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
//     begin
//     end;

//     trigger Jarray::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
//     begin
//     end;

//     trigger Myjobject::PropertyChanged(sender: Variant;e: dotnet PropertyChangedEventArgs)
//     begin
//     end;

//     trigger Myjobject::PropertyChanging(sender: Variant;e: dotnet PropertyChangingEventArgs)
//     begin
//     end;

//     trigger Myjobject::ListChanged(sender: Variant;e: dotnet ListChangedEventArgs)
//     begin
//     end;

//     trigger Myjobject::AddingNew(sender: Variant;e: dotnet AddingNewEventArgs)
//     begin
//     end;

//     trigger Myjobject::CollectionChanged(sender: Variant;e: dotnet NotifyCollectionChangedEventArgs)
//     begin
//     end;
// }

