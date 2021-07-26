Page 52092466 "Employee Signature"
{
    Caption = 'Employee Signature';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            field(Signature; Signature)
            {
                ApplicationArea = Basic, Suite;
                ShowCaption = false;
                ToolTip = 'Specifies the picture of the employee.';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Take';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Activate the camera on the device.';
                Visible = CameraAvailable;

                // trigger OnAction()
                // var
                //     CameraOptions: dotnet CameraOptions;
                // begin
                //     TestField("No.");
                //     TestField("First Name");
                //     TestField("Last Name");

                //     if not CameraAvailable then
                //         exit;
                //     CameraOptions := CameraOptions.CameraOptions;
                //     CameraOptions.Quality := 100;
                //     // CameraProvider.RequestPictureAsync(CameraOptions);
                // end;
            }
            action(ImportPicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                begin
                    TestField("No.");
                    TestField("First Name");
                    TestField("Last Name");

                    if Signature.Hasvalue then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    if FileName = '' then
                        exit;

                    Clear(Signature);
                    Signature.ImportFile(FileName, ClientFileName);
                    Modify(true);

                    if FileManagement.DeleteServerFile(FileName) then;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Export';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTip = 'Export the picture to a file.';

                trigger OnAction()
                var
                    DummyPictureEntity: Record "Picture Entity";
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    TestField("No.");
                    TestField("First Name");
                    TestField("Last Name");

                    ToFile := DummyPictureEntity.GetDefaultMediaDescription(Rec);
                    ExportPath := TemporaryPath + "No." + Format(Signature.MediaId);
                    Signature.ExportFile(ExportPath);

                    FileManagement.ExportImage(ExportPath, ToFile);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    TestField("No.");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Signature);
                    Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    // trigger OnOpenPage()
    // begin
    //     CameraAvailable := CameraProvider.IsAvailable;
    //     if CameraAvailable then
    //         CameraProvider := CameraProvider.Create;
    // end;

    var
        // [RunOnClient]
        //[WithEvents]
        //CameraProvider: dotnet CameraProvider;
        CameraAvailable: Boolean;
        OverrideImageQst: label 'The existing signature will be replaced. Do you want to continue?';
        DeleteImageQst: label 'Are you sure you want to delete the signature?';
        SelectPictureTxt: label 'Select a signature to upload';
        DeleteExportEnabled: Boolean;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Signature.Hasvalue;
    end;

    // trigger Cameraprovider::PictureAvailable(PictureName: Text;PictureFilePath: Text)
    // var
    //     File: File;
    //     Instream: InStream;
    // begin
    //     if (PictureName = '') or (PictureFilePath = '') then
    //       exit;

    //     if Signature.Hasvalue then
    //       if not Confirm(OverrideImageQst) then begin
    //         if Erase(PictureFilePath) then;
    //         exit;
    //       end;

    //     File.Open(PictureFilePath);
    //     File.CreateInstream(Instream);

    //     Clear(Signature);
    //     Signature.ImportStream(Instream,PictureName);
    //     if not Modify(true) then
    //       Insert(true);

    //     File.Close;
    //     if Erase(PictureFilePath) then;
    // end;
}

