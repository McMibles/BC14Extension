Codeunit 52092137 "Generic Record Restriction"
{

    trigger OnRun()
    begin
    end;

    var
        RecordRestriction: Codeunit "Record Restriction Mgt.";

    [IntegrationEvent(false, false)]

    procedure OnCheckGenericReleaseRestrictions(RecRef: RecordRef)
    begin
    end;

    [EventSubscriber(Objecttype::Codeunit, Codeunit::"Generic Record Restriction", 'OnCheckGenericReleaseRestrictions', '', false, false)]
    local procedure CheckGenericReleaseRestrictions(RecRef: RecordRef)
    begin
        RecordRestriction.CheckRecordHasUsageRestrictions(RecRef.RecordId);
    end;
}

