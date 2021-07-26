Codeunit 52092192 EventDueManagement
{

    trigger OnRun()
    begin
    end;

    var
        iCount: Integer;
        NoOfRecords: Integer;
        NoOfYears: Integer;
        Window: Dialog;
        Text001: label 'No matching record found!';
        Text002: label 'No record was processed!';
        Text003: label '%1 employees records successfully processed!';


    procedure BirthDayDue(var Rec: Record Employee;FromDate: Date;ToDate: Date)
    var
        BirthDate: Date;
    begin
        Rec.ClearMarks;
        Rec.MarkedOnly := false;

        NoOfRecords := Rec.Count;
        if NoOfRecords = 0 then begin
          Message(Text001);
          exit;
        end;

        Window.Open('Please Wait #1###### @2@@@@@@@@@@@@@');

        iCount := 1;

        Rec.Find('-');
        repeat
          Window.Update(1,Rec."No.");
          Window.Update(2,ROUND(iCount / NoOfRecords * 10000,1));
          if (Rec."Birth Date" <> 0D) and (Rec.Status <> Rec.Status::Terminated) then begin
            BirthDate := Dmy2date(Date2dmy(Rec."Birth Date",1),Date2dmy(Rec."Birth Date",2),Date2dmy(FromDate,3));
            if (BirthDate >= FromDate) and (BirthDate <= ToDate) then
              Rec.Mark := true;
          end;
          iCount := iCount + 1;
        until Rec.Next = 0;
        Rec.Find('-');

        Rec.MarkedOnly := true;
        if Rec.Count = 0 then begin
          Message(Text001);
        end;
        Window.Close;
    end;


    procedure LongService(var EmpRec: Record Employee;Years: Integer)
    begin
        EmpRec.ClearMarks;
        EmpRec.MarkedOnly := false;

        NoOfRecords := EmpRec.Count;
        if NoOfRecords = 0 then begin
          Message(Text001);
          exit;
        end;

        Window.Open('Please Wait #1###### @2@@@@@@@@@@@@@');

        iCount := 1;

        EmpRec.Find('-');
        repeat
          Window.Update(1,EmpRec."No.");
          Window.Update(2,ROUND(iCount / NoOfRecords * 10000,1));
          if (EmpRec."Employment Date" <> 0D) and (EmpRec.Status <> EmpRec.Status::Terminated) then begin
            NoOfYears := Date2dmy(Today,3) - Date2dmy(EmpRec."Employment Date",3);
            if NoOfYears =  Years then
              EmpRec.Mark := true;
          end;
          iCount := iCount + 1;
        until EmpRec.Next = 0;
        EmpRec.Find('-');

        EmpRec.MarkedOnly := true;
        if EmpRec.Count = 0 then
          Message(Text001);

        Window.Close;
    end;


    procedure Confirmation(var Employee: Record Employee)
    var
        EventDue: Record "Event Due";
        NoApplied: Integer;
        ChangeRec: Boolean;
    begin
        NoOfRecords := Employee.Count;
        if NoOfRecords = 0 then begin
          Message(Text001);
          exit;
        end;

        Window.Open('Please Wait #1###### @2@@@@@@@@@@@@@');

        iCount := 1;
        NoApplied := 0;

        Employee.Find('-');
        EventDue.SetRange(EventDue."Entry Type",EventDue."entry type"::Confirmation);

        repeat

          Window.Update(1,Employee."No.");
          Window.Update(2,ROUND(iCount / NoOfRecords * 10000,1));

          ChangeRec := false;

          EventDue.SetRange(EventDue."Employee No.",Employee."No.");
          if EventDue.Find('-') then begin
            case EventDue.Confirmation of
             1 : begin
                 EventDue.TestField("Responsible Empl. No.");
                 Employee."Employment Status" := Employee."employment status"::Confirmed;
                 Employee."Confirmation Date" := EventDue."Due Date";
                 Employee."Confirmed By" := EventDue."Responsible Empl. No.";
                 ChangeRec := true;
             end;
             2 : begin
               if Format(EventDue."Ext. Period") <> '' then begin
                 Employee."Employment Status" := Employee."employment status"::Probation;
                 Employee."Probation Period" := EventDue."Ext. Period";
                 Employee."Confirmation Due Date" := CalcDate(Format(EventDue."Ext. Period"),Employee."Confirmation Due Date");
                 ChangeRec := true;
               end;
             end;
             3 : begin
               if EventDue."Grounds for Termination" <> '' then begin
                 Employee.Status := Employee.Status::Terminated;
                 Employee."Employment Status" := Employee."employment status"::Confirmed;
                 Employee."Grounds for Term. Code" := EventDue."Grounds for Termination";
                 Employee."Termination Date" := EventDue."Due Date";
                 ChangeRec := true;
               end;
             end;
            end;
            if ChangeRec then begin
              Employee.Modify;
              EventDue.Delete;
              NoApplied := NoApplied + 1;
            end;
          end;

          iCount := iCount + 1;

        until Employee.Next = 0;

        Window.Close;
        if NoApplied = 0 then
          Message(Text002)
        else
          Message(Text003,NoApplied);
    end;


    procedure FiftyYrAnniversary(var EmpAnnivRec: Record Employee;Years: Integer)
    begin
        EmpAnnivRec.ClearMarks;
        EmpAnnivRec.MarkedOnly := false;

        NoOfRecords := EmpAnnivRec.Count;
        if NoOfRecords = 0 then begin
          Message('No matching record found!');
          exit;
        end;

        Window.Open('Please Wait #1###### @2@@@@@@@@@@@@@');

        iCount := 1;

        EmpAnnivRec.Find('-');
        repeat
          Window.Update(1,EmpAnnivRec."No.");
          Window.Update(2,ROUND(iCount / NoOfRecords * 10000,1));
          if (EmpAnnivRec."Birth Date" <> 0D) and (EmpAnnivRec.Status <> EmpAnnivRec.Status::Terminated) then begin
            NoOfYears := Date2dmy(Today,3) - Date2dmy(EmpAnnivRec."Birth Date",3);
            if NoOfYears =  Years then
              EmpAnnivRec.Mark := true;
          end;
          iCount := iCount + 1;
        until EmpAnnivRec.Next = 0;
        EmpAnnivRec.Find('-');

        EmpAnnivRec.MarkedOnly := true;
        if EmpAnnivRec.Count = 0 then
          Message('No matching record found!');

        Window.Close;
    end;
}

