Table 52092147 "Payroll-Payslip Line"
{
    DrillDownPageID = "Payslip Lines";
    LookupPageID = "Payslip Lines";
    Permissions = TableData "Employee Absence"=rim,
                  TableData "Payroll-Loan"=rimd,
                  TableData "Payroll-Loan Entry"=rimd;

    fields
    {
        field(1;"Payroll Period";Code[10])
        {
            Editable = false;
            TableRelation = "Payroll-Period";

            trigger OnValidate()
            begin
                PayPeriodRec.Get( "Payroll Period");
                begin
                  "Period Start" := PayPeriodRec."Start Date";
                  "Period End" := PayPeriodRec."End Date";
                end;
            end;
        }
        field(2;"Employee No.";Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "Payroll-Employee";
        }
        field(3;"E/D Code";Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                if (xRec."E/D Code" <> '') and ("E/D Code" <> xRec."E/D Code") and (CurrFieldNo = FieldNo("E/D Code")) then
                  Error(Text004,"E/D Code","Employee No.");

                if CheckClosed  then
                  Error (Text005,"Employee No.", "Payroll Period");

                "E/DFileRec".Get( "E/D Code");
                ProllHeader.Get("Payroll Period","Employee No.");
                ProllHeader.TestField(ProllHeader.Status,0);

                if not ("E/DFileRec".CheckandAllow("Employee No.",ProllHeader."Salary Group")) then begin
                  if CurrFieldNo = FieldNo("E/D Code") then
                    Error(Text010)
                  else
                    exit;
                end;

                begin
                  "Currency Code" := ProllHeader."Currency Code";
                  "Statistics Group Code" := "E/DFileRec"."Statistics Group Code";
                  "Pos. In Payslip Grp." := "E/DFileRec"."Pos. In Payslip Grp.";
                  "Payslip Appearance" := "E/DFileRec"."Payslip appearance";
                  Units := "E/DFileRec".Units;
                  Rate := "E/DFileRec".Rate;
                  "Overline Column" := "E/DFileRec"."Overline Column";
                  "Underline Amount" := "E/DFileRec"."Underline Amount";
                  "Payslip Column" := "E/DFileRec"."Payslip Column";
                  "Payslip Text" := "E/DFileRec".Description;
                  EmployeeRec.Get("Employee No.");
                  "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                  "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                  Compute := "E/DFileRec".Compute;
                  "Common ID" := "E/DFileRec"."Common Id";
                  "Loan (Y/N)" := "E/DFileRec"."Loan (Y/N)";
                  "No. of Days Prorate"  := "E/DFileRec"."No. of Days Prorate";
                  "No. of Months Prorate" := "E/DFileRec"."No. of Months Prorate";
                end;

                if ((Units = '') or ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Factor Lookup" <> '') or
                   ("E/DFileRec"."Table Look Up" <> ''))) or "E/DFileRec"."Loan (Y/N)") and
                   not ("E/DFileRec"."Yes/No Req.") then
                  begin

                    Amount := CalcAmount ("E/DFileRec", Rec, Amount, "E/D Code");

                    if ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Factor Lookup" <> '') or
                       ("E/DFileRec"."Table Look Up" <> ''))) then
                      Validate(Rate,Amount);

                    if Amount <> 0 then begin

                      CheckCommonIDExists(true);

                      "E/DFileRec".Get("E/D Code");
                      if "E/DFileRec"."Max. Entries Per Year" <> 0 then
                        if "E/DFileRec"."Max. Entries Per Year" < CheckNoOfEntries then
                          Error(Text001,"E/DFileRec".Description,PeriodTaken);
                    end;
                    CalcAmountLCY;
                    if Rec.Amount <> xRec.Amount then
                      begin
                        CalcCompute (Rec, Amount, true, "E/D Code");
                        CalcFactor1 (Rec);
                        ChangeAllOver (Rec, false);
                        ResetChangeFlags (Rec);
                      end
                  end;

                if BookGrLinesRec.Get(ProllHeader."Salary Group","E/D Code") then
                  begin
                    "Debit Account" := BookGrLinesRec."Debit Account No.";
                    "Credit Account" := BookGrLinesRec."Credit Account No.";
                    "Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
                    "Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";
                    if not BookGrLinesRec."Transfer Global Dim. 1 Code" then
                      "Global Dimension 1 Code" := ''
                    else
                      if "Global Dimension 1 Code" = '' then
                        "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";

                    if not BookGrLinesRec."Transfer Global Dim. 2 Code" then
                      "Global Dimension 2 Code" := ''
                    else
                      if "Global Dimension 2 Code" = '' then
                        "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";

                    if BookGrLinesRec."Debit Acc. Type" = 1 then
                      if "Debit Account" = '' then
                        if EmployeeRec."Customer No." <> '' then
                          "Debit Account" := EmployeeRec."Customer No." ;

                    if BookGrLinesRec."Credit Acc. Type" = 1 then
                      if "Credit Account" = '' then
                        if EmployeeRec."Customer No."  <> '' then
                          "Credit Account" := EmployeeRec."Customer No.";

                    if BookGrLinesRec."Transfer Global Dim. 1 Code" then
                      "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    if BookGrLinesRec."Transfer Global Dim. 2 Code" then
                      "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                  end;
            end;
        }
        field(4;Units;Text[10])
        {
            Editable = false;
        }
        field(5;Rate;Decimal)
        {
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if CheckClosed  then
                  Error (Text005,"Employee No.","Payroll Period");
                "E/DFileRec".Get( "E/D Code");

                if (Units = '') or (not("E/DFileRec"."Edit Amount") and (CurrFieldNo = FieldNo(Rate)) ) then begin
                  Rec.Rate := xRec.Rate;
                end else begin
                  Amount := Quantity * Rate;
                  Amount := ChkRoundMaxMin("E/DFileRec", Amount);
                end
            end;
        }
        field(6;Quantity;Decimal)
        {
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if CheckClosed  then
                  Error (Text005, "Employee No.", "Payroll Period");

                if (Units = '') then
                  Rec.Quantity := xRec.Quantity
                else
                  begin
                    "E/DFileRec".Get("E/D Code");
                    if "E/DFileRec"."Max. Quantity" <> 0 then begin
                      if Quantity > "E/DFileRec"."Max. Quantity"  then
                        Rec.Quantity := xRec.Quantity;
                    end;

                    Amount := Quantity * Rate;
                    Amount := ChkRoundMaxMin ("E/DFileRec", Amount);
                  end
            end;
        }
        field(7;Flag;Boolean)
        {

            trigger OnValidate()
            begin
                if CheckClosed  then
                  Error (Text005, "Employee No.", "Payroll Period");

                "E/DFileRec".Get("E/D Code");
                if not ("E/DFileRec"."Yes/No Req.") then
                  Flag := false
                else begin
                  ProllHeader.Get("Payroll Period","Employee No.");
                  if not ("E/DFileRec".CheckandAllow("Employee No.",ProllHeader."Salary Group")) then begin
                    if CurrFieldNo = FieldNo("E/D Code") then
                      Error(Text010);
                  end;
                  EmployeeRec.Get("Employee No.");
                  if "E/DFileRec"."Marital Status" <> 0 then
                    EmployeeRec.TestField("Marital Status","E/DFileRec"."Marital Status");

                  Amount := CalcAmount ("E/DFileRec", Rec, Amount, "E/D Code");
                  if Amount = 0 then
                    Flag := false;
                end;
                if (Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Table Look Up" <> '')) then
                  Validate(Rate,Amount);
            end;
        }
        field(8;Amount;Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            DecimalPlaces = 0:2;

            trigger OnValidate()
            begin
                if CurrFieldNo = FieldNo(Amount) then begin
                  if CheckClosed  then
                    Error (Text005, "Employee No.", "Payroll Period");
                  "E/DFileRec".Get( "E/D Code");
                  if not ("E/DFileRec"."Edit Amount") then
                    Rec.Amount := xRec.Amount
                  else
                    if ("E/DFileRec"."Max. Amount" <> 0) or ("E/DFileRec"."Min. Amount" <> 0) then
                      if Confirm(Text006,true) then
                        Amount := ChkRoundMaxMin("E/DFileRec", Amount);
                end;
            end;
        }
        field(9;"Debit Account";Code[20])
        {
            TableRelation = if ("Debit Acc. Type"=const(Finance)) "G/L Account"
                            else if ("Debit Acc. Type"=const(Customer)) Customer;

            trigger OnValidate()
            begin
                if "Debit Account" <> '' then
                  case "Debit Acc. Type" of
                    0:  FinanceAccRec.Get("Debit Account");
                    1:  CustomerAccRec.Get("Debit Account");
                    2:  SupplierAccRec.Get("Debit Account");
                  end;
            end;
        }
        field(10;"Credit Account";Code[20])
        {
            TableRelation = if ("Credit Acc. Type"=const(Finance)) "G/L Account"
                            else if ("Credit Acc. Type"=const(Customer)) Customer;

            trigger OnValidate()
            begin
                if "Credit Account" <> '' then
                  case "Credit Acc. Type" of
                    0:  FinanceAccRec.Get("Credit Account");
                    1:  CustomerAccRec.Get("Credit Account");
                    2:  SupplierAccRec.Get("Credit Account");
                  end;
            end;
        }
        field(11;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(12;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(13;AmountToBook;Decimal)
        {
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(14;"Statistics Group Code";Code[10])
        {
            TableRelation = "Payroll Statistical Group";
        }
        field(15;"Pos. In Payslip Grp.";Integer)
        {
        }
        field(16;"Payslip Appearance";Option)
        {
            OptionMembers = "Non-zero & Code","Always & Code","Always & Text","Non-zero & Text","Does not appear",Heading;
        }
        field(17;"Debit Acc. Type";Option)
        {
            OptionMembers = Finance,Customer,Supplier;
        }
        field(18;"Credit Acc. Type";Option)
        {
            OptionMembers = Finance,Customer,Supplier;
        }
        field(19;ChangeOthers;Boolean)
        {
            Editable = false;
            InitValue = false;
        }
        field(20;HasBeenChanged;Boolean)
        {
            Editable = false;
            InitValue = false;
        }
        field(21;ChangeCounter;Integer)
        {
            Editable = false;
            InitValue = 0;
        }
        field(22;"Payslip Column";Option)
        {
            OptionMembers = "1","2","3";
        }
        field(23;"S. Report Appearance";Option)
        {
            OptionMembers = "Non-zero & Code","Always & Code","Always & Text","Non-zero & Text","Does not appear",Heading;
        }
        field(24;"Overline Column";Option)
        {
            InitValue = "None";
            OptionMembers = "None","1","2","3","1-2","2-3","1-3";
        }
        field(25;"Underline Amount";Option)
        {
            InitValue = "None";
            OptionMembers = "None",Underline,"Double Underline";
        }
        field(26;"Loan ID";Code[10])
        {
            TableRelation = "Payroll-Loan";
        }
        field(27;"Payslip Text";Text[40])
        {
            Editable = false;
        }
        field(28;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(30;"User Id";Code[50])
        {
            Editable = false;
            TableRelation = User;
        }
        field(31;Status;Option)
        {
            Editable = false;
            OptionMembers = " ",Journal,Posted;
        }
        field(32;"Period Start";Date)
        {
            Editable = false;
        }
        field(33;"Period End";Date)
        {
            Editable = false;
        }
        field(34;"Job No.";Code[20])
        {
            TableRelation = Job;
        }
        field(35;Reimbursable;Boolean)
        {
        }
        field(37;Bold;Boolean)
        {
        }
        field(38;"Arrears Amount";Decimal)
        {
        }
        field(40;"Actual Prorated Amount";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(42;"Amount (LCY)";Decimal)
        {
            Editable = false;
        }
        field(43;Compute;Code[20])
        {
            TableRelation = "Payroll-E/D";
        }
        field(44;"Common ID";Code[10])
        {
        }
        field(45;"Loan (Y/N)";Boolean)
        {
        }
        field(46;"No. of Days Prorate";Boolean)
        {
        }
        field(47;"No. of Months Prorate";Boolean)
        {
        }
        field(48;"Currency Code";Code[10])
        {
        }
        field(49;"Dimension Set ID";Integer)
        {
        }
        field(50;"Processed Leave Entry No.";Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"Payroll Period","Employee No.","E/D Code")
        {
            Clustered = true;
            SumIndexFields = Amount,Quantity,"Arrears Amount";
        }
        key(Key2;"Payroll Period","Global Dimension 1 Code","Global Dimension 2 Code","Job No.","Debit Acc. Type","Debit Account","Credit Acc. Type","Credit Account","Loan ID")
        {
            SumIndexFields = Amount,"Arrears Amount";
        }
        key(Key3;"Payroll Period","Employee No.","Statistics Group Code","Pos. In Payslip Grp.")
        {
            SumIndexFields = Amount,Quantity,"Arrears Amount";
        }
        key(Key4;"E/D Code","Employee No.","Payroll Period")
        {
        }
        key(Key5;"Employee No.","Payroll Period")
        {
        }
        key(Key6;"Global Dimension 1 Code","E/D Code")
        {
        }
        key(Key7;"Payroll Period","Global Dimension 1 Code","Employee No.","E/D Code")
        {
        }
        key(Key8;"Global Dimension 1 Code","Employee No.","Employee Category")
        {
            SumIndexFields = Amount,"Arrears Amount";
        }
        key(Key9;"Payroll Period","Employee No.","Loan ID",Status)
        {
            SumIndexFields = Amount,"Arrears Amount";
        }
        key(Key10;"Debit Account","Credit Account")
        {
        }
        key(Key11;"Employee No.","E/D Code",Units)
        {
        }
        key(Key12;"Employee No.","Statistics Group Code","Period End")
        {
            SumIndexFields = Amount,"Arrears Amount";
        }
        key(Key13;"Payroll Period","E/D Code","Debit Account","Credit Account")
        {
            SumIndexFields = Amount,"Arrears Amount";
        }
        key(Key14;Amount,Compute,ChangeOthers,"Common ID","Loan (Y/N)")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ProllHeader.Get( "Payroll Period", "Employee No.") then begin
          if ProllHeader.Closed then
            Error (Text003, "Employee No.", "Payroll Period");

          ProllHeader.TestField(ProllHeader.Status,0);
          "E/DFileRec".Get("E/D Code");
          if "E/DFileRec"."Block Deletion" then
            Error(Text012);

          ChangeOthers := false;
          ChangeDueToDelete(Rec);

          ResetChangeFlags(Rec);

          "E/DFileRec".Get("E/D Code");
          if "E/DFileRec"."Loan (Y/N)" then begin
            ProllLoanEntry.SetCurrentkey("Payroll Period","Employee No.","E/D Code","Loan ID");
            ProllLoanEntry.SetRange("Payroll Period","Payroll Period");
            ProllLoanEntry.SetRange("Employee No.","Employee No.");
            ProllLoanEntry.SetRange("E/D Code","E/D Code");
            ProllLoanEntry.SetRange("Entry Type",ProllLoanEntry."entry type"::"Payroll Deduction");
            if ProllLoanEntry.FindFirst then begin
              repeat
                ProllLoan.Get(ProllLoanEntry."Loan ID");
                ProllLoanEntry.Delete;
                ProllLoan.CalcFields("Remaining Amount");
                ProllLoan."Open(Y/N)" := (ProllLoan."Remaining Amount" <> 0);
                ProllLoan.Modify;
              until ProllLoanEntry.Next = 0
             end;
          end;
          if "Processed Leave Entry No." <> 0 then begin
            EmployeeAbsence.Get("Processed Leave Entry No.");
            EmployeeAbsence."Payroll Period" := '';
            EmployeeAbsence.Modify;
          end
        end;
    end;

    trigger OnInsert()
    begin
        EmployeeRec.Get("Employee No.");
        "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
        "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
        "User Id" := UserId;

        if "E/D Code" <> '' then begin
          "E/DFileRec".Get("E/D Code");
          if ("E/DFileRec"."Loan (Y/N)") and ("Loan ID" = '') then
            Amount := CalcLoanAmount("E/DFileRec",Rec);
        end;

        "Employee Category":= EmployeeRec."Employee Category";
    end;

    trigger OnModify()
    begin
        if ProllHeader.Get( "Payroll Period", "Employee No.") then begin
          if ProllHeader.Closed then
            Error (Text003, "Employee No.", "Payroll Period");
          ProllHeader.TestField(ProllHeader.Status,0);

          if (Rec.Amount <> xRec.Amount) or ("Loan ID" <> '') then
          begin
            if Amount <> 0 then begin

              CheckCommonIDExists(true);

              "E/DFileRec".Reset;
              "E/DFileRec".Get("E/D Code");
              if "E/DFileRec"."Max. Entries Per Year" <> 0 then
                if "E/DFileRec"."Max. Entries Per Year" < CheckNoOfEntries then
                  Error(Text001,"E/DFileRec".Description,PeriodTaken);

              EmployeeRec.Get("Employee No.");
              if "E/DFileRec"."Marital Status" <> 0 then
                EmployeeRec.TestField("Marital Status","E/DFileRec"."Marital Status");
            end;
            if ("Loan ID" <> '') and (Amount <> xRec.Amount) then begin
              if CurrFieldNo = FieldNo( Amount) then
                Error(Text002);
            end;

            CalcAmountLCY;

            Modify;
            Commit;

            Mark(true);

            "E/DFileRec".Reset;
            //ProllEntryRec.RESET;

            CalcCompute (Rec,Rec.Amount,false,"E/D Code");
            CalcFactor1 (Rec);
            ChangeOthers := false;
            ChangeAllOver (Rec, false);
            ResetChangeFlags(Rec);
          end;
          "User Id" := UserId;
        end;
    end;

    var
        "E/DFileRec": Record "Payroll-E/D";
        ConstEDFileRec: Record "Payroll-E/D";
        ProllHeader: Record "Payroll-Payslip Header";
        ProllRecStore: Record "Payroll-Payslip Line";
        ProllFactorRec: Record "Payroll-Payslip Line";
        LookHeaderRec: Record "Payroll-Lookup Header";
        LookLinesRec: Record "Payroll-Lookup Line";
        FactorLookRec: Record "Payroll-Factor Lookup";
        EmployeeRec: Record "Payroll-Employee";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        PrevLookRec: Record "Payroll-Lookup Line";
        ProllLoan: Record "Payroll-Loan";
        ProllLoanEntry: Record "Payroll-Loan Entry";
        ProllLoanEntry2: Record "Payroll-Loan Entry";
        ProllPeriod: Record "Payroll-Period";
        FinanceAccRec: Record "G/L Account";
        CustomerAccRec: Record Customer;
        SupplierAccRec: Record Vendor;
        PayPeriodRec: Record "Payroll-Period";
        RepRec: Record "Payroll-Payslip Line";
        PayrollSetUp: Record "Payroll-Setup";
        HRSetup: Record "Human Resources Setup";
        PayrollHeader: Record "Payroll-Payslip Header";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        EmployeeAbsence: Record "Employee Absence";
        EmpGroupLine: Record "Payroll-Employee Group Line";
        DimMgt: Codeunit DimensionManagement;
        RoundDir: Text[1];
        ReturnAmount: Decimal;
        InputAmount: Decimal;
        ComputedTotal: Decimal;
        AmountToAdd: Decimal;
        FactorRecAmount: Decimal;
        AmtToAdd: Decimal;
        RoundPrec: Decimal;
        BackOneRec: Integer;
        MaxChangeCount: Integer;
        NoOfDays: Integer;
        IsComputed: Boolean;
        FactorOf: Boolean;
        Text000: label 'It is not possible to have %1 and %2 together!';
        Text001: label 'Maximum no. of entries already exceeded!\ %1 already taken in %2';
        Text002: label 'Loan Amount can not changed manually';
        Text003: label 'Entries for Employee %1/ in Period %2/ are closed\Nothing can be deleted';
        Text004: label 'E/D code %1 cannot be changed for %2!';
        Text005: label 'Entries for Employee %1 for period %2 have already been closed';
        Text006: label 'Do you want to apply Maximum/Minimum check!';
        Text007: label 'Factor Lookup Not Registered Yet';
        Text008: label 'The E/D Code %1,seems to have been defined with CYCLIC characteristics';
        PeriodTaken: Code[20];
        Text009: label 'Do you want to delete %1';
        Text010: label 'This employee is not entitled to this E/D';
        nMonths: Decimal;
        RefDate: Date;
        Text011: label 'Fatal Error! Employment Date for Employee %1 is blank';
        Text012: label 'ED Cannot be deleted!';
        CurrencyDate: Date;


    procedure SpecialRelation("FieldNo.": Integer)
    begin
        if "E/D Code" <> '' then
          exit;

        if CheckClosed  then
          Error (Text005, "Employee No.", "Payroll Period");
    end;


    procedure CalcAmount(EDFileRec: Record "Payroll-E/D";var EntryLineRec: Record "Payroll-Payslip Line";EntryLineAmount: Decimal;EDCode: Code[20]): Decimal
    begin
        if (EDFileRec."Yes/No Req.") and not (EntryLineRec.Flag) then
          exit (0);
        
        if EDFileRec."Loan (Y/N)" then begin
          ReturnAmount := CalcLoanAmount(EDFileRec,EntryLineRec);
          ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
          exit (ReturnAmount);
        end;
        
        if EDFileRec."Annual Leave ED" then begin
          ReturnAmount := GetLeaveAmount(EntryLineRec,EDFileRec);
          ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
          exit(ReturnAmount);
        end;
        
        if EDFileRec."Annual Allowance ED" then begin
          ReturnAmount := GetEDAmount(EntryLineRec,EDFileRec);
          ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
          exit(ReturnAmount);
        end;
        
        EDFileRec.CalcFields("Value Exist");
        if EDFileRec."Value Exist" then begin
          ReturnAmount := EDFileRec.GetAmount(EntryLineRec."Payroll Period");
          ReturnAmount := ProrateAmount(EDFileRec,ReturnAmount,EntryLineRec);
          EntryLineRec."Actual Prorated Amount" := ReturnAmount;
          ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
          exit(ReturnAmount);
        end;
        
        if EDFileRec."Static ED" then begin
          ProllHeader.Get(EntryLineRec."Payroll Period",EntryLineRec."Employee No.");
          EmpGroupLine.Get(ProllHeader."Salary Group",EDFileRec."E/D Code");
          ReturnAmount := EmpGroupLine."Default Amount";
          EntryLineRec."Actual Prorated Amount" := ReturnAmount;
          ReturnAmount := ProrateAmount(EDFileRec,ReturnAmount,EntryLineRec);
          ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
          exit (ReturnAmount);
        end;
        
        if EDFileRec."Factor Of" = '' then begin
          if EDFileRec."Factor Lookup" <> '' then begin
            if not FactorLookRec.Get( EDFileRec."Factor Lookup") then
              begin
                Message (Text007);
                exit (EntryLineRec.Amount);
              end
                else begin /* Factor lookup exists*/
                  ReturnAmount := (FactorLookRec.CalcAmount(EntryLineRec,EDCode,"Payroll Period","Employee No.")
                                * EDFileRec.Percentage) / 100;
                  EntryLineRec."Actual Prorated Amount" := ReturnAmount;
                  ReturnAmount := ProrateAmount(EDFileRec,ReturnAmount,EntryLineRec);
                  ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
                  exit (ReturnAmount);
                end;
          end;
          if not AmountIsComputed (ReturnAmount, EntryLineRec, EDFileRec,EntryLineAmount, EDCode) then
            exit (EntryLineRec.Amount)
          else
            begin
              EntryLineRec."Actual Prorated Amount" := ReturnAmount;
              ReturnAmount := ProrateAmount(EDFileRec,ReturnAmount,EntryLineRec);
              ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
              exit (ReturnAmount);
            end;
        end;
        
        if not ProllFactorRec.Get(EntryLineRec."Payroll Period",EntryLineRec."Employee No.",EDFileRec."Factor Of") then
          exit (EntryLineRec.Amount)
        else
          if  ProllFactorRec."E/D Code" = EDCode then
            ProllFactorRec.Amount := EntryLineAmount;
        
        if EDFileRec."Table Look Up" = '' then begin
          ReturnAmount := (ProllFactorRec.Amount * EDFileRec.Percentage) / 100 ;
          EntryLineRec."Actual Prorated Amount" := ReturnAmount;
          ReturnAmount := ProrateAmount(EDFileRec,ReturnAmount,EntryLineRec);
        end else
          if not  LookHeaderRec.Get( EDFileRec."Table Look Up") then
            begin
              Message (Text007);
              exit (EntryLineRec.Amount)
            end
              else begin
                LookLinesRec.TableId := EDFileRec."Table Look Up";
                LookLinesRec.SetRange(TableId, EDFileRec."Table Look Up");
                case LookHeaderRec.Type of
                  0,2:
                    begin
                      if ProllFactorRec.Amount > -1 then begin
                        LookLinesRec."Lower Code" := '';
                        InputAmount := ProllFactorRec.Amount * LookHeaderRec."Input Factor";
                        LookLinesRec."Lower Amount" := InputAmount;
                        LookLinesRec.SetRange("Lower Code",'');
                      end
                        else
                          exit (LookHeaderRec."Min. Extract Amount")
                    end;
                  else
                    begin
                      LookLinesRec."Lower Amount" := 0;
                      LookLinesRec."Lower Code" := EDFileRec."E/D Code";
                      LookLinesRec.SetRange("Upper Amount",0);
                      LookLinesRec.SetRange("Lower Amount",0);
                    end
                end; /* Case*/
        
                case LookHeaderRec.Type of
                  0,1: begin
                    if  LookLinesRec.Find( '=') then
                      ReturnAmount := LookLinesRec."Extract Amount"
                    else
                      if  LookLinesRec.Find( '>') then begin
                        BackOneRec :=  LookLinesRec.Next( -1);
                        ReturnAmount := LookLinesRec."Extract Amount";
                      end
                        else
                          if LookHeaderRec.Type = 0 then begin
                            if  LookLinesRec.Find( '+') then
                              ReturnAmount := LookLinesRec."Extract Amount";
                          end
                            else
                              exit (EntryLineRec.Amount);
                  end;
        
                  2:
                    ReturnAmount := (CalcTaxAmt (LookLinesRec, InputAmount)) *
                                    LookHeaderRec."Output Factor";
                end; /* Case */
        
                if (LookHeaderRec."Max. Extract Amount" <> 0) and
                   (ReturnAmount > LookHeaderRec."Max. Extract Amount") then
                  ReturnAmount := LookHeaderRec."Max. Extract Amount"
                else
                  if (ReturnAmount < LookHeaderRec."Min. Extract Amount") then
                    ReturnAmount := LookHeaderRec."Min. Extract Amount";
        
                if LookHeaderRec."Rounding Precision" = 0 then
                  RoundPrec := 0.01
                else
                  RoundPrec := LookHeaderRec."Rounding Precision";
                case LookHeaderRec."Rounding Direction" of
                  1: RoundDir := '>';
                  2: RoundDir := '<';
                  else RoundDir := '=';
                end;
                ReturnAmount := ROUND (ReturnAmount, RoundPrec, RoundDir);
                EntryLineRec."Actual Prorated Amount" := ReturnAmount;
                ReturnAmount := ProrateAmount(EDFileRec,ReturnAmount,EntryLineRec);
                LookLinesRec.Reset
              end;
        
        ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
        
        exit(ReturnAmount);

    end;


    procedure CheckClosed(): Boolean
    begin
        if  ProllHeader.Get("Payroll Period","Employee No.") then
          exit (ProllHeader.Closed);
    end;


    procedure CalcTaxAmt(var LDetailsRec: Record "Payroll-Lookup Line";TaxTableInput: Decimal): Decimal
    begin
        PrevLookRec := LDetailsRec;
        if  LDetailsRec.Find( '=') then
          if  PrevLookRec.Next(-1) = 0 then
            ReturnAmount := (TaxTableInput * LDetailsRec."Tax Rate %")/100
          else
            ReturnAmount := CalcGraduated (LDetailsRec, TaxTableInput)
        else
        if  LDetailsRec.Find( '>') then
          if  LDetailsRec.Next(-1) = 0 then
            ReturnAmount := 0
          else
            ReturnAmount := CalcGraduated (LDetailsRec, TaxTableInput)
        else
          if  LDetailsRec.Next(-1) = 0 then
            ReturnAmount := (TaxTableInput * LDetailsRec."Tax Rate %")/100
          else
            ReturnAmount := CalcGraduated (LDetailsRec, TaxTableInput);

        exit (ReturnAmount);
    end;


    procedure CalcGraduated(var WantedLookRec: Record "Payroll-Lookup Line";InputToTable: Decimal): Decimal
    begin
        PrevLookRec :=  WantedLookRec;
        if  PrevLookRec.Next(-1) = 0 then
         ReturnAmount := (InputToTable * WantedLookRec."Tax Rate %")/100
        else
          begin
             ReturnAmount :=  (InputToTable - PrevLookRec."Upper Amount");
             ReturnAmount :=  (ReturnAmount * WantedLookRec."Tax Rate %")/100;
             ReturnAmount :=  ReturnAmount + PrevLookRec."Cum. Tax Payable";
          end;
        exit (ReturnAmount);
    end;


    procedure CalcCompute(EntryRecParam: Record "Payroll-Payslip Line";AmountInLine: Decimal;"CalledFromEdCode?": Boolean;EDCode: Code[20])
    var
        ProllEntryRec: Record "Payroll-Payslip Line";
        PayslipLineQry: Query "Payroll-Payslip Line Query";
    begin
        ConstEDFileRec.Get(EntryRecParam."E/D Code");
        if ConstEDFileRec.Compute = '' then
          exit;
        if not ProllEntryRec.Get(EntryRecParam."Payroll Period",EntryRecParam."Employee No.",
          ConstEDFileRec.Compute) then
            exit;
        
        if "CalledFromEdCode?" then
          begin
            if ConstEDFileRec."Add/Subtract" = 2 then
              /* Subtract */
              ComputedTotal := - AmountInLine
            else
              /* Add */
              ComputedTotal := AmountInLine
          end else
            ComputedTotal := 0;
        Clear(PayslipLineQry);
        PayslipLineQry.SetRange(Payroll_Period,EntryRecParam."Payroll Period");
        PayslipLineQry.SetRange(Employee_No,EntryRecParam."Employee No.");
        PayslipLineQry.SetRange(Compute,ConstEDFileRec.Compute);
        if PayslipLineQry.Open then begin
          while PayslipLineQry.Read do begin
            if  EDCode = PayslipLineQry.E_D_Code then
              AmountToAdd := AmountInLine
            else
              AmountToAdd := PayslipLineQry.Amount;
        
            "E/DFileRec".Get(PayslipLineQry.E_D_Code);
            if "E/DFileRec"."Add/Subtract" = 2 then
              /* Subtract */
              ComputedTotal := ComputedTotal - AmountToAdd
            else
              /* Add */
              ComputedTotal := ComputedTotal + AmountToAdd;
          end;
          Clear(PayslipLineQry);
          PayslipLineQry.Close;
        end;
        "E/DFileRec".Get(ConstEDFileRec.Compute);
        ComputedTotal := ChkRoundMaxMin ("E/DFileRec",ComputedTotal);
        
        ProllEntryRec.Get(EntryRecParam."Payroll Period",EntryRecParam."Employee No.",ConstEDFileRec.Compute);
        ProllEntryRec.Amount := ComputedTotal;
        if (ProllEntryRec.Units <> '')then
          ProllEntryRec.Validate(ProllEntryRec.Rate,ProllEntryRec.Amount);
        ProllEntryRec.ChangeOthers := true;
        ProllEntryRec.HasBeenChanged := true;
        ProllEntryRec.CalcAmountLCY;
        ProllEntryRec.Modify;
        Commit;

    end;


    procedure CalcFactor1(CurrentEntryLine: Record "Payroll-Payslip Line")
    var
        ProllEntryRec: Record "Payroll-Payslip Line";
        PayslipLineQry: Query "Payroll-Payslip Line Query";
    begin
        Clear(PayslipLineQry);
        PayslipLineQry.SetRange(Payroll_Period,CurrentEntryLine."Payroll Period");
        PayslipLineQry.SetRange(Employee_No,CurrentEntryLine."Employee No.");
        if PayslipLineQry.Open then begin
          while PayslipLineQry.Read do begin
            "E/DFileRec".Get(PayslipLineQry.E_D_Code);
            FactorOf := false;

            if "E/DFileRec"."Factor Lookup" <> '' then begin
              FactorLookRec.Get("E/DFileRec"."Factor Lookup");
              FactorOf := FactorLookRec.CheckForFactor(CurrentEntryLine."E/D Code");
            end;

            if ("E/DFileRec"."Factor Of" = CurrentEntryLine."E/D Code") or
              (FactorOf and ("E/DFileRec"."E/D Code" <> CurrentEntryLine."E/D Code")) then
              begin
                ProllEntryRec.Get(PayslipLineQry.Payroll_Period,PayslipLineQry.Employee_No,
                  PayslipLineQry.E_D_Code);
                FactorRecAmount := ProllEntryRec.Amount;
                ProllEntryRec.Amount := "CalcFactor1.1" (CurrentEntryLine,
                                                         ProllEntryRec,"E/DFileRec");

                ProllEntryRec.Amount := ProrateAmount("E/DFileRec",ProllEntryRec.Amount,CurrentEntryLine);
                ProllEntryRec.CalcAmountLCY;
                if (ProllEntryRec.Units <> '')  then begin
                  ProllEntryRec.Validate(ProllEntryRec.Rate,ProllEntryRec.Amount);
                  ProllEntryRec.Modify;
                end;

                if FactorRecAmount <> ProllEntryRec.Amount then
                  begin
                    ProllEntryRec.ChangeOthers := true;
                    ProllEntryRec.Modify;
                  end
              end;
          end;
          Clear(PayslipLineQry);
          PayslipLineQry.Close;
        end;
        Commit;
    end;


    procedure "CalcFactor1.1"(CurrLineRec: Record "Payroll-Payslip Line";LineToChangeRec: Record "Payroll-Payslip Line";EDFileRec: Record "Payroll-E/D"): Decimal
    begin
        if (EDFileRec."Yes/No Req.") and not (LineToChangeRec.Flag) then
          exit (0);
        
        if EDFileRec."Factor Lookup" <> '' then
          ReturnAmount := (FactorLookRec.CalcAmount(CurrLineRec,LineToChangeRec."E/D Code",LineToChangeRec."Payroll Period",
                           LineToChangeRec."Employee No.") * EDFileRec.Percentage) / 100
        else
          if EDFileRec."Table Look Up" = '' then
            ReturnAmount := (CurrLineRec.Amount * EDFileRec.Percentage) / 100
          else
            if not LookHeaderRec.Get(EDFileRec."Table Look Up") then
              begin
                Message (Text007);
                exit (LineToChangeRec.Amount)
              end else begin
                LookLinesRec.TableId := EDFileRec."Table Look Up";
                LookLinesRec.SetRange(TableId, EDFileRec."Table Look Up");
                case LookHeaderRec.Type of
                  0,2:begin
                    if CurrLineRec.Amount > -1 then begin
                      LookLinesRec."Lower Code" := '';
                      LookLinesRec."Lower Amount" := CurrLineRec.Amount * LookHeaderRec."Input Factor";
                      LookLinesRec.SetRange("Lower Code",'');
                    end else
                      exit (LookHeaderRec."Min. Extract Amount")
                  end;
                  else begin
                    LookLinesRec."Lower Amount" := 0;
                    LookLinesRec."Lower Code" := CurrLineRec."E/D Code";
                    LookLinesRec.SetRange("Upper Amount",0);
                    LookLinesRec.SetRange("Lower Amount",0);
                  end
                end; /* Case*/
        
                case LookHeaderRec.Type of
                  0,1: begin
                    if  LookLinesRec.Find( '=') then
                      ReturnAmount := LookLinesRec."Extract Amount"
                    else
                      if  LookLinesRec.Find( '>') then
                        begin
                          BackOneRec :=  LookLinesRec.Next( -1);
                          ReturnAmount := LookLinesRec."Extract Amount";
                        end
                          else
                            if LookHeaderRec.Type = 0 then begin
                              if  LookLinesRec.Find( '+') then
                                ReturnAmount := LookLinesRec."Extract Amount"
                              else
                                exit (LineToChangeRec.Amount)
                            end
                              else
                                exit (LineToChangeRec.Amount);
                  end;
        
                  2:
                    ReturnAmount := (CalcTaxAmt (LookLinesRec, CurrLineRec.Amount *
                                           LookHeaderRec."Input Factor")) *
                              LookHeaderRec."Output Factor";
                end; /* Case */
        
                if (LookHeaderRec."Max. Extract Percentage" <> 0) and
                  (ReturnAmount > LookHeaderRec."Max. Extract Percentage" * CurrLineRec.Amount / 100) then
                    ReturnAmount := LookHeaderRec."Max. Extract Percentage" * CurrLineRec.Amount / 100
                else
                  if (ReturnAmount < LookHeaderRec."Min. Extract Percentage" * CurrLineRec.Amount / 100) then
                    ReturnAmount := LookHeaderRec."Min. Extract Percentage" * CurrLineRec.Amount / 100;
        
                if (LookHeaderRec."Max. Extract Amount" <> 0) and
                   (ReturnAmount > LookHeaderRec."Max. Extract Amount") then
                  ReturnAmount := LookHeaderRec."Max. Extract Amount"
                else
                  if (ReturnAmount < LookHeaderRec."Min. Extract Amount") then
                    ReturnAmount := LookHeaderRec."Min. Extract Amount";
        
                if LookHeaderRec."Rounding Precision" = 0 then
                  RoundPrec := 0.01
                else
                  RoundPrec := LookHeaderRec."Rounding Precision";
                case LookHeaderRec."Rounding Direction" of
                  1: RoundDir := '>';
                  2: RoundDir := '<';
                  else RoundDir := '=';
                end;
                ReturnAmount := ROUND (ReturnAmount, RoundPrec, RoundDir);
        
                LookLinesRec.Reset
              end;
        
        ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
        
        exit (ReturnAmount);

    end;


    procedure ChangeAllOver(CurrentRec: Record "Payroll-Payslip Line";CurrWasDeleted: Boolean)
    var
        ChangeOthersRec: Record "Payroll-Payslip Line";
        PayslipLineQry: Query "Payroll-Payslip Line Query";
    begin
        ChangeOthersRec := CurrentRec;
        ChangeOthersRec.SetRange("Payroll Period", CurrentRec."Payroll Period");
        ChangeOthersRec.SetRange("Employee No.", CurrentRec."Employee No.");
        ChangeOthersRec.SetRange(ChangeOthers, true);

        ChangeOthersRec."E/D Code" := '';
        if not ChangeOthersRec.Find('>') then
          exit;

        MaxChangeCount := 50;

        repeat
          if not (CurrWasDeleted and (ChangeOthersRec."E/D Code" =
                                      CurrentRec."E/D Code"))
          then begin
            ComputeAgain (ChangeOthersRec, CurrentRec, CurrWasDeleted);
            CalcFactorAgain (ChangeOthersRec, CurrentRec, CurrWasDeleted);
          end;
          ChangeOthersRec.ChangeOthers := false;
          ChangeOthersRec.ChangeCounter := ChangeOthersRec.ChangeCounter + 1;
          ChangeOthersRec.Modify;
          ProllRecStore := ChangeOthersRec;
          ChangeOthersRec."E/D Code" := '';
        until ((ProllRecStore.ChangeCounter > MaxChangeCount) or
               ( ChangeOthersRec.Next(1) = 0));
        Commit;
        ChangeOthersRec.SetRange("Payroll Period");
        ChangeOthersRec.SetRange("Employee No.");
        ChangeOthersRec.SetRange(ChangeOthers);

        if (ProllRecStore.ChangeCounter > MaxChangeCount) then
          Message (Text008, ProllRecStore."E/D Code");

        exit;
    end;


    procedure ComputeAgain(ParamLine: Record "Payroll-Payslip Line";CurrentRec: Record "Payroll-Payslip Line";CurrWasDeleted: Boolean)
    var
        ProllEntryRec: Record "Payroll-Payslip Line";
        PayslipLineQry: Query "Payroll-Payslip Line Query";
    begin
        ConstEDFileRec.Get(ParamLine."E/D Code");
        if ConstEDFileRec.Compute = '' then
          exit;
        if not ProllEntryRec.Get(CurrentRec."Payroll Period",CurrentRec."Employee No.",ConstEDFileRec.Compute)
          then
            exit;
        
        if (CurrWasDeleted and (ProllEntryRec."E/D Code" = CurrentRec."E/D Code"))
          then
            exit;
        
        "E/DFileRec".Get(CurrentRec."E/D Code");
        if CurrWasDeleted then
          ComputedTotal := 0
        else
         if "E/DFileRec".Compute = ConstEDFileRec.Compute then begin
           if "E/DFileRec"."Add/Subtract" = 2 then
            /* Subtract */
            ComputedTotal := -  CurrentRec.Amount
           else
            /* Add */
            ComputedTotal := CurrentRec.Amount;
         end
          else
           ComputedTotal := 0;
        
        Clear(PayslipLineQry);
        PayslipLineQry.SetRange(Payroll_Period,CurrentRec."Payroll Period");
        PayslipLineQry.SetRange(Employee_No,CurrentRec."Employee No.");
        PayslipLineQry.SetRange(Compute,ConstEDFileRec.Compute);
        if PayslipLineQry.Open then begin
          while PayslipLineQry.Read do begin
            if PayslipLineQry.E_D_Code <> CurrentRec."E/D Code" then begin
               "E/DFileRec".Get(PayslipLineQry.E_D_Code);
               if "E/DFileRec"."Add/Subtract" = 2 then
                 /* Subtract */
                 ComputedTotal := ComputedTotal - PayslipLineQry.Amount
               else
                 /* Add */
                 ComputedTotal := ComputedTotal + PayslipLineQry.Amount
            end;
          end;
          PayslipLineQry.Close;
          Clear(PayslipLineQry);
        end;
        ProllEntryRec.Get(CurrentRec."Payroll Period",CurrentRec."Employee No.",ConstEDFileRec.Compute);
        "E/DFileRec".Get(ConstEDFileRec.Compute);
        ComputedTotal := ChkRoundMaxMin ("E/DFileRec", ComputedTotal);
        if ProllEntryRec.Amount <> ComputedTotal then
          begin
            ProllEntryRec.Amount := ComputedTotal;
            ProllEntryRec.CalcAmountLCY;
            ProllEntryRec.ChangeOthers := true;
            ProllEntryRec.Modify
          end;
        Commit;

    end;


    procedure CalcFactorAgain(ParamLine: Record "Payroll-Payslip Line";CurrentRec: Record "Payroll-Payslip Line";CurrWasDeleted: Boolean)
    var
        ProllEntryRec: Record "Payroll-Payslip Line";
        PayslipLineQry: Query "Payroll-Payslip Line Query";
    begin
        Clear(PayslipLineQry);
        PayslipLineQry.SetRange(Payroll_Period,ParamLine."Payroll Period");
        PayslipLineQry.SetRange(Employee_No,ParamLine."Employee No.");
        if PayslipLineQry.Open then
          if not(PayslipLineQry.Read) then begin
            Clear(PayslipLineQry);
            PayslipLineQry.Close;
            exit
          end else begin
            PayslipLineQry.Open;
            while PayslipLineQry.Read do begin
              ProllEntryRec.Get(PayslipLineQry.Payroll_Period,PayslipLineQry.Employee_No,PayslipLineQry.E_D_Code);
              "E/DFileRec".Get(PayslipLineQry.E_D_Code);
              FactorOf := false;
              if "E/DFileRec"."Factor Lookup" <> '' then begin
                FactorLookRec.Get("E/DFileRec"."Factor Lookup");
                FactorOf := FactorLookRec.CheckForFactor(ParamLine."E/D Code");
              end;

              if ("E/DFileRec"."Factor Of" = ParamLine."E/D Code") or
                (FactorOf and ("E/DFileRec"."E/D Code" <> ParamLine."E/D Code")) then
              begin

                FactorRecAmount := PayslipLineQry.Amount;
                if (CurrWasDeleted and (ParamLine."E/D Code" = CurrentRec."E/D Code"))
                  then
                    ProllEntryRec.Amount := 0
                  else
                    ProllEntryRec.Amount := "CalcFactor1.1" (ParamLine, ProllEntryRec,
                                                       "E/DFileRec");

                ProllEntryRec.Amount := ProrateAmount("E/DFileRec",ProllEntryRec.Amount,ProllEntryRec);
                ProllEntryRec.CalcAmountLCY;
                if (ProllEntryRec.Units <> '')  then begin
                  ProllEntryRec.Validate(ProllEntryRec.Rate,ProllEntryRec.Amount);
                  ProllEntryRec.Modify;
                end;

                if FactorRecAmount <> ProllEntryRec.Amount then
                  begin
                    ProllEntryRec.ChangeOthers := true;
                    ProllEntryRec.Modify
                  end
              end;
            end;
            Clear(PayslipLineQry);
            PayslipLineQry.Close;
          end;
        Commit;
    end;


    procedure ResetChangeFlags(CurrentRec: Record "Payroll-Payslip Line")
    var
        ProllEntryRec: Record "Payroll-Payslip Line";
        PayslipLineQry: Query "Payroll-Payslip Line Query";
    begin
        Clear(PayslipLineQry);
        PayslipLineQry.SetRange(Payroll_Period,CurrentRec."Payroll Period");
        PayslipLineQry.SetRange(Employee_No,CurrentRec."Employee No.");
        if PayslipLineQry.Open then begin
          while PayslipLineQry.Read do begin
            ProllEntryRec.Get(PayslipLineQry.Payroll_Period,PayslipLineQry.Employee_No,PayslipLineQry.E_D_Code);
            ProllEntryRec.ChangeOthers   := false;
            ProllEntryRec.ChangeCounter := 0;
            if ProllEntryRec."E/D Code" <> CurrentRec."E/D Code" then
              ProllEntryRec.Modify;
          end;
          Clear(PayslipLineQry);
          PayslipLineQry.Close;
        end;

        Commit;
    end;


    procedure AmountIsComputed(var ReturnAmount: Decimal;EntryLineRec: Record "Payroll-Payslip Line";EDFileRec: Record "Payroll-E/D";NewAmount: Decimal;EDCode: Code[20]): Boolean
    var
        PayslipLineQry: Query "Payroll-Payslip Line Query";
    begin
        ReturnAmount := 0;
        IsComputed := false;
        Clear(PayslipLineQry);
        PayslipLineQry.SetRange(Payroll_Period,EntryLineRec."Payroll Period");
        PayslipLineQry.SetRange(Employee_No,EntryLineRec."Employee No.");
        if PayslipLineQry.Open then
          if not(PayslipLineQry.Read) then begin
            Clear(PayslipLineQry);
            PayslipLineQry.Close;
            exit
          end else begin
            PayslipLineQry.Close;
            PayslipLineQry.Open;
            while PayslipLineQry.Read do begin
              "E/DFileRec".Get(PayslipLineQry.E_D_Code);
              if "E/DFileRec".Compute = EntryLineRec."E/D Code" then begin
                if PayslipLineQry.E_D_Code = EDCode then
                  AmtToAdd := NewAmount
                else
                  AmtToAdd := PayslipLineQry.Amount;
        
                if "E/DFileRec"."Add/Subtract" = 2 then
                  /* Subtract */
                  ReturnAmount := ReturnAmount - AmtToAdd
                else
                  /* Add */
                  ReturnAmount := ReturnAmount + AmtToAdd;
        
                IsComputed := true
              end;
            end;
          Clear(PayslipLineQry);
          PayslipLineQry.Close;
          end;
        exit(IsComputed);

    end;


    procedure ChangeDueToDelete(DeletedRec: Record "Payroll-Payslip Line")
    var
        ProllEntryRec: Record "Payroll-Payslip Line";
    begin
        ProllEntryRec := DeletedRec;
        ProllEntryRec.SetRange("Payroll Period", DeletedRec."Payroll Period");
        ProllEntryRec.SetRange("Employee No.", DeletedRec."Employee No.");

        if not "E/DFileRec".Get(DeletedRec."E/D Code") then
          exit;
        ProllEntryRec."E/D Code" := "E/DFileRec".Compute;
        if ProllEntryRec.Find('=') then
          ComputeAgain(DeletedRec,DeletedRec,true);

        CalcFactorAgain(DeletedRec,DeletedRec,true);

        ChangeAllOver(DeletedRec,true);
        exit;
    end;


    procedure ChkRoundMaxMin(EDRecord: Record "Payroll-E/D";TheAmount: Decimal): Decimal
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
          1: RoundDir := '>';
          2: RoundDir := '<';
          else RoundDir := '=';
        end;
        TheAmount := ROUND (TheAmount, RoundPrec, RoundDir);

        exit (TheAmount);
    end;


    procedure CalcLoanAmount(EDFileRec: Record "Payroll-E/D";var CurrEntryLineRec: Record "Payroll-Payslip Line"): Decimal
    var
        LoanRec: Record "Payroll-Loan";
        LoanEntry: Record "Payroll-Loan Entry";
        RepaymentAmt: Decimal;
        IntRepaymentAmt: Decimal;
        TotalRepaymentAmt: Decimal;
        RemainingAmt: Decimal;
        IntRemainingAmt: Decimal;
        IncludeLoan: Boolean;
        NextLoanEntryNo: Integer;
    begin
        LoanRec.SetCurrentkey("Employee No.","Loan E/D","Open(Y/N)");
        LoanRec.SetRange(LoanRec."Employee No.",CurrEntryLineRec."Employee No.");
        LoanRec.SetRange(LoanRec."Loan E/D",EDFileRec."E/D Code");
        LoanRec.SetRange(LoanRec."Open(Y/N)",true);
        if not LoanRec.Find('-') then begin
          LoanEntry.SetRange("Payroll Period",CurrEntryLineRec."Payroll Period");
          LoanEntry.SetRange("E/D Code",CurrEntryLineRec."E/D Code");
          LoanEntry.SetRange("Employee No.",CurrEntryLineRec."Employee No.");
          LoanEntry.SetRange("Entry Type",LoanEntry."entry type"::"Payroll Deduction");
          LoanEntry.CalcSums(Amount);
          exit(Abs(LoanEntry.Amount));
        end;
        ProllPeriod.Get(CurrEntryLineRec."Payroll Period");
        TotalRepaymentAmt := 0;
        repeat
          IncludeLoan := true;
          if LoanRec."Deduction Starting Date" = 0D then
            IncludeLoan := false;
          if LoanRec."Suspended(Y/N)" then
            if (LoanRec."Suspension Ending Date" > ProllPeriod."End Date") or ((LoanRec."Deduction Starting Date" <> 0D) and
            (LoanRec."Deduction Starting Date" > ProllPeriod."End Date"))
              then
                IncludeLoan := false;

          if ((LoanRec."Deduction Starting Date" <> 0D) and (LoanRec."Deduction Starting Date" > ProllPeriod."End Date")) then
            IncludeLoan := false;

          if IncludeLoan then begin
            LoanRec.SetFilter("Date Filter",'..%1',ProllPeriod."End Date");
            LoanRec.CalcFields("Remaining Amount","Interest Remaining Amount");
            RemainingAmt := LoanRec."Remaining Amount";
            LoanRec.SetRange("Date Filter",ProllPeriod."End Date");
            LoanRec.CalcFields("Repaid Amount","Interest Repaid Amount");

            if Abs(RemainingAmt) > 0 then
                CurrEntryLineRec."Loan ID" := LoanRec."Loan ID";
            if RemainingAmt > LoanRec."Monthly Repayment" then
              RepaymentAmt := LoanRec."Monthly Repayment"
            else
              RepaymentAmt := RemainingAmt;
            if (LoanRec."Interest Remaining Amount" <> 0) then
              IntRepaymentAmt := LoanRec."Interest Remaining Amount"
            else if (LoanRec."Interest Repaid Amount" <> 0) then
              IntRepaymentAmt := Abs(LoanRec."Interest Repaid Amount");

            if RepaymentAmt < 1.05 then
              RepaymentAmt := 0;

            //Create Loan Entry
            if (RepaymentAmt <> 0) and (RepaymentAmt <> (-1* (LoanRec."Repaid Amount"))) then begin
              ProllLoanEntry.Init;
              ProllLoanEntry."Payroll Period" := CurrEntryLineRec."Payroll Period";
              ProllLoanEntry.Date := ProllPeriod."End Date";
              ProllLoanEntry."Employee No." := CurrEntryLineRec."Employee No.";
              ProllLoanEntry."E/D Code" := CurrEntryLineRec."E/D Code";
              ProllLoanEntry."Loan ID" := LoanRec."Loan ID" ;
              if LoanRec."Repaid Amount" = 0 then
                ProllLoanEntry.Amount := -(RepaymentAmt)
              else
                ProllLoanEntry.Amount := -( RepaymentAmt - (-1* (LoanRec."Repaid Amount")));
              ProllLoanEntry."Entry Type" := ProllLoanEntry."entry type"::"Payroll Deduction";
              if ProllLoanEntry2.FindLast then
                ProllLoanEntry."Entry No." := ProllLoanEntry2."Entry No." + 1
              else
                ProllLoanEntry."Entry No." := 1;
              ProllLoanEntry.Insert;
            end;
            //Create Interest entry
            if (IntRepaymentAmt <> 0) and (IntRepaymentAmt <> (-1* (LoanRec."Interest Repaid Amount"))) then begin
              ProllLoanEntry.Init;
              ProllLoanEntry."Payroll Period" := CurrEntryLineRec."Payroll Period";
              ProllLoanEntry.Date := ProllPeriod."End Date";
              ProllLoanEntry."Employee No." := CurrEntryLineRec."Employee No.";
              ProllLoanEntry."E/D Code" := CurrEntryLineRec."E/D Code";
              ProllLoanEntry."Loan ID" := LoanRec."Loan ID" ;
              if LoanRec."Interest Repaid Amount" = 0 then
                ProllLoanEntry.Amount := -(IntRepaymentAmt)
              else
                ProllLoanEntry.Amount := -(IntRepaymentAmt - (-1* (LoanRec."Interest Repaid Amount")));
              ProllLoanEntry."Entry Type" := ProllLoanEntry."entry type"::"Payroll Deduction";
              ProllLoanEntry."Amount Type" := ProllLoanEntry."amount type"::"Interest Amount";
              if ProllLoanEntry2.FindLast then
                ProllLoanEntry."Entry No." := ProllLoanEntry2."Entry No." + 1
              else
                ProllLoanEntry."Entry No." := 1;
              ProllLoanEntry.Insert;
            end;


            TotalRepaymentAmt := TotalRepaymentAmt + RepaymentAmt + IntRepaymentAmt;
            LoanRec.SetRange("Date Filter");
            LoanRec.CalcFields("Remaining Amount");
            if (LoanRec."Remaining Amount" <= 1.05) then
             LoanRec."Open(Y/N)" := false;
            LoanRec.Modify;
          end;
        until LoanRec.Next = 0;

        exit (TotalRepaymentAmt);
    end;


    procedure ReCalculateAmount()
    var
        ProllEntryRec: Record "Payroll-Payslip Line";
    begin
        if CheckClosed  then
          Error (Text005, "Employee No.","Payroll Period");

         "E/DFileRec".Get( "E/D Code");

        begin
          "Statistics Group Code" := "E/DFileRec"."Statistics Group Code";
          "Pos. In Payslip Grp." := "E/DFileRec"."Pos. In Payslip Grp.";
          "Payslip Appearance" := "E/DFileRec"."Payslip appearance";
          Units := "E/DFileRec".Units;
          Rate := "E/DFileRec".Rate;
          "Overline Column" := "E/DFileRec"."Overline Column";
          "Underline Amount" := "E/DFileRec"."Underline Amount";
          "Payslip Text" := "E/DFileRec".Description;
          Compute := "E/DFileRec".Compute;
          "Common ID" := "E/DFileRec"."Common Id";
          "Loan (Y/N)" := "E/DFileRec"."Loan (Y/N)";
          "No. of Days Prorate"  := "E/DFileRec"."No. of Days Prorate";
          "No. of Months Prorate" := "E/DFileRec"."No. of Months Prorate";

        end;

        if (((Units = '') or ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Factor Lookup" <> '') or
           ("E/DFileRec"."Table Look Up" <> ''))) or "E/DFileRec"."Loan (Y/N)") and
           not ("E/DFileRec"."Yes/No Req.")) or (("E/DFileRec"."Yes/No Req.") and
           ((Amount <> 0) or Flag)) then
          begin
            if ("E/DFileRec"."Yes/No Req.") and (Amount <> 0) then
              Flag := true;

            Amount := CalcAmount("E/DFileRec",Rec,Amount,"E/D Code");

            if ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Factor Lookup" <> '') or
               ("E/DFileRec"."Table Look Up" <> ''))) then
              Validate(Rate,Amount);
          end;
    end;


    procedure CheckNoOfEntries() NoOfEntries: Integer
    var
        ProllPeriod: Record "Payroll-Period";
        ProllEntryRec: Record "Payroll-Payslip Line";
        ClosedProllEntryRec: Record "Closed Payroll-Payslip Line";
        PayrollFirstPeriod: Code[10];
    begin
        NoOfEntries := 0;

        ProllPeriod.Get("Payroll Period");
        ProllPeriod.SetRange(ProllPeriod."Start Date",Dmy2date(1,1,Date2dmy(ProllPeriod."Start Date",3)),ProllPeriod."Start Date");
        ProllPeriod.SetRange(ProllPeriod."Employee Category",ProllPeriod."Employee Category");
        if ProllPeriod.Find('-') then
          PayrollFirstPeriod := ProllPeriod."Period Code"
        else
          PayrollFirstPeriod := "Payroll Period";

        ProllEntryRec.SetCurrentkey("Payroll Period","Employee No.","E/D Code");
        ProllEntryRec.SetRange(ProllEntryRec."Payroll Period",PayrollFirstPeriod,"Payroll Period");
        ProllEntryRec.SetRange(ProllEntryRec."Employee No.","Employee No.");
        ProllEntryRec.SetRange(ProllEntryRec."E/D Code","E/D Code");
        ProllEntryRec.SetFilter(ProllEntryRec.Amount,'<>%1',0);

        ClosedProllEntryRec.SetCurrentkey("Payroll Period","Employee No.","E/D Code");
        ClosedProllEntryRec.SetRange("Payroll Period",PayrollFirstPeriod,"Payroll Period");
        ClosedProllEntryRec.SetRange("Employee No.","Employee No.");
        ClosedProllEntryRec.SetRange("E/D Code","E/D Code");
        ClosedProllEntryRec.SetFilter(Amount,'<>%1',0);


        NoOfEntries := ProllEntryRec.Count + ClosedProllEntryRec.Count;
        if ProllEntryRec.Find('+') then;
        if (ProllEntryRec."Payroll Period" <> "Payroll Period") and (Amount <> 0)  then begin
          NoOfEntries := NoOfEntries + 1;
          PeriodTaken := ProllEntryRec."Payroll Period";
        end;
    end;


    procedure ProrateAmount(EDFileRec: Record "Payroll-E/D";ProrateAmount: Decimal;PayLine: Record "Payroll-Payslip Line") ProratedAmount: Decimal
    var
        NoofMonthDays: Integer;
        RefDate2: Date;
    begin
        if (EDFileRec."No. of Days Prorate") and (ProrateAmount <> 0) then begin
          ProllHeader.Get(PayLine."Payroll Period",PayLine."Employee No.");
            if NoOfDays <> 0 then
              NoofMonthDays := NoOfDays
            else
              NoofMonthDays := ProllHeader."No. of Days Worked";
        
            ProratedAmount := ProrateAmount / ProllHeader."No. of Working Days Basis" * NoofMonthDays;
            /*IF (NoofMonthDays) <> 0  THEN
              ProratedAmount := ProrateAmount / ProllHeader."No. of Working Days Basis" * NoofMonthDays
            ELSE
              ProratedAmount := ProrateAmount;*/
            exit(ProratedAmount);
        end else
          exit(ProrateAmount);

    end;


    procedure CheckCommonIDExists(ShowErr: Boolean): Boolean
    var
        CommonIDErr: Text;
        PayslipLineQry: Query "Payroll-Payslip Line Query";
    begin
        "E/DFileRec".Get("E/D Code");
        if "E/DFileRec"."Common Id" <> '' then begin
          Clear(PayslipLineQry);
          PayslipLineQry.SetRange(Payroll_Period,"Payroll Period");
          PayslipLineQry.SetRange(Employee_No,"Employee No.");
          PayslipLineQry.SetFilter(E_D_Code,'<>%1',"E/D Code");
          PayslipLineQry.SetRange(Common_ID,"E/DFileRec"."Common Id");
          PayslipLineQry.SetFilter(Amount,'<>%1',0);
          if PayslipLineQry.Open then begin
            if PayslipLineQry.Read then begin
              CommonIDErr := StrSubstNo(Text000,PayslipLineQry.E_D_Code,"E/DFileRec"."E/D Code");
              Clear(PayslipLineQry);
              PayslipLineQry.Close;
              if ShowErr then
                Error(CommonIDErr)
              else
                exit(true);
            end else begin
              Clear(PayslipLineQry);
              PayslipLineQry.Close;
              exit(false);
            end
          end else
            exit(false);
        end else
          exit(false)
    end;


    procedure SetLastPeriod(var RefPeriod: Code[20])
    begin
        PayPeriodRec.Get(RefPeriod);
        RefDate := PayPeriodRec."End Date";
    end;


    procedure GetPayrollHeader()
    begin
        TestField("Payroll Period");
        TestField("Employee No.");
        PayrollHeader.Get("Payroll Period","Employee No.");
        if PayrollHeader."Currency Code" = '' then
          Currency.InitRoundingPrecision
        else begin
          PayrollHeader.TestField("Currency Factor");
          Currency.Get(PayrollHeader."Currency Code");
          Currency.TestField("Amount Rounding Precision");
        end;
    end;


    procedure CalcAmountLCY()
    begin
        GetPayrollHeader;
        if PayrollHeader."Currency Code" = '' then
          "Amount (LCY)" := Amount
        else begin
          "Amount (LCY)" := ROUND(
            CurrExchRate.ExchangeAmtFCYToLCY(
              PayrollHeader."Period Start",PayrollHeader."Currency Code",
                Amount,PayrollHeader."Currency Factor"));
        end;
    end;


    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",StrSubstNo('%1 %2 %3',"Payroll Period","Employee No.","E/D Code"));
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");
    end;


    procedure CreateDim(Type1: Integer;No1: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        TableID[1] := Type1;
        No[1] := No1;
        "Global Dimension 1 Code" := '';
        "Global Dimension 2 Code" := '';
        GetPayrollHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,'',
            "Global Dimension 1 Code","Global Dimension 2 Code",
            ProllHeader."Dimension Set ID",0);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Global Dimension 1 Code","Global Dimension 2 Code");
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array [8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;


    procedure CheckEmploymentPeriodStatus(EmployeeNo: Code[20];LeaveDate: Date)
    var
        Employee: Record Employee;
        nMonths: Decimal;
        EmploymentDateErr: label 'Fatal Error! Employment Date for Employee %1 is blank';
        LeaveEntitleErr: label 'Employee is  not entitled to leave allowance until after %1 months of your employment';
    begin
        Employee.Get(EmployeeNo);
        HRSetup.Get;
        if Employee."Employment Date" = 0D then
          Error(EmploymentDateErr,Employee."No.");
        nMonths := ROUND(((Date2dmy(LeaveDate,3) - Date2dmy(Employee."Employment Date",3)) * 365 +
                        (Date2dmy(LeaveDate,2) - Date2dmy(Employee."Employment Date",2))* 30.41 +
                        (Date2dmy(LeaveDate,1) - Date2dmy(Employee."Employment Date",1)))/30.41,0.00001);
        if nMonths < HRSetup."Req. Month for Leave Allow."  then
          Error(LeaveEntitleErr,HRSetup."Req. Month for Leave Allow.");
    end;

    local procedure GetLeaveAmount(PayslipLine: Record "Payroll-Payslip Line";lEDRec: Record "Payroll-E/D"): Decimal
    var
        FirstPayrollPeriod: Record "Payroll-Period";
        NextPayrollPeriod: Record "Payroll-Period";
        ClosedPayslip: Record "Closed Payroll-Payslip Line";
        PayrollSetup: Record "Payroll-Setup";
        CurrentAccruedLeaveAllow: Record "Payroll-Payslip Line";
        StartDate: Date;
        TotalLeaveAllowance: Decimal;
        NoMonths: Integer;
    begin
        HRSetup.Get;
        if HRSetup."Req. Month for Leave Allow." <> 0 then
          CheckEmploymentPeriodStatus("Employee No.",PayslipLine."Period Start");
        lEDRec.TestField("Accrual ED Code");
        StartDate := Dmy2date(1,1,Date2dmy(PayslipLine."Period Start",3));
        FirstPayrollPeriod.SetRange("Start Date",StartDate,PayslipLine."Period Start");
        NoMonths := FirstPayrollPeriod.Count;
        FirstPayrollPeriod.FindFirst;
        ClosedPayslip.SetCurrentkey("Payroll Period","Employee No.","E/D Code");
        ClosedPayslip.SetFilter("Payroll Period",'>=%1',FirstPayrollPeriod."Period Code");
        ClosedPayslip.SetRange("Employee No.",PayslipLine."Employee No.");
        ClosedPayslip.SetRange("E/D Code",lEDRec."Accrual ED Code");
        if ClosedPayslip.FindSet then begin
          repeat
            TotalLeaveAllowance += ClosedPayslip.Amount;
          until ClosedPayslip.Next = 0;
        end;
        CurrentAccruedLeaveAllow.Get(PayslipLine."Payroll Period",PayslipLine."Employee No.",lEDRec."Accrual ED Code");
        TotalLeaveAllowance += CurrentAccruedLeaveAllow.Amount;

        if NoMonths < 12 then
          TotalLeaveAllowance += CurrentAccruedLeaveAllow."Actual Prorated Amount" *(12 - NoMonths);
        exit(TotalLeaveAllowance);
    end;

    local procedure GetEDAmount(PayslipLine: Record "Payroll-Payslip Line";lEDRec: Record "Payroll-E/D"): Decimal
    var
        FirstPayrollPeriod: Record "Payroll-Period";
        NextPayrollPeriod: Record "Payroll-Period";
        ClosedPayslip: Record "Closed Payroll-Payslip Line";
        PayrollSetup: Record "Payroll-Setup";
        CurrentAccruedEDAmount: Record "Payroll-Payslip Line";
        StartDate: Date;
        TotalEDAmount: Decimal;
        NoMonths: Integer;
    begin
        lEDRec.TestField("Accrual ED Code");
        StartDate := Dmy2date(1,1,Date2dmy(PayslipLine."Period Start",3));
        FirstPayrollPeriod.SetRange("Start Date",StartDate,PayslipLine."Period Start");
        NoMonths := FirstPayrollPeriod.Count;
        FirstPayrollPeriod.FindFirst;
        ClosedPayslip.SetCurrentkey("Payroll Period","Employee No.","E/D Code");
        ClosedPayslip.SetFilter("Payroll Period",'>=%1',FirstPayrollPeriod."Period Code");
        ClosedPayslip.SetRange("Employee No.",PayslipLine."Employee No.");
        ClosedPayslip.SetRange("E/D Code",lEDRec."Accrual ED Code");
        if ClosedPayslip.FindSet then begin
          repeat
            TotalEDAmount += ClosedPayslip.Amount;
          until ClosedPayslip.Next = 0;
        end;
        CurrentAccruedEDAmount.Get(PayslipLine."Payroll Period",PayslipLine."Employee No.",lEDRec."Accrual ED Code");
        TotalEDAmount += CurrentAccruedEDAmount.Amount;

        if NoMonths = 12 then
          exit(TotalEDAmount);
    end;


    procedure SetNoOfDays(var lNoOfDays: Integer)
    begin
        NoOfDays := lNoOfDays;
    end;
}

