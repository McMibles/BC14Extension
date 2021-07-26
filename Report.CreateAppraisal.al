Report 52092365 "Create Appraisal"
{
    Caption = 'Create Performance';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(ReportForNavId_7528; 7528)
            {
            }
            dataitem("Appraisal Section";"Appraisal Section")
            {
                column(ReportForNavId_1; 1)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if UseTemplate then
                      CreateEmpTemplateEntry
                    else if UseEmployee then
                      CreateEmployeeEntry
                    else if UseJobTitle then
                      CreateJobTitleEntry
                    else if UseCategory then
                      CreateCategoryEntry
                    else if UseGradeLevel then
                      CreateGradeLeveEntry
                    else if UseDimensions then
                      CreateGlobalDimsEntry
                    else if UseGlobalDim1 then
                      CreateGlobalDim1Entry
                    else if UseGlobalDim2 then
                      CreateGlobalDim2Entry
                end;
            }

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                if  (YearNo = '') then
                  Error(Text001);

                HRSetup.Get;

                Employee.SetRange(Employee."Termination Date",0D);
                //Employee.SETFILTER(Employee."Appointment Status",'<>%1',Employee."Appointment Status"::Inactive);
                //Employee.SETFILTER(Employee."Employment Status",'<>%1',Employee."Employment Status"::Probation);

                AppraisalPeriod.Get(YearNo,AppType);
                if AppraisalPeriod.Closed then
                  Error(Text004);

                Window.Open(Text002);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(YearNo;YearNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Performance Period';
                    TableRelation = "Appraisal Period";
                }
                field(AppType;AppType)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appraisal Type';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        AppraisalTempHeader: Record "Appraisal Template Header";
        AppraisalTempLine: Record "Appraisal Template Line";
        AppraisalLine: Record "Appraisal Lines";
        AppraisalHeader: Record "Appraisal Header";
        AppraisalSection: Record "Appraisal Section";
        EmployeeRec: Record Employee;
        EmployAppTemplate: Record "Employee Appraisal Template";
        EmplHistory: Record "Employment History";
        HRSetup: Record "Human Resources Setup";
        AppraisalPeriod: Record "Appraisal Period";
        Trapper: Boolean;
        Section: Code[20];
        EmpNo: Code[20];
        AppraisedPeriod: Code[20];
        YearNo: Code[20];
        AppType: Option "Mid Year","Year End";
        ErrMsg: Text[120];
        PromDate: Date;
        NewDate: Date;
        Window: Dialog;
        Text001: label 'Appraisal Period Must No Be Empty';
        Text002: label 'Creating Appraisals For ###1########';
        Text003: label 'The EmployeeNo %1 does not have appraisal setup for %2 For the Year %3 %4';
        Text004: label 'Appraisal Period already closed';
        UserSetup: Record "User Setup";


    procedure CreateEmployeeEntry()
    begin
        AppraisalTempLine.Reset;
        AppraisalTempLine.SetCurrentkey("Appraisal Type","Section Code","Template Code","Line No.");
        AppraisalTempLine.SetRange(AppraisalTempLine."Section Code","Appraisal Section".Name);
        AppraisalTempLine.SetRange(AppraisalTempLine."Template Code",AppraisalTempHeader."Template Code");
        AppraisalTempLine.SetRange(AppraisalTempLine."Appraisal Type",AppraisalPeriod."Appraisal Type");
        if AppraisalTempLine.Find('-') then
          begin
            AppraisalHeader.Reset;
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Period",YearNo);
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
            AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.",Employee."No.");
            if not AppraisalHeader.Find('-') then
              begin
                AppraisalHeader.Init;
                AppraisalHeader."Section Code":= "Appraisal Section".Name;
                AppraisalHeader."Appraisal Period" := YearNo;
                AppraisalHeader."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalHeader.Validate(AppraisalHeader."Appraisee No.",Employee."No.");
                AppraisalHeader."Group Code" := AppraisalTempLine."Template Code";
                AppraisalHeader.Year := AppraisalPeriod.Year;
                AppraisalHeader."Date Appraised" := AppraisalPeriod."End Date";
                AppraisalHeader.Insert;
              end;
            repeat
              AppraisalLine.Init;
              AppraisalLine."Section Code" := "Appraisal Section".Name;
              AppraisalLine."Line No." := AppraisalTempLine."Line No.";
              AppraisalLine."Factor Code" := AppraisalTempLine.Code;
              AppraisalLine.Weight := AppraisalTempLine.Weight;
              AppraisalLine.Description := AppraisalTempLine.Description;
              AppraisalLine."Appraisal Period"  := YearNo;
              AppraisalLine."Appraisal Type" := AppraisalPeriod."Appraisal Type";
              AppraisalLine."Employee No." := Employee."No.";
              AppraisalLine."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
              AppraisalLine."Grade Level Code" := Employee."Grade Level Code";
              AppraisalLine."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
              AppraisalLine."Weighting %" := AppraisalTempLine."Weighting Percent";
              AppraisalLine."Template Code" := AppraisalTempLine."Template Code";
              AppraisalLine."Line Type" := AppraisalTempLine."Line Type";
              AppraisalLine.Insert;
            until AppraisalTempLine.Next = 0;
            Window.Update(1,Employee."No.");
          end;
    end;


    procedure CreateGradeLeveEntry()
    begin
        AppraisalTempLine.Reset;
        AppraisalTempLine.SetCurrentkey("Appraisal Type","Section Code","Template Code","Line No.");
        AppraisalTempLine.SetRange(AppraisalTempLine."Section Code","Appraisal Section".Name);
        AppraisalTempLine.SetRange(AppraisalTempLine."Template Code",AppraisalTempHeader."Template Code");
        AppraisalTempLine.SetRange(AppraisalTempLine."Appraisal Type",AppraisalPeriod."Appraisal Type");
        if AppraisalTempLine.Find('-') then
          begin
            AppraisalHeader.Reset;
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Period",YearNo);
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
            AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.",Employee."No.");
            if not AppraisalHeader.Find('-') then
              begin
                AppraisalHeader.Init;
                AppraisalHeader."Section Code":= "Appraisal Section".Name;
                AppraisalHeader."Appraisal Period" := YearNo;
                AppraisalHeader."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalHeader.Validate(AppraisalHeader."Appraisee No.",Employee."No.");
                AppraisalHeader."Group Code" := AppraisalTempLine."Template Code";
                AppraisalHeader.Year := AppraisalPeriod.Year;
                AppraisalHeader."Date Appraised" := AppraisalPeriod."End Date";
                AppraisalHeader.Insert;
              end;
              repeat
                AppraisalLine.Init;
                AppraisalLine."Section Code" := "Appraisal Section".Name;
                AppraisalLine."Line No." := AppraisalTempLine."Line No.";
                AppraisalLine."Factor Code" := AppraisalTempLine.Code;
                AppraisalLine.Weight := AppraisalTempLine.Weight;
                AppraisalLine.Description := AppraisalTempLine.Description;
                AppraisalLine."Appraisal Period"  := YearNo;
                AppraisalLine."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalLine."Employee No." := Employee."No.";
                AppraisalLine."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
                AppraisalLine."Grade Level Code" := Employee."Grade Level Code";
                AppraisalLine."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
                AppraisalLine."Weighting %" := AppraisalTempLine."Weighting Percent";
                AppraisalLine."Template Code" := AppraisalTempLine."Template Code";
                AppraisalLine."Line Type" := AppraisalTempLine."Line Type";
                AppraisalLine.Insert;
              until AppraisalTempLine.Next = 0;
              Window.Update(1,Employee."No.");
          end;
    end;


    procedure CreateGlobalDim1Entry()
    begin
        AppraisalTempLine.Reset;
        AppraisalTempLine.SetCurrentkey("Appraisal Type","Section Code","Template Code","Line No.");
        AppraisalTempLine.SetRange(AppraisalTempLine."Section Code","Appraisal Section".Name);
        AppraisalTempLine.SetRange(AppraisalTempLine."Template Code",AppraisalTempHeader."Template Code");
        AppraisalTempLine.SetRange(AppraisalTempLine."Appraisal Type",AppraisalPeriod."Appraisal Type");
        if AppraisalTempLine.Find('-') then
          begin
            AppraisalHeader.Reset;
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Period",YearNo);
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
            AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.",Employee."No.");
            if not AppraisalHeader.Find('-') then
              begin
                AppraisalHeader.Init;
                AppraisalHeader."Section Code":= "Appraisal Section".Name;
                AppraisalHeader."Appraisal Period" := YearNo;
                AppraisalHeader."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalHeader.Validate(AppraisalHeader."Appraisee No.",Employee."No.");
                AppraisalHeader."Group Code" := AppraisalTempLine."Template Code";
                AppraisalHeader.Year := AppraisalPeriod.Year;
                AppraisalHeader."Date Appraised" := AppraisalPeriod."End Date";
                AppraisalHeader.Insert;
              end;
            repeat
              AppraisalLine.Init;
              AppraisalLine."Section Code" := "Appraisal Section".Name;
              AppraisalLine."Line No." := AppraisalTempLine."Line No.";
              AppraisalLine."Factor Code" := AppraisalTempLine.Code;
              AppraisalLine.Weight := AppraisalTempLine.Weight;
              AppraisalLine.Description := AppraisalTempLine.Description;
              AppraisalLine."Appraisal Period"  := YearNo;
              AppraisalLine."Appraisal Type" := AppraisalPeriod."Appraisal Type";
              AppraisalLine."Employee No." := Employee."No.";
              AppraisalLine."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
              AppraisalLine."Grade Level Code" := Employee."Grade Level Code";
              AppraisalLine."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
              AppraisalLine."Weighting %" := AppraisalTempLine."Weighting Percent";
              AppraisalLine."Template Code" := AppraisalTempLine."Template Code";
              AppraisalLine."Line Type" := AppraisalTempLine."Line Type";
              AppraisalLine.Insert;
            until AppraisalTempLine.Next = 0;
            Window.Update(1,Employee."No.");
          end;
    end;


    procedure CreateGlobalDim2Entry()
    begin
        AppraisalTempLine.Reset;
        AppraisalTempLine.SetCurrentkey("Appraisal Type","Section Code","Template Code","Line No.");
        AppraisalTempLine.SetRange(AppraisalTempLine."Section Code","Appraisal Section".Name);
        AppraisalTempLine.SetRange(AppraisalTempLine."Template Code",AppraisalTempHeader."Template Code");
        AppraisalTempLine.SetRange(AppraisalTempLine."Appraisal Type",AppraisalPeriod."Appraisal Type");
        if AppraisalTempLine.Find('-') then
          begin
            AppraisalHeader.Reset;
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Period",YearNo);
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
            AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.",Employee."No.");
            if not AppraisalHeader.Find('-') then
              begin
                AppraisalHeader.Init;
                AppraisalHeader."Section Code":= "Appraisal Section".Name;
                AppraisalHeader."Appraisal Period" := YearNo;
                AppraisalHeader."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalHeader.Validate(AppraisalHeader."Appraisee No.",Employee."No.");
                AppraisalHeader."Group Code" := AppraisalTempLine."Template Code";
                AppraisalHeader.Year := AppraisalPeriod.Year;
                AppraisalHeader."Date Appraised" := AppraisalPeriod."End Date";
                AppraisalHeader.Insert;
              end;
            repeat
              AppraisalLine.Init;
              AppraisalLine."Section Code" := "Appraisal Section".Name;
              AppraisalLine."Line No." := AppraisalTempLine."Line No.";
              AppraisalLine."Factor Code" := AppraisalTempLine.Code;
              AppraisalLine.Weight := AppraisalTempLine.Weight;
              AppraisalLine.Description := AppraisalTempLine.Description;
              AppraisalLine."Appraisal Period"  := YearNo;
              AppraisalLine."Appraisal Type" := AppraisalPeriod."Appraisal Type";
              AppraisalLine."Employee No." := Employee."No.";
              AppraisalLine."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
              AppraisalLine."Grade Level Code" := Employee."Grade Level Code";
              AppraisalLine."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
              AppraisalLine."Weighting %" := AppraisalTempLine."Weighting Percent";
              AppraisalLine."Template Code" := AppraisalTempLine."Template Code";
              AppraisalLine."Line Type" := AppraisalTempLine."Line Type";
              AppraisalLine.Insert;
            until AppraisalTempLine.Next = 0;
            Window.Update(1,Employee."No.");
          end;
    end;


    procedure CreateJobTitleEntry()
    begin
        AppraisalTempLine.Reset;
        AppraisalTempLine.SetCurrentkey("Appraisal Type","Section Code","Template Code","Line No.");
        AppraisalTempLine.SetRange(AppraisalTempLine."Section Code","Appraisal Section".Name);
        AppraisalTempLine.SetRange(AppraisalTempLine."Template Code",AppraisalTempHeader."Template Code");
        AppraisalTempLine.SetRange(AppraisalTempLine."Appraisal Type",AppraisalPeriod."Appraisal Type");
        if AppraisalTempLine.Find('-') then
          begin
            AppraisalHeader.Reset;
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Period",YearNo);
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
            AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.",Employee."No.");
            if not AppraisalHeader.Find('-') then
              begin
                AppraisalHeader.Init;
                AppraisalHeader."Section Code":= "Appraisal Section".Name;
                AppraisalHeader."Appraisal Period" := YearNo;
                AppraisalHeader."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalHeader.Validate(AppraisalHeader."Appraisee No.",Employee."No.");
                AppraisalHeader."Group Code" := AppraisalTempLine."Template Code";
                AppraisalHeader.Year := AppraisalPeriod.Year;
                AppraisalHeader."Date Appraised" := AppraisalPeriod."End Date";
                AppraisalHeader.Insert;
              end;
            repeat
              AppraisalLine.Init;
              AppraisalLine."Section Code" := "Appraisal Section".Name;
              AppraisalLine."Line No." := AppraisalTempLine."Line No.";
              AppraisalLine."Factor Code" := AppraisalTempLine.Code;
              AppraisalLine.Weight := AppraisalTempLine.Weight;
              AppraisalLine.Description := AppraisalTempLine.Description;
              AppraisalLine."Appraisal Period"  := YearNo;
              AppraisalLine."Appraisal Type" := AppraisalPeriod."Appraisal Type";
              AppraisalLine."Employee No." := Employee."No.";
              AppraisalLine."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
              AppraisalLine."Grade Level Code" := Employee."Grade Level Code";
              AppraisalLine."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
              AppraisalLine."Weighting %" := AppraisalTempLine."Weighting Percent";
              AppraisalLine."Template Code" := AppraisalTempLine."Template Code";
              AppraisalLine."Line Type" := AppraisalTempLine."Line Type";
              AppraisalLine.Insert;
            until AppraisalTempLine.Next = 0;
            Window.Update(1,Employee."No.");
          end;
    end;


    procedure CreateCategoryEntry()
    begin
        AppraisalTempLine.Reset;
        AppraisalTempLine.SetCurrentkey("Appraisal Type","Section Code","Template Code","Line No.");
        AppraisalTempLine.SetRange(AppraisalTempLine."Section Code","Appraisal Section".Name);
        AppraisalTempLine.SetRange(AppraisalTempLine."Template Code",AppraisalTempHeader."Template Code");
        AppraisalTempLine.SetRange(AppraisalTempLine."Appraisal Type",AppraisalPeriod."Appraisal Type");
        if AppraisalTempLine.Find('-') then
          begin
            AppraisalHeader.Reset;
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Period",YearNo);
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
            AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.",Employee."No.");
            if not AppraisalHeader.Find('-') then
              begin
                AppraisalHeader.Init;
                AppraisalHeader."Section Code":= "Appraisal Section".Name;
                AppraisalHeader."Appraisal Period" := YearNo;
                AppraisalHeader."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalHeader.Validate(AppraisalHeader."Appraisee No.",Employee."No.");
                AppraisalHeader."Group Code" := AppraisalTempLine."Template Code";
                AppraisalHeader.Year := AppraisalPeriod.Year;
                AppraisalHeader."Date Appraised" := AppraisalPeriod."End Date";
                AppraisalHeader.Insert;
              end;
            repeat
              AppraisalLine.Init;
              AppraisalLine."Section Code" := "Appraisal Section".Name;
              AppraisalLine."Line No." := AppraisalTempLine."Line No.";
              AppraisalLine."Factor Code" := AppraisalTempLine.Code;
              AppraisalLine.Weight := AppraisalTempLine.Weight;
              AppraisalLine.Description := AppraisalTempLine.Description;
              AppraisalLine."Appraisal Period"  := YearNo;
              AppraisalLine."Appraisal Type" := AppraisalPeriod."Appraisal Type";
              AppraisalLine."Employee No." := Employee."No.";
              AppraisalLine."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
              AppraisalLine."Grade Level Code" := Employee."Grade Level Code";
              AppraisalLine."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
              AppraisalLine."Weighting %" := AppraisalTempLine."Weighting Percent";
              AppraisalLine."Template Code" := AppraisalTempLine."Template Code";
              AppraisalLine."Line Type" := AppraisalTempLine."Line Type";
              AppraisalLine.Insert;
            until AppraisalTempLine.Next = 0;
            Window.Update(1,Employee."No.");
          end;
    end;


    procedure CreateEmpTemplateEntry()
    begin
        AppraisalTempLine.Reset;
        AppraisalTempLine.SetCurrentkey("Appraisal Type","Section Code","Template Code","Line No.");
        AppraisalTempLine.SetRange(AppraisalTempLine."Section Code","Appraisal Section".Name);
        AppraisalTempLine.SetRange(AppraisalTempLine."Template Code",EmployAppTemplate."Group Code");
        AppraisalTempLine.SetRange(AppraisalTempLine."Appraisal Type",AppraisalPeriod."Appraisal Type");
        if AppraisalTempLine.Find('-') then
          begin
            AppraisalHeader.Reset;
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Period",YearNo);
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
            AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.",Employee."No.");
            if not AppraisalHeader.Find('-') then
              begin
                AppraisalHeader.Init;
                AppraisalHeader."Section Code":= "Appraisal Section".Name;
                AppraisalHeader."Appraisal Period" := YearNo;
                AppraisalHeader."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalHeader.Validate(AppraisalHeader."Appraisee No.",Employee."No.");
                AppraisalHeader."Group Code" := AppraisalTempLine."Template Code";
                AppraisalHeader.Year := AppraisalPeriod.Year;
                AppraisalHeader."Date Appraised" := AppraisalPeriod."End Date";
                AppraisalHeader.Insert;
              end;
            repeat
              AppraisalLine.Init;
              AppraisalLine."Section Code" := "Appraisal Section".Name;
              AppraisalLine."Line No." := AppraisalTempLine."Line No.";
              AppraisalLine."Factor Code" := AppraisalTempLine.Code;
              AppraisalLine.Weight := AppraisalTempLine.Weight;
              AppraisalLine.Description := AppraisalTempLine.Description;
              AppraisalLine."Appraisal Period"  := YearNo;
              AppraisalLine."Appraisal Type" := AppraisalPeriod."Appraisal Type";
              AppraisalLine."Employee No." := Employee."No.";
              AppraisalLine."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
              AppraisalLine."Grade Level Code" := Employee."Grade Level Code";
              AppraisalLine."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
              AppraisalLine."Weighting %" := AppraisalTempLine."Weighting Percent";
              AppraisalLine."Template Code" := AppraisalTempLine."Template Code";
              AppraisalLine."Line Type" := AppraisalTempLine."Line Type";
              AppraisalLine.Insert;
            until AppraisalTempLine.Next = 0;
            Window.Update(1,Employee."No.");
          end;
    end;


    procedure CreateGlobalDimsEntry()
    begin
        AppraisalTempLine.Reset;
        AppraisalTempLine.SetCurrentkey("Appraisal Type","Section Code","Template Code","Line No.");
        AppraisalTempLine.SetRange(AppraisalTempLine."Section Code","Appraisal Section".Name);
        AppraisalTempLine.SetRange(AppraisalTempLine."Template Code",AppraisalTempHeader."Template Code");
        AppraisalTempLine.SetRange(AppraisalTempLine."Appraisal Type",AppraisalPeriod."Appraisal Type");
        if AppraisalTempLine.Find('-') then
          begin
            AppraisalHeader.Reset;
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Period",YearNo);
            AppraisalHeader.SetRange(AppraisalHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
            AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.",Employee."No.");
            if not AppraisalHeader.Find('-') then
              begin
                AppraisalHeader.Init;
                AppraisalHeader."Section Code":= "Appraisal Section".Name;
                AppraisalHeader."Appraisal Period" := YearNo;
                AppraisalHeader."Appraisal Type" := AppraisalPeriod."Appraisal Type";
                AppraisalHeader.Validate(AppraisalHeader."Appraisee No.",Employee."No.");
                AppraisalHeader."Group Code" := AppraisalTempLine."Template Code";
                AppraisalHeader.Year := AppraisalPeriod.Year;
                AppraisalHeader."Date Appraised" := AppraisalPeriod."End Date";
                AppraisalHeader.Insert;
              end;
            repeat
              AppraisalLine.Init;
              AppraisalLine."Section Code" := "Appraisal Section".Name;
              AppraisalLine."Line No." := AppraisalTempLine."Line No.";
              AppraisalLine."Factor Code" := AppraisalTempLine.Code;
              AppraisalLine.Weight := AppraisalTempLine.Weight;
              AppraisalLine.Description := AppraisalTempLine.Description;
              AppraisalLine."Appraisal Period"  := YearNo;
              AppraisalLine."Appraisal Type" := AppraisalPeriod."Appraisal Type";
              AppraisalLine."Employee No." := Employee."No.";
              AppraisalLine."Global Dimension 1 Code" := Employee."Global Dimension 1 Code";
              AppraisalLine."Grade Level Code" := Employee."Grade Level Code";
              AppraisalLine."Global Dimension 2 Code" := Employee."Global Dimension 2 Code";
              AppraisalLine."Weighting %" := AppraisalTempLine."Weighting Percent";
              AppraisalLine."Template Code" := AppraisalTempLine."Template Code";
              AppraisalLine."Line Type" := AppraisalTempLine."Line Type";
              AppraisalLine.Insert;
            until AppraisalTempLine.Next = 0;
            Window.Update(1,Employee."No.");
          end;
    end;

    local procedure UseTemplate(): Boolean
    begin
        EmployAppTemplate.Reset;
        EmployAppTemplate.SetRange(EmployAppTemplate."Section Code","Appraisal Section".Name);
        EmployAppTemplate.SetRange(EmployAppTemplate."Employee No.",Employee."No.");
        EmployAppTemplate.SetRange(EmployAppTemplate."Appraisal Type",AppraisalPeriod."Appraisal Type");
        EmployAppTemplate.SetRange(EmployAppTemplate.Status,EmployAppTemplate.Status::Certified);
        if ((EmployAppTemplate.Find('-')) and (EmployAppTemplate.Find('='))) then
          exit(true)
        else
          exit(false);
    end;

    local procedure UseEmployee(): Boolean
    begin
        AppraisalTempHeader.Reset;
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Section Code","Appraisal Section".Name);
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Employee No.",Employee."No.");
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
        AppraisalTempHeader.SetRange(AppraisalTempHeader.Status,AppraisalTempHeader.Status::Approved);
        if ((AppraisalTempHeader.Find('-')) and (AppraisalTempHeader.Find('='))) then
          exit(true)
        else
          exit(false)
    end;

    local procedure UseJobTitle(): Boolean
    begin
        if Employee."Job Title Code" = '' then
          exit(false);
        AppraisalTempHeader.Reset;
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Section Code","Appraisal Section".Name);
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Job Title Code",Employee."Job Title Code");
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
        AppraisalTempHeader.SetRange(AppraisalTempHeader.Status,AppraisalTempHeader.Status::Approved);
        if ((AppraisalTempHeader.Find('-')) and (AppraisalTempHeader.Find('='))) then
          exit(true)
        else
          exit(false)
    end;

    local procedure UseCategory(): Boolean
    begin
        if Employee."Employee Category" = '' then
          exit(false);
        AppraisalTempHeader.Reset;
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Section Code","Appraisal Section".Name);
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Staff Category",Employee."Employee Category");
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
        AppraisalTempHeader.SetRange(AppraisalTempHeader.Status,AppraisalTempHeader.Status::Approved);
        if ((AppraisalTempHeader.Find('-')) and (AppraisalTempHeader.Find('='))) then
          exit(true)
        else
          exit(false)
    end;

    local procedure UseGradeLevel(): Boolean
    begin
        if Employee."Grade Level Code" = '' then
          exit(false);
        AppraisalTempHeader.Reset;
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Section Code","Appraisal Section".Name);
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Grade Level Code",Employee."Grade Level Code");
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
        AppraisalTempHeader.SetRange(AppraisalTempHeader.Status,AppraisalTempHeader.Status::Approved);
        if ((AppraisalTempHeader.Find('-')) and (AppraisalTempHeader.Find('='))) then
          exit(true)
        else
          exit(false)
    end;

    local procedure UseDimensions(): Boolean
    begin
        if (Employee."Global Dimension 1 Code" = '') and (Employee."Global Dimension 2 Code" = '') then
          exit(false);
        AppraisalTempHeader.Reset;
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Section Code","Appraisal Section".Name);
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Global Dimension 1 Code",Employee."Global Dimension 1 Code");
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Global Dimension 2 Code",Employee."Global Dimension 2 Code");
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
        AppraisalTempHeader.SetRange(AppraisalTempHeader.Status,AppraisalTempHeader.Status::Approved);
        if ((AppraisalTempHeader.Find('-')) and (AppraisalTempHeader.Find('='))) then
          exit(true)
        else
          exit(false)
    end;

    local procedure UseGlobalDim1(): Boolean
    begin
        if Employee."Global Dimension 1 Code" ='' then
          exit(false);
        if (Employee."Global Dimension 1 Code" <> '') and (Employee."Global Dimension 2 Code" <> '') then
          exit(false);
        AppraisalTempHeader.Reset;
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Section Code","Appraisal Section".Name);
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Global Dimension 1 Code",Employee."Global Dimension 1 Code");
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
        AppraisalTempHeader.SetRange(AppraisalTempHeader.Status,AppraisalTempHeader.Status::Approved);
        if ((AppraisalTempHeader.Find('-')) and (AppraisalTempHeader.Find('='))) then
          exit(true)
        else
          exit(false)
    end;

    local procedure UseGlobalDim2(): Boolean
    begin
        if Employee."Global Dimension 2 Code" = '' then
          exit(false);
        if (Employee."Global Dimension 1 Code" <> '') and (Employee."Global Dimension 2 Code" <> '') then
          exit(false);
        AppraisalTempHeader.Reset;
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Section Code","Appraisal Section".Name);
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Global Dimension 2 Code",Employee."Global Dimension 2 Code");
        AppraisalTempHeader.SetRange(AppraisalTempHeader."Appraisal Type",AppraisalPeriod."Appraisal Type");
        AppraisalTempHeader.SetRange(AppraisalTempHeader.Status,AppraisalTempHeader.Status::Approved);
        if ((AppraisalTempHeader.Find('-')) and (AppraisalTempHeader.Find('='))) then
          exit(true)
        else
          exit(false)
    end;

    local procedure Create()
    begin
    end;
}

