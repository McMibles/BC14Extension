Codeunit 52092133 "Gems Workflow Response"
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowResponseMgt: Codeunit "Workflow Response Handling";
        ResponseAlreadyExistErr: label 'A response with description %1 already exists.';
        PurchaseHook: Codeunit "Purchase Hook";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddWorkflowResponsesToLibrary()
    begin
        WorkflowResponseMgt.AddResponseToLibrary(UpperCase('CheckBudgetlimitCode'), 0, 'Check Budget Limit', 'GROUP 0');
        WorkflowResponseMgt.AddResponseToLibrary(UpperCase('BlockBudgetApproval'), 0, 'Block Budget Approval', 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', false, false)]
    local procedure OnExecuteWorkflowResponse(var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance")
    begin
        if ExecuteResponse(Variant, ResponseWorkflowStepInstance, xVariant) then
            ResponseExecuted := true;
    end;


    procedure ExecuteResponse(var Variant: Variant; ResponseWorkflowStepInstance: Record "Workflow Step Instance"; xVariant: Variant): Boolean
    var
        RecRef: RecordRef;
        WorkflowResponse: Record "Workflow Response";
        PaymentRequest: Record "Payment Request Header";
        PaymentHeader: Record "Payment Header";
        PurchaseHeader: Record "Purchase Header";
        PurchaseRequisition: Record "Requisition Wksh. Name";
        TravelHeader: Record "Travel Header";
        WorkflowChangeRecMgt: Codeunit "Workflow Change Rec Mgt.";
        PurchaseHook: Codeunit "Purchase Hook";
        ResponseExecuted: Boolean;
    begin
        if WorkflowResponse.Get(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                UpperCase('CheckBudgetlimitCode'):
                    begin
                        RecRef.GetTable(Variant);
                        case RecRef.Number of
                            Database::"Payment Request Header":
                                begin
                                    PaymentRequest := Variant;
                                    PaymentRequest.CheckBudgetLimit;
                                    exit(true);
                                end;
                            Database::"Payment Header":
                                begin
                                    PaymentHeader := Variant;
                                    PaymentHeader.CheckBudgetLimit;
                                    exit(true);
                                end;
                            Database::"Purchase Header":
                                begin
                                    PurchaseHeader := Variant;
                                    PurchaseHook.CheckBudgetLimit(PurchaseHeader);
                                    exit(true);
                                end;
                            Database::"Requisition Wksh. Name":
                                begin
                                    PurchaseRequisition := Variant;
                                    PurchaseHook.CheckPRNBudgetEntry(PurchaseRequisition);
                                    exit(true);
                                end;
                            Database::"Travel Header":
                                begin
                                    TravelHeader := Variant;
                                    TravelHeader.CheckBudgetEntry;
                                    exit(true);
                                end;
                        end;
                    end;
            end;
    end;

    local procedure CreateAppraisalEntry()
    begin
    end;
}

