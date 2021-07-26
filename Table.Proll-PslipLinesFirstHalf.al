Table 52092175 "Proll-Pslip Lines First Half"
{
    Permissions = TableData "Payroll-Loan" = rimd,
                  TableData "Payroll-Loan Entry" = rimd;

    fields
    {
        field(1; "Payroll Period"; Code[10])
        {
            Editable = false;
            TableRelation = "Payroll-Period";
        }
        field(2; "Employee No."; Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "Payroll-Employee";
        }
        field(3; "E/D Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                /* If Period+Employee has already been closed then stop edit */
                /*IF CheckClosed  THEN
                  ERROR ('Entries for Employee %1 for period %2 '+
                         'have already been closed.', "Employee No.", "Payroll Period");*/

                "E/DFileRec".Get("E/D Code");
                ProllHeader.Get("Payroll Period", "Arrear Type", "Employee No.");
                if not ("E/DFileRec".CheckandAllow("Employee No.", ProllHeader."Employee Group")) then begin
                    if CurrFieldNo = FieldNo("E/D Code") then
                        Error(Text010);
                end;



                /* Transfer Units, Rate, Payslip Group ID. and Pos in Payslip Group */
                begin
                    "Statistics Group Code" := "E/DFileRec"."Statistics Group Code";
                    "Pos. In Payslip Grp." := "E/DFileRec"."Pos. In Payslip Grp.";
                    "Payslip appearance" := "E/DFileRec"."Payslip appearance";
                    Units := "E/DFileRec".Units;
                    Rate := "E/DFileRec".Rate;
                    "Overline Column" := "E/DFileRec"."Overline Column";
                    "Underline Amount" := "E/DFileRec"."Underline Amount";
                    "Payslip Text" := "E/DFileRec".Description;
                end;

                /* Calculate the amount if neither quantities nor yes flag are required*/
                if ((Units = '') or ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Table Look Up" <> '')))) and
                   not ("E/DFileRec"."Yes/No Req.") then begin
                    if "E/DFileRec"."Use as Default" = 1 then
                        Amount := "E/DFileRec"."Max. Amount";

                    Amount := CalcAmount("E/DFileRec", Rec, Amount, "E/D Code");

                    if ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Table Look Up" <> ''))) then
                        Validate(Rate, Amount);
                    if Rec.Amount <> xRec.Amount then begin
                        /* Change the entries that are computed using this new amount */
                        CalcCompute(Rec, Amount, true, "E/D Code");
                        /*BDC*/

                        /* If this new entry contributes to the value of another line
                          then compute that other line's value and insert it appropriately*/
                        CalcFactor1(Rec);

                        /* Go through all the lines and change where necessary */
                        ChangeAllOver(Rec, false);

                        /* Reset the ChangeOthers flag in all lines */
                        ResetChangeFlags(Rec);
                    end
                end;

                /* Transfer from Booking Group Lines */
                EmployeeRec.Get("Employee No.");
                if BookGrLinesRec.Get(EmployeeRec."Customer No.", "E/D Code") then begin
                    begin
                        "Debit Account" := BookGrLinesRec."Debit Account No.";
                        "Credit Account" := BookGrLinesRec."Credit Account No.";
                        "Debit Acc. Type" := BookGrLinesRec."Debit Acc. Type";
                        "Credit Acc. Type" := BookGrLinesRec."Credit Acc. Type";
                        "Global Dimension 1 Code" := BookGrLinesRec."Global Dimension 1 Code";
                        "Global Dimension 2 Code" := BookGrLinesRec."Global Dimension 2 Code";
                    end;

                    if BookGrLinesRec."Debit Acc. Type" = 1 then
                        if "Debit Account" = '' then
                            if EmployeeRec."Customer No." <> '' then
                                "Debit Account" := EmployeeRec."Customer No.";

                    if BookGrLinesRec."Credit Acc. Type" = 1 then
                        if "Credit Account" = '' then
                            if EmployeeRec."Customer No." <> '' then
                                "Credit Account" := EmployeeRec."Customer No.";

                    if BookGrLinesRec."Transfer Global Dim. 1 Code" then
                        "Global Dimension 1 Code" := EmployeeRec."Global Dimension 1 Code";
                    if BookGrLinesRec."Transfer Global Dim. 2 Code" then
                        "Global Dimension 2 Code" := EmployeeRec."Global Dimension 2 Code";
                end;

            end;
        }
        field(4; Units; Text[10])
        {
            Editable = false;
        }
        field(5; Rate; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                /* If Period+Employee has already been closed then stop edit */
                /*IF CheckClosed  THEN
                  ERROR ('Entries for Employee %1 for period %2 '+
                         'have already been closed.', "Employee No.", "Payroll Period");*/

                if (Units = '') then
                    /* User cannot edit the rate if the E/D code has no units*/
                  Rec.Rate := xRec.Rate
                else begin
                    Amount := Quantity * Rate;

                    /*Check for rounding, Maximum and minimum */
                    "E/DFileRec".Get("E/D Code");
                    Amount := ChkRoundMaxMin("E/DFileRec", Amount);

                end

            end;
        }
        field(6; Quantity; Decimal)
        {
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                /* If Period+Employee has already been closed then stop edit */
                /*IF CheckClosed  THEN
                  ERROR ('Entries for Employee %1 for period %2 '+
                         'have already been closed.', "Employee No.", "Payroll Period");*/

                if (Units = '') then
                    /* User cannot enter quantity if the E/D code has no units*/
                  Rec.Quantity := xRec.Quantity
                else begin
                    Amount := Quantity * Rate;

                    /*Check for rounding, Maximum and minimum */
                    "E/DFileRec".Get("E/D Code");
                    Amount := ChkRoundMaxMin("E/DFileRec", Amount);
                end

            end;
        }
        field(7; Flag; Boolean)
        {

            trigger OnValidate()
            begin
                /* If Period+Employee has already been closed then stop edit */
                /*IF CheckClosed  THEN
                  ERROR ('Entries for Employee %1 for period %2 '+
                         'have already been closed.', "Employee No.", "Payroll Period");*/

                "E/DFileRec".Get("E/D Code");
                if not ("E/DFileRec"."Yes/No Req.") then
                    Flag := false
                else begin
                    ProllHeader.Get("Payroll Period", "Arrear Type", "Employee No.");

                    if not ("E/DFileRec".CheckandAllow("Employee No.", ProllHeader."Employee Group")) then begin
                        if CurrFieldNo = FieldNo(Flag) then
                            Error(Text010);
                    end;

                    EmployeeRec.Get("Employee No.");
                    if ("E/DFileRec"."Marital Status" <> 0) then begin
                        if CurrFieldNo = FieldNo(Flag) then
                            EmployeeRec.TestField("Marital Status", "E/DFileRec"."Marital Status")
                        else
                            exit;
                    end;
                    Amount := CalcAmount("E/DFileRec", Rec, Amount, "E/D Code");
                end;
                if (Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Table Look Up" <> '')) then
                    Validate(Rate, Amount);

            end;
        }
        field(8; Amount; Decimal)
        {
            DecimalPlaces = 0 : 2;

            trigger OnValidate()
            begin
                /* If Period+Employee has already been closed then stop edit */
                /*IF CheckClosed  THEN
                  ERROR ('Entries for Employee %1 for period %2 '+
                         'have already been closed.', "Employee No.", "Payroll Period");*/

                "E/DFileRec".Get("E/D Code");
                if not ("E/DFileRec"."Edit Amount") then
                    Rec.Amount := xRec.Amount
                else
                    /*Check for rounding, Maximum and minimum */
                    if ("E/DFileRec"."Max. Amount" <> 0) or ("E/DFileRec"."Min. Amount" <> 0) then
                        if Confirm('Do you want to apply Maximum/Minimum check!', true) then
                            Amount := ChkRoundMaxMin("E/DFileRec", Amount);

            end;
        }
        field(9; "Debit Account"; Code[20])
        {
            TableRelation = if ("Debit Acc. Type" = const(Finance)) "G/L Account"
            else
            if ("Debit Acc. Type" = const(Customer)) Customer;

            trigger OnValidate()
            begin
                if "Debit Account" <> '' then
                    case "Debit Acc. Type" of
                        0:
                            FinanceAccRec.Get("Debit Account");
                        1:
                            CustomerAccRec.Get("Debit Account");
                        2:
                            SupplierAccRec.Get("Debit Account");
                    end;
            end;
        }
        field(10; "Credit Account"; Code[20])
        {
            TableRelation = if ("Credit Acc. Type" = const(Finance)) "G/L Account"
            else
            if ("Credit Acc. Type" = const(Customer)) Customer;

            trigger OnValidate()
            begin
                if "Credit Account" <> '' then
                    case "Credit Acc. Type" of
                        0:
                            FinanceAccRec.Get("Credit Account");
                        1:
                            CustomerAccRec.Get("Credit Account");
                        2:
                            SupplierAccRec.Get("Credit Account");
                    end;
            end;
        }
        field(11; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(12; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(13; AmountToBook; Decimal)
        {
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(14; "Statistics Group Code"; Code[10])
        {
            TableRelation = "Payroll Statistical Group";
        }
        field(15; "Pos. In Payslip Grp."; Integer)
        {
        }
        field(16; "Payslip appearance"; Option)
        {
            OptionMembers = "Non-zero & Code","Always & Code","Always & Text","Non-zero & Text","Does not appear",Heading;
        }
        field(17; "Debit Acc. Type"; Option)
        {
            OptionMembers = Finance,Customer,Supplier;
        }
        field(18; "Credit Acc. Type"; Option)
        {
            OptionMembers = Finance,Customer,Supplier;
        }
        field(19; ChangeOthers; Boolean)
        {
            Editable = false;
            InitValue = false;
        }
        field(20; HasBeenChanged; Boolean)
        {
            Editable = false;
            InitValue = false;
        }
        field(21; ChangeCounter; Integer)
        {
            Editable = false;
            InitValue = 0;
        }
        field(22; "Payslip Column"; Option)
        {
            InitValue = "2";
            OptionMembers = "1","2","3";
        }
        field(23; "S. Report appearance"; Option)
        {
            OptionMembers = "Non-zero & Code","Always & Code","Always & Text","Non-zero & Text","Does not appear",Heading;
        }
        field(24; "Overline Column"; Option)
        {
            InitValue = "None";
            OptionMembers = "None","1","2","3","1-2","2-3","1-3";
        }
        field(25; "Underline Amount"; Option)
        {
            InitValue = "None";
            OptionMembers = "None",Underline,"Double Underline";
        }
        field(26; "Loan ID"; Code[10])
        {
            TableRelation = "Payroll-Loan"."Loan ID";
        }
        field(27; "Payslip Text"; Text[30])
        {
            Editable = false;
        }
        field(28; "Staff Category"; Code[10])
        {
        }
        field(29; "Staff Posting Type"; Option)
        {
            OptionMembers = " ","Salary Adv.",Housing,"Non-Housing";
        }
        field(30; "User Id"; Code[20])
        {
            TableRelation = User;
        }
        field(32; "Period Start"; Date)
        {
            Editable = false;
        }
        field(33; "Period End"; Date)
        {
            Editable = false;
        }
        field(34; "Job No."; Code[20])
        {
            TableRelation = Job;
        }
        field(38; "Arrears Amount"; Decimal)
        {
            DecimalPlaces = 0 : 2;
        }
        field(50000; "Arrear Type"; Option)
        {
            OptionCaption = 'Salary,Promotion,Initial Entry';
            OptionMembers = Salary,Promotion,"Initial Entry";
        }
        field(50001; "Payment Period"; Code[10])
        {
            TableRelation = "Payroll-Period";
        }
    }

    keys
    {
        key(Key1; "Payroll Period", "Arrear Type", "Employee No.", "E/D Code")
        {
            Clustered = true;
            SumIndexFields = Amount, Quantity, "Arrears Amount";
        }
        key(Key2; "Payroll Period", "Global Dimension 1 Code", "Global Dimension 2 Code", "Job No.", "Debit Acc. Type", "Debit Account", "Credit Acc. Type", "Credit Account")
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
        key(Key3; "Payroll Period", "Employee No.", "Statistics Group Code", "Pos. In Payslip Grp.")
        {
            SumIndexFields = Amount, Quantity, "Arrears Amount";
        }
        key(Key4; "E/D Code", "Employee No.", "Payroll Period")
        {
        }
        key(Key5; "Employee No.", "Payroll Period")
        {
        }
        key(Key6; "Global Dimension 1 Code")
        {
        }
        key(Key7; "Payroll Period", "Global Dimension 1 Code", "Employee No.", "E/D Code")
        {
        }
        key(Key8; "Global Dimension 1 Code", "Staff Category")
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
        key(Key9; "Payroll Period", "E/D Code", "Debit Account", "Credit Account")
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
        key(Key10; "Payment Period")
        {
            SumIndexFields = Amount, "Arrears Amount";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*ProllHeader.GET( "Payroll Period", "Employee No.");
        IF ProllHeader."Closed?" THEN
          ERROR ('Entries for Employee %1/ in Period %2/ are closed. '+
                 'Nothing can be deleted', "Employee No.", "Payroll Period");*/

        /* Go through all the lines and make any appropriate Changes */
        ChangeOthers := false;
        ChangeDueToDelete(Rec);

        /* Set the 'Change' flags to false in all the lines */
        ResetChangeFlags(Rec);

    end;

    trigger OnInsert()
    begin
        "User Id" := UserId;
        "E/DFileRec".Get("E/D Code");
        UpdateArrears("E/DFileRec");
    end;

    trigger OnModify()
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ This trigger is called if any of the fields in "KI03b P.Roll Entry" is     ‚
        ‚ not equal to the corresponding field in "xKI03b P.Roll Entry"              ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/

        if (Rec.Amount <> xRec.Amount) then begin
            if Rec.Amount <> 0 then begin
                // check for common ids - E/Ds with same implications
                "E/DFileRec".Get("E/D Code");
                if "E/DFileRec"."Common Id" <> '' then begin
                    "E/DFileRec".SetRange("E/DFileRec"."Common Id", "E/DFileRec"."Common Id");
                    "E/DFileRec".Find('-');
                    repeat
                        if "E/DFileRec"."E/D Code" <> "E/D Code" then
                            if ProllEntryRec.Get("Payroll Period", "Arrear Type", "Employee No.", "E/DFileRec"."E/D Code") and
                              (ProllEntryRec.Amount <> 0) then
                                Error(Text000, "E/D Code", "E/DFileRec"."E/D Code");
                    until "E/DFileRec".Next = 0;
                end;
                //Check for marital status
                "E/DFileRec".Get("E/D Code");
                EmployeeRec.Get("Employee No.");
                if "E/DFileRec"."Marital Status" <> 0 then
                    EmployeeRec.TestField("Marital Status", "E/DFileRec"."Marital Status");

            end;

            //Update Arrears on Initial Pay
            "E/DFileRec".Get("E/D Code");
            UpdateArrears("E/DFileRec");


            Mark(true);
            /* If this new entry contributes in computing another, then compute that value
              for that computed entry and insert it appropriately*/
            CalcCompute(Rec, Rec.Amount, false, "E/D Code");
            /*BDC*/

            /* If this new entry is a contributory factor for the value of another line,
              then compute that other line's value and insert it appropriately */
            CalcFactor1(Rec);

            /* The two functions above have used this line to change others */
            ChangeOthers := false;

            /* Go through all the lines and change where necessary */
            ChangeAllOver(Rec, false);

            /* Reset the ChangeOthers flag in all lines */
            /*    ResetChangeFlags (Rec);*/

            /*BDC
              MARK( FALSE);*/
            "User Id" := UserId;
        end;

    end;

    var
        "E/DFileRec": Record "Payroll-E/D";
        ConstEDFileRec: Record "Payroll-E/D";
        ProllHeader: Record "Payslip Header First Half";
        ProllRecStore: Record "Proll-Pslip Lines First Half";
        ProllFactorRec: Record "Proll-Pslip Lines First Half";
        ProllEntryRec: Record "Proll-Pslip Lines First Half";
        ChangeOthersRec: Record "Proll-Pslip Lines First Half";
        PayslipLines: Record "Payroll-Payslip Line";
        EDFileRec2: Record "Payroll-E/D";
        FactorLookRec: Record "Payroll-Factor Lookup";
        LookHeaderRec: Record "Payroll-Lookup Header";
        LookLinesRec: Record "Payroll-Lookup Line";
        ProllPeriod: Record "Payroll-Period";
        NoOfMonthDays: Integer;
        BackOneRec: Integer;
        ReturnAmount: Decimal;
        PrevLookRec: Record "Payroll-Lookup Line";
        InputAmount: Decimal;
        ComputedTotal: Decimal;
        AmountToAdd: Decimal;
        FactorRecAmount: Decimal;
        AmtToAdd: Decimal;
        EmployeeRec: Record "Payroll-Employee";
        BookGrLinesRec: Record "Payroll-Posting Group Line";
        RoundPrec: Decimal;
        RoundDir: Text[1];
        IsComputed: Boolean;
        FinanceAccRec: Record "G/L Account";
        CustomerAccRec: Record Customer;
        SupplierAccRec: Record Vendor;
        PayrollSetUp: Record "Payroll-Setup";
        DimMgt: Codeunit 408;
        MaxChangeCount: Integer;
        Text000: label 'It is not possible to have %1 and %2 together!';
        Text001: label 'Maximum no. of entries already exceeded!\ %1 already taken in %2';
        Text002: label 'Loan Amount can not changed manually';
        Text003: label 'Entries for Employee %1/ in Period %2/ are closed\Nothing can be deleted';
        Text004: label 'E/D code %1 cannot be changed for %2!';
        Text005: label 'Entries for Employee %1 for period %2 have already been closed';
        Text006: label 'Do you want to apply Maximum/Minimum check!';
        Text007: label 'Factor Lookup Not Registered Yet';
        Text008: label 'The E/D Code %1,seems to have been defined with CYCLIC characteristics';
        Text009: label 'Do you want to delete %1';
        FactorOf: Boolean;
        PeriodTaken: Code[20];
        Text010: label 'This employee is not entitled to this E/D';
        RefDate: Date;
        Text011: label 'Fatal Error! Employment Date for Employee %1 is blank';


    procedure SpecialRelation("FieldNo.": Integer)
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Special Relations code for the field, E/D Code                             ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/

        /* Force NO-EDIT of field already has a value or if Employee payroll details
          for the period are already closed*/
        if "E/D Code" <> '' then
            exit;

        /* If Period+Employee has already been closed then stop edit */
        /*IF CheckClosed  THEN
          ERROR ('Entries for Employee %1 for period %2 '+
                 'have already been closed.', "Employee No.", "Payroll Period");*/

    end;


    procedure CalcAmount(EDFileRec: Record "Payroll-E/D"; var EntryLineRec: Record "Proll-Pslip Lines First Half"; EntryLineAmount: Decimal; EDCode: Code[20]): Decimal
    begin
        /*----------------------------------------------------------------------------+
        ¦ Calculate the amount based on Factor Of and Percentage fields in the file  ¦
        ¦ E/D file, alternatively calculate if the current line is computed by others¦
        ¦  Parameters:                                                               ¦
        ¦    EDFileRec    : EDFile Record for the E/D Code of the current entry line ¦
        ¦    EntryLineRec : The current entry line record                            ¦
        ¦    EntryLineAmount: The amount in the current entry line. Note this        ¦
        ¦    parameter is important if this trigger is called from the SAVE trigger  ¦
        +----------------------------------------------------------------------------*/

        /* If NO is in the flag field return amount to 0*/
        if (EDFileRec."Yes/No Req.") and not (EntryLineRec.Flag) then
            exit(0);

        // Check if e/d is loan
        if EDFileRec."Loan (Y/N)" then begin
            ReturnAmount := 0;
            ReturnAmount := ChkRoundMaxMin(EDFileRec, ReturnAmount);
            exit(ReturnAmount);
        end;


        //Check for Fixed Amounts
        EDFileRec.CalcFields("Value Exist");
        if EDFileRec."Value Exist" then begin
            ReturnAmount := EDFileRec.GetAmount(EntryLineRec."Payroll Period");
            exit(ReturnAmount);
        end;

        /* If Factor Of is Nil then do not change then check if amount is computed by
          others*/
        if EDFileRec."Factor Of" = '' then begin
            if EDFileRec."Factor Lookup" <> '' then begin
                if not FactorLookRec.Get(EDFileRec."Factor Lookup") then begin
                    Message(Text007);
                    exit(EntryLineRec.Amount);
                end
                else begin /* Factor lookup exists*/
                    ReturnAmount := (FactorLookRec.CalcAmount1(EntryLineRec, EDCode, "Payroll Period", "Employee No.", "Arrear Type")
                                  * EDFileRec.Percentage) / 100;
                    ReturnAmount := ChkRoundMaxMin(EDFileRec, ReturnAmount);
                    exit(ReturnAmount);
                end;
            end;
            if not AmountIsComputed(ReturnAmount, EntryLineRec, EDFileRec,
                                     EntryLineAmount, EDCode) then
                /*BDC*/
            exit(EntryLineRec.Amount)
            else begin
                /*Check for rounding, Maximum and minimum */
                ReturnAmount := ChkRoundMaxMin(EDFileRec, ReturnAmount);
                exit(ReturnAmount);
            end;
        end;
        /* Get the record from the current file based on Factor Of */
        if not ProllFactorRec.Get(EntryLineRec."Payroll Period", EntryLineRec."Arrear Type",
                         EntryLineRec."Employee No.", EDFileRec."Factor Of") then
            exit(EntryLineRec.Amount)
        else
            /* If this 'Factor of' entry record is marked then this trigger was called
              from this 'Fator of' record, therefore ensure the amount to be used is
              the updated amount*/
            /*BDC
            IF  ProllFactorRec.MARK THEN
            */
            if ProllFactorRec."E/D Code" = EDCode then
                ProllFactorRec.Amount := EntryLineAmount;

        /* Calculate the amount based on values in Table Look Up or Percentage fields
          of E/D file */
        if EDFileRec."Table Look Up" = '' then
            ReturnAmount := (ProllFactorRec.Amount * EDFileRec.Percentage) / 100
        else /* Extract relevant amount from Table Look Up */

            if not LookHeaderRec.Get(EDFileRec."Table Look Up") then begin
                Message(Text007);
                exit(EntryLineRec.Amount)
            end
            else begin /* Table lookup exists*/

                /* Filter Lookupline records to those of current Table Id Only*/
                LookLinesRec.TableId := EDFileRec."Table Look Up";
                LookLinesRec.SetRange(TableId, EDFileRec."Table Look Up");

                /* Depending on whether input parameter is code or numeric, set dbSETRANGE
                  appropraitely and initialise the record to use as a parameter to
                  dbFINDREC */
                case LookHeaderRec.Type of
                    0, 2:
                        begin
                            /* Lookup table is searched with numeric variables */
                            if ProllFactorRec.Amount > -1 then begin
                                LookLinesRec."Lower Code" := '';
                                InputAmount := ProllFactorRec.Amount * LookHeaderRec."Input Factor";
                                LookLinesRec."Lower Amount" := InputAmount;
                                LookLinesRec.SetRange("Lower Code", '');
                            end
                            else
                                exit(LookHeaderRec."Min. Extract Amount")
                        end;
                    else  /*Lookup table is searched with variables of type code*/
                      begin
                            LookLinesRec."Lower Amount" := 0;
                            LookLinesRec."Lower Code" := EDFileRec."E/D Code";
                            LookLinesRec.SetRange("Upper Amount", 0);
                            LookLinesRec.SetRange("Lower Amount", 0);
                        end
                end; /* Case*/

                case LookHeaderRec.Type of
                    0, 1:
                        begin
                            /* Extract amount as follows; First find line where Lower Amount or
                              lower code is just greater than the Factor Amount then move one
                              line back.*/

                            if LookLinesRec.Find('=') then
                                ReturnAmount := LookLinesRec."Extract Amount"
                            else
                                if LookLinesRec.Find('>') then begin
                                    BackOneRec := LookLinesRec.Next(-1);
                                    ReturnAmount := LookLinesRec."Extract Amount";
                                end
                                else
                                    if LookHeaderRec.Type = 0 then begin
                                        /*'Factor' Amount is > than the table's greatest "Lower amount"*/
                                        if LookLinesRec.Find('+') then
                                            ReturnAmount := LookLinesRec."Extract Amount";
                                    end
                                    else
                                        exit(EntryLineRec.Amount);
                        end;

                    2: /*  Extract amount from tax table*/
                        ReturnAmount := (CalcTaxAmt(LookLinesRec, InputAmount)) *
                                        LookHeaderRec."Output Factor";
                end; /* Case */

                /* Adjust the amount as per the maximum/minimum in the LookupHeader*/
                if (LookHeaderRec."Max. Extract Amount" <> 0) and
                   (ReturnAmount > LookHeaderRec."Max. Extract Amount") then
                    ReturnAmount := LookHeaderRec."Max. Extract Amount"
                else
                    if (ReturnAmount < LookHeaderRec."Min. Extract Amount") then
                        ReturnAmount := LookHeaderRec."Min. Extract Amount";

                /* Check for rounding */
                if LookHeaderRec."Rounding Precision" = 0 then
                    RoundPrec := 0.01
                else
                    RoundPrec := LookHeaderRec."Rounding Precision";
                case LookHeaderRec."Rounding Direction" of
                    1:
                        RoundDir := '>';
                    2:
                        RoundDir := '<';
                    else
                        RoundDir := '=';
                end;
                ReturnAmount := ROUND(ReturnAmount, RoundPrec, RoundDir);

                LookLinesRec.Reset
            end;

        /*Check for rounding, Maximum and minimum */
        // prorate no. of days worked
        if EDFileRec."No. of Days Prorate" and (ReturnAmount <> 0) then begin
            PayrollSetUp.Get;
            PayrollSetUp.TestField(PayrollSetUp."No. of Working Days");
            ProllHeader.Get("Payroll Period", "Arrear Type", "Employee No.");
            if ProllHeader."No. of Days Worked" <> 0 then
                if ProllHeader."No. of Working Days Basis" <> 0 then
                    ReturnAmount := ReturnAmount / ProllHeader."No. of Working Days Basis" * ProllHeader."No. of Days Worked"
                else
                    ReturnAmount := ReturnAmount / PayrollSetUp."No. of Working Days" * ProllHeader."No. of Days Worked";
        end;


        ReturnAmount := ChkRoundMaxMin(EDFileRec, ReturnAmount);

        exit(ReturnAmount);

    end;


    procedure CheckClosed(): Boolean
    begin
        /*----------------------------------------------------------------------------+
        ¦ Return the value of ProllHeader."Closed?" for this Period + Employee       ¦
        +----------------------------------------------------------------------------*/
        if ProllHeader.Get("Payroll Period", "Arrear Type", "Employee No.") then
            exit(ProllHeader."Closed?");

    end;


    procedure CalcTaxAmt(var LDetailsRec: Record "Payroll-Lookup Line"; TaxTableInput: Decimal): Decimal
    begin
        /*----------------------------------------------------------------------------+
        ¦ Returns the tax figure from a table lookup of type Tax                     ¦
        +----------------------------------------------------------------------------*/
        /* Parameters:
          by Referrence : The current Lookup detail table record = LDetailsRec.
                          NB: By referrence so that all delimitations, sortings etc
                              are still in effect.
          by value      : The amount to be taxed = TaxTableInput
        */

        /* Copy all current filters of LookUpRec */
        PrevLookRec := LDetailsRec;
        /* COPYFILTERS(LDetailsRec );          */
        /*BDC
        PrevLookRec.COPYFILTERS(LDetailsRec);
        */
        if LDetailsRec.Find('=') then
            /*Record found where Lower Amount is equal to TaxTableInput*/
          if PrevLookRec.Next(-1) = 0 then
                ReturnAmount := (TaxTableInput * LDetailsRec."Tax Rate %") / 100
            else
                /* Call function to get the tax amount from the graduated tax table.*/
            ReturnAmount := CalcGraduated(LDetailsRec, TaxTableInput)
        else
            if LDetailsRec.Find('>') then
                /*Record found where Lower Amount is just larger than TaxTableInput.
                 Therefore TaxableInput should be in previus range (= record)*/
          if LDetailsRec.Next(-1) = 0 then
                    /* The lowest taxable amount is larger than the input amount */
            ReturnAmount := 0
                else
                    ReturnAmount := CalcGraduated(LDetailsRec, TaxTableInput)
            else
                /*TaxableInput is larger than the table's greatest lower amount*/
                if LDetailsRec.Next(-1) = 0 then
                    ReturnAmount := (TaxTableInput * LDetailsRec."Tax Rate %") / 100
                else
                    /* Call function to get the tax amount from the graduated tax table.*/
            ReturnAmount := CalcGraduated(LDetailsRec, TaxTableInput);

        exit(ReturnAmount);

    end;


    procedure CalcGraduated(var WantedLookRec: Record "Payroll-Lookup Line"; InputToTable: Decimal): Decimal
    begin
        /*---------------------------------------------------------------------------+
        ¦ Returns the tax amount from the graduated tax table.                      ¦
        ¦ Parameters                                                                ¦
        ¦ by reference : The Table Lookup record within which the Taxable amount    ¦
        ¦                falls = WantedLookRec                                      ¦
        ¦                NB: By referrence so that all delimitations, sortings etc  ¦
        ¦                    are still in effect.                                   ¦
        ¦ by value     : The amount to be taxed = InputToTable                      ¦
        +---------------------------------------------------------------------------*/

        /* Create a copy of the valid Look Up table Record */
        PrevLookRec := WantedLookRec;
        /*BDC
        COPYFILTERS(WantedLookRec );
       */
        if PrevLookRec.Next(-1) = 0 then
            ReturnAmount := (InputToTable * WantedLookRec."Tax Rate %") / 100
        else begin
            /* Compute tax for the amount of money that is within the range of the
              Wanted Look Up Record then add the Cumulative Tax Payable amount from
              the previous Look Up record*/

            ReturnAmount := (InputToTable - PrevLookRec."Upper Amount");
            ReturnAmount := (ReturnAmount * WantedLookRec."Tax Rate %") / 100;
            ReturnAmount := ReturnAmount + PrevLookRec."Cum. Tax Payable";
        end;
        exit(ReturnAmount);

    end;


    procedure CalcCompute(EntryRecParam: Record "Proll-Pslip Lines First Half"; AmountInLine: Decimal; "CalledFromEdCode?": Boolean; EDCode: Code[20])
    begin
        /*---------------------------------------------------------------------------+
        ¦ Depending on the value of the Compute field for the E/D File record that  ¦
        ¦ corresponds to the current P.Roll Entry Line record                       ¦
        ¦ Parameters :                                                              ¦
        ¦   EntryRecParam           : Current entry line                            ¦
        ¦   Amount in current line  : The figure in the amount field in this line   ¦
        ¦   "CalledFromEdCode?"     : True if the trigger code was called from the  ¦
        ¦                            "E/D Code" field                               ¦
        +---------------------------------------------------------------------------*/

        ConstEDFileRec.Get(EntryRecParam."E/D Code");
        "E/DFileRec" := ConstEDFileRec;
        if "E/DFileRec".Compute = '' then
            exit;

        ProllEntryRec.Init;
        ProllEntryRec.SetRange("Payroll Period", EntryRecParam."Payroll Period");
        ProllEntryRec.SetRange("Arrear Type", EntryRecParam."Arrear Type");
        ProllEntryRec.SetRange("Employee No.", EntryRecParam."Employee No.");

        /* If the entry line to be computed does not exist then EXIT */
        ProllEntryRec := EntryRecParam;
        ProllEntryRec."E/D Code" := ConstEDFileRec.Compute;
        if not ProllEntryRec.Find('=') then
            exit;

        /* Initialise the variable to store the computed total. Note if the trigger
          code was called from the "E/D Code" field then that record is a new one.
          This implies that a search of the records in the file will not find this
          new record. Therefore for it's amount to be used in the computation
          we initialise the computed total to that amount*/
        if "CalledFromEdCode?" then begin
            if "E/DFileRec"."Add/Subtract" = 2 then
                /* Subtract */
            ComputedTotal := -AmountInLine
            else
                /* Add */
            ComputedTotal := AmountInLine
        end
        else
            ComputedTotal := 0;

        /*Get first record in P.Roll Entry file for this Period/Employee combination*/
        ProllEntryRec := EntryRecParam;
        ProllEntryRec."E/D Code" := '';
        ProllEntryRec.Find('>');

        /* Go through all the entry lines for this Period/Employee record and sum up
          all those that contribute to the E/D specified in the Compute field for
          the current entry line */
        repeat
        begin
            /*BDC
              IF  ProllEntryRec.MARK THEN
              */
            if EDCode = ProllEntryRec."E/D Code" then
                /* We are at the record where the function was called from */
            AmountToAdd := AmountInLine
            else
                AmountToAdd := ProllEntryRec.Amount;

            "E/DFileRec".Get(ProllEntryRec."E/D Code");
            if "E/DFileRec".Compute = ConstEDFileRec.Compute then
                if "E/DFileRec"."Add/Subtract" = 2 then
                    /* Subtract */
              ComputedTotal := ComputedTotal - AmountToAdd
                else
                    /* Add */
              ComputedTotal := ComputedTotal + AmountToAdd;
        end
        until (ProllEntryRec.Next(1) = 0);

        /* Move the computed amount to the line whose E/D Code is the one that has
          just been calculated.*/
        ProllEntryRec.Init;
        ProllEntryRec."E/D Code" := ConstEDFileRec.Compute;
        "E/DFileRec".Get(ConstEDFileRec.Compute);
        /*FTN No Need
        dbTRANSFERFIELDS ("E/DFileRec", ProllEntryRec);
        */

        /*Check for rounding, Maximum and minimum */
        ComputedTotal := ChkRoundMaxMin("E/DFileRec", ComputedTotal);

        /*ProllEntryRec.Amount := ComputedTotal;
        ProllRecStore := ProllEntryRec;*/
        //ProllEntryRec.LOCKTABLE(FALSE,TRUE);
        if ProllEntryRec.Find('=') then begin
            /*ProllRecStore.ChangeOthers := TRUE;
            ProllRecStore.HasBeenChanged := TRUE;
            dbMODIFYREC (ProllRecStore);*/
            ProllEntryRec.Amount := ComputedTotal;

            // inserted by Ade Aluko
            if (ProllEntryRec.Units <> '') /*AND (ProllEntryRec.Rate <> ProllEntryRec.Amount)*/ then begin
                ProllEntryRec.Validate(ProllEntryRec.Rate, ProllEntryRec.Amount);
                ProllEntryRec.Modify;
            end;

            ProllEntryRec.ChangeOthers := true;
            ProllEntryRec.HasBeenChanged := true;
            ProllEntryRec.Modify;
        end;
        Commit;

        ProllEntryRec.SetRange("Payroll Period");
        ProllEntryRec.SetRange("Arrear Type");
        ProllEntryRec.SetRange("Employee No.");

    end;


    procedure CalcFactor1(CurrentEntryLine: Record "Proll-Pslip Lines First Half")
    begin
        /*----------------------------------------------------------------------------+
        ¦ If an entry is a contributory factor for the value of another line, then   ¦
        ¦ compute that other line's value and insert it appropriately                ¦
        ¦ Parameters :                                                               ¦
        ¦   CurrentEntryLine        : Current entry line                             ¦
        +----------------------------------------------------------------------------*/

        /* Get first record in Entry Lines file for this Employee/Period */
        ProllEntryRec := CurrentEntryLine;
        ProllEntryRec.Init;
        ProllEntryRec.SetRange("Employee No.", ProllEntryRec."Employee No.");
        ProllEntryRec.SetRange("Arrear Type", ProllEntryRec."Arrear Type");
        ProllEntryRec.SetRange("Payroll Period", ProllEntryRec."Payroll Period");
        ProllEntryRec."E/D Code" := '';
        if ProllEntryRec.Find('>') then begin

            /* Go through all the entry lines for this Period/Employee record and where
              the current entry line's value is a factor, calculate that amount. */
            repeat

                "E/DFileRec".Get(ProllEntryRec."E/D Code");
                FactorOf := false;
                // check if special factor is used
                if "E/DFileRec"."Factor Lookup" <> '' then begin
                    FactorLookRec.Get("E/DFileRec"."Factor Lookup");
                    FactorOf := FactorLookRec.CheckForFactor(CurrentEntryLine."E/D Code");
                end;

                if ("E/DFileRec"."Factor Of" = CurrentEntryLine."E/D Code") or
                   (FactorOf and ("E/DFileRec"."E/D Code" <> CurrentEntryLine."E/D Code")) then begin

                    FactorRecAmount := ProllEntryRec.Amount;
                    ProllEntryRec.Amount := "CalcFactor1.1"(CurrentEntryLine,
                                                               ProllEntryRec, "E/DFileRec");
                    /*The new entry in this line should now be used to Compute another and
                    also entries where it is a Factor, therefore set ChangeOthers to True*/

                    // prorate no. of days worked
                    if "E/DFileRec"."No. of Days Prorate" and (ProllEntryRec.Amount <> 0) then begin
                        ProllHeader.Get("Payroll Period", "Arrear Type", "Employee No.");
                        NoOfMonthDays := Date2dmy(CalcDate('CM', ProllHeader."Period Start"), 1);
                        if ProllHeader."No. of Days Worked" <> 0 then
                            ProllEntryRec.Amount := ProllEntryRec.Amount / NoOfMonthDays * ProllHeader."No. of Days Worked";
                    end;

                    // inserted by Ade Aluko @GEMS 21/11/00 to compute rate
                    if (ProllEntryRec.Units <> '') /*AND (ProllEntryRec.Rate <> ProllEntryRec.Amount)*/ then begin
                        ProllEntryRec.Validate(ProllEntryRec.Rate, ProllEntryRec.Amount);
                        ProllEntryRec.Modify;
                    end;

                    if FactorRecAmount <> ProllEntryRec.Amount then begin
                        ProllEntryRec.ChangeOthers := true;
                        ProllEntryRec.Modify;
                    end
                end;

            until (ProllEntryRec.Next(1) = 0);
        end;
        Commit;

    end;


    procedure "CalcFactor1.1"(CurrLineRec: Record "Proll-Pslip Lines First Half"; LineToChangeRec: Record "Proll-Pslip Lines First Half"; EDFileRec: Record "Payroll-E/D"): Decimal
    begin
        /*----------------------------------------------------------------------------+
        ¦ Calculate the amount based on Factor Of and Percentage fields of the file  ¦
        ¦ E/D file,                                                                  ¦
        ¦  Parameters:                                                               ¦
        ¦    CurrLineRec    : The current entry line record                          ¦
        ¦    LineToChangeRec: The entry line to be changed.                          ¦
        ¦    EDFileRec      : EDFile Record for the E/D Code of LineToChangeRec      ¦
        +----------------------------------------------------------------------------*/

        /* If NO is in the flag field return amount to 0 */
        if (EDFileRec."Yes/No Req.") and not (LineToChangeRec.Flag) then
            exit(0);

        /* Calculate the amount based on values in Table Look Up or Percentage fields
          of E/D file */
        if EDFileRec."Factor Lookup" <> '' then
            ReturnAmount := (FactorLookRec.CalcAmount1(CurrLineRec, LineToChangeRec."E/D Code", LineToChangeRec."Payroll Period",
                             LineToChangeRec."Employee No.", LineToChangeRec."Arrear Type") * EDFileRec.Percentage) / 100
        else
            if EDFileRec."Table Look Up" = '' then
                ReturnAmount := (CurrLineRec.Amount * EDFileRec.Percentage) / 100
            else /* Extract relevant amount from Table Look Up */

                if not LookHeaderRec.Get(EDFileRec."Table Look Up") then begin
                    Message(Text007);
                    exit(LineToChangeRec.Amount)
                end
                else begin /* Table lookup exists*/

                    /* Filter Lookupline records to those of current Table Id Only*/
                    LookLinesRec.TableId := EDFileRec."Table Look Up";
                    LookLinesRec.SetRange(TableId, EDFileRec."Table Look Up");

                    /* Depending on whether input parameter is code or numeric, set dbSETRANGE
                      appropraitely and initialise the record to use as a parameter to
                      dbFINDREC */
                    case LookHeaderRec.Type of
                        0, 2:
                            begin
                                /* Lookup table is searched with numeric variables */
                                if CurrLineRec.Amount > -1 then begin
                                    LookLinesRec."Lower Code" := '';
                                    LookLinesRec."Lower Amount" := CurrLineRec.Amount *
                                                                   LookHeaderRec."Input Factor";
                                    LookLinesRec.SetRange("Lower Code", '');
                                end
                                else
                                    exit(LookHeaderRec."Min. Extract Amount")
                            end;
                        else  /*Lookup table is searched with variables of type code*/
                          begin
                                LookLinesRec."Lower Amount" := 0;
                                LookLinesRec."Lower Code" := CurrLineRec."E/D Code";
                                LookLinesRec.SetRange("Upper Amount", 0);
                                LookLinesRec.SetRange("Lower Amount", 0);
                            end
                    end; /* Case*/

                    case LookHeaderRec.Type of
                        0, 1:
                            begin
                                /* Extract amount as follows; First find line where Lower Amount or
                                  Lower Code is just greater than the CurrLineRec then move one line
                                  back.*/

                                if LookLinesRec.Find('=') then
                                    ReturnAmount := LookLinesRec."Extract Amount"
                                else
                                    if LookLinesRec.Find('>') then begin
                                        BackOneRec := LookLinesRec.Next(-1);
                                        ReturnAmount := LookLinesRec."Extract Amount";
                                    end
                                    else
                                        if LookHeaderRec.Type = 0 then begin
                                            /*CurrLineRec.Amount is > than the table's greatest "Lower amount"*/
                                            if LookLinesRec.Find('+') then
                                                ReturnAmount := LookLinesRec."Extract Amount"
                                            else
                                                exit(LineToChangeRec.Amount)
                                        end
                                        else
                                            /*CurrLineRec.EDCode is > than the table's greatest "Lower code"*/
                  exit(LineToChangeRec.Amount);
                            end;

                        2: /*  Extract amount from tax table*/
                            ReturnAmount := (CalcTaxAmt(LookLinesRec, CurrLineRec.Amount *
                                                         LookHeaderRec."Input Factor")) *
                                            LookHeaderRec."Output Factor";
                    end; /* Case */

                    /* Adjust the amount as per the maximum/minimum in the LookupHeader*/
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

                    /* Check for rounding */
                    if LookHeaderRec."Rounding Precision" = 0 then
                        RoundPrec := 0.01
                    else
                        RoundPrec := LookHeaderRec."Rounding Precision";
                    case LookHeaderRec."Rounding Direction" of
                        1:
                            RoundDir := '>';
                        2:
                            RoundDir := '<';
                        else
                            RoundDir := '=';
                    end;
                    ReturnAmount := ROUND(ReturnAmount, RoundPrec, RoundDir);

                    LookLinesRec.Reset
                end;


        /* Adjust amount as per maximum/minimum set in the E/D file. This will overide
          any max/min. values set in the Table Lookup Header file*/
        ReturnAmount := ChkRoundMaxMin(EDFileRec, ReturnAmount);

        exit(ReturnAmount);

    end;


    procedure ChangeAllOver(CurrentRec: Record "Proll-Pslip Lines First Half"; CurrWasDeleted: Boolean)
    begin
        /*---------------------------------------------------------------------------+
        ¦ Go through all the lines and where a line is supposed to Change others    ¦
        ¦ then change those others.                                                 ¦
        ¦ Parameters :                                                              ¦
        ¦   CurrentRec      : Current Entry line                                    ¦
        ¦   CurrWasDeleted  : True if the current record was deleted                ¦
        +---------------------------------------------------------------------------*/

        ChangeOthersRec := CurrentRec;
        ChangeOthersRec.SetRange("Payroll Period", CurrentRec."Payroll Period");
        ChangeOthersRec.SetRange("Arrear Type", CurrentRec."Arrear Type");
        ChangeOthersRec.SetRange("Employee No.", CurrentRec."Employee No.");
        ChangeOthersRec.SetRange(ChangeOthers, true);

        ChangeOthersRec."E/D Code" := '';
        if not ChangeOthersRec.Find('>') then
            exit;

        /*Set the maximum number of times the Amount can be changed for any one line.
         This will be used to ensure that this function does not execute 'forever',
         when the user has defined 'cyclic' E/Ds*/
        MaxChangeCount := 50;

        repeat

            /* Process the record to change others only if it isn't the deleted one */
            if not (CurrWasDeleted and (ChangeOthersRec."E/D Code" =
                                        CurrentRec."E/D Code"))
            then begin
                ComputeAgain(ChangeOthersRec, CurrentRec, CurrWasDeleted);
                CalcFactorAgain(ChangeOthersRec, CurrentRec, CurrWasDeleted);
            end;
            ChangeOthersRec.ChangeOthers := false;
            ChangeOthersRec.ChangeCounter := ChangeOthersRec.ChangeCounter + 1;
            ChangeOthersRec.Modify;
            ProllRecStore := ChangeOthersRec;
            ChangeOthersRec."E/D Code" := '';
        until ((ProllRecStore.ChangeCounter > MaxChangeCount) or
               (ChangeOthersRec.Next(1) = 0));
        Commit;
        ChangeOthersRec.SetRange("Payroll Period");
        ChangeOthersRec.SetRange("Arrear Type");
        ChangeOthersRec.SetRange("Employee No.");
        ChangeOthersRec.SetRange(ChangeOthers);

        if (ProllRecStore.ChangeCounter > MaxChangeCount) then
            Message(Text008, ProllRecStore."E/D Code");

        exit;

    end;


    procedure ComputeAgain(ParamLine: Record "Proll-Pslip Lines First Half"; CurrentRec: Record "Proll-Pslip Lines First Half"; CurrWasDeleted: Boolean)
    begin
        /*---------------------------------------------------------------------------+
        ¦ Compute values for the E/D specified in the Compute field for the         ¦
        ¦  Entry Line record passed as a parameter                                  ¦
        ¦ Parameters :                                                              ¦
        ¦   ParamLine       : Entry line passed as a parameter                      ¦
        ¦   CurrentRec      : Current Entry line                                    ¦
        ¦   CurrWasDeleted  : True if the current record was deleted                ¦
        +---------------------------------------------------------------------------*/

        ConstEDFileRec.Get(ParamLine."E/D Code");
        "E/DFileRec" := ConstEDFileRec;
        if "E/DFileRec".Compute = '' then
            exit;

        ProllEntryRec.Reset;
        ProllEntryRec.Init;
        ProllEntryRec.SetRange("Payroll Period", CurrentRec."Payroll Period");
        ProllEntryRec.SetRange("Arrear Type", CurrentRec."Arrear Type");
        ProllEntryRec.SetRange("Employee No.", CurrentRec."Employee No.");

        /* If the entry line to be computed does not exist then EXIT */
        ProllEntryRec := ParamLine;
        ProllEntryRec."E/D Code" := ConstEDFileRec.Compute;
        if not ProllEntryRec.Find('=') then
            exit;

        /* If CurrentRec is to be deleted, then no need to re-compute it */
        if (CurrWasDeleted and (ProllEntryRec."E/D Code" = CurrentRec."E/D Code"))
        then
            exit;

        /*
          Initialise the variable to store the computed total. If a record was
          deleted then initialise to 0. Otherwise if the current line (i.e that
          entered by the user) also contributes to the computed line then we
          initialise the computed total to that amount
        */
        "E/DFileRec".Get(CurrentRec."E/D Code");
        if CurrWasDeleted then
            ComputedTotal := 0
        else
            if "E/DFileRec".Compute = ConstEDFileRec.Compute then begin
                if "E/DFileRec"."Add/Subtract" = 2 then
                    /* Subtract */
            ComputedTotal := -CurrentRec.Amount
                else
                    /* Add */
            ComputedTotal := CurrentRec.Amount;
            end
            else
                ComputedTotal := 0;

        /*Get first record in P.Roll Entry file for this Employee group*/
        ProllEntryRec := ParamLine;
        ProllEntryRec."E/D Code" := '';
        ProllEntryRec.Find('>');

        /* Go through all the entry lines for this Employee group and sum up
          all those that contribute to the E/D specified in the Compute field for
          the current entry line */
        repeat

            if ProllEntryRec."E/D Code" <> CurrentRec."E/D Code" then begin

                "E/DFileRec".Get(ProllEntryRec."E/D Code");
                if "E/DFileRec".Compute = ConstEDFileRec.Compute then
                    if "E/DFileRec"."Add/Subtract" = 2 then
                        /* Subtract */
                ComputedTotal := ComputedTotal - ProllEntryRec.Amount
                    else
                        /* Add */
                ComputedTotal := ComputedTotal + ProllEntryRec.Amount

            end
        until (ProllEntryRec.Next(1) = 0);

        /* Move the computed amount to the line whose E/D Code is the one that has
          just been calculated.*/
        ProllEntryRec.Init;
        ProllEntryRec."E/D Code" := ConstEDFileRec.Compute;
        "E/DFileRec".Get(ConstEDFileRec.Compute);
        /*dbTRANSFERFIELDS ("E/DFileRec", ProllEntryRec);*/

        /*Check for rounding, Maximum and minimum */
        ComputedTotal := ChkRoundMaxMin("E/DFileRec", ComputedTotal);

        /*ProllEntryRec.Amount := ComputedTotal;
        ProllRecStore := ProllEntryRec;*/

        //ProllEntryRec.LOCKTABLE(FALSE,TRUE);
        if ProllEntryRec.Find('=') then begin
            /*FactorRecAmount := ProllEntryRec.Amount;*/
            /*ProllEntryRec := ProllRecStore;*/

            /*The new entry in this line should now be used to Compute another and
             also entries where it is a Factor, therefore set ChangeOthers to True*/
            if ProllEntryRec.Amount <> ComputedTotal then begin
                ProllEntryRec.Amount := ComputedTotal;
                ProllEntryRec.ChangeOthers := true;
                ProllEntryRec.Modify
            end
        end;
        Commit;

        ProllEntryRec.Reset;

    end;


    procedure CalcFactorAgain(ParamLine: Record "Proll-Pslip Lines First Half"; CurrentRec: Record "Proll-Pslip Lines First Half"; CurrWasDeleted: Boolean)
    begin
        /*----------------------------------------------------------------------------+
        ¦ If a change in a line due to the entry or change to another entry is a     ¦
        ¦ contributory factor for the value of another line, then  compute that      ¦
        ¦other line's value and insert it appropriately                              ¦
        ¦ Parameters :                                                               ¦
        ¦   ParamLine         : Line whose value should change others                ¦
        ¦   CurrentRec        : Current Entry line                                   ¦
        ¦   CurrWasDeleted    : True if CurrentRec is to be deleted                  ¦
        +----------------------------------------------------------------------------*/

        /*Get first record in Employee Group Lines file for this Employee group*/
        ProllEntryRec.Reset;
        ProllEntryRec.Init;
        ProllEntryRec.SetRange("Payroll Period", ParamLine."Payroll Period");
        ProllEntryRec.SetRange("Arrear Type", ParamLine."Arrear Type");
        ProllEntryRec.SetRange("Employee No.", ParamLine."Employee No.");
        ProllEntryRec := ParamLine;
        ProllEntryRec."E/D Code" := '';
        if not ProllEntryRec.Find('>') then
            exit;

        /* Go through all the entry lines for this Employee Group record and where
          the current entry line's value is a factor, calculate that amount. */
        repeat

            "E/DFileRec".Get(ProllEntryRec."E/D Code");

            FactorOf := false;
            // check if special factor is used
            if "E/DFileRec"."Factor Lookup" <> '' then begin
                FactorLookRec.Get("E/DFileRec"."Factor Lookup");
                FactorOf := FactorLookRec.CheckForFactor(ParamLine."E/D Code");
            end;

            if ("E/DFileRec"."Factor Of" = ParamLine."E/D Code") or
               (FactorOf and ("E/DFileRec"."E/D Code" <> ParamLine."E/D Code")) then begin

                FactorRecAmount := ProllEntryRec.Amount;
                if (CurrWasDeleted and (ParamLine."E/D Code" = CurrentRec."E/D Code"))
                then
                    ProllEntryRec.Amount := 0
                else
                    ProllEntryRec.Amount := "CalcFactor1.1"(ParamLine, ProllEntryRec,
                                                             "E/DFileRec");

                // prorate no. of days worked
                if "E/DFileRec"."No. of Days Prorate" and (ProllEntryRec.Amount <> 0) then begin
                    ProllHeader.Get("Payroll Period", "Arrear Type", "Employee No.");
                    NoOfMonthDays := Date2dmy(CalcDate('CM', ProllHeader."Period Start"), 1);
                    if ProllHeader."No. of Days Worked" <> 0 then
                        ProllEntryRec.Amount := ProllEntryRec.Amount / NoOfMonthDays * ProllHeader."No. of Days Worked";
                end;

                // inserted by Ade Aluko @GEMS 21/11/00 to compute rate
                if (ProllEntryRec.Units <> '') /*AND (ProllEntryRec.Rate <> ProllEntryRec.Amount)*/ then begin
                    ProllEntryRec.Validate(ProllEntryRec.Rate, ProllEntryRec.Amount);
                    ProllEntryRec.Modify;
                end;

                /*The new entry in this line should now be used to Compute another and
                 also entries where it is a Factor, therefore set ChangeOthers to True*/
                if FactorRecAmount <> ProllEntryRec.Amount then begin
                    ProllEntryRec.ChangeOthers := true;
                    ProllEntryRec.Modify
                end
            end;

        until (ProllEntryRec.Next(1) = 0);
        Commit;

        ProllEntryRec.Reset;

    end;


    procedure ResetChangeFlags(CurrentRec: Record "Proll-Pslip Lines First Half")
    begin
        /*----------------------------------------------------------------------------+
        ¦ Reset ChangeOthers to false for all lines in this Period/Employee          ¦
        ¦ Parameters :                                                               ¦
        ¦   CurrentRec  : Current entry line                                         ¦
        +----------------------------------------------------------------------------*/
        /*Get first record in Employee Group Lines file for this Employee group*/
        ProllEntryRec := CurrentRec;
        ProllEntryRec.Init;
        ProllEntryRec.SetRange("Payroll Period", CurrentRec."Payroll Period");
        ProllEntryRec.SetRange("Arrear Type", CurrentRec."Arrear Type");
        ProllEntryRec.SetRange("Employee No.", CurrentRec."Employee No.");
        ProllEntryRec."E/D Code" := '';
        if ProllEntryRec.Find('>') then begin  //Added by Adebola

            /* Reset ChangeOthers for this Employee Group */
            repeat

                ProllEntryRec.ChangeOthers := false;
                ProllEntryRec.ChangeCounter := 0;
                /*BDC - Do not modify the one to be deleted*/
                if ProllEntryRec."E/D Code" <> CurrentRec."E/D Code" then
                    ProllEntryRec.Modify;

            until (ProllEntryRec.Next(1) = 0);
        end;
        Commit;

        ProllEntryRec.Reset;

    end;


    procedure AmountIsComputed(var ReturnAmount: Decimal; EntryLineRec: Record "Proll-Pslip Lines First Half"; EDFileRec: Record "Payroll-E/D"; NewAmount: Decimal; EDCode: Code[20]): Boolean
    begin
        /*---------------------------------------------------------------------------+
        ¦ Check for values that should COMPUTE the amount for the P.Roll Entry      ¦
        ¦ Line record.                                                              ¦
        ¦ Return:                                                                   ¦
        ¦   If there are entries for the employee/period that compute the value     ¦
        ¦   then return TRUE else return FALSE                                      ¦
        ¦ Parameters :                                                              ¦
        ¦   ReturnAmount:  The computed amount, by refference                       ¦
        ¦   EntryLineRec:  The P.Roll Entry record whose value is to be computed    ¦
        ¦   EDFileRec   :  The E/D file record of the E/D of the P.Roll Entry Record¦
        ¦   NewAmount   :  The new calculated or entered amount in the current rec. ¦
        +---------------------------------------------------------------------------*/

        ProllRecStore := EntryLineRec;

        /*Get first record in P.Roll Entry file for this Period/Employee combination*/
        ProllRecStore.SetRange("Payroll Period", EntryLineRec."Payroll Period");
        ProllRecStore.SetRange("Arrear Type", EntryLineRec."Arrear Type");
        ProllRecStore.SetRange("Employee No.", EntryLineRec."Employee No.");
        ProllRecStore."E/D Code" := '';
        if not ProllRecStore.Find('>') then
            exit(false);

        /* Initialise the variable to store the computed total. */
        ReturnAmount := 0;
        IsComputed := false;

        /* Go through all the entry lines for this Period/Employee record and sum up
          all those that contribute to the E/D of the given payroll entry line */
        repeat
            "E/DFileRec".Get(ProllRecStore."E/D Code");
            if "E/DFileRec".Compute = EntryLineRec."E/D Code" then begin
                /*BDC
                    IF  ProllRecStore.MARK THEN
                  */
                if ProllRecStore."E/D Code" = EDCode then
                    AmtToAdd := NewAmount
                else
                    AmtToAdd := ProllRecStore.Amount;

                if "E/DFileRec"."Add/Subtract" = 2 then
                    /* Subtract */
              ReturnAmount := ReturnAmount - AmtToAdd
                else
                    /* Add */
              ReturnAmount := ReturnAmount + AmtToAdd;

                IsComputed := true
            end
        until (ProllRecStore.Next(1) = 0);

        exit(IsComputed);

    end;


    procedure ChangeDueToDelete(DeletedRec: Record "Proll-Pslip Lines First Half")
    begin
        /*---------------------------------------------------------------------------+
        ¦ Due to the deleted record, ensure all the other lines are correct.        ¦
        ¦ Parameters :                                                              ¦
        ¦   DeletedRec : The current record (= the record to be deleted)            ¦
        ¦                                                                           ¦
        +---------------------------------------------------------------------------*/
        /*Get first record in Employee Group Lines file for this Employee group*/
        ProllEntryRec := DeletedRec;
        ProllEntryRec.SetRange("Payroll Period", DeletedRec."Payroll Period");
        ProllEntryRec.SetRange("Arrear Type", DeletedRec."Arrear Type");
        ProllEntryRec.SetRange("Employee No.", DeletedRec."Employee No.");

        /* If the deleted record was 'COMPUTING' another then make changes */
        if not "E/DFileRec".Get(DeletedRec."E/D Code") then
            exit;
        ProllEntryRec."E/D Code" := "E/DFileRec".Compute;
        if ProllEntryRec.Find('=') then
            ComputeAgain(DeletedRec, DeletedRec, true);

        /* If another record is a 'FACTOR OF' the deleted one then make changes */
        CalcFactorAgain(DeletedRec, DeletedRec, true);

        /* Due to these changes adjust AMOUNTS in all lines */
        ChangeAllOver(DeletedRec, true);
        exit;

    end;


    procedure ChkRoundMaxMin(EDRecord: Record "Payroll-E/D"; TheAmount: Decimal): Decimal
    begin
        /*---------------------------------------------------------------------------+
        ¦ Round an amount and check for Max and Min. Return the amended amount.     ¦
        ¦ Parameters :                                                              ¦
        ¦   EDRecord : The ED file record to use to check Round, Max. and Min       ¦
        ¦   TheAmount: The amounht to Round, and check for Max. and Min             ¦
        +---------------------------------------------------------------------------*/

        /* Adjust amount as per maximum/minimum set in the E/D file. */
        if (EDRecord."Max. Amount" <> 0) and
           (TheAmount > EDRecord."Max. Amount") then
            TheAmount := EDRecord."Max. Amount"
        else
            if (EDRecord."Min. Amount" <> 0) and
               (TheAmount < EDRecord."Min. Amount") then
                TheAmount := EDRecord."Min. Amount";

        /* Check for rounding */
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


    procedure CalcLoanAmount(EDFileRec: Record "Payroll-E/D"; var CurrEntryLineRec: Record "Proll-Pslip Lines First Half"): Decimal
    var
        LoanRec: Record "Payroll-Loan";
        RepaymentAmt: Decimal;
        IntRepaymentAmt: Decimal;
        TotalRepaymentAmt: Decimal;
        RemainingAmt: Decimal;
        IncludeLoan: Boolean;
        NextLoanEntryNo: Integer;
    begin
        /*CurrEntryLineRec.Amount := 0;
        
        LoanRec.SETRANGE(LoanRec."Employee No.",CurrEntryLineRec."Employee No.");
        LoanRec.SETRANGE(LoanRec."Loan E/D",EDFileRec."E/D Code");
        LoanRec.SETRANGE(LoanRec."Open(Y/N)",TRUE);
        IF NOT LoanRec.FIND('-') THEN
          EXIT (0);
        
        ProllPeriod.GET(CurrEntryLineRec."Payroll Period");
        TotalRepaymentAmt := 0;
        REPEAT
          IncludeLoan := TRUE;
          IF LoanRec."Deduction Starting Date" = 0D THEN
            IncludeLoan := FALSE;
          IF LoanRec."Suspended(Y/N)" THEN
            IF (LoanRec."Suspension Ending Date" > ProllPeriod."End Date") OR ((LoanRec."Deduction Starting Date" <> 0D) AND
            (LoanRec."Deduction Starting Date" > ProllPeriod."End Date"))
              THEN
                IncludeLoan := FALSE;
        
          IF ((LoanRec."Deduction Starting Date" <> 0D) AND (LoanRec."Deduction Starting Date" > ProllPeriod."End Date")) THEN
            IncludeLoan := FALSE;
        
          IF IncludeLoan THEN BEGIN
            LoanRec.CALCFIELDS("Remaining Amount","Interest Remaining Amount");
            LoanRec.SETRANGE("Date Filter",ProllPeriod."End Date");
            LoanRec.CALCFIELDS("Repaid Amount","Interest Repaid Amount");
            //RemainingAmt := LoanRec."Remaining Amount" + CurrEntryLineRec.Amount;
        
            IF ABS(LoanRec."Remaining Amount") > 0 THEN
                CurrEntryLineRec."Loan ID" := LoanRec."Loan ID";
            IF LoanRec."Remaining Amount" > LoanRec."Monthly Repayment" THEN
              RepaymentAmt := LoanRec."Monthly Repayment"
            ELSE
              RepaymentAmt := LoanRec."Remaining Amount";
            IF (LoanRec."Interest Remaining Amount") <> 0 THEN
              IntRepaymentAmt := LoanRec."Interest Remaining Amount";
            //Create Loan Entry
            IF (RepaymentAmt <> 0) AND (RepaymentAmt <> (-1* (LoanRec."Repaid Amount"))) THEN BEGIN
              ProllLoanEntry.INIT;
              ProllLoanEntry."Payroll Period" := CurrEntryLineRec."Payroll Period";
              ProllLoanEntry.Date := ProllPeriod."End Date";
              ProllLoanEntry."Employee No." := CurrEntryLineRec."Employee No";
              ProllLoanEntry."E/D Code" := CurrEntryLineRec."E/D Code";
              ProllLoanEntry."Loan ID" := LoanRec."Loan ID" ;
              IF LoanRec."Repaid Amount" = 0 THEN
                ProllLoanEntry.Amount := -(RepaymentAmt)
              ELSE
                ProllLoanEntry.Amount := -( RepaymentAmt - (-1* (LoanRec."Repaid Amount")));
              ProllLoanEntry."Entry Type" := ProllLoanEntry."Entry Type"::"Payroll Deduction";
              IF ProllLoanEntry2.FINDLAST THEN
                ProllLoanEntry."Entry No." := ProllLoanEntry2."Entry No." + 1
              ELSE
                ProllLoanEntry."Entry No." := 1;
              ProllLoanEntry.INSERT;
            END;
            //Create Interest entry
            IF (IntRepaymentAmt <> 0) AND (IntRepaymentAmt <> (-1* (LoanRec."Interest Repaid Amount"))) THEN BEGIN
              ProllLoanEntry.INIT;
              ProllLoanEntry."Payroll Period" := CurrEntryLineRec."Payroll Period";
              ProllLoanEntry.Date := ProllPeriod."End Date";
              ProllLoanEntry."Employee No." := CurrEntryLineRec."Employee No";
              ProllLoanEntry."E/D Code" := CurrEntryLineRec."E/D Code";
              ProllLoanEntry."Loan ID" := LoanRec."Loan ID" ;
              IF LoanRec."Interest Repaid Amount" = 0 THEN
                ProllLoanEntry.Amount := -(IntRepaymentAmt)
              ELSE
                ProllLoanEntry.Amount := -(IntRepaymentAmt - (-1* (LoanRec."Interest Repaid Amount")));
              ProllLoanEntry."Entry Type" := ProllLoanEntry."Entry Type"::"Payroll Deduction";
              ProllLoanEntry."Amount Type" := ProllLoanEntry."Amount Type"::"Interest Amount";
              IF ProllLoanEntry2.FINDLAST THEN
                ProllLoanEntry."Entry No." := ProllLoanEntry2."Entry No." + 1
              ELSE
                ProllLoanEntry."Entry No." := 1;
              ProllLoanEntry.INSERT;
            END;
        
        
            TotalRepaymentAmt := TotalRepaymentAmt + RepaymentAmt + IntRepaymentAmt;
            LoanRec.SETRANGE("Date Filter");
            LoanRec.CALCFIELDS("Remaining Amount");
            LoanRec."Open(Y/N)" := (LoanRec."Remaining Amount" <> 0);
            LoanRec.MODIFY;
          END;
        UNTIL LoanRec.NEXT = 0;
        
        EXIT (TotalRepaymentAmt);*/

    end;


    procedure ReCalcutateAmount()
    begin
        /* If Period+Employee has already been closed then stop edit */
        if CheckClosed then
            Error(Text005, "Employee No.", "Payroll Period");

        "E/DFileRec".Get("E/D Code");

        /* Transfer Units, Rate, Payslip Group ID. and Pos in Payslip Group */
        begin
            "Statistics Group Code" := "E/DFileRec"."Statistics Group Code";
            "Pos. In Payslip Grp." := "E/DFileRec"."Pos. In Payslip Grp.";
            "Payslip appearance" := "E/DFileRec"."Payslip appearance";
            Units := "E/DFileRec".Units;
            Rate := "E/DFileRec".Rate;
            "Overline Column" := "E/DFileRec"."Overline Column";
            "Underline Amount" := "E/DFileRec"."Underline Amount";
            "Payslip Text" := "E/DFileRec".Description;
        end;

        /* Calculate the amount if neither quantities nor yes flag are required*/
        if (((Units = '') or ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Factor Lookup" <> '') or
           ("E/DFileRec"."Table Look Up" <> ''))) or "E/DFileRec"."Loan (Y/N)") and
           not ("E/DFileRec"."Yes/No Req.")) or (("E/DFileRec"."Yes/No Req.") and
           ((Amount <> 0) or Flag)) then begin
            if ("E/DFileRec"."Yes/No Req.") and (Amount <> 0) then
                Flag := true;

            Amount := CalcAmount("E/DFileRec", Rec, Amount, "E/D Code");

            // Prorate no. of days worked
            if "E/DFileRec"."No. of Days Prorate" and (Amount <> 0) then begin
                ProllHeader.Get("Payroll Period", "Arrear Type", "Employee No.");
                NoOfMonthDays := Date2dmy(CalcDate('CM', ProllHeader."Period Start"), 1);
                if ProllHeader."No. of Days Worked" <> 0 then
                    Amount := Amount / NoOfMonthDays * ProllHeader."No. of Days Worked";
            end;

            if ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Factor Lookup" <> '') or
               ("E/DFileRec"."Table Look Up" <> ''))) then
                Validate(Rate, Amount);
        end;

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

        ProllEntryRec.SetRange(ProllEntryRec."Payroll Period", PayrollFirstPeriod, "Payroll Period");
        ProllEntryRec.SetRange(ProllEntryRec."Arrear Type", "Arrear Type");
        ProllEntryRec.SetRange(ProllEntryRec."Employee No.", "Employee No.");
        ProllEntryRec.SetRange(ProllEntryRec."E/D Code", "E/D Code");
        ProllEntryRec.SetFilter(ProllEntryRec.Amount, '<>%1', 0);

        NoOfEntries := ProllEntryRec.Count;
        if ProllEntryRec.Find('+') then;
        if (ProllEntryRec."Payroll Period" <> "Payroll Period") and (Amount <> 0) then begin
            NoOfEntries := NoOfEntries + 1;
            PeriodTaken := ProllEntryRec."Payroll Period";
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNo, ShortcutDimCode);
        DimMgt.SaveDefaultDim(Database::"Payroll-Payslip Line", "Payroll Period", FieldNo, ShortcutDimCode);
        Modify;
    end;


    procedure UpdateArrears(var "E/DFile": Record "Payroll-E/D")
    var
        Found: Boolean;
    begin
        //Update Arrears on Initial Pay
        if "Arrear Type" in [0, 1] then begin
            if ("E/DFile"."Use in Arrear Calc.") and (Amount <> 0) then begin
                Found := false;
                if PayslipLines.Get("Payroll Period", "Employee No.", "E/DFile"."E/D Code") then begin
                    "Arrears Amount" := Amount - PayslipLines.Amount;
                end else begin
                    if "E/DFile"."Common Id" <> '' then begin
                        EDFileRec2.SetCurrentkey("Common Id");
                        EDFileRec2.SetFilter("E/D Code", '<>%1', "E/DFile"."E/D Code");
                        EDFileRec2.SetRange("Common Id", "E/DFile"."Common Id");
                        if EDFileRec2.FindFirst then begin
                            repeat
                                if PayslipLines.Get("Payroll Period", "Employee No.", EDFileRec2."E/D Code") then begin
                                    "Arrears Amount" := Amount - PayslipLines.Amount;
                                    Found := true;
                                end else begin
                                    "Arrears Amount" := Amount;
                                end;
                            until (EDFileRec2.Next = 0) or Found;
                        end
                    end else begin
                        "Arrears Amount" := Amount;
                    end;
                end;
                if ("E/DFile"."Prorate Arrear") and (Amount <> 0) then begin
                    ProllHeader.Get("Payroll Period", "Arrear Type", "Employee No.");
                    if ProllHeader."No. of Days Worked (Arr)" <> 0 then begin
                        NoOfMonthDays := Date2dmy(CalcDate('CM', ProllHeader."Period Start"), 1);
                        PayrollSetUp.Get;
                        PayrollSetUp.TestField(PayrollSetUp."No. of Working Days");
                        "Arrears Amount" := ("Arrears Amount" / NoOfMonthDays) *
                                                          ProllHeader."No. of Days Worked (Arr)";
                    end;
                end;
            end else
                "Arrears Amount" := 0;
        end else begin
            if ("E/DFile"."Use in Arrear Calc.") and (Amount <> 0) then
                "Arrears Amount" := Amount;
        end;
    end;


    procedure ProrateAmount(EDFileRec: Record "Payroll-E/D"; ProrateAmount: Decimal; PayLine: Record "Proll-Pslip Lines First Half") ProratedAmount: Decimal
    var
        NoofMonthDays: Integer;
        RefDate2: Date;
        nMonths: Decimal;
    begin
        if (EDFileRec."No. of Days Prorate" or EDFileRec."No. of Months Prorate")
        and (ProrateAmount <> 0) then begin
            if EDFileRec."No. of Days Prorate" then begin
                ProllHeader.Get(PayLine."Payroll Period", PayLine."Arrear Type", PayLine."Employee No.");
                NoofMonthDays := Date2dmy(CalcDate('CM', ProllHeader."Period Start"), 1);
                if ProllHeader."No. of Days Worked" <> 0 then
                    ProratedAmount := ProrateAmount / NoofMonthDays * ProllHeader."No. of Days Worked"
                else
                    ProratedAmount := ProrateAmount;
                exit(ProratedAmount);
            end else
                if EDFileRec."No. of Months Prorate" then begin
                    PayrollSetUp.Get;
                    EmployeeRec.Get(ProllHeader."Employee No");
                    if EmployeeRec."Employment Date" = 0D then
                        Error(Text011, ProllHeader."Employee No");
                    if RefDate <> 0D then
                        RefDate2 := RefDate
                    else
                        RefDate2 := ProllHeader."Period Start";

                    if PayrollSetUp."ExGratia ED Code" = EDFileRec."E/D Code" then
                        RefDate2 := Dmy2date(31, 12, Date2dmy(ProllHeader."Period Start", 3));

                    nMonths := ROUND(((Date2dmy(RefDate2, 3) - Date2dmy(EmployeeRec."Employment Date", 3)) * 365 +
                                (Date2dmy(RefDate2, 2) - Date2dmy(EmployeeRec."Employment Date", 2)) * 30.41 +
                                (Date2dmy(RefDate2, 1) - Date2dmy(EmployeeRec."Employment Date", 1))) / 30.41, 0.00001);
                    if PayrollSetUp."Leave ED Code" = EDFileRec."E/D Code" then begin
                        if nMonths >= 12 then begin
                            ProratedAmount := ProrateAmount;
                            exit(ProratedAmount);
                        end;
                        if nMonths >= 6 then begin
                            ProratedAmount := ProrateAmount / 12 * nMonths;
                            exit(ProratedAmount);
                        end;
                        if nMonths < 6 then begin
                            ProratedAmount := 0;
                            exit(ProratedAmount);
                        end;
                    end;
                    if PayrollSetUp."ExGratia ED Code" = EDFileRec."E/D Code" then begin
                        if nMonths >= 12 then begin
                            ProratedAmount := ProrateAmount;
                            exit(ProratedAmount);
                        end else begin
                            ProratedAmount := ProrateAmount / 12 * nMonths;
                            exit(ProratedAmount);
                        end;
                    end;
                end;
        end else
            exit(ProrateAmount);
    end;
}

