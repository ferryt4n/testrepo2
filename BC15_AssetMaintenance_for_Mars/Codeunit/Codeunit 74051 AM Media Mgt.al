codeunit 74051 "MCH AM Media Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        SelectPictureTxt: Label 'Select a picture to upload';
        SavePictureTxt: Label 'Save picture';
        PictureFileTypeFilterText: Label 'All Files (*.*)|*.*|JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg|PNG (*.png)|*.png|BMP (*.bmp)|*.bmp';
        ImportAttachmentTxt: Label 'Attach a document.';
        SelectFileTxt: Label 'Select File...';
        SaveAttachmentTxt: Label 'Save attachment';
        AttachmentFileDialogTxt: Label 'Attachments (%1)|%1';
        AttachmentFilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*';
        EmptyFileNameErr: Label 'Please choose a file.';
        NoContentErr: Label 'The selected file has no content. Please choose another file.';
        NoDocumentAttachedErr: Label 'Please attach a document first.';
        DocumentAttachedTableIDErr: Label 'Attachments for table %1 %2 is not possible.';


    procedure MaintAssetImportPictureFromFile(var MaintAsset: Record "MCH Maintenance Asset")
    var
        ImageInStream: InStream;
        DefaultPictureFileName: Text;
    begin
        MaintAsset.TestField("No.");
        if MaintAsset.Picture.HasValue then
          if not Confirm(OverrideImageQst) then
            Error('');
        DefaultPictureFileName := CleanFileName(StrSubstNo('%1 %2.%3',MaintAsset."No.",MaintAsset.Description,GetDefaultFileExtension));
        if UploadIntoStream(SelectPictureTxt,'','All Files (*.*)|*.*',DefaultPictureFileName,ImageInStream) then begin
          MaintAsset.Get(MaintAsset."No.");
          Clear(MaintAsset.Picture);
          MaintAsset.Picture.ImportStream(ImageInStream,DefaultPictureFileName);
          MaintAsset.Modify(true);
        end;
    end;


    procedure MaintAssetExportPictureToFile(var MaintAsset: Record "MCH Maintenance Asset")
    var
        TempBlob: Codeunit "Temp Blob";
        ImageInStream: InStream;
        ImageOutStream: OutStream;
        DefaultPictureFileName: Text;
    begin
        if not MaintAsset.Picture.HasValue then
          exit;
        TempBlob.CreateOutStream(ImageOutStream);
        MaintAsset.Picture.ExportStream(ImageOutStream);
        TempBlob.CreateInStream(ImageInStream);
        DefaultPictureFileName := CleanFileName(StrSubstNo('%1 %2.%3',MaintAsset."No.",MaintAsset.Description,GetDefaultFileExtension));
        DownloadFromStream(ImageInStream,SavePictureTxt,'',PictureFileTypeFilterText,DefaultPictureFileName);
    end;


    procedure SparePartImportPictureFromFile(var MaintSparePart: Record "MCH Maintenance Spare Part")
    var
        ImageInStream: InStream;
        DefaultPictureFileName: Text;
    begin
        MaintSparePart.TestField("No.");
        if MaintSparePart.Picture.HasValue then
          if not Confirm(OverrideImageQst) then
            Error('');
        DefaultPictureFileName := CleanFileName(StrSubstNo('%1 %2.%3',MaintSparePart."No.",MaintSparePart.Description,GetDefaultFileExtension));
        if UploadIntoStream(SelectPictureTxt,'','All Files (*.*)|*.*',DefaultPictureFileName,ImageInStream) then begin
          MaintSparePart.Get(MaintSparePart."No.");
          Clear(MaintSparePart.Picture);
          MaintSparePart.Picture.ImportStream(ImageInStream,DefaultPictureFileName);
          MaintSparePart.Modify(true);
        end;
    end;


    procedure SparePartExportPictureToFile(var MaintSparePart: Record "MCH Maintenance Spare Part")
    var
        TempBlob: Codeunit "Temp Blob";
        ImageInStream: InStream;
        ImageOutStream: OutStream;
        DefaultPictureFileName: Text;
    begin
        if not MaintSparePart.Picture.HasValue then
          exit;
        TempBlob.CreateOutStream(ImageOutStream);
        MaintSparePart.Picture.ExportStream(ImageOutStream);
        TempBlob.CreateInStream(ImageInStream);
        DefaultPictureFileName := CleanFileName(StrSubstNo('%1 %2.%3',MaintSparePart."No.",MaintSparePart.Description,GetDefaultFileExtension));
        DownloadFromStream(ImageInStream,SavePictureTxt,'',PictureFileTypeFilterText,DefaultPictureFileName);
    end;


    procedure UsageMonitorImportPictureFromFile(var UsageMonitor: Record "MCH Asset Usage Monitor")
    var
        ImageInStream: InStream;
        DefaultPictureFileName: Text;
    begin
        UsageMonitor.TestField("Asset No.");
        UsageMonitor.TestField("Monitor Code");
        if UsageMonitor.Picture.HasValue then
          if not Confirm(OverrideImageQst) then
            Error('');
        DefaultPictureFileName := CleanFileName(StrSubstNo('%1 %2 %3.%4',UsageMonitor."Asset No.",UsageMonitor."Monitor Code",UsageMonitor.Description,GetDefaultFileExtension));
        if UploadIntoStream(SelectPictureTxt,'','All Files (*.*)|*.*',DefaultPictureFileName,ImageInStream) then begin
          UsageMonitor.Get(UsageMonitor."Asset No.",UsageMonitor."Monitor Code");
          Clear(UsageMonitor.Picture);
          UsageMonitor.Picture.ImportStream(ImageInStream,DefaultPictureFileName);
          UsageMonitor.Modify(true);
        end;
    end;


    procedure UsageMonitorExportPictureToFile(var UsageMonitor: Record "MCH Asset Usage Monitor")
    var
        TempBlob: Codeunit "Temp Blob";
        ImageInStream: InStream;
        ImageOutStream: OutStream;
        DefaultPictureFileName: Text;
    begin
        if not UsageMonitor.Picture.HasValue then
          exit;
        TempBlob.CreateOutStream(ImageOutStream);
        UsageMonitor.Picture.ExportStream(ImageOutStream);
        TempBlob.CreateInStream(ImageInStream);
        DefaultPictureFileName := CleanFileName(StrSubstNo('%1 %2 %3.%4',UsageMonitor."Asset No.",UsageMonitor."Monitor Code",UsageMonitor.Description,GetDefaultFileExtension));
        DownloadFromStream(ImageInStream,SavePictureTxt,'',PictureFileTypeFilterText,DefaultPictureFileName);
    end;


    procedure MaintLocationImportPictureFromFile(var MaintenanceLocation: Record "MCH Maintenance Location")
    var
        ImageInStream: InStream;
        DefaultPictureFileName: Text;
    begin
        MaintenanceLocation.TestField(Code);
        if MaintenanceLocation.Picture.HasValue then
          if not Confirm(OverrideImageQst) then
            Error('');
        DefaultPictureFileName := CleanFileName(StrSubstNo('%1 %2.%3',MaintenanceLocation.Code,MaintenanceLocation.Name,GetDefaultFileExtension));
        if UploadIntoStream(SelectPictureTxt,'','All Files (*.*)|*.*',DefaultPictureFileName,ImageInStream) then begin
          MaintenanceLocation.Get(MaintenanceLocation.Code);
          Clear(MaintenanceLocation.Picture);
          MaintenanceLocation.Picture.ImportStream(ImageInStream,DefaultPictureFileName);
          MaintenanceLocation.Modify(true);
        end;
    end;


    procedure MaintLocationExportPictureToFile(var MaintenanceLocation: Record "MCH Maintenance Location")
    var
        TempBlob: Codeunit "Temp Blob";
        ImageInStream: InStream;
        ImageOutStream: OutStream;
        DefaultPictureFileName: Text;
    begin
        if not MaintenanceLocation.Picture.HasValue then
          exit;
        TempBlob.CreateOutStream(ImageOutStream);
        MaintenanceLocation.Picture.ExportStream(ImageOutStream);
        TempBlob.CreateInStream(ImageInStream);
        DefaultPictureFileName := CleanFileName(StrSubstNo('%1 %2.%3',MaintenanceLocation.Code,MaintenanceLocation.Name,GetDefaultFileExtension));
        DownloadFromStream(ImageInStream,SavePictureTxt,'',PictureFileTypeFilterText,DefaultPictureFileName);
    end;

    local procedure GetDefaultFileExtension() FileExtension: Text
    begin
        exit('jpg');
    end;

    local procedure CleanFileName(InputText: Text) OutputText: Text
    begin
        exit(DelChr(InputText,'=','"#%&*:<>?\/{|}~'));
    end;
}

