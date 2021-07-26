Table 52092308 "CashLite Setup"
{
    Caption = 'CashLite Setup';

    fields
    {
        field(1;"Primary Key";Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2;"Batch No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(3;"Reference No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(4;"Temporary Folder";Text[250])
        {
        }
        field(5;"Cash Lite Url";Text[250])
        {
            Description = 'GEMS';
        }
        field(6;TerminalId;Code[10])
        {
        }
        field(7;SponsorCode;Code[10])
        {
        }
        field(8;TransactionCode;Code[5])
        {
        }
        field(16;"Redirect Url";Text[250])
        {
        }
        field(17;"Webservice Url";Text[250])
        {
        }
        field(18;"CashLite Email";Text[100])
        {
        }
        field(19;Surcharge;Decimal)
        {
        }
        field(20;"Update Ledger";Boolean)
        {
        }
        field(21;"Client ID";Text[250])
        {
            ExtendedDatatype = Masked;
        }
        field(22;"Payment Platform";Option)
        {
            OptionCaption = 'Interswitch,NIBSS,UBA,Bank Branch,GEMS';
            OptionMembers = Interswitch,NIBSS,UBA,"Bank Branch",GEMS;
        }
        field(23;UserName;Text[30])
        {
        }
        field(24;Password;Text[50])
        {
        }
        field(25;"Single View Request No. Series";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(26;"Institution Code";Code[10])
        {
        }
        field(27;"Mail Body";Text[250])
        {
        }
        field(28;"Cashlite NIBBS Approval";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(29;"Auto Send Schedule On Approval";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30;"Get Payroll on Cashlite";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31;"Mail Body File Path";Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50000;"Auto Create Cashlite From PV";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008;"Delete Files After Upload";Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Created files in the Temporary Folder path';
        }
        field(52132405;"UBA CBA Stat. Max.Tran Count";Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52132406;"UBA Bal. API Processing Code";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52132407;"UBA Paymt API Processing Code";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52132408;"UBA Statmt API Processing Code";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52132409;"UBA CBS API Password";Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(52132410;"UBA CBA API User Name";Text[30])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(52132411;"UBA CBA API Url";Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(52132412;"Pen. Payroll URL";Text[250])
        {
        }
        field(52132414;"Nibss Max. Record Size Per Pag";Integer)
        {
        }
        field(52132415;"Use Gateway Base Url";Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Nibss Gateway Base Url");
                TestField("Nibss Schedule Size");
                TestField("Nibss Schedule Status Method");
                TestField("Nibss Create Schedule Method");
                TestField("Nibss CallBack Service");
                TestField("Nibss Update Schedule Method");
                TestField("Nibss Close And Process Sche");
                TestField("Nibss Re-query Status");
            end;
        }
        field(52132416;"Nibss CallBack Service";Text[250])
        {
        }
        field(52132417;"Nibss Re-query Status";Text[50])
        {
        }
        field(52132418;"Nibss Schedule Size";Text[50])
        {
        }
        field(52132419;"Nibss Schedule Status Method";Text[50])
        {
        }
        field(52132420;"Nibss Close And Process Sche";Text[50])
        {
        }
        field(52132421;"Nibss Update Schedule Method";Text[50])
        {
        }
        field(52132422;"Nibss Create Schedule Method";Text[50])
        {
        }
        field(52132423;"Nibss Gateway Base Url";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure SendCustomisedMail(FilePath: Text;FileName: Text;FileExtention: Text;SenderUserID: Code[50];RecipiantUserID: Code[50];RecipiantMailAddress: Text;AddCCMailAddresses: Text;Subject: Text;Body: Text)
    var
        SMTPMail: Codeunit "SMTP Mail";
        UserSetup: Record "User Setup";
        EmployeeRec: Record Employee;
        RecipiantFullName: Text;
        RecipiantMail: Text;
        SenderFullName: Text;
        CompanyInformation: Record "Company Information";
        SenderAddress: Text;
        AttachementFile: Text;
        RecipentMailToUse: Text;
        Windows: Dialog;
    begin
        AttachementFile:= '';
        if FilePath = ''  then
          Error('File name must have a value');
        if FileName = '' then
          Error('File path must have a value');
        if FileExtention = '' then
          Error('File extension must have a value');

        AttachementFile := FilePath+ FileName + FileExtention;

        RecipiantMail:= '';
        CompanyInformation.Get;
        UserSetup.Get(SenderUserID);
        EmployeeRec.Get(UserSetup."Employee No.");
        SenderFullName:= EmployeeRec.FullName;
        SenderAddress:= UserSetup."E-Mail";
        if UserSetup.Get(RecipiantUserID) then
          RecipiantMail:= UserSetup."E-Mail";

        if RecipiantMail = ''then
          RecipentMailToUse := RecipiantMailAddress
        else
          RecipentMailToUse := RecipiantMail;
        Windows.Open('Please wait, sending mail');
        SMTPMail.CreateMessage(CompanyInformation.Name,SenderAddress,RecipentMailToUse,Subject,Body,true);
        SMTPMail.AddAttachment(AttachementFile,FileName + FileExtention);
        if AddCCMailAddresses <>'' then
          SMTPMail.AddCC(AddCCMailAddresses);
        SMTPMail.Send;
        Windows.Close;
    end;


    procedure CheckPathFormat(FilePath: Text) NewFilePath: Text
    var
        PathLength: Integer;
        SlashPosition: Integer;
        LastChar: Text;
    begin
        if FilePath = '' then
          Error('File path must contain a value');
        PathLength:= StrLen(FilePath);
        LastChar := CopyStr(FilePath,PathLength,1);
        //ERROR(STRSUBSTNO(LastChar));
        if LastChar = '\' then
          NewFilePath := FilePath
        else
          NewFilePath:= FilePath +'\';
        exit(NewFilePath);
    end;
}

