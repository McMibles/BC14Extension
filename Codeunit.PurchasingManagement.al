Codeunit 52092258 PurchasingManagement
{

    //     trigger OnRun()
    //     begin
    //     end;

    //     var
    //         Vendor: Record Vendor;
    //         PurchReq: Record "Requisition Wksh. Name";
    //         PurchReq2: Record "Requisition Wksh. Name";
    //         ReqLine: Record "Requisition Line";
    //         ReqLine2: Record "Requisition Line";
    //         PurchReqHeader: Record UnknownRecord52092344;
    //         PurchReqLine: Record UnknownRecord52092345;
    //         PurchReqSuppCombination: Record UnknownRecord52092343;
    //         PurchComment: Record "Purch. Comment Line";
    //         PurchReqSuppCombination2: Record UnknownRecord52092343;
    //         PurchHeader: Record "Purchase Header";
    //         PurchLine: Record "Purchase Line";
    //         PurchLine2: Record "Purchase Line";
    //         ConsignmentHeader: Record UnknownRecord52092337;
    //         ConsignmentLine: Record UnknownRecord52092338;
    //         UserSetup: Record "User Setup";
    //         PurchSetup: Record "Purchases & Payables Setup";
    //         PurchQuoteToOrder: Codeunit "Purch.-Quote to Order";
    //         ArchMgt: Codeunit ArchiveManagement;
    //         UserMgt: Codeunit "User Setup Management";
    //         ApprovalMgt: Codeunit "Approvals Mgmt.";
    //         PurchHook: Codeunit UnknownCodeunit52092259;
    //         LineNo: Integer;
    //         Text001: label 'RFQ No. %1 already created\Cancel %2 before the Requisition';
    //         Text002: label 'Order already created, RFQ can not be cancelled';
    //         Text003: label 'Quote already created,RFQ can not be cancelled';
    //         Text004: label 'No approved supplier!\Process aborted';
    //         Text005: label 'No approved quote(s) found!';
    //         Text006: label '%1 %2(s) successfully created!';
    //         Text007: label 'Supplier No. must be specified!';
    //         Text008: label 'Do you want to post GRN?';
    //         Text009: label 'GRN posting aborted!';
    //         Text010: label 'GRN successfully posted!';
    //         Text011: label 'Are you sure you want to cancel %1!';
    //         Text012: label 'User Comment not available, PRN %1 Cannot be cancelled!';
    //         Text013: label 'Are you sure you want to reopen cancelled  %1!';
    //         Text014: label 'User Comment not available, PRN %1 Cannot be reopened';
    //         Text015: label 'Do you want to cancel this quote evaluation?';
    //         Text016: label 'You must give reasons for cancellation';
    //         Text017: label 'Only one supplier must be selected';
    //         Text099: label 'PURCHASE REQUISITION TO ORDER NOTIFICATION';
    //         Text100: label 'This is to notify you that purchase requisition %1 (%2) has been converted to purchase order.';
    //         Window: Dialog;
    //         Text101: label 'REQUEST FOR QUOTE';
    //         Text102: label 'Find Attached Request for Quote %1.';
    //         Text103: label 'Preparing to send RFQ\\';
    //         Text104: label 'Sending to #1##############################';


    //     procedure RFQToQuote(var RFQHeader: Record "Requisition Wksh. Name")
    //     var
    //         NoofDoc: Integer;
    //         PurchReqHeader2: Record UnknownRecord52092344;
    //         QuoteEvaHeader: Record UnknownRecord52092344;
    //         QuoteEvaLine: Record UnknownRecord52092345;
    //     begin
    //         NoofDoc := 0;
    //         with RFQHeader do begin
    //           //approved supplier must exist
    //           if not SupplierExist(true) then
    //             Error(Text004);
    //           ReqLine.SetRange(ReqLine."Worksheet Template Name",'RFQ');
    //           ReqLine.SetRange(ReqLine."Journal Batch Name",Name);
    //           if not ReqLine.Find('-') then
    //             Error(Text004);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type",PurchReqSuppCombination."document type"::Quote);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.",Name);
    //           PurchReqSuppCombination.SetRange(Confirmed,true);
    //           PurchReqSuppCombination.Find('-');
    //             repeat
    //               NoofDoc := NoofDoc + 1;
    //               CreatePurchQuote(RFQHeader,PurchReqSuppCombination."Registered Vendor No.",NoofDoc);
    //             until PurchReqSuppCombination.Next = 0;

    //           if PurchReqHeader2.Get(RFQHeader."Worksheet Template Name",RFQHeader.Name) then begin
    //             PurchReqHeader2.DeleteLinks;
    //             PurchReqHeader2.Delete(true);
    //           end;
    //           //Create BID EVALUATION Header from RFQ Header
    //           QuoteEvaHeader.TransferFields(RFQHeader);
    //           QuoteEvaHeader."Worksheet Template Name" := 'BIDEVA';
    //           QuoteEvaHeader."No." := '';
    //           QuoteEvaHeader."RFQ No." := Name;
    //           QuoteEvaHeader."PRN No." := "PRN No.";
    //           QuoteEvaHeader.Status := 0;
    //           QuoteEvaHeader."Creation Date" := Today;
    //           QuoteEvaHeader."Date Last Updated" := 0D;
    //           QuoteEvaHeader."Last Updated By" := '';
    //           QuoteEvaHeader."Responsibility Center" :=  "Responsibility Center";
    //           QuoteEvaHeader."Template Type" :=  "Template Type" ;
    //           QuoteEvaHeader."Expected Receipt Date" := "Expected Receipt Date" ;
    //           QuoteEvaHeader."Dimension Set ID" := "Dimension Set ID";
    //           QuoteEvaHeader."Shortcut Dimension 1 Code"  := "Shortcut Dimension 1 Code";
    //           QuoteEvaHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";

    //           QuoteEvaHeader.Insert(true);
    //           QuoteEvaHeader.CopyLinks(RFQHeader);

    //           OnMoveDocAttachFromOpenDocClosedDoc(RFQHeader,QuoteEvaHeader);

    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type",PurchReqSuppCombination."document type"::Quote);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.",Name);
    //           PurchReqSuppCombination.SetRange(Confirmed,true);
    //           if PurchReqSuppCombination.Find('-') then
    //             repeat
    //               PurchReqSuppCombination2 := PurchReqSuppCombination;
    //               PurchReqSuppCombination2."Document Type" := PurchReqSuppCombination2."document type"::Quote;
    //               PurchReqSuppCombination2."Document No." := QuoteEvaHeader."No.";
    //               PurchReqSuppCombination2.Insert;
    //             until PurchReqSuppCombination.Next = 0;

    //           PurchReqHeader.TransferFields(RFQHeader);
    //           PurchReqHeader.Status := PurchReqHeader.Status::Approved;
    //           PurchReqHeader.Insert;
    //           PurchReqHeader.CopyLinks(RFQHeader);
    //           ReqLine.SetRange("Worksheet Template Name","Worksheet Template Name");
    //           ReqLine.SetRange("Journal Batch Name",Name);
    //           if ReqLine.Find('-') then
    //             repeat
    //               PurchReqLine.TransferFields(ReqLine);
    //               PurchReqLine.Insert;
    //               //Create Evaluation Lines
    //               QuoteEvaLine.TransferFields(ReqLine);
    //               QuoteEvaLine."Worksheet Template Name" := 'BIDEVA';
    //               QuoteEvaLine."Journal Batch Name" := QuoteEvaHeader."No.";
    //               QuoteEvaLine.Insert;
    //             until ReqLine.Next = 0;
    //           ReqLine.DeleteAll(true);
    //           DeleteLinks;
    //           OnMoveDocAttachFromOpenDocClosedDoc(RFQHeader,PurchReqHeader);
    //           OnBeforeDeleteDoc1(RFQHeader);
    //           Delete;
    //         end;

    //         Message(Text006,NoofDoc,'Quote');
    //     end;


    //     procedure CreatePurchQuote(RFQHeader: Record "Requisition Wksh. Name";SupplierNo: Code[20];SeqNo: Integer)
    //     begin
    //         with RFQHeader do begin
    //           if SupplierNo = '' then
    //             Error(Text007);
    //           LineNo := 10000;
    //           // check vendor record
    //           Vendor.Get(SupplierNo);
    //           Vendor.TestField(Vendor.Name);
    //           Vendor.TestField(Vendor.Blocked,0);
    //           Vendor.TestField(Vendor."Vendor Posting Group");
    //           Vendor.TestField(Vendor."Gen. Bus. Posting Group");
    //           Vendor.TestField(Vendor."VAT Bus. Posting Group");

    //           // create purchase Header
    //           PurchHeader.Init;
    //           PurchHeader."Document Type" := PurchHeader."document type"::Quote;
    //           PurchHeader."Responsibility Center" := UserMgt.GetPurchasesFilter();
    //           PurchHeader."No." := '';
    //           if SeqNo = 0 then
    //             PurchHeader."Suffix No." := "Suffix No."
    //           else
    //             PurchHeader."Suffix No." := "Suffix No." + '-' + Format(SeqNo);
    //             PurchHeader."Original Suffix No." := "Suffix No.";
    //           PurchHeader.Insert(true);
    //           PurchHeader.Validate(PurchHeader."Buy-from Vendor No.",SupplierNo);
    //           PurchHeader.Validate("Posting Date",Today);
    //           PurchHeader."Order Date" := Today;
    //           PurchHeader."Document Date" := Today;
    //           PurchHeader.Validate("Shipment Method Code","Shipment Method Code");
    //           PurchHeader.Validate("Requested Receipt Date","Expected Receipt Date");
    //           if "Shortcut Dimension 1 Code" <> '' then
    //             PurchHeader.Validate(PurchHeader."Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
    //           if "Shortcut Dimension 2 Code" <> '' then
    //             PurchHeader.Validate(PurchHeader."Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");
    //           PurchHeader.Validate(PurchHeader."Document Date",Today);
    //           PurchHeader."RFQ No." := Name;
    //           PurchHeader."PRN No." := "PRN No.";
    //           PurchHeader."Beneficiary No." := RFQHeader."Beneficiary No.";
    //           PurchHeader."Purchaser Code" := "Purchaser Code";
    //           PurchHeader."Order Type" := RFQHeader."Order Type";
    //           PurchHeader."Purchase Req. Type" :=  RFQHeader.Type;
    //           PurchHeader."Purchase Req. Code" :=  RFQHeader."Purchase Req. Code";
    //           PurchHeader."Posting Description" := RFQHeader.Description;
    //           PurchHeader.CopyLinks(RFQHeader);
    //           PurchHeader.Modify;

    //           ReqLine.SetRange(ReqLine."Worksheet Template Name",'RFQ');
    //           ReqLine.SetRange(ReqLine."Journal Batch Name",Name);
    //           ReqLine.Find('-');
    //           repeat
    //             if ReqLine.Type <> 0 then begin
    //               PurchLine.Init;
    //               PurchLine."Document Type" := PurchHeader."Document Type";
    //               PurchLine."Document No." := PurchHeader."No.";
    //               PurchLine.Validate("Buy-from Vendor No.",PurchHeader."Buy-from Vendor No.");
    //               PurchLine."Line No." := ReqLine."Line No.";
    //               case ReqLine.Type of
    //                // 0 : PurchLine.Type := 0;                                                           // blank
    //                 1 : PurchLine.Type := PurchLine.Type::"G/L Account";                               // g/l
    //                 2 : PurchLine.Type := PurchLine.Type::Item;                                        // item
    //                 3 : PurchLine.Type := PurchLine.Type::"Fixed Asset";                               // fixed asset
    //               end; /*end case*/
    //               PurchLine.Validate("No.",ReqLine."No.");
    //               PurchLine.Validate("Location Code",ReqLine."Location Code");
    //               PurchLine."Requested Receipt Date" := "Expected Receipt Date";
    //               PurchLine.Description := ReqLine.Description;
    //               PurchLine."Description 2" := ReqLine."Description 2";
    //               //Transfer Job Detail
    //               PurchLine."Job No." := ReqLine."Job No.";
    //               PurchLine."Job Task No." := ReqLine."Job Task No.";
    //               //PurchLine."Work Order No." := ReqLine."Work Order No.";
    //               //PurchLine."Work Order Task No." := ReqLine."Work Order Task No.";

    //               PurchLine.Validate("Unit of Measure",ReqLine."Unit of Measure Code");
    //               PurchLine.Validate(Quantity,ReqLine.Quantity);

    //               PurchLine."Qty. to Invoice" := 0;
    //               PurchLine."Qty. to Receive" := 0;
    //               PurchLine.Validate("Direct Unit Cost",ReqLine."Offered Unit Price");
    //               PurchLine."RFQ No." := PurchHeader."RFQ No.";
    //               PurchLine."PRN No." := PurchHeader."PRN No.";
    //               PurchLine."Requisition Line No." := ReqLine."Line No.";
    //               PurchLine."Maintenance Code" := ReqLine."Maintenance Code";
    //               if ReqLine."Maintenance Code" <> '' then
    //                 PurchLine."FA Posting Type" := PurchLine."fa posting type"::Maintenance;
    //               PurchLine."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
    //               PurchLine."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
    //               PurchLine."Dimension Set ID" := ReqLine."Dimension Set ID";
    //               PurchLine."Account No."  := ReqLine."Account No.";
    //               PurchLine.Insert;
    //              end else begin //Insert Descriptive line
    //                PurchLine.Init;
    //                PurchLine."Document Type" := PurchHeader."Document Type";
    //                PurchLine."Document No." := PurchHeader."No.";
    //                PurchLine.Description := ReqLine.Description;
    //                PurchLine."Description 2" := ReqLine."Description 2";
    //                PurchLine."Line No." := ReqLine."Line No.";
    //                PurchLine."Requisition Line No." := ReqLine."Line No.";
    //                PurchLine."RFQ No." := PurchHeader."RFQ No.";
    //                PurchLine."PRN No." := PurchHeader."PRN No.";
    //                PurchLine.Insert;
    //              end;
    //              LineNo := LineNo + 10000;
    //           until ReqLine.Next = 0;
    //         end;

    //     end;


    //     procedure RFQToPO(var RFQHeader: Record "Requisition Wksh. Name")
    //     var
    //         NoofDoc: Integer;
    //         PurchReqHeader2: Record UnknownRecord52092344;
    //         QuoteEvaHeader: Record UnknownRecord52092344;
    //         QuoteEvaLine: Record UnknownRecord52092345;
    //         Employee: Record Employee;
    //         SMTP: Codeunit "SMTP Mail";
    //         Body: Text[200];
    //         Subject: Text[200];
    //         Sender: Text[80];
    //         Receiver: Text[80];
    //         GlobalSender: Text[100];
    //     begin
    //         NoofDoc := 0;
    //         with RFQHeader do begin
    //           //approved supplier must exist
    //           if not SupplierExist(true) then
    //             Error(Text004);
    //           ReqLine.SetRange(ReqLine."Worksheet Template Name",'RFQ');
    //           ReqLine.SetRange(ReqLine."Journal Batch Name",Name);
    //           if not ReqLine.Find('-') then
    //             Error(Text004);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type",PurchReqSuppCombination."document type"::Quote);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.",Name);
    //           PurchReqSuppCombination.SetRange(Confirmed,true);
    //           PurchReqSuppCombination.Find('-');
    //             repeat
    //               NoofDoc := NoofDoc + 1;
    //               CreatePOFromRFQ(RFQHeader,PurchReqSuppCombination."Registered Vendor No.",NoofDoc);
    //             until PurchReqSuppCombination.Next = 0;

    //           if PurchReqHeader2.Get(RFQHeader."Worksheet Template Name",RFQHeader.Name) then begin
    //             PurchReqHeader2.DeleteLinks;
    //             PurchReqHeader2.Delete(true);
    //           end;

    //           PurchReqHeader.TransferFields(RFQHeader);
    //           PurchReqHeader.Status := PurchReqHeader.Status::"LPO Raised";
    //           PurchReqHeader.Insert;
    //           PurchReqHeader.CopyLinks(RFQHeader);
    //           ReqLine.SetRange("Worksheet Template Name","Worksheet Template Name");
    //           ReqLine.SetRange("Journal Batch Name",Name);
    //           if ReqLine.Find('-') then
    //             repeat
    //               PurchReqLine.TransferFields(ReqLine);
    //               PurchReqLine.Insert;
    //             until ReqLine.Next = 0;
    //           ReqLine.DeleteAll(true);
    //           DeleteLinks;
    //           DeleteCommitment(RFQHeader.Name);
    //           PurchReqHeader2.Get('P-REQ',RFQHeader."PRN No.");
    //           PurchReqHeader2.Status := PurchReqHeader2.Status::"LPO Raised";
    //           PurchReqHeader2.Modify;
    //           //Notify the Requestor
    //           PurchSetup.Get;
    //           if PurchSetup."PRN Convertion Notification" then begin
    //             UserSetup.Get(UserId);
    //             UserSetup.TestField("Employee No.");
    //             Employee.Get(UserSetup."Employee No.");
    //             GlobalSender := Employee.FullName;

    //             UserSetup.TestField("E-Mail");
    //             Sender := UserSetup."E-Mail";

    //             //Get Receiver
    //             Employee.Get(RFQHeader."Beneficiary No.");
    //             Employee.TestField("Company E-Mail");

    //             Receiver := Employee."Company E-Mail";
    //             Body := StrSubstNo(Text100,RFQHeader."PRN No.",RFQHeader.Description);
    //             Subject := StrSubstNo(Text099);
    //             SMTP.CreateMessage(GlobalSender,Sender,Receiver,Subject,Body,false);
    //             SMTP.Send;
    //           end;
    //           OnBeforeDeleteDoc1(RFQHeader);
    //           Delete;
    //         end;

    //         Message(Text006,NoofDoc,'PO');
    //     end;


    //     procedure CreatePOFromRFQ(RFQHeader: Record "Requisition Wksh. Name";SupplierNo: Code[20];SeqNo: Integer)
    //     begin
    //         with RFQHeader do begin
    //           if SupplierNo = '' then
    //             Error(Text007);
    //           LineNo := 10000;
    //           // check vendor record
    //           Vendor.Get(SupplierNo);
    //           Vendor.TestField(Vendor.Name);
    //           Vendor.TestField(Vendor.Blocked,0);
    //           Vendor.TestField(Vendor."Vendor Posting Group");
    //           Vendor.TestField(Vendor."Gen. Bus. Posting Group");
    //           Vendor.TestField(Vendor."VAT Bus. Posting Group");

    //           // create purchase Header
    //           PurchHeader.Init;
    //           PurchHeader."Document Type" := PurchHeader."document type"::Order;
    //           PurchHeader."Responsibility Center" := UserMgt.GetPurchasesFilter();
    //           PurchHeader."No." := '';
    //           if SeqNo = 0 then
    //             PurchHeader."Suffix No." := "Suffix No."
    //           else
    //             PurchHeader."Suffix No." := "Suffix No." + '-' + Format(SeqNo);
    //             PurchHeader."Original Suffix No." := "Suffix No.";
    //           PurchHeader.Insert(true);
    //           PurchHeader.CopyLinks(RFQHeader);
    //           PurchHeader.Validate(PurchHeader."Buy-from Vendor No.",SupplierNo);
    //           PurchHeader.Validate("Posting Date",Today);
    //           PurchHeader."Order Date" := Today;
    //           PurchHeader."Document Date" := Today;
    //           PurchHeader.Validate("Shipment Method Code","Shipment Method Code");
    //           PurchHeader.Validate("Requested Receipt Date","Expected Receipt Date");
    //           if "Shortcut Dimension 1 Code" <> '' then
    //             PurchHeader.Validate(PurchHeader."Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
    //           if "Shortcut Dimension 2 Code" <> '' then
    //             PurchHeader.Validate(PurchHeader."Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");
    //           PurchHeader.Validate(PurchHeader."Document Date",Today);
    //           PurchHeader."RFQ No." := Name;
    //           PurchHeader."PRN No." := "PRN No.";
    //           PurchHeader."Beneficiary No." := RFQHeader."Beneficiary No.";
    //           PurchHeader."Purchaser Code" := "Purchaser Code";
    //           PurchHeader."Order Type" := RFQHeader."Order Type";
    //           PurchHeader."Purchase Req. Type" :=  RFQHeader.Type;
    //           PurchHeader."Purchase Req. Code" :=  RFQHeader."Purchase Req. Code";
    //           PurchHeader."Dimension Set ID" := RFQHeader."Dimension Set ID";
    //           PurchHeader."Currency Code" := RFQHeader."Currency Code";
    //           PurchHeader."Currency Factor" := RFQHeader."Currency Factor";
    //           PurchHeader.CopyLinks(RFQHeader);
    //           PurchHeader.Modify;

    //           ReqLine.SetRange(ReqLine."Worksheet Template Name",'RFQ');
    //           ReqLine.SetRange(ReqLine."Journal Batch Name",Name);
    //           ReqLine.Find('-');
    //           repeat
    //             if ReqLine.Type <> 0 then begin
    //               PurchLine.Init;
    //               PurchLine."Document Type" := PurchHeader."Document Type";
    //               PurchLine."Document No." := PurchHeader."No.";
    //               PurchLine.Validate("Buy-from Vendor No.",PurchHeader."Buy-from Vendor No.");
    //               PurchLine."Line No." := ReqLine."Line No.";
    //               case ReqLine.Type of
    //                // 0 : PurchLine.Type := 0;                                                           // blank
    //                 1 : PurchLine.Type := PurchLine.Type::"G/L Account";                               // g/l
    //                 2 : PurchLine.Type := PurchLine.Type::Item;                                        // item
    //                 3 : PurchLine.Type := PurchLine.Type::"Fixed Asset";                               // fixed asset
    //               end; /*end case*/
    //               PurchLine.Validate("No.",ReqLine."No.");
    //               PurchLine.Validate("Location Code",ReqLine."Location Code");
    //               PurchLine."Requested Receipt Date" := "Expected Receipt Date";
    //               PurchLine.Description := ReqLine.Description;
    //               PurchLine."Description 2" := ReqLine."Description 2";
    //               //Transfer Job Detail
    //               PurchLine."Job No." := ReqLine."Job No.";
    //               PurchLine."Job Task No." := ReqLine."Job Task No.";
    //               //PurchLine."Work Order No." := ReqLine."Work Order No.";
    //               //PurchLine."Work Order Task No." := ReqLine."Work Order Task No.";

    //               PurchLine.Validate("Unit of Measure Code",ReqLine."Unit of Measure Code");
    //               PurchLine.Validate(Quantity,ReqLine.Quantity);

    //               PurchLine."Qty. to Invoice" := 0;
    //               PurchLine."Qty. to Receive" := 0;
    //               PurchLine.Validate("Direct Unit Cost",ReqLine."Offered Unit Price");
    //               PurchLine."RFQ No." := PurchHeader."RFQ No.";
    //               PurchLine."PRN No." := PurchHeader."PRN No.";
    //               PurchLine."Requisition Line No." := ReqLine."Line No.";
    //               PurchLine."Maintenance Code" := ReqLine."Maintenance Code";
    //               PurchLine."Dimension Set ID" := ReqLine."Dimension Set ID";
    //               PurchLine."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
    //               PurchLine."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
    //               if ReqLine."Maintenance Code" <> '' then
    //                 PurchLine."FA Posting Type" := PurchLine."fa posting type"::Maintenance;
    //               PurchLine.Insert;
    //              end else begin //Insert Descriptive line
    //                PurchLine.Init;
    //                PurchLine."Document Type" := PurchHeader."Document Type";
    //                PurchLine."Document No." := PurchHeader."No.";
    //                PurchLine.Description := ReqLine.Description;
    //                PurchLine."Description 2" := ReqLine."Description 2";
    //                PurchLine."Line No." := ReqLine."Line No.";
    //                PurchLine."Requisition Line No." := ReqLine."Line No.";
    //                PurchLine."RFQ No." := PurchHeader."RFQ No.";
    //                PurchLine."PRN No." := PurchHeader."PRN No.";
    //                PurchLine.Insert;
    //              end;
    //              LineNo := LineNo + 10000;
    //           until ReqLine.Next = 0;
    //           PurchHook.CreateCommitment(PurchHeader);
    //         end;

    //     end;


    //     procedure GetNoSeries(DoumentType: Option PRN,RFQ,QEVA,Quote,"Order","Service PO";SuffixNo: Code[20];var NewNo: Code[20])
    //     begin
    //         case DoumentType of
    //          0 : NewNo := 'PRN' + SuffixNo;
    //          1 : NewNo := 'RFQ' + SuffixNo;
    //          2 : NewNo := 'QEVA' + SuffixNo;
    //          3 : NewNo := 'Q' + SuffixNo;
    //          4 : NewNo := 'PO' + SuffixNo;
    //          5 : NewNo := 'SPO' + SuffixNo;
    //         end;
    //     end;


    //     procedure CancelPRN(var PRN: Record "Requisition Wksh. Name")
    //     begin
    //         if not Confirm(Text011,false,PRN.Name) then
    //           exit;
    //         with PRN do begin
    //           if "Worksheet Template Name" = 'P-REQ' then begin
    //             // check if RFQ already exist
    //             PurchReq.Reset;
    //             PurchReq.SetRange(PurchReq."Worksheet Template Name",'RFQ');
    //             PurchReq.SetRange(PurchReq."PRN No.",Name);
    //             if PurchReq.Find('-') then
    //               Error(Text001,PurchReq.Name,PurchReq."Worksheet Template Name");
    //             PurchComment.Reset;
    //             PurchComment.SetCurrentkey("No.",Date,"User ID");
    //             PurchComment.SetRange("No.",Name);
    //             PurchComment.SetRange(Date,WorkDate);
    //             PurchComment.SetRange("User ID",UserId);
    //             if not PurchComment.Find('-') then
    //               Error(Text012,Name);
    //             PurchReqHeader.TransferFields(PRN);
    //             PurchReqHeader.Insert;
    //             ReqLine.SetRange("Worksheet Template Name","Worksheet Template Name");
    //             ReqLine.SetRange("Journal Batch Name",Name);
    //             if ReqLine.Find('-') then
    //               repeat
    //                 PurchReqLine.TransferFields(ReqLine);
    //                 PurchReqLine.Insert;
    //               until ReqLine.Next = 0;
    //             PurchReqHeader.Status := PurchReqHeader.Status::Cancelled;
    //             PurchReqHeader."Date Last Updated" := Today;
    //             PurchReqHeader."Last Updated By" := UserId;
    //             PurchReqHeader.CopyLinks(PRN);
    //             OnMoveDocAttachFromOpenDocClosedDoc(PRN,PurchReqHeader);
    //             PurchReqHeader.Modify;
    //             PurchHook.DeletePRNCommitment(PRN);
    //             ApprovalMgt.PostApprovalEntries(RecordId,PurchReqHeader.RecordId,PurchReqHeader."No.");
    //             ApprovalMgt.DeleteApprovalEntries(RecordId);

    //             ReqLine.DeleteAll(true);
    //             DeleteLinks;
    //             DeleteCommitment(PRN.Name);
    //             PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type",
    //               PurchReqSuppCombination."document type"::Requisition);
    //             PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.",Name);
    //             PurchReqSuppCombination.DeleteAll;
    //             OnBeforeDeleteDoc1(PRN);
    //             Delete;
    //           end;
    //         end;
    //     end;


    //     procedure ReopenCancelledPRN(var PRN: Record UnknownRecord52092344)
    //     begin
    //         if not Confirm(Text013,false,PRN."No.") then
    //           exit;
    //         with PRN do begin
    //           if "Worksheet Template Name" = 'P-REQ' then begin
    //             //Reasons reopening deletion must be specified
    //             PurchComment.Reset;
    //             PurchComment.SetCurrentkey("No.",Date,"User ID");
    //             PurchComment.SetRange("No.","No.");
    //             PurchComment.SetRange(Date,WorkDate);
    //             PurchComment.SetRange("User ID",UserId);
    //             if not (PurchComment.FindSet) then
    //               Error(Text014,"No.");

    //             // Delete Existing RFQ
    //             PurchReq.Reset;
    //             PurchReq.SetRange(PurchReq."Worksheet Template Name",'RFQ');
    //             PurchReq.SetRange(PurchReq."PRN No.","No.");
    //             PurchReq.DeleteAll(true);
    //             PurchReqHeader.Reset;
    //             PurchReqHeader.SetRange("Worksheet Template Name",'RFQ');
    //             PurchReqHeader.SetRange("PRN No.","No.");
    //             PurchReqHeader.DeleteAll(true);

    //             //Delete Existing quotes
    //             PurchHeader.Reset;
    //             PurchHeader.SetRange(PurchHeader."Document Type",PurchHeader."document type"::Quote);
    //             PurchHeader.SetRange(PurchHeader."PRN No.","No.");
    //             PurchHeader.DeleteAll(true);

    //             PurchReq.TransferFields(PRN);
    //             PurchReq.Insert;

    //             PurchReqLine.SetRange("Worksheet Template Name","Worksheet Template Name");
    //             PurchReqLine.SetRange("Journal Batch Name","No.");
    //             if PurchReqLine.Find('-') then
    //               repeat
    //                 ReqLine.TransferFields(PurchReqLine);
    //                 ReqLine.Insert;
    //               until PurchReqLine.Next = 0;

    //             PurchReq.Status := PurchReq.Status::Open;
    //             PurchReq.Modify;
    //             PurchReqLine.DeleteAll(true);
    //             OnBeforeDeleteDoc2(PRN);
    //             Delete;
    //           end;
    //         end;
    //     end;


    //     procedure CancelRFQReopenPRN(var RFQ: Record "Requisition Wksh. Name";ReopenPRN: Boolean)
    //     begin
    //         with RFQ do begin
    //           if "Worksheet Template Name" = 'RFQ' then begin
    //             //check if PO already exists
    //             PurchHeader.Reset;
    //             PurchHeader.SetRange(PurchHeader."Document Type",PurchHeader."document type"::Order);
    //             PurchHeader.SetRange(PurchHeader."RFQ No.",Name);
    //             if PurchHeader.Find('-') then Error(Text002);

    //             // check if quote(s) already exist
    //             PurchHeader.Reset;
    //             PurchHeader.SetRange(PurchHeader."Document Type",PurchHeader."document type"::Quote);
    //             PurchHeader.SetRange(PurchHeader."RFQ No.",Name);
    //             if PurchHeader.Find('-') then
    //               Error(Text003);

    //             if ReopenPRN then begin
    //               PurchReqHeader.Get('P-REQ', RFQ."PRN No.");
    //               PurchReq.TransferFields(PurchReqHeader);
    //               PurchReq.Status := PurchReq.Status::Open;
    //               PurchReq.Insert;
    //               PurchReqLine.Reset;
    //               PurchReqLine.SetRange(PurchReqLine."Worksheet Template Name",'P-REQ');
    //               PurchReqLine.SetRange("Journal Batch Name",RFQ."PRN No.");
    //               PurchReqLine.Find('-');
    //                 repeat
    //                   ReqLine.TransferFields(PurchReqLine);
    //                   ReqLine.Insert;
    //                 until  PurchReqLine.Next = 0;
    //               PurchReqLine.DeleteAll(true);
    //               OnBeforeDeleteDoc2(PurchReqHeader);
    //               PurchReqHeader.Delete;
    //               //Delete RFQ;
    //               ReqLine2.Reset;
    //               ReqLine2.SetRange("Worksheet Template Name","Worksheet Template Name");
    //               ReqLine2.SetRange("Journal Batch Name",Name);
    //               ReqLine2.DeleteAll(true);
    //               PurchReqSuppCombination.Reset;
    //               PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.",Name);
    //               PurchReqSuppCombination.DeleteAll;
    //               DeleteLinks;
    //               DeleteCommitment(RFQ.Name);
    //               OnBeforeDeleteDoc1(RFQ);
    //               Delete;
    //             end else begin
    //               PurchReqHeader.Get('P-REQ', RFQ."PRN No.");
    //               PurchReqHeader.Status := PurchReqHeader.Status::Cancelled;
    //               //Delete RFQ;
    //               ReqLine2.Reset;
    //               ReqLine2.SetRange("Worksheet Template Name","Worksheet Template Name");
    //               ReqLine2.SetRange("Journal Batch Name",Name);
    //               ReqLine2.DeleteAll(true);
    //               PurchReqSuppCombination.Reset;
    //               PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.",Name);
    //               PurchReqSuppCombination.DeleteAll;
    //               DeleteCommitment(RFQ.Name);
    //               OnBeforeDeleteDoc2(PurchReqHeader);
    //               Delete;
    //             end;
    //           end;
    //         end;
    //     end;


    //     procedure CreateRFQ(var PRN: Record "Requisition Wksh. Name")
    //     var
    //         ProcesedRFQHeader: Record UnknownRecord52092344;
    //         RFQHeader: Record "Requisition Wksh. Name";
    //         NoOfDoc: Integer;
    //     begin
    //         with PRN do begin
    //           //Create RFQ Header from PRN Header
    //           RFQHeader.SetCurrentkey("Worksheet Template Name","PRN No.");
    //           RFQHeader.SetRange("Worksheet Template Name",'RFQ');
    //           RFQHeader.SetRange("PRN No.",PRN.Name);
    //           ProcesedRFQHeader.SetCurrentkey("Worksheet Template Name","PRN No.");
    //           ProcesedRFQHeader.SetRange("Worksheet Template Name",'RFQ');
    //           ProcesedRFQHeader.SetRange("PRN No.",PRN.Name);

    //           NoOfDoc := RFQHeader.Count + ProcesedRFQHeader.Count;
    //           PurchReq := PRN;
    //           PurchReq."Worksheet Template Name" := 'RFQ';
    //           PurchReq.Name := '';
    //           if NoOfDoc = 0 then
    //             PurchReq."Suffix No." := "Suffix No."
    //           else
    //             PurchReq."Suffix No." := "Suffix No." + '-' + Format(NoOfDoc);
    //           PurchReq."PRN No." := Name;
    //           PurchReq.Status := 0;
    //           PurchReq."Creation Date" := Today;
    //           PurchReq."Date Last Updated" := 0D;
    //           PurchReq."Last Updated By" := '';
    //           PurchReq."Responsibility Center" :=  "Responsibility Center";
    //           PurchReq."Template Type" :=  "Template Type" ;
    //           PurchReq."Expected Receipt Date" := "Expected Receipt Date" ;
    //           PurchReq."Shortcut Dimension 1 Code"  := "Shortcut Dimension 1 Code";
    //           PurchReq."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
    //           PurchReq."Dimension Set ID" := "Dimension Set ID";
    //           UserSetup.Get(UserId);
    //           UserSetup.TestField("Salespers./Purch. Code");
    //           if PurchReq."Purchaser Code" = ''  then
    //             PurchReq."Purchaser Code" := UserSetup."Salespers./Purch. Code";
    //           PurchReq."RFQ Created By" := UserId;
    //           PurchReq."Currency Code" := "Currency Code";
    //           PurchReq."Currency Factor" := "Currency Factor";
    //           PurchReq.Insert(true);
    //           PurchReq.CopyLinks(PRN);

    //           OnMoveDocAttachFromOpenDoc1ToOpenDoc2(PRN,PurchReq);

    //           PurchReqHeader.TransferFields(PRN);
    //           PurchReqHeader.Insert;
    //           ReqLine.Reset;
    //           ReqLine.SetRange("Worksheet Template Name","Worksheet Template Name");
    //           ReqLine.SetRange("Journal Batch Name",Name);
    //           ReqLine.FindFirst;
    //           repeat
    //             PurchReqLine.TransferFields(ReqLine);
    //             PurchReqLine.Insert;
    //             ReqLine2 := ReqLine;
    //             ReqLine2."Worksheet Template Name" := 'RFQ';
    //             ReqLine2."Journal Batch Name" := PurchReq.Name;
    //             ReqLine2.Insert;
    //           until ReqLine.Next = 0;

    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type",PurchReqSuppCombination."document type"::Requisition);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.",Name);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination.Confirmed,true);
    //           if PurchReqSuppCombination.Find('-') then
    //             repeat
    //               PurchReqSuppCombination2 := PurchReqSuppCombination;
    //               PurchReqSuppCombination2."Document Type" := PurchReqSuppCombination2."document type"::Quote;
    //               PurchReqSuppCombination2."Document No." := PurchReq.Name;
    //               PurchReqSuppCombination2.Insert;
    //             until PurchReqSuppCombination.Next = 0;


    //           PurchHook.CreatePRNCommitment(PurchReq);
    //           ApprovalMgt.PostApprovalEntries(RecordId,PurchReqHeader.RecordId,PurchReqHeader."No.");
    //           ApprovalMgt.DeleteApprovalEntries(RecordId);

    //           ReqLine.Reset;
    //           ReqLine.SetRange("Worksheet Template Name","Worksheet Template Name");
    //           ReqLine.SetRange("Journal Batch Name",Name);
    //           ReqLine.DeleteAll(true);
    //           DeleteCommitment(PRN.Name);
    //           OnMoveDocAttachFromOpenDocClosedDoc(PRN,PurchReqHeader);
    //           OnBeforeDeleteDoc1(PRN);
    //           Delete;
    //         end;
    //     end;


    //     procedure CreatePO(var BIDEVAHeader: Record UnknownRecord52092344)
    //     var
    //         PurchSetup: Record "Purchases & Payables Setup";
    //         PRN: Record UnknownRecord52092344;
    //         Employee: Record Employee;
    //         SMTP: Codeunit "SMTP Mail";
    //         NoofDoc: Integer;
    //         Body: Text[200];
    //         Subject: Text[200];
    //         Sender: Text[80];
    //         Receiver: Text[80];
    //         GlobalSender: Text[100];
    //     begin
    //         with BIDEVAHeader do begin
    //           //TESTFIELD("Approved for Order");
    //           PurchHeader.SetRange("Document Type",PurchHeader."document type"::Quote);
    //           PurchHeader.SetRange("RFQ No.","RFQ No.");
    //           PurchHeader.SetRange(Status,PurchHeader.Status::Released);
    //           if not PurchHeader.FindFirst then
    //             Error(Text005);
    //           NoofDoc := PurchHeader.Count;
    //           // create Order(s) from approved Quote(s)
    //           repeat
    //             PurchQuoteToOrder.SetOnlySelectedLine;
    //             PurchQuoteToOrder.SetQuoteEvaNo(BIDEVAHeader."No.");
    //             PurchQuoteToOrder.Run(PurchHeader);
    //           until PurchHeader.Next = 0;
    //         end;


    //         /*PurchHeader.RESET;
    //         PurchHeader.SETRANGE("Document Type",PurchHeader."Document Type"::Quote);
    //         PurchHeader.SETRANGE("RFQ No.",BIDEVAHeader."RFQ No.");
    //         PurchHeader.SETRANGE(Status,PurchHeader.Status::Open);
    //         PurchHeader.MODIFYALL("Posted Status",PurchHeader."Posted Status"::Posted);*/

    //         //PurchHeader.DELETEALL(TRUE);
    //         DeleteCommitment(BIDEVAHeader."RFQ No.");
    //         BIDEVAHeader.Status := BIDEVAHeader.Status::"LPO Raised";
    //         BIDEVAHeader.Modify;
    //         if BIDEVAHeader."PRN No." <> '' then begin
    //           PRN.Get('P-REQ',BIDEVAHeader."PRN No." );
    //           PRN.Status := PRN.Status::"LPO Raised";
    //           PRN."Order Creation Date" := Today;
    //           PRN.Modify;
    //           //Notify the Requestor
    //           Commit;
    //           //Notify the Requestor
    //           PurchSetup.Get;
    //           if PurchSetup."PRN Convertion Notification" then begin
    //             UserSetup.Get(UserId);
    //             UserSetup.TestField("Employee No.");
    //             Employee.Get(UserSetup."Employee No.");
    //             GlobalSender := Employee.FullName;

    //             UserSetup.TestField("E-Mail");
    //             Sender := UserSetup."E-Mail";

    //             //Get Receiver
    //             UserSetup.Get(BIDEVAHeader."User ID");
    //             UserSetup.TestField("E-Mail");


    //             Receiver := UserSetup."E-Mail";
    //             Body := StrSubstNo(Text100,BIDEVAHeader."PRN No.",BIDEVAHeader.Description);
    //             Subject := StrSubstNo(Text099);
    //             if UserSetup."E-Mail" <> '' then begin
    //               SMTP.CreateMessage(GlobalSender,Sender,Receiver,Subject,Body,false);
    //               SMTP.Send;
    //             end;
    //           end;
    //         end;

    //         Message(Text006,NoofDoc,'Order');

    //     end;


    //     procedure QuoteEvaToQuote(var QuoteEvaHeader: Record UnknownRecord52092344)
    //     var
    //         NoofDoc: Integer;
    //         NoofDocCreated: Integer;
    //         PurchQuote: Record "Purchase Header";
    //         PurchOrder: Record "Purchase Header";
    //         PurchReqLine: Record UnknownRecord52092345;
    //     begin
    //         NoofDoc := 0;
    //         NoofDocCreated := 0;
    //         PurchQuote.SetRange("Document Type",PurchQuote."document type"::Quote);
    //         PurchQuote.SetRange("RFQ No.",QuoteEvaHeader."RFQ No.");

    //         NoofDocCreated := PurchQuote.Count;

    //         with QuoteEvaHeader do begin
    //           //approved supplier must exist
    //           if not SupplierExist(true) then
    //             Error(Text004);
    //           PurchReqLine.SetRange(PurchReqLine."Worksheet Template Name","Worksheet Template Name");
    //           PurchReqLine.SetRange(PurchReqLine."Journal Batch Name","No.");
    //           if not PurchReqLine.Find('-') then
    //             Error(Text004);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type",PurchReqSuppCombination."document type"::Quote);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.","No.");
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination.Confirmed,true);
    //           PurchReqSuppCombination.Find('-');
    //             repeat
    //             PurchQuote.SetRange("Document Type",PurchQuote."document type"::Quote);
    //             PurchQuote.SetRange("Buy-from Vendor No.",PurchReqSuppCombination."Registered Vendor No.");
    //             PurchQuote.SetRange("RFQ No.",QuoteEvaHeader."RFQ No.");
    //             if  not (PurchQuote.FindFirst) then begin
    //               NoofDoc := NoofDoc + 1;
    //               CreatePurchQuote2(QuoteEvaHeader,PurchReqSuppCombination."Registered Vendor No.",(NoofDoc + NoofDocCreated));
    //             end;
    //             until PurchReqSuppCombination.Next = 0;
    //         end;

    //         Message(Text006,NoofDoc,'Quote');
    //     end;


    //     procedure CreatePurchQuote2(QuoteEvaHeader: Record UnknownRecord52092344;SupplierNo: Code[20];SeqNo: Integer)
    //     var
    //         PurchReqLine: Record UnknownRecord52092345;
    //     begin
    //         with QuoteEvaHeader do begin
    //           if SupplierNo = '' then
    //             Error(Text007);

    //           // check vendor record
    //           Vendor.Get(SupplierNo);
    //           Vendor.TestField(Vendor.Name);
    //           Vendor.TestField(Vendor.Blocked,0);
    //           Vendor.TestField(Vendor."Vendor Posting Group");
    //           Vendor.TestField(Vendor."Gen. Bus. Posting Group");
    //           Vendor.TestField(Vendor."VAT Bus. Posting Group");

    //           // create purchase header
    //           PurchHeader.Init;
    //           PurchHeader."Document Type" := PurchHeader."document type"::Quote;
    //           PurchHeader."Responsibility Center" := UserMgt.GetPurchasesFilter();
    //           PurchHeader."No." := '';
    //           if SeqNo = 0 then
    //             PurchHeader."Suffix No." := "Suffix No."
    //           else
    //             PurchHeader."Suffix No." := "Suffix No." + '-' + Format(SeqNo);
    //             PurchHeader."Original Suffix No." := "Suffix No.";
    //           PurchHeader.Insert(true);
    //           PurchHeader.Validate(PurchHeader."Buy-from Vendor No.",SupplierNo);
    //           PurchHeader.Validate("Posting Date",Today);
    //           PurchHeader."Document Date" := Today;
    //           PurchHeader."Order Date" := Today;
    //           PurchHeader.Validate("Shipment Method Code","Shipment Method Code");
    //           PurchHeader.Validate("Requested Receipt Date","Expected Receipt Date");
    //           if "Shortcut Dimension 1 Code" <> '' then
    //             PurchHeader.Validate(PurchHeader."Shortcut Dimension 1 Code","Shortcut Dimension 1 Code");
    //           if "Shortcut Dimension 2 Code" <> '' then
    //             PurchHeader.Validate(PurchHeader."Shortcut Dimension 2 Code","Shortcut Dimension 2 Code");
    //           PurchHeader.Validate(PurchHeader."Document Date",Today);
    //           PurchHeader."RFQ No." := "RFQ No." ;
    //           PurchHeader."PRN No." := "PRN No.";
    //           PurchHeader."Beneficiary No." := "Requested By";
    //           PurchHeader."Purchaser Code" := "Purchaser Code";
    //           PurchHeader."Order Type" := "Order Type";
    //           PurchHeader."Purchase Req. Type" :=  Type;
    //           PurchHeader."Purchase Req. Code" := "Purchase Req. Code";

    //           //PurchHeader."Job No." := "Job No.";
    //           PurchHeader.Modify;

    //           PurchReqLine.SetRange(PurchReqLine."Worksheet Template Name","Worksheet Template Name");
    //           PurchReqLine.SetRange(PurchReqLine."Journal Batch Name","No.");
    //           PurchReqLine.Find('-');
    //           repeat
    //             if PurchReqLine.Type <> 0 then begin
    //               PurchLine.Init;
    //               PurchLine."Document Type" := PurchHeader."Document Type";
    //               PurchLine."Document No." := PurchHeader."No.";
    //               PurchLine.Validate("Buy-from Vendor No.",PurchHeader."Buy-from Vendor No.");
    //               PurchLine."Line No." := PurchReqLine."Line No.";
    //               case PurchReqLine.Type of
    //                // 0 : PurchLine.Type := 0;                                                           // blank
    //                 1 : PurchLine.Type := PurchLine.Type::"G/L Account";                               // g/l
    //                 2 : PurchLine.Type := PurchLine.Type::Item;                                        // item
    //                 3 : PurchLine.Type := PurchLine.Type::"Fixed Asset";                               // fixed asset
    //               end; /*end case*/
    //               PurchLine.Validate(PurchLine."No.",PurchReqLine."No.");
    //               PurchLine.Validate(PurchLine."Location Code",PurchReqLine."Location Code");
    //               PurchLine."Planned Receipt Date" := "Expected Receipt Date";
    //               PurchLine.Description := PurchReqLine.Description;
    //               PurchLine."Description 2" := PurchReqLine."Description 2";
    //               PurchLine.Validate(PurchLine."Unit of Measure",PurchReqLine."Unit of Measure Code");
    //               PurchLine.Validate(PurchLine.Quantity,PurchReqLine."Requested Quantity");
    //               PurchLine."Qty. to Invoice" := 0;
    //               PurchLine."Qty. to Receive" := 0;
    //               PurchLine.Validate(PurchLine."Direct Unit Cost",PurchReqLine."Offered Unit Price");
    //               PurchLine."RFQ No." := PurchHeader."RFQ No.";
    //               PurchLine."PRN No." := PurchHeader."PRN No.";
    //               PurchLine."Requisition Line No." := PurchReqLine."Line No.";//Inserted By Sogo. 19.03.13
    //               PurchLine."Maintenance Code" := PurchReqLine."Maintenance Code";
    //               if PurchReqLine."Maintenance Code" <> '' then
    //                 PurchLine."FA Posting Type" := PurchLine."fa posting type"::Maintenance;
    //               PurchLine.Insert;
    //             end else begin //Insert Descriptive line
    //               PurchLine.Init;
    //               PurchLine."Document Type" := PurchHeader."Document Type";
    //               PurchLine."Document No." := PurchHeader."No.";
    //               PurchLine.Description := PurchReqLine.Description;
    //               PurchLine."Description 2" := PurchReqLine."Description 2";
    //               PurchLine."Line No." := PurchReqLine."Line No.";
    //               PurchLine."RFQ No." := PurchHeader."RFQ No.";
    //               PurchLine."PRN No." := PurchHeader."PRN No.";
    //               PurchLine.Insert;
    //             end;
    //           until PurchReqLine.Next = 0;
    //         end;

    //     end;


    //     procedure CancelQuoteEvaluation(QuoteEvaluation: Record UnknownRecord52092344)
    //     begin
    //         if Confirm(Text015) then begin
    //           PurchComment.Reset;
    //           PurchComment.SetCurrentkey("No.",Date,"User ID");
    //           PurchComment.SetRange("No.",QuoteEvaluation."No.");
    //           PurchComment.SetRange(Date,WorkDate);
    //           PurchComment.SetRange("User ID",UserId);
    //           if not (PurchComment.FindSet) then
    //             Error(Text016);

    //           //Cancel PRN
    //           /*PurchReq.SETRANGE("Worksheet Template Name",'P-REQ');
    //           PurchReq.SETRANGE(Name,QuoteEvaluation."PRN No.");
    //           IF PurchReq.FINDSET THEN
    //             PurchReq.MODIFYALL(Status,PurchReq.Status::Cancelled);

    //           // Cancel Quote
    //           PurchHeader.SETRANGE("Document Type",PurchHeader."Document Type"::Quote);
    //           PurchHeader.SETRANGE("RFQ No.",Name);
    //           IF PurchHeader.FINDSET THEN
    //             PurchHeader.MODIFYALL("Posted Status",PurchHeader."Posted Status"::Cancelled);*/

    //           //Cancel RFQ
    //           QuoteEvaluation.Status := QuoteEvaluation.Status::Cancelled;
    //           QuoteEvaluation.Modify;
    //         end;

    //     end;


    //     procedure SendRFQAsEmailAttachment(RFQHeader: Record "Requisition Wksh. Name")
    //     var
    //         PurchaserCode: Record "Salesperson/Purchaser";
    //         Text101: label 'REQUEST FOR QUOTE';
    //         Text102: label 'Find Attached Request for Quote %1.';
    //         Text103: label 'Preparing to send RFQ\\';
    //         RFQHeader2: Record "Requisition Wksh. Name";
    //         PurchVendor: Record UnknownRecord52092343;
    //         Vendor: Record Vendor;
    //         RFQReport: Report UnknownReport52092642;
    //         Subject: Text[250];
    //         Body: Text[250];
    //         FileNameServer: Text;
    //         SMTP: Codeunit "SMTP Mail";
    //         FileManagement: Codeunit "File Management";
    //     begin
    //         PurchaserCode.Get(RFQHeader."Purchaser Code");
    //         PurchaserCode.TestField("E-Mail");
    //         Window.Open(Text103 +
    //                     Text104 );
    //         Subject := Text101;
    //         Body := StrSubstNo(Text102,PurchHeader."No.");
    //         RFQHeader2:= RFQHeader;
    //         RFQHeader2.SetRecfilter;
    //         PurchVendor.SetRange(PurchVendor."Document Type",PurchVendor."document type"::Quote);
    //         PurchVendor.SetRange("Document No.",RFQHeader.Name);
    //         if PurchVendor.FindSet then begin
    //           repeat
    //             Vendor.Get(PurchVendor."Registered Vendor No.");
    //             Vendor.TestField("E-Mail");
    //             RFQReport.SetTableview(RFQHeader2);
    //             RFQReport.SetVendorFilter(PurchVendor."Registered Vendor No.");
    //             FileNameServer := FileManagement.ServerTempFileName('.pdf');
    //             RFQReport.SaveAsPdf(FileNameServer);
    //             Window.Update(1,Vendor.Name);
    //             SMTP.CreateMessage(COMPANYNAME,PurchaserCode."E-Mail",Vendor."E-Mail",Subject,Body,true);
    //             SMTP.AddAttachment(FileNameServer,StrSubstNo('RFQ %1.pdf',RFQHeader2.Name));
    //             SMTP.AddCC(PurchaserCode."E-Mail");
    //             SMTP.Send;
    //             Clear(RFQReport);
    //             if Erase(FileNameServer) then;
    //           until PurchVendor.Next = 0;
    //         end else
    //           Error(Text001);
    //         RFQHeader."Actual RFQ Issue Date" := Today;
    //         RFQHeader.Modify;
    //         Window.Close;
    //     end;


    //     procedure DeleteCommitment(DocumentNo: Code[20])
    //     var
    //         CommitmentEntry: Record UnknownRecord52092307;
    //     begin
    //         CommitmentEntry.SetRange("Document No.",DocumentNo);
    //         CommitmentEntry.DeleteAll;
    //     end;


    //     procedure PRNToPI(var PRNHeader: Record "Requisition Wksh. Name")
    //     var
    //         NoofDoc: Integer;
    //         PurchReqHeader2: Record UnknownRecord52092344;
    //         QuoteEvaHeader: Record UnknownRecord52092344;
    //         QuoteEvaLine: Record UnknownRecord52092345;
    //     begin
    //         NoofDoc := 0;
    //         with PRNHeader do begin
    //           //approved supplier must exist
    //           if not SupplierExist(true) then
    //             Error(Text004);
    //           ReqLine.SetRange(ReqLine."Worksheet Template Name",'P-REQ');
    //           ReqLine.SetRange(ReqLine."Journal Batch Name",Name);
    //           if not ReqLine.Find('-') then
    //             Error(Text004);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document Type",PurchReqSuppCombination."document type"::Requisition);
    //           PurchReqSuppCombination.SetRange(PurchReqSuppCombination."Document No.",Name);
    //           PurchReqSuppCombination.SetRange(Confirmed,true);
    //           if PurchReqSuppCombination.Count > 1 then
    //             Error(Text017);
    //           PurchReqSuppCombination.Find('-');
    //             repeat
    //               NoofDoc := NoofDoc + 1;
    //               CreatePIFromPRN(PRNHeader,PurchReqSuppCombination."Registered Vendor No.",NoofDoc);
    //             until PurchReqSuppCombination.Next = 0;

    //           if PurchReqHeader2.Get(PRNHeader."Worksheet Template Name",PRNHeader.Name) then begin
    //             PurchReqHeader2.DeleteLinks;
    //             PurchReqHeader2.Delete(true);
    //           end;

    //           PurchReqHeader.TransferFields(PRNHeader);
    //           PurchReqHeader.Status := PurchReqHeader.Status::"LPO Raised";
    //           PurchReqHeader.Insert;
    //           PurchReqHeader.CopyLinks(PRNHeader);
    //           ReqLine.SetRange("Worksheet Template Name","Worksheet Template Name");
    //           ReqLine.SetRange("Journal Batch Name",Name);
    //           if ReqLine.Find('-') then
    //             repeat
    //               PurchReqLine.TransferFields(ReqLine);
    //               PurchReqLine.Insert;
    //             until ReqLine.Next = 0;

    //           ApprovalMgt.PostApprovalEntries(RecordId,PurchReqHeader.RecordId,PurchReqHeader."No.");
    //           ApprovalMgt.DeletePostedApprovalEntries(RecordId);

    //           ReqLine.DeleteAll(true);
    //           DeleteLinks;
    //           OnMoveDocAttachFromOpenDocClosedDoc(PRNHeader,PurchReqHeader);
    //           OnBeforeDeleteDoc1(PRNHeader);
    //           Delete;
    //         end;

    //         Message(Text006,NoofDoc,'Purchase Invoice');
    //     end;


    //     procedure CreatePIFromPRN(PRNHeader: Record "Requisition Wksh. Name";SupplierNo: Code[20];SeqNo: Integer)
    //     begin
    //         with PRNHeader do begin
    //           if SupplierNo = '' then
    //             Error(Text007);
    //           LineNo := 10000;
    //           // check vendor record
    //           Vendor.Get(SupplierNo);
    //           Vendor.TestField(Vendor.Name);
    //           Vendor.TestField(Vendor.Blocked,0);
    //           Vendor.TestField(Vendor."Vendor Posting Group");
    //           Vendor.TestField(Vendor."Gen. Bus. Posting Group");
    //           Vendor.TestField(Vendor."VAT Bus. Posting Group");

    //           // create purchase Header
    //           PurchHeader.Init;
    //           PurchHeader."Document Type" := PurchHeader."document type"::Invoice;
    //           //PurchHeader."Responsibility Center" := UserMgt.GetPurchasesFilter();
    //           PurchHeader.Insert(true);
    //           PurchHeader.CopyLinks(PRNHeader);
    //           PurchHeader."No PO Attached" := true;
    //           PurchHeader.Validate(PurchHeader."Buy-from Vendor No.",SupplierNo);
    //           PurchHeader.Validate("Posting Date",Today);
    //           PurchHeader."Order Date" := Today;
    //           PurchHeader."Document Date" := Today;
    //           PurchHeader.Validate("Shipment Method Code","Shipment Method Code");
    //           PurchHeader.Validate("Requested Receipt Date","Expected Receipt Date");
    //           PurchHeader."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
    //           PurchHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
    //           PurchHeader."Dimension Set ID" := "Dimension Set ID";
    //           PurchHeader.Validate(PurchHeader."Document Date","Creation Date");
    //           PurchHeader."PRN No." := Name;
    //           PurchHeader."Beneficiary No." := "Beneficiary No.";
    //           PurchHeader."Purchaser Code" := "Purchaser Code";
    //           PurchHeader."Order Type" := "Order Type";
    //           PurchHeader."Purchase Req. Type" :=  Type;
    //           PurchHeader."Purchase Req. Code" :=  "Purchase Req. Code";
    //           PurchHeader."Dimension Set ID" := "Dimension Set ID";
    //           PurchHeader.Status := PurchHeader.Status::Released;
    //           PurchHeader."Currency Code" := "Currency Code";
    //           PurchHeader."Currency Factor" := "Currency Factor";
    //           PurchHeader.CopyLinks(PRNHeader);
    //           PurchHeader.Modify;

    //           ReqLine.SetRange(ReqLine."Worksheet Template Name",'P-REQ');
    //           ReqLine.SetRange(ReqLine."Journal Batch Name",Name);
    //           ReqLine.Find('-');
    //           repeat
    //             if ReqLine.Type <> 0 then begin
    //               PurchLine.Init;
    //               PurchLine."Document Type" := PurchHeader."Document Type";
    //               PurchLine."Document No." := PurchHeader."No.";
    //               PurchLine.SuspendStatusCheck(true);
    //               PurchLine.Validate("Buy-from Vendor No.",PurchHeader."Buy-from Vendor No.");
    //               PurchLine."Line No." := ReqLine."Line No.";
    //               case ReqLine.Type of
    //                // 0 : PurchLine.Type := 0;                                                           // blank
    //                 1 : PurchLine.Type := PurchLine.Type::"G/L Account";                               // g/l
    //                 2 : PurchLine.Type := PurchLine.Type::Item;                                        // item
    //                 3 : PurchLine.Type := PurchLine.Type::"Fixed Asset";                               // fixed asset
    //               end; /*end case*/
    //               PurchLine.Validate("No.",ReqLine."No.");
    //               PurchLine.Validate("Location Code",ReqLine."Location Code");
    //               PurchLine."Requested Receipt Date" := "Expected Receipt Date";
    //               PurchLine.Description := ReqLine.Description;
    //               PurchLine."Description 2" := ReqLine."Description 2";
    //               //Transfer Job Detail
    //               PurchLine."Job No." := ReqLine."Job No.";
    //               PurchLine."Job Task No." := ReqLine."Job Task No.";
    //               //PurchLine."Work Order No." := ReqLine."Work Order No.";
    //               //PurchLine."Work Order Task No." := ReqLine."Work Order Task No.";

    //               PurchLine.Validate("Unit of Measure Code",ReqLine."Unit of Measure Code");
    //               PurchLine.Validate(Quantity,ReqLine.Quantity);
    //               PurchLine.Validate("Direct Unit Cost",ReqLine."Offered Unit Price");
    //               PurchLine."Maintenance Code" := ReqLine."Maintenance Code";
    //               PurchLine."Dimension Set ID" := ReqLine."Dimension Set ID";
    //               PurchLine."Shortcut Dimension 1 Code" := ReqLine."Shortcut Dimension 1 Code";
    //               PurchLine."Shortcut Dimension 2 Code" := ReqLine."Shortcut Dimension 2 Code";
    //               PurchLine."Account No."  := ReqLine."Account No.";
    //               if ReqLine."Maintenance Code" <> '' then
    //                 PurchLine."FA Posting Type" := PurchLine."fa posting type"::Maintenance;
    //               PurchLine.Insert;
    //              end else begin //Insert Descriptive line
    //                PurchLine.Init;
    //                PurchLine."Document Type" := PurchHeader."Document Type";
    //                PurchLine."Document No." := PurchHeader."No.";
    //                PurchLine.Description := ReqLine.Description;
    //                PurchLine."Description 2" := ReqLine."Description 2";
    //                PurchLine."Line No." := ReqLine."Line No.";
    //                PurchLine."Requisition Line No." := ReqLine."Line No.";
    //                PurchLine.Insert;
    //              end;
    //              LineNo := LineNo + 10000;
    //           until ReqLine.Next = 0;
    //           PurchHook.CreateCommitment(PurchHeader);
    //         end;

    //     end;

    //     [IntegrationEvent(false, false)]
    //     local procedure OnMoveDocAttachFromOpenDoc1ToOpenDoc2(var Rec1: Record "Requisition Wksh. Name";var Rec2: Record "Requisition Wksh. Name")
    //     begin
    //     end;

    //     [IntegrationEvent(false, false)]
    //     local procedure OnMoveDocAttachFromOpenDocClosedDoc(var Rec1: Record "Requisition Wksh. Name";var Rec2: Record UnknownRecord52092344)
    //     begin
    //     end;

    //     [IntegrationEvent(false, false)]
    //     local procedure OnBeforeDeleteDoc1(var Rec1: Record "Requisition Wksh. Name")
    //     begin
    //     end;

    //     [IntegrationEvent(false, false)]
    //     local procedure OnBeforeDeleteDoc2(var Rec1: Record UnknownRecord52092344)
    //     begin
    //     end;
}

