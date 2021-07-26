Report 52092359 "Employee Profile"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Employee Profile.rdlc';

    dataset
    {
        dataitem(Employee;Employee)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Global Dimension 1 Code","Employee Category";
            column(ReportForNavId_7528; 7528)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(UserId;UserId)
            {
            }
            column(Employee__No__;"No.")
            {
            }
            column(Address____Address_2_;Address + "Address 2")
            {
            }
            column(Title__________Last_Name___________First_Name_;Title + ' ' + "Last Name" + ' ' + "First Name")
            {
            }
            column(StateofOrigin;StateofOrigin)
            {
            }
            column(Age;Age)
            {
            }
            column(Employee__Birth_Date_;"Birth Date")
            {
            }
            column(CountryName;CountryName)
            {
            }
            column(Employee_Religion;Religion)
            {
            }
            column(Employee__Marital_status_;"Marital Status")
            {
            }
            column(Employee__No___Control1000000026;"No.")
            {
            }
            column(CostCentreName;CostCentreName)
            {
            }
            column(Employee__Job_Title_Code_;"Job Title Code")
            {
            }
            column(Employee_ProfileCaption;Employee_ProfileCaptionLbl)
            {
            }
            column(Employee__No__Caption;FieldCaption("No."))
            {
            }
            column(Address____Address_2_Caption;Address____Address_2_CaptionLbl)
            {
            }
            column(Employee_NameCaption;Employee_NameCaptionLbl)
            {
            }
            column(Personal_DetailsCaption;Personal_DetailsCaptionLbl)
            {
            }
            column(StateofOriginCaption;StateofOriginCaptionLbl)
            {
            }
            column(AgeCaption;AgeCaptionLbl)
            {
            }
            column(Employee__Birth_Date_Caption;FieldCaption("Birth Date"))
            {
            }
            column(CountryNameCaption;CountryNameCaptionLbl)
            {
            }
            column(Employee_ReligionCaption;FieldCaption(Religion))
            {
            }
            column(Employee__Marital_status_Caption;FieldCaption("Marital Status"))
            {
            }
            column(Employee_NoCaption;Employee_NoCaptionLbl)
            {
            }
            column(CostCentreNameCaption;CostCentreNameCaptionLbl)
            {
            }
            column(Employee__Job_Title_Code_Caption;FieldCaption("Job Title Code"))
            {
            }
            dataitem("Employee Relative";"Employee Relative")
            {
                DataItemLink = "Employee No."=field("No.");
                DataItemTableView = sorting("Employee No.","Line No.");
                column(ReportForNavId_6239; 6239)
                {
                }
                column(Last_Name___________First_Name___________Middle_Name_;"Last Name" + ' ' + "First Name" + ' ' + "Middle Name")
                {
                }
                column(Employee_Relative__Birth_Date_;"Birth Date")
                {
                }
                column(Employee_Relative__Relative_s_Employee_No__;"Relative's Employee No.")
                {
                }
                column(FORMAT_SerialNo_______;Format(SerialNo) + '.')
                {
                }
                column(Relative_Description;Relative.Description)
                {
                }
                column(NamesCaption;NamesCaptionLbl)
                {
                }
                column(Date_of_BirthCaption;Date_of_BirthCaptionLbl)
                {
                }
                column(RelationshipCaption;RelationshipCaptionLbl)
                {
                }
                column(Relative_Employee_No_Caption;Relative_Employee_No_CaptionLbl)
                {
                }
                column(Employee_RelativesCaption;Employee_RelativesCaptionLbl)
                {
                }
                column(Employee_Relative_Employee_No_;"Employee No.")
                {
                }
                column(Employee_Relative_Line_No_;"Line No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if  "Employee Relative"."Relative Code" <> '' then
                      Relative.Get("Employee Relative"."Relative Code")
                end;
            }
            dataitem("Employee Qualification";"Employee Qualification")
            {
                DataItemLink = "Employee No."=field("No.");
                DataItemTableView = sorting("Employee No.","Line No.");
                column(ReportForNavId_6340; 6340)
                {
                }
                column(Employee_Qualification__Qualification_Code_;"Qualification Code")
                {
                }
                column(Employee_Qualification_Description;Description)
                {
                }
                column(Employee_Qualification__From_Date_;"From Date")
                {
                }
                column(Employee_Qualification__To_Date_;"To Date")
                {
                }
                column(Employee_Qualification__Institution_Company_;"Institution/Company")
                {
                }
                column(FORMAT_SerialNo________Control1000000057;Format(SerialNo) + '.')
                {
                }
                column(Educational_and_Professional_QualificationsCaption;Educational_and_Professional_QualificationsCaptionLbl)
                {
                }
                column(QualificationCaption;QualificationCaptionLbl)
                {
                }
                column(FromCaption;FromCaptionLbl)
                {
                }
                column(ToCaption;ToCaptionLbl)
                {
                }
                column(Employee_Qualification__Qualification_Code_Caption;Employee_Qualification__Qualification_Code_CaptionLbl)
                {
                }
                column(Employee_Qualification__Institution_Company_Caption;FieldCaption("Institution/Company"))
                {
                }
                column(Employee_Qualification_Employee_No_;"Employee No.")
                {
                }
                column(Employee_Qualification_Line_No_;"Line No.")
                {
                }
            }
            dataitem("Employment History";"Employment History")
            {
                DataItemLink = "No."=field("No.");
                DataItemTableView = sorting("Record Type","No.","Line No.") where("Record Type"=const(Employee));
                column(ReportForNavId_6764; 6764)
                {
                }
                column(Employment_History__Institution_Company_;"Institution/Company")
                {
                }
                column(Employment_History__Position_Held_;"Position Held")
                {
                }
                column(Employment_History__From_Date_;"From Date")
                {
                }
                column(Employment_History__To_Date_;"To Date")
                {
                }
                column(Employment_History_Remark;Remark)
                {
                }
                column(FORMAT_SerialNo________Control1000000070;Format(SerialNo) + '.')
                {
                }
                column(Employment_HistoryCaption;Employment_HistoryCaptionLbl)
                {
                }
                column(Employment_History__Institution_Company_Caption;FieldCaption("Institution/Company"))
                {
                }
                column(Employment_History__Position_Held_Caption;FieldCaption("Position Held"))
                {
                }
                column(Employment_History__From_Date_Caption;FieldCaption("From Date"))
                {
                }
                column(Employment_History__To_Date_Caption;FieldCaption("To Date"))
                {
                }
                column(Employment_History_RemarkCaption;FieldCaption(Remark))
                {
                }
                column(Employment_History_Record_Type;"Record Type")
                {
                }
                column(Employment_History_No_;"No.")
                {
                }
                column(Employment_History_Line_No_;"Line No.")
                {
                }
            }
            dataitem(Referee;Referee)
            {
                DataItemLink = "No."=field("No.");
                DataItemTableView = sorting("Record Type","No.") where("Record Type"=const(Employee));
                column(ReportForNavId_2575; 2575)
                {
                }
                column(Name__________Name_2_;Name + ' ' + "Name 2")
                {
                }
                column(Address___________Address_2_;Address + ' ' +  "Address 2")
                {
                }
                column(Referee_Occupation;Occupation)
                {
                }
                column(Referee__No__of_Years_;"No. of Years")
                {
                }
                column(FORMAT_SerialNo________Control1000000081;Format(SerialNo) + '.')
                {
                }
                column(ReferencesCaption;ReferencesCaptionLbl)
                {
                }
                column(NameCaption;NameCaptionLbl)
                {
                }
                column(Referee__No__of_Years_Caption;Referee__No__of_Years_CaptionLbl)
                {
                }
                column(Address___________Address_2_Caption;Address___________Address_2_CaptionLbl)
                {
                }
                column(Referee_OccupationCaption;FieldCaption(Occupation))
                {
                }
                column(Referee_Record_Type;"Record Type")
                {
                }
                column(Referee_No_;"No.")
                {
                }
            }
            dataitem("Employee Query Entry";"Employee Query Entry")
            {
                DataItemLink = "Employee No."=field("No.");
                DataItemTableView = sorting("Employee No.","Query Ref. No.");
                column(ReportForNavId_5335; 5335)
                {
                }
                column(FORMAT_SerialNo________Control1000000090;Format(SerialNo) + '.')
                {
                }
                column(Employee_Query_Entry__Query_Ref__No__;"Query Ref. No.")
                {
                }
                column(Employee_Query_Entry_Offence;Offence)
                {
                }
                column(Employee_Query_Entry_Explanation;Explanation)
                {
                }
                column(Employee_Query_Entry__Date_of_Query_;"Date of Query")
                {
                }
                column(Employee_Query_Entry_Action;Action)
                {
                }
                column(Employee_Query_Entry__Suspension_Duration_;"Suspension Duration")
                {
                }
                column(Employee_Query_Entry__Query_Ref__No__Caption;Employee_Query_Entry__Query_Ref__No__CaptionLbl)
                {
                }
                column(Employee_Query_Entry_OffenceCaption;FieldCaption(Offence))
                {
                }
                column(Employee_Query_Entry_ExplanationCaption;FieldCaption(Explanation))
                {
                }
                column(QueriesCaption;QueriesCaptionLbl)
                {
                }
                column(Employee_Query_Entry__Date_of_Query_Caption;FieldCaption("Date of Query"))
                {
                }
                column(Employee_Query_Entry_ActionCaption;FieldCaption(Action))
                {
                }
                column(Employee_Query_Entry__Suspension_Duration_Caption;Employee_Query_Entry__Suspension_Duration_CaptionLbl)
                {
                }
                column(Employee_Query_Entry_Employee_No_;"Employee No.")
                {
                }
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(Employee_Status;Employee.Status)
                {
                }
                column(Employee_StatusCaption;Employee_StatusCaptionLbl)
                {
                }
                column(StatusCaption;StatusCaptionLbl)
                {
                }
                column(Integer_Number;Number)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if Employee."Birth Date" <> 0D then
                  Age := Date2dmy(Today,3) - Date2dmy(Employee."Birth Date",3)
                else
                  Age := 0;

                if Country.Get(Employee."Country/Region Code") then
                  CountryName := Country.Name
                else
                  CountryName := '';

                if State.Get(0,Employee."State Code") then
                  StateofOrigin := State.Description
                else
                  StateofOrigin := '';

                CostCentreName := DimMgt.ReturnDimName(1,Employee."Global Dimension 1 Code");
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
        State: Record State;
        Country: Record "Country/Region";
        Relative: Record Relative;
        DimMgt: Codeunit "Dimension Hook";
        CountryName: Text[30];
        EmployerName: array [3] of Text[30];
        StateofOrigin: Text[20];
        CostCentreName: Text[40];
        Age: Integer;
        SerialNo: Integer;
        PrintPreview: Boolean;
        Employee_ProfileCaptionLbl: label 'Employee Profile';
        Address____Address_2_CaptionLbl: label 'Address';
        Employee_NameCaptionLbl: label 'Employee Name';
        Personal_DetailsCaptionLbl: label 'Personal Details';
        StateofOriginCaptionLbl: label 'State of Origin';
        AgeCaptionLbl: label 'Age';
        CountryNameCaptionLbl: label 'Country';
        Employee_NoCaptionLbl: label 'Employee No';
        CostCentreNameCaptionLbl: label 'Department';
        NamesCaptionLbl: label 'Names';
        Date_of_BirthCaptionLbl: label 'Date of Birth';
        RelationshipCaptionLbl: label 'Relationship';
        Relative_Employee_No_CaptionLbl: label 'Relative Employee No.';
        Employee_RelativesCaptionLbl: label 'Employee Relatives';
        Educational_and_Professional_QualificationsCaptionLbl: label 'Educational and Professional Qualifications';
        QualificationCaptionLbl: label 'Qualification';
        FromCaptionLbl: label 'From';
        ToCaptionLbl: label 'To';
        Employee_Qualification__Qualification_Code_CaptionLbl: label 'Code';
        Employment_HistoryCaptionLbl: label 'Employment History';
        ReferencesCaptionLbl: label 'References';
        NameCaptionLbl: label 'Name';
        Referee__No__of_Years_CaptionLbl: label 'Years Known';
        Address___________Address_2_CaptionLbl: label 'Address';
        Employee_Query_Entry__Query_Ref__No__CaptionLbl: label 'Reference No.';
        QueriesCaptionLbl: label 'Queries';
        Employee_Query_Entry__Suspension_Duration_CaptionLbl: label 'Days Suspension';
        Employee_StatusCaptionLbl: label 'Employee Status';
        StatusCaptionLbl: label 'Status';


    procedure PrintOption()
    begin
        PrintPreview := true;
    end;
}

