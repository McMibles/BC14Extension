Table 52092130 "Random OTP Approval Setup"
{

    fields
    {
        field(1; "Table ID"; Integer)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(2; "Table Name"; Text[50])
        {
            CalcFormula = lookup(Field.TableName where(TableNo = field("Table ID")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Dimension; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Minimum Amount (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Last Date Modified"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Modified By"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(10; Enable; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "OTP Valid Duration"; Duration)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Table ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        "Modified By" := UserId;
    end;


    procedure GenerateRandomOTP(MaxNum: Integer; var TimeGenerated: Time): Integer
    begin
        TimeGenerated := Time;
        exit(Random(MaxNum));
    end;


    procedure OTPApprovalRequired(MyTableID: Integer; Amount: Decimal): Boolean
    var
        RandomOTPApprovalSetup: Record "Random OTP Approval Setup";
    begin
        RandomOTPApprovalSetup.Reset;
        if RandomOTPApprovalSetup.Get(MyTableID) then
            exit((RandomOTPApprovalSetup.Enable) and (RandomOTPApprovalSetup."Minimum Amount (LCY)" <= Amount))
        else
            exit(false);
    end;


    procedure MatchOTPInput(ApprovalEntryNo: Integer; InputedOTPValue: Integer): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Get(ApprovalEntryNo);
        exit(ApprovalEntry."Random OTP" = InputedOTPValue);
    end;


    procedure OTPRequestInputForm(ApprovalEntryId: Integer; DisplayedText: Text): Integer
    var
        // [RunOnClient]
        // ImputMsg: dotnet Interaction;
        UserRecievedOTPTex: Text;
        UserRecievedOTP: Integer;
    begin
        // UserRecievedOTPTex:= ImputMsg.InputBox(DisplayedText,'OTP Additional Approval Required','',500,300);
        Evaluate(UserRecievedOTP, UserRecievedOTPTex);
    end;


    procedure SendOTPViaSmS(ApprovalEntryNo: Integer; OTPValue: Integer; OTPGenerateTime: Time; var DeliveryStatus: Text; var MessageToSendWithoutOTP: Text) Status: Boolean
    var
        SMSSetup: Record "SMS Setup";
        // SendSMS: Codeunit "Send SMS";
        Tx001: label 'A Pending Debit of %1 %2 on Document %3. Use %4 as your One Time Password';
        MobilePhoneNo: Text;
        DocumentNo: Code[20];
        Description: Text;
        ApprovalEntryRec: Record "Approval Entry";
        RandomOTPApprovalSetup: Record "Random OTP Approval Setup";
        MessageToSend: Text;
        Tx002: label 'A Pending Debit of %1 %2 on Document %3. Use ther One Time Password sent to you.';
    begin
        ApprovalEntryRec.Get(ApprovalEntryNo);
        RandomOTPApprovalSetup.Get(ApprovalEntryRec."Table ID");
        MessageToSendWithoutOTP := StrSubstNo(Tx002, ApprovalEntryRec."Currency Code", ApprovalEntryRec.Amount,
                        ApprovalEntryRec."Document No.", OTPGenerateTime + RandomOTPApprovalSetup."OTP Valid Duration");

        MessageToSend := StrSubstNo(Tx001, ApprovalEntryRec."Currency Code", ApprovalEntryRec.Amount,
                        ApprovalEntryRec."Document No.", OTPValue);

        SMSSetup.Get;
        // Status := SendSMS.SendSmS(SMSSetup."SMS Sender", ApprovalEntryRec."Mobile Phone No", MessageToSend, SMSSetup."SMS URL", SMSSetup."URL SMS User ID", SMSSetup."URL SMS Password", DeliveryStatus);

        exit(Status);
    end;


    procedure GetMobilNo(userId: Code[20]): Text
    var
        UserSetup: Record "User Setup";
        EmployeeRec: Record Employee;
    begin
        UserSetup.Get(userId);
        if EmployeeRec.Get(UserSetup."Employee No.") then
            exit(EmployeeRec."Mobile Phone No.");
    end;

    local procedure CheckIfOTP_Still_Valid(TimeGenerated: Time; MaxDuration: Duration): Boolean
    begin
        exit((Time - TimeGenerated) <= MaxDuration);
    end;
}

