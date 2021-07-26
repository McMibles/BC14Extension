Codeunit 52092134 "Record Insert Event"
{
    Permissions = TableData "Approval Entry" = imd,
                  TableData "Approval Comment Line" = imd,
                  TableData "Posted Approval Entry" = imd,
                  TableData "Posted Approval Comment Line" = imd,
                  TableData "Overdue Approval Entry" = imd,
                  TableData "Notification Entry" = imd;

    trigger OnRun()
    begin
    end;

    var
        InvtSetup: Record "Inventory Setup";
        UserSetup: Record "User Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecordRestriction: Codeunit "Record Restriction Mgt.";

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    begin
        Rec."User ID" := UserId;
        Rec."Creation Date" := WorkDate;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnModifyCustomer(var Rec: Record Customer; var xRec: Record Customer; RunTrigger: Boolean)
    begin
        //RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertVendor(var Rec: Record Vendor; RunTrigger: Boolean)
    begin
        Rec."User ID" := UserId;
        Rec."Creation Date" := WorkDate;
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnModifyVendor(var Rec: Record Vendor; var xRec: Record Vendor; RunTrigger: Boolean)
    begin
        //RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertItem(var Rec: Record Item; RunTrigger: Boolean)
    begin
        /*Rec."User ID" := USERID;
        Rec."Allow SRN On Item" := TRUE;
        Rec."Creation Date" := WORKDATE;*/

    end;

    [EventSubscriber(ObjectType::Table, Database::Employee, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertEmployee(var Rec: Record Employee; RunTrigger: Boolean)
    begin
        Rec."Date Created" := WorkDate;
        Rec."Userd ID" := UserId;
    end;

    [EventSubscriber(ObjectType::Table, Database::Employee, 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyEmployee(var Rec: Record Employee; var xRec: Record Employee; RunTrigger: Boolean)
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Employee, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnModifyEmployee(var Rec: Record Employee; var xRec: Record Employee; RunTrigger: Boolean)
    var
        HumanResSetup: Record "Human Resources Setup";
        Text50004: label 'Automatic update of Payroll record not enabled, ensure that you manually update the payroll record';
    begin
        HumanResSetup.Get;
        if HumanResSetup."AutoUpdatePayroll Employee" then
            Rec.CreateEmployeePayrollRecord
        else
            Message(Text50004);
        Rec."Last Modified By" := UserId;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure OnCompanyInitialise()
    begin
        InitSetupTables;
    end;

    local procedure InitSetupTables()
    var
        PayrollSetup: Record "Payroll-Setup";
        PmtMgtSetup: Record "Payment Mgt. Setup";
    begin
        with PayrollSetup do
            if not FindFirst then begin
                Init;
                Insert;
            end;

        with PmtMgtSetup do
            if not FindFirst then begin
                Init;
                Insert;
            end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        with CustLedgerEntry do begin
            "WHT Posting Group" := GenJournalLine."WHT Posting Group";
            "Source Customer No." := GenJournalLine."Source Vend/Cust  No.";
            "Customer Entry No." := GenJournalLine."Vend/Cust Entry No.";
            "Source Amount" := GenJournalLine."Source Amount";
            "Source Invoice No." := GenJournalLine."Source Invoice No.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        with VendorLedgerEntry do begin
            "Source Vendor No." := GenJournalLine."Source Vend/Cust  No.";
            "Vendor Entry No." := GenJournalLine."Vend/Cust Entry No.";
            "Source PI No." := GenJournalLine."Source Invoice No.";
            "Source PO No." := GenJournalLine."Source Order No.";
            "Source Amount" := GenJournalLine."Source Amount";
            "WHT Posting Group" := GenJournalLine."WHT Posting Group";
            "PO No." := GenJournalLine."Order No.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeModifyEvent', '', false, false)]
    local procedure OnBeforeModifyApprovalEntry(var Rec: Record "Approval Entry"; var xRec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        RandomOTPApprovalSetup: Record "Random OTP Approval Setup";
        OTPTimeGenerated: Time;
        DeliveryStatus: Text;
        ImputMessageText: Text;
    begin
        if (Rec."OTP Approval Required") and (UserId = Rec."Approver ID") and (Rec.Status = Rec.Status::Approved) then begin
            Rec.Validate("Random OTP", RandomOTPApprovalSetup.GenerateRandomOTP(Rec."Table ID", OTPTimeGenerated));
            if RandomOTPApprovalSetup.SendOTPViaSmS(Rec."Entry No.", Rec."Random OTP", OTPTimeGenerated, DeliveryStatus, ImputMessageText) = true then
                if RandomOTPApprovalSetup.MatchOTPInput(Rec."Entry No.", RandomOTPApprovalSetup.OTPRequestInputForm(Rec."Entry No.", ImputMessageText)) = false then
                    Error('Mismatch OTP');
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsert(var Rec: Record "Approval Entry"; RunTrigger: Boolean)
    var
        RandomOTPApprovalSetupRec: Record "Random OTP Approval Setup";
    begin
        Rec."OTP Approval Required" := RandomOTPApprovalSetupRec.OTPApprovalRequired(Rec."Table ID", Rec."Amount (LCY)");
        if Rec."OTP Approval Required" then
            Rec."Mobile Phone No" := RandomOTPApprovalSetupRec.GetMobilNo(Rec."Approver ID");
        Rec.Modify;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Employee Ledger Entry", 'OnAfterCopyEmployeeLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyEmployeeLedgerEntryFromGenJnlLine(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        EmployeeLedgerEntry."Entry Type" := GenJournalLine."Entry Type";
        EmployeeLedgerEntry."Cash Advance Doc. No." := GenJournalLine."Cash Advance Doc. No."
    end;
}

