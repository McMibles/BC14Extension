Report 52092362 "Employee Query Statistics"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Query Statistics.rdlc';

    dataset
    {
        dataitem(Employee; Employee)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.", "Employee Category", "Global Dimension 2 Code";
            column(ReportForNavId_7528; 7528)
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
            column(Employee__No__; "No.")
            {
            }
            column(Last_Name___________First_Name_; "Last Name" + ' ' + "First Name")
            {
            }
            column(Employee__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Employee__Staff_Category_; "Employee Category")
            {
            }
            column(NoOfQueries; NoOfQueries)
            {
                DecimalPlaces = 0 : 0;
            }
            column(NoOfQueries_Control16; NoOfQueries)
            {
                DecimalPlaces = 0 : 0;
            }
            column(Query_StatisticsCaption; Query_StatisticsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Last_Name___________First_Name_Caption; Last_Name___________First_Name_CaptionLbl)
            {
            }
            column(Employee__Global_Dimension_1_Code_Caption; Employee__Global_Dimension_1_Code_CaptionLbl)
            {
            }
            column(Employee__Staff_Category_Caption; FieldCaption("Employee Category"))
            {
            }
            column(NoOfQueriesCaption; NoOfQueriesCaptionLbl)
            {
            }
            column(Total_Queries_Caption; Total_Queries_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                EmplQuery.SetRange(EmplQuery."Employee No.", Employee."No.");
                NoOfQueries := 0;
                if EmplQuery.Find('-') then begin
                    repeat
                        NoOfQueries := NoOfQueries + 1;
                    until EmplQuery.Next = 0
                end
                else
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                //CurrReport.CreateTotals(NoOfQueries);
                if (FromDate <> 0D) and (ToDate <> 0D) then
                    EmplQuery.SetRange(EmplQuery."Date of Query", FromDate, ToDate)
                else
                    if (FromDate = 0D) and (ToDate <> 0D) then
                        EmplQuery.SetRange(EmplQuery."Date of Query", 0D, ToDate)
                    else
                        if (FromDate <> 0D) and (ToDate = 0D) then
                            EmplQuery.SetRange(EmplQuery."Date of Query", FromDate, Today)
                        else
                            EmplQuery.SetRange(EmplQuery."Date of Query");
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
        EmplQueryFilter := Employee.GetFilters;
    end;

    var
        EmplQuery: Record "Employee Query Entry";
        EmplQueryFilter: Text[250];
        iCount: Integer;
        NoOfQueries: Decimal;
        FromDate: Date;
        ToDate: Date;
        Query_StatisticsCaptionLbl: label 'Query Statistics';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Last_Name___________First_Name_CaptionLbl: label 'Employee Name';
        Employee__Global_Dimension_1_Code_CaptionLbl: label 'Dept Code';
        NoOfQueriesCaptionLbl: label 'No of Queries';
        Total_Queries_CaptionLbl: label 'Total Queries:';
}

