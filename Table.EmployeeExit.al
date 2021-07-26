Table 52092217 "Employee Exit"
{
    DrillDownPageID = "Exit List";
    LookupPageID = "Exit List";

    fields
    {
        field(1;"No.";Code[20])
        {
            Editable = false;
        }
        field(2;"Document Date";Date)
        {
        }
        field(3;"Employee No.";Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                if "Employee No." <> '' then begin
                  Employee.Get("Employee No.");
                  if Employee.Status = Employee.Status::Terminated then
                    Error(Text004);
                  CheckExistingExitDoc;
                  "Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                  "Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                  "Employee Name" := Employee.FullName;
                  "Employment Date" := Employee."Employment Date";
                  "Grade Level" := Employee."Grade Level Code";
                  "Outstanding Cash Advance" := GetCashAdvanceAmount;
                  if Employee."Birth Date" <> 0D then
                    "Employee Age" := ROUND(((Date2dmy(Today,3) - Date2dmy(Employee."Birth Date",3)) * 12 +
                    (Date2dmy(Today,2) - Date2dmy(Employee."Birth Date",2)))/12,1,'=');
                  Designation := Employee.Designation;
                  "Employee Category" := Employee.GetEmployeeCategory;
                  "Employee Creditor's Balance" := GetCreditorBalance;
                  "Employee Debtor's Balance" := GetDebtorBalance;
                  InsertExitArticle;
                end else begin
                  DeleteLine;
                  "Global Dimension 1 Code" := '';
                  "Global Dimension 2 Code" := '';
                  "Employee Name" := '';
                  "Employment Date" := 0D;
                  "Grade Level" := '';
                  "Length of Service" := 0;
                  "Outstanding Cash Advance" := 0;
                  "Employee Age" := 0;
                  Designation := '';
                  "Employee Category" := '';
                end;
            end;
        }
        field(4;"Global Dimension 1 Code";Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(1),
                                                          "Dimension Value Type"=filter(Standard));
        }
        field(5;"Global Dimension 2 Code";Code[10])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where ("Global Dimension No."=const(2),
                                                          "Dimension Value Type"=filter(Standard));
        }
        field(6;"Exit Date";Date)
        {

            trigger OnValidate()
            begin
                if "Exit Date" <> 0D then begin
                  Employee.Get("Employee No.");
                  "Length of Service" := ROUND(((Date2dmy("Exit Date",3) - Date2dmy("Employment Date",3)) * 12 +
                    (Date2dmy("Exit Date",2) - Date2dmy("Employment Date",2)))/12,1,'=');
                  "Length of Service Text" := PeriodText.GetPeriodText("Employment Date","Exit Date");
                end else begin
                  "Length of Service" := 0;
                  "Length of Service Text" := '';
                end;
            end;
        }
        field(7;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Open,Approved,Pending Approval,Cancelled,Processed';
            OptionMembers = Open,Approved,"Pending Approval",Cancelled,Processed;
        }
        field(8;"Exit Reason";Text[50])
        {
        }
        field(9;"No. Series";Code[20])
        {
        }
        field(10;"Grounds for Exit";Code[10])
        {
            TableRelation = "Grounds for Termination";

            trigger OnValidate()
            begin
                TestField(Status,Status::Open);
                if "Grounds for Exit" <> '' then begin
                  ExitGround.Get("Grounds for Exit");
                  "Exit Reason" := ExitGround.Description;
                end else
                  "Exit Reason" := '';
            end;
        }
        field(11;"Employee Name";Text[100])
        {
        }
        field(12;"Grade Level";Code[20])
        {
            Editable = false;
        }
        field(13;"Employment Date";Date)
        {
            Editable = false;
        }
        field(14;"Length of Service";Integer)
        {
            Editable = false;
        }
        field(15;"Length of Service Text";Text[50])
        {
        }
        field(20;"Gratuity Amount";Decimal)
        {
            CalcFormula = sum("Gratuity Ledger Entry"."Current Amount" where ("Employee No."=field("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21;"OutStanding Loan Amount";Decimal)
        {
            CalcFormula = sum("Payroll-Loan Entry".Amount where ("Employee No."=field("Employee No."),
                                                                 "Amount Type"=const("Loan Amount")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(22;"Miscellaneous Articles";Integer)
        {
            CalcFormula = count("Misc. Article Information" where ("Employee No."=field("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(23;"Outstanding Cash Advance";Decimal)
        {
            Editable = false;
        }
        field(30;"No. of Months in Lieu";Integer)
        {
        }
        field(31;"Employee Age";Integer)
        {
        }
        field(32;Designation;Text[50])
        {
        }
        field(33;"Employee Category";Text[50])
        {
            TableRelation = "Employee Category";
        }
        field(34;"Employee Group";Code[10])
        {
            TableRelation = "Payroll-Employee Group Header";
        }
        field(50;"Employee Debtor's Balance";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(51;"Employee Creditor's Balance";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(52;"Unused Leave Days";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(53;"Annual Basic Pay";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(54;"Annual Gross Pay";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(55;"Accrued Salary";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(56;"13th Month Salary";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(57;"Notice Pay";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(58;"Severance Pay";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59;"Leave Allowance";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(60;"Entitled Leave Allowance";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(61;"Unearned Leave";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(62;"Unearned Salary";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(63;"Assets in Employee Possession";Integer)
        {
            CalcFormula = count("Fixed Asset" where ("Responsible Employee"=field("Employee No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(64;"Unearned Leave Days";Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(65;"Monthly Basic Salary";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1;"No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
          HumanResSetup.Get;
          HumanResSetup.TestField(HumanResSetup."Exit No.");
          NoSeriesMgt.InitSeries(HumanResSetup."Exit No.",xRec."No. Series",0D,"No.","No. Series");
        end;
        UserSetup.Get(UserId);
        Validate("Employee No.",UserSetup."Employee No.");
        "Document Date" := Today;
    end;

    trigger OnModify()
    begin
        if not (StatusCheckSuspended) then
          TestField(Status,Status::Open);
    end;

    var
        HumanResSetup: Record "Human Resources Setup";
        UserSetup: Record "User Setup";
        ExitGround: Record "Grounds for Termination";
        Employee: Record Employee;
        PayrollEmployee: Record "Payroll-Employee";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text001: label 'Do you want to process exit?';
        Text002: label 'Exit not processed';
        Text003: label 'Do you want to discontinue exit?';
        Text004: label 'Employee %1 already exited';
        Text005: label 'Exit document %1 already exist for this employee';
        PeriodText: Codeunit "Period to Text";
        StatusCheckSuspended: Boolean;
        PayrollMgt: Codeunit "Payroll-Management";
        PayrollSetup: Record "Payroll-Setup";
        PayrollPayslipLine: Record "Closed Payroll-Payslip Line";
        LeaveAmtCollected: Decimal;
        EmpAbs: Record "Employee Absence";
        Window: Dialog;
        PaymentVoucherHeader: Record "Payment Header";
        EmpRec: Record "Payroll-Employee";
        PaymentVoucherLine: Record "Payment Line";
        LineNo: Integer;
        EmpExitArtEntry: Record "Employee Exit Article Entry";
        SMTPSetup: Record "SMTP Mail Setup";
        SMTP: Codeunit "SMTP Mail";
        UserSetup2: Record "User Setup";
        Subject: Text[100];
        Body: Text[250];
        EmpBank: Record "Employee Bank Account";
        ApprovalEntry: Record "Approval Entry";
        RequestorId: Code[20];
        ApprovedDocName: Text;


    procedure DiscontinueExit()
    begin
        if Confirm(Text003,false) then begin
          Status := Status::Cancelled;
          Modify;
        end;
    end;


    procedure ProcessExit()
    begin
        if not Confirm(Text001) then
          Error(Text002);

        Employee.Get("Employee No.");
        Employee.Status := Employee.Status::Terminated;
        Employee."Termination Date" := "Exit Date";
        Employee."Grounds for Term. Code" := "Grounds for Exit";
        Employee.Modify;

        PayrollEmployee.Get("Employee No.");
        PayrollEmployee."Appointment Status" := Employee.Status::Terminated;
        PayrollEmployee."Termination Date" := "Exit Date";
        PayrollEmployee."Grounds for Term. Code" := "Grounds for Exit";
        PayrollEmployee.Modify;

        Status := Status::Processed;
        Modify;
    end;


    procedure CheckExistingExitDoc()
    var
        EmployeeExit: Record "Employee Exit";
    begin
        EmployeeExit.SetRange("Employee No.","Employee No.");
        EmployeeExit.SetFilter("No.",'<>%1',"No.");
        EmployeeExit.SetFilter(Status,'<>%1',EmployeeExit.Status::Cancelled);
        if EmployeeExit.FindFirst then
          Error(Text005,EmployeeExit."No.");
    end;


    procedure GetCashAdvanceAmount() AdvanceAmount: Decimal
    var
        CashAdvance: Record "Posted Payment Header";
    begin
        CashAdvance.SetCurrentkey("Payee No.","Entry Status","Retirement Status");
        CashAdvance.SetRange("Document Type",CashAdvance."document type"::"Cash Advance");
        CashAdvance.SetRange("Payee No.","Employee No.");
        CashAdvance.SetRange("Entry Status",CashAdvance."entry status"::Posted);
        CashAdvance.SetFilter("Retirement Status",'%1|%2',0,3);
        if CashAdvance.Find('-') then begin
          repeat
            CashAdvance.CalcFields("Amount (LCY)");
            AdvanceAmount :=+ CashAdvance."Amount (LCY)";
          until CashAdvance.Next = 0;
        end;
        exit(AdvanceAmount);
    end;


    procedure SuspendStatusCheck(Suspend: Boolean)
    begin
        StatusCheckSuspended := Suspend;
    end;


    procedure InsertExitArticle()
    var
        Vend: Record Vendor;
        Cust: Record Customer;
        EmpExitArticle: Record "Employee Exit Article";
        EmpExitArticleEntry: Record "Employee Exit Article Entry";
        GratuityLedgerEntry: Record "Gratuity Ledger Entry";
    begin
        DeleteLine;
        if not EmpExitArticle.FindFirst then
          exit;

        Employee.Get("Employee No.");
        PayrollEmployee.Get("Employee No.");
        Clear(Vend);
        Clear(Cust);
        if Cust.Get(PayrollEmployee."Customer No.") then
          Cust.CalcFields("Balance (LCY)");
        if Vend.Get(Employee."Vendor No.") then
          Vend.CalcFields("Balance (LCY)");
        repeat
          EmpExitArticleEntry.Init;
          EmpExitArticleEntry."Exit No." := "No.";
          EmpExitArticleEntry."Employee No." := "Employee No.";
          EmpExitArticleEntry."Misc. Article Code" := EmpExitArticle.Code;
          EmpExitArticleEntry."Global Dimension 1 Code" := EmpExitArticle."Global Dimension 1 Code";
          EmpExitArticleEntry."Global Dimension 2 Code" := EmpExitArticle."Global Dimension 2 Code";
          EmpExitArticleEntry.Description := EmpExitArticle.Description;
          if EmpExitArticle."Staff Gratuity" then begin//Get Gratuity accrued
            GratuityLedgerEntry.Reset;
            GratuityLedgerEntry.SetRange("Employee No.","Employee No.");
            GratuityLedgerEntry.CalcSums("Current Amount");
            EmpExitArticleEntry.Validate("Credit Amount",GratuityLedgerEntry."Current Amount");
            EmpExitArticleEntry."Staff Gratuity" := true;
          end;
          if EmpExitArticle."Staff Debtor" then begin//Get Staff Debtor
            EmpExitArticleEntry."Staff Debtor" := true;
            if Cust."Balance (LCY)" >= 0 then
              EmpExitArticleEntry.Validate("Debit Amount",Cust."Balance (LCY)")
            else
              EmpExitArticleEntry.Validate("Credit Amount",Abs(Cust."Balance (LCY)"));
          end;
          if EmpExitArticle."Staff Creditor" then begin//Get Staff Creditor Account
            EmpExitArticleEntry."Staff Creditor" := true;
          end;
          if EmpExitArticle."Outstanding Cash Advance" then begin//Get Outstanding Cash Advance
            EmpExitArticleEntry."Outstanding Cash Advance" := true;
            if GetCashAdvanceAmount >= 0 then
              EmpExitArticleEntry.Validate("Debit Amount",GetCashAdvanceAmount)
            else
              EmpExitArticleEntry.Validate("Credit Amount",Abs(GetCashAdvanceAmount));
          end;
          if not EmpExitArticleEntry.Insert(true) then
            EmpExitArticleEntry.Modify(true);
        until EmpExitArticle.Next = 0;
    end;


    procedure DeleteLine()
    var
        EmpExitArticleEntry: Record "Employee Exit Article Entry";
    begin
        EmpExitArticleEntry.SetRange("Exit No.","No.");
        EmpExitArticleEntry.DeleteAll;
    end;


    procedure GetCreditorBalance(): Decimal
    var
        Vendor: Record Vendor;
    begin
        Employee.Get("Employee No.");
        if Employee."Vendor No." <> '' then begin
          Vendor.Get(Employee."Vendor No.");
          Vendor.CalcFields("Balance (LCY)");
          exit(Vendor."Balance (LCY)");
        end else
          exit(0)
    end;


    procedure GetDebtorBalance(): Decimal
    var
        Customer: Record Customer;
    begin
        Employee.Get("Employee No.");
        if Employee."Customer No." <> '' then begin
          Customer.Get(Employee."Customer No.");
          Customer.CalcFields("Balance (LCY)");
          exit(Customer."Balance (LCY)");
        end else
          exit(0)
    end;


    procedure CalculateAvailableLeave()
    var
        LeaveScheduleHeader: Record "Leave Schedule Header";
        EmployeeGroupLine: Record "Payroll-Employee Group Line";
        EmpGroupCode: Code[20];
        nTotalLeaveDayEntitled: Decimal;
        nTotalLeaveDayUsed: Decimal;
        AvailableDays: Decimal;
        nMonths: Decimal;
        nDays: Decimal;
        BasicSalary: Decimal;
        nLeaveDayEntitled: Decimal;
        nLeaveDayPerMonth: Decimal;
        nYearNo: Integer;
        FirstMonthDate: Date;
    begin
        HumanResSetup.Get;
        TestField("Exit Date");
        PayrollSetup.Get;
        PayrollSetup.TestField("Leave Accrual ED Code");
        PayrollSetup.TestField("13TH Month ED Code");
        nYearNo := Date2dmy("Exit Date",3);
        LeaveAmtCollected := 0;
        
        if LeaveScheduleHeader.Get(nYearNo,"Employee No.",HumanResSetup."Annual Leave Code") then begin
          LeaveScheduleHeader.CalcFields("No. of Days Added","No. of Days Subtracted","No. of Days Utilised");
          nTotalLeaveDayEntitled := LeaveScheduleHeader."No. of Days Entitled" + LeaveScheduleHeader."No. of Days B/F"+
                                    + LeaveScheduleHeader."No. of Days Added";
          nTotalLeaveDayUsed := LeaveScheduleHeader."No. of Days Subtracted" + LeaveScheduleHeader."No. of Days Utilised";
        
          FirstMonthDate := Dmy2date(1,1,nYearNo);
          nMonths := ROUND(((Date2dmy("Exit Date",3) - Date2dmy(FirstMonthDate,3)) * 365 +
                      (Date2dmy("Exit Date",2) - Date2dmy(FirstMonthDate,2))* 30.41 +
                      (Date2dmy("Exit Date",1) - Date2dmy(FirstMonthDate,1)))/30.41,0.1);
          nDays := ROUND(((Date2dmy("Exit Date",3) - Date2dmy(FirstMonthDate,3)) * 365 +
                      (Date2dmy("Exit Date",2) - Date2dmy(FirstMonthDate,2))* 30.41 +
                      (Date2dmy("Exit Date",1) - Date2dmy(FirstMonthDate,1))),0.1);
        
          //EmployeeGroupLine.GET("Employee Group",PayrollSetup."Leave ED Code");
          /*EmpAbs.SETRANGE("Employee No.","Employee No.");
          EmpAbs.SETRANGE("Year No.",nYearNo);
          IF EmpAbs.FINDFIRST THEN
            REPEAT
              //LeaveAmtCollected += EmpAbs."Leave Amount Paid";
            UNTIL EmpAbs.NEXT = 0;*/
        
        
          PayrollPayslipLine.Reset;
          PayrollPayslipLine.SetRange("Employee No.","Employee No.");
          PayrollPayslipLine.SetRange("E/D Code",PayrollSetup."Leave Accrual ED Code");
          PayrollPayslipLine.FindLast;
        
          nLeaveDayPerMonth :=   ROUND(nTotalLeaveDayEntitled/12,1,'>');
          nLeaveDayEntitled :=   ROUND(nLeaveDayPerMonth * nMonths,1,'>');
          if nTotalLeaveDayUsed < nLeaveDayEntitled then
            "Unused Leave Days" := ROUND((nLeaveDayEntitled - nTotalLeaveDayUsed),1,'>')
          else
            "Unearned Leave Days"  :=  ROUND((nTotalLeaveDayUsed - nLeaveDayEntitled),1,'>');
          "Leave Allowance" := nMonths * PayrollPayslipLine.Amount;
          if "Leave Allowance" >= LeaveAmtCollected then
            "Entitled Leave Allowance" := "Leave Allowance" - LeaveAmtCollected
          else
            "Unearned Leave" := LeaveAmtCollected - "Leave Allowance";
        
          //EmployeeGroupLine.GET("Employee Group",PayrollSetup."13Th Month ED Code");
          PayrollPayslipLine.Reset;
          PayrollPayslipLine.SetRange("Employee No.","Employee No.");
          PayrollPayslipLine.SetRange("E/D Code",PayrollSetup."13TH Month ED Code");
          PayrollPayslipLine.FindLast;
          "13th Month Salary" := nMonths * PayrollPayslipLine.Amount/12;
        
        end;

    end;
}

