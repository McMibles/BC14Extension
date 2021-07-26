Report 52092351 "Copy Appraisal Template"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Copy Appraisal Template.rdlc';

    dataset
    {
        dataitem("Appraisal Template Header";"Appraisal Template Header")
        {
            column(ReportForNavId_1; 1)
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
    }

    var
        FromTemPlateCode: Code[10];
}

