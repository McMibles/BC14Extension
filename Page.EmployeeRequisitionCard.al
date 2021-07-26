Page 52092369 "Employee Requisition Card"
{
    Caption = 'Employee Requistion Card';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Employee Requisition";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
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
                field(RequestedBy;RequestedBy)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requested By';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Administration)
            {
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
                field(ExpectedApptmtDate;"Expected Apptmt. Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CommittedDateofAppmt;"Committed Date of Appmt.")
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
                field(MinWorkingExperience;"Min. Working Experience")
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
            action("<Action1000000033>")
            {
                ApplicationArea = Basic;
                Caption = 'Search Employee Profile';
                Enabled = false;
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    TestField("Job Title Code");
                    TestField("Internal/External","internal/external"::Internal);
                    TestField("No. Required");
                    EmpReq.Copy(Rec);
                    EmpReq.SetRecfilter;
                    EmployeeSearch.SetTableview(EmpReq);
                    EmployeeSearch.SetRequirement("No.");
                    EmployeeSearch.RunModal;
                    Clear(EmployeeSearch);
                    CurrPage.Update(false);
                end;
            }
            action("Import External Applicants")
            {
                ApplicationArea = Basic;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ImportApplicantFrmExcel.SetParameters("No.");
                    ImportApplicantFrmExcel.RunModal;
                end;
            }
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
            group(Request)
            {
                action(Release)
                {
                    ApplicationArea = Basic;
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;

                    trigger OnAction()
                    var
                        ReleaseDocument: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformanualManualDocRelease(RecRef);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("<Action1000000032>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetUserName;
        SetControlAppearance
    end;

    var
        RecRef: RecordRef;
        EmpReq: Record "Employee Requisition";
        EmployeeSearch: Report "Search Employee Profile";
        ImportApplicantFrmExcel: Report "Import External Applicants";
        UserSetup: Record "User Setup";
        RequestedBy: Text[250];
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;


    procedure GetUserName()
    begin
        if "Requested By" <> '' then begin
          UserSetup.SetRange(UserSetup."Employee No.","Requested By");
          if UserSetup.FindFirst then
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

