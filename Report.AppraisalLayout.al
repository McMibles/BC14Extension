Report 52092354 "Appraisal Layout"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Appraisal Layout.rdlc';

    dataset
    {
        dataitem("Appraisal Header";"Appraisal Header")
        {
            RequestFilterFields = "Appraisal Period","Appraisal Type","Appraisee No.";
            column(ReportForNavId_8780; 8780)
            {
            }
            column(COMPANYNAME_________Appraisals_;COMPANYNAME + ' '+ 'Appraisals')
            {
            }
            column(Appraisal_Header__Employee_No__;"Appraisee No.")
            {
            }
            column(Appraisal_Header__First_Name_;"First Name")
            {
            }
            column(Appraisal_Header__Last_Name_;"Last Name")
            {
            }
            column(Appraisal_Header_Initials;Initials)
            {
            }
            column(Appraisal_Header__Sectional_Weight_Score_;"Sectional Weight Score")
            {
            }
            column(Appraisal_Header__No__of_Steps_;"No. of Steps")
            {
            }
            column(Appraisal_Header__Appraisal_Period_;"Appraisal Period")
            {
            }
            column(Appraisal_Header__Appraisal_Type_;"Appraisal Type")
            {
            }
            column(Appraisal_Header__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(Appraisal_Header__Employee_No__Caption;FieldCaption("Appraisee No."))
            {
            }
            column(Appraisal_Header__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(Appraisal_Header__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(Appraisal_Header_InitialsCaption;FieldCaption(Initials))
            {
            }
            column(Appraisal_Header__Sectional_Weight_Score_Caption;FieldCaption("Sectional Weight Score"))
            {
            }
            column(Appraisal_Header__No__of_Steps_Caption;FieldCaption("No. of Steps"))
            {
            }
            column(Appraisal_Header__Appraisal_Period_Caption;FieldCaption("Appraisal Period"))
            {
            }
            column(Appraisal_Header__Appraisal_Type_Caption;FieldCaption("Appraisal Type"))
            {
            }
            column(Appraisal_Header__Global_Dimension_1_Code_Caption;FieldCaption("Global Dimension 1 Code"))
            {
            }
            dataitem("Appraisal Lines";"Appraisal Lines")
            {
                DataItemLink = "Appraisal Period"=field("Appraisal Period"),"Appraisal Type"=field("Appraisal Type"),"Employee No."=field("Appraisee No.");
                DataItemTableView = sorting("Appraisal Period","Appraisal Type","Employee No.","Factor Code") where(Weight=filter(<>0));
                column(ReportForNavId_4389; 4389)
                {
                }
                column(Appraisal_Lines_Weight;Weight)
                {
                }
                column(Appraisal_Lines_Score;"Appraiser Score")
                {
                }
                column(Appraisal_Lines__Appraisal_Lines__Rating;"Appraisal Lines".Rating)
                {
                }
                column(Appraisal_Lines_Description;Description)
                {
                }
                column(Appraisal_Lines__Weighted_Score_;"Appraiser Weighted Score")
                {
                }
                column(Appraisal_Header___Sectional_Weight_Score_;"Appraisal Header"."Sectional Weight Score")
                {
                }
                column(Appraisal_Lines_WeightCaption;FieldCaption(Weight))
                {
                }
                column(Appraisal_Lines_ScoreCaption;FieldCaption("Appraiser Score"))
                {
                }
                column(RatingCaption;RatingCaptionLbl)
                {
                }
                column(Appraisal_Lines_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Appraisal_Lines__Weighted_Score_Caption;FieldCaption("Appraiser Weighted Score"))
                {
                }
                column(TOTAL_SCORECaption;TOTAL_SCORECaptionLbl)
                {
                }
                column(Appraisal_Lines_Appraisal_Period;"Appraisal Period")
                {
                }
                column(Appraisal_Lines_Appraisal_Type;"Appraisal Type")
                {
                }
                column(Appraisal_Lines_Employee_No_;"Employee No.")
                {
                }
                column(Appraisal_Lines_Section_Code;"Section Code")
                {
                }
                column(Appraisal_Lines_Line_No_;"Line No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Employee.Get("Appraisee No.");
            end;

            trigger OnPreDataItem()
            begin
                if SortOrder = 1 then
                  "Appraisal Header".SetCurrentkey("Appraisal Period","Appraisal Type");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SortOrder;SortOrder)
                {
                    ApplicationArea = Basic;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Employee: Record Employee;
        SortOrder: Option " ","Employee No.";
        RatingCaptionLbl: label 'Rating';
        TOTAL_SCORECaptionLbl: label 'TOTAL SCORE';
}

