Page 52092354 "Leave Adjustment"
{
    Caption = 'Leave Adjustment';
    DataCaptionFields = "Employee No.";
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Leave Application";
    SourceTableView = where("Entry Type"=filter("Positive Adjustment"|"Negative Adjustment"));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field(DocumentNo;"Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Year;"Year No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Year';
                }
                field(EmployeeNo;"Employee No.")
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
                field(EntryType;"Entry Type")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if "Entry Type" = "entry type"::Application then
                          Error(Text001);
                    end;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode;"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000005;"Leave FactBox")
            {
                SubPageLink = "Employee No."=field("Employee No.");
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
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
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
            }
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Choice := StrMenu(Text002,1);
        if Choice = 0 then
          Error(Text003);
        case Choice of
          1: "Entry Type" := 1;
          2: "Entry Type" := 2;
        end;
    end;

    var
        Employee: Record Employee;
        UserSetup: Record "User Setup";
        HRSetup: Record "Human Resources Setup";
        [InDataSet]
        "Emp Editable": Boolean;
        [InDataSet]
        "FromDate Editable": Boolean;
        [InDataSet]
        "ToDate Editable": Boolean;
        [InDataSet]
        "Quantity Editable": Boolean;
        [InDataSet]
        "Cause Editable": Boolean;
        [InDataSet]
        "Allowance Editable": Boolean;
        CalledFromApproval: Boolean;
        Text001: label 'Entry Type not allowed';
        Text002: label 'Add,Subtract';
        Text003: label 'Entry Type must specified';
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        Choice: Integer;
        Text004: label 'Do you want to process this adjustment';
        Text005: label 'Adjustment not processed';
        Text006: label 'Year must be specified';
        Text007: label 'Adjustment must be approved';
        Text008: label 'No. of Days must be specified';

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

