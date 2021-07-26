Table 52092135 "Mobile Approval User Setup"
{
    Caption = 'Mobile Approval User Setup';
    DrillDownPageID = "Mobile Approval User Setup";
    LookupPageID = "Mobile Approval User Setup";

    fields
    {
        field(1;"User ID";Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = User."User Name";
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.ValidateUserID("User ID");
            end;
        }
        field(17;"E-Mail";Text[100])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
            end;
        }
        field(50001;"Employee Name";Text[150])
        {
        }
        field(60000;"Employee No.";Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                Text60000: label 'Employee No. already assigned to user %1';
            begin
                if "Employee No." <> '' then begin
                  UserSetup.SetFilter("User ID",'<>%1',"User ID");
                  UserSetup.SetRange("Employee No.","Employee No.");
                  if UserSetup.FindFirst then
                    Error(Text60000,UserSetup."User ID");
                end;
            end;
        }
        field(60001;"Exclude From MFA";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60002;"Multi Factor Auth PIN";Text[100])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
    }

    keys
    {
        key(Key1;"User ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        if not ExistInUserSetup("User ID") then
          Error(Text001,"User ID");

        UpdateInfo;
    end;

    var
        Text001: label 'User have not been setup as an approval %1';
        UserSetup: Record "User Setup";

    local procedure ExistInUserSetup(UserID: Code[50]): Boolean
    var
        ApprovalUserSetup: Record "User Setup";
        WorkflowUserGroupMember: Record "Workflow User Group Member";
    begin
        ApprovalUserSetup.SetRange("Approver ID",UserID);
        if ApprovalUserSetup.Count <>0 then
          exit(true);

        WorkflowUserGroupMember.SetRange("User Name",UserID);
        if WorkflowUserGroupMember.Count <>0 then
          exit(true);

        exit(false);
    end;


    procedure UpdateInfo()
    var
        EmployeeRec: Record Employee;
    begin
        UserSetup.Get("User ID");
        UserSetup.TestField("E-Mail");
        UserSetup.TestField("Employee No.");
        Message(UserSetup."E-Mail");
        Validate("E-Mail",UserSetup."E-Mail");
        Validate("Employee No.",UserSetup."Employee No.");
        EmployeeRec.Get(UserSetup."Employee No.");
        Validate("Employee Name",EmployeeRec.FullName);
    end;
}

