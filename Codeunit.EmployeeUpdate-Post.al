Codeunit 52092189 "Employee Update-Post"
{
    TableNo = "Employee Update Header";

    trigger OnRun()
    begin
        if not Confirm(Text001) then exit;
        Window.Open('Updating Employee Information');
        EmpUpdateHeader := Rec;
        CheckLineMandatoryFields(EmpUpdateHeader);
        PostLine(EmpUpdateHeader);
        EmpUpdateHeader."Processed Date" := WorkDate;
        EmpUpdateHeader."Processed By" := UserId;
        EmpUpdateHeader.Processed := true;
        EmpUpdateHeader.Modify;
        Rec := EmpUpdateHeader;
        Window.Close;
        Message('Completed');
    end;

    var
        EmpUpdateHeader: Record "Employee Update Header";
        Employee: Record Employee;
        GradeLevel: Record "Grade Level";
        EmploymentHistory: Record "Employment History";
        PayrollSetup: Record "Payroll-Setup";
        JobTitle: Record "Job Title";
        CompanyInfo: Record "Company Information";
        Window: Dialog;
        NextEntryNo: Integer;
        NoOfRecords: Integer;
        LineCount: Integer;
        LineNo: Integer;
        Type: Text[30];
        Text001: label 'Do you want to post Journal Lines?';
        Text002: label 'There is nothing to post!';
        Text003: label 'Promotion Journal already posted!';
        Text004: label 'Basic Salary cannot be the same as New Basic Salary for Salary Change\Journal Batch %1, Employee No. %2';
        Text005: label 'Grade Level cannot be the same as New Grade Level for Upgrading\Journal Batch %1, Employee No. %2';
        Text006: label 'Basic Salary cannot be the same as New Basic Salary for Upgrading\Journal Batch %1, Employee No. %2';
        Text007: label 'Job Title cannot be the same as\New Job Title for Redesignation\Journal Batch %1, Employee No. %2';
        Text008: label 'Job Title cannot be the same as\New Job Title for Redesignation/Transfer\Journal Batch %1, Employee No. %2';
        Text009: label 'Promotion Journal Line(s) successfully posted!';

    local procedure CheckLineMandatoryFields(EmpUpdateHeader: Record "Employee Update Header")
    var
        EmpUpdateLine: Record "Employee Update Line";
    begin
        with EmpUpdateHeader do begin
          EmpUpdateLine.SetRange("Document No.","Document No.");
          if EmpUpdateLine.Find('-') then
            repeat
              case "Entry Type" of
                "entry type"::Redesignation:
                  begin
                    EmpUpdateLine.TestField("New Job Title");
                    if EmpUpdateLine."Job Title Code" = EmpUpdateLine."New Job Title" then
                       Error(Text007,EmpUpdateLine."Document No.",EmpUpdateLine."Employee No.");
                  end;
                "entry type"::"Salary Change":
                  begin
                    EmpUpdateLine.TestField("New Gross Salary");
                    if EmpUpdateLine."Gross Salary" = EmpUpdateLine."New Gross Salary" then
                      Error(Text004,EmpUpdateLine."Document No.",EmpUpdateLine."Employee No.");
                  end;
                "entry type"::Upgrading:
                  begin
                    if EmpUpdateLine."Grade Level" = EmpUpdateLine."New Grade Level" then
                      Error(Text005,EmpUpdateLine."Document No.",EmpUpdateLine."Employee No.");
                  end;
                "entry type"::"Redesignation/Transfer":
                  begin
                    EmpUpdateLine.TestField("New Job Title");
                    EmpUpdateLine.TestField("New Global Dimension 1 Code");
                    EmpUpdateLine.TestField("New Global Dimension 2 Code");
                    if EmpUpdateLine."Job Title Code" = EmpUpdateLine."New Job Title" then
                      Error(Text008,"Document No.",EmpUpdateLine."Employee No.");
                  end;
              end;
            until EmpUpdateLine.Next = 0;
        end;
    end;

    local procedure PostLine(EmpUpdateHeader: Record "Employee Update Header")
    var
        EmpUpdateLine: Record "Employee Update Line";
    begin
        CompanyInfo.Get;
        PayrollSetup.Get;
        with EmpUpdateLine do begin
          SetRange("Document No.",EmpUpdateHeader."Document No.");
          if not(EmpUpdateLine.Find('-')) then Error(Text002);
          repeat
            case EmpUpdateHeader."Entry Type" of
              EmpUpdateHeader."entry type"::Promotion:
                begin
                  Employee.Get("Employee No.");
                  if "New Grade Level" <> '' then
                    Employee."Grade Level Code" := "New Grade Level";
                  if "New Job Title" <> '' then
                    Employee."Job Title Code":= "New Job Title";
                  if "New Global Dimension 1 Code" <> '' then
                    Employee."Global Dimension 1 Code" := "New Global Dimension 1 Code";
                  if "New Global Dimension 2 Code" <> '' then
                    Employee."Global Dimension 2 Code" := "New Global Dimension 2 Code";
                  if ("New Category" <> '') then
                    Employee."Employee Category" := "New Category";
                  Employee.Modify;
                end;
              EmpUpdateHeader."entry type"::Transfer:
                begin
                  Employee.Get("Employee No.");
                  if "New Global Dimension 1 Code" <> '' then
                    Employee."Global Dimension 1 Code" := "New Global Dimension 1 Code";
                  if "New Global Dimension 2 Code" <> '' then
                    Employee."Global Dimension 2 Code" := "New Global Dimension 2 Code";
                  if ("New Category" <> '') then
                    Employee."Employee Category" := "New Category";
                  if "New Job Title" <> '' then
                    Employee."Job Title Code" := "New Job Title";
                  Employee.Modify;
                end;
              EmpUpdateHeader."entry type"::Redesignation:
                begin
                  Employee.Get("Employee No.");
                  Employee."Job Title Code" := "New Job Title";
                  if "New Grade Level" <> '' then
                    Employee."Grade Level Code" := "New Grade Level";
                  if "New Global Dimension 1 Code" <> '' then
                    Employee."Global Dimension 1 Code" := "New Global Dimension 1 Code";
                  if "New Global Dimension 2 Code" <> '' then
                    Employee."Global Dimension 2 Code" := "New Global Dimension 2 Code";
                  if ("New Category" <> '') then
                    Employee."Employee Category" := "New Category";
                  Employee.Modify;
                end;
              EmpUpdateHeader."entry type"::Upgrading:
                begin
                  Employee.Get("Employee No.");
                  Employee."Grade Level Code" := "New Grade Level";
                  if "New Global Dimension 1 Code" <> '' then
                    Employee."Global Dimension 1 Code" := "New Global Dimension 1 Code";
                  if "New Global Dimension 2 Code" <> '' then
                    Employee."Global Dimension 2 Code" := "New Global Dimension 2 Code";
                  if ("New Category" <> '') then
                    Employee."Employee Category" := "New Category";
                  if "New Job Title" <> '' then
                    Employee."Job Title Code" := "New Job Title";
                  Employee.Modify;
                end;
              EmpUpdateHeader."entry type"::"Redesignation/Transfer":
                begin
                  Employee.Get("Employee No.");
                  if "New Job Title" <> '' then
                    Employee."Job Title Code" := "New Job Title";
                  if "New Global Dimension 1 Code" <> '' then
                    Employee."Global Dimension 1 Code" := "New Global Dimension 1 Code";
                  if "New Global Dimension 2 Code" <> '' then
                    Employee."Global Dimension 2 Code" := "New Global Dimension 2 Code";
                  if "New Grade Level" <> '' then
                    Employee."Grade Level Code" := "New Grade Level";
                  if ("New Category" <> '') then
                    Employee."Employee Category" := "New Category";
                  Employee.Modify;
                end;
            end;
            UpdateEmplmentHistory(EmpUpdateHeader,EmpUpdateLine);
            UpdateSalaryGroup(EmpUpdateHeader,EmpUpdateLine);
          until EmpUpdateLine.Next = 0;
        end;
    end;

    local procedure UpdateEmplmentHistory(EmpUpdateHeader: Record "Employee Update Header";EmpUpdateLine: Record "Employee Update Line")
    begin
        with EmpUpdateLine do begin
          UpdatePrevEmplmentHistory(EmpUpdateHeader,EmpUpdateLine);

          EmploymentHistory.Init;
          EmploymentHistory."Record Type" := EmploymentHistory."record type"::Employee;
          EmploymentHistory."No." := "Employee No.";
          EmploymentHistory."Entry Type" := EmpUpdateHeader."Entry Type";
          GetNextEntryNo;
          EmploymentHistory."Line No." := NextEntryNo;
          EmploymentHistory."From Date" := "Effective Date";
          EmploymentHistory.Type := EmploymentHistory.Type::Internal;
          EmploymentHistory."Institution/Company" := CompanyInfo.Name;
          EmploymentHistory."To Date" := 0D;
          EmploymentHistory.Remark := Format(EmpUpdateHeader."Entry Type");

          if "New Job Title" <> '' then begin
            JobTitle.Get("New Job Title");
            EmploymentHistory."Job Title Code" := "New Job Title";
            EmploymentHistory."Old Job Title Code" := "Job Title Code";
            EmploymentHistory."Position Held" := JobTitle."Title/Description";
          end else begin
            JobTitle.Get("Job Title Code");
            EmploymentHistory."Job Title Code" := "Job Title Code";
            EmploymentHistory."Position Held" := JobTitle."Title/Description";
          end;

          if "New Global Dimension 1 Code" <> '' then
            EmploymentHistory."Global Dimension 1 Code" := "New Global Dimension 1 Code"
          else
            EmploymentHistory."Global Dimension 1 Code" := "Global Dimension 1 Code";

          if "New Global Dimension 2 Code" <>'' then begin
            EmploymentHistory."Global Dimension 2 Code" := "New Global Dimension 2 Code";
            EmploymentHistory."Old Global Dimension 2 Code" := "Global Dimension 2 Code";
          end else
            EmploymentHistory."Global Dimension 2 Code" := "Global Dimension 2 Code";

          if "New Grade Level" <> '' then begin
            EmploymentHistory."Grade Level" := "New Grade Level";
            EmploymentHistory."Old Grade Level" := "Grade Level";
          end else
            EmploymentHistory."Grade Level" := "Grade Level";

          if "New Gross Salary" <> 0 then begin
            EmploymentHistory.Salary := "New Gross Salary";
            EmploymentHistory."Old Gross Salary" := "Gross Salary";
          end else
            EmploymentHistory.Salary := "Gross Salary";

          EmploymentHistory."User ID" := UserId;
          EmploymentHistory."Document No.":= "Document No.";
          EmploymentHistory."Document Date" := EmpUpdateHeader."Document Date";
          EmploymentHistory."System Date" := Today;
          EmploymentHistory.Correction := Correction;
          EmploymentHistory.Insert;
        end;
    end;

    local procedure UpdatePrevEmplmentHistory(EmpUpdateHeader: Record "Employee Update Header";EmpUpdateLine: Record "Employee Update Line")
    var
        PrevEmploymentHistory: Record "Employment History";
    begin
        with EmpUpdateLine do begin
          PrevEmploymentHistory.SetRange("Record Type",PrevEmploymentHistory."record type"::Employee);
          PrevEmploymentHistory.SetRange("No.","Employee No.");
          PrevEmploymentHistory.SetRange("Entry Type",EmpUpdateHeader."Entry Type");
          if PrevEmploymentHistory.Find('+') then begin
            if PrevEmploymentHistory."To Date" = 0D then begin
              PrevEmploymentHistory."To Date" := "Effective Date";
              PrevEmploymentHistory.Modify;
            end;
          end;
        end;
    end;

    local procedure UpdateSalaryGroup(EmpUpdateHeader: Record "Employee Update Header";EmpUpdateLine: Record "Employee Update Line")
    var
        EmployeeSalary: Record "Employee Salary";
        EmpGroupLines: Record "Payroll-Employee Group Line";
        EmpGrpHeader: Record "Payroll-Employee Group Header";
    begin
        with EmpUpdateLine do begin
          if ("New Salary Group" <> '') then begin
            EmployeeSalary.Init;
            EmployeeSalary."Employee No." := "Employee No.";
            EmployeeSalary."Salary Group" := "New Salary Group";
            EmployeeSalary."Effective Date" := "Effective Date";
            EmpGrpHeader.Get("New Salary Group");
            EmpGroupLines.Get("New Salary Group",PayrollSetup."Annual Gross Pay E/D Code");
            if ("New Gross Salary" <> EmpGroupLines."Default Amount") and ("New Gross Salary" <> 0) then
              EmployeeSalary."Annual Gross Amount" := "New Gross Salary";
            EmployeeSalary."Currency Code" := EmpGrpHeader."Currency Code";
            EmployeeSalary.Insert
          end else if ("New Gross Salary" <> 0) then begin
            EmployeeSalary.Init;
            EmployeeSalary."Employee No." := "Employee No.";
            EmployeeSalary."Salary Group" := "Salary Group";
            EmployeeSalary."Effective Date" := "Effective Date";
            EmpGrpHeader.Get("Salary Group");
            EmployeeSalary."Annual Gross Amount" := "New Gross Salary";
            EmployeeSalary."Currency Code" := EmpGrpHeader."Currency Code";
            EmployeeSalary.Insert
          end;
        end;
    end;

    local procedure GetNextEntryNo()
    begin
        if NextEntryNo = 0 then begin
          EmploymentHistory.LockTable;
          if EmploymentHistory.FindLast then begin
            NextEntryNo := EmploymentHistory."Line No." + 1
          end else
            NextEntryNo += 1
        end else
          NextEntryNo += 1;
    end;
}

