Table 52092161 "Employee Salary"
{

    fields
    {
        field(1;"Employee No.";Code[20])
        {
            TableRelation = Employee;
        }
        field(2;"Salary Group";Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-Employee Group Header";

            trigger OnValidate()
            begin
                PayrollSetup.Get;
                if "Salary Group" <> '' then begin
                  EmployeeGrp.Get("Salary Group");
                  "Currency Code" := EmployeeGrp."Currency Code";
                  PayrollSetup.TestField("Annual Gross Pay E/D Code");
                  EmployeeGrpLine.Get("Salary Group",PayrollSetup."Annual Gross Pay E/D Code");
                  "Annual Gross Amount" := EmployeeGrpLine."Default Amount";
                end else begin
                  "Currency Code" := '';
                  "Annual Gross Amount" := 0;
                end;
            end;
        }
        field(3;"Effective Period";Code[20])
        {
            TableRelation = "Payroll-Period";
        }
        field(4;"Effective Date";Date)
        {
        }
        field(5;"Entry Type";Option)
        {
            OptionCaption = ' ,Salary Arrears,Promotion Arrears';
            OptionMembers = " ","Salary Arrears","Promotion Arrears";
        }
        field(6;"No. of Periods";Integer)
        {

            trigger OnValidate()
            begin
                if "No. of Periods" <> 0 then begin
                  if not ("Entry Type" in [1,2]) then
                    Error(Text001)
                end;
            end;
        }
        field(7;"Payment Period";Code[10])
        {
            TableRelation = "Payroll-Period";

            trigger OnValidate()
            begin
                if "Payment Period" <> '' then begin
                  if not ("Entry Type" in [1,2]) then
                    Error(Text001);
                  PayPeriod.Get("Payment Period");
                  if PayPeriod.Closed then
                    Error(Text002);
                end;
            end;
        }
        field(8;"Arrears Calculated";Boolean)
        {
        }
        field(9;"Annual Gross Amount";Decimal)
        {

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo("Annual Gross Amount") then
                  if (xRec."Annual Gross Amount" <> "Annual Gross Amount") then begin
                    PayrollSetup.Get;
                    TestField("Salary Group");
                    PayrollSetup.TestField("Annual Gross Pay E/D Code");
                    EmployeeGrpLine.Get("Salary Group",PayrollSetup."Annual Gross Pay E/D Code");
                    if "Annual Gross Amount" <> EmployeeGrpLine."Default Amount" then
                      if not Confirm(StrSubstNo(Text004,EmployeeGrpLine."Default Amount"),false) then
                        Error(Text005);
                  end;
            end;
        }
        field(10;"Currency Code";Code[10])
        {
            Editable = false;
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if "Salary Group" <> '' then begin
                  EmployeeGrp.Get("Salary Group");
                  if "Currency Code" <> EmployeeGrp."Currency Code" then
                    if not Confirm(StrSubstNo(Text003,"Currency Code",EmployeeGrp."Currency Code" )) then
                      "Currency Code" := EmployeeGrp."Currency Code";
                end;
            end;
        }
        field(11;"Appraisal Period";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Salary Group","Effective Date")
        {
            Clustered = true;
        }
        key(Key2;"Employee No.","Effective Period")
        {
        }
        key(Key3;"Employee No.","Effective Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text001: label 'No. of periods can only be specified for arrears';
        PayrollSetup: Record "Payroll-Setup";
        PayPeriod: Record "Payroll-Period";
        Text002: label 'You cannot select a closed period';
        EmployeeGrp: Record "Payroll-Employee Group Header";
        Text003: label 'The currency specified %1 is different from the employee group currency %2\ Do you want to continue?';
        EmployeeGrpLine: Record "Payroll-Employee Group Line";
        Text004: label 'The amount entered is more than the group amount %1\\ Do you want to continue?';
        Text005: label 'Amount entered has been discarded';
}

