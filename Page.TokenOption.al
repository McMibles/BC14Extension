Page 52092131 "Token Option"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ConfirmationDialog;

    layout
    {
        area(content)
        {
            field(TokenType;TokenType)
            {
                ApplicationArea = Basic;
                Caption = 'Token Type';
            }
        }
    }

    actions
    {
    }

    var
        TokenType: Option SMS,EMail,TOTP,HOTP;


    procedure ReturnInfo(var TType: Option SMS,EMail,TOTP,HOTP)
    begin
        TType := TokenType;
    end;
}

