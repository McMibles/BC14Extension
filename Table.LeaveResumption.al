Table 52092245 "Leave Resumption"
{

    fields
    {
        field(1;"Document No.";Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(2;"Employee No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                Employee.Get("Employee No.");
                "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                "Global Dimension 2 Code" := Employee."Global Dimension 2 Code" ;
                "Employee Name" := Employee.FullName;
                "Employee Category" := Employee."Employee Category";
            end;
        }
        field(3;"Cause of Absence Code";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Cause of Absence";

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                HumanResSetup.Get;
                if "Cause of Absence Code" <> '' then
                  GetLeaveDetails;
            end;
        }
        field(4;"Leave Start Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5;"Expected Resumption Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(6;"Actual Resumption Date";Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(9;Variance;Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(10;"Leave Application No.";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30;Status;Option)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(33;"Year No.";Integer)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(35;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(36;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(38;"No. Series";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(44;"Employee Name";Text[150])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(48;"Employee Category";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Employee Category";
        }
        field(49;"Variance to Post";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50;"Variance Comment";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(51;Processed;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(70000;"Portal ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70001;"Mobile User ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70002;"Created from External Portal";Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Created from External Portal such as Retail';
        }
    }

    keys
    {
        key(Key1;"Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Document No." = '' then begin
          HumanResSetup.Get;
          HumanResSetup.TestField(HumanResSetup."Employee Absence No.");
          NoSeriesMgt.InitSeries(HumanResSetup."Employee Absence No.",xRec."No. Series",0D,"Document No.","No. Series");
        end;
        GetEmployeeDetails;
    end;

    var
        UserSetup: Record "User Setup";
        CauseOfAbsence: Record "Cause of Absence";
        Employee: Record Employee;
        EmployeeAbsence: Record "Employee Absence";
        HumanResUnitOfMeasure: Record "Human Resource Unit of Measure";
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NextEntryNo: Integer;
        StatusCheckSuspended: Boolean;
        ResumpEntryErr: label 'Resumption entry already created for this leave %1';

    local procedure GetEmployeeDetails()
    begin
        UserSetup.Get(UserId);
        UserSetup.TestField("Employee No.");
        Validate("Employee No.",UserSetup."Employee No.");
        "Actual Resumption Date" := WorkDate;
    end;

    local procedure GetLeaveDetails()
    begin
        if ("Employee No." <> '') and ("Cause of Absence Code" <> '') then begin
          EmployeeAbsence.SetCurrentkey("From Date","To Date");
          EmployeeAbsence.SetRange("Cause of Absence Code","Cause of Absence Code");
          EmployeeAbsence.SetRange("Employee No.","Employee No.");
          EmployeeAbsence.SetRange("Entry Type",EmployeeAbsence."entry type"::Application);
          EmployeeAbsence.FindLast;
          EmployeeAbsence.CalcFields("Resumption Entry Exist");
          if EmployeeAbsence."Resumption Entry Exist" then
            Error(ResumpEntryErr,EmployeeAbsence."Leave Application ID");
          "Leave Start Date" := EmployeeAbsence."From Date";
          "Expected Resumption Date" := EmployeeAbsence."Resumption Date";
          Variance := "Expected Resumption Date" - "Actual Resumption Date" ;
          "Year No." := EmployeeAbsence."Year No.";
          "Leave Application No." := EmployeeAbsence."Leave Application ID";
        end else begin
          "Leave Start Date" := 0D;
          "Expected Resumption Date" := 0D;
          Variance := 0;
          "Year No." := 0;
        end;
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;
}

