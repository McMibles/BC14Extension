Table 52092166 "Employee Bank Account"
{
    DrillDownPageID = "Employee Bank Account List";
    LookupPageID = "Employee Bank Account List";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = Employee where(Status = const(Active));

            trigger OnValidate()
            begin
                if "Employee No." <> '' then begin
                    Emp.Get("Employee No.");
                    "Employee Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                    "Bank Account Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
                end else begin
                    "Employee Name" := '';
                    "Bank Account Name" := '';
                end;
            end;
        }
        field(2; "Code"; Code[10])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                if Code = '' then
                    TestField("Use for Payroll", false);
            end;
        }
        field(3; "Employee Name"; Text[70])
        {
        }
        field(4; "CBN Bank Code"; Code[20])
        {
            TableRelation = Bank.Code;

            trigger OnValidate()
            begin
                if "CBN Bank Code" <> '' then begin
                    Bank.Get("CBN Bank Code");
                    "Bank Name" := Bank.Name;
                end else
                    "Bank Name" := '';
            end;
        }
        field(5; "Bank Name"; Text[50])
        {
        }
        field(6; "Bank Branch"; Text[30])
        {
        }
        field(7; "Bank Account Name"; Text[80])
        {
        }
        field(8; "Bank Account No."; Text[20])
        {

            trigger OnValidate()
            begin
                if "Bank Account No." = '' then
                    TestField("Use for Payroll", false);
            end;
        }
        field(10; "Use for Payroll"; Boolean)
        {

            trigger OnValidate()
            begin
                if "Use for Payroll" then begin
                    Clear(EmpBankAcct);
                    PayrollEmployee.Get("Employee No.");
                    if (PayrollEmployee."Preferred Bank Account" <> Code) then begin
                        if PayrollEmployee."Preferred Bank Account" <> '' then begin
                            EmpBankAcct.Get("Employee No.", PayrollEmployee."Preferred Bank Account");
                            if EmpBankAcct."Use for Payroll" then
                                if not Confirm(Text001, false, EmpBankAcct.Code) then
                                    Error(Text002, EmpBankAcct.Code);
                            EmpBankAcct."Use for Payroll" := false;
                            EmpBankAcct.Modify;
                        end;
                        TestField(Code);
                        Clear(EmpBankAcct);
                        EmpBankAcct.SetCurrentkey("Use for Payroll");
                        EmpBankAcct.SetRange("Employee No.", "Employee No.");
                        EmpBankAcct.SetRange("Use for Payroll", true);
                        if EmpBankAcct.FindFirst then
                            Error(Text003, "Employee No.", EmpBankAcct.Code);
                    end;
                    PayrollEmployee."Preferred Bank Account" := Code;
                    PayrollEmployee."Bank Account" := "Bank Account No.";
                    PayrollEmployee.Modify;
                end else begin
                    PayrollEmployee.Get("Employee No.");
                    if (PayrollEmployee."Preferred Bank Account" <> '') and (PayrollEmployee."Preferred Bank Account" = EmpBankAcct.Code) then begin
                        PayrollEmployee.Validate("Preferred Bank Account", '');
                        PayrollEmployee.Modify;
                    end;
                end;
            end;
        }
        field(11; Address; Text[50])
        {
            Caption = 'Address';
        }
        field(12; "Address 2"; Text[50])
        {
            Caption = 'Address 2';
        }
        field(15; Contact; Text[50])
        {
            Caption = 'Contact';
        }
        field(16; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(17; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            ExtendedDatatype = EMail;
        }
        field(19; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code';
        }
        field(20; "BVN Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Code")
        {
            Clustered = true;
        }
        key(Key2; "Use for Payroll")
        {
        }
        key(Key3; "Code", "Bank Name", "Bank Branch", "Bank Account No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", "Bank Name", "Bank Branch", "Bank Account No.")
        {
        }
    }

    trigger OnDelete()
    begin
        if "Use for Payroll" then
            Error(Text004);
    end;

    var
        Emp: Record Employee;
        Bank: Record Bank;
        PayrollEmployee: Record "Payroll-Employee";
        EmpBankAcct: Record "Employee Bank Account";
        Text001: label 'Bank Account %1 already selected. Do you want to deselect it?';
        Text002: label 'You must deselect Bank Account %1 before you can proceed';
        Text003: label 'Employee No. %1 already has %2 for payroll.';
        Text004: label 'Deletion not allow when use for payroll';
}

