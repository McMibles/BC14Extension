Report 52092367 "Import External Applicants"
{
    ProcessingOnly = true;
    UseRequestPage = false;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = where(Number=const(1));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ExcelBuf.DeleteAll;
                if SheetName = '' then
                  SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                ExcelBuf.OpenBook(ServerFileName,SheetName);
                ExcelBuf.ReadSheet;
                AnalyzeData;
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
        if ServerFileName = '' then
          ServerFileName := FileMgt.UploadFile(Text006,ExcelFileExtensionTok);
        if ServerFileName = '' then
          Error(Text002);
    end;

    var
        ExcelBuf: Record "Excel Buffer";
        Applicant: Record Applicant;
        ServerFileName: Text;
        SheetName: Text[250];
        ReadingText: Text[250];
        Window: Dialog;
        TotalRecNo: Integer;
        RecNo: Integer;
        NoOfColumn: Integer;
        ExcelFileExtensionTok: label '.xlsx', Locked=true;
        VacancyNo: Code[20];
        Text002: label 'File must be selected';
        Text006: label 'Import Excel File';
        FileMgt: Codeunit "File Management";
        Text007: label 'Analyzing Data...\\';
        Text008: label 'Nothing to process.';
        FirstName: label 'First Name';
        MiddleName: label 'Middle Name';
        LastName: label 'Last Name';
        Address: label 'Address';
        MaritalStatus: label 'Marital Status';
        MobileNo: label 'Mobile No';
        EMail: label 'EMail';
        BirthDate: label 'Birth Date';
        Gender: label 'Gender';
        DateReceived: label 'Date Received';

    local procedure AnalyzeData()
    var
        HeaderRowNo: Integer;
        CountDim: Integer;
        TestDateTime: DateTime;
        OldRowNo: Integer;
    begin
        Window.Open(
          Text007 +
          '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1,0);
        TotalRecNo := ExcelBuf.Count;
        RecNo := 0;
        ExcelBuf.SetFilter("Row No.",'>1');
        if not ExcelBuf.FindFirst then
          Error(Text008);
        repeat
          RecNo := RecNo + 1;
          Window.Update(1,ROUND(RecNo / TotalRecNo * 10000,1));
          case UpperCase(GetColumnFieldCaption(ExcelBuf.xlColID)) of
            UpperCase(Format(FirstName)):begin
              Applicant.Init;
              Applicant."No." := '';
              Applicant."First Name" := ExcelBuf."Cell Value as Text";
              Applicant."Position Desired" := VacancyNo;
              Applicant."Internal/External" := Applicant."internal/external"::External;
              Applicant.Insert(true);
            end;
            UpperCase(Format(MiddleName)): Applicant."Middle Name" := ExcelBuf."Cell Value as Text";
            UpperCase(Format(LastName)): Applicant."Last Name" := ExcelBuf."Cell Value as Text";
            UpperCase(Format(Address)): Applicant.Address := CopyStr(ExcelBuf."Cell Value as Text",1,StrLen(Applicant.Address));
            UpperCase(Format(MaritalStatus)): Evaluate(Applicant."Marital Status",ExcelBuf."Cell Value as Text");
            UpperCase(Format(MobileNo)): Applicant."Mobile Phone No." := ExcelBuf."Cell Value as Text";
            UpperCase(Format(EMail)): Applicant."E-Mail" := ExcelBuf."Cell Value as Text";
            UpperCase(Format(BirthDate)): Evaluate(Applicant."Birth Date",ExcelBuf."Cell Value as Text");
            UpperCase(Format(Gender)): Evaluate(Applicant.Gender,ExcelBuf."Cell Value as Text");
            UpperCase(Format(DateReceived)):begin
              Evaluate(Applicant."Date Received",ExcelBuf."Cell Value as Text");
              Applicant.Modify;
            end;
          end;
        until ExcelBuf.Next = 0;
        Window.Close;
    end;


    procedure GetColumnFieldCaption(CloumnID: Text[1]): Text[50]
    var
        ExcelBuf2: Record "Excel Buffer";
    begin
        ExcelBuf2.Reset;
        ExcelBuf2.SetRange("Row No.",1);
        ExcelBuf2.SetRange(xlColID,CloumnID);
        ExcelBuf2.FindFirst;
        exit(ExcelBuf2."Cell Value as Text");
    end;


    procedure SetParameters(lVacancyNo: Code[20])
    begin
        VacancyNo := lVacancyNo;
    end;
}

