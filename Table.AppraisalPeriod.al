Table 52092229 "Appraisal Period"
{
    DrillDownPageID = "Appraisal Periods";
    LookupPageID = "Appraisal Periods";

    fields
    {
        field(1;"Period Code";Code[20])
        {
        }
        field(2;"Start Date";Date)
        {

            trigger OnValidate()
            begin
                Validate("Period Description",StrSubstNo(Text005,Format("Start Date",0,'<Day,2>-<Month Text,3>-<Year4>'),
                                                   Format("End Date",0,'<Day,2>-<Month Text,3>-<Year4>')));
                Year := Date2dmy("Start Date",3);
                ValidatePeriodEndDate;
            end;
        }
        field(3;"End Date";Date)
        {

            trigger OnValidate()
            begin
                Validate("Period Description",StrSubstNo(Text005,Format("Start Date",0,'<Day,2>-<Month Text,3>-<Year4>'),
                                                   Format("End Date",0,'<Day,2>-<Month Text,3>-<Year4>')));
            end;
        }
        field(4;"Period Description";Text[50])
        {

            trigger OnValidate()
            begin
                if (1 < CursorPos) and (CursorPos < MaxStrLen("Search Name")) then
                begin
                  "Search Name" := DelChr (CopyStr("Period Description", CursorPos),'<>');
                  "Search Name" := PadStr ("Search Name" + ' ' + DelChr (CopyStr("Period Description", 1, CursorPos-1), '<>'),
                          MaxStrLen("Search Name"));
                end
                else
                  "Search Name" := "Period Description";
            end;
        }
        field(5;Closed;Boolean)
        {
        }
        field(6;"Search Name";Text[50])
        {
        }
        field(7;"Appraisal Type";Option)
        {
            OptionCaption = 'Mid-Year,Year End,Monthly,Quarterly';
            OptionMembers = "Mid-Year","Year End",Monthly,Quarterly;

            trigger OnValidate()
            begin
                ValidatePeriodEndDate;
            end;
        }
        field(8;Year;Integer)
        {
        }
        field(9;"Entries Exist";Boolean)
        {
            CalcFormula = exist("Appraisal Header" where ("Appraisal Period"=field("Period Code"),
                                                          "Appraisal Type"=field("Appraisal Type")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Period Code","Appraisal Type")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CalcFields("Entries Exist");
        if "Entries Exist" then
          Error(Text001);
    end;

    trigger OnModify()
    begin
        TestField(Closed,false);
    end;

    var
        Text001: label 'Appraisal period cannnot be deleted!';
        Text005: label 'Appraisal from %1 to %2';
        CursorPos: Integer;

    local procedure ValidatePeriodEndDate()
    var
        AppraisalPeriod: Record "Appraisal Period";
    begin
        if "Start Date"<>0D then
          begin
            case "Appraisal Type" of
              "appraisal type"::"Mid-Year":
                begin
                  Validate("End Date",CalcDate('6M-1D',"Start Date"));
                end;
              "appraisal type"::Monthly:
                begin
                  Validate("End Date",CalcDate('1M-1D',"Start Date"));
                end;
              "appraisal type"::Quarterly:
                begin
                  Validate("End Date",CalcDate('3M-1D',"Start Date"));
                end;
              "appraisal type"::"Year End":
                begin
                  Validate("End Date",CalcDate('12M-1D',"Start Date"));
                end;
            end;
          end;
    end;
}

