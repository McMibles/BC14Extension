TableExtension 52000020 tableextension52000020 extends "User Setup" 
{
    fields
    {
        field(60001;"Delegation Start Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60002;"Delegation End Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60015;"Schedule View Filter";Text[250])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Acc. Schedule Name";
        }
        field(60021;"Mobile User Administrator";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60070;"Disable Token Authentication";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(60071;"Login Pin";Text[20])
        {
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(52092190;"Payroll Administrator";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092191;"HR Administrator";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092193;"Receive Leave Alert";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092198;"Personnel Level";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(52092199;"Employee No.";Code[20])
        {
            DataClassification = ToBeClassified;
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
        field(52092200;"Account Administrator";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092287;"Cashier Type";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,All,Receiving,Payment Voucher,Checks';
            OptionMembers = " ",All,Receiving,"Payment Voucher",Checks;
        }
        field(52092288;"Treasury Resp. Ctr Filter";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";
        }
        field(52092289;"Float Resp. Ctr Filter";Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center";
        }
        field(52092290;"Float Account No.";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(52092291;"Float Administrator";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092343;"Procurement Admin";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    procedure GetUserName(): Text
    var
        Employee: Record Employee;
    begin
        if "Employee No." = '' then
          exit("User ID")
        else begin
          Employee.Get("Employee No.");
          exit(Employee.FullName);
        end;
    end;
}

