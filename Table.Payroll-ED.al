Table 52092144 "Payroll-E/D"
{
    DrillDownPageID = "Payroll-ED List";
    LookupPageID = "Payroll-ED List";

    fields
    {
        field(1;"E/D Code";Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                "Search Name" := "E/D Code";
            end;
        }
        field(2;"Search Name";Code[20])
        {
        }
        field(3;Description;Text[40])
        {

            trigger OnValidate()
            begin
                "Payslip Appearance Text" := Description;
            end;
        }
        field(4;"Payslip appearance";Option)
        {
            OptionMembers = "Non-zero & Code","Always & Code","Always & Text","Non-zero & Text","Does not appear",Heading,"Always & Text & Special";
        }
        field(6;Units;Text[10])
        {
        }
        field(7;Compute;Code[20])
        {
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                if Compute <> '' then
                  if Compute = "E/D Code" then
                    Error ('An E/D cannot compute itself')
                  else
                    "E/DFileRec".Get( Compute);
                if Compute = '' then
                  "Add/Subtract" := 0;
            end;
        }
        field(8;"Factor Of";Code[20])
        {
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                if "Factor Of" <> '' then
                  if "Factor Of" = "E/D Code" then
                    Error ('An E/D cannot be a factor of itself')
                  else
                  "E/DFileRec".Get( "Factor Of");
            end;
        }
        field(9;Percentage;Decimal)
        {
            DecimalPlaces = 0:9;
        }
        field(10;"Add/Subtract";Option)
        {
            OptionMembers = " ",Add,Subtract;
        }
        field(11;"Table Look Up";Code[20])
        {
            TableRelation = "Payroll-Lookup Header";

            trigger OnValidate()
            begin
                if "Table Look Up" <> '' then
                  LookupRec.Get( "Table Look Up");
            end;
        }
        field(12;"Edit Amount";Boolean)
        {
        }
        field(13;"Yes/No Req.";Boolean)
        {
        }
        field(14;"Max. Amount";Decimal)
        {
            DecimalPlaces = 0:5;
        }
        field(15;"Min. Amount";Decimal)
        {
            DecimalPlaces = 0:5;
        }
        field(16;Rate;Decimal)
        {
            DecimalPlaces = 0:5;
        }
        field(17;"Statistics Group Code";Code[10])
        {
            TableRelation = "Payroll Statistical Group";
        }
        field(18;"Pos. In Payslip Grp.";Integer)
        {
            MaxValue = 99;
            MinValue = 0;
        }
        field(19;"Reset Next Period";Boolean)
        {
            InitValue = false;
        }
        field(20;"Rounding Direction";Option)
        {
            OptionMembers = Nearest,Higher,Lower;
        }
        field(21;"Rounding Precision";Decimal)
        {
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(22;"Payslip Column";Option)
        {
            InitValue = "1";
            OptionCaption = 'Earning,Deduction,Net';
            OptionMembers = "1","2","3";
        }
        field(23;Changed;Boolean)
        {
            InitValue = false;
        }
        field(24;"S. Report appearance";Option)
        {
            InitValue = "Does not appear";
            OptionMembers = "Non-zero & Code","Always & Code","Always & Text","Non-zero & Text","Does not appear",Heading;
        }
        field(25;"Edit Grp. Amount";Boolean)
        {
            InitValue = false;
        }
        field(26;"Overline Column";Option)
        {
            InitValue = "None";
            OptionMembers = "None","1","2","3","1-2","2-3","1-3";
        }
        field(27;"Underline Amount";Option)
        {
            InitValue = "None";
            OptionMembers = "None",Underline,"Double Underline";
        }
        field(28;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(29;"Loan (Y/N)";Boolean)
        {
        }
        field(30;"Min. Percentage";Decimal)
        {
            DecimalPlaces = 0:5;
        }
        field(31;"Max. Percentage";Decimal)
        {
            DecimalPlaces = 0:5;
        }
        field(32;"Factor Lookup";Code[20])
        {
            TableRelation = "Payroll-Factor Lookup";
        }
        field(33;"Common Id";Code[10])
        {
        }
        field(34;Variable;Boolean)
        {
        }
        field(35;Historical;Boolean)
        {
        }
        field(36;"Recalculate Next Period";Boolean)
        {
        }
        field(37;"Max. Entries Per Year";Integer)
        {
        }
        field(38;Posting;Option)
        {
            OptionMembers = " ","None","Debit Only","Credit Only",Both;
        }
        field(39;"No. of Days Prorate";Boolean)
        {

            trigger OnValidate()
            begin
                if "No. of Days Prorate" then
                  TestField("No. of Months Prorate",false);
            end;
        }
        field(40;Comments;Boolean)
        {
        }
        field(41;"Include On Detail Report";Boolean)
        {
        }
        field(42;"Counter Account No. Compulsory";Boolean)
        {
            Description = 'For the loans that are not to be posted on staff Acct.';

            trigger OnValidate()
            begin
                TestField("Loan (Y/N)",true);
            end;
        }
        field(44;"Date Filter";Date)
        {
        }
        field(45;"Date Filter 2";Date)
        {
        }
        field(47;"No. of Employees";Integer)
        {
        }
        field(48;"No. of Empl.  Leave";Integer)
        {
        }
        field(49;"Extended Description";Text[50])
        {
        }
        field(50;"ED Compulsory";Boolean)
        {

            trigger OnValidate()
            begin
                if Confirm(Text002,false) then begin
                  SalaryGroup.Reset;
                  SalaryGroup.SetRange("E/D Code","E/D Code");
                  SalaryGroup.ModifyAll(SalaryGroup."ED Compulsory","ED Compulsory");
                end;
            end;
        }
        field(51;"Payslip Appearance Text";Text[40])
        {
        }
        field(52;"Appear On Reimburseable Report";Boolean)
        {
        }
        field(53;"Reimburseable Report Text";Text[50])
        {
        }
        field(54;"Payroll Period Type";Option)
        {
            OptionCaption = 'Both,Month End,Mid Month';
            OptionMembers = Both,"Month End","Mid Month";
        }
        field(55;Blocked;Boolean)
        {
        }
        field(56;"Payment Voucher Compulsory";Boolean)
        {
            Description = 'To check for payment voucher';

            trigger OnValidate()
            begin
                TestField("Loan (Y/N)",true);
            end;
        }
        field(57;"Monthly Recurring";Boolean)
        {
        }
        field(58;"Loan Type";Option)
        {
            OptionCaption = ' ,Salary Adv.,Housing,Non-Housing';
            OptionMembers = " ","Salary Adv.",Housing,"Non-Housing";

            trigger OnValidate()
            begin
                TestField("Loan (Y/N)");
            end;
        }
        field(59;"Number of Repayment";Integer)
        {

            trigger OnValidate()
            begin
                TestField("Loan (Y/N)");
            end;
        }
        field(60;Reimbursable;Boolean)
        {
        }
        field(61;"Allow Multiple Loans";Boolean)
        {

            trigger OnValidate()
            begin
                TestField("Loan (Y/N)",true);
            end;
        }
        field(62;"Use as Default";Option)
        {
            OptionMembers = " ","Max. Amount","Min. Amount";
        }
        field(63;"Marital Status";Option)
        {
            OptionCaption = ' ,Single,Married,Separated,Widowed';
            OptionMembers = " ",Single,Married,Separated,Widowed;
        }
        field(64;"Max. Quantity";Decimal)
        {
        }
        field(65;Bold;Boolean)
        {
        }
        field(66;"No. of Months Prorate";Boolean)
        {

            trigger OnValidate()
            begin
                if "No. of Months Prorate" then
                  TestField("No. of Days Prorate",false);
            end;
        }
        field(67;"Use in Arrear Calc.";Boolean)
        {
        }
        field(68;"Prorate Arrear";Boolean)
        {
        }
        field(69;"Designation Cond. Exist";Boolean)
        {
            CalcFormula = exist("ED Condition" where ("ED Code"=field("E/D Code"),
                                                      Type=const("Job Title"),
                                                      Value=filter(<>'')));
            FieldClass = FlowField;
        }
        field(70;"Department Cond. Exist";Boolean)
        {
            CalcFormula = exist("ED Condition" where ("ED Code"=field("E/D Code"),
                                                      Type=const(Department),
                                                      Value=filter(<>'')));
            FieldClass = FlowField;
        }
        field(71;"Value Exist";Boolean)
        {
            CalcFormula = exist("ED Period and Value" where ("ED Code"=field("E/D Code"),
                                                             "Effective Period"=filter(<>''),
                                                             Amount=filter(<>0)));
            FieldClass = FlowField;
        }
        field(72;Arrear;Boolean)
        {
        }
        field(73;"Check Emp. Grp";Boolean)
        {
        }
        field(74;"Block Deletion";Boolean)
        {
        }
        field(75;Italic;Boolean)
        {
        }
        field(76;"Use as Group Total";Boolean)
        {
        }
        field(77;"Loan Deduction Starting Period";DateFormula)
        {
        }
        field(78;"Arrear ED Code";Code[20])
        {
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                if "Arrear ED Code" <> '' then begin
                  TestField("Use in Arrear Calc.",true);
                  if "E/D Code" = "Arrear ED Code" then
                    Error(Text003);
                end;
            end;
        }
        field(79;"Interest %";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(80;"Annual Leave ED";Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'This is to indicate that an ED is Annual Leave ED';

            trigger OnValidate()
            begin
                TestField("Annual Allowance ED",false);
            end;
        }
        field(81;"Accrual ED Code";Code[20])
        {
            DataClassification = ToBeClassified;
            Description = 'This is used to hold the accrual ED for an ED';
            TableRelation = "Payroll-E/D";
        }
        field(82;"Annual Allowance ED";Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'This is to indicate that an ED is paid annually';

            trigger OnValidate()
            begin
                TestField("Annual Leave ED",false);
            end;
        }
        field(83;"Static ED";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"E/D Code")
        {
            Clustered = true;
        }
        key(Key2;"Search Name")
        {
        }
        key(Key3;"Reimburseable Report Text")
        {
        }
        key(Key4;"Common Id")
        {
        }
        key(Key5;Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"E/D Code",Description)
        {
        }
    }

    trigger OnModify()
    begin
        if ("Loan (Y/N)") and (not "Payment Voucher Compulsory") then
          if not Confirm(Text000,false) then
            Error(Text001);
    end;

    var
        SalaryGroup: Record "Payroll-Employee Group Line";
        "E/DFileRec": Record "Payroll-E/D";
        LookupRec: Record "Payroll-Lookup Header";
        EmpGrpLines: Record "Payroll-Employee Group Line";
        Text000: label 'You have not flagged the ED as Payment Voucher Compulsory, This will not allow the system to check the if the payment voucher has bee created for any new loan with the ED\Are you sure want to continue?';
        Text001: label 'Update Process Alborted!';
        Text002: label 'Do you want to update all the group lines with the change?';
        Text003: label 'The Arrears ED Code cannot be the same as the E/D Code';


    procedure CheckandAllow(var EmployeeCode: Code[20];var EmpGroup: Code[20]): Boolean
    var
        EDCondition: Record "ED Condition";
        EDCondition2: Record "ED Condition";
        Employee: Record "Payroll-Employee";
    begin
        CalcFields("Designation Cond. Exist","Department Cond. Exist");
        Employee.Get(EmployeeCode);
        if ("Designation Cond. Exist") and ("Department Cond. Exist") then begin
          if EDCondition.Get("E/D Code",1,Employee."Job Title Code") and
             EDCondition2.Get("E/D Code",2,Employee."Global Dimension 2 Code") then
            exit(true)
          else
            exit (false)
        end;

        if ("Designation Cond. Exist") and ("Department Cond. Exist" = false) then begin
          if EDCondition.Get("E/D Code",1,Employee."Job Title Code") then begin
            if not ("Check Emp. Grp") then
              exit(true)
            else begin
              if not EmpGrpLines.Get(EmpGroup,"E/D Code") then
                exit(false)
              else
                exit(true);
            end;
          end else
            exit(false);
        end;
        if ("Designation Cond. Exist" = false) and ("Department Cond. Exist") then begin
          if EDCondition.Get("E/D Code",2,Employee."Global Dimension 2 Code") then begin
            if not ("Check Emp. Grp") then
              exit(true)
            else begin
              if not EmpGrpLines.Get(EmpGroup,"E/D Code") then
                exit(false)
              else
                exit(true);
            end;
          end else
            exit(false);
        end;

        if not ("Check Emp. Grp") then
          exit(true)
        else begin
          if not EmpGrpLines.Get(EmpGroup,"E/D Code") then
            exit(false)
          else
            exit(true);
        end;
    end;


    procedure GetAmount(var PeriodCode: Code[20]): Decimal
    var
        EDPeriodValue: Record "ED Period and Value";
    begin
        EDPeriodValue.SetRange(EDPeriodValue."ED Code","E/D Code");
        EDPeriodValue.SetFilter("Effective Period",'<=%1',PeriodCode);
        if EDPeriodValue.FindLast then
          exit(EDPeriodValue.Amount)
        else begin
          case "E/DFileRec"."Use as Default" of
            1: exit("Max. Amount");
            2: exit("Min. Amount");
            else
              exit(0);
          end;
        end;
    end;
}

