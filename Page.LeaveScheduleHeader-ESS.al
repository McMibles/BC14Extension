Page 52092346 "Leave Schedule Header -ESS"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Leave Schedule Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field(YearNo;"Year No.")
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
                    Caption = 'Employee Name';
                }
                field(AbsenceCode;"Absence Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    HideValue = true;
                    Visible = false;
                }
                field(ManagerNo;"Manager No.")
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
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysBF;"No. of Days B/F")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysEntitled;"No. of Days Entitled")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysAdded;"No. of Days Added")
                {
                    ApplicationArea = Basic;
                }
                field("<No. of Days Subtracted>";"No. of Days Subtracted")
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of Days Subtracted';
                }
                field(NoofDaysUtilised;"No. of Days Utilised")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000011;"Leave Schedule Line")
            {
                Editable = "Schedule Line Editable" ;
                SubPageLink = "Year No."=field("Year No."),
                              "Employee No."=field("Employee No."),
                              "Absence Code"=field("Absence Code");
            }
        }
        area(factboxes)
        {
            part(Control6;"Leave FactBox")
            {
                SubPageLink = "Year No."=field("Year No."),
                              "Employee No."=field("Employee No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Release)
            {
                action(Action3)
                {
                    ApplicationArea = Basic;
                    Caption = 'Release';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocs: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocs.PerformanualManualDocRelease(RecRef);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reopen';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        RecRef: RecordRef;
                        ReleaseDocs: Codeunit "Release Documents";
                    begin
                        RecRef.GetTable(Rec);
                        ReleaseDocs.PerformManualReopen(RecRef);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                action("<Action1000000013>")
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
                        ApprovalsMgmt: Codeunit "Approvals Hook";
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("<Action1000000014>")
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
        EnableFields;
        SetControlAppearance
    end;

    trigger OnInit()
    begin
        "Schedule Line Editable" := true;
    end;

    trigger OnOpenPage()
    begin
        HRSetup.Get;
        SetRange("Absence Code",HRSetup."Annual Leave Code");
        SetFilter("Year Filter",'..%1',Date2dmy(Today,3) - 1);
    end;

    var
        HRSetup: Record "Human Resources Setup";
        UserSetup: Record "User Setup";
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        EmployeeName: Text[200];
        [InDataSet]
        "Schedule Line Editable": Boolean;
        CalledFromApproval: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        StartDate: Date;
        PreviousDate: Date;
        PreviousYr: Integer;


    procedure EnableFields()
    begin
        if Status in [1,2] then
          "Schedule Line Editable" := false
        else
          "Schedule Line Editable" := true;
    end;


    procedure SetCalledFromApproval()
    begin
        CalledFromApproval := true;
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
    end;

    local procedure GetLeaveBF()
    begin
    end;
}

