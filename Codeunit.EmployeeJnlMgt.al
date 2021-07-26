Codeunit 52092190 EmployeeJnlMgt
{

    trigger OnRun()
    begin
    end;


    procedure OpenEmployeeJournal(var BatchName: Code[20])
    var
        EmployeeJournal: Record "Employee Update Line";
    begin
        EmployeeJournal.FilterGroup := 2;
        EmployeeJournal.SetRange(EmployeeJournal."Document No.",BatchName);
        EmployeeJournal.FilterGroup := 0;

        EmployeeJournal."Document No." := BatchName;
        Page.Run(52092415,EmployeeJournal);
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[20];var EmployeeJournal: Record "Employee Update Line")
    begin
        EmployeeJournal.FilterGroup := 2;
        EmployeeJournal.SetRange(EmployeeJournal."Document No.",CurrentJnlBatchName);
        EmployeeJournal.FilterGroup := 0;
    end;
}

