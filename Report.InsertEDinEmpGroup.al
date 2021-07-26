Report 52092182 "Insert ED in Emp Group"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Insert ED in Emp Group.rdlc';

    dataset
    {
        dataitem("Payroll-E/D";"Payroll-E/D")
        {
            RequestFilterFields = "E/D Code";
            column(ReportForNavId_9150; 9150)
            {
            }
            dataitem("Payroll-Employee Group Header";"Payroll-Employee Group Header")
            {
                column(ReportForNavId_6076; 6076)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not PayEmpGrpLines.Get(Code,"Payroll-E/D"."E/D Code") then begin
                      PayEmpGrpLines.Init;
                      PayEmpGrpLines."Employee Group" := Code;
                      PayEmpGrpLines."E/D Code" := "Payroll-E/D"."E/D Code";
                      PayEmpGrpLines.Validate("E/D Code");
                      PayEmpGrpLines.Insert;
                    end;
                end;
            }
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
        PayEmpGrpLines: Record "Payroll-Employee Group Line";
}

