Report 52092157 "Pension Remittance Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Pension Remittance Summary.rdlc';

    dataset
    {
        dataitem(PFA;"Pension Administrator")
        {
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1000000009; 1000000009)
            {
            }
            column(Code_PFA;PFA.Code)
            {
            }
            column(PFA_PFA_Code;PFA."PFA Code")
            {
            }
            column(PFA_PFCustodian;PFA."PF Custodian")
            {
            }
            column(PFA_Receiving_Bank;PFA."Receiving Bank")
            {
            }
            column(PFA_Receiving_Account;PFA."Receiving Account")
            {
            }
            column(PFA_Receiving_Account_Name;PFA."Receiving Account Name")
            {
            }
            column(PeriodRec_Name;PeriodRec.Name)
            {
            }
            column(ReportOrder;ReportOrder)
            {
            }
            column(CompanyInfo_Name;CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address;CompanyInfo.Address)
            {
            }
            column(CompanyInfo_Address2;CompanyInfo."Address 2")
            {
            }
            column(IsClosedPeriod;IsClosedPeriod)
            {
            }
            dataitem("Payroll-Payslip Header";"Payroll-Payslip Header")
            {
                DataItemLink = "Pension Adminstrator Code"=field(Code);
                RequestFilterFields = "Payroll Period","Employee Category";
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(Payslip_EmployeeNo;"Employee No.")
                {
                }
                column(Payslip_EmployeeName;"Employee Name")
                {
                }
                column(Payslip_PFA;"Pension Adminstrator Code")
                {
                }
                column(Payslip_Global_Dim1;"Global Dimension 1 Code")
                {
                }
                column(Employee_RSA;Employee."Pension No.")
                {
                }
                column(Gross_Amount;EDAmount[1])
                {
                }
                column(Contribution_Employee;EDAmount[2])
                {
                }
                column(Contribution_Employer;EDAmount[3])
                {
                }
                column(EmpCount;EmpCount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Employee.Get("Payroll-Payslip Header"."Employee No.");

                    Clear(EDAmount);

                    //Get Employee Contribution
                    SetFilter("ED Filter",PayrollSetup."Pension Employee E/D");
                    CalcFields("ED Amount");
                    EDAmount[2] := "ED Amount";

                    //Get Employer Contribution
                    SetFilter("ED Filter",PayrollSetup."Pension Employer E/D");
                    CalcFields("ED Amount");
                    EDAmount[3] := "ED Amount";

                    if (EDAmount[1] = 0) and (EDAmount[2] = 0) then
                      CurrReport.Skip;

                    EmpCount := EmpCount + 1;
                end;

                trigger OnPreDataItem()
                begin
                    if IsClosedPeriod then
                      CurrReport.Break;

                    case ReportOrder of
                      0:SetCurrentkey("Pension Adminstrator Code","Global Dimension 1 Code") ;
                      1:SetCurrentkey("Global Dimension 1 Code","Global Dimension 2 Code");
                    end;
                    UserSetup.Get(UserId);
                    if not(UserSetup."Payroll Administrator") then begin
                      FilterGroup(2);
                      SetFilter("Employee Category",UserSetup."Personnel Level");
                      FilterGroup(0);
                    end else
                      SetRange("Employee Category");
                end;
            }
            dataitem(ClosedPayroll;"Closed Payroll-Payslip Header")
            {
                DataItemLink = "Pension Adminstrator Code"=field(Code);
                DataItemTableView = sorting("Pension Adminstrator Code","Global Dimension 1 Code");
                column(ReportForNavId_13; 13)
                {
                }
                column(ClosedPayroll_EmployeeNo;ClosedPayroll."Employee No.")
                {
                }
                column(ClosedPayroll_EmployeeName;ClosedPayroll."Employee Name")
                {
                }
                column(ClosedPayroll_PFA;ClosedPayroll."Pension Adminstrator Code")
                {
                }
                column(ClosedPayroll_Global_Dim1;ClosedPayroll."Global Dimension 1 Code")
                {
                }
                column(ClosedPayroll_Employee_RSA;Employee."Pension No.")
                {
                }
                column(ClosedPayroll_Gross_Amount;EDAmount[1])
                {
                }
                column(ClosedPayroll_Contribution_Employee;EDAmount[2])
                {
                }
                column(ClosedPayroll_Contribution_Employer;EDAmount[3])
                {
                }
                column(ClosedPayroll_EmpCount;EmpCount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Employee.Get("Employee No.");

                    Clear(EDAmount);

                    //Get Employee Contribution
                    SetRange("ED Filter",PayrollSetup."Pension Employee E/D");
                    CalcFields("ED Amount");
                    EDAmount[2] := "ED Amount";

                    //Get Employer Contribution
                    SetRange("ED Filter",PayrollSetup."Pension Employer E/D");
                    CalcFields("ED Amount");
                    EDAmount[3] := "ED Amount";

                    if (EDAmount[1] = 0) and (EDAmount[2] = 0) then
                      CurrReport.Skip;

                    EmpCount := EmpCount + 1;
                end;

                trigger OnPreDataItem()
                begin
                    if not(IsClosedPeriod) then
                      CurrReport.Break;

                    ClosedPayroll.SetView("Payroll-Payslip Header".GetView);

                    case ReportOrder of
                      0:SetCurrentkey("Pension Adminstrator Code","Global Dimension 1 Code") ;
                      1:SetCurrentkey("Global Dimension 1 Code","Global Dimension 2 Code");
                    end;

                    UserSetup.Get(UserId);
                    if not(UserSetup."Payroll Administrator") then begin
                      FilterGroup(2);
                      SetFilter("Employee Category",UserSetup."Personnel Level");
                      FilterGroup(0);
                    end else
                      SetRange("Employee Category");
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ReportOrder;ReportOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show By';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        Report_Heading = 'Pension Remittance Summary';
    }

    trigger OnPreReport()
    begin
        if "Payroll-Payslip Header".GetFilter("Payroll-Payslip Header"."ED Filter") <> '' then
          Error(Text000);
        if "Payroll-Payslip Header".GetFilter("Payroll-Payslip Header"."Payroll Period") = '' then
          Error (Text001);

        PeriodRec.Get("Payroll-Payslip Header".GetFilter("Payroll Period"));
        IsClosedPeriod := PeriodRec.Closed;

        PayrollSetup.Get;
        PayrollSetup.TestField("Pension Employee E/D");
        PayrollSetup.TestField("Pension Employer E/D");
        CompanyInfo.Get;
    end;

    var
        CompanyInfo: Record "Company Information";
        PayrollSetup: Record "Payroll-Setup";
        Employee: Record "Payroll-Employee";
        PeriodRec: Record "Payroll-Period";
        PFA2: Record "Pension Administrator";
        UserSetup: Record "User Setup";
        EDAmount: array [3] of Decimal;
        Text000: label 'You must not specify ED Filter!';
        Text001: label 'Period Filter must be specified.';
        ReportOrder: Option PFA,"Dimension 1 Code";
        EmpCount: Integer;
        IsClosedPeriod: Boolean;
}

