Table 52092176 "Proll-Emply Grp First Half"
{
    // Created           : FTN, 14/3/93
    // File name         : KI03 P.Emp.Grp Lines
    // Comments          : The Header card that is to be used to enter detail lines
    //                     for employee groups
    // File details      : Primary Key is;
    //                      Employee Group, E/D Code
    //                   : Relations;
    //                      To E/D File from E/D Code
    //                      To Finance Account from Debit and Credit Account No.
    //                   : Edit/Display fields;
    //                      Employee Group is a No”Edit field. It is intended to
    //                      be transfered from the P.Employee Grps. File i.e this
    //                      file should be used in a window that is called from
    //                      another in which the Employee Group is entered/displayed.
    //                   : Window
    // 
    // BDC 25/09/97       : Do not modify the line to be deleted


    fields
    {
        field(1;"Employee Group";Code[20])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = "Proll-Emply Grp First Half";
        }
        field(2;"E/D Code";Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-E/D";

            trigger OnValidate()
            begin
                 "E/DFileRec".Get( "E/D Code");
                
                
                /* Transfer Units and Rate */
                begin
                  Rate := "E/DFileRec".Rate;
                  Units := "E/DFileRec".Units;
                  "Payslip Text" := "E/DFileRec".Description;
                end;
                
                /* Calculate the amount if neither quantities nor yes flag are required*/
                if ((Units = '') or ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Table Look Up" <> '')))) and
                   not ("E/DFileRec"."Yes/No Req.") then
                begin
                  "Default Amount"  := CalcAmount ("E/DFileRec",
                                                   Rec, "Default Amount" );
                  if ((Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Table Look Up" <> ''))) then
                    Validate(Rate,"Default Amount");
                
                  if Rec."Default Amount"  <>
                     xRec."Default Amount"  then
                  begin
                    /* Change the entries that are computed using this new amount */
                    CalcCompute (Rec, "Default Amount", true);
                
                    /*If this new entry is a contributory factor for the value of another
                    line, then compute that other line's value and insert it appropriately*/
                    CalcFactor1 (Rec);
                
                    /* Go through all the lines and make any appropriate Changes */
                    ChangeAllOver (Rec, false);
                
                    /* Set the 'Change' flags to false in all the lines */
                    ResetChangeFlags(Rec);
                
                  end;
                end

            end;
        }
        field(3;Units;Text[10])
        {
            Editable = false;
        }
        field(4;Rate;Decimal)
        {
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if (Units = '') then
                  /* User cannot edit the rate if the E/D code has no units*/
                  Rec.Rate := xRec.Rate
                else
                begin
                  "Default Amount"  := Quantity * Rate;
                
                  /* Check for rounding and Maximum/Minimum */
                   "E/DFileRec".Get( "E/D Code");
                  "Default Amount" := ChkRoundMaxMin ("E/DFileRec", "Default Amount");
                
                end

            end;
        }
        field(5;Quantity;Decimal)
        {
            DecimalPlaces = 0:5;

            trigger OnValidate()
            begin
                if (Units = '') then
                  /* User cannot enter quantity if the E/D code has no units*/
                  Rec.Quantity := xRec.Quantity
                else
                begin
                  "Default Amount"  := Quantity * Rate;
                
                  /* Check for rounding and Maximum/Minimum */
                   "E/DFileRec".Get( "E/D Code");
                  "Default Amount" := ChkRoundMaxMin ("E/DFileRec", "Default Amount");
                
                end

            end;
        }
        field(6;Flag;Boolean)
        {

            trigger OnValidate()
            begin
                 "E/DFileRec".Get("E/D Code");
                if not ("E/DFileRec"."Yes/No Req.") then
                  Flag := false
                else
                begin
                  "Default Amount"  := CalcAmount ("E/DFileRec", Rec,
                                                   "Default Amount" );
                  if (Units <> '') and (("E/DFileRec"."Factor Of" <> '') or ("E/DFileRec"."Table Look Up" <> '')) then
                    Validate(Rate,"Default Amount");
                end
            end;
        }
        field(7;"Default Amount";Decimal)
        {
            DecimalPlaces = 0:5;
            InitValue = 0;
            NotBlank = true;

            trigger OnValidate()
            begin
                /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
                ‚   Note that this trigger is invoked whenever the amount is edited          ‚
                ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
                 "E/DFileRec".Get( "E/D Code");
                if not ("E/DFileRec"."Edit Grp. Amount") then
                  Rec."Default Amount"  :=
                  xRec."Default Amount"
                else
                  /* Check for rounding and Maximum/Minimum */
                  "Default Amount" := ChkRoundMaxMin ("E/DFileRec", "Default Amount");

            end;
        }
        field(8;ChangeOthers;Boolean)
        {
            Editable = false;
            InitValue = false;
        }
        field(9;HasBeenChanged;Boolean)
        {
            Editable = false;
            InitValue = false;
        }
        field(10;ChangeCounter;Integer)
        {
            Editable = false;
            InitValue = 0;
        }
        field(11;"Payslip Text";Text[30])
        {
        }
    }

    keys
    {
        key(Key1;"Employee Group","E/D Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        ChangeOthers := false;
        /* Go through all the lines and make any appropriate Changes */
        ChangeDueToDelete( Rec);
        
        /* Set the 'Change' flags to false in all the lines */
        ResetChangeFlags(Rec);

    end;

    trigger OnModify()
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ This trigger is called if any of the fields in "KI03 P.Emp.Grp Lines"      ‚
        ‚ is different from the corresponding field in "xKI03 P.Emp.Grp Line"        ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        if Rec."Default Amount"  <>
           xRec."Default Amount"  then
        begin
           Mark( true);
          /* If this new entry contributes in computing another, then compute that
            value for that computed entry and insert it appropriately*/
          CalcCompute (Rec, "Default Amount", false);
        
          /* If this new entry is a contributory factor for the value of another line,
            then compute that other line's value and insert it appropriately */
          CalcFactor1 (Rec);
        
          /*The new entry in this line has already been used to Compute another and
           also entries where it is a Factor, therefore set ChangeOthers to false*/
          ChangeOthers := false;
        
          /* Go through all the lines and make any appropriate Changes */
          ChangeAllOver (Rec, false);
        
          /* Set the 'Change' flags to false in all the lines */
         /***ST ResetChangeFlags(Rec);  */
        
           Mark( false)
        end;

    end;

    var
        EmpGrpHeader: Record "Payroll-Employee Group Header";
        "E/DFileRec": Record "Payroll-E/D";
        ConstEdFileRec: Record "Payroll-E/D";
        LineFactorRec: Record "Payroll-Factor Lookup Line";
        LookHeaderRec: Record "Payroll-Lookup Header";
        LookLinesRec: Record "Payroll-Lookup Line";
        PrevLookRec: Record "Payroll-Lookup Line";
        EmpLinesRecStore: Record "Proll-Emply Grp First Half";
        EmpGrpLinesRec: Record "Proll-Emply Grp First Half";
        ChangeOthersRec: Record "Proll-Emply Grp First Half";
        BackOneRec: Integer;
        ComputedTotal: Decimal;
        AmountToAdd: Decimal;
        AmtToAdd: Decimal;
        ReturnAmount: Decimal;
        InputAmount: Decimal;
        FactorRecAmount: Decimal;
        RoundPrec: Decimal;
        RoundDir: Text[1];
        IsComputed: Boolean;
        MaxChangeCount: Integer;


    procedure SpecialRelation("FieldNo.": Integer)
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Special Relations code for the field, E/D Code                             ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        /* Force NO-EDIT of field already has a value*/
        if "E/D Code" <> '' then
          exit;

    end;


    procedure CalcAmount(EDFileRec: Record "Payroll-E/D";EntryLineRec: Record "Proll-Emply Grp First Half";EntryLineAmount: Decimal): Decimal
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Calculate the amount based on Factor Of and Percentage fields in the file  ‚
        ‚ E/D file, alternatively calculate if the group line is computed by others  ‚
        ‚  Parameters:                                                               ‚
        ‚    EDFileRec    : EDFile Record for the E/D Code of the current entry line ‚
        ‚    EntryLineRec : The current entry line record                            ‚
        ‚    EntryLineAmount: The amount in the current entry line. Not this         ‚
        ‚    parameter is important if this trigger is called from the SAVE trigger  ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        /* If NO is in the flag field return amount to 0 */
        if (EDFileRec."Yes/No Req.") and not (EntryLineRec.Flag) then
          exit (0);
        
        /* If Factor Of is Nil then check if amount is computed by others */
        if EDFileRec."Factor Of" = '' then
          if not AmountIsComputed (ReturnAmount, EntryLineRec, EntryLineAmount) then
            exit (EntryLineRec."Default Amount")
          else
          begin
            /* Check for rounding and Maximum/Minimum */
            ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
            exit (ReturnAmount)
          end;
        
        /* Get the record from the current file based on Factor Of */
        if not  LineFactorRec.Get( EntryLineRec."Employee Group",
                         EDFileRec."Factor Of") then
          exit (EntryLineRec."Default Amount")
        else
          /* If this 'Factor of' entry record is marked then this trigger was called
            from the 'Factor of' entry line, therefore ensure the amount to be used
            is the updated amount*/
          if  LineFactorRec.Mark then
            FactorRecAmount := EntryLineAmount
          else
            FactorRecAmount := LineFactorRec.Amount;
        
        /* Calculate the amount based on values in Table Look Up or Percentage fields
          of E/D file */
        if EDFileRec."Table Look Up" = '' then
          ReturnAmount := (FactorRecAmount * EDFileRec.Percentage) / 100
        else /* Extract relevant amount from Table Look Up */
        
          if not  LookHeaderRec.Get( EDFileRec."Table Look Up") then
          begin
            Message ('Table Lookup Not Registered Yet');
            exit (EntryLineRec."Default Amount")
          end
          else begin /* Table lookup exists*/
        
            /* Filter Lookupline records to those of current Table Id Only*/
            LookLinesRec.TableId := EDFileRec."Table Look Up";
             LookLinesRec.SetRange(TableId, EDFileRec."Table Look Up");
        
            /* Depending on whether input parameter is code or numeric, set dbSETRANGE
              appropraitely and initialise the record to use as a parameter to
              dbFINDREC */
            /*IF LookHeaderRec.Type = 0 THEN BEGIN*/
            case LookHeaderRec.Type of
            0,2:
              begin
                /* Lookup table is searched with numeric variables */
                if FactorRecAmount > -1 then begin
                  LookLinesRec."Lower Code" := '';
                  InputAmount := FactorRecAmount * LookHeaderRec."Input Factor";
                  LookLinesRec."Lower Amount" := InputAmount;
                   LookLinesRec.SetRange("Lower Code",'');
                end
                else
                  exit (LookHeaderRec."Min. Extract Amount")
              end;
            else  /*Lookup table is searched with variables of type code*/
              begin
                LookLinesRec."Lower Amount" := 0;
                LookLinesRec."Lower Code" := EDFileRec."Factor Of";
                 LookLinesRec.SetRange("Upper Amount",0);
                 LookLinesRec.SetRange("Lower Amount",0);
              end
            end; /* Case*/
        
            case LookHeaderRec.Type of
            0,1: begin
               /* Extract amount as follows; First find line where Lower Amount or
                 lower code is just greater than the Factor Amount then move one
                 line back.*/
        
              if  LookLinesRec.Find( '=') then
                ReturnAmount := LookLinesRec."Extract Amount"
              else
              if  LookLinesRec.Find( '>') then begin
                BackOneRec :=  LookLinesRec.Next( -1);
                ReturnAmount := LookLinesRec."Extract Amount";
              end
              else
                if LookHeaderRec.Type = 0 then begin
                  /*'Factor' Amount is > than the table's greatest "Lower amount"*/
                  if  LookLinesRec.Find( '+') then
                    ReturnAmount := LookLinesRec."Extract Amount";
                end
                else
                  exit (EntryLineRec."Default Amount");
            end;
        
            2: /*  Extract amount from tax table*/
              ReturnAmount := (CalcTaxAmt (LookLinesRec, InputAmount)) *
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
              1: RoundDir := '>';
              2: RoundDir := '<';
              else RoundDir := '=';
            end;
            ReturnAmount := ROUND (ReturnAmount, RoundPrec, RoundDir);
        
             LookLinesRec.Reset
          end;
        
        /* Check for rounding and Maximum/Minimum */
        ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
        
        exit (ReturnAmount);

    end;


    procedure CalcCompute(EntryRecParam: Record "Proll-Emply Grp First Half";AmountInLine: Decimal;"CalledFromEdCode?": Boolean)
    begin
        /*”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Compute values for the E/D specified in the Compute field for the current ‚
        ‚  Entry Line record                                                        ‚
        ‚ Parameters :                                                              ‚
        ‚   EntryRecParam           : Current entry line                            ‚
        ‚   AmountInLine            : The figure in the amount field in this line   ‚
        ‚   "CalledFromEdCode?"     : True if the trigger code was called from the  ‚
        ‚                            "E/D Code" field                               ‚
        ”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
         ConstEdFileRec.Get( EntryRecParam."E/D Code");
        "E/DFileRec" := ConstEdFileRec;
        if "E/DFileRec".Compute = '' then
          exit;
        
         EmpGrpLinesRec.Init;
         EmpGrpLinesRec.SetRange("Employee Group", EntryRecParam."Employee Group");
        
        /* If the entry line to be computed does not exist then EXIT */
        EmpGrpLinesRec := EntryRecParam;
        EmpGrpLinesRec."E/D Code" := ConstEdFileRec.Compute;
        if not  EmpGrpLinesRec.Find( '=') then
          exit;
        
        /* If the line to be computed needs a flag and yet the flag is false, EXIT */
         "E/DFileRec".Get( EmpGrpLinesRec."E/D Code");
        if ("E/DFileRec"."Yes/No Req.") and not (EmpGrpLinesRec.Flag) then
          exit;
        
        /* Initialise the variable to store the computed total. Note if the trigger
          code was called from the "E/D Code" field then that record is a new one.
          This implies that a search of the records in the file will not find this
          new record. Therefore for it's amount to be used in the computation
          we initialise the computed total to that amount*/
        if "CalledFromEdCode?" then begin
          if ConstEdFileRec."Add/Subtract" = 2 then
            /* Subtract */
            ComputedTotal := - AmountInLine
          else
            /* Add */
            ComputedTotal := AmountInLine;
        end
        else
         ComputedTotal := 0;
        
        /*Get first record in P.Roll Entry file for this Employee group*/
        EmpGrpLinesRec := EntryRecParam;
        EmpGrpLinesRec."E/D Code" := '';
         EmpGrpLinesRec.Find( '>');
        
        /* Go through all the entry lines for this Employee group and sum up
          all those that contribute to the E/D specified in the Compute field for
          the current entry line */
        repeat
        begin
          if EmpGrpLinesRec."E/D Code" = EntryRecParam."E/D Code" then
            /* We are at the record where the function was called from */
            AmountToAdd := AmountInLine
          else
            AmountToAdd := EmpGrpLinesRec."Default Amount";
        
           "E/DFileRec".Get( EmpGrpLinesRec."E/D Code");
          if "E/DFileRec".Compute = ConstEdFileRec.Compute then
            if "E/DFileRec"."Add/Subtract" = 2 then
              /* Subtract */
              ComputedTotal := ComputedTotal - AmountToAdd
            else
              /* Add */
              ComputedTotal := ComputedTotal + AmountToAdd;
        
        end
        until ( EmpGrpLinesRec.Next(1) = 0);
        
        /* Move the computed amount to the line whose E/D Code is the one that has
          just been calculated.*/
         EmpGrpLinesRec.Init;
        EmpGrpLinesRec."E/D Code" := ConstEdFileRec.Compute;
         "E/DFileRec".Get( ConstEdFileRec.Compute);
        
        /* Check for rounding and Maximum/Minimum */
        ComputedTotal := ChkRoundMaxMin ("E/DFileRec", ComputedTotal);
        
        begin
          EmpGrpLinesRec.Rate := "E/DFileRec".Rate;
          EmpGrpLinesRec.Units := "E/DFileRec".Units;
        end;
        EmpGrpLinesRec."Default Amount" := ComputedTotal;
        
        // inserted by Ade Aluko
        if EmpGrpLinesRec.Units <> '' then
          EmpGrpLinesRec.Validate(EmpGrpLinesRec.Rate,EmpGrpLinesRec."Default Amount");
        
        EmpLinesRecStore := EmpGrpLinesRec;
        /*dbSETRANGE (EmpLinesRecStore."Employee Group", EmpGrpLinesRec."Employee Group");*/
        
         EmpGrpLinesRec.LockTable( false);
        
        if  EmpGrpLinesRec.Find( '=') then
        begin
          FactorRecAmount := EmpGrpLinesRec."Default Amount";
          EmpGrpLinesRec."Default Amount" := EmpLinesRecStore."Default Amount";
          /*The new entry in this line should now be used to Compute another and
           also entries where it is a Factor, therefore set ChangeOthers to True*/
          if FactorRecAmount <> EmpGrpLinesRec."Default Amount" then
          begin
            EmpGrpLinesRec.ChangeOthers := true;
             EmpGrpLinesRec.Modify
          end
        end;
        Commit;
        
         EmpGrpLinesRec.SetRange("Employee Group");
         EmpLinesRecStore.SetRange("Employee Group");

    end;


    procedure CalcFactor1(CurrentEntryLine: Record "Proll-Emply Grp First Half")
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ If an entry is a contributory factor for the value of another line, then   ‚
        ‚ compute that other line's value and insert it appropriately                ‚
        ‚ Parameters :                                                               ‚
        ‚   CurrentEntryLine        : Current entry line                             ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        /*Get first record in Employee Group Lines file for this Employee group*/
        EmpGrpLinesRec := CurrentEntryLine;
         EmpGrpLinesRec.Init;
         EmpGrpLinesRec.SetRange("Employee Group", EmpGrpLinesRec."Employee Group");
        EmpGrpLinesRec."E/D Code" := '';
         EmpGrpLinesRec.Find( '>');
        
        /* Go through all the entry lines for this Employee Group record and where
          the current entry line's value is a factor, calculate that amount. */
        repeat
        
           "E/DFileRec".Get( EmpGrpLinesRec."E/D Code");
        
          if "E/DFileRec"."Factor Of" = CurrentEntryLine."E/D Code" then
          begin
        
            FactorRecAmount := EmpGrpLinesRec."Default Amount";
            EmpGrpLinesRec."Default Amount" := "CalcFactor1.1" (CurrentEntryLine,
                                                                EmpGrpLinesRec,
                                                                "E/DFileRec");
            /*The new entry in this line should now be used to Compute another and
             also entries where it is a Factor, therefore set ChangeOthers to True*/
        
            // inserted by Ade Aluko @GEMS 21/11/00 to compute rate
            if EmpGrpLinesRec.Units <> '' then
              EmpGrpLinesRec.Validate(EmpGrpLinesRec.Rate,EmpGrpLinesRec."Default Amount");
        
            if FactorRecAmount <> EmpGrpLinesRec."Default Amount" then
            begin
              EmpGrpLinesRec.ChangeOthers := true;
               EmpGrpLinesRec.Modify;
            end;
          end;
        
        until ( EmpGrpLinesRec.Next(1) = 0);
        Commit;

    end;


    procedure "CalcFactor1.1"(CurrLineRec: Record "Proll-Emply Grp First Half";LineToChangeRec: Record "Proll-Emply Grp First Half";EDFileRec: Record "Payroll-E/D"): Decimal
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Calculate the amount based on Factor Of and Percentage fields of the       ‚
        ‚ E/D file record linked to the Line to be Changed.                          ‚
        ‚  Parameters:                                                               ‚
        ‚    CurrLineRec    : The current entry line record                          ‚
        ‚    LineToChangeRec: The entry line to be changed.                          ‚
        ‚    EDFileRec      : EDFile Record for the E/D Code of LineToChangeRec      ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        /* If NO is in the flag field return amount to 0 */
        if (EDFileRec."Yes/No Req.") and not (LineToChangeRec.Flag) then
          exit (0);
        
        /* Calculate the amount based on values in Table Look Up or Percentage fields
          of E/D file */
        if EDFileRec."Table Look Up" = '' then
          ReturnAmount := (CurrLineRec."Default Amount" * EDFileRec.Percentage) / 100
        else /* Extract relevant amount from Table Look Up */
        
          if not  LookHeaderRec.Get( EDFileRec."Table Look Up") then
          begin
            Message ('Table Lookup Not Registered Yet');
            exit (LineToChangeRec."Default Amount")
          end
          else begin /* Table lookup exists*/
        
            /* Filter Lookupline records to those of current Table Id Only*/
            LookLinesRec.TableId := EDFileRec."Table Look Up";
             LookLinesRec.SetRange(TableId, EDFileRec."Table Look Up");
        
            /* Depending on whether input parameter is code or numeric, set dbSETRANGE
              appropraitely and initialise the record to use as a parameter to
              dbFINDREC */
            case LookHeaderRec.Type of
            0,2:
              begin
                /* Lookup table is searched with numeric variables */
                if CurrLineRec."Default Amount" > -1 then begin
                  LookLinesRec."Lower Code" := '';
                  LookLinesRec."Lower Amount" := CurrLineRec."Default Amount" *
                                                 LookHeaderRec."Input Factor";
                   LookLinesRec.SetRange("Lower Code",'');
                end
                else
                  exit (LookHeaderRec."Min. Extract Amount")
              end;
            else  /*Lookup table is searched with variables of type code*/
              begin
                LookLinesRec."Lower Amount" := 0;
                LookLinesRec."Lower Code" := CurrLineRec."E/D Code";
                 LookLinesRec.SetRange("Upper Amount",0);
                 LookLinesRec.SetRange("Lower Amount",0);
              end
            end; /* Case*/
        
            case LookHeaderRec.Type of
            0,1: begin
               /* Extract amount as follows; First find line where Lower Amount or
                 Lower Code is just greater than the CurrLineRec then move one line
                 back.*/
        
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
                  /*CurrLineRec.Amount is > than the table's greatest "Lower amount"*/
                  if  LookLinesRec.Find( '+') then
                    ReturnAmount := LookLinesRec."Extract Amount"
                  else
                    exit (LineToChangeRec."Default Amount")
                end
                else
                  /*CurrLineRec.EDCode is > than the table's greatest "Lower code"*/
                  exit (LineToChangeRec."Default Amount");
              end;
        
            2: /*  Extract amount from tax table*/
              ReturnAmount := (CalcTaxAmt (LookLinesRec,
                                           CurrLineRec."Default Amount" *
                                           LookHeaderRec."Input Factor")) *
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
              1: RoundDir := '>';
              2: RoundDir := '<';
              else RoundDir := '=';
            end;
            ReturnAmount := ROUND (ReturnAmount, RoundPrec, RoundDir);
        
             LookLinesRec.Reset
          end;
        
        /* Check for rounding and Maximum/Minimum */
        ReturnAmount := ChkRoundMaxMin (EDFileRec, ReturnAmount);
        
        exit (ReturnAmount);

    end;


    procedure ChangeAllOver(CurrentRec: Record "Proll-Emply Grp First Half";CurrWasDeleted: Boolean)
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ If there is any entry line that should change other lines then do so       ‚
        ‚  Parameters:                                                               ‚
        ‚    CurrentRec      : The current entry line record                         ‚
        ‚    CurrWasDeleted  : True if the current record was deleted                ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        ChangeOthersRec := CurrentRec;
         ChangeOthersRec.SetRange("Employee Group", CurrentRec."Employee Group");
         ChangeOthersRec.SetRange(ChangeOthers, true);
        ChangeOthersRec."E/D Code" := '';
        if not  ChangeOthersRec.Find( '>') then
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
            ComputeAgain (ChangeOthersRec, CurrentRec, CurrWasDeleted);
            CalcFactorAgain (ChangeOthersRec, CurrentRec, CurrWasDeleted);
          end;
          ChangeOthersRec.ChangeCounter := ChangeOthersRec.ChangeCounter + 1;
          ChangeOthersRec.ChangeOthers := false;
           ChangeOthersRec.Modify;
          EmpLinesRecStore := ChangeOthersRec;
          ChangeOthersRec."E/D Code" := '';
        until ((EmpLinesRecStore.ChangeCounter > MaxChangeCount) or
               ( ChangeOthersRec.Next(1) = 0));
        Commit;
         ChangeOthersRec.SetRange("Employee Group");
         ChangeOthersRec.SetRange(ChangeOthers);
        if (EmpLinesRecStore.ChangeCounter > MaxChangeCount) then
          Message ('The E/D Code %1, / seems to have been defined with CYCLIC' +
                   ' characteristics', EmpLinesRecStore."E/D Code");
        
        exit;

    end;


    procedure ComputeAgain(ParamLine: Record "Proll-Emply Grp First Half";CurrentRec: Record "Proll-Emply Grp First Half";CurrWasDeleted: Boolean)
    begin
        /*”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Compute values for the E/D specified in the Compute field for the         ‚
        ‚  Entry Line record passed as a parameter                                  ‚
        ‚ Parameters :                                                              ‚
        ‚   ParamLine         : Entry line passed as a parameter                    ‚
        ‚   CurrentRec        : Current Entry line                                  ‚
        ‚   CurrWasDeleted    : True if CurrentRec is to be deleted                 ‚
        ”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
         ConstEdFileRec.Get( ParamLine."E/D Code");
        "E/DFileRec" := ConstEdFileRec;
        if "E/DFileRec".Compute = '' then
          exit;
        
         EmpGrpLinesRec.Init;
         EmpGrpLinesRec.SetRange("Employee Group", ParamLine."Employee Group");
        
        /* If the entry line to be computed does not exist then EXIT */
        EmpGrpLinesRec := ParamLine;
        EmpGrpLinesRec."E/D Code" := ConstEdFileRec.Compute;
        if not  EmpGrpLinesRec.Find( '=') then
          exit;
        
        /* If CurrentRec is to be deleted, then no need to re-compute it */
        if (CurrWasDeleted and (EmpGrpLinesRec."E/D Code" = CurrentRec."E/D Code"))
        then exit;
        
        /*
          Initialise the variable to store the computed total. If a record was
          deleted then initialise to 0. Otherwise if the current line (i.e that
          entered by the user) also contributes to the computed line then we
          initialise the computed total to that amount
        */
         "E/DFileRec".Get( CurrentRec."E/D Code");
        if CurrWasDeleted then
          ComputedTotal := 0
        else
         if "E/DFileRec".Compute = ConstEdFileRec.Compute then begin
           if "E/DFileRec"."Add/Subtract" = 2 then
            /* Subtract */
            ComputedTotal := -  CurrentRec."Default Amount"
           else
            /* Add */
            ComputedTotal := CurrentRec."Default Amount";
         end
         else
          ComputedTotal := 0;
        
        /*Get first record in P.Roll Entry file for this Employee group*/
        EmpGrpLinesRec := ParamLine;
        EmpGrpLinesRec."E/D Code" := '';
         EmpGrpLinesRec.Find( '>');
        
        /* Go through all the entry lines for this Employee group and sum up
          all those that contribute to the E/D specified in the Compute field for
          the current entry line */
        repeat
        
          if EmpGrpLinesRec."E/D Code" <> CurrentRec."E/D Code" then begin
        
             "E/DFileRec".Get( EmpGrpLinesRec."E/D Code");
            if "E/DFileRec".Compute = ConstEdFileRec.Compute then
              if "E/DFileRec"."Add/Subtract" = 2 then
                /* Subtract */
                ComputedTotal := ComputedTotal - EmpGrpLinesRec."Default Amount"
              else
                /* Add */
                ComputedTotal := ComputedTotal + EmpGrpLinesRec."Default Amount"
        
          end
        until ( EmpGrpLinesRec.Next(1) = 0);
        
        /* Move the computed amount to the line whose E/D Code is the one that has
          just been calculated.*/
         EmpGrpLinesRec.Init;
        EmpGrpLinesRec."E/D Code" := ConstEdFileRec.Compute;
         "E/DFileRec".Get( ConstEdFileRec.Compute);
        begin
          EmpGrpLinesRec.Rate := "E/DFileRec".Rate;
          EmpGrpLinesRec.Units := "E/DFileRec".Units;
        end;
        
        /* Check for rounding and Maximum/Minimum */
        ComputedTotal := ChkRoundMaxMin ("E/DFileRec", ComputedTotal);
        
        EmpGrpLinesRec."Default Amount" := ComputedTotal;
        EmpLinesRecStore := EmpGrpLinesRec;
        
         EmpGrpLinesRec.LockTable( false);
        
        if  EmpGrpLinesRec.Find( '=') then
        begin
          FactorRecAmount := EmpGrpLinesRec."Default Amount";
          EmpGrpLinesRec := EmpLinesRecStore;
          /*The new entry in this line should now be used to Compute another and
           also entries where it is a Factor, therefore set ChangeOthers to True*/
          if FactorRecAmount <> EmpGrpLinesRec."Default Amount" then
          begin
            EmpGrpLinesRec.ChangeOthers := true;
             EmpGrpLinesRec.Modify
          end
        end;
        Commit;
        
         EmpGrpLinesRec.SetRange("Employee Group");
         EmpLinesRecStore.SetRange("Employee Group");

    end;


    procedure CalcFactorAgain(ParamLine: Record "Proll-Emply Grp First Half";CurrentRec: Record "Proll-Emply Grp First Half";CurrWasDeleted: Boolean)
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ If a change in a line due to the entry or change to another entry is a     ‚
        ‚ contributory factor for the value of another line, then  compute that      ‚
        ‚other line's value and insert it appropriately                              ‚
        ‚ Parameters :                                                               ‚
        ‚   ParamLine         : Line whose value should change others                ‚
        ‚   CurrentRec        : Current Entry line                                   ‚
        ‚   CurrWasDeleted    : True if CurrentRec is to be deleted                  ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        /*Get first record in Employee Group Lines file for this Employee group*/
        EmpGrpLinesRec := ParamLine;
         EmpGrpLinesRec.Init;
         EmpGrpLinesRec.SetRange("Employee Group", ParamLine."Employee Group");
        EmpGrpLinesRec."E/D Code" := '';
        if not  EmpGrpLinesRec.Find( '>') then
          exit;
        
        /* Go through all the entry lines for this Employee Group record and where
          the current entry line's value is a factor, calculate that amount. */
        repeat
        
           "E/DFileRec".Get( EmpGrpLinesRec."E/D Code");
        
          if "E/DFileRec"."Factor Of" = ParamLine."E/D Code" then
          begin
        
            FactorRecAmount := EmpGrpLinesRec."Default Amount";
            if (CurrWasDeleted and (ParamLine."E/D Code" =
                                    CurrentRec."E/D Code"))
            then
              EmpGrpLinesRec."Default Amount" := 0
            else begin
              EmpGrpLinesRec."Default Amount" := "CalcFactor1.1" (ParamLine,
                                                                  EmpGrpLinesRec,
                                                                  "E/DFileRec");
             /*The new entry in this line should now be used to Compute another and
              also entries where it is a Factor, therefore set ChangeOthers to True*/
              if FactorRecAmount <> EmpGrpLinesRec."Default Amount" then
              begin
                EmpGrpLinesRec.ChangeOthers := true;
                 EmpGrpLinesRec.Modify
              end
            end
          end;
        until ( EmpGrpLinesRec.Next(1) = 0);
        Commit;
         EmpGrpLinesRec.SetRange("Employee Group");

    end;


    procedure ResetChangeFlags(CurrentRec: Record "Proll-Emply Grp First Half")
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Reset the field ChangeOthers to false for all lines in this Employee Group ‚
        ‚ Parameters :                                                               ‚
        ‚   CurrentRec  : Current entry line                                         ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        /*Get first record in Employee Group Lines file for this Employee group*/
        EmpGrpLinesRec := CurrentRec;
         EmpGrpLinesRec.Init;
         EmpGrpLinesRec.SetRange("Employee Group", EmpGrpLinesRec."Employee Group");
        EmpGrpLinesRec."E/D Code" := '';
         EmpGrpLinesRec.Find( '>');
        
        /* Reset ChangeOthers for this Employee Group */
        repeat
        
          EmpGrpLinesRec.ChangeOthers   := false;
          EmpGrpLinesRec.ChangeCounter  := 0;
          /*BDC - Do not modify the one to be deleted*/
        /*  IF EmpGrpLinesRec."Employee Group" <> CurrentRec."Employee Group" THEN*/
           if EmpGrpLinesRec."E/D Code" <> CurrentRec."E/D Code" then
           EmpGrpLinesRec.Modify;
        
        until ( EmpGrpLinesRec.Next(1) = 0);
        Commit;

    end;


    procedure CalcTaxAmt(var LDetailsRec: Record "Payroll-Lookup Line";TaxTableInput: Decimal): Decimal
    begin
        /*””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Returns the tax figure from a table lookup of type Tax                     ‚
        ‚ Parameters:                                                                ‚
        ‚  by Referrence : The current Lookup detail table record = LDetailsRec.     ‚
        ‚                  NB: By referrence so that all delimitations, sortings etc ‚
        ‚                      are still in effect.                                  ‚
        ‚  by value      : The amount to be taxed = TaxTableInput                    ‚
        ””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        /* Copy all current filters of LookUpRec */
        PrevLookRec := LDetailsRec;
        /*BDC
         COPYFILTERS(LDetailsRec );
         */
        
        if  LDetailsRec.Find( '=') then
          /*Record found where Lower Amount is equal to TaxTableInput*/
          if  PrevLookRec.Next(-1) = 0 then
            ReturnAmount := (TaxTableInput * LDetailsRec."Tax Rate %")/100
          else
            /* Call function to get the tax amount from the graduated tax table.*/
            ReturnAmount := CalcGraduated (LDetailsRec, TaxTableInput)
        else
        if  LDetailsRec.Find( '>') then
          /*Record found where Lower Amount is just larger than TaxTableInput.
           Therefore TaxableInput should be in previus range (= record)*/
          if  LDetailsRec.Next(-1) = 0 then
            /* The lowest taxable amount is larger than the input amount */
            ReturnAmount := 0
          else
            ReturnAmount := CalcGraduated (LDetailsRec, TaxTableInput)
        else
          /*TaxableInput is larger than the table's greatest lower amount*/
          if  LDetailsRec.Next(-1) = 0 then
            ReturnAmount := (TaxTableInput * LDetailsRec."Tax Rate %")/100
          else
            /* Call function to get the tax amount from the graduated tax table.*/
            ReturnAmount := CalcGraduated (LDetailsRec, TaxTableInput);
        
        exit (ReturnAmount);

    end;


    procedure CalcGraduated(var WantedLookRec: Record "Payroll-Lookup Line";InputToTable: Decimal): Decimal
    begin
        /*”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Returns the tax amount from the graduated tax table.                      ‚
        ‚ Parameters                                                                ‚
        ‚ by reference : The Table Lookup record within which the Taxable amount    ‚
        ‚                falls = WantedLookRec                                      ‚
        ‚                NB: By referrence so that all delimitations, sortings etc  ‚
        ‚                    are still in effect.                                   ‚
        ‚ by value     : The amount to be taxed = InputToTable                      ‚
        ”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        /* Create a copy of the valid Look Up table Record */
        PrevLookRec :=  WantedLookRec;
        /*BDC
         COPYFILTERS(WantedLookRec );
        */
        if  PrevLookRec.Next(-1) = 0 then
         ReturnAmount := (InputToTable * WantedLookRec."Tax Rate %")/100
        else
        begin
          /* Compute tax for the amount of money that is within the range of the
            Wanted Look Up Record then add the Cumulative Tax Payable amount from
            the previous Look Up record*/
        
           ReturnAmount :=  (InputToTable - PrevLookRec."Upper Amount");
           ReturnAmount :=  (ReturnAmount * WantedLookRec."Tax Rate %")/100;
           ReturnAmount :=  ReturnAmount + PrevLookRec."Cum. Tax Payable";
        end;
        exit (ReturnAmount);

    end;


    procedure AmountIsComputed(var ReturnAmount: Decimal;EntryRecParam: Record "Proll-Emply Grp First Half";NewAmount: Decimal): Boolean
    begin
        /*”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Check for values that should COMPUTE the amount for the P.Roll Entry      ‚
        ‚ Line record.                                                              ‚
        ‚ Return:                                                                   ‚
        ‚   If there are entries for the employee group that compute the value      ‚
        ‚   then return TRUE else return FALSE                                      ‚
        ‚ Parameters :                                                              ‚
        ‚   ReturnAmount : The computed amount, passed by reference                 ‚
        ‚   EntryRecParam: The P.Roll Entry record whose value is to be computed    ‚
        ‚   NewAmount    : The New Amount in the current entry line                 ‚
        ”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
        EmpLinesRecStore := EntryRecParam;
        
        /*Get first record in P.Roll Entry file for this Employee group*/
         EmpLinesRecStore.SetRange("Employee Group", EntryRecParam."Employee Group");
        EmpLinesRecStore."E/D Code" := '';
        if not  EmpLinesRecStore.Find( '>') then
          exit (false);
        
        /* Initialise the variable to store the computed total. */
        ReturnAmount := 0;
        IsComputed := false;
        
        /* Go through all the entry lines for this Employee group and sum up
          all those that contribute to the E/D specified in the Compute field for
          the current entry line */
        repeat
           "E/DFileRec".Get( EmpLinesRecStore."E/D Code");
          if "E/DFileRec".Compute =  EntryRecParam."E/D Code" then begin
        
            if  EmpLinesRecStore.Mark then
              AmtToAdd := NewAmount
            else
              AmtToAdd := EmpLinesRecStore."Default Amount";
        
            if "E/DFileRec"."Add/Subtract" = 2 then
              /* Subtract */
              ReturnAmount := ReturnAmount - AmtToAdd
            else
              /* Add */
              ReturnAmount := ReturnAmount + AmtToAdd;
        
            IsComputed := true
          end
        until ( EmpLinesRecStore.Next(1) = 0);
         EmpLinesRecStore.SetRange("Employee Group");
        
        exit (IsComputed);

    end;


    procedure ChangeDueToDelete(DeletedRec: Record "Proll-Emply Grp First Half")
    begin
        /*”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Due to the deleted record, ensure all the other lines are correct.        ‚
        ‚ Parameters :                                                              ‚
        ‚   DeletedRec : The current record (= the record to be deleted             ‚
        ‚                                                                           ‚
        ”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        /*Get first record in Employee Group Lines file for this Employee group*/
        EmpGrpLinesRec := DeletedRec;
         EmpGrpLinesRec.Init;
         EmpGrpLinesRec.SetRange("Employee Group", DeletedRec."Employee Group");
        
        /* If the deleted record was 'COMPUTING" another then make changes */
         "E/DFileRec".Get( DeletedRec."E/D Code");
        EmpGrpLinesRec."E/D Code" := "E/DFileRec".Compute;
        if  EmpGrpLinesRec.Find( '=') then
          ComputeAgain (DeletedRec, DeletedRec, true);
        
        CalcFactorAgain (DeletedRec, DeletedRec, true);
        ChangeAllOver (DeletedRec, true);
        exit;

    end;


    procedure ChkRoundMaxMin(EDRecord: Record "Payroll-E/D";TheAmount: Decimal): Decimal
    begin
        /*”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””
        ‚ Round an amount and check for Max and Min. Return the amended amount.     ‚
        ‚ Parameters :                                                              ‚
        ‚   EDRecord : The ED file record to use to check Round, Max. and Min       ‚
        ‚   TheAmount: The amounht to Round, and check for Max. and Min             ‚
        ”””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””””*/
        
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
          1: RoundDir := '>';
          2: RoundDir := '<';
          else RoundDir := '=';
        end;
        TheAmount := ROUND (TheAmount, RoundPrec, RoundDir);
        
        exit (TheAmount);

    end;
}

