Table 52092158 "Payroll-Loan Entry"
{
    DrillDownPageID = "Payroll-Loan Entries";

    fields
    {
        field(1;"Payroll Period";Code[10])
        {
        }
        field(2;"Employee No.";Code[20])
        {
            NotBlank = true;
            TableRelation = "Payroll-Employee";
        }
        field(3;"E/D Code";Code[20])
        {
            NotBlank = true;
            SQLDataType = Variant;
            TableRelation = "Payroll-E/D";
        }
        field(4;"Loan ID";Code[10])
        {
            Editable = true;
            TableRelation = "Payroll-Loan";
        }
        field(5;Amount;Decimal)
        {
            DecimalPlaces = 2:2;
        }
        field(6;Status;Option)
        {
            Editable = false;
            OptionMembers = " ",Journal,Posted;
        }
        field(7;"Entry Type";Option)
        {
            OptionCaption = 'Cost Amount,Payroll Deduction,Settlement,Adjustment';
            OptionMembers = "Cost Amount","Payroll Deduction",Settlement,Adjustment;
        }
        field(8;Date;Date)
        {
        }
        field(9;"Entry No.";Integer)
        {
            Editable = true;
        }
        field(10;"Cust. Ledger Entry No.";Integer)
        {
            BlankZero = true;
            Editable = false;
        }
        field(11;"Amount Type";Option)
        {
            OptionCaption = 'Loan Amount,Interest Amount';
            OptionMembers = "Loan Amount","Interest Amount";
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Payroll Period","Employee No.","E/D Code","Loan ID","Entry Type",Date,"Amount Type")
        {
            SumIndexFields = Amount;
        }
        key(Key3;"Cust. Ledger Entry No.")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /*CASE "Entry Type" OF
          "Entry Type"::"Cost Amount" : BEGIN
            ERROR('Loan Amount entry cannot be deleted!');
          END;
          "Entry Type"::Adjustment : BEGIN
            ERROR('Adjustment Amount entry cannot be deleted from the payroll-loan entries!');
          END;
          "Entry Type"::"Payroll Deduction" : BEGIN
            // adjust payslip lines
            IF ProllPslipLine.GET("Payroll Period","Employee No.","E/D Code") THEN BEGIN
              ProllPslipHeader.GET(ProllPslipLine."Payroll Period",ProllPslipLine."Employee No");
              ProllPslipHeader.TESTFIELD(ProllPslipHeader."Closed?",FALSE);
              ProllPslipLine.Amount := ProllPslipLine.Amount + Amount;
              ProllPslipLine.MODIFY;
            END;
          END;
        END;
        
        // adjust loan card
        ProllLoan.GET("Loan ID");
        ProllLoan.CALCFIELDS(ProllLoan."Remaining Amount");
        ProllLoan."Open(Y/N)" := (ProllLoan."Remaining Amount" <> 0);
        ProllLoan.MODIFY;*/

    end;

    trigger OnModify()
    begin
        /*IF (Amount <> xRec.Amount) THEN BEGIN
        
          CASE "Entry Type" OF
            "Entry Type"::"Cost Amount" : BEGIN
              ERROR('Loan Amount entry cannot be changed!');
            END;
            "Entry Type"::"Payroll Deduction" : BEGIN
              // adjust payslip lines
              ProllPslipLine.GET("Payroll Period","Employee No.","E/D Code");
              ProllPslipHeader.GET(ProllPslipLine."Payroll Period",ProllPslipLine."Employee No");
              ProllPslipHeader.TESTFIELD(ProllPslipHeader."Closed?",FALSE);
        
              ProllPslipLine.Amount := ProllPslipLine.Amount + xRec.Amount - Amount;
              ProllPslipLine.MODIFY;
            END;
            "Entry Type"::Adjustment : BEGIN
              ERROR('Adjustment Amount entry cannot be changed from the payroll-loan entries!');
            END;
            "Entry Type"::Settlement : BEGIN
              TESTFIELD("Cust. Ledger Entry No.");
              CustLedgEntry.GET("Cust. Ledger Entry No.");
              ProllLoanEntry.SETCURRENTKEY("Cust. Ledger Entry No.");
              ProllLoanEntry.SETRANGE("Cust. Ledger Entry No.","Cust. Ledger Entry No.");
              ProllLoanEntry.CALCSUMS(Amount);
              CustLedgEntry.CALCFIELDS("Amount (LCY)");
              IF ABS(CustLedgEntry."Amount (LCY)") < (ABS(ProllLoanEntry.Amount) + xRec.Amount - Amount) THEN
                ERROR('Amount on Leger Entry exceeded!');
            END;
          END;
        
          // adjust loan card
          ProllLoan.GET("Loan ID");
          ProllLoan.CALCFIELDS(ProllLoan."Remaining Amount");
          ProllLoan."Open(Y/N)" := (ProllLoan."Remaining Amount" <> 0);
          ProllLoan.MODIFY;
        
        END;*/

    end;

    var
        ProllLoanEntry: Record "Payroll-Loan Entry";
        ProllLoan: Record "Payroll-Loan";
        ProllPslipHeader: Record "Payroll-Payslip Header";
        ProllPslipLine: Record "Payroll-Payslip Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
}

