Codeunit 52092141 "User Permissions"
{
    // Table Data,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System


    trigger OnRun()
    begin
    end;

    var
        GroupRec: Record "Permission Set";
        WindowGroup: Record "Access Control";
        Group: Code[20];
        Text000: label 'Specified Role %1 not yet created. Contact your System Administrator for Assistance.';
        Text001: label 'You do not have permission to perform this operation, User Role %1\\ Contact the system manager if you need to have your permissions changed!';


    procedure UserPermissionNoError(AccessId: Text[30]; NoMsg: Boolean): Boolean
    begin
        if UserId = '' then exit(true);

        WindowGroup.SetRange(WindowGroup."User Name", UserId);
        WindowGroup.SetFilter("Role ID", '%1', 'SUPER');
        if WindowGroup.Find('-') then
            exit(true);

        if not GroupRec.Get(AccessId) then
            Error(Text000, AccessId);

        WindowGroup.SetFilter("Role ID", '%1', AccessId);
        if WindowGroup.Find('-') then exit(true);

        if not NoMsg then begin
            Error(Text001, AccessId)
        end;

        exit(false);
    end;


    procedure TestForPermission(ObjectType: Option "Table Data","Table",,"Report",,"Codeunit","XMLport",MenuSuite,"Page","Query",System; ObjectId: Integer; PermissionType: Option Read,Insert,Modify,Delete,Execute): Boolean
    var
        PermissionRec: Record Permission;
    begin
        // also checks for a global permission
        PermissionRec.SetRange(PermissionRec."Object Type", ObjectType);
        PermissionRec.SetFilter(PermissionRec."Object ID", '%1|%2', 0, ObjectId);
        WindowGroup.SetRange(WindowGroup."User Name", UserId);
        if WindowGroup.Find('-') then
            repeat
                PermissionRec.SetRange(PermissionRec."Role ID", WindowGroup."Role ID");
                if PermissionRec.Find('-') then
                    case PermissionType of
                        0:
                            exit(PermissionRec."Read Permission" = PermissionRec."read permission"::Yes);
                        1:
                            exit(PermissionRec."Insert Permission" = PermissionRec."insert permission"::Yes);
                        2:
                            exit(PermissionRec."Modify Permission" = PermissionRec."modify permission"::Yes);
                        3:
                            exit(PermissionRec."Delete Permission" = PermissionRec."delete permission"::Yes);
                        4:
                            exit(PermissionRec."Execute Permission" = PermissionRec."execute permission"::Yes);
                        else
                            exit(true)
                    end;
            until WindowGroup.Next = 0;
        exit(false);
    end;


    procedure LicensePermission(ObjectType: Option "Table Data","Table",,"Report",,"Codeunit","XMLport",MenuSuite,"Page","Query",System; ObjectID: Integer): Boolean
    var
        lLicPermission: Record "License Permission";
    begin
        if lLicPermission.Get(ObjectType, ObjectID) then begin
            if lLicPermission."Execute Permission" = lLicPermission."execute permission"::Yes then
                exit(true)
            else
                exit(false)
        end else
            exit(false);
    end;
}

