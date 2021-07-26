Codeunit 52000002 "Company-Initialize2"
{

    trigger OnRun()
    begin

        //  OBJECT Modification "Company-Initialize"(Codeunit 2)
        //  {
        //    OBJECT-PROPERTIES
        //    {
        //      Date=04262020D;
        //      Time=111053T;
        //      Modified=Yes;
        //      Version List=NAVW114.03;
        //    }
        //    PROPERTIES
        //    {
        //      Target="Company-Initialize"(Codeunit 2);
        //    }
        //    CHANGES
        //    {
        //      { CodeModification  ;OriginalCode=BEGIN
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOLBIS3_ElectronicFormatTxt,PEPPOLBIS3_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Exp. Sales Inv. PEPPOL BIS3.0",0,ElectronicDocumentFormat.Usage::"Sales Invoice");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOLBIS3_ElectronicFormatTxt,PEPPOLBIS3_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Exp. Sales CrM. PEPPOL BIS3.0",0,ElectronicDocumentFormat.Usage::"Sales Credit Memo");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOLBIS3_ElectronicFormatTxt,PEPPOLBIS3_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"PEPPOL Validation",0,ElectronicDocumentFormat.Usage::"Sales Validation");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOLBIS3_ElectronicFormatTxt,PEPPOLBIS3_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Exp. Serv.Inv. PEPPOL BIS3.0",0,ElectronicDocumentFormat.Usage::"Service Invoice");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOLBIS3_ElectronicFormatTxt,PEPPOLBIS3_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Exp. Serv.CrM. PEPPOL BIS3.0",0,ElectronicDocumentFormat.Usage::"Service Credit Memo");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOLBIS3_ElectronicFormatTxt,PEPPOLBIS3_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"PEPPOL Service Validation",0,ElectronicDocumentFormat.Usage::"Service Validation");
        //                                        END;
        //  
        //                           ModifiedCode=BEGIN
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Export Sales Inv. - PEPPOL 2.1",0,ElectronicDocumentFormat.Usage::"Sales Invoice");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Export Sales Cr.M. - PEPPOL2.1",0,ElectronicDocumentFormat.Usage::"Sales Credit Memo");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Export Serv. Inv. - PEPPOL 2.1",0,ElectronicDocumentFormat.Usage::"Service Invoice");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Exp. Service Cr.M. - PEPPOL2.1",0,ElectronicDocumentFormat.Usage::"Service Credit Memo");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        //                                          #11..13
        //                                            PEPPOL21_ElectronicFormatTxt,PEPPOL21_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"PEPPOL Service Validation",0,ElectronicDocumentFormat.Usage::"Service Validation");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Export Sales Inv. - PEPPOL 2.0",0,ElectronicDocumentFormat.Usage::"Sales Invoice");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Export Sales Cr.M. - PEPPOL2.0",0,ElectronicDocumentFormat.Usage::"Sales Credit Memo");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Export Serv. Inv. - PEPPOL 2.0",0,ElectronicDocumentFormat.Usage::"Service Invoice");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"Exp. Service Cr.M. - PEPPOL2.0",0,ElectronicDocumentFormat.Usage::"Service Credit Memo");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"PEPPOL Validation",0,ElectronicDocumentFormat.Usage::"Sales Validation");
        //  
        //                                          ElectronicDocumentFormat.InsertElectronicFormat(
        //                                            PEPPOL20_ElectronicFormatTxt,PEPPOL20_ElectronicFormatDescriptionTxt,
        //                                            CODEUNIT::"PEPPOL Service Validation",0,ElectronicDocumentFormat.Usage::"Service Validation");
        //                                          #4..6
        //                                          #3..10
        //                                            CODEUNIT::"Exp. Sales Inv. PEPPOL BIS3.0",0,ElectronicDocumentFormat.Usage::"Service Invoice");
        //                                          #16..18
        //                                            CODEUNIT::"Exp. Sales CrM. PEPPOL BIS3.0",0,ElectronicDocumentFormat.Usage::"Service Credit Memo");
        //                                        END;
        //  
        //                           Target=InitElectronicFormats(PROCEDURE 23) }
        //      { Insertion         ;InsertAfter=BankDataConvPmtTypeDesc9Txt(Variable 1166);
        //                           ChangedElements=VariableCollection
        //                           {
        //                             PEPPOL21_ElectronicFormatTxt@1168 : TextConst '@@@={Locked};ENU=PEPPOL 2.1';
        //                             PEPPOL21_ElectronicFormatDescriptionTxt@1170 : TextConst 'ENU=PEPPOL 2.1 Format (Pan-European Public Procurement Online)';
        //                             PEPPOL20_ElectronicFormatTxt@1172 : TextConst '@@@={Locked};ENU=PEPPOL 2.0';
        //                             PEPPOL20_ElectronicFormatDescriptionTxt@1171 : TextConst 'ENU=PEPPOL 2.0 Format (Pan-European Public Procurement Online)';
        //                           }
        //                            }
        //      { PropertyModification;
        //                           Property=Version List;
        //                           OriginalValue=NAVW114.12;
        //                           ModifiedValue=NAVW114.03 }
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

