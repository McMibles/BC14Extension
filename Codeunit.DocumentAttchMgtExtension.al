Codeunit 52092126 "DocumentAttchMgt Extension"
{

    trigger OnRun()
    begin
    end;

    local procedure CopyAttachments(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        FromDocumentAttachment: Record "Document Attachment";
        ToDocumentAttachment: Record "Document Attachment";
        FromFieldRef: FieldRef;
        ToFieldRef: FieldRef;
        FromDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        FromLineNo: Integer;
        FromNo: Code[20];
        ToNo: Code[20];
        RecNo: Code[20];
        ToDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        ToLineNo: Integer;
    begin
        FromDocumentAttachment.SetRange("Table ID", FromRecRef.Number);
        if FromDocumentAttachment.IsEmpty then
            exit;
        case FromRecRef.Number of
            Database::"Payment Request Header",
            Database::"Cash Receipt Header",
            Database::"Cash Lodgement":
                begin
                    FromFieldRef := FromRecRef.Field(1);
                    FromNo := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("No.", FromNo);
                end;
            Database::"Payment Header":
                begin
                    FromFieldRef := FromRecRef.Field(2);
                    FromDocumentType := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("Document Type", FromDocumentType);
                    FromFieldRef := FromRecRef.Field(1);
                    FromNo := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("No.", FromNo);
                end;
            Database::"Requisition Wksh. Name":
                begin
                    FromFieldRef := FromRecRef.Field(1);
                    RecNo := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("Template Name", RecNo);

                    FromFieldRef := FromRecRef.Field(2);
                    RecNo := FromFieldRef.Value;
                    FromDocumentAttachment.SetRange("No.", RecNo);
                end;
        end;

        if FromDocumentAttachment.FindSet then begin
            repeat
                Clear(ToDocumentAttachment);
                ToDocumentAttachment.Init;
                ToDocumentAttachment.TransferFields(FromDocumentAttachment);
                ToDocumentAttachment.Validate("Table ID", ToRecRef.Number);

                case ToRecRef.Number of
                    Database::"Payment Request Header",
                    Database::"Cash Receipt Header",
                    Database::"Cash Lodgement":
                        begin
                            ToFieldRef := ToRecRef.Field(1);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("No.", ToNo);
                        end;
                    Database::"Payment Header",
                    Database::"Posted Payment Header":
                        begin
                            ToFieldRef := ToRecRef.Field(1);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("No.", ToNo);

                            ToFieldRef := ToRecRef.Field(2);
                            ToDocumentType := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("Document Type", ToDocumentType);
                        end;
                    Database::"Requisition Wksh. Name", Database::"Purchase Req. Header":
                        begin
                            ToFieldRef := ToRecRef.Field(1);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("Template Name", ToNo);

                            ToFieldRef := ToRecRef.Field(2);
                            ToNo := ToFieldRef.Value;
                            ToDocumentAttachment.Validate("No.", ToNo);
                        end;
                end;

                if not ToDocumentAttachment.Insert(true) then;

            until FromDocumentAttachment.Next = 0;
        end;

        // Copies attachments for header and then calls CopyAttachmentsForPostedDocsLines to copy attachments for lines.
    end;

    local procedure DeleteAttachedDocuments(RecRef: RecordRef)
    var
        DocumentAttachment: Record "Document Attachment";
        FieldRef: FieldRef;
        RecNo: Code[20];
        RecNo1: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        if RecRef.IsTemporary then
            exit;
        if DocumentAttachment.IsEmpty then
            exit;
        DocumentAttachment.SetRange("Table ID", RecRef.Number);
        case RecRef.Number of
            Database::"Payment Request Header",
            Database::"Cash Receipt Header",
            Database::"Cash Lodgement":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"Payment Header":
                begin
                    FieldRef := RecRef.Field(2);
                    DocType := FieldRef.Value;
                    DocumentAttachment.SetRange("Document Type", DocType);

                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"Requisition Wksh. Name", Database::"Purchase Req. Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Template Name", RecNo);

                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
        DocumentAttachment.DeleteAll;
    end;

    [EventSubscriber(Objecttype::Page, 1173, 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnOpenDocAttach(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        case RecRef.Number of
            Database::"Payment Request Header",
            Database::"Cash Receipt Header",
            Database::"Posted Cash Receipt Header",
            Database::"Cash Lodgement",
            Database::"Posted Cash Lodgement":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"Payment Header",
            Database::"Posted Payment Header":
                begin
                    FieldRef := RecRef.Field(2);
                    DocType := FieldRef.Value;
                    DocumentAttachment.SetRange("Document Type", DocType);

                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"Requisition Wksh. Name":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Template Name", RecNo);

                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnBeforeInsertAttachment', '', false, false)]
    local procedure OnSaveAttachment(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        case RecRef.Number of
            Database::"Payment Request Header",
            Database::"Cash Receipt Header",
            Database::"Cash Lodgement":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;

        case RecRef.Number of
            Database::"Payment Header":
                begin
                    FieldRef := RecRef.Field(2);
                    DocType := FieldRef.Value;
                    DocumentAttachment.Validate("Document Type", DocType);

                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            Database::"Requisition Wksh. Name":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("Template Name", RecNo);

                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Request Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeletePmtReqHeader(var Rec: Record "Payment Request Header"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Payment Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeletePaymentHeader(var Rec: Record "Payment Header"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cash Receipt Header", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteCashRcptHeader(var Rec: Record "Cash Receipt Header"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cash Lodgement", 'OnAfterDeleteEvent', '', false, false)]
    local procedure DeleteAttachedDocumentsOnAfterDeleteCashLodgment(var Rec: Record "Cash Lodgement"; RunTrigger: Boolean)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Rec);
        DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Request Mgt", 'OnCreatePaymentDocument', '', false, false)]
    local procedure DocAttachFlowFromPmtRequestToPaymentHeader(var PaymentRequest: Record "Payment Request Header"; var PaymentHeader: Record "Payment Header")
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        if PaymentRequest."No." = '' then
            exit;

        if PaymentRequest.IsTemporary then
            exit;

        if PaymentHeader."No." = '' then
            exit;

        if PaymentHeader.IsTemporary then
            exit;

        FromRecRef.Open(Database::"Payment Request Header");
        FromRecRef.GetTable(PaymentRequest);

        ToRecRef.Open(Database::"Payment Header");
        ToRecRef.GetTable(PaymentHeader);

        CopyAttachments(FromRecRef, ToRecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment - Post", 'OnBeforeDeletePostedPaymentDocument', '', false, false)]
    local procedure DocAttachFlowFromPaymentHeaderToPostedPaymentHeader(var PaymentHeader: Record "Payment Header"; var PostedPaymentHeader: Record "Posted Payment Header")
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        if PaymentHeader."No." = '' then
            exit;

        if PaymentHeader.IsTemporary then
            exit;

        if PostedPaymentHeader."No." = '' then
            exit;

        if PostedPaymentHeader.IsTemporary then
            exit;

        FromRecRef.Open(Database::"Payment Header");
        FromRecRef.GetTable(PaymentHeader);

        ToRecRef.Open(Database::"Posted Payment Header");
        ToRecRef.GetTable(PostedPaymentHeader);

        CopyAttachments(FromRecRef, ToRecRef);
    end;
    /*
        [EventSubscriber(Objecttype::Codeunit, 52092258, 'OnMoveDocAttachFromOpenDoc1ToOpenDoc2', '', false, false)]
        local procedure DocAttachFlowFromOpenPurchDocToOpenPurchDoc(var Rec1: Record "Requisition Wksh. Name"; var Rec2: Record "Requisition Wksh. Name")
        var
            FromRecRef: RecordRef;
            ToRecRef: RecordRef;
        begin
            if Rec1.Name = '' then
                exit;

            if Rec1.IsTemporary then
                exit;

            if Rec2.Name = '' then
                exit;

            if Rec2.IsTemporary then
                exit;

            FromRecRef.Open(Database::"Requisition Wksh. Name");
            FromRecRef.GetTable(Rec1);

            ToRecRef.Open(Database::"Requisition Wksh. Name");
            ToRecRef.GetTable(Rec2);

            CopyAttachments(FromRecRef, ToRecRef);
        end;

        [EventSubscriber(Objecttype::Codeunit, 52092258, 'OnMoveDocAttachFromOpenDocClosedDoc', '', false, false)]
        local procedure DocAttachFlowFromOpenPurchDocToClosedPurchDoc(var Rec1: Record "Requisition Wksh. Name"; var Rec2: Record "Purchase Req. Header")
        var
            FromRecRef: RecordRef;
            ToRecRef: RecordRef;
        begin
            if Rec1.Name = '' then
                exit;

            if Rec1.IsTemporary then
                exit;

            if Rec2."No." = '' then
                exit;

            if Rec2.IsTemporary then
                exit;

            FromRecRef.Open(Database::"Requisition Wksh. Name");
            FromRecRef.GetTable(Rec1);

            ToRecRef.Open(Database::"Purchase Req. Header");
            ToRecRef.GetTable(Rec2);

            CopyAttachments(FromRecRef, ToRecRef);
        end;

        [EventSubscriber(Objecttype::Codeunit, 52092258, 'OnBeforeDeleteDoc1', '', false, false)]
        local procedure OnDeleteOpenPurchDoc(var Rec: Record "Requisition Wksh. Name")
        var
            RecRef: RecordRef;
        begin
            RecRef.GetTable(Rec);
            DeleteAttachedDocuments(RecRef);
        end;

        [EventSubscriber(Objecttype::Codeunit, 52092258, 'OnBeforeDeleteDoc2', '', false, false)]
        local procedure OnDeleteClosedPurchDoc(var Rec: Record "Purchase Req. Header")
        var
            RecRef: RecordRef;
        begin
            RecRef.GetTable(Rec);
            DeleteAttachedDocuments(RecRef);
        end;
        */
}

