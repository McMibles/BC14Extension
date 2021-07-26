Page 52092406 "Appraisal - Line Manager"
{
    Caption = 'Performance';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Appraisal Header";
    SourceTableView = where(Closed=const(false),
                            Location=const(Appraiser));

    layout
    {
        area(content)
        {
            group(General)
            {
                field(AppraiseeNo;"Appraisee No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(FirstName;"First Name")
                {
                    ApplicationArea = Basic;
                }
                field(LastName;"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(MiddleName;"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCategory;"Employee Category")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Category';
                }
                field(AppraisalType;"Appraisal Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DateAppraised;"Date Appraised")
                {
                    ApplicationArea = Basic;
                }
                field(SectionalWeightScore;"Sectional Weight Score")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Recommendations)
            {
                field(Recommendation;Recommendation)
                {
                    ApplicationArea = Basic;
                }
                field(RecommendedCode;"Recommended Code")
                {
                    ApplicationArea = Basic;
                }
                field(RecommendedSalIncrease;"Recommended Sal % Increase")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000013;"Appraisal SubForm")
            {
                Caption = 'Performance Lines';
                SubPageLink = "Appraisal Period"=field("Appraisal Period"),
                              "Appraisal Type"=field("Appraisal Type"),
                              "Employee No."=field("Appraisee No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Function")
            {
                Caption = 'Function';
                action("Skill Gaps and Training")
                {
                    ApplicationArea = Basic;
                    Image = Skills;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Appraisal Skill Gap";
                    RunPageLink = "Appraisal Period"=field("Appraisal Period"),
                                  "Appraisal Type"=field("Appraisal Type"),
                                  "Employee No."=field("Appraisee No.");
                }
            }
            group(Release)
            {
                Caption = 'Request';
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
                        "Appraisal Ready" := true;
                        RecRef.GetTable(Rec);
                        ReleaseDocument.PerformanualManualDocRelease(RecRef);
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
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("Send &Approval Request")
                {
                    ApplicationArea = Basic;
                    Enabled = not OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        "Appraisal Ready" := true;
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
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
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                        "Appraisal Ready" := false;
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
        /*FILTERGROUP(2);
        UserSetup.GET(USERID);
        UserSetup.TESTFIELD("Employee No.");
        SETRANGE("Manager No.",UserSetup."Employee No.");
        FILTERGROUP(0);*/

    end;

    var
        Grading: Record "Appraisal Grading";
        Employee: Record Employee;
        AppraisalLine: Record "Appraisal Lines";
        StaffRatingSetup: Record "Employee Category Rating Setup";
        AppraisalSection: Record "Appraisal Section";
        AppraisalHeader1: Record "Appraisal Header";
        AppraisalHeader2: Record "Appraisal Header";
        AppraisalGrading: Record "Appraisal Grading";
        UserSetup: Record "User Setup";
        YearNo: Integer;
        AppraisalType: Option " ","Mid-Year","Year-End";
        Window: Dialog;
        Text001: label 'Appraisal Type cannot be blank!';
        Text002: label 'Entry Already Submitted';
        Text003: label 'Pls Complete the Rating For EmployeeNo %1 For %2 Before Submiting';
        Text004: label 'Are You Sure You Want To Submit This Entry?';
        Text005: label 'Entry Successfully Submitted';
        CurrPeriod: Code[20];
        Text006: label 'Recommendation already applied. Contact HR';
        Text007: label 'This will recall the entries, Continue Anyway?';
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

