Codeunit 52000040 LogInManagement40
{

    trigger OnRun()
    begin

        //  OBJECT Modification LogInManagement(Codeunit 40)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=08102020D;
        //      Time=142126T;
        //      Modified=Yes;
        //      Version List=NAVW114.05;
        //    }
        //    PROPERTIES
        //    {
        //      Target=LogInManagement(Codeunit 40);
        //    }
        //    CHANGES
        //    {
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          LogonManagement.SetLogonInProgress(TRUE);
        //  
        //                                          // This needs to be the very first thing to run before company open
        //                                          #4..8
        //                                          IF GUIALLOWED AND (ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::Background) THEN
        //                                            LogInStart;
        //  
        //                                          OnAfterCompanyOpen;
        //  
        //                                          LogonManagement.SetLogonInProgress(FALSE);
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..11
        //                                          IF (TokenSetup.GET)  THEN BEGIN
        //                                            IF ((CURRENTCLIENTTYPE = CLIENTTYPE::Windows) AND TokenSetup."Windows Client") OR ((CURRENTCLIENTTYPE = CLIENTTYPE::Web) AND TokenSetup."Web Client") OR
        //                                                ((CURRENTCLIENTTYPE = CLIENTTYPE::Phone) OR (CURRENTCLIENTTYPE = CLIENTTYPE::Tablet) AND TokenSetup."Mobile App Client") THEN BEGIN
        //  
        //                                              IF TokenSetup."Use Token Login" THEN BEGIN
        //                                                UserSetup.GET(USERID);
        //                                                IF NOT(UserSetup."Disable Token Authentication") THEN
        //                                                  TokenAuthenticator.RUN;
        //                                              END;
        //                                            END;
        //                                          END;
        //  
        //  
        //                                          #12..14
        //                                        END;
        //  
        //                           Target=CompanyOpen(PROCEDURE 1) }
        //      { Insertion         ;InsertAfter=GLSetupRead(Variable 1012);
        //                           ChangedElements=VariableCollection
        //                           {
        //                             TokenSetup@1008 : Record "Token Setup";
        //                             TokenAuthenticator@1002 : Codeunit "Token Authenticator";
        //                             UserSetup@1000 : Record "User Setup";
        //                           }
        //                            }
        //    }
        //    CODE
        //    {
        //  
        //      BEGIN
        //      END.
        //    }
        //  }
        //  
        //  

    end;
}

