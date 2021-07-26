Page 52092383 "Closed Interview Card"
{
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Interview Header";
    SourceTableView = where(Status = const(Hired),
                            "Interview Closed" = const(true));

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
    }

    var
        InterviewHeader: Record "Interview Header";
        InterviewLine: Record "Interview Line";
        Applicant: Record Applicant;
        HrSetup: Record "Human Resources Setup";
        GlobalText: Text[160];
        //ShortList: Report "Short-List Applicant";
        //InterviewInvitation: Report "Invitation for Interview";
        ApplicantMobile: Text[80];
        GlobalSender: Text[80];
        SMTP: Codeunit "SMTP Mail";
        ApprovalNotification: Codeunit "Approvals Mgmt.";
        Body: Text[200];
        Subject: Text[200];
        Choice: Integer;
        Text001: label 'You are hereby invited for an interview at %1, Venue is %2, Date %3 and Time %4';
        Text002: label 'This is to notify you that interview for the position of %1 will held at %2 on %3 at %4 prompt and your presence is highly required';
        Text003: label 'Line is empty!';
        Text004: label 'Message was successfully sent!';
        Text005: label 'Interviewing Officers not yet selected!';

    /*
        procedure NotifyPanel(Choice: Integer)
        var
            Interviewer: Record Interviewer;
            InterviewLines: Record "Interview Line";
        begin
            GlobalSender := 'HR DEPARTMENT';
            InterviewLines.Reset;
            InterviewLines.SetRange(InterviewLines."Interview No.", "No.");
            InterviewLines.SetFilter(InterviewLines."Applicant No.", '<>%1', '');
            if not InterviewLines.FindFirst then
                Error(Text003);

            Interviewer.Reset;
            Interviewer.SetRange(Interviewer."Schedule Code", "No.");
            if Interviewer.FindFirst then begin
                if Choice <> 0 then begin
                    repeat
                        CreateResultSheet(Interviewer);
                        Body := StrSubstNo(Text002, Description, "Venue Description", "Interview Date", "Interview Time");
                        Subject := 'RECRUITMENT INTERVIEW';
                        case Choice of
                            1:
                                begin
                                    SMTP.CreateMessage('HR DEPT.', 'a.adeyemi@gems-consult.com', Interviewer."E-Mail", Subject, Body, false);
                                    SMTP.Send;
                                end;
                        //2:BEGIN
                          //SendSMS.SendURLSMS(Interviewer."Mobile No.",Body,GlobalSender);
                        //END;
                        end;
                    until Interviewer.Next = 0;
                    if Choice = 1 then
                        Message(Text004);
                end;
            end else begin
                Error(Text005);
            end;

        end;


        procedure CreateResultSheet(CurrRec: Record Interviewer)
        var
            InterviewDetailLines: Record "Interview Line";
            InterviewDetailScoreSheet: Record "Interviewer Score Details";
        begin
            InterviewDetailLines.Reset;
            InterviewDetailLines.SetRange(InterviewDetailLines."Interview No.", "No.");
            InterviewDetailLines.FindFirst;
            repeat
                InterviewDetailScoreSheet."Ref. No." := InterviewDetailLines."Interview No.";
                InterviewDetailScoreSheet."Line No." := InterviewDetailLines."Line No.";
                InterviewDetailScoreSheet."Job Ref. No." := InterviewDetailLines."Emp. Requisition Code";
                InterviewDetailScoreSheet."Applicant No." := InterviewDetailLines."Applicant No.";
                InterviewDetailScoreSheet.Name := InterviewDetailLines.Name;
                InterviewDetailScoreSheet."Interviewer Code" := CurrRec."Employee Code";
                if not (InterviewDetailScoreSheet.Insert) then
                    InterviewDetailScoreSheet.Modify;
            until InterviewDetailLines.Next = 0;
        end;
    */
}
