Page 52092136 "Mobile Approval Setup"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Mobile Approval Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Baseurl;"Base url")
                {
                    ApplicationArea = Basic;
                }
                field(SendApprovalRequestMethod;"Send Approval Request Method")
                {
                    ApplicationArea = Basic;
                }
                field(EnforceMultiFactAuth;"Enforce Multi. Fact. Auth")
                {
                    ApplicationArea = Basic;
                }
                field(SameEMailonUserSetup;"Same E-Mail on User Setup")
                {
                    ApplicationArea = Basic;
                }
                field(MobileApprovalAdministrator;"Mobile Approval Administrator")
                {
                    ApplicationArea = Basic;
                }
                field(LogInUserName;"Log In User Name")
                {
                    ApplicationArea = Basic;
                }
                field(Password;Password)
                {
                    ApplicationArea = Basic;
                }
                field(GetTokenMethod;"Get Token Method")
                {
                    ApplicationArea = Basic;
                }
                field(TenantID;TenantID)
                {
                    ApplicationArea = Basic;
                }
                field(LoginHttpRequestType;"Login Http Request Type")
                {
                    ApplicationArea = Basic;
                }
                field(MultiFactorAuthPIN;"Multi Factor Auth PIN")
                {
                    ApplicationArea = Basic;
                }
                field(MultiFactorAuthPINToPrior;"Multi Factor Auth PIN To Prior")
                {
                    ApplicationArea = Basic;
                }
                field(TempFolderPath;"Temp Folder Path")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7;Links)
            {
            }
            systempart(Control8;MyNotes)
            {
            }
            systempart(Control9;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Users)
            {
                ApplicationArea = Advanced;
                Caption = 'Users';
                Image = Users;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Mobile Approval User Setup";
                ToolTip = 'Set up the employees who will approve document in this company from thier E-Mail';
            }
            action(SMTPMailSetup)
            {
                ApplicationArea = Advanced;
                Caption = 'SMTP Mail Setup';
                Image = MailSetup;
                RunObject = Page "SMTP Mail Setup";
                ToolTip = 'Set up the integration and security of the mail server at your site that handles email.';
            }
            action(ReportsForMobileDocumentView)
            {
                ApplicationArea = Advanced;
                Caption = 'Reports For Mobile Document View';
                Image = Users;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Mobile Approval Document Map";
                ToolTip = 'Set up the reports that will be used to by mobile approvals to view the document from thier E-Mail';
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

