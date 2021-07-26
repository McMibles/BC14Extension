Page 52092356 "Leave Applications"
{
    Caption = 'Absence Applications';
    CardPageID = "Leave Application Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Leave Application";
    SourceTableView = where("Entry Type" = const(Application));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DocumentNo; "Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo; "Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName; "Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(CauseofAbsenceCode; "Cause of Absence Code")
                {
                    ApplicationArea = Basic;
                }
                field(FromDate; "From Date")
                {
                    ApplicationArea = Basic;
                }
                field(ToDate; "To Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1000000009; "Leave FactBox")
            {
                SubPageLink = "Employee No." = field("Employee No.");
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
                    ApprovalEntries.Setfilters(Database::"Leave Application", 6, "Document No.");
                    ApprovalEntries.Run;
                end;
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(ProcessLeavePrintLetter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Leave & Print Letter';
                    Image = PostBatch;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        EmployeeLeave: Record "Leave Application";
                    //LeaveLetter: Report "Employee Leave Letter";
                    begin
                        if not Confirm(Text001, false) then
                            exit;
                        EmployeeLeave := Rec;
                        EmployeeLeave.SetRecfilter;
                        // LeaveLetter.SetTableview(EmployeeLeave);
                        // LeaveLetter.Run;
                        PostLeave;
                        CurrPage.Update;
                    end;
                }
                action(ProcessLeaveOnly)
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Leave Only';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        if not Confirm(Text001, false) then
                            exit;

                        PostLeave;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }

    var
        UserSetup: Record "User Setup";
        Text001: label 'Do you want to process leave?';
        Text002: label 'Do you want to process and print leave letter?';
}

