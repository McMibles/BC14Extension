Page 52092417 "Employee Req. Card - Line Mgr"
{
    Caption = 'Employee Requistion';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Employee Requisition";
    SourceTableView = where("Request Position"=const("With Requestor"));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No;"No.")
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
                field(NatureofRequest;"Nature of Request")
                {
                    ApplicationArea = Basic;
                }
                field(ForWhom;"For Whom")
                {
                    ApplicationArea = Basic;
                }
                field(EmploymentType;"Employment Type")
                {
                    ApplicationArea = Basic;
                }
                field(TemporaryPeriod;"Temporary Period")
                {
                    ApplicationArea = Basic;
                }
                field(OpenDate;"Open Date")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(InternalExternal;"Internal/External")
                {
                    ApplicationArea = Basic;
                }
                field(NoRequired;"No. Required")
                {
                    ApplicationArea = Basic;
                }
                field(NoofApplicant;"No. of Applicant")
                {
                    ApplicationArea = Basic;
                }
                field(RequestedBy;"Requested By")
                {
                    ApplicationArea = Basic;
                    Caption = 'Requested By';
                }
                field(ExpectedApptmtDate;"Expected Apptmt. Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Administration)
            {
                Editable = false;
                field(EmploymentStatus;"Employment Status")
                {
                    ApplicationArea = Basic;
                }
                field(GradeLevel;"Grade Level")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                }
                field(SalaryGroup;"Salary Group")
                {
                    ApplicationArea = Basic;
                }
                field(ExpectedSalary;"Expected Salary")
                {
                    ApplicationArea = Basic;
                }
                field(ApprovedEstablishment;"Approved Establishment")
                {
                    ApplicationArea = Basic;
                }
                field(PresentNoofEmployee;"Present No. of Employee")
                {
                    ApplicationArea = Basic;
                }
                field(Vacancies;Vacancies)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Requirement)
            {
                Editable = false;
                field(MinWorkingExperience;"Min. Working Experience")
                {
                    ApplicationArea = Basic;
                }
                field(RequiredState;"Req. State Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Required State';
                }
                field(RequiredLocalGovt;"Req. LG")
                {
                    ApplicationArea = Basic;
                    Caption = 'Required Local Govt.';
                }
                field(RequiredGender;"Req. Gender")
                {
                    ApplicationArea = Basic;
                    Caption = 'Required Gender';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(EmpRequisition)
            {
                Caption = 'Emp. Requisition';
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
                action("<Action1000000036>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Skills';
                    Image = Skills;
                    RunObject = Page "Skill Entry-Others";
                    RunPageLink = "Record Type"=const(Vacancy),
                                  "No."=field("No.");
                }
                action(Qualifications)
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

    var
        RecRef: RecordRef;
        EmpReq: Record "Employee Requisition";
        EmployeeSearch: Report "Search Employee Profile";
        UserSetup: Record "User Setup";
        Employee: Record Employee;
        RequestedBy: Text[250];
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;


    procedure GetUserName()
    begin
        if "Requested By" <> '' then begin
          UserSetup.Get("Requested By");
          RequestedBy := UserSetup.GetUserName;
        end;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;
}

