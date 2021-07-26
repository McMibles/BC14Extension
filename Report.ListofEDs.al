Report 52092165 "List of E/Ds"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/List of EDs.rdlc';

    dataset
    {
        dataitem("Payroll-E/D"; "Payroll-E/D")
        {
            DataItemTableView = sorting("E/D Code");
            RequestFilterFields = "E/D Code";
            column(ReportForNavId_9150; 9150)
            {
            }
            column(CompanyData_Name; CompanyData.Name)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PageNo)
            // {
            // }
            column(Payroll_E_D_Codes__E_D_Code_; "E/D Code")
            {
            }
            column(Payroll_E_D_Codes_Description; Description)
            {
            }
            column(Payroll_E_D_Codes_Compute; Compute)
            {
            }
            column(Payroll_E_D_Codes__Factor_Of_; "Factor Of")
            {
            }
            column(Payroll_E_D_Codes_Percentage; Percentage)
            {
            }
            column(Payroll_E_D_Codes__Table_Look_Up_; "Table Look Up")
            {
            }
            column(Payroll_E_D_Codes__Payslip_appearance_; "Payslip appearance")
            {
            }
            column(Payroll_E_D_Codes_Variable; Variable)
            {
            }
            column(Payroll_E_D_Codes__Factor_Lookup_; "Factor Lookup")
            {
            }
            column(Payroll_E_D_Codes__Common_Id_; "Common Id")
            {
            }
            column(Payroll_module__Caption; Payroll_module__CaptionLbl)
            {
            }
            column(List_of_E_DsCaption; List_of_E_DsCaptionLbl)
            {
            }
            column(PageCaption; PageCaptionLbl)
            {
            }
            column(E_DCaption; E_DCaptionLbl)
            {
            }
            column(Payslip_TextCaption; Payslip_TextCaptionLbl)
            {
            }
            column(ComputeCaption; ComputeCaptionLbl)
            {
            }
            column(Factor_ofCaption; Factor_ofCaptionLbl)
            {
            }
            column(PercentCaption; PercentCaptionLbl)
            {
            }
            column(Table_lookupCaption; Table_lookupCaptionLbl)
            {
            }
            column(Payslip_appearanceCaption; Payslip_appearanceCaptionLbl)
            {
            }
            column(Payroll_E_D_Codes_VariableCaption; FieldCaption(Variable))
            {
            }
            column(Payroll_E_D_Codes__Factor_Lookup_Caption; FieldCaption("Factor Lookup"))
            {
            }
            column(Payroll_E_D_Codes__Common_Id_Caption; FieldCaption("Common Id"))
            {
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
        Report_Title = 'List of EDs';
    }

    trigger OnPreReport()
    begin
        CompanyData.Get;
    end;

    var
        CompanyData: Record "Company Information";
        Payroll_module__CaptionLbl: label 'Payroll module -';
        List_of_E_DsCaptionLbl: label 'List of E/Ds';
        PageCaptionLbl: label 'Page';
        E_DCaptionLbl: label 'E/D';
        Payslip_TextCaptionLbl: label 'Payslip Text';
        ComputeCaptionLbl: label 'Compute';
        Factor_ofCaptionLbl: label 'Factor of';
        PercentCaptionLbl: label 'Percent';
        Table_lookupCaptionLbl: label 'Table lookup';
        Payslip_appearanceCaptionLbl: label 'Payslip appearance';
}

