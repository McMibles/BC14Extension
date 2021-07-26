Report 52092358 "Employee - Age Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee - Age Report.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            //DataItemTableView = sorting("Birth Date");
            RequestFilterFields = "No.", "Employee Category";
            column(ReportForNavId_7528; 7528)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PageNo)
            // {
            // }
            column(UserId; UserId)
            {
            }
            column(Employee_TABLENAME__________EmployeeFilter; Employee.TableName + ': ' + EmployeeFilter)
            {
            }
            column(Employee__No__; "No.")
            {
            }
            column(FullName; FullName)
            {
            }
            column(Employee__Birth_Date_; "Birth Date")
            {
            }
            column(SerialNo; SerialNo)
            {
            }
            column(Age; Age)
            {
            }
            column(GlobalDim1Text; GlobalDim1Text)
            {
            }
            column(Employee_Employee_Designation; Employee.Designation)
            {
            }
            column(Employee___AgeCaption; Employee___AgeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Full_NameCaption; Full_NameCaptionLbl)
            {
            }
            column(Employee__Birth_Date_Caption; FieldCaption("Birth Date"))
            {
            }
            column(SerialNoCaption; SerialNoCaptionLbl)
            {
            }
            column(AgeCaption; AgeCaptionLbl)
            {
            }
            column(Department_CodeCaption; Department_CodeCaptionLbl)
            {
            }
            column(Employee_Employee_DesignationCaption; Employee_Employee_DesignationCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SerialNo := SerialNo + 1;
                if Employee."Birth Date" <> 0D then
                    Age := ((Date2dmy(Today, 3)) - (Date2dmy(Employee."Birth Date", 3)));
                GlobalDim1Text := DimensionMgt.ReturnDimName(1, Employee."Global Dimension 1 Code");
                GlobalDim2Text := DimensionMgt.ReturnDimName(2, Employee."Global Dimension 2 Code");
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
                SerialNo := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        EmployeeFilter := Employee.GetFilters;
    end;

    var
        LastFieldNo: Integer;
        SerialNo: Integer;
        Age: Integer;
        EmployeeFilter: Text[250];
        GlobalDim1Text: Text[50];
        GlobalDim2Text: Text[50];
        DimensionMgt: Codeunit "Dimension Hook";
        Employee___AgeCaptionLbl: label 'Employee - Age';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Full_NameCaptionLbl: label 'Full Name';
        SerialNoCaptionLbl: label 'S/N';
        AgeCaptionLbl: label 'Age';
        Department_CodeCaptionLbl: label 'Department Code';
        Employee_Employee_DesignationCaptionLbl: label 'Designation';
}

