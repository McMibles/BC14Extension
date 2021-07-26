Page 52092414 "Employee Update Card"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Action';
    SourceTable = "Employee Update Header";

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
                field(DocumentNo;"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType;"Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate;"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control4;"Employee Updatel Subform")
            {
                SubPageLink = "Document No."=field("Document No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("Request Approval")
            {
                action("<Action1000000027>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send &Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        RecRef.GetTable(Rec);
                        if ApprovalsMgmt.CheckGenericApprovalsWorkflowEnabled(RecRef) then
                          ApprovalsMgmt.OnSendGenericDocForApproval(RecRef);
                    end;
                }
                action("<Action1000000028>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        RecRef.GetTable(Rec);
                        ApprovalsMgmt.OnCancelGenericDocForApproval(RecRef);
                    end;
                }
            }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    if Processed then
                      Error(StrSubstNo(Text001,Format("Entry Type"),"Document No."));
                    Codeunit.Run(Codeunit::"Employee Update-Post",Rec);
                end;
            }
        }
    }

    var
        PromotionJnlBatchPost: Codeunit "Employee Update-Post";
        EmpJnlManagement: Codeunit EmployeeJnlMgt;
        EmployeeUpdate: Record "Employee Update Header";
        RecRef: RecordRef;
        ApprovalsMgmt: Codeunit "Approvals Hook";
        Text001: label '%1 %2 already processed';
}

