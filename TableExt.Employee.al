TableExtension 52000055 tableextension52000055 extends Employee
{
    fields
    {

        //Unsupported feature: Property Modification (Data type) on ""Job Title"(Field 6)".

        field(52092187; "Job Title Code"; Code[20])
        {
            Caption = 'Job Title';
            TableRelation = "Job Title";

            trigger OnValidate()
            var
                JobTitle: Record "Job Title";
            begin
                JobTitle.Get("Job Title Code");
                "Global Dimension 1 Code" := JobTitle."Global Dimension 1 Code";
                "Global Dimension 2 Code" := JobTitle."Global Dimension 2 Code";
                "Employee Category" := JobTitle."Employee Category";
                Designation := JobTitle.Designation;
                "Job Title" := JobTitle."Title/Description";
                "Grade Level Code" := JobTitle."Grade Level Code";
            end;
        }
        field(52092188; "Vendor No."; Code[20])
        {
            TableRelation = Vendor;
        }
        field(52092189; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(52092190; "Employee Category"; Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(52092191; "Marital Status"; Option)
        {
            OptionCaption = ' ,Single,Married,Separated,Widowed';
            OptionMembers = " ",Single,Married,Separated,Widowed;
        }
        field(52092192; "Payroll No."; Code[20])
        {
        }
        field(52092193; "Last Modified By"; Code[50])
        {
        }
        field(52092194; Designation; Text[50])
        {
        }
        field(52092195; "Grade Level Code"; Code[20])
        {
            TableRelation = "Grade Level";

            trigger OnValidate()
            var
                GradeLevel: Record "Grade Level";
            begin
                if ("Grade Level Code" <> '') and ("Grade Level Code" <> xRec."Grade Level Code") then begin
                    GradeLevel.Get("Grade Level Code");
                    if GradeLevel."Employee Category" <> '' then
                        "Employee Category" := GradeLevel."Employee Category";

                    if CurrFieldNo = FieldNo("Grade Level Code") then
                        UpdateSalary;
                end;
            end;
        }
        field(52092196; "Probation Period"; DateFormula)
        {
            Editable = false;

            trigger OnValidate()
            begin
                TestField("Employment Status", "employment status"::Probation);
                TestField("Employment Date");
                if Status = Status::Terminated then
                    Error(Text52092186);

                "Confirmation Due Date" := CalcDate(Format("Probation Period"), "Employment Date");
                if ("Employment Date" > "Confirmation Due Date") then
                    Error(Text52092187);
            end;
        }
        field(52092197; "Employment Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Probation,Confirmed';
            OptionMembers = Probation,Confirmed;

            trigger OnValidate()
            begin
                case "Employment Status" of
                    "employment status"::Confirmed:
                        begin
                            TestField("Employment Date");
                            if Status = Status::Terminated then
                                Error(Text52092188);
                            "Confirmation Date" := Today;
                        end;
                    else
                        "Confirmation Date" := 0D;
                end;
            end;
        }
        field(52092198; "Confirmation Date"; Date)
        {
            Editable = false;
        }
        field(52092199; "Confirmed By"; Code[50])
        {
        }
        field(52092200; "Pension No."; Code[20])
        {
        }
        field(52092201; "Confirmation Due Date"; Date)
        {
            Editable = false;
        }
        field(52092202; "Contract Start Date"; Date)
        {

            trigger OnValidate()
            begin
                TestField("Emplymt. Contract Code");
            end;
        }
        field(52092203; "Contract Expiry Date"; Date)
        {

            trigger OnValidate()
            begin
                TestField("Emplymt. Contract Code");
            end;
        }
        field(52092204; "Inactive Duration"; Code[10])
        {
        }
        field(52092205; "Current Appointment Date"; Date)
        {
        }
        field(52092206; "Blood Group"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",A,B,AB,O;
        }
        field(52092207; Genotype; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",AA,AS,SS,Others;
        }
        field(52092208; "Height (m)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092209; "Fitness (%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092210; "Post Qualification Empl Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52092211; "Re-Instatement Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52092212; "Inactive Without Pay"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092213; "Emergency Contact No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(52092214; "Emergency Contact Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52092215; "Previous Employee No."; Code[20])
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            var
                Employee: Record Employee;
            begin
                if Employee.Get("Previous Employee No.") then
                    Employee.TestField(Status, Status::Terminated);
            end;
        }
        field(52092216; "Userd ID"; Code[50])
        {
            DataClassification = ToBeClassified;

            trigger OnLookup()
            var
                Employee: Record Employee;
            begin
            end;
        }
        field(52092217; "Date Created"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(52092218; "Maiden Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(52092219; "Pension Adminstrator Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Pension Administrator";
        }
        field(52092220; "Exclude From Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092221; "State Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State.Code where("Record Type" = const(State));
        }
        field(52092222; "LG Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = State.Code where("Record Type" = const(LG));
        }
        field(52092223; Religion; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Christianity,Islam,Traditional,Others';
            OptionMembers = " ",Christianity,Islam,Traditional,Others;
        }
        field(52092224; Signature; Media)
        {
            DataClassification = ToBeClassified;
        }
        field(52092225; "TnA ID"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        /*        
                field(52092451; "Scheduled Saturday Overtime"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Overtime Hours" where("Employee No." = field("No."),
                                                                                    Status = const(Complete),
                                                                                    Close = const(true),
                                                                                    "Date In" = field("Date Filter"),
                                                                                    "Attendance Status" = const("On Duty"),
                                                                                    "Day Type" = const(Saturday)));
                    Description = 'TnA Information -Note that the 52092451.. is for TnA';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092452; "Scheduled Sunday Overtime"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Overtime Hours" where("Employee No." = field("No."),
                                                                                    Status = const(Complete),
                                                                                    Close = const(true),
                                                                                    "Date In" = field("Date Filter"),
                                                                                    "Attendance Status" = const("On Duty"),
                                                                                    "Day Type" = const(Sunday)));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092453; "Monthly Ordinary Overtime"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Overtime Hours" where("Employee No." = field("No."),
                                                                                    Status = const(Complete),
                                                                                    Close = const(true),
                                                                                    "Date In" = field("Date Filter"),
                                                                                    "Attendance Status" = const("On Duty"),
                                                                                    "Day Type" = const("Week Day")));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092454; "Weekend Overtime"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Overtime Hours" where("Employee No." = field("No."),
                                                                                    Status = const(Complete),
                                                                                    Close = const(true),
                                                                                    "Date In" = field("Date Filter"),
                                                                                    "Attendance Status" = const("On Duty"),
                                                                                    "Day Type" = filter(<> "Week Day")));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092455; "Public Holidays Overtime"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Overtime Hours" where("Employee No." = field("No."),
                                                                                    Status = const(Complete),
                                                                                    Close = const(true),
                                                                                    "Date In" = field("Date Filter"),
                                                                                    "Attendance Status" = const("On Duty"),
                                                                                    "Day Type" = const("Public Holiday")));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092456; "WeekEnd/PH Overtime"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Hours At Work" where("Employee No." = field("No."),
                                                                                   Status = const(Complete),
                                                                                   Close = const(true),
                                                                                   "Date In" = field("Date Filter"),
                                                                                   "Attendance Status" = const("On Duty"),
                                                                                   "Day Type" = filter(Saturday | Sunday | "Public Holiday")));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092457; "Days Worked"; Integer)
                {
                    CalcFormula = count("Attendance Register" where("Employee No." = field("No."),
                                                                     Status = const(Complete),
                                                                     Close = const(true),
                                                                     "Date In" = field("Date Filter"),
                                                                     "Attendance Status" = const("On Duty")));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092458; "No. of  Public Holiday"; Integer)
                {
                    CalcFormula = count("Attendance Register" where("Employee No." = field("No."),
                                                                     Status = const(Complete),
                                                                     Close = const(true),
                                                                     "Date In" = field("Date Filter"),
                                                                     "Attendance Status" = const("On Duty"),
                                                                     "Day Type" = const("Public Holiday")));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092459; "WeekDay Hours Worked"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Hours At Work" where("Employee No." = field("No."),
                                                                                   Status = const(Complete),
                                                                                   Close = const(true),
                                                                                   "Date In" = field("Date Filter"),
                                                                                   "Attendance Status" = const("On Duty"),
                                                                                   "Day Type" = const("Week Day")));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092460; "Public Holidays Hours Worked"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Hours At Work" where("Employee No." = field("No."),
                                                                                   Status = const(Complete),
                                                                                   Close = const(true),
                                                                                   "Date In" = field("Date Filter"),
                                                                                   "Attendance Status" = const("On Duty"),
                                                                                   "Day Type" = const("Public Holiday")));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092461; "WeekEnd Hours Worked"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Hours At Work" where("Employee No." = field("No."),
                                                                                   Status = const(Complete),
                                                                                   Close = const(true),
                                                                                   "Date In" = field("Date Filter"),
                                                                                   "Attendance Status" = const("On Duty"),
                                                                                   "Day Type" = filter(Saturday | Sunday)));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092462; "No. of  Night Shift"; Integer)
                {
                    CalcFormula = count("Attendance Register" where("Employee No." = field("No."),
                                                                     Status = const(Complete),
                                                                     Close = const(true),
                                                                     "Date In" = field("Date Filter"),
                                                                     "Attendance Status" = const("On Duty"),
                                                                     "Spans New Day" = const(true)));
                    Description = 'TnA Information';
                    Editable = false;
                    FieldClass = FlowField;
                }
                field(52092463; Shift; Option)
                {
                    DataClassification = ToBeClassified;
                    Description = 'TnA Information';
                    OptionMembers = " ",Yes,No;
                }
                field(52092464; "Work Day Id"; Code[10])
                {
                    DataClassification = ToBeClassified;
                    Description = 'TnA Information';
                }
                field(52092465; "Hours Not Worked"; Decimal)
                {
                    CalcFormula = sum("Attendance Register"."Minutes Not Worked" where("Employee No." = field("No."),
                                                                                        Status = const(Complete),
                                                                                        Close = const(true),
                                                                                        "Date In" = field("Date Filter"),
                                                                                        "Attendance Status" = const("On Duty")));
                    Editable = false;
                    FieldClass = FlowField;
                }
        */
    }

    procedure UpdateSalary()
    var
        EmployeeSalary: Record "Employee Salary";
        GradeLevel: Record "Grade Level";
        SalaryGroup: Record "Payroll-Employee Group Header";
    begin
        EmployeeSalary.Init;
        GradeLevel.Get("Grade Level Code");
        GradeLevel.TestField("Salary Group");
        EmployeeSalary."Employee No." := "No.";
        EmployeeSalary."Salary Group" := GradeLevel."Salary Group";
        EmployeeSalary."Effective Date" := WorkDate;
        SalaryGroup.Get(GradeLevel."Salary Group");
        EmployeeSalary."Currency Code" := SalaryGroup."Currency Code";
        if EmployeeSalary."Salary Group" <> '' then
            EmployeeSalary.Insert;
    end;

    procedure CreateDebtor()
    var
        Customer: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        CreateNewStaffDebtAcct: Boolean;
    begin
        if Status = Status::Terminated then
            exit;
        CreateNewStaffDebtAcct := false;

        with Rec do begin
            // Customer Account for staff loans
            if "Customer No." = '' then begin
                Customer.Init;
                Customer."No." := "No.";
            end else
                if not Customer.Get("Customer No.") then
                    CreateNewStaffDebtAcct := true;

            if CreateNewStaffDebtAcct then
                Customer."No." := "No.";
            Customer.Validate(Name, CopyStr(FullName, 1, MaxStrLen(Customer.Name)));
            Customer.Validate("Search Name", UpperCase(FullName));
            Customer.Address := Address;
            Customer."Bill-to Customer No." := "No.";
            Customer."Address 2" := "Address 2";
            Customer."Global Dimension 1 Code" := "Global Dimension 1 Code";
            Customer."Global Dimension 2 Code" := "Global Dimension 2 Code";
            //Customer."Customer Posting Group" := SalesSetup."Staff  Cust. Posting Grp";
            //Customer."Gen. Bus. Posting Group" := SalesSetup."Staff Gen. Bus Posting Grp";
            //Customer."VAT Bus. Posting Group" := SalesSetup."Staff VAT Bus. Posting Grp";
            Customer.Type := Customer.Type::Staff;
            //Customer.Status := Customer.Status::Approved;

            if Address = '' then
                Customer.Address := 'LAGOS';

            if ("Customer No." = '') or (CreateNewStaffDebtAcct) then begin
                if Customer.Insert then;
                Commit;
                "Customer No." := Customer."No.";
            end;
        end;
    end;

    procedure CreateCreditor()
    var
        Vendor: Record Vendor;
        PayableSetup: Record "Purchases & Payables Setup";
        CreateNewStaffCredtAcct: Boolean;
    begin
        /*PayableSetup.GET;
        //PayableSetup.TESTFIELD("Cash Adv. Vend. Posting Grp");
        CreateNewStaffCredtAcct := FALSE;
        WITH Rec DO BEGIN
        //Create Vendor account for cash advance and claims
          IF "Vendor No." = '' THEN BEGIN
            Vendor.INIT;
            Vendor."No." := "No.";
          END ELSE
            IF NOT Vendor.GET("Vendor No.") THEN
              CreateNewStaffCredtAcct := TRUE;
        
          IF CreateNewStaffCredtAcct THEN
            Vendor."No." := "No.";
          Vendor.VALIDATE(Name,COPYSTR(FullName,1,MAXSTRLEN(Vendor.Name)));
          Vendor.VALIDATE("Search Name", UPPERCASE(FullName));
          Vendor.Address := Address;
          Vendor."Pay-to Vendor No." := "No.";
          Vendor."Address 2" := "Address 2";
          Vendor."Global Dimension 1 Code" := "Global Dimension 1 Code";
          Vendor."Global Dimension 2 Code" := "Global Dimension 2 Code";
          //Vendor."Vendor Posting Group" := PayableSetup."Cash Adv. Vend. Posting Grp";
          Vendor.Type := Vendor.Type::"Staff Advance";
          //Vendor.Status := Vendor.Status::Approved;
        
          IF Address = '' THEN
            Vendor.Address := 'LAGOS';
        
          IF ("Vendor No." = '') OR (CreateNewStaffCredtAcct) THEN BEGIN
            IF Vendor.INSERT THEN;
            COMMIT;
            "Vendor No." := Vendor."No.";
          END;
        END;*/

    end;

    procedure CreateEmployeePayrollRecord()
    var
        CreateNewEmployPayroll: Boolean;
        Employee2: Record Employee;
        PayrollEmployee: Record "Payroll-Employee";
    begin
        with Rec do begin
            if "Payroll No." <> '' then
                PayrollEmployee.Get("Payroll No.");
            PayrollEmployee.TransferFields(Rec);
            PayrollEmployee."Job Title" := "Job Title Code";
            PayrollEmployee."Customer No." := "Customer No.";
            PayrollEmployee."Employee Category" := "Employee Category";
            PayrollEmployee."Marital Status" := "Marital Status";
            PayrollEmployee.Designation := Designation;
            PayrollEmployee."State Code" := "State Code";
            PayrollEmployee."Grade Level Code" := "Grade Level Code";
            PayrollEmployee."Employment Status" := "Employment Status";
            PayrollEmployee."Pension No." := "Pension No.";
            PayrollEmployee."Contract Start Date" := "Contract Start Date";
            PayrollEmployee."Contract Expiry Date" := "Contract Expiry Date";
            PayrollEmployee."Inactive Duration" := "Inactive Duration";
            PayrollEmployee."LG Code" := "LG Code";
            PayrollEmployee."Re-Instatement Date" := "Re-Instatement Date";
            PayrollEmployee."Inactive Without Pay" := "Inactive Without Pay";
            PayrollEmployee."Pension Administrator Code" := "Pension Adminstrator Code";
            PayrollEmployee."Exclude From Payroll" := "Exclude From Payroll";
            //PayrollEmployee."Bank Account" := "Bank Account No.";
            PayrollEmployee."Tax State" := "State Code";
            if PayrollEmployee.Insert then begin
                "Payroll No." := PayrollEmployee."No.";
                Modify;
            end else
                PayrollEmployee.Modify;
            UpdatePayrollDim("No.", "Payroll No.");
        end;
    end;

    procedure GetAbsenceParameter(AbsenceCode: Code[10]; var AllowedDays: Decimal; var "Allowance%": Decimal)
    var
        EmployeeCategory: Record "Employee Category";
        GradeLevel: Record "Grade Level";
        AbsenceSetup: Record "Leave Setup";
        Absence: Record "Cause of Absence";
    begin
        if AbsenceSetup.Get(AbsenceSetup."record type"::Employee, "No.", AbsenceCode) then begin
            AllowedDays := AbsenceSetup."No. of Days Allowed";
            "Allowance%" := AbsenceSetup."Allowance %";
            exit;
        end;
        if AbsenceSetup.Get(AbsenceSetup."record type"::Category, "Employee Category", AbsenceCode) then begin
            AllowedDays := AbsenceSetup."No. of Days Allowed";
            "Allowance%" := AbsenceSetup."Allowance %";
            exit;
        end;
        if AbsenceSetup.Get(AbsenceSetup."record type"::"Grade Level", "Grade Level Code", AbsenceCode) then begin
            AllowedDays := AbsenceSetup."No. of Days Allowed";
            "Allowance%" := AbsenceSetup."Allowance %";
            exit;
        end;
        Absence.Get(AbsenceCode);
        AllowedDays := Absence."No. of Days Allowed";
        "Allowance%" := Absence."Allowance %";
    end;

    procedure GetEmployeeCategory(): Text[50]
    var
        EmployeeCategory: Record "Employee Category";
    begin
        if "Employee Category" <> '' then begin
            EmployeeCategory.Get("Employee Category");
            exit(EmployeeCategory.Description);
        end else
            exit('')
    end;

    local procedure UpdatePayrollDim(FromNo: Code[20]; ToNo: Code[20])
    var
        EmployeeDefaultDim: Record "Default Dimension";
        PayEmployeeDefaultDim: Record "Default Dimension";
    begin
        PayEmployeeDefaultDim.SetFilter("Table ID", '%1', Database::"Payroll-Employee");
        PayEmployeeDefaultDim.SetRange("No.", ToNo);
        PayEmployeeDefaultDim.DeleteAll;

        EmployeeDefaultDim.SetFilter("Table ID", '%1', Database::Employee);
        EmployeeDefaultDim.SetRange("No.", FromNo);
        if EmployeeDefaultDim.FindSet then begin
            repeat
                PayEmployeeDefaultDim := EmployeeDefaultDim;
                PayEmployeeDefaultDim."Table ID" := Database::"Payroll-Employee";
                PayEmployeeDefaultDim."No." := ToNo;
                if not PayEmployeeDefaultDim.Insert then
                    PayEmployeeDefaultDim.Modify;
            until EmployeeDefaultDim.Next = 0;
        end;
    end;

    procedure GetEmployeeBankAccount(var EmployeeBankAccount: Record "Employee Bank Account")
    var
        EmployeeBank: Record "Employee Bank Account";
    begin
        EmployeeBank.SetRange("Employee No.", "No.");
        EmployeeBank.SetRange("Use for Payroll", true);
        if EmployeeBank.FindFirst then
            EmployeeBankAccount := EmployeeBank;
    end;

    var
        Text52092186: label 'Action not possible for terminated employee!';
        Text52092187: label 'Probation Period not correct!';
        Text52092188: label 'Action not possible for terminated employee!';
        Text52092189: label 'Probation Period not correct!';
        Text52092190: label 'Automatic update of Payroll record not enabled, ensure that you manually update the payroll record';
        Text52092191: label 'Records Can not be deleted\\ NOTE this action is Logged against your Acivities!! ';
}

