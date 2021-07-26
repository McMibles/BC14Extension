Page 52092377 "Interview Result Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Interview Header";
    SourceTableView = where(Status = filter(Invited | Hired),
                            "Interview Closed" = const(false));

    layout
    {
        area(content)
        {
            group(Group)
            {
                Editable = false;
                field(No; "No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmpRequisitionCode; "Emp. Requisition Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(InterviewDate; "Interview Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(InterviewTime; "Interview Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Stage; Stage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Level; Level)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Pass Mark Level")
            {
                field(PassMark; "Pass Mark")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Result Line")
            {
                Caption = 'Result Line';
                part(Control1000000014; "Interview Result SubForm")
                {
                    SubPageLink = "Interview No." = field("No.");
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000011; "Interview Result Factbox")
            {
                SubPageLink = "No." = field("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(GetResult)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Result';
                    Enabled = false;
                    Visible = false;

                    trigger OnAction()
                    var
                        InterviewScore: Record Interviewer;
                    begin
                        GetResult;
                    end;
                }
                action("<Action1000000017>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Next Stage';
                    Image = NextSet;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if Status = Status::Hired then
                            exit;
                        if (Stage = Stage::Final) then
                            Error(Text005);

                        CreateNextStage(InterviewHeader);
                        "Schedule Closed" := true;

                        // short-list candidates
                        InterviewHeader.SetRange(InterviewHeader."No.", InterviewHeader."No.");
                        ShortList.UseRequestPage(false);
                        ShortList.SetTableview(InterviewHeader);
                        ShortList.Run;
                        Commit;
                        //Open next schedule
                        InterviewHeader.SetRange(InterviewHeader."No.");
                        InterviewSchedule.SetRecord(InterviewHeader);
                        InterviewSchedule.RunModal;
                        Clear(InterviewSchedule);
                        CurrPage.Close;
                    end;
                }
                action(ApplyResult)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Result';
                    Image = Apply;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ApplyResult;
                        CurrPage.Update;
                    end;
                }
                action("<Action1000000018>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Auto Select for Employment';
                    Image = AddAction;
                    Visible = false;

                    trigger OnAction()
                    begin
                        RecruitmentMgt.SelectApplicant(Rec);
                        CurrPage.Update;
                    end;
                }
                action("<Action1000000020>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Offer Letter';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;

                    // trigger OnAction()
                    // var
                    //     EmploymentLetter: Report "Employment Letter";
                    // begin
                    //     InterviewHeader.SetRange("No.","No.");
                    //     EmploymentLetter.SetTableview(InterviewHeader);
                    //     EmploymentLetter.Run;
                    // end;
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
                        DiscontinueInterview;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        InterviewHeader: Record "Interview Header";
        InterviewSchedule: Page "Interview Schedule Card";
        RecruitmentMgt: Codeunit RecruitmentManagement;
        ShortList: Report "Short-List Applicant";
        Text004: label 'Interview Schedule for this job is not yet closed.\You have to close Schedule before you proceed!';
        Text005: label 'Interview is in the Final Stage already!\Next Stage not allowed!';
}

