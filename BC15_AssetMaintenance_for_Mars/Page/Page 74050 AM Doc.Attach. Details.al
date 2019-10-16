page 74050 "MCH AM Doc.Attach. Details"
{
    Caption = 'Attached Maintenance Documents';
    DataCaptionExpression = '';
    Editable = true;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPlus;
    PopulateAllFields = true;
    ShowFilter = false;
    SourceTable = "MCH AM Document Attachment";
    SourceTableView = SORTING("Table ID");

    layout
    {
        area(content)
        {
            field(CaptionText;CaptionText)
            {
                ApplicationArea = Basic,Suite;
                Editable = false;
                QuickEntry = false;
                ShowCaption = false;
                Style = Strong;
                StyleExpr = TRUE;
                Visible = ShowCaptionText;
            }
            repeater(Group)
            {
                Editable = NOT IsReadOnly;
                FreezeColumn = "File Name";
                field("File Name";"File Name")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the filename of the attachment.';
                }
                field("File Extension";"File Extension")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the file extension of the attachment.';
                }
                field("File Type";"File Type")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    OptionCaption = ' ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other';
                    ToolTip = 'Specifies the type of document that the attachment is.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the attached document.';
                }
                field("Attached By";"Attached By")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the user who attached the document.';
                }
                field("Attached Date";"Attached Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date when the document was attached.';
                }
                field("Attached by (Full Name)";"Attached by (Full Name)")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1101214002;"MCH AM Doc.Attach. Image FactC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Attachment Entry No."=FIELD("Attachment Entry No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Import)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Import';
                Enabled = NOT IsReadOnly;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Visible = NOT IsReadOnly;

                trigger OnAction()
                var
                    FromRecRef: RecordRef;
                    AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
                begin
                    if AMDocAttachmentMgt.TryFindRecRefFromDocAttachment(Rec,FromRecRef) then begin
                      if AMDocAttachmentMgt.ImportAttachment(Rec,FromRecRef) then begin
                        if FindLast then ;
                        CurrPage.Update(false);
                      end;
                    end;
                end;
            }
            action(Export)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Export';
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Export to preview the attachment.';

                trigger OnAction()
                var
                    AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
                begin
                    if "File Name" <> '' then
                      AMDocAttachmentMgt.ExportAttachment(Rec,true);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        exit(not IsReadOnly);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Description := '';
    end;

    trigger OnOpenPage()
    begin
        ShowCaptionText := (CaptionText <> '');
    end;

    var
        CaptionText: Text;
        [InDataSet]
        ShowCaptionText: Boolean;
        [InDataSet]
        IsReadOnly: Boolean;


    procedure SetCaption(NewCaptionText: Text)
    begin
        CaptionText := UpperCase(NewCaptionText);
    end;


    procedure SetReadOnly(NewIsReadOnly: Boolean)
    begin
        IsReadOnly := NewIsReadOnly;
    end;
}

