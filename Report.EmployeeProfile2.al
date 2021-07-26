Report 52092361 "Employee Profile 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Profile 2.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Global Dimension 1 Code","Global Dimension 2 Code";
            column(ReportForNavId_7528; 7528)
            {
            }
            column(SerialNo;SerialNo)
            {
            }
            column(Age;Age)
            {
            }
            column(Employee__No__;"No.")
            {
            }
            column(Employee__Birth_Date_;"Birth Date")
            {
            }
            column(Employee_Gender;Gender)
            {
            }
            column(Employee__Marital_status_;"Marital Status")
            {
            }
            column(Employee__State_Code_;"State Code")
            {
            }
            column(Employee__Employment_Date_;"Employment Date")
            {
            }
            column(Employee__Grade_Level_Code_;"Grade Level Code")
            {
            }
            column(DimMgt_ReturnDimName_1__Global_Dimension_1_Code__;DimMgt.ReturnDimName(1,"Global Dimension 1 Code"))
            {
            }
            column(FullName_TRUE_;FullName)
            {
            }
            column(Employee_Designation;Designation)
            {
            }
            column(Employee__LG_Code_;"LG Code")
            {
            }
            column(DimMgt_ReturnDimName_2__Global_Dimension_2_Code__;DimMgt.ReturnDimName(2,"Global Dimension 2 Code"))
            {
            }
            column(Employee_Religion;Religion)
            {
            }
            column(EMPLOYEE_PROFILECaption;EMPLOYEE_PROFILECaptionLbl)
            {
            }
            column(S_NCaption;S_NCaptionLbl)
            {
            }
            column(Entry_AgeCaption;Entry_AgeCaptionLbl)
            {
            }
            column(Employee__No__Caption;FieldCaption("No."))
            {
            }
            column(Employee__Birth_Date_Caption;FieldCaption("Birth Date"))
            {
            }
            column(Employee_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Employee__Marital_status_Caption;FieldCaption("Marital Status"))
            {
            }
            column(StateCaption;StateCaptionLbl)
            {
            }
            column(Emp__DateCaption;Emp__DateCaptionLbl)
            {
            }
            column(Grade_LevelCaption;Grade_LevelCaptionLbl)
            {
            }
            column(DimMgt_ReturnDimName_1__Global_Dimension_1_Code__Caption;DimMgt_ReturnDimName_1__Global_Dimension_1_Code__CaptionLbl)
            {
            }
            column(FullName_TRUE_Caption;FullName_TRUE_CaptionLbl)
            {
            }
            column(Employee_DesignationCaption;FieldCaption(Designation))
            {
            }
            column(LGACaption;LGACaptionLbl)
            {
            }
            column(DimMgt_ReturnDimName_2__Global_Dimension_2_Code__Caption;DimMgt_ReturnDimName_2__Global_Dimension_2_Code__CaptionLbl)
            {
            }
            column(Employee_ReligionCaption;FieldCaption(Religion))
            {
            }

            trigger OnAfterGetRecord()
            begin
                SerialNo:=SerialNo + 1;
                if(("Birth Date" <> 0D) and ("Employment Date"<> 0D)) then begin
                Age:=((Date2dmy("Employment Date",3)) - (Date2dmy("Birth Date",3)));
                end else
                Age:=0;

                EmpTotal:=EmpTotal+1;
            end;

            trigger OnPreDataItem()
            begin
                SerialNo:=0;
                SetRange(Status,Status::Active);
                /*Employee.SETFILTER(Employee."Global Dimension 2 Code","Dimension Value".Totaling);
                IF PayrollPeriod = '' THEN
                  ERROR(Text001);*/

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
        SerialNo: Integer;
        Age: Integer;
        AnnualSalary: Decimal;
        CurrentApptnmtDate: Date;
        PayPHeader: Record "Payroll-Payslip Header";
        PayrollPeriod: Code[20];
        NoOfEmployee: Integer;
        PayEmp: Record "Payroll-Employee";
        Text001: label 'Payment period cannot be blank';
        PeriodRec: Record "Payroll-Period";
        DimMgt: Codeunit "Dimension Hook";
        DEPARTMENTFilter: Text[150];
        EmpTotal: Integer;
        EMPLOYEE_PROFILECaptionLbl: label 'EMPLOYEE PROFILE';
        S_NCaptionLbl: label 'S/N';
        Entry_AgeCaptionLbl: label 'Entry Age';
        StateCaptionLbl: label 'State';
        Emp__DateCaptionLbl: label 'Emp. Date';
        Grade_LevelCaptionLbl: label 'Grade Level';
        DimMgt_ReturnDimName_1__Global_Dimension_1_Code__CaptionLbl: label 'Department';
        FullName_TRUE_CaptionLbl: label 'Full Name';
        LGACaptionLbl: label 'LGA';
        DimMgt_ReturnDimName_2__Global_Dimension_2_Code__CaptionLbl: label 'Unit';
}

