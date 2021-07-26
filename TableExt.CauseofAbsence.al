TableExtension 52000059 tableextension52000059 extends "Cause of Absence" 
{
    fields
    {
        field(52092186;"No. of Days Allowed";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092187;"Requires Allowance";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092188;"Allowance %";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(52092189;Gender;Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Female,Male';
            OptionMembers = " ",Female,Male;
        }
        field(52092190;"Exempt from  Unknown Pub. Hol.";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092191;"Days Calculation Basis";Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Working Days,Day';
            OptionMembers = "Working Days",Day;
        }
        field(52092192;"Block if Annual Leave Exist";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092193;"Allow Pub. Holiday";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092194;"Roll Over Absence";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(52092195;"Restrict App. to Schedule";Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    procedure GetAvailableDays(YearNo: Integer;EmployeeNo: Code[20]): Decimal
    var
        LeaveScheduleHeader: Record "Leave Schedule Header";
        AvailableDays: Integer;
    begin
        AvailableDays := 0;
        if LeaveScheduleHeader.Get(YearNo,EmployeeNo,Code) then begin
          LeaveScheduleHeader.CalcFields(Balance,"No. of Days Committed");
          AvailableDays := LeaveScheduleHeader.Balance - LeaveScheduleHeader."No. of Days Committed";
        end;
        exit(AvailableDays);
    end;
}

