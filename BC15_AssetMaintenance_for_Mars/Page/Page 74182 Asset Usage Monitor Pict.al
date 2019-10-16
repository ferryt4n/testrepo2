page 74182 "MCH Asset Usage Monitor Pict."
{
    Caption = 'Picture';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Usage Monitor";

    layout
    {
        area(content)
        {
            field(Picture;Picture)
            {
                ApplicationArea = Basic,Suite;
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImportPicture)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Import';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                begin
                    ImportFromDevice;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Export';
                Enabled = DeleteExportEnabled;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Export the picture to a file.';

                trigger OnAction()
                begin
                    ExportPictureToDevice;
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Delete the picture.';

                trigger OnAction()
                begin
                    DeleteThePicture;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    var
        AMMediaMgt: Codeunit "MCH AM Media Mgt.";
        DeleteExportEnabled: Boolean;
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';

    local procedure ImportFromDevice()
    begin
        Find;
        TestField("Asset No.");
        TestField("Monitor Code");
        AMMediaMgt.UsageMonitorImportPictureFromFile(Rec);
    end;

    local procedure ExportPictureToDevice()
    var
        FileManagement: Codeunit "File Management";
        FileName: Text;
        ClientFileName: Text;
    begin
        Find;
        if not Picture.HasValue then
          exit;
        TestField("Asset No.");
        TestField("Monitor Code");
        AMMediaMgt.UsageMonitorExportPictureToFile(Rec);
    end;

    local procedure DeleteThePicture()
    begin
        Find;
        if not Picture.HasValue then
          exit;
        TestField("Asset No.");
        TestField("Monitor Code");
        if not Confirm(DeleteImageQst) then
          exit;
        Clear(Picture);
        Modify(true);
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := Picture.HasValue;
    end;
}

