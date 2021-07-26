Report 52092352 "Apply Appraisal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Apply Appraisal.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            //DataItemTableView = sorting("Global Dimension 1 Code", "Grade Level Code");
            RequestFilterFields = "No.", "Employee Category", "Global Dimension 1 Code";
            column(ReportForNavId_7528; 7528)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(APPRAISAL_REPORT_________FOR_YEAR___________FORMAT_YearNo_; 'APPRAISAL REPORT ' + ' ' + 'FOR YEAR ' + ' ' + Format(YearNo))
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(UserId; UserId)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(Employee__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(Employee_Designation; Designation)
            {
            }
            column(BasicSalary; GrossSalary)
            {
            }
            column(TotalScore; TotalScore)
            {
            }
            column(New_Basic_Salary; NewGrossSalary)
            {
            }
            column(RemarkText; RemarkText)
            {
            }
            column(Employee_FullName_TRUE_; Employee.FullName)
            {
            }
            column(BasicSalary_Control1000000018; GrossSalary)
            {
            }
            column(Total_for______Global_Dimension_1_Code__; 'Total for ' + ("Global Dimension 1 Code"))
            {
            }
            column(BasicSalary_Control1000000020; GrossSalary)
            {
            }
            column(GRAND_TOTAL_; 'GRAND TOTAL')
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(NOTE__APPRAISALS_NOT_YET_APPLIED_TO_ADJUST_SALARYCaption; NOTE__APPRAISALS_NOT_YET_APPLIED_TO_ADJUST_SALARYCaptionLbl)
            {
            }
            column(NOTE__APPRAISALS_ALREADY_APPLIED_TO_ADJUST_SALARYCaption; NOTE__APPRAISALS_ALREADY_APPLIED_TO_ADJUST_SALARYCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Employee_FullName_TRUE_Caption; Employee_FullName_TRUE_CaptionLbl)
            {
            }
            column(Employee_DesignationCaption; FieldCaption(Designation))
            {
            }
            column(BasicSalaryCaption; BasicSalaryCaptionLbl)
            {
            }
            column(TotalScoreCaption; TotalScoreCaptionLbl)
            {
            }
            column(RemarkTextCaption; RemarkTextCaptionLbl)
            {
            }
            column(Employee__Global_Dimension_1_Code_Caption; FieldCaption("Global Dimension 1 Code"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                if (Employee."Termination Date" <> 0D) then
                    if (Date2dmy(Employee."Termination Date", 3) <= YearNo) then
                        CurrReport.Skip;

                PayrollMgt.GetSalaryStructure(Employee."No.", Today, EmployeeGroup, GrossSalary, EmpGrpEffectiveDate);

                AppraisalHeader.SetRange(AppraisalHeader.Year, YearNo);
                AppraisalHeader.SetRange(AppraisalHeader."Appraisee No.", Employee."No.");
                AppraisalHeader.SetRange(AppraisalHeader."Appraisal Ready", true);


                if AppraisalHeader.Count > 2 then
                    Error(Text001, Employee."No.");

                if not AppraisalHeader.Find('-') then
                    NoAppraisal := true
                else begin
                    if AppraisalHeader.Closed then
                        Error(Text002, Employee."No.");
                    NoAppraisal := true;
                    TotalScore := 0;
                    iCount := 0;
                    NewGrossSalary := 0;
                    repeat
                        AppraisalHeader.CalcFields(AppraisalHeader."Sectional Weight Score");
                        TotalScore := TotalScore + AppraisalHeader."Sectional Weight Score";
                        iCount := iCount + 1;
                        if AppraisalHeader."Appraisal Type" = AppraisalHeader."appraisal type"::"Year End" then begin
                            NoAppraisal := false;
                            if (AppraisalHeader.Status <> AppraisalHeader.Status::Approved) and (ApplyAppraisal) then
                                Error(Text010);

                            if AppraisalHeader.Recommendation = AppraisalHeader.Recommendation::Demotion
                              then
                                CurrReport.Skip;
                        end;
                    until AppraisalHeader.Next = 0;

                    TotalScore := TotalScore / iCount;

                end;
                if NoAppraisal then CurrReport.Skip;

                if (not NoAppraisal) then begin
                    EmployeeRatingSetup.Get(AppraisalHeader."Employee Category");
                    if EmployeeRatingSetup."Rating type" = EmployeeRatingSetup."rating type"::Grading then
                        UseGrade
                    else
                        UsePercentage;
                end;
                if ApplyAppraisal then
                    AppraisalHeader.ModifyAll(Closed, true);
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                if ApplyAppraisal then
                    Message(Text007);
            end;

            trigger OnPreDataItem()
            begin
                Window.Open('APPLYING APPRAISAL')
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(YearNo; YearNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Enter Year';
                }
                field(ApplyAppraisal; ApplyAppraisal)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Appraisal';
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ApplyAppraisal := false;
            if YearNo = 0 then
                YearNo := Date2dmy(WorkDate, 3);
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if YearNo = 0 then Error(Text006);
        if not Confirm(Text008, false) then
            Error(Text009);
    end;

    var
        HRSetup: Record "Human Resources Setup";
        AppraisalHeader: Record "Appraisal Header";
        AppraisalPeriod: Record "Appraisal Period";
        GradeLevel: Record "Grade Level";
        Grading: Record "Appraisal Grading";
        EmployeeRatingSetup: Record "Employee Category Rating Setup";
        EmplHistory: Record "Employment History";
        EmployeeSalary: Record "Employee Salary";
        EmployeeGroup: Code[20];
        GrossSalary: Decimal;
        NewGrossSalary: Decimal;
        YearNo: Integer;
        Text001: label 'Multiple appraisals found for %1!';
        Text002: label 'Appraisal already appplied for %1!';
        Text003: label 'Unexpected score on %1 %2 %3!';
        Text004: label 'Grade level %1 on %2 does not exist!';
        Text006: label 'Year must be entered!';
        iCount: Integer;
        NoofSteps: Integer;
        TotalScore: Decimal;
        NoAppraisal: Boolean;
        ApplyAppraisal: Boolean;
        RemarkText: Text[30];
        PayrollMgt: Codeunit "Payroll-Management";
        Window: Dialog;
        Text007: label 'Appraisal successfully applied';
        Text008: label 'You have selected apply appraiser, this may lead to a change in salary. Do you want to continue?';
        Text009: label 'Action aborted!!';
        Text010: label 'Appraisal for employee %1 not yet approved. Function cannot be completed';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NOTE__APPRAISALS_NOT_YET_APPLIED_TO_ADJUST_SALARYCaptionLbl: label 'NOTE: APPRAISALS NOT YET APPLIED TO ADJUST SALARY';
        NOTE__APPRAISALS_ALREADY_APPLIED_TO_ADJUST_SALARYCaptionLbl: label 'NOTE: APPRAISALS ALREADY APPLIED TO ADJUST SALARY';
        Employee_FullName_TRUE_CaptionLbl: label 'Name';
        BasicSalaryCaptionLbl: label 'Label1000000009';
        TotalScoreCaptionLbl: label 'Total Score';
        RemarkTextCaptionLbl: label 'Remarks';
        EmpGrpEffectiveDate: Date;


    procedure UsePercentage()
    begin
        Grading."Lower Score" := TotalScore;
        Grading.Find('=<');
        AppraisalPeriod.Get(AppraisalHeader."Appraisal Period");
        if (Grading."Percentage %" <> 0) then begin
            if ApplyAppraisal then begin
                EmployeeSalary.Init;
                EmployeeSalary."Employee No." := Employee."No.";
                EmployeeSalary."Effective Date" := AppraisalPeriod."End Date";
                EmployeeSalary."Salary Group" := EmployeeGroup;
                EmployeeSalary."Annual Gross Amount" := GrossSalary + ROUND((GrossSalary * Grading."Percentage %" / 100));
                NewGrossSalary := EmployeeSalary."Annual Gross Amount";
                EmployeeSalary."Appraisal Period" := AppraisalHeader."Appraisal Period";
                EmployeeSalary.Insert;
            end else
                NewGrossSalary := GrossSalary + ROUND((GrossSalary * Grading."Percentage %" / 100));
        end else
            NewGrossSalary := 0;
    end;


    procedure UseGrade()
    begin
        // use the grading table to determine No. of steps for the employee
        Grading."Lower Score" := TotalScore;
        Grading.Find('=<');
    end;


    procedure SetAppraisalYear(var YearNo2: Integer)
    begin
        YearNo := YearNo2
    end;
}

