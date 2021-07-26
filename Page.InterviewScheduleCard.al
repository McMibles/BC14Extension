Page 52092372 "Interview Schedule Card"
{
    DeleteAllowed = false;
    PageType = Document;
    SourceTable = "Interview Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmpRequisitionCode; "Emp. Requisition Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(VenueCode; "Venue Code")
                {
                    ApplicationArea = Basic;
                }
                field(VenueDescription; "Venue Description")
                {
                    ApplicationArea = Basic;
                }
                field(Address; Address)
                {
                    ApplicationArea = Basic;
                }
                field(Address2; "Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(InterviewDate; "Interview Date")
                {
                    ApplicationArea = Basic;
                }
                field(InterviewTime; "Interview Time")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; "Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(Stage; Stage)
                {
                    ApplicationArea = Basic;
                }
                field(NotoInterview; "No. to Interview")
                {
                    ApplicationArea = Basic;
                }
                field(InterviewingOfficers; "Interviewing Officers")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000019; "Interview Schedule SubForm")
            {
                SubPageLink = "Interview No." = field("No.");
            }
            group(Administration)
            {
                field(ResponsibleEmplNo; "Responsible Empl. No.")
                {
                    ApplicationArea = Basic;
                }
                field(PrevInterviewRefNo; "Prev. Interview Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("<Action1000000020>")
            {
                Caption = 'Functions';
                action("<Action1000000021>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Short-List';
                    Image = Suggest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        InterviewHeader.Copy(Rec);
                        InterviewHeader.SetRecfilter;
                        ShortList.SetTableview(InterviewHeader);
                        ShortList.SetRequirement("Emp. Requisition Code");
                        ShortList.RunModal;
                        Clear(ShortList);
                        CurrPage.Update(false);
                    end;
                }
                group(ApplicantInvitation)
                {
                    Caption = 'Applicant Invitation';
                    Image = HumanResources;
                    action("<Action1000000023>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Applicant Invitation Letter';
                        Image = SendElectronicDocument;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        begin
                            InterviewHeader.SetRange(InterviewHeader."No.", "No.");
                            // InterviewInvitation.SetTableview(InterviewHeader);
                            // InterviewInvitation.Run;
                        end;
                    }
                    action("<Action1000000024>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'E-Mail Invitation';
                        Enabled = false;
                        Image = Email;
                        Visible = false;

                        trigger OnAction()
                        begin
                            ApplicantEmailInv;
                        end;
                    }
                    action(MobileInvitation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Mobile Invitation';
                        Image = Calls;

                        trigger OnAction()
                        begin
                            ApplicantMobileInv;
                        end;
                    }
                }
                group("<Action1000000026>")
                {
                    Caption = 'Interview Panel Invitation';
                    action("<Action1000000031>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Interviewer Invitation Leter';
                        Image = SendElectronicDocument;
                        Promoted = true;
                        PromotedCategory = Process;

                        trigger OnAction()
                        begin
                            InterviewHeader.SetRange(InterviewHeader."No.", "No.");
                            // InterviewerInvitation.SetTableview(InterviewHeader);
                            // InterviewerInvitation.Run;
                        end;
                    }
                    action(EmailInvitation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'E-mail Invitation';
                        Enabled = false;
                        Image = Email;
                        Visible = false;

                        trigger OnAction()
                        begin
                            NotifyPanel(1);
                        end;
                    }
                    action("<Action1000000028>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Mobile Invitation';
                        Image = Calls;

                        trigger OnAction()
                        begin
                            NotifyPanel(2);
                        end;
                    }
                }
                action("<Action1000000019>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Discontinue Interview';
                    Image = Stop;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if not Confirm(Text006, false) then
                            exit;

                        if Confirm(Text007, false) then begin
                            JobVacancy.Get("Emp. Requisition Code");
                            JobVacancy.Status := JobVacancy.Status::Discontinued;
                            JobVacancy.Modify;
                        end;

                        Status := Status::Discontinued;
                        "Schedule Closed" := true;

                        //Close Interviewers score sheet
                        Interviewer.SetRange("Schedule Code", "No.");
                        Interviewer.ModifyAll("Schedule Closed", true);

                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        InterviewHeader: Record "Interview Header";
        InterviewLine: Record "Interview Line";
        Applicant: Record Applicant;
        HrSetup: Record "Human Resources Setup";
        JobVacancy: Record "Employee Requisition";
        Interviewer: Record Interviewer;
        UserSetup: Record "User Setup";
        Employee: Record Employee;
        GlobalText: Text[160];
        ShortList: Report "Short-List Applicant";
        //InterviewInvitation: Report "Invitation for Interview";
        //InterviewerInvitation: Report "Interviewer Invitation";
        ApplicantMobile: Text[80];
        GlobalSender: Text[80];
        CurrErrMessage: Text[80];
        SMTP: Codeunit "SMTP Mail";
        ApprovalNotification: Codeunit "Approvals Mgmt.";
        Body: Text[200];
        Subject: Text[200];
        Choice: Integer;
        Text001: label 'You are hereby invited for an interview at %1, Venue is %2, Date %3 and Time %4';
        Text002: label 'This is to notify you that interview for the position of %1 will held at %2 on %3 at %4 prompt and your presence is highly required';
        Text003: label 'Line is empty!';
        Text004: label 'Invitation was successfully sent!';
        Text005: label 'Interviewing Officers not yet selected!';
        Text006: label 'Are you sure you want to discontinue this interview?';
        Text007: label 'Do you want to discontinue the Job Vacancy as well!';
}

