Page 52092375 "Interviewer Score Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = Interviewer;
    SourceTableView = where("Schedule Closed"=const(false));

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field(ScheduleCode;"Schedule Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeCode;"Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000005;"Interviewer Score SubForm")
            {
                Caption = 'Interviewer Score';
                SubPageLink = "Ref. No."=field("Schedule Code"),
                              "Interviewer Code"=field("Employee Code");
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetRange("Employee Code");
        HRSetup.Get;
        case HRSetup."Interview Score Recording" of
          0:begin
            FilterGroup(2);
            if UserSetup.Get(UserId) then begin
              UserSetup.TestField(UserSetup."Employee No.");
              SetRange("Employee Code",UserSetup."Employee No.");
            end else
              Error(Text001);
            FilterGroup(0);
          end;
          1: SetRange("Employee Code");
        end;
    end;

    var
        UserSetup: Record "User Setup";
        Text001: label 'Sorry no  score card available!';
        HRSetup: Record "Human Resources Setup";
}

