Codeunit 52001751 "Data Classification Eval.1751"
{

    trigger OnRun()
    begin

        //  OBJECT Modification "Data Classification Eval. Data"(Codeunit 1751)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=04272020D;
        //      Time=115617T;
        //      Modified=Yes;
        //      Version List=NAVW114.01;
        //    }
        //    PROPERTIES
        //    {
        //      Target="Data Classification Eval. Data"(Codeunit 1751);
        //    }
        //    CHANGES
        //    {
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          ClassifyCreditTransferEntry;
        //                                          ClassifyActiveSession;
        //                                          ClassifyRegisteredInvtMovementHdr;
        //                                          #4..60
        //                                          ClassifyWorkflowStepInstance;
        //                                          ClassifyWorkCenter;
        //                                          ClassifyCampaignEntry;
        //                                          ClassifySession;
        //                                          ClassifyIsolatedStorage;
        //                                          ClassifyNavAppSetting;
        //                                          ClassifyPurchaseLineArchive;
        //                                          #68..95
        //                                          ClassifyICInboxPurchaseHeader;
        //                                          ClassifyICInboxSalesHeader;
        //                                          ClassifyHandledICOutboxPurchHdr;
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..63
        //                                          //ClassifySession;
        //                                          #65..98
        //                                        END;
        //  
        //                           Target=ClassifyTablesPart1(PROCEDURE 234) }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          SetTableFieldsToNormal(DATABASE::"Payment Terms");
        //                                          SetTableFieldsToNormal(DATABASE::Currency);
        //                                          SetTableFieldsToNormal(DATABASE::"Finance Charge Terms");
        //                                          #4..76
        //                                          SetTableFieldsToNormal(DATABASE::"Requisition Wksh. Name");
        //                                          SetTableFieldsToNormal(DATABASE::"Intrastat Setup");
        //                                          SetTableFieldsToNormal(DATABASE::"VAT Reg. No. Srv Config");
        //                                          SetTableFieldsToNormal(DATABASE::"VAT Reg. No. Srv. Template");
        //                                          SetTableFieldsToNormal(DATABASE::"Gen. Business Posting Group");
        //                                          SetTableFieldsToNormal(DATABASE::"Gen. Product Posting Group");
        //                                          SetTableFieldsToNormal(DATABASE::"General Posting Setup");
        //                                          #84..103
        //                                          SetTableFieldsToNormal(DATABASE::"Job Journal Quantity");
        //                                          SetTableFieldsToNormal(DATABASE::"Custom Address Format");
        //                                          SetTableFieldsToNormal(DATABASE::"Custom Address Format Line");
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..79
        //                                          #81..106
        //                                        END;
        //  
        //                           Target=ClassifyTablesToNormalPart1(PROCEDURE 232) }
        //      { Deletion          ;Target=ClassifyVATRegistrationLog(PROCEDURE 157).DummyVATRegistrationLogDetails(Variable 1001);
        //                           ChangedElements=VariableCollection
        //                           {
        //                             DummyVATRegistrationLogDetails@1001 : Record "VAT Registration Log Details";
        //                           }
        //                            }
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          TableNo := DATABASE::"VAT Registration Log";
        //                                          SetTableFieldsToNormal(TableNo);
        //                                          SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("Verified City"));
        //                                          #4..7
        //                                          SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("User ID"));
        //                                          SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("Country/Region Code"));
        //                                          SetFieldToPersonal(TableNo,DummyVATRegistrationLog.FIELDNO("VAT Registration No."));
        //  
        //                                          TableNo := DATABASE::"VAT Registration Log Details";
        //                                          SetTableFieldsToNormal(TableNo);
        //                                          SetFieldToPersonal(TableNo,DummyVATRegistrationLogDetails.FIELDNO(Requested));
        //                                          SetFieldToPersonal(TableNo,DummyVATRegistrationLogDetails.FIELDNO(Response));
        //                                          SetFieldToPersonal(TableNo,DummyVATRegistrationLogDetails.FIELDNO("Current Value"));
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          #1..10
        //                                        END;
        //  
        //                           Target=ClassifyVATRegistrationLog(PROCEDURE 157) }
        //      { PropertyModification;
        //                           Property=Version List;
        //                           OriginalValue=NAVW114.19;
        //                           ModifiedValue=NAVW114.01 }
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

