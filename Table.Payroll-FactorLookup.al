Table 52092153 "Payroll-Factor Lookup"
{
    DrillDownPageID = "Factor Lookup List";
    LookupPageID = "Factor Lookup List";

    fields
    {
        field(1;"Table Id";Code[20])
        {
        }
        field(2;Description;Text[50])
        {
        }
        field(3;"Search Name";Code[20])
        {
        }
        field(4;"Max. Extract Amount";Decimal)
        {
            DecimalPlaces = 0:5;
        }
        field(5;"Min. Extract Amount";Decimal)
        {
            DecimalPlaces = 0:5;
        }
        field(6;"Input Factor";Decimal)
        {
            DecimalPlaces = 0:5;
            InitValue = 1;
            MinValue = 0;
            NotBlank = true;
        }
        field(7;"Output Factor";Decimal)
        {
            DecimalPlaces = 0:5;
            InitValue = 1;
            MinValue = 0;
            NotBlank = true;
        }
        field(8;"Rounding Precision";Decimal)
        {
            DecimalPlaces = 0:5;
            MinValue = 0;
        }
        field(9;"Rounding Direction";Option)
        {
            OptionMembers = Nearest,Higher,Lower;
        }
        field(10;"Calculation Type";Option)
        {
            OptionCaption = ' ,Comparism';
            OptionMembers = " ",Comparism;
        }
        field(11;"Comparism Direction";Option)
        {
            OptionCaption = 'Highest,Lowest';
            OptionMembers = Highest,Lowest;
        }
        field(5000;"Use For Arrears Compt.";Boolean)
        {
            CalcFormula = exist("Payroll-Factor Lookup Line" where ("Table Id"=field("Table Id"),
                                                                    "Factor Basis"=filter("Nos Of Arrears")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Table Id")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ProllEmployee: Record "Payroll-Employee";
        ProllPeriod: Record "Payroll-Period";
        PayslipHeader: Record "Payroll-Payslip Header";
        PayslipLine: Record "Payroll-Payslip Line";
        EmpGrpLine: Record "Payroll-Employee Group Line";
        FactorLookupLine2: Record "Payroll-Factor Lookup Line";
        PayslipFirstHalf: Record "Proll-Pslip Lines First Half";
        FactorLookupLine: Record "Payroll-Factor Lookup Line" temporary;
        EDFileRec: Record "Payroll-E/D";
        TotalAmount: Decimal;
        ContrAmount: Decimal;
        TotalUsed: Decimal;
        CalcFactor: Decimal;
        NoOfMonth: Integer;
        NoOfEntries: Integer;
        PayrollPreviousPeriod: Code[10];
        PayrollFirstPeriod: Code[10];
        PayrollFirstPeriod2: Code[10];
        PayrollPreviousPeriod2: Code[10];
        PayrollPeriod2: Code[10];


    procedure CalcAmount(CurrLineRec: Record "Payroll-Payslip Line";EDCode: Code[20];PayrollPeriod: Code[10];EmployeeNo: Code[20]) RetAmount: Decimal
    begin
        RetAmount := 0;
        PayslipLine.SetRange(PayslipLine."Payroll Period",PayrollPeriod);
        PayslipLine.SetRange(PayslipLine."Employee No.",EmployeeNo);
        if not PayslipLine.Find('-') then
          exit;
        
        PayslipHeader.Get(PayrollPeriod,EmployeeNo);
        
        FactorLookupLine2.Reset;
        FactorLookupLine2.SetRange(FactorLookupLine2."Table Id","Table Id");
        
        if not FactorLookupLine2.Find('-') then
          exit(0);
        
        Clear(FactorLookupLine);
        Clear(ProllEmployee);
        Clear(ProllPeriod);
        
        ProllEmployee.Get(EmployeeNo);
        
        // find previous period
        ProllPeriod.SetCurrentkey("Start Date");
        ProllPeriod.Get(PayrollPeriod);
        ProllPeriod.SetFilter(ProllPeriod."Start Date",'<%1',ProllPeriod."Start Date");
        if ProllPeriod.Find('+') then
          PayrollPreviousPeriod := ProllPeriod."Period Code";
        
        //find year start period
        CalcFields("Use For Arrears Compt.");
        ProllPeriod.Get(PayrollPeriod);
        case "Use For Arrears Compt." of
          false:
            begin
              ProllPeriod.SetRange(ProllPeriod."Start Date",Dmy2date(1,1,Date2dmy(ProllPeriod."Start Date",3)),ProllPeriod."Start Date");
              if ProllPeriod.Find('-') then
                PayrollFirstPeriod := ProllPeriod."Period Code"
              else
                PayrollFirstPeriod := PayrollPeriod;
            end;
          true:
            begin
              PayrollFirstPeriod :=GetStartPeriod(EmployeeNo,PayrollPeriod,PayrollPreviousPeriod);
            end;
        end;
        
        // find current period
        ProllPeriod.Get(PayrollPeriod);
        ProllPeriod.SetRange(ProllPeriod."Start Date",Dmy2date(1,1,Date2dmy(ProllPeriod."Start Date",3)),ProllPeriod."End Date");
        if ProllPeriod.Find('+') then
          PayrollPeriod2 := ProllPeriod."Period Code";
        
        ProllPeriod.Reset;
        ProllPeriod.SetRange(ProllPeriod."Period Code",PayrollFirstPeriod,PayrollPeriod);
        NoOfMonth := ProllPeriod.Count;
        NoOfEntries := ProllPeriod.Count;
        
        TotalAmount := 0;
        
        repeat
          FactorLookupLine.Copy(FactorLookupLine2);
          FactorLookupLine.Amount := 0;
          case FactorLookupLine."Factor Basis" of
            FactorLookupLine."factor basis"::Static:
              begin
                CalcFactor := 1;
              end;
            FactorLookupLine."factor basis"::"Nos Of Arrears":
              begin
                if EmployeeNo<>'' then
                  CalcFactor:= GetArrearCalcFactor(EmployeeNo,PayrollPeriod,PayrollPreviousPeriod)
                else
                  CalcFactor := 0;
              end;
          end;
        
          ProllEmployee.SetRange(ProllEmployee."ED Filter",FactorLookupLine."E/D Code");
          ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollFirstPeriod,PayrollPeriod);
          ProllEmployee.CalcFields(ProllEmployee."No. of Entries",ProllEmployee."Closed No. of Entries");
          NoOfEntries := ProllEmployee."No. of Entries" + ProllEmployee."Closed No. of Entries";
          if (NoOfMonth <> NoOfEntries) and (FactorLookupLine."E/D Code" = CurrLineRec."E/D Code") and
            (not PayslipLine.Get(PayrollPeriod,EmployeeNo,CurrLineRec."E/D Code")) then
            NoOfEntries := NoOfEntries + 1;
          case FactorLookupLine."Entry Type" of
            FactorLookupLine."entry type"::Cummulative : begin
             case FactorLookupLine."Cummulative Period" of
              FactorLookupLine."cummulative period"::"Current Period" : begin
                //Set range for the period start to current perion end date
                ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollFirstPeriod,PayrollPeriod);
        
                 // include special payroll
                 if FactorLookupLine."Incl. Special Payroll" and
                    (PayrollFirstPeriod2 <> '') and (PayrollFirstPeriod2 <= PayrollPeriod2) then
                   ProllEmployee.SetFilter(ProllEmployee."Period Filter",'%1..%2|%3..%4',PayrollFirstPeriod,PayrollPeriod,
                                           PayrollFirstPeriod2,PayrollPeriod2);
                 case FactorLookupLine.Projection of
                   FactorLookupLine.Projection::"Current Month" :
                     CalcFactor := NoOfEntries;
                   FactorLookupLine.Projection::Annual :
                     if NoOfEntries <> 0 then
                       CalcFactor := 12 / NoOfEntries
                     else
                       CalcFactor := 0;
                 end; /*end case*/
               end;
              FactorLookupLine."cummulative period"::"Previous Period" : begin
                 ProllEmployee.SetFilter(ProllEmployee."Period Filter",'>=%1&<%2',PayrollFirstPeriod,PayrollPeriod);
                 // include special payroll
                 if FactorLookupLine."Incl. Special Payroll" and
                    (PayrollFirstPeriod2 <> '') and (PayrollFirstPeriod2 <= PayrollPreviousPeriod2) then
                   ProllEmployee.SetFilter(ProllEmployee."Period Filter",'>=%1&<%2|>=%3&<%4',PayrollFirstPeriod,PayrollPeriod,
                                           PayrollFirstPeriod2,PayrollPeriod2);
        
                 case FactorLookupLine.Projection of
                   FactorLookupLine.Projection::"Current Month" :
                     CalcFactor := NoOfEntries - 1;
                   FactorLookupLine.Projection::Annual :
                     if NoOfMonth > 1 then
                       CalcFactor := 12 / (NoOfEntries - 1)
                     else
                       CalcFactor := 12;
                     /*CalcFactor := 12 / (NoOfEntries - 1);*/
                 end; /*end case*/
              end;
              FactorLookupLine."cummulative period"::All : begin
                 //Set range for the period start to current perion end date
                 ProllEmployee.SetRange(ProllEmployee."Period Filter");
                 ProllEmployee.SetFilter(ProllEmployee."Period Filter",'..%1',PayrollPeriod);
        
                 case FactorLookupLine.Projection of
                   FactorLookupLine.Projection::"Current Month" :
                     CalcFactor := NoOfEntries;
                   FactorLookupLine.Projection::Annual :
                     if NoOfEntries <> 0 then
                       CalcFactor := 12 / NoOfEntries
                     else
                       CalcFactor := 0;
                 end; /*end case*/
               end;
              FactorLookupLine."cummulative period"::"Balance at Previous": begin
                 //Set range for the period start to current perion end date
                 ProllEmployee.SetRange(ProllEmployee."Period Filter");
                 ProllEmployee.SetFilter(ProllEmployee."Period Filter",'..%1',PayrollPreviousPeriod);
                 case FactorLookupLine.Projection of
                   FactorLookupLine.Projection::"Current Month" :
                     CalcFactor := NoOfEntries;
                   FactorLookupLine.Projection::Annual :
                     if NoOfEntries <> 0 then
                       CalcFactor := 12 / NoOfEntries
                     else
                       CalcFactor := 0;
                 end; /*end case*/
               end;
        
               else;
             end; /*end case*/
           end;
           FactorLookupLine."entry type"::Actual : begin
             ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollPeriod);
             case FactorLookupLine.Projection of
               FactorLookupLine.Projection::"Current Month" :
                 CalcFactor := NoOfEntries;
               FactorLookupLine.Projection::Annual :
                 CalcFactor := 12;
             end; /*end case*/
           end;
           FactorLookupLine."entry type"::Previous : begin
             ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollPreviousPeriod);
             case FactorLookupLine.Projection of
               FactorLookupLine.Projection::"Current Month" :
                 CalcFactor := NoOfEntries;
               FactorLookupLine.Projection::Annual :
                 CalcFactor := 12;
             end; /*end case*/
           end;
           FactorLookupLine."entry type"::Annual : begin
             ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollPeriod);
             CalcFactor := 12;
           end;
           FactorLookupLine."entry type"::"First Half" : begin
             ProllEmployee.SetRange(ProllEmployee."Period Filter");
             ProllEmployee.SetFilter(ProllEmployee."Period Filter",'..%1',PayrollPeriod);
             case FactorLookupLine.Projection of
               FactorLookupLine.Projection::"Current Month" :
                 CalcFactor := NoOfEntries;
               FactorLookupLine.Projection::Annual :
                 CalcFactor := 12;
             end; /*end case*/
           end;
          end; /*end case*/
        
          if FactorLookupLine."Use Arrears Amount" then begin
            ProllEmployee.CalcFields(ProllEmployee."EDFirstHalf ArAmount");
            ContrAmount := ProllEmployee."EDFirstHalf ArAmount";
          end else begin
            ProllEmployee.CalcFields(ProllEmployee."ED Amount",ProllEmployee."ED Closed Amount");
            ContrAmount := ProllEmployee."ED Amount" + ProllEmployee."ED Closed Amount";
          end;
        
          if (NoOfMonth <> ProllEmployee."No. of Entries") and (FactorLookupLine."E/D Code" = CurrLineRec."E/D Code") and
            (not PayslipLine.Get(PayrollPeriod,EmployeeNo,CurrLineRec."E/D Code")) and
            (StrPos(ProllEmployee.GetFilter(ProllEmployee."Period Filter"),PayrollPeriod) <> 0) then
            ContrAmount := (ContrAmount + CurrLineRec.Amount) * CalcFactor
          else
            ContrAmount := ContrAmount * CalcFactor;
        
          // take a percentage
          if FactorLookupLine.Percentage <> 0 then
            ContrAmount := ContrAmount * FactorLookupLine.Percentage / 100;
          // check for max./min.
          if (FactorLookupLine."Max. Amount" <> 0) and (ContrAmount > FactorLookupLine."Max. Amount") then
            ContrAmount := FactorLookupLine."Max. Amount"
          else
            if (FactorLookupLine."Min. Amount" <> 0) and (FactorLookupLine."Min. Amount" > ContrAmount) then
              ContrAmount := FactorLookupLine."Min. Amount";
            if FactorLookupLine."Add/Subtract" = FactorLookupLine."add/subtract"::Subtract then
              ContrAmount := ContrAmount * (-1);
        
          FactorLookupLine.Amount := ContrAmount;
        
          TotalAmount := TotalAmount + ContrAmount;
        
          FactorLookupLine.Insert;
        until FactorLookupLine2.Next = 0;
        
        TotalUsed := TotalAmount;
        if ("Max. Extract Amount" <> 0) and (TotalAmount > "Max. Extract Amount") then
          TotalUsed := "Max. Extract Amount"
        else
          if ("Min. Extract Amount" <> 0) and ("Min. Extract Amount" > TotalAmount) then
          TotalUsed := "Min. Extract Amount";
        
        FactorLookupLine.Find('-');
        if (TotalAmount <> 0) then
          case "Calculation Type" of
            0: begin
              repeat
                if FactorLookupLine.Amount <> 0 then
                  RetAmount := RetAmount + ((FactorLookupLine.Amount / TotalAmount) * TotalUsed ) /
                               FactorLookupLine.Factor;
              until FactorLookupLine.Next = 0;
            end;
            1: begin
              repeat
                case "Comparism Direction" of
                  0: begin
                    FactorLookupLine.SetCurrentkey(Amount);
                    FactorLookupLine.Ascending(true);
                    FactorLookupLine.FindLast;
                    RetAmount := FactorLookupLine.Amount;
                  end;
                  1: begin
                    FactorLookupLine.SetCurrentkey(Amount);
                    FactorLookupLine.Ascending(false);
                    FactorLookupLine.FindLast;
                    RetAmount := FactorLookupLine.Amount;
                  end;
                end
              until FactorLookupLine.Next = 0;
            end;
          end;
        FactorLookupLine.DeleteAll;

    end;


    procedure CalcAmount2(EDCode: Code[20];EmployeeGroup: Code[20];StaffCategory: Code[10]) RetAmount: Decimal
    begin
        RetAmount := 0;
        EDFileRec.Get(EDCode) ;
        if EDFileRec.Arrear then
         exit(0);
        FactorLookupLine2.Reset;
        FactorLookupLine2.SetRange(FactorLookupLine2."Table Id","Table Id");
        if not FactorLookupLine2.Find('-') then
          exit;
        
        Clear(FactorLookupLine);
        
        EmpGrpLine.SetRange(EmpGrpLine."Employee Group",EmployeeGroup);
        FactorLookupLine2.SetFilter(FactorLookupLine2."Employee Category",StaffCategory);
        
        if not EmpGrpLine.Find('-') then exit;
        
        TotalAmount := 0;
        
        repeat
          FactorLookupLine.Copy(FactorLookupLine2);
          FactorLookupLine.Amount := 0;
          case FactorLookupLine."Factor Basis" of
            FactorLookupLine."factor basis"::Static:
              begin
                CalcFactor := 1;
              end;
            FactorLookupLine."factor basis"::"Nos Of Arrears":
              begin
                if PayslipHeader."Employee No."<>'' then
                  CalcFactor:= GetArrearCalcFactor(PayslipHeader."Employee No.",PayslipHeader."Payroll Period",PayrollPreviousPeriod)
                else
                  CalcFactor:=0;
              end;
          end;
        
          if EmpGrpLine.Get(EmployeeGroup,FactorLookupLine."E/D Code") then begin
        
            case FactorLookupLine."Entry Type" of
             FactorLookupLine."entry type"::Cummulative : begin
               case FactorLookupLine."Cummulative Period" of
                 FactorLookupLine."cummulative period"::"Current Period" : begin
                   case FactorLookupLine.Projection of
                     FactorLookupLine.Projection::"Current Month" :
                       CalcFactor := 1;
                     FactorLookupLine.Projection::Annual :
                       CalcFactor := 12;
                   end; /*end case*/
                 end;
                 FactorLookupLine."cummulative period"::"Previous Period" : begin
                   case FactorLookupLine.Projection of
                     FactorLookupLine.Projection::"Current Month" :
                       CalcFactor := 0;
                     FactorLookupLine.Projection::Annual :
                       CalcFactor := 12;
                   end; /*end case*/
                 end;
                 else;
               end; /*end case*/
             end;
             FactorLookupLine."entry type"::Actual : begin
               case FactorLookupLine.Projection of
                 FactorLookupLine.Projection::"Current Month" :
                   CalcFactor := 1;
                 FactorLookupLine.Projection::Annual :
                   CalcFactor := 12;
               end; /*end case*/
             end;
             FactorLookupLine."entry type"::Previous : begin
               case FactorLookupLine.Projection of
                 FactorLookupLine.Projection::"Current Month" :
                   CalcFactor := 1;
                 FactorLookupLine.Projection::Annual :
                   CalcFactor := 12;
               end; /*end case*/
             end;
             FactorLookupLine."entry type"::Annual : begin
               CalcFactor := 12;
             end;
            end; /*end case*/
        
            ContrAmount := EmpGrpLine."Default Amount" * CalcFactor;
        
            // take a percentage
            if FactorLookupLine.Percentage <> 0 then
              ContrAmount := ContrAmount * FactorLookupLine.Percentage / 100;
            // check for max./min.
            if (FactorLookupLine."Max. Amount" <> 0) and (ContrAmount > FactorLookupLine."Max. Amount") then
              ContrAmount := FactorLookupLine."Max. Amount"
            else
              if FactorLookupLine."Min. Amount" > ContrAmount then
                ContrAmount := FactorLookupLine."Min. Amount";
              if FactorLookupLine."Add/Subtract" = FactorLookupLine."add/subtract"::Subtract then
                ContrAmount := ContrAmount * (-1);
        
            FactorLookupLine.Amount := ContrAmount;
        
            TotalAmount := TotalAmount + ContrAmount;
        
            FactorLookupLine.Insert;
          end;
        
        until FactorLookupLine2.Next = 0;
        
        TotalUsed := TotalAmount;
        if ("Max. Extract Amount" <> 0) and (TotalAmount > "Max. Extract Amount") then
          TotalUsed := "Max. Extract Amount"
        else
          if ("Min. Extract Amount" <> 0) and ("Min. Extract Amount" > TotalAmount) then
          TotalUsed := "Min. Extract Amount";
        
        FactorLookupLine.Find('-');
        if (TotalAmount <> 0) then
          case "Calculation Type" of
            0: begin
              repeat
                if FactorLookupLine.Amount <> 0 then
                  RetAmount := RetAmount + ((FactorLookupLine.Amount / TotalAmount) * TotalUsed ) /
                               FactorLookupLine.Factor;
              until FactorLookupLine.Next = 0;
            end;
            1: begin
              repeat
                case "Comparism Direction" of
                  0: begin
                    FactorLookupLine.SetCurrentkey(Amount);
                    FactorLookupLine.Ascending(true);
                    FactorLookupLine.FindLast;
                    RetAmount := FactorLookupLine.Amount;
                  end;
                  1: begin
                    FactorLookupLine.SetCurrentkey(Amount);
                    FactorLookupLine.Ascending(false);
                    FactorLookupLine.FindLast;
                    RetAmount := FactorLookupLine.Amount;
                  end;
                end
              until FactorLookupLine.Next = 0;
            end;
          end;
        
        FactorLookupLine.DeleteAll;

    end;


    procedure CheckForFactor(EDCode: Code[20]): Boolean
    begin
        FactorLookupLine2.SetRange(FactorLookupLine2."Table Id","Table Id");
        FactorLookupLine2.SetRange(FactorLookupLine2."E/D Code",EDCode);
        FactorLookupLine2.SetFilter(FactorLookupLine2."Entry Type",'<>%1&<>%2',FactorLookupLine2."entry type"::Previous,
                                    FactorLookupLine2."entry type"::"First Half");
        if FactorLookupLine2.Find('-') then begin
          case FactorLookupLine2."Entry Type" of
            FactorLookupLine2."entry type"::Cummulative : begin
              if FactorLookupLine2."Cummulative Period" in [2] then
                exit (false)
              else
                exit (true);
            end;
              else exit (true);
          end; /*end case*/
        end else
          exit (false);

    end;


    procedure CalcAmount1(CurrLineRec: Record "Proll-Pslip Lines First Half";EDCode: Code[20];PayrollPeriod: Code[10];EmployeeNo: Code[20];ArrType: Option Salary,Promotion) RetAmount: Decimal
    begin
        RetAmount := 0;
        
        PayslipFirstHalf.SetRange(PayslipFirstHalf."Payroll Period",PayrollPeriod);
        PayslipFirstHalf.SetRange("Arrear Type",ArrType);
        PayslipFirstHalf.SetRange(PayslipFirstHalf."Employee No.",EmployeeNo);
        if not PayslipFirstHalf.Find('-') then
          exit;
        
        FactorLookupLine2.Reset;
        FactorLookupLine2.SetRange(FactorLookupLine2."Table Id","Table Id");
        if not FactorLookupLine2.Find('-') then
          exit;
        
        Clear(FactorLookupLine);
        Clear(ProllEmployee);
        
        ProllEmployee.Get(EmployeeNo);
        // find previous period
        ProllPeriod.SetCurrentkey("Start Date");
        ProllPeriod.Get(PayrollPeriod);
        ProllPeriod.SetFilter(ProllPeriod."Start Date",'<%1',ProllPeriod."Start Date");
        if ProllPeriod.Find('+') then
          PayrollPreviousPeriod := ProllPeriod."Period Code";
        
        //find year start period
        CalcFields("Use For Arrears Compt.");
        ProllPeriod.Get(PayrollPeriod);
        case "Use For Arrears Compt." of
          false:
            begin
              ProllPeriod.SetRange(ProllPeriod."Start Date",Dmy2date(1,1,Date2dmy(ProllPeriod."Start Date",3)),ProllPeriod."Start Date");
              if ProllPeriod.Find('-') then
                PayrollFirstPeriod := ProllPeriod."Period Code"
              else
                PayrollFirstPeriod := PayrollPeriod;
            end;
          true:
            begin
              PayrollFirstPeriod :=GetStartPeriod(PayslipFirstHalf."Employee No.",PayslipFirstHalf."Payroll Period",PayrollPreviousPeriod);
            end;
        end;
        
        // find current period
        ProllPeriod.Get(PayrollPeriod);
        ProllPeriod.SetRange(ProllPeriod."Start Date",Dmy2date(1,1,Date2dmy(ProllPeriod."Start Date",3)),ProllPeriod."End Date");
        if ProllPeriod.Find('+') then
          PayrollPeriod2 := ProllPeriod."Period Code";
        
        
        ProllPeriod.Reset;
        ProllPeriod.SetRange(ProllPeriod."Period Code",PayrollFirstPeriod,PayrollPeriod);
        NoOfMonth := ProllPeriod.Count;
        NoOfEntries := ProllPeriod.Count;
        
        TotalAmount := 0;
        
        repeat
          FactorLookupLine.Copy(FactorLookupLine2);
          FactorLookupLine.Amount := 0;
          case FactorLookupLine."Factor Basis" of
            FactorLookupLine."factor basis"::Static:
              begin
                CalcFactor := 1;
              end;
            FactorLookupLine."factor basis"::"Nos Of Arrears":
              begin
                CalcFactor:= GetArrearCalcFactor(PayslipFirstHalf."Employee No.",PayslipFirstHalf."Payroll Period",PayrollPreviousPeriod);
              end;
          end;
        
          ProllEmployee.SetRange(ProllEmployee."ED Filter",FactorLookupLine."E/D Code");
          ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollFirstPeriod,PayrollPeriod);
          ProllEmployee.SetRange(ProllEmployee."Arrear Type Filter",ArrType);
          ProllEmployee.CalcFields(ProllEmployee."No. of Entries");
          NoOfEntries := ProllEmployee."No. of Entries";
          if (NoOfMonth <> NoOfEntries) and (FactorLookupLine."E/D Code" = CurrLineRec."E/D Code") and
            (not PayslipFirstHalf.Get(PayrollPeriod,ArrType,EmployeeNo,CurrLineRec."E/D Code")) then
            NoOfEntries := NoOfEntries + 1;
          case FactorLookupLine."Entry Type" of
           FactorLookupLine."entry type"::Cummulative : begin
             case FactorLookupLine."Cummulative Period" of
               FactorLookupLine."cummulative period"::"Current Period" : begin
                 ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollFirstPeriod,PayrollPeriod);
                 case FactorLookupLine.Projection of
                   FactorLookupLine.Projection::"Current Month" :
                     CalcFactor := NoOfEntries;
                   FactorLookupLine.Projection::Annual :
                     if NoOfEntries <> 0 then
                       CalcFactor := 12 / NoOfEntries
                     else
                       CalcFactor := 0;
                 end; /*end case*/
               end;
               FactorLookupLine."cummulative period"::"Previous Period" : begin
                 ProllEmployee.SetFilter(ProllEmployee."Period Filter",'>=%1&<%2',PayrollFirstPeriod,PayrollPeriod);
                 case FactorLookupLine.Projection of
                   FactorLookupLine.Projection::"Current Month" :
                     CalcFactor := NoOfEntries - 1;
                   FactorLookupLine.Projection::Annual :
                     if NoOfMonth > 1 then
                       CalcFactor := 12 / (NoOfEntries - 1)
                     else
                       CalcFactor := 12;
                     /*CalcFactor := 12 / (NoOfEntries - 1);*/
                 end; /*end case*/
               end;
               else;
             end; /*end case*/
           end;
           FactorLookupLine."entry type"::Actual : begin
             ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollPeriod);
             case FactorLookupLine.Projection of
               FactorLookupLine.Projection::"Current Month" :
                 CalcFactor := NoOfEntries;
               FactorLookupLine.Projection::Annual :
                 CalcFactor := 12;
             end; /*end case*/
           end;
           FactorLookupLine."entry type"::Previous : begin
             ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollPreviousPeriod);
             case FactorLookupLine.Projection of
               FactorLookupLine.Projection::"Current Month" :
                 CalcFactor := NoOfEntries;
               FactorLookupLine.Projection::Annual :
                 CalcFactor := 12;
             end; /*end case*/
           end;
           FactorLookupLine."entry type"::Annual : begin
             ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollPeriod);
             CalcFactor := 12;
           end;
           FactorLookupLine."entry type"::"First Half" : begin
             ProllEmployee.SetRange(ProllEmployee."Period Filter",PayrollPeriod);
             case FactorLookupLine.Projection of
               FactorLookupLine.Projection::"Current Month" :
                 CalcFactor := NoOfEntries;
               FactorLookupLine.Projection::Annual :
                 CalcFactor := 12;
             end; /*end case*/
           end;
          end; /*end case*/
        
          ProllEmployee.CalcFields(ProllEmployee."EDFirstHalf Amount");
          if (NoOfMonth <> ProllEmployee."No. of Entries") and (FactorLookupLine."E/D Code" = CurrLineRec."E/D Code") and
            (not PayslipFirstHalf.Get(PayrollPeriod,ArrType,EmployeeNo,CurrLineRec."E/D Code")) and
            (StrPos(ProllEmployee.GetFilter(ProllEmployee."Period Filter"),PayrollPeriod) <> 0) then
            ContrAmount := (ProllEmployee."EDFirstHalf Amount" + CurrLineRec.Amount) * CalcFactor
          else
            ContrAmount := ProllEmployee."EDFirstHalf Amount" * CalcFactor;
        
          // take a percentage
          if FactorLookupLine.Percentage <> 0 then
            ContrAmount := ContrAmount * FactorLookupLine.Percentage / 100;
          // check for max./min.
          if (FactorLookupLine."Max. Amount" <> 0) and (ContrAmount > FactorLookupLine."Max. Amount") then
            ContrAmount := FactorLookupLine."Max. Amount"
          else
            if (FactorLookupLine."Min. Amount" <> 0) and (FactorLookupLine."Min. Amount" > ContrAmount) then
              ContrAmount := FactorLookupLine."Min. Amount";
            if FactorLookupLine."Add/Subtract" = FactorLookupLine."add/subtract"::Subtract then
              ContrAmount := ContrAmount * (-1);
        
          FactorLookupLine.Amount := ContrAmount;
        
          TotalAmount := TotalAmount + ContrAmount;
        
          FactorLookupLine.Insert;
        until FactorLookupLine2.Next = 0;
        
        TotalUsed := TotalAmount;
        if ("Max. Extract Amount" <> 0) and (TotalAmount > "Max. Extract Amount") then
          TotalUsed := "Max. Extract Amount"
        else
          if ("Min. Extract Amount" <> 0) and ("Min. Extract Amount" > TotalAmount) then
          TotalUsed := "Min. Extract Amount";
        
        FactorLookupLine.Find('-');
        if (TotalAmount <> 0) then
          case "Calculation Type" of
            0: begin
              repeat
                if FactorLookupLine.Amount <> 0 then
                  RetAmount := RetAmount + ((FactorLookupLine.Amount / TotalAmount) * TotalUsed ) /
                               FactorLookupLine.Factor;
              until FactorLookupLine.Next = 0;
            end;
            1: begin
              repeat
                case "Comparism Direction" of
                  0: begin
                    FactorLookupLine.SetCurrentkey(Amount);
                    FactorLookupLine.Ascending(true);
                    FactorLookupLine.FindLast;
                    RetAmount := FactorLookupLine.Amount;
                  end;
                  1: begin
                    FactorLookupLine.SetCurrentkey(Amount);
                    FactorLookupLine.Ascending(false);
                    FactorLookupLine.FindLast;
                    RetAmount := FactorLookupLine.Amount;
                  end;
                end
              until FactorLookupLine.Next = 0;
            end;
          end;
        
        FactorLookupLine.DeleteAll;
        
        
        //COMMIT;

    end;

    local procedure GetStartPeriod(EmployeeNo: Code[20];PayrollPeriod: Code[10];PreviousPeriodCode: Code[10]): Code[20]
    var
        CurrLineRec: Record "Payroll-Payslip Line";
        EDCode: Code[20];
        CurrPayslipHeader: Record "Payroll-Payslip Header";
        PayrollPeriodRec: Record "Payroll-Period";
        EmpSalGrp: Code[20];
        PreviousPeriod: Record "Payroll-Period";
    begin
        if PreviousPeriod.Get(PreviousPeriodCode)then
          begin
            CurrPayslipHeader.Get(PayrollPeriod,EmployeeNo);
            if CurrPayslipHeader.FindLast then
              begin
                PayrollPeriodRec.SetFilter("Start Date",'>=%1',CurrPayslipHeader."Effective Date Of Salary Group");
                PayrollPeriodRec.SetFilter("End Date",'<=%1',PreviousPeriod."End Date");
                if PayrollPeriodRec.FindFirst then
                  exit(PayrollPeriodRec."Period Code");
              end;
            end;
    end;

    local procedure GetArrearCalcFactor(EmployeeNo: Code[20];PayrollPeriod: Code[10];PreviousPeriodCode: Code[10]): Integer
    var
        CurrLineRec: Record "Payroll-Payslip Line";
        EDCode: Code[20];
        CurrPayslipHeader: Record "Payroll-Payslip Header";
        PayrollPeriodRec: Record "Payroll-Period";
        EmpSalGrp: Code[20];
        CalenderDate: Record Date;
        PreviousPeriod: Record "Payroll-Period";
        CountPayrollPeriodRec: Record "Payroll-Period";
        ClosedPayrollPayslipHeader: Record "Closed Payroll-Payslip Header";
    begin
        if PreviousPeriod.Get(PreviousPeriodCode) then
          begin
            CurrPayslipHeader.Get(PayrollPeriod,EmployeeNo);
            if CurrPayslipHeader.FindLast then
              begin
                PayrollPeriodRec.SetFilter("Start Date",'>=%1',CurrPayslipHeader."Effective Date Of Salary Group");
                PayrollPeriodRec.SetFilter("End Date",'<=%1',PreviousPeriod."End Date");
                if PayrollPeriodRec.FindFirst then
                  begin
                    ClosedPayrollPayslipHeader.SetRange("Employee No.",EmployeeNo);
                    ClosedPayrollPayslipHeader.SetRange("Payroll Period",PayrollPeriodRec."Period Code",PreviousPeriod."Period Code");
                    exit(ClosedPayrollPayslipHeader.Count);
                  end;
              end;
          end;
          exit(0);
    end;
}

