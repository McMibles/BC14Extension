Page 52092345 "Leave Application Card"
{
    Caption = 'Leave Application';
    DataCaptionFields = "Employee No.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Leave Application";
    SourceTableView = where("Entry Type" = const(Application));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(DocumentNo; "Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(EmployeeNo; "Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName; "Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(CauseofAbsenceCode; "Cause of Absence Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(FromDate; "From Date")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(ToDate; "To Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(UnitofMeasureCode; "Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ResumptionDate; "Resumption Date")
                {
                    ApplicationArea = Basic;
                }
                field(ReliefNo; "Relief No.")
                {
                    ApplicationArea = Basic;
                }
                field(ProcessAllowancePayment; "Process Allowance Payment")
                {
                    ApplicationArea = Basic;
                }
                field(LeaveAmounttoPay; "Leave Amount to Pay")
                {
                    ApplicationArea = Basic;
                }
                field(QuantityBase; "Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = true;
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
            action(DocAttach)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category8;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                trigger OnAction()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal;
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
        Text001: label 'Do you want to process leave?';
        Text002: label 'Do you want to process and print leave letter?';
}

