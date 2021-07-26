Page 52092352 "Leave Schedule Header"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Leave Schedule Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = false;
                field(YearNo;"Year No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeNo;"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field(EmployeeName;"Employee Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Employee Name';
                }
                field(ManagerNo;"Manager No.")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code;"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code;"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysBF;"No. of Days B/F")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysEntitled;"No. of Days Entitled")
                {
                    ApplicationArea = Basic;
                }
                field(NoofDaysAdded;"No. of Days Added")
                {
                    ApplicationArea = Basic;
                }
                field("<No. of Days Subtracted>";"No. of Days Subtracted")
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of Days Subtracted';
                }
                field(NoofDaysUtilised;"No. of Days Utilised")
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000011;"Leave Schedule Line")
            {
                Editable = "Schedule Line Editable" ;
                SubPageLink = "Year No."=field("Year No."),
                              "Employee No."=field("Employee No."),
                              "Absence Code"=field("Absence Code");
            }
        }
        area(factboxes)
        {
            part(Control2;"Leave FactBox")
            {
                SubPageLink = "Year No."=field("Year No."),
                              "Employee No."=field("Employee No.");
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        EnableFields;
    end;

    trigger OnInit()
    begin
        "Schedule Line Editable" := true;
    end;

    trigger OnOpenPage()
    begin
        HRSetup.Get;
        SetRange("Absence Code",HRSetup."Annual Leave Code");
        FilterGroup(2);
        SetRange("Absence Code",HRSetup."Annual Leave Code");
        FilterGroup(0);
        SetFilter("Year Filter",'..%1',Date2dmy(Today,3) - 1);
    end;

    var
        HRSetup: Record "Human Resources Setup";
        UserSetup: Record "User Setup";
        Employee: Record Employee;
        EmployeeName: Text[200];
        [InDataSet]
        "Schedule Line Editable": Boolean;
        CalledFromApproval: Boolean;


    procedure EnableFields()
    begin
        if Status in [1,2] then
          "Schedule Line Editable" := false
        else
          "Schedule Line Editable" := true;
    end;


    procedure SetCalledFromApproval()
    begin
        CalledFromApproval := true;
    end;
}

