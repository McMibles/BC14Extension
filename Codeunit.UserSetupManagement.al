Codeunit 52005700 "User Setup Management5700"
{

    trigger OnRun()
    begin

        //  OBJECT Modification "User Setup Management"(Codeunit 5700)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=04242020D;
        //      Time=152809T;
        //      Modified=Yes;
        //      Version List=NAVW114.04;
        //    }
        //    PROPERTIES
        //    {
        //      Target="User Setup Management"(Codeunit 5700);
        //    }
        //    CHANGES
        //    {
        //      { Insertion         ;InsertAfter=OnBeforeIsPostingDateValidWithSetup(PROCEDURE 20);
        //                           ChangedElements=PROCEDURECollection
        //                           {
    end;

    PROCEDURE GetTreasuryFilter(): Code[10];
    BEGIN
        //EXIT(GetTreasuryFilter2(USERID));
    END;
    //  
    //                             PROCEDURE GetTreasuryFilter2@24(UserCode@1000 : Code[50]) : Code[10];
    //                             BEGIN
    //                               IF NOT HasGotTreaUserSetup THEN BEGIN
    //                                 CompanyInfo.GET;
    //                                 TreaUserRespCenter := CompanyInfo."Responsibility Center";
    //                                 UserLocation := CompanyInfo."Location Code";
    //                                 IF UserSetup.GET(UserCode) AND (UserCode <> '') THEN
    //                                   IF UserSetup."Treasury Resp. Ctr Filter" <> '' THEN
    //                                     TreaUserRespCenter := UserSetup."Treasury Resp. Ctr Filter";
    //                                 HasGotTreaUserSetup := TRUE;
    //                               END;
    //                               EXIT(TreaUserRespCenter);
    //                             END;
    //  
    //                             PROCEDURE GetFloatFilter@23() : Code[10];
    //                             BEGIN
    //                               EXIT(GetFloatFilter2(USERID));
    //                             END;
    //  
    //                             PROCEDURE GetFloatFilter2@21(UserCode@1000 : Code[50]) : Code[10];
    //                             BEGIN
    //                               IF NOT HasGotFloatUserSetup THEN BEGIN
    //                                 CompanyInfo.GET;
    //                                 FloatUserRespCenter := CompanyInfo."Responsibility Center";
    //                                 UserLocation := CompanyInfo."Location Code";
    //                                 IF UserSetup.GET(UserCode) AND (UserCode <> '') THEN
    //                                   IF UserSetup."Float Resp. Ctr Filter" <> '' THEN
    //                                     FloatUserRespCenter := UserSetup."Float Resp. Ctr Filter";
    //                                 HasGotFloatUserSetup := TRUE;
    //                               END;
    //                               EXIT(FloatUserRespCenter);
    //                             END;
    //  
    //                           }
    //                            }
    //      { Insertion         ;InsertAfter=ServUserRespCenter(Variable 1007);
    //                           ChangedElements=VariableCollection
    //                           {
    //                             TreaUserRespCenter@52092134 : Code[10];
    //                             FloatUserRespCenter@52092135 : Code[10];
    //                           }
    //                            }
    //      { Insertion         ;InsertAfter=PostingDateRangeErr(Variable 1018);
    //                           ChangedElements=VariableCollection
    //                           {
    //                             HasGotTreaUserSetup@52092132 : Boolean;
    //                             HasGotFloatUserSetup@52092133 : Boolean;
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

    //end;
}

