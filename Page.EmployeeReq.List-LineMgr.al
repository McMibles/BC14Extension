Page 52092418 "Employee Req. List- Line Mgr"
{
    Caption = 'Employee Requisition';
    CardPageID = "Employee Req. Card - Line Mgr";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = "Employee Requisition";
    SourceTableView = where("Request Position"=const("With Requestor"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(JobTitleCode;"Job Title Code")
                {
                    ApplicationArea = Basic;
                }
                field(Designation;Designation)
                {
                    ApplicationArea = Basic;
                }
                field(OpenDate;"Open Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoRequired;"No. Required")
                {
                    ApplicationArea = Basic;
                }
                field(EmploymentStatus;"Employment Status")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(ExpectedApptmtDate;"Expected Apptmt. Date")
                {
                    ApplicationArea = Basic;
                }
                field(CommittedDateofAppmt;"Committed Date of Appmt.")
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
            group(EmpRequistion)
            {
                Caption = 'Emp. Requistion';
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;

                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(Database::"Employee Requisition",0,"No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("<Action1000000012>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    Image = Skills;
                    RunObject = Page "Skill Entry-Others";
                    RunPageLink = "Record Type"=const(Vacancy),
                                  "No."=field("No.");
                }
                action("<Action1000000013>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    RunObject = Page "Job/Vacancy Qualifications";
                    RunPageLink = "Record Type"=const(Vacancy),
                                  "No."=field("No.");
                }
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
                        RecRef.GetTable(Rec);
                        if ApprovalMgt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalMgt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("<Action1000000007>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
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
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance
    end;

    trigger OnOpenPage()
    begin
        FilterGroup(2);
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        SetRange("Requested By",UserSetup."Employee No.");
        FilterGroup(0);
    end;

    var
        UserSetup: Record "User Setup";
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

