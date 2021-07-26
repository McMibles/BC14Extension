Table 52092148 "Payroll-Employee Group Header"
{
    // Description
    // Created           : FTN, 12/3/93
    // File name         : KI03 P.Roll Header
    // Comments          : The Header card that is to be used to enter employee
    //                     groups
    // File details      : Primary Key is;
    //                      Code
    //                   : Relations;
    //                      None

    LookupPageID = "Employee Group List";

    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;

            trigger OnValidate()
            begin
                if (1 < CursorPos) and (CursorPos < MaxStrLen(Description)) then
                begin
                  Description := DelChr (CopyStr(Code, CursorPos),'<>');
                  Description := PadStr (Description + ' ' + DelChr (CopyStr(Code, 1, CursorPos-1), '<>'), MaxStrLen(Description));
                end
                else
                   Description := Code;
                   Description := DelChr (Description, '<');
            end;
        }
        field(2;Description;Text[50])
        {
        }
        field(5;"Gross Pay";Decimal)
        {
            CalcFormula = sum("Payroll-Employee Group Line"."Default Amount" where ("Employee Group"=field(Code),
                                                                                    "E/D Code"=const('5')));
            DecimalPlaces = 0:5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(6;"Tax Charged";Decimal)
        {
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(7;"Tax Deducted";Decimal)
        {
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(8;"Taxable Pay";Decimal)
        {
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(9;"Total Deductions";Decimal)
        {
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(10;"Net Pay Due";Decimal)
        {
            DecimalPlaces = 0:5;
            Editable = false;
        }
        field(11;"Employee Category";Code[10])
        {
            TableRelation = "Employee Category";
        }
        field(12;"Currency Code";Code[10])
        {
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
        key(Key2;Description)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        /* Confirm */
        if not Confirm ('All entries for this employee group '+
                        'will be deleted!'+
                        'Proceed with Deletion?    ')
        then
          Error ('Nothing was deleted');
        
        /* Lock 'parent' and 'child' files*/
        if RECORDLEVELLOCKING then begin
         LockTable;
         GrpLinesRec.LockTable;
        end;
        /* First delete the detail lines */
         GrpLinesRec.SetRange("Employee Group", Code);
         GrpLinesRec.DeleteAll;
        
        /* Delete the 'parent record'*/
         Delete;
        
        /* Disable the locking effect */
        Commit ;

    end;

    trigger OnModify()
    begin
        if (GrpCodeRec.Code <> Code) and
             (GrpCodeRec.Code <> '') then begin
            if Confirm(StrSubstNo('Do you want to change %1?',FieldName(Code)),false) then begin
                GrpCodeRec.SetRange(Code,GrpCodeRec.Code);
                Description := GrpCodeRec.Description;
            end;
        end;
    end;

    var
        GrpCodeRec: Record "Payroll-Employee Group Header";
        GrpLinesRec: Record "Payroll-Employee Group Line";
        GrpLinesFirstHalf: Record "Proll-Emply Grp First Half";
        CursorPos: Integer;
        Ok: Boolean;
}

