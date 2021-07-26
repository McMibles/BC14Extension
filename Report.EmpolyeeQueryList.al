Report 52092363 "Empolyee Query List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Empolyee Query List.rdlc';

    dataset
    {
        dataitem("Employee Query Entry"; "Employee Query Entry")
        {
            DataItemTableView = sorting("Employee No.", "Date of Query");
            RequestFilterFields = "Employee No.", "Global Dimension 1 Code", "Global Dimension 2 Code", Level, "Date of Query";
            column(ReportForNavId_5335; 5335)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(UserId; UserId)
            {
            }
            column(EmplQueryFilter; EmplQueryFilter)
            {
            }
            column(Employee_No___________EmployeeName; "Employee No." + ' ' + EmployeeName)
            {
            }
            column(Employee_Query_Entry__Date_of_Query_; "Date of Query")
            {
            }
            column(Employee_Query_Entry__Query_Ref__No__; "Query Ref. No.")
            {
            }
            column(Employee_Query_Entry_Level; Level)
            {
            }
            column(Employee_Query_Entry_Action; Action)
            {
            }
            column(Employee_Query_Entry_Offence; Offence)
            {
            }
            column(Employee_Query_Entry_Response; Response)
            {
            }
            column(Employee_Query_Entry_Explanation; Explanation)
            {
            }
            column(Employee_Query_Entry__Suspension_Duration_; "Suspension Duration")
            {
            }
            column(Employee_Query_ListCaption; Employee_Query_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_Query_Entry__Date_of_Query_Caption; FieldCaption("Date of Query"))
            {
            }
            column(Employee_Query_Entry__Query_Ref__No__Caption; FieldCaption("Query Ref. No."))
            {
            }
            column(Employee_Query_Entry_LevelCaption; FieldCaption(Level))
            {
            }
            column(Employee_Query_Entry_ActionCaption; FieldCaption(Action))
            {
            }
            column(Employee_Query_Entry_OffenceCaption; FieldCaption(Offence))
            {
            }
            column(Employee_Query_Entry_ResponseCaption; FieldCaption(Response))
            {
            }
            column(Employee_Query_Entry_ExplanationCaption; FieldCaption(Explanation))
            {
            }
            column(Employee_Query_Entry__Suspension_Duration_Caption; FieldCaption("Suspension Duration"))
            {
            }
            column(Employee_No___________EmployeeNameCaption; Employee_No___________EmployeeNameCaptionLbl)
            {
            }
            column(Employee_Query_Entry_Employee_No_; "Employee No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Employee.Get("Employee Query Entry"."Employee No.") then
                    EmployeeName := Employee."Last Name" + ' ' + Employee."First Name";
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Employee No.");
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
        EmplQueryFilter := "Employee Query Entry".GetFilters;
    end;

    var
        Employee: Record Employee;
        EmployeeName: Text[60];
        EmplQueryFilter: Text[250];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Employee_Query_ListCaptionLbl: label 'Employee Query List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Employee_No___________EmployeeNameCaptionLbl: label 'Employee';
}

