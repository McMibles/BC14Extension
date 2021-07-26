Report 52092197 "Flag Oust. Leave Allowance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Flag Oust. Leave Allowance.rdlc';

    dataset
    {
        dataitem(Employee; "Payroll-Employee")
        {
            DataItemTableView = sorting("Global Dimension 1 Code", "Global Dimension 2 Code") where("Appointment Status" = const(Active));
            RequestFilterFields = "No.";

            column(Payroll_Employee__Global_Dimension_1_Code_; "Global Dimension 1 Code")
            {
            }
            column(Payroll_Employee__No__; "No.")
            {
            }
            column(Payroll_Employee__FullName; Employee.FullName)
            {
            }
            column(Payroll_Employee_EDAmount; "ED Amount")
            {
            }
            column(Remarks; Remarks)
            {
            }
            column(Payroll_Employee_EDAmount_Control1000000011; "ED Amount")
            {
            }
            column(TOTAL_FOR_____________Global_Dimension_1_Code_; 'TOTAL FOR ' + '   ' + "Global Dimension 1 Code")
            {
            }
            column(Payroll_Employee__No__Caption; FieldCaption("No."))
            {
            }
            column(Payroll_Employee__FullNameCaption; Payroll_Employee__FullNameCaptionLbl)
            {
            }
            column(Payroll_Employee_EDAmountCaption; FieldCaption("ED Amount"))
            {
            }
            column(RemarksCaption; RemarksCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Employee.SetFilter("Period Filter", '%1..%2', PayrollFirstPeriod, PayrollPreviousPeriod);
                Employee.SetFilter("ED Filter", PayrollSetup."Leave ED Code");
                Employee.CalcFields("ED Amount");
                Remarks := '';
                if Employee."ED Amount" <> 0 then
                    CurrReport.Skip;
                if PayslipLines.Get(PayrollPeriod, Employee."No.", PayrollSetup."Leave ED Code") then begin
                    PayslipLines.SetLastPeriod(PayrollLastPeriod);
                    PayslipLines.Validate(Flag, true);
                    //PayslipLines."Skip Recalc." := TRUE;
                    PayslipLines.Modify;
                    Employee.SetFilter("Period Filter", '%1..%2', PayrollPeriod, PayrollPeriod);
                    Employee.SetFilter("ED Filter", PayrollSetup."Leave ED Code");
                    Employee.CalcFields("ED Amount");
                end else
                    Remarks := 'No Payslip'
            end;

            trigger OnPreDataItem()
            begin
                if PayrollPeriod = '' then
                    Error(Text001);

                //find year start period
                ProllPeriod.Get(PayrollPeriod);
                ProllPeriod.SetRange(ProllPeriod."Start Date", Dmy2date(1, 1, Date2dmy(ProllPeriod."Start Date", 3)), ProllPeriod."Start Date");
                if ProllPeriod.Find('-') then
                    PayrollFirstPeriod := ProllPeriod."Period Code"
                else
                    PayrollFirstPeriod := PayrollPeriod;

                // find previous period
                ProllPeriod.SetCurrentkey("Start Date");
                ProllPeriod.Get(PayrollPeriod);
                ProllPeriod.SetFilter(ProllPeriod."Start Date", '<%1', ProllPeriod."Start Date");
                if ProllPeriod.Find('+') then
                    PayrollPreviousPeriod := ProllPeriod."Period Code";

                //find year end period

                ProllPeriod.Get(PayrollPeriod);
                //ProllPeriod.reset;
                ProllPeriod.SetRange(ProllPeriod."Start Date", Dmy2date(1, 12, Date2dmy(ProllPeriod."Start Date", 3)),
                                    Dmy2date(31, 12, Date2dmy(ProllPeriod."Start Date", 3)));
                if ProllPeriod.Find('-') then
                    PayrollLastPeriod := ProllPeriod."Period Code"
                else
                    PayrollLastPeriod := PayrollPeriod;

                PayrollSetup.Get;
                PayrollSetup.TestField("Leave ED Code");
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
        ProllPeriod: Record "Payroll-Period";
        PayslipLines: Record "Payroll-Payslip Line";
        PayHeader: Record "Payroll-Payslip Header";
        PayrollSetup: Record "Payroll-Setup";
        PayrollPeriod: Code[20];
        PayrollFirstPeriod: Code[20];
        PayrollLastPeriod: Code[10];
        PayrollPreviousPeriod: Code[20];
        Remarks: Text[30];
        Text001: label 'Pay Period must be specified.';
        Payroll_Employee__FullNameCaptionLbl: label 'Name';
        RemarksCaptionLbl: label 'Remarks';
}

