Table 52092178 "Payroll Variable Header"
{

    fields
    {
        field(1;"Payroll Period";Code[10])
        {
            NotBlank = true;
            TableRelation = "Payroll-Period";
        }
        field(2;"E/D Code";Code[20])
        {
            SQLDataType = Variant;
            TableRelation = "Payroll-E/D" where (Variable=const(true));

            trigger OnValidate()
            begin
                PayrollED.Get( "E/D Code");
                "Payslip Text" := PayrollED.Description;
                PayrollPeriod.Get("Payroll Period");
                PayrollPeriod.TestField(Closed,false);
                "Period Name" := PayrollPeriod.Name;
            end;
        }
        field(3;"User Id";Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(4;"Payslip Text";Text[40])
        {
            Editable = false;
        }
        field(5;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(6;"Period Name";Text[40])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7;Processed;Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Payroll Period","E/D Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User Id" := UserId;
        if GetFilter("Payroll Period") <> '' then
          "Payroll Period" := GetFilter("Payroll Period");
        PayrollPeriod.Get("Payroll Period");
        PayrollPeriod.TestField(Closed,false);
        "Period Name" := PayrollPeriod.Name;
    end;

    trigger OnModify()
    begin
        TestField(Processed,false);
    end;

    trigger OnRename()
    begin
        TestField(Processed,false);
    end;

    var
        PayrollPeriod: Record "Payroll-Period";
        PayrollED: Record "Payroll-E/D";
        PayrollPayslipLine: Record "Payroll-Payslip Line";
        PayrollPayslipVariable: Record "Payroll Payslip Variable";
        Text000: label 'Your action will transfer the lines to the payslip lines. Are you sure you want to continue?';
        Text001: label 'Nothing to process.';
        Text002: label 'Function Successfully completed.';

    local procedure ValidateEntries()
    begin
        TestField(Status,Status);
    end;


    procedure ImplementEntries()
    begin
        ValidateEntries;
        PayrollPayslipVariable.SetRange("Payroll Period","Payroll Period");
        PayrollPayslipVariable.SetRange("E/D Code","E/D Code");
        if not Confirm(Text000,false) then
          exit;

        if not PayrollPayslipVariable.FindFirst then
          Error(Text001);
        repeat
          PayrollPayslipVariable.CalcFields("Payslip Line Exist");
          if PayrollPayslipVariable."Payslip Line Exist" then begin
            PayrollPayslipLine.Get("Payroll Period",PayrollPayslipVariable."Employee No.","E/D Code");
            if PayrollPayslipVariable.Quantity <> 0 then
              PayrollPayslipLine.Validate(Quantity,PayrollPayslipVariable.Quantity);
            if PayrollPayslipVariable.Amount <> 0 then
              PayrollPayslipLine.Validate(Amount,PayrollPayslipVariable.Amount);
            if PayrollPayslipVariable.Flag then
              PayrollPayslipLine.Validate(Flag,true);
            PayrollPayslipLine."Processed Leave Entry No." := PayrollPayslipVariable."Processed Leave Entry No.";
            PayrollPayslipLine.Modify;
          end else begin
            PayrollPayslipLine.Init;
            PayrollPayslipLine."Employee No." := PayrollPayslipVariable."Employee No.";
            PayrollPayslipLine."Payroll Period" := PayrollPayslipVariable."Payroll Period";
            PayrollPayslipLine.Validate("E/D Code","E/D Code");
            PayrollPayslipLine.Insert(true);
            PayrollPayslipLine.Get("Payroll Period",PayrollPayslipVariable."Employee No.","E/D Code");
            if PayrollPayslipVariable.Quantity <> 0 then
              PayrollPayslipLine.Validate(Quantity,PayrollPayslipVariable.Quantity);
            if PayrollPayslipVariable.Amount <> 0 then
              PayrollPayslipLine.Validate(Amount,PayrollPayslipVariable.Amount);
            if PayrollPayslipVariable.Flag then
              PayrollPayslipLine.Validate(Flag,true);
            PayrollPayslipLine."Processed Leave Entry No." := PayrollPayslipVariable."Processed Leave Entry No.";
            PayrollPayslipLine.Modify;
          end;
          PayrollPayslipVariable.Processed := true;
          PayrollPayslipVariable.Modify;
        until PayrollPayslipVariable.Next = 0;

        Processed := true;
        Modify;

        Message(Text002);
    end;
}

