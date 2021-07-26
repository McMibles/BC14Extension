Page 52092129 "SMS Setup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "SMS Setup";

    layout
    {
        area(content)
        {
            field(SendSMSBy; "Send SMS By")
            {
                ApplicationArea = Basic;
            }
            group("URL Setup")
            {
                field(SMSURL; "SMS URL")
                {
                    ApplicationArea = Basic;
                }
                field(URLSMSUserID; "URL SMS User ID")
                {
                    ApplicationArea = Basic;
                }
                field(URLSMSPassword; "URL SMS Password")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = Masked;
                }
                field(TestMessage; "Test Message")
                {
                    ApplicationArea = Basic;
                }
                field(SMSSender; "SMS Sender")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Email Setup")
            {
                field(EmailSMSID; "Email SMS ID")
                {
                    ApplicationArea = Basic;
                }
                field(EmailSMSPassword; "Email SMS Password")
                {
                    ApplicationArea = Basic;
                    ExtendedDatatype = Masked;
                }
                field(EmailSMSExtension; "Email SMS Extension")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Update Phone Number From BVN")
            {
                field(ResolveBVNUrl; "Resolve BVN Url")
                {
                    ApplicationArea = Basic;
                }
                field(ResolveBVNMethod; "Resolve BVN Method")
                {
                    ApplicationArea = Basic;
                }
                field(ResolveBVNBearerToken; "Resolve BVN BearerToken")
                {
                    ApplicationArea = Basic;
                }
                group("Resolve BVN Test")
                {
                    field(ResolveBVN; "Resolve BVN")
                    {
                        ApplicationArea = Basic;
                    }
                    field(ResolveBVNFirstName; "Resolve BVN First Name")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                    field(ResolveBVNLastName; "Resolve BVN Last Name")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                    field(ResolveBVNPhoneNumber; "Resolve BVN Phone Number")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                    field(ResolveDateOfBirth; "Resolve Date Of Birth")
                    {
                        ApplicationArea = Basic;
                        Editable = false;
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control18; Links)
            {
                Visible = false;
            }
            systempart(Control17; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendTestSms)
            {
                ApplicationArea = Basic;
                Caption = '&Test Sms Setup', Comment = '{Locked="&"}';
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Sends sms to the mobile phone number that is specified in the SMS Settings window.';

                trigger OnAction()
                var
                    SendSMS: Codeunit "Send SMS";
                begin
                    Message(SendSMS.PromptAndSendSms);
                end;
            }
            action("Test Get Phone Number")
            {
                ApplicationArea = Basic;
                Caption = '&Test Get Phone Number', Comment = '{Locked="&"}';
                Image = SendMail;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Sends BVN to an API call to return FirstName, LastName, Phone Number, Date Of Birth and BVN';

                trigger OnAction()
                var
                    SendSMS: Codeunit "Send SMS";
                    BVN: Text;
                begin
                    Clear("Resolve BVN First Name");
                    Clear("Resolve BVN Last Name");
                    Clear("Resolve BVN Phone Number");
                    Clear("Resolve Date Of Birth");
                    Clear("Resolve BVN");
                    BVN := SendSMS.PromptAndInputBVN;
                    "Resolve BVN" := BVN;
                    if BVN = '' then
                        exit;
                    //MESSAGE(BVN);
                    if SendSMS.ResolveBVN_ReturnPlusPhoneNumber("Resolve BVN First Name", "Resolve BVN Last Name",
                        "Resolve BVN Phone Number", "Resolve Date Of Birth", BVN, "Resolve BVN Url", "Resolve BVN BearerToken", "Resolve BVN Method") = true then
                        Modify;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
            Init;
            Insert;
        end;
    end;
}

