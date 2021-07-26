Codeunit 52092125 "Send SMS"
{

    //     trigger OnRun()
    //     begin
    //     end;

    //     var
    //         HrSetup: Record "Human Resources Setup";
    //         SMSSetup: Record "SMS Setup";
    //         deliveryMsg: Boolean;
    //         alertmsg: Boolean;
    //         XmlHttp: Automation ;
    //         XmlDoc: Automation ;
    //         XmlNode: Automation ;
    //         CurrErrorMsg: Text[80];
    //         GlobalNumber: Text[50];
    //         GlobalText: Text[160];
    //         GlobalSender: Text[80];
    //         SMTP: Codeunit "SMTP Mail";
    //         Text001: label 'SMS Successfully Sent';
    //         UrlForERP: Text;
    //         SmsMessage: Text;


    //     procedure SendURLSMS(var LocalMobile: Text[80];var LocalText: Text[160];var LocalSender: Text[100]): Text[80]
    //     begin
    //         SMSSetup.Get;
    //         SMSSetup.TestField(SMSSetup."URL SMS User ID");
    //         SMSSetup.TestField(SMSSetup."URL SMS Password");


    //         if ISCLEAR(XmlDoc) then
    //         Create(XmlDoc,false,true);

    //         if ISCLEAR(XmlHttp) then
    //         Create(XmlHttp,false,true);

    //         //********* Using New URL
    //         XmlHttp.open('POST',
    //         'http://api2.infobip.com/api/sendsms/plain?user='+ SMSSetup."URL SMS User ID" + '&password=' + SMSSetup."URL SMS Password" +
    //         '&sender='+ LocalSender +'&SMSText='+ LocalText +
    //         '&IsFlash=0&GSM='+ LocalMobile,0);



    //         XmlHttp.setRequestHeader('Content-Type', 'text/xml; charset=utf-8');

    //         XmlHttp.setTimeouts(10000,10000,0,0);

    //         XmlHttp.send;

    //         //************ Get Error description if any
    //         CurrErrorMsg := '';

    //         CurrErrorMsg := GetErrorDescription;
    //         Clear(XmlDoc);
    //         Clear(XmlHttp);
    //         exit(CurrErrorMsg);
    //     end;


    //     procedure GetErrorDescription() ErrText: Text[50]
    //     begin
    //         case XmlHttp.responseText of

    //           '-1':begin
    //                  ErrText := 'SEND ERROR';
    //                end;
    //           '-2':begin
    //                  ErrText := 'NOT ENOUGH CREDITS';
    //                end;

    //           '-3':begin
    //                  ErrText := 'NETWORK NOT COVERED';
    //                end;

    //           '-4':begin
    //                  ErrText := 'SOCKET EXCEPTION';
    //                end;

    //           '-5':begin
    //                  ErrText := 'INVALID USER OR PASSWORD';
    //                end;

    //           '-6':begin
    //                  ErrText := 'MISSING DESTINATION ADDRESS';
    //                end;

    //           '-7':begin
    //                  ErrText := 'MISSING SMS TEXT';
    //                end;

    //           '-8':begin
    //                  ErrText := 'MISSING SENDER NAME';
    //                end;

    //           '-9':begin
    //                  ErrText := 'DESTINATION ADDRESS IS INVALID';
    //                end;

    //           '-10':begin
    //                  ErrText := 'MISSING USERNAME';
    //                 end;

    //           '-11':begin
    //                   ErrText := 'MISSING PASSWORD';
    //                 end;

    //           '-12':begin
    //                   ErrText := '-12';
    //                 end;

    //           '-13':begin
    //                   ErrText := '-13';
    //                 end;

    //         end;/*end case*/

    //     end;


    //     procedure SendEmailAsSMS(var Sender: Text[80];var Recipient: Text[80];var Subject: Text[80];var Body: Text[160])
    //     begin
    //         SMSSetup.Get;
    //         Subject := Subject + SMSSetup."Email SMS Password";
    //         SMTP.CreateMessage(Sender,SMSSetup."Email SMS ID",Recipient,Subject,Body,false);
    //         SMTP.Send;

    //         Message(Text001);
    //     end;


    //     procedure CheckPathFormat(FilePath: Text) NewFilePath: Text
    //     var
    //         PathLength: Integer;
    //         SlashPosition: Integer;
    //         LastChar: Text;
    //     begin
    //         if FilePath = '' then
    //           Error('File path must contain a value');
    //         PathLength:= StrLen(FilePath);
    //         LastChar := CopyStr(FilePath,PathLength,1);
    //         //ERROR(STRSUBSTNO(LastChar));
    //         if LastChar = '\' then
    //           NewFilePath := FilePath
    //         else
    //           NewFilePath:= FilePath +'\';
    //         exit(NewFilePath);
    //     end;


    procedure SendTestSMS(ReceiverMobilePhone: Text; var DeliveryStatus: Text)
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
    begin
        // TestSMSSetup;
        // SMSSetup.Get;
        // SendSmS(SMSSetup."SMS Sender",ReceiverMobilePhone,SMSSetup."Test Message",SMSSetup."SMS URL",SMSSetup."URL SMS User ID",SMSSetup."URL SMS Password",DeliveryStatus);
    end;


    procedure PromptAndSendSms(): Text
    var
        SMTPUserSpecifiedAddress: Page "SMTP User-Specified Address";
        ReceiversMobilePhoneNumber: Text;
        DeliveryStatus: Text;
    begin
        Clear(SMTPUserSpecifiedAddress);
        SMTPUserSpecifiedAddress.Caption('Specify Receivers Mobile Phone Number');
        SMTPUserSpecifiedAddress.SetImputMobilePhone;
        if SMTPUserSpecifiedAddress.RunModal = Action::OK then begin
            ReceiversMobilePhoneNumber := SMTPUserSpecifiedAddress.GetMobilePhoneNumber;
            if ReceiversMobilePhoneNumber = '' then
                exit;
            SendTestSMS(ReceiversMobilePhoneNumber, DeliveryStatus);
            exit(DeliveryStatus);
        end;
    end;


    //     procedure TestSMSSetup()
    //     begin
    //         SMSSetup.Get;
    //         case SMSSetup."Send SMS By" of
    //           SMSSetup."send sms by"::URLSMS:
    //             begin
    //               SMSSetup.TestField("SMS Sender");
    //               SMSSetup.TestField("SMS URL");
    //               SMSSetup.TestField("Test Message");
    //               SMSSetup.TestField("URL SMS Password");
    //               SMSSetup.TestField("URL SMS User ID");
    //             end;
    //           SMSSetup."send sms by"::EMailSMS:
    //             begin
    //               SMSSetup.TestField("Email SMS Extension");
    //               SMSSetup.TestField("Email SMS ID");
    //               SMSSetup.TestField("Email SMS Password");
    //             end;
    //         end;
    //     end;


    //     procedure SendSmS(Sender: Text;Receiver: Text;MessageToSend: Text;SmSPortalURL: Text;SmSUrlUserID: Text;SmsUrlPswrd: Text;var DeliveryStatus: Text): Boolean
    //     var
    //         XmlHttp: Automation ;
    //         Windows: Dialog;
    //         RequestBody: Text;
    //         ResponsText: Text;
    //         SelectTokenParam: Text;
    //         GetValueParam: Text;
    //         ExpectedGetvalueResult: Text;
    //         SelectedJsonList: dotnet JArray;
    //         SelectedJsonRec: dotnet JObject;
    //         result: Text;
    //         JObject: dotnet JObject;
    //         JToken: dotnet JToken;
    //     begin
    //         Windows.Open('Please Wait...');

    //         if ISCLEAR(XmlDoc) then
    //           Create(XmlDoc,false,true);
    //         if ISCLEAR(XmlHttp) then
    //           Create(XmlHttp,false,true);
    //         RequestBody:= 'username='+SmSUrlUserID+'&password='+SmsUrlPswrd+'&sender='+Sender+'&message='+MessageToSend+'&recipients='+Receiver;
    //         XmlHttp.open('GET',SmSPortalURL+RequestBody,false);
    //         XmlHttp.setTimeouts(300000,300000,300000,300000);
    //         XmlHttp.send(RequestBody);
    //         ResponsText:= XmlHttp.responseText;
    //         //MESSAGE('This is raw '+ResponsText);
    //         SelectTokenParam:='message';
    //         GetValueParam:='error';
    //         ExpectedGetvalueResult:='False';

    //         JObject:= JObject.JObject;
    //         JObject := JToken.Parse(ResponsText);
    //         result := JObject.GetValue(GetValueParam).ToString;

    //         if  (result = ExpectedGetvalueResult) then
    //           DeliveryStatus:= JObject.GetValue(SelectTokenParam).ToString
    //         else
    //           DeliveryStatus:= ResponsText;

    //         Windows.Close;
    //         exit(result = ExpectedGetvalueResult);
    //     end;


    //     procedure PromptAndGetSmsMessage(): Text
    //     var
    //         SMTPUserSpecifiedAddress: Page "SMTP User-Specified Address";
    //         SmsMessageToSend: Text;
    //     begin
    //         Clear(SMTPUserSpecifiedAddress);
    //         SMTPUserSpecifiedAddress.Caption('Imput the Sms message to send');
    //         SMTPUserSpecifiedAddress.SetImputSmsMessage;
    //         if SMTPUserSpecifiedAddress.RunModal = Action::OK then begin
    //           SmsMessageToSend := SMTPUserSpecifiedAddress.GetSmsMessage;
    //           if SmsMessageToSend = '' then
    //             exit;
    //           exit(SmsMessageToSend);
    //         end;
    //     end;


    procedure ResolveBVN_ReturnPlusPhoneNumber(var Firstname: Text; var Lastname: Text; var Phonenumber: Text; var Dateofbirth: Text; BVN: Text; ResolveBVN_API: Text; BearerSecretKey: Text; ResolveBVN_API_Method: Text): Boolean
    var
    //         XmlHttp: Automation ;
    //         Windows: Dialog;
    //         RequestBody: Text;
    //         ResponsText: Text;
    //         SelectTokenParam: Text;
    //         GetValueParam: Text;
    //         ExpectedGetvalueResult: Text;
    //         SelectedJsonList: dotnet JArray;
    //         SelectedJsonRec: dotnet JObject;
    //         ReturnedBvn: Text;
    //         result: Text;
    //         JObject: dotnet JObject;
    //         JToken: dotnet JToken;
    //         TypeHelper: Codeunit "Type Helper";
    begin
        //         Windows.Open('Please Wait...');

        //         if ISCLEAR(XmlDoc) then
        //           Create(XmlDoc,false,true);
        //         if ISCLEAR(XmlHttp) then
        //           Create(XmlHttp,false,true);
        //         RequestBody:= BVN;
        //         XmlHttp.open('GET',ResolveBVN_API+ResolveBVN_API_Method+RequestBody,false);
        //         XmlHttp.setRequestHeader('Authorization:', 'Bearer '+BearerSecretKey);
        //         XmlHttp.setTimeouts(300000,300000,300000,300000);
        //         XmlHttp.send();
        //         ResponsText:= XmlHttp.responseText;
        //         /*//Use for testing
        //         ResponsText:='{'+
        //           '"status": true,'+
        //           '"message": "BVN resolved",'+
        //           '"data": {'+
        //             '"first_name": "evans",'+
        //             '"last_name": "sajere",'+
        //             '"dob": "29-Aug-84",'+
        //             '"formatted_dob": "1984-08-29",'+
        //             '"mobile": "07037172652",'+
        //             '"bvn": "22258477205"'+
        //           '},'+
        //           '"meta": {'+
        //             '"calls_this_month": 1,'+
        //             '"free_calls_left": 9'+
        //           '}'+
        //         '}';
        //         */
        //         SelectTokenParam:='data';
        //         GetValueParam:='message';
        //         ExpectedGetvalueResult:='BVN resolved';
        //         JObject:= JObject.JObject;
        //         JObject := JToken.Parse(ResponsText);
        //         result := JObject.GetValue(GetValueParam).ToString;

        //         if  (result = ExpectedGetvalueResult) then
        //           begin
        //             SelectedJsonRec := JObject.SelectToken(SelectTokenParam);
        //             Firstname:= SelectedJsonRec.GetValue('first_name').ToString;
        //             Lastname:= SelectedJsonRec.GetValue('last_name').ToString;
        //             Dateofbirth:= SelectedJsonRec.GetValue('dob').ToString;
        //             Phonenumber:= SelectedJsonRec.GetValue('mobile').ToString;
        //             if StrLen(Phonenumber)<>13 then
        //               Phonenumber:= '234'+DelStr(Phonenumber,1,1);
        //             ReturnedBvn:= SelectedJsonRec.GetValue('bvn').ToString;
        //             exit(true);
        //           end
        //           else
        //            exit(false);
        //         Windows.Close;

    end;

    //     local procedure ReadJsonResponse(RawJsonText: Text;SelectTokenParam: Text;GetValueParam: Text;ExpectedGetvalueResult: Text;SelectedJsonList: dotnet JArray;SelectedJsonRec: dotnet JObject)
    //     var
    //         Windows: Dialog;
    //         result: Text;
    //         JObject: dotnet JObject;
    //         JToken: dotnet JToken;
    //     begin
    //         JObject:= JObject.JObject;
    //         JObject := JToken.Parse(RawJsonText);
    //         result := JObject.GetValue(GetValueParam).ToString;
    //         Message(result);
    //         if  (result = ExpectedGetvalueResult) then
    //           begin
    //             SelectedJsonList := JObject.SelectToken(SelectTokenParam);
    //             Message(SelectedJsonList.ToString);
    //           end;
    //     end;


    procedure PromptAndInputBVN(): Text
    var
        SMTPUserSpecifiedAddress: Page "SMTP User-Specified Address";
        BVN_to_Resolve: Text;
    begin
        Clear(SMTPUserSpecifiedAddress);
        SMTPUserSpecifiedAddress.Caption('Imput the BVN to resolve');
        SMTPUserSpecifiedAddress.SetBVN;
        if SMTPUserSpecifiedAddress.RunModal = Action::OK then begin
            BVN_to_Resolve := SMTPUserSpecifiedAddress.GetBVNtoReolve;
            if BVN_to_Resolve = '' then
                exit;
            exit(BVN_to_Resolve);
        end;
    end;
}

