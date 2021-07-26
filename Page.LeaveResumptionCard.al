Page 52092477 "Leave Resumption Card"
{
    PageType = Card;
    SourceTable = "Leave Resumption";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
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
                field(YearNo;"Year No.")
                {
                    ApplicationArea = Basic;
                }
                field(LeaveStartDate;"Leave Start Date")
                {
                    ApplicationArea = Basic;
                }
                field(ExpectedResumptionDate;"Expected Resumption Date")
                {
                    ApplicationArea = Basic;
                }
                field(ActualResumptionDate;"Actual Resumption Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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
            }
            group(Variance)
            {
                Caption = 'Variance';
                Enabled = EnableEdit;
                field(Control9;Variance)
                {
                    ApplicationArea = Basic;
                }
                field(VariancetoPost;"Variance to Post")
                {
                    ApplicationArea = Basic;
                }
                field(VarianceComment;"Variance Comment")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    MultiLine = true;
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
                    ApprovalEntries.Setfilters(Database::"Leave Resumption",6,"Document No.");
                    ApprovalEntries.Run;
                end;
            }
        }
        area(processing)
        {
            action(Process)
            {
                ApplicationArea = Basic;
                Enabled = EnableControl;
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    LeaveApplication: Record "Leave Application";
                begin
                    if not Confirm(ConfirmText) then begin
                      Message(ConfirmMsg);
                      exit;
                    end;
                    CauseofAbsence.Get("Cause of Absence Code");
                    HRSetup.Get;
                    if "Variance to Post" <> 0 then begin
                      LeaveApplication.Init;
                      LeaveApplication."Document No." := "Document No.";
                      LeaveApplication."Employee No." := "Employee No.";
                      LeaveApplication."Employee Name" := "Employee Name";
                      LeaveApplication."From Date" := WorkDate;
                      LeaveApplication."Cause of Absence Code" := "Cause of Absence Code";
                      LeaveApplication."Year No." := "Year No.";
                      if "Variance to Post" < 0 then
                        LeaveApplication."Entry Type" := LeaveApplication."entry type"::"Negative Adjustment"
                      else
                        LeaveApplication."Entry Type" := LeaveApplication."entry type"::"Positive Adjustment";
                      LeaveApplication.Description := 'Rolled Over Leave Cancellation';
                      LeaveApplication.Validate("Unit of Measure Code",CauseofAbsence."Unit of Measure Code");
                      LeaveApplication.Validate(Quantity,"Variance to Post");
                      LeaveApplication.Insert;
                      LeaveMgt.PostLeave(LeaveApplication);
                    end;
                    Message('Resumption Proessed');
                    Processed := true;
                    Modify;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetControlAppearance
    end;

    var
        ConfirmText: label 'Do you want to process leave resumption?';
        HRSetup: Record "Human Resources Setup";
        CauseofAbsence: Record "Cause of Absence";
        Employee: Record Employee;
        LeaveMgt: Codeunit LeaveManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ConfirmMsg: label 'Action Cancelled';
        EnableEdit: Boolean;
        EnableControl: Boolean;

    local procedure SetControlAppearance()
    begin
        EnableControl := not(Processed);
        EnableEdit := not(Processed);
    end;
}

