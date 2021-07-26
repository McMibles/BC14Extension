Page 52092355 "Leave Adjustments"
{
    CardPageID = "Leave Adjustment";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = "Leave Application";
    SourceTableView = where("Entry Type"=filter("Positive Adjustment"|"Negative Adjustment"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo;"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(CauseofAbsenceCode;"Cause of Absence Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(YearNo;"Year No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType;"Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Approvals)
            {
                ApplicationArea = Basic;
                Image = Approvals;

                trigger OnAction()
                var
                    ApprovalEntries: Page "Approval Entries";
                begin
                    ApprovalEntries.Setfilters(Database::"Leave Application",6,"Document No.");
                    ApprovalEntries.Run;
                end;
            }
        }
        area(processing)
        {
            group(Release)
            {
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocument: Codeunit "Release Documents";
                    begin
                        TestField("Cause of Absence Code");
                        TestField(Quantity);
                        TestField("Employee No.");
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformanualManualDocRelease(RecRef);
                        CurrPage.Update;
                    end;
                }
                action("Re&open")
                {
                    ApplicationArea = Basic;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocument: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformManualReopen(RecRef);
                        CurrPage.Update;
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("<Action1000000006>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalMgt: Codeunit "Approvals Hook";
                    begin
                        TestField("Cause of Absence Code");
                        TestField(Quantity);
                        TestField("Employee No.");
                        RecRef.GetTable(Rec);
                        if ApprovalMgt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalMgt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("Cancel Approval Re&quest")
                {
                    ApplicationArea = Basic;
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalMgt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalMgt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Process)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Adjustment';
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalMgt: Codeunit "Approvals Mgmt.";
                    begin
                        if not Confirm(Text004) then
                          Error(Text005);

                        if Status <> Status::Approved then
                          Error(Text007);

                        if "Year No." = 0 then
                          Error(Text006);

                        if "Quantity (Base)" = 0 then
                          Error(Text008);

                        PostLeave;

                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance;
    end;

    var
        Text001: label 'Entry Type not allowed';
        Text002: label 'Add,Subtract';
        Text003: label 'Entry Type must specified';
        Text004: label 'Do you want to process this adjustment';
        Text005: label 'Adjustment not processed';
        Text006: label 'Year must be specified';
        Text007: label 'Adjustment must be approved';
        Text008: label 'No. of Days must be specified';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

