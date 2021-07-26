PageExtension 52000034 pageextension52000034 extends "SMTP User-Specified Address" 
{
    layout
    {

        //Unsupported feature: Property Insertion (Visible) on "EmailAddressField(Control 3)".

        addafter(EmailAddressField)
        {
            field(PeriodStartDate;PeriodStartDate)
            {
                ApplicationArea = Basic;
                Caption = 'Period Start Date';
                Visible = UseForTnAStartDate;
            }
            field(PeriodLenght;PeriodLenght)
            {
                ApplicationArea = Basic;
                Caption = 'Period Length';
                Visible = UseForTnAStartDate;
            }
            field(MobilePhoneNumberField;PhonNumber)
            {
                ApplicationArea = Basic;
                Caption = 'Mobile Phone Number';
                ExtendedDatatype = PhoneNo;
                Visible = ShowPhonNumber;

                trigger OnValidate()
                begin
                    if StrLen(PhonNumber)<> StrLen('2349054711004') then
                      Error('Mobil phone number must be %1',StrLen('2349054711004'));
                end;
            }
            field(SmsMessageField;MessageBody)
            {
                ApplicationArea = Basic;
                Caption = 'Sms Message';
                Visible = ShowMessageBody;
            }
            field(BVNInputField;BVNInput)
            {
                ApplicationArea = Basic;
                Caption = 'Input BVN to resolve';
                Visible = ShowBVNInput;
            }
        }
    }

    var
        PeriodStartDate: Date;
        PeriodLenght: DateFormula;
        UseForEmailAddress: Boolean;
        UseForTnAStartDate: Boolean;
        PhonNumber: Text;
        ShowPhonNumber: Boolean;
        MessageBody: Text;
        ShowBVNInput: Boolean;
        BVNInput: Text;
        ShowMessageBody: Boolean;


    //Unsupported feature: Code Insertion on "OnOpenPage".

    //trigger OnOpenPage()
    //begin
        /*
        IF (ShowBVNInput = FALSE) AND (ShowMessageBody=FALSE) AND(ShowPhonNumber=FALSE)AND (UseForTnAStartDate=FALSE)THEN
          UseForEmailAddress:= TRUE;
        */
    //end;

    procedure GetPeriodStartDate(var MyStartDate: Date;var MyPeriodLenght: DateFormula)
    begin
        MyStartDate:= PeriodStartDate;
        MyPeriodLenght:=PeriodLenght;
    end;

    procedure SetPeriodStartDate()
    begin
        UseForTnAStartDate:= true;
        ShowBVNInput:= false;
        UseForEmailAddress:=false;
        ShowMessageBody:= false;
        ShowPhonNumber:= false;
    end;

    procedure SetImputMobilePhone()
    begin
        ShowBVNInput:= false;
        UseForEmailAddress:=false;
        ShowMessageBody:= false;
        ShowPhonNumber:= true;
        UseForTnAStartDate:= false;
    end;

    procedure GetMobilePhoneNumber(): Text
    begin
        exit(PhonNumber);
    end;

    procedure SetImputSmsMessage()
    begin
        ShowBVNInput:= false;
        UseForEmailAddress:=false;
        ShowMessageBody:=true;
        ShowPhonNumber:= false;
        UseForTnAStartDate:= false;
    end;

    procedure GetSmsMessage(): Text
    begin
        exit(MessageBody);
    end;

    procedure SetBVN()
    begin
        ShowBVNInput:= true;
        UseForEmailAddress:=false;
        ShowMessageBody:= false;
        ShowPhonNumber:= true;
        UseForTnAStartDate:= false;
    end;

    procedure GetBVNtoReolve(): Text
    begin
        exit(BVNInput);
    end;
}

