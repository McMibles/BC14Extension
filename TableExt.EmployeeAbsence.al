TableExtension 52000060 tableextension52000060 extends "Employee Absence" 
{
    fields
    {
        field(52092186;"Year No.";Integer)
        {
        }
        field(52092187;"Entry Type";Option)
        {
            OptionCaption = 'Application,Positive Adjustment,Negative Adjustment';
            OptionMembers = Application,"Positive Adjustment","Negative Adjustment";
        }
        field(52092188;"Application Date";Date)
        {
        }
        field(52092189;"Manager No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(52092190;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));
        }
        field(52092191;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));
        }
        field(52092192;"Relief No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(52092193;"Resumption Date";Date)
        {
            Editable = false;
        }
        field(52092194;"Employee Name";Text[150])
        {
            Editable = false;
        }
        field(52092195;"Leave Application ID";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092196;"Leave ED Code";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092197;"Leave Amount Paid";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092198;"Process Allowance Payment";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092199;"Leave Paid";Boolean)
        {
            Editable = false;
        }
        field(52092200;"Payroll Period";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52092201;"Opening/Closing Entry";Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Opening,Closing;
        }
        field(52092203;"User ID";Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(52092204;"Employee Category";Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(52092205;"Resumption Entry Exist";Boolean)
        {
            CalcFormula = exist("Leave Resumption" where ("Leave Application No."=field("Leave Application ID")));
            FieldClass = FlowField;
        }
    }

    procedure CopyFromLeaveApplication(LeaveApplication: Record "Leave Application")
    begin
        "Employee No." := LeaveApplication."Employee No." ;
        "From Date" := LeaveApplication."From Date" ;
        "To Date" := LeaveApplication."To Date";
        "Cause of Absence Code" :=  LeaveApplication."Cause of Absence Code";
        Description := LeaveApplication.Description;
        case LeaveApplication."Entry Type" of
          "entry type"::"Positive Adjustment":
            begin
              Quantity :=  LeaveApplication.Quantity;
              "Quantity (Base)" := LeaveApplication."Quantity (Base)";
            end;
          else
            begin
              Quantity :=  -LeaveApplication.Quantity;
              "Quantity (Base)" := -LeaveApplication."Quantity (Base)";
            end;
        end;

        "Unit of Measure Code" := LeaveApplication."Unit of Measure Code";
        "Qty. per Unit of Measure" := LeaveApplication."Qty. per Unit of Measure";
        "Application Date" :=  LeaveApplication."Application Date";
        "Year No." := LeaveApplication."Year No.";
        "Manager No." := LeaveApplication."Manager No.";
        "Global Dimension 1 Code" := LeaveApplication."Global Dimension 1 Code";
        "Global Dimension 2 Code" := LeaveApplication."Global Dimension 2 Code";
        "Relief No." :=  LeaveApplication."Relief No.";
        "Resumption Date" := LeaveApplication."Resumption Date";
        "Entry Type" := LeaveApplication."Entry Type";
        "Employee Name" := LeaveApplication."Employee Name";
        "Leave Application ID" := LeaveApplication."Document No.";
        "Process Allowance Payment" := LeaveApplication."Process Allowance Payment";
        "Opening/Closing Entry" := LeaveApplication."Opening/Closing Entry";
        "User ID" := UserId;
        "Employee Category" := LeaveApplication."Employee Category";
    end;
}

