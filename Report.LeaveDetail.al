Report 52092350 "Leave Detail"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Leave Detail.rdlc';

    dataset
    {
        dataitem("Leave Schedule Header";"Leave Schedule Header")
        {
            RequestFilterFields = "Year No.","Global Dimension 1 Code";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(NoofDaysAdded_LeaveScheduleHeader;"Leave Schedule Header"."No. of Days Added")
            {
            }
            column(NoofDaysSubtracted_LeaveScheduleHeader;"Leave Schedule Header"."No. of Days Subtracted")
            {
            }
            column(NoofDaysUtilised_LeaveScheduleHeader;"Leave Schedule Header"."No. of Days Utilised")
            {
            }
            column(NoofDaysEntitled_LeaveScheduleHeader;"Leave Schedule Header"."No. of Days Entitled")
            {
            }
            column(NoofDaysBF_LeaveScheduleHeader;"Leave Schedule Header"."No. of Days B/F")
            {
            }
            column(GlobalDimension1Code_LeaveScheduleHeader;"Leave Schedule Header"."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_LeaveScheduleHeader;"Leave Schedule Header"."Global Dimension 2 Code")
            {
            }
            column(YearNo_LeaveScheduleHeader;"Leave Schedule Header"."Year No.")
            {
            }
            column(EmployeeNo_LeaveScheduleHeader;"Leave Schedule Header"."Employee No.")
            {
            }
            column(EmployeeName_LeaveScheduleHeader;"Leave Schedule Header"."Employee Name")
            {
            }
            column(AvailDays;"Leave Schedule Header".Balance)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SetFilter("Year Filter",'..%1',("Leave Schedule Header"."Year No." - 1));
                CalcFields("No. of Days Entitled","No. of Days B/F","No. of Days Utilised","No. of Days Added","No. of Days Subtracted",Balance);
            end;

            trigger OnPreDataItem()
            begin
                //SETFILTER("Year Filter",'..%1',DATE2DMY(TODAY,3) - 1);
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

    var
        Employeerec: Record Employee;
        AvailDays: Decimal;
        Posdays: Decimal;
        Negdays: Decimal;
}

