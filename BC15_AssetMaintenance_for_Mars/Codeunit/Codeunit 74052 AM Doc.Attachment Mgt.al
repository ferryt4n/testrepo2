codeunit 74052 "MCH AM Doc.Attachment Mgt."
{
    // FileName := FileManagement.BLOBImportWithFilter(TempBlob,ImportAttachmentTxt,FileName,STRSUBSTNO(AttachmentFileDialogTxt,AttachmentFilterTxt),AttachmentFilterTxt);
    // EXIT(FileManagement.BLOBExport(TempBlob,FullFileName,ShowFileDialog));


    trigger OnRun()
    begin
    end;

    var
        PictureFileTypeFilterText: Label 'All Files (*.*)|*.*|JPEG (*.jpg;*.jpeg)|*.jpg;*.jpeg|PNG (*.png)|*.png|BMP (*.bmp)|*.bmp';
        ImportAttachmentTxt: Label 'Attach a document.';
        AttachmentFileDialogTxt: Label 'Attachments (%1)|%1';
        AttachmentFilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*';
        EmptyFileNameErr: Label 'Please choose a file.';
        NoContentErr: Label 'The selected file has no content. Please choose another file.';
        NoDocumentAttachedErr: Label 'Please attach a document first.';

    [TryFunction]

    procedure CheckDocumentAttachmentTableID(TableID: Integer)
    var
        AllObjWithCaption: Record AllObjWithCaption;
        DocumentAttachedTableIDErr: Label 'Asset Maint. Attachments for table %1 %2 is not possible.';
    begin
        if not (TableID in [
          DATABASE::"MCH Maintenance Asset",
          DATABASE::"MCH Master Maintenance Task",
          DATABASE::"MCH Asset Maintenance Task",
          DATABASE::"MCH Work Order Header",
          DATABASE::"MCH Work Order Line"])
        then begin
            if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, TableID) then;
            Error(
              DocumentAttachedTableIDErr, TableID, AllObjWithCaption."Object Caption");
        end;
    end;


    procedure DocumentAttachmentIsDuplicateFile(TableID: Integer; DocumentNo: Code[20]; DocumentNo2: Code[20]; RecDocStatus: Option; RecLineNo: Integer; FileName: Text; FileExtension: Text): Boolean
    var
        AMDocumentAttachment: Record "MCH AM Document Attachment";
    begin
        AMDocumentAttachment.SetRange("Table ID", TableID);
        AMDocumentAttachment.SetRange("No.", DocumentNo);
        AMDocumentAttachment.SetRange("No. 2", DocumentNo2);
        AMDocumentAttachment.SetRange("Document Status", RecDocStatus);
        AMDocumentAttachment.SetRange("Line No.", RecLineNo);
        AMDocumentAttachment.SetRange("File Name", FileName);
        AMDocumentAttachment.SetRange("File Extension", FileExtension);
        exit(not AMDocumentAttachment.IsEmpty);
    end;


    procedure ImportAttachment(var AMDocumentAttachment: Record "MCH AM Document Attachment"; var FromRecRef: RecordRef) OK: Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        FileName: Text;
    begin
        CheckDocumentAttachmentTableID(FromRecRef.Number);
        FileName := FileManagement.BLOBImportWithFilter(TempBlob, ImportAttachmentTxt, FileName, StrSubstNo(AttachmentFileDialogTxt, AttachmentFilterTxt), AttachmentFilterTxt);
        if FileName = '' then
            exit(false);
        SaveNewAttachment(AMDocumentAttachment, FromRecRef, FileName, TempBlob);
        exit(true);
    end;

    local procedure SaveNewAttachment(var AMDocumentAttachment: Record "MCH AM Document Attachment"; RecRef: RecordRef; FileName: Text; TempBlob: Codeunit "Temp Blob")
    var
        FileManagement: Codeunit "File Management";
        DocInStream: InStream;
        IncomingFileName: Text;
    begin
        CheckDocumentAttachmentTableID(RecRef.Number);
        if FileName = '' then
            Error(EmptyFileNameErr);
        if not TempBlob.HasValue then
            Error(NoContentErr);

        IncomingFileName := FileName;

        with AMDocumentAttachment do begin
            Init;
            Validate("File Extension", FileManagement.GetExtension(IncomingFileName));
            Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(IncomingFileName), 1, MaxStrLen("File Name")));

            TempBlob.CreateInStream(DocInStream);
            // IMPORTSTREAM(stream,description, mime-type,filename)
            // description and mime-type are set empty and will be automatically set by platform code from the stream
            //"Attachment Content".IMPORTSTREAM(DocInStream,'','',IncomingFileName);
            "Attachment Content".ImportStream(DocInStream, IncomingFileName);

            if not "Attachment Content".HasValue then
                Error(NoDocumentAttachedErr);

            "Attachment Entry No." := 0; // AutoIncrement on insert;
            if ValidateNewDocAttachmentFromRecRef(RecRef, AMDocumentAttachment) then
                Insert(true);
        end;
    end;


    procedure ExportAttachment(var AMDocumentAttachment: Record "MCH AM Document Attachment"; ShowFileDialog: Boolean): Text
    var
        TempBlob: Codeunit "Temp Blob";
        FileManagement: Codeunit "File Management";
        DocumentStream: OutStream;
        FullFileName: Text;
    begin
        with AMDocumentAttachment do begin
            if not "Attachment Content".HasValue then
                exit;
            FullFileName := "File Name" + '.' + "File Extension";
            TempBlob.CreateOutStream(DocumentStream);
            "Attachment Content".ExportStream(DocumentStream);
            exit(FileManagement.BLOBExport(TempBlob, FullFileName, ShowFileDialog));
        end;
    end;


    procedure CopyAttachmentsByVariantRef(FromRecord: Variant; ToRecord: Variant)
    var
        FromRecRef: RecordRef;
        ToRecRef: RecordRef;
    begin
        FromRecRef.GetTable(FromRecord);
        ToRecRef.GetTable(ToRecord);
        CopyAttachmentsByRecordRef(FromRecRef, ToRecRef);
    end;


    procedure CopyAttachmentsByRecordRef(var FromRecRef: RecordRef; var ToRecRef: RecordRef)
    var
        FromAMDocumentAttachment: Record "MCH AM Document Attachment";
        ToAMDocumentAttachment: Record "MCH AM Document Attachment";
    begin
        FromAMDocumentAttachment.SetRange("Table ID", FromRecRef.Number);
        if FromAMDocumentAttachment.IsEmpty or (ToRecRef.Number = 0) then
            exit;
        if not SetDocAttachmentFilterFromRecRef(FromRecRef, FromAMDocumentAttachment) then
            exit;

        if FromAMDocumentAttachment.FindSet then begin
            repeat
                Clear(ToAMDocumentAttachment);
                ToAMDocumentAttachment.Init;
                ToAMDocumentAttachment.TransferFields(FromAMDocumentAttachment);
                if ValidateNewDocAttachmentFromRecRef(ToRecRef, ToAMDocumentAttachment) then begin
                    if not ToAMDocumentAttachment.Insert(true) then;
                end;
            until FromAMDocumentAttachment.Next = 0;
        end;
    end;


    procedure DeleteAttachedDocuments(RecRef: RecordRef)
    var
        AMDocumentAttachment: Record "MCH AM Document Attachment";
    begin
        if RecRef.IsTemporary then
            exit;
        if AMDocumentAttachment.IsEmpty then
            exit;
        if not CheckDocumentAttachmentTableID(RecRef.Number) then
            exit;
        if not SetDocAttachmentFilterFromRecRef(RecRef, AMDocumentAttachment) then
            exit;
        AMDocumentAttachment.DeleteAll(true);
    end;


    procedure SetDocAttachmentFilterFromRecRef(RecRef: RecordRef; var AMDocumentAttachment: Record "MCH AM Document Attachment") OK: Boolean
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LineNo: Integer;
    begin
        AMDocumentAttachment.SetRange("Table ID", RecRef.Number);
        // Master tables
        case RecRef.Number of
            DATABASE::"MCH Maintenance Asset",
            DATABASE::"MCH Master Maintenance Task":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    AMDocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"MCH Asset Maintenance Task":
                begin
                    FieldRef := RecRef.Field(2); // MA No.
                    RecNo := FieldRef.Value;
                    AMDocumentAttachment.SetRange("No.", RecNo);
                    FieldRef := RecRef.Field(3); // Maint. Procedure Code
                    RecNo := FieldRef.Value;
                    AMDocumentAttachment.SetRange("No. 2", RecNo);
                end;
        end;
        // WO header/lines
        case RecRef.Number of
            DATABASE::"MCH Work Order Header",
            DATABASE::"MCH Work Order Line":
                begin
                    FieldRef := RecRef.Field(1);
                    DocType := FieldRef.Value;
                    AMDocumentAttachment.SetRange("Document Status", DocType);
                    FieldRef := RecRef.Field(2);
                    RecNo := FieldRef.Value;
                    AMDocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
        case RecRef.Number of
            DATABASE::"MCH Work Order Line":
                begin
                    FieldRef := RecRef.Field(3);
                    LineNo := FieldRef.Value;
                    AMDocumentAttachment.SetRange("Line No.", LineNo);
                end;
        end;
        exit(RecNo <> '');
    end;

    local procedure ValidateNewDocAttachmentFromRecRef(ToRecRef: RecordRef; var ToAMDocumentAttachment: Record "MCH AM Document Attachment") OK: Boolean
    var
        ToFieldRef: FieldRef;
        ToNo: Code[20];
        ToNo2: Code[20];
        ToDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        ToLineNo: Integer;
    begin
        ToAMDocumentAttachment.Validate("Table ID", ToRecRef.Number);
        ToAMDocumentAttachment."Document Status" := 0;
        ToAMDocumentAttachment."Line No." := 0;

        // Master tables
        case ToRecRef.Number of
            DATABASE::"MCH Maintenance Asset",
            DATABASE::"MCH Master Maintenance Task":
                begin
                    ToFieldRef := ToRecRef.Field(1);
                    ToNo := ToFieldRef.Value;
                    ToAMDocumentAttachment.Validate("No.", ToNo);
                end;
            DATABASE::"MCH Asset Maintenance Task":
                begin
                    ToFieldRef := ToRecRef.Field(2); // MA No.
                    ToNo := ToFieldRef.Value;
                    ToAMDocumentAttachment.Validate("No.", ToNo);
                    ToFieldRef := ToRecRef.Field(3); // Maint. Procedure Code
                    ToNo2 := ToFieldRef.Value;
                    ToAMDocumentAttachment.Validate("No. 2", ToNo2);
                end;
        end;
        // Work Order Header/Line
        case ToRecRef.Number of
            DATABASE::"MCH Work Order Header",
            DATABASE::"MCH Work Order Line":
                begin
                    ToFieldRef := ToRecRef.Field(1); // Status
                    ToDocumentType := ToFieldRef.Value;
                    ToAMDocumentAttachment.Validate("Document Status", ToDocumentType);
                    ToFieldRef := ToRecRef.Field(2); // No.
                    ToNo := ToFieldRef.Value;
                    ToAMDocumentAttachment.Validate("No.", ToNo);
                end;
        end;
        case ToRecRef.Number of
            DATABASE::"MCH Work Order Line":
                begin
                    ToFieldRef := ToRecRef.Field(3); // Line No.
                    ToLineNo := ToFieldRef.Value;
                    ToAMDocumentAttachment.Validate("Line No.", ToLineNo);
                end;
        end;
        exit(ToNo <> ''); //Safeguard
    end;

    [TryFunction]

    procedure TryFindRecRefFromDocAttachment(var AMDocumentAttachment: Record "MCH AM Document Attachment"; var ToRecRef: RecordRef)
    var
        ToFieldRef: FieldRef;
        ToNo: Code[20];
        ToNo2: Code[20];
        ToDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        ToLineNo: Integer;
    begin
        Clear(ToRecRef);
        CheckDocumentAttachmentTableID(AMDocumentAttachment."Table ID");
        ToRecRef.Open(AMDocumentAttachment."Table ID");

        // Master tables
        case ToRecRef.Number of
            DATABASE::"MCH Maintenance Asset",
            DATABASE::"MCH Master Maintenance Task":
                begin
                    ToFieldRef := ToRecRef.Field(1);
                    ToFieldRef.Value(AMDocumentAttachment."No.");
                end;
            DATABASE::"MCH Asset Maintenance Task":
                begin
                    ToFieldRef := ToRecRef.Field(2); // MA No.
                    ToFieldRef.Value(AMDocumentAttachment."No.");
                    ToFieldRef := ToRecRef.Field(3); // Maint. Procedure Code
                    ToFieldRef.Value(AMDocumentAttachment."No. 2");
                end;
        end;
        // Work Order Header/Line
        case ToRecRef.Number of
            DATABASE::"MCH Work Order Header",
            DATABASE::"MCH Work Order Line":
                begin
                    ToFieldRef := ToRecRef.Field(1); // Status
                    ToFieldRef.Value(AMDocumentAttachment."Document Status");
                    ToFieldRef := ToRecRef.Field(2); // No.
                    ToFieldRef.Value(AMDocumentAttachment."No.");
                end;
        end;
        case ToRecRef.Number of
            DATABASE::"MCH Work Order Line":
                begin
                    ToFieldRef := ToRecRef.Field(3); // Line No.
                    ToFieldRef.Value(AMDocumentAttachment."Line No.");
                end;
        end;
        ToRecRef.Find;
    end;

    [EventSubscriber(ObjectType::Table, 74032, 'OnAfterDeleteEvent', '', false, false)]
    local procedure MaintAssetOnAfterDelete(var Rec: Record "MCH Maintenance Asset"; RunTrigger: Boolean)
    var
        AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
        RecRef: RecordRef;
    begin
        if Rec.IsTemporary then
            exit;
        RecRef.GetTable(Rec);
        AMDocAttachmentMgt.DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, 74059, 'OnAfterDeleteEvent', '', false, false)]
    local procedure MaintProcedureOnAfterDelete(var Rec: Record "MCH Master Maintenance Task"; RunTrigger: Boolean)
    var
        AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
        RecRef: RecordRef;
    begin
        if Rec.IsTemporary then
            exit;
        RecRef.GetTable(Rec);
        AMDocAttachmentMgt.DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, 74062, 'OnAfterDeleteEvent', '', false, false)]
    local procedure AssetMaintProcedureOnAfterDelete(var Rec: Record "MCH Asset Maintenance Task"; RunTrigger: Boolean)
    var
        AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
        RecRef: RecordRef;
    begin
        if Rec.IsTemporary then
            exit;
        RecRef.GetTable(Rec);
        AMDocAttachmentMgt.DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, 74042, 'OnAfterDeleteEvent', '', false, false)]
    local procedure WorkOrderHeaderOnAfterDelete(var Rec: Record "MCH Work Order Header"; RunTrigger: Boolean)
    var
        AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
        RecRef: RecordRef;
    begin
        if Rec.IsTemporary then
            exit;
        RecRef.GetTable(Rec);
        AMDocAttachmentMgt.DeleteAttachedDocuments(RecRef);
    end;

    [EventSubscriber(ObjectType::Table, 74043, 'OnAfterDeleteEvent', '', false, false)]
    local procedure WorkOrderLineOnAfterDelete(var Rec: Record "MCH Work Order Line"; RunTrigger: Boolean)
    var
        AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
        RecRef: RecordRef;
    begin
        if Rec.IsTemporary then
            exit;
        RecRef.GetTable(Rec);
        AMDocAttachmentMgt.DeleteAttachedDocuments(RecRef);
    end;
}

