Page 52092193 "Pension Administrators"
{
    PageType = List;
    SourceTable = "Pension Administrator";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name; Name)
                {
                    ApplicationArea = Basic;
                }
                field(PFACode; "PFA Code")
                {
                    ApplicationArea = Basic;
                }
                field(PFCustodian; "PF Custodian")
                {
                    ApplicationArea = Basic;
                }
                field(CBNBankCode; "CBN Bank Code")
                {
                    ApplicationArea = Basic;
                }
                field(ReceivingBank; "Receiving Bank")
                {
                    ApplicationArea = Basic;
                }
                field(ReceivingAccount; "Receiving Account")
                {
                    ApplicationArea = Basic;
                }
                field(ReceivingAccountName; "Receiving Account Name")
                {
                    ApplicationArea = Basic;
                }
                field(Address; Address)
                {
                    ApplicationArea = Basic;
                }
                field(PhoneNumber; "Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field(EMailAddressOfPFA; "E-Mail Address Of PFA")
                {
                    ApplicationArea = Basic;
                }
                field(MailBodyFile; "Mail Body File")
                {
                    ApplicationArea = Basic;
                    Description = 'This specifies thefile that contains the content of the body of mail to send.';
                    Editable = false;
                    ExtendedDatatype = URL;
                    ToolTip = 'This specifies thefile that contains the content of the body of mail to send.';
                }
                field(CcMailAddresses; "Cc Mail Addresses")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update mail body file")
            {
                ApplicationArea = Basic;
                Image = Link;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Clear(ServerFileName);
                    if ServerFileName = '' then
                        ServerFileName := FileMgt.OpenFileDialog('Select mandate', ServerFileName, '*.txt|');

                    if ServerFileName <> '' then
                        CopyPath(ServerFileName);
                end;
            }
        }
    }

    var
        UpdateBodyOfMail: Boolean;
        ServerFileName: Text;
        FileMgt: Codeunit "File Management";


    procedure CopyPath(UserFilePath: Text)
    var

    begin

    end;
    /*    var
            CashLiteSetup: Record "CashLite Setup";
            FileManagement: Codeunit "File Management";
            FileRec: Record File;
            RecordLinkRec: Record "Record Link";
        begin
            CashLiteSetup.Get;
            CashLiteSetup.TestField("Mail Body File Path");
              if UserFilePath<>''  then begin
                FileManagement.CopyClientFile(UserFilePath,AddBackSlash(CashLiteSetup."Mail Body File Path")+FileManagement.GetFileName(UserFilePath),true);
                Rec.Validate("Mail Body File",AddBackSlash(CashLiteSetup."Mail Body File Path")+FileManagement.GetFileName(UserFilePath));
                Rec.Modify;
              end;
        end;

    */
    procedure AddBackSlash(MyPath: Text): Text
    var
        MyPathLength: Integer;
        LastBackSlachPostion: Integer;
    begin
        MyPathLength := StrLen(MyPath);
        if '\' = CopyStr(MyPath, MyPathLength, 1) then
            exit(MyPath)
        else
            exit(MyPath + '\');
    end;
}

