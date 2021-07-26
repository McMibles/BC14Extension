Table 52092170 "Payroll Payslip Variable"
{
    Caption = 'Payroll Payslip Variable';
    Permissions = TableData "Employee Absence" = rim;

    fields
    {
        field(1; "Payroll Period"; Code[10])
        {
            Editable = false;
            TableRelation = "Payroll-Period";
        }
        field(2; "Employee No."; Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-Employee";

            trigger OnValidate()
            begin
                "Employee Name" := '';
                if PayrollEmployee.Get("Employee No.") then
                    "Employee Name" := PayrollEmployee.FullName;
            end;
        }
        field(3; "E/D Code"; Code[20])
        {
            SQLDataType = Variant;
            TableRelation = "Payroll-E/D" where(Variable = filter(true));

            trigger OnValidate()
            begin
                TeststatusOpen;
                CheckClosed;

                PayrollED.Get("E/D Code");
                "Payslip Text" := PayrollED.Description;
                ProllHeader.Get("Payroll Period", "Employee No.");
                if not (PayrollED.CheckandAllow("Employee No.", ProllHeader."Salary Group")) then begin
                    if CurrFieldNo = FieldNo("E/D Code") then
                        Error(Text001)
                    else
                        exit;
                end;

                if (PayrollED.Units <> '') then begin
                    Units := PayrollED.Units;
                    if ProllPayslipLine.Get("Payroll Period", "Employee No.", "E/D Code") then
                        Rate := ProllPayslipLine.Rate
                    else
                        Rate := PayrollED.Rate;
                end;
            end;
        }
        field(4; Rate; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0 : 5;
            Editable = false;

            trigger OnValidate()
            begin
                TeststatusOpen;
                CheckClosed;
                PayrollED.Get("E/D Code");
                if (PayrollED.Units = '') then
                    Rec.Rate := xRec.Rate
                else begin
                    Amount := Quantity * Rate;
                    Amount := ChkRoundMaxMin(PayrollED, Amount);
                end
            end;
        }
        field(5; Quantity; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                TeststatusOpen;
                CheckClosed;

                PayrollED.Get("E/D Code");
                if (PayrollED.Units = '') then
                    Rec.Quantity := xRec.Quantity
                else begin
                    Amount := Quantity * Rate;
                    Amount := ChkRoundMaxMin(PayrollED, Amount);
                end
            end;
        }
        field(6; Amount; Decimal)
        {
            BlankZero = true;
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                TeststatusOpen;
                CheckClosed;

                PayrollED.Get("E/D Code");
                if not (PayrollED."Edit Amount") then
                    Rec.Amount := xRec.Amount
                else
                    if (PayrollED."Max. Amount" <> 0) or (PayrollED."Min. Amount" <> 0) then
                        if Confirm('Do you want to apply Maximum/Minimum check!', true) then
                            Amount := ChkRoundMaxMin(PayrollED, Amount);

                if (Amount <> 0) and (PayrollED."Yes/No Req.") then
                    Flag := true;
            end;
        }
        field(7; "User Id"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(8; "Payslip Text"; Text[40])
        {
            Editable = false;
        }
        field(9; Units; Text[10])
        {
            Editable = false;
        }
        field(10; Flag; Boolean)
        {

            trigger OnValidate()
            begin
                TeststatusOpen;
                CheckClosed;

                PayrollED.Get("E/D Code");
                if not (PayrollED."Yes/No Req.") then
                    Flag := false
                else begin
                    ProllHeader.Get("Payroll Period", "Employee No.");
                    if not (PayrollED.CheckandAllow("Employee No.", ProllHeader."Salary Group")) then begin
                        if CurrFieldNo = FieldNo("E/D Code") then
                            Error(Text001);
                    end;
                    EmployeeRec.Get("Employee No.");
                    if PayrollED."Marital Status" <> 0 then
                        EmployeeRec.TestField("Marital Status", PayrollED."Marital Status");

                    ProllPayslipLine.Get("Payroll Period", "Employee No.", "E/D Code");
                    ProllPayslipLine.Flag := Flag;
                    Amount := ProllPayslipLine.CalcAmount(PayrollED, ProllPayslipLine, Amount, "E/D Code");
                end;

                if (Units <> '') and ((PayrollED."Factor Of" <> '') or (PayrollED."Table Look Up" <> '')) then
                    Validate(Rate, Amount);
            end;
        }
        field(11; Processed; Boolean)
        {
            Editable = false;
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval';
            OptionMembers = Open,Approved,"Pending Approval";
        }
        field(13; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(14; "Payslip Line Exist"; Boolean)
        {
            CalcFormula = exist("Payroll-Payslip Line" where("Payroll Period" = field("Payroll Period"),
                                                              "Employee No." = field("Employee No."),
                                                              "E/D Code" = field("E/D Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Processed Leave Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Payroll Period", "Employee No.", "E/D Code")
        {
            Clustered = true;
            SumIndexFields = Quantity, Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TeststatusOpen;
        if "Processed Leave Entry No." <> 0 then begin
            EmployeeAbsence.Get("Processed Leave Entry No.");
            EmployeeAbsence."Payroll Period" := '';
            EmployeeAbsence.Modify;
        end;
    end;

    trigger OnInsert()
    begin
        "User Id" := UserId;
        PayrollVariableHeader.Get("Payroll Period", "E/D Code");
        TeststatusOpen;
        "Payslip Text" := PayrollVariableHeader."Payslip Text";
    end;

    trigger OnModify()
    begin
        TeststatusOpen;
        if (Amount <> 0) or (Quantity <> 0) then begin
            PayrollED.Get("E/D Code");
            if PayrollED."Common Id" <> '' then begin
                PayrollED.SetRange(PayrollED."Common Id", PayrollED."Common Id");
                PayrollED.Find('-');
                repeat
                    if PayrollED."E/D Code" <> "E/D Code" then
                        if ProllEntryRec.Get("Payroll Period", "Employee No.", PayrollED."E/D Code") and
                          ((ProllEntryRec.Amount <> 0) or (ProllEntryRec.Quantity <> 0)) then
                            Error('It is not possible to have %1 and %2 together!', "E/D Code", PayrollED."E/D Code");
                until PayrollED.Next = 0;
            end;
            PayrollED.Get("E/D Code");
            // check for maximum number of entries in the year
            if PayrollED."Max. Entries Per Year" <> 0 then
                if PayrollED."Max. Entries Per Year" < CheckNoOfEntries then
                    Error('Maximum no. of entries already exceeded!');
            //Check for marital status
            PayrollED.Get("E/D Code");
            EmployeeRec.Get("Employee No.");
            if PayrollED."Marital Status" <> 0 then
                EmployeeRec.TestField("Marital Status", PayrollED."Marital Status");

        end;

        if Processed = true then
            Error('E/D Code %1 is Processed already!', "E/D Code");
    end;

    var
        PayrollEmployee: Record "Payroll-Employee";
        PayrollPeriod: Record "Payroll-Period";
        PayrollVariableHeader: Record "Payroll Variable Header";
        ProllHeader: Record "Payroll-Payslip Header";
        ProllEntryRec: Record "Payroll Payslip Variable";
        PayrollED: Record "Payroll-E/D";
        ProllPayslipLine: Record "Payroll-Payslip Line";
        ProllPayslipHeader: Record "Payroll-Payslip Header";
        EmployeeRec: Record "Payroll-Employee";
        EmployeeAbsence: Record "Employee Absence";
        RoundPrec: Decimal;
        RoundDir: Text[1];
        Text001: label '';
        Text5000: label 'Entries for Employee %1 for period %2 have already been closed.';


    procedure ChkRoundMaxMin(EDRecord: Record "Payroll-E/D"; TheAmount: Decimal): Decimal
    begin
        if (EDRecord."Max. Amount" <> 0) and
           (TheAmount > EDRecord."Max. Amount") then
            TheAmount := EDRecord."Max. Amount"
        else
            if (EDRecord."Min. Amount" <> 0) and
               (TheAmount < EDRecord."Min. Amount") then
                TheAmount := EDRecord."Min. Amount";

        if EDRecord."Rounding Precision" = 0 then
            RoundPrec := 0.01
        else
            RoundPrec := EDRecord."Rounding Precision";
        case EDRecord."Rounding Direction" of
            1:
                RoundDir := '>';
            2:
                RoundDir := '<';
            else
                RoundDir := '=';
        end;
        TheAmount := ROUND(TheAmount, RoundPrec, RoundDir);

        exit(TheAmount);
    end;


    procedure CheckClosed()
    begin
        PayrollPeriod.Get("Payroll Period");
        if not PayrollPeriod.Closed then
            exit;

        Error(Text5000, "Employee No.", "Payroll Period");
    end;


    procedure CheckNoOfEntries() NoOfEntries: Integer
    var
        ProllPeriod: Record "Payroll-Period";
        PayrollFirstPeriod: Code[10];
    begin
        NoOfEntries := 0;

        ProllPeriod.Get("Payroll Period");
        ProllPeriod.SetRange(ProllPeriod."Start Date", Dmy2date(1, 1, Date2dmy(ProllPeriod."Start Date", 3)), ProllPeriod."Start Date");
        ProllPeriod.SetRange(ProllPeriod."Employee Category", ProllPeriod."Employee Category");
        if ProllPeriod.Find('-') then
            PayrollFirstPeriod := ProllPeriod."Period Code"
        else
            PayrollFirstPeriod := "Payroll Period";

        ProllPayslipLine.SetRange(ProllPayslipLine."Payroll Period", PayrollFirstPeriod, "Payroll Period");
        ProllPayslipLine.SetRange(ProllPayslipLine."Employee No.", "Employee No.");
        ProllPayslipLine.SetRange(ProllPayslipLine."E/D Code", "E/D Code");
        ProllPayslipLine.SetFilter(ProllPayslipLine.Amount, '<>%1', 0);

        NoOfEntries := ProllPayslipLine.Count;
        if ProllPayslipLine.Find('+') then;
        if (ProllPayslipLine."Payroll Period" <> "Payroll Period") and (Amount <> 0) then
            NoOfEntries := NoOfEntries + 1;
    end;

    local procedure TeststatusOpen()
    begin
        PayrollVariableHeader.Get("Payroll Period", "E/D Code");
        PayrollVariableHeader.TestField(Status, PayrollVariableHeader.Status::Open);
    end;
}

