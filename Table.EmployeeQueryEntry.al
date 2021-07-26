Table 52092214 "Employee Query Entry"
{
    DrillDownPageID = "Query Action List";
    LookupPageID = "Query Action List";

    fields
    {
        field(1; "Query Ref. No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee where(Status = filter(<> Terminated));
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnValidate()
            begin
                if "Employee No." <> '' then begin
                    Employee.Get("Employee No.");
                    "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                    "Staff Category" := Employee."Employee Category";
                    "Employee Name" := Employee.FullName;
                end else begin
                    "Global Dimension 1 Code" := '';
                    "Staff Category" := '';
                    "Queried By" := '';
                    "Global Dimension 2 Code" := '';
                    "Employee Name" := ''
                end;
            end;
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(5; "Queried By"; Code[20])
        {
            Editable = false;
            TableRelation = Employee;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if not Employee.Get("Queried By") then
                    if not Confirm(Text002, false) then
                        Error(Text003);
                "Queried By Name" := Employee.FullName;
            end;
        }
        field(6; Level; Option)
        {
            Editable = false;
            OptionCaption = ' ,Category I,Category II,Category III,Category IV';
            OptionMembers = " ","Category I","Category II","Category III","Category IV";

            trigger OnValidate()
            begin
                /*IF (Action >= 2) AND (Level < 2) THEN
                  ERROR(Text001,Action,Level);*/

            end;
        }
        field(7; "Cause of Query Code"; Code[10])
        {
            TableRelation = "Cause of Query";

            trigger OnValidate()
            begin
                if "Cause of Query Code" <> '' then begin
                    CauseOfQuery.Get("Cause of Query Code");
                    Offence := CauseOfQuery.Description;
                    Level := CauseOfQuery.Level;
                    Action := CauseOfQuery.Action;
                    "Suspension Duration" := CauseOfQuery."Suspension Duration";
                end;
            end;
        }
        field(8; Offence; Text[150])
        {
        }
        field(9; Response; Option)
        {
            OptionMembers = "None",Satisfactory,"Not Satisfactory","Awaiting Response";
        }
        field(10; Explanation; Text[250])
        {
        }
        field(11; Closed; Boolean)
        {
        }
        field(12; "Effective Date of Action"; Date)
        {
        }
        field(13; "Action"; Option)
        {
            OptionCaption = 'No Action ,Advice,Warning,Suspension with pay,Suspension without pay,Dismissal';
            OptionMembers = "No Action",Advice,Warning,"Suspension with pay","Suspension without pay",Dismissal;

            trigger OnValidate()
            begin
                /*IF (Action >= 2) AND (Level < 2) THEN
                  ERROR(Text001,Action,Level);*/

            end;
        }
        field(14; "Date of Query"; Date)
        {
        }
        field(15; "Suspension Duration"; DateFormula)
        {

            trigger OnValidate()
            begin
                if Format("Suspension Duration") <> '' then begin
                    TestField("Effective Date of Action");
                    if not (Action in [3, 4]) then
                        Error(StrSubstNo(Text009, Action::"Suspension with pay", Action::"Suspension without pay"));
                end;
            end;
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Cost-centre Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(17; "Date of Violation"; Date)
        {
        }
        field(18; Time; Time)
        {
        }
        field(19; "Staff Category"; Code[10])
        {
        }
        field(20; Status; Option)
        {
            OptionCaption = ' ,Issued Out,Answered,Awaiting HR Action,Closed,Cancelled';
            OptionMembers = " ","Issued Out",Answered,"Awaiting HR Action",Closed,Cancelled;
        }
        field(21; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(22; "Response DeadLine"; Code[10])
        {

            trigger OnValidate()
            begin
                TestField("Date of Query");
                "Response Due Date" := CalcDate(Format("Response DeadLine") + '-1D', "Date of Query");
            end;
        }
        field(23; "Response Due Date"; Date)
        {
        }
        field(24; "Cause of Inactivity Code"; Code[10])
        {
            TableRelation = "Cause of Inactivity";

            trigger OnValidate()
            begin
                if "Cause of Inactivity Code" <> '' then begin
                    if not (Action in [3, 4]) then
                        Error(StrSubstNo(Text009, Action::"Suspension with pay", Action::"Suspension without pay"));
                end;
            end;
        }
        field(25; "Grounds for Term. Code"; Code[10])
        {
            TableRelation = "Grounds for Termination";

            trigger OnValidate()
            begin
                if "Grounds for Term. Code" <> '' then begin
                    if not (Action in [5]) then
                        Error(StrSubstNo(Text009, Action::"Suspension with pay", Action::"Suspension without pay"));
                end;
            end;
        }
        field(26; "Queried By Name"; Text[100])
        {
        }
        field(27; "No. of Queries"; Integer)
        {
            CalcFormula = count("Employee Query Entry" where("Employee No." = field("Employee No."),
                                                              "Cause of Query Code" = field("Cause of Query Code"),
                                                              Closed = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Employee Name"; Text[100])
        {
        }
        field(70000; "Portal ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(70001; "Mobile User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(70002; "Created from External Portal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'Created from External Portal such as Retail';
        }
    }

    keys
    {
        key(Key1; "Query Ref. No.")
        {
            Clustered = true;
        }
        key(Key2; "Employee No.")
        {
        }
        key(Key3; "Employee No.", "Date of Query")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "Query Ref. No." = '' then begin
            HumanResSetup.Get;
            HumanResSetup.TestField(HumanResSetup."Query Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Query Nos.", xRec."No. Series", 0D, "Query Ref. No.", "No. Series");
        end;
        UserSetup.Get(UserId);
        Validate("Queried By", UserSetup."Employee No.");
    end;

    trigger OnModify()
    begin
        if Status = Status::Answered then begin
            case Action of
                3, 4:
                    begin
                        TestField("Suspension Duration");
                        TestField("Cause of Inactivity Code");
                    end;
                5:
                    begin
                        TestField("Grounds for Term. Code");
                    end;
            end;
        end;
    end;

    var
        Employee: Record Employee;
        EmployeeQuery: Record "Employee Query Entry";
        CauseOfQuery: Record "Cause of Query";
        Text001: label '%1 cannot be given for a %2 Query!';
        Text002: label 'Employee does not exist.Are you sure you want to continue?';
        Text003: label 'Cannot save changes';
        HumanResSetup: Record "Human Resources Setup";
        UserSetup: Record "User Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text004: label 'Query Successfully registered\E-mail notification successfully sent.';
        Text005: label 'Nothing to submit\Explanation must be given';
        Text006: label 'Do you want to submit your response?';
        Text007: label 'Submission of response aborted!';
        Text008: label 'Response successfully submitted';
        Text009: label 'This can only be used with the action %1 or %2';
        Text010: label 'This is to notify you that you have been issued a query for %1. You must respond to the query on or before %2';
        Text011: label 'Do you want to process this query action?';
        Text012: label 'Action processing aborted!';
        Mail: Codeunit Mail;
        //QueryLetters: Report "Employee Query Letter";
        Text013: label 'Do you want to send this query to HR for processing?';
        Text014: label 'Action Aborted!';


    procedure RegisterQueryAndEmail()
    var
        Employee2: Record Employee;
        GlobalText: Integer;
        GlobalSender: Text[80];
        Body: Text[200];
        Subject: Text[200];
        SMTP: Codeunit "SMTP Mail";
    begin
        TestField("Employee No.");
        TestField("Queried By");
        TestField("Cause of Query Code");
        TestField("Date of Query");

        Employee.Get("Employee No.");
        Employee.TestField("E-Mail");
        Employee2.Get("Queried By");
        Employee2.TestField("E-Mail");

        GlobalSender := Employee2."First Name" + '' + Employee2."Last Name";
        Body := StrSubstNo(Text010, Offence, "Response Due Date");
        Subject := 'QUERY';
        SMTP.CreateMessage(GlobalSender, Employee2."E-Mail", Employee."E-Mail", Subject, Body, false);
        SMTP.Send;

        Status := Status::"Issued Out";
        Modify;
        Message(Text004);
    end;


    procedure SubmitResponse()
    begin
        if Explanation = '' then
            Error(Text005);
        if not Confirm(Text006) then
            Error(Text007);
        Status := Status::Answered;
        Modify;
        Message(Text008);
    end;


    procedure sendToHR()
    begin
        if not (Confirm(Text013)) then
            Error(Text014);

        Status := Status::"Awaiting HR Action";
        Modify;
    end;


    procedure ProcessAction()
    begin
        if not (Confirm(Text011)) then
            Error(Text012);
        Employee.Get("Employee No.");
        if not (Action in [0]) then begin
            case Action of
                3:
                    begin
                        Employee.Status := Employee.Status::Inactive;
                        Employee."Inactive Date" := "Effective Date of Action";
                        Employee."Inactive Duration" := Format("Suspension Duration");
                        Employee."Cause of Inactivity Code" := "Cause of Inactivity Code";
                        Employee.Modify
                    end;
                4:
                    begin
                        Employee.Status := Employee.Status::Inactive;
                        Employee."Inactive Date" := "Effective Date of Action";
                        Employee."Inactive Duration" := Format("Suspension Duration");
                        Employee."Cause of Inactivity Code" := "Cause of Inactivity Code";
                        Employee."Inactive Without Pay" := true;
                        Employee.Modify;
                    end;
                5:
                    begin
                        Employee.Status := Employee.Status::Terminated;
                        Employee."Termination Date" := "Effective Date of Action";
                        Employee."Grounds for Term. Code" := "Grounds for Term. Code";
                        Employee.Modify;
                    end;
            end;

        end;
        Status := Status::Closed;
        Modify;
    end;


    procedure RegisterQueryAndPrintLetter()
    begin
        TestField("Employee No.");
        TestField("Queried By");
        TestField("Cause of Query Code");
        TestField("Date of Query");

        EmployeeQuery.Get("Query Ref. No.");
        EmployeeQuery.SetRecfilter;
        // QueryLetters.SetTableview(EmployeeQuery);
        // QueryLetters.Run;
    end;
}

