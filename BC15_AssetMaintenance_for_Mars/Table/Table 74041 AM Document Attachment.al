table 74041 "MCH AM Document Attachment"
{
    Caption = 'Maint. Document Attachment';

    fields
    {
        field(1;"Table ID";Integer)
        {
            Caption = 'Table ID';
            NotBlank = true;
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Table));
        }
        field(2;"No.";Code[20])
        {
            Caption = 'No.';
            NotBlank = true;
            TableRelation = IF ("Table ID"=CONST(74032)) "MCH Maintenance Asset"."No."
                            ELSE IF ("Table ID"=CONST(74042)) "MCH Work Order Header"."No." WHERE (Status=FIELD("Document Status"))
                            ELSE IF ("Table ID"=CONST(74043)) "MCH Work Order Line"."Work Order No." WHERE (Status=FIELD("Document Status"))
                            ELSE IF ("Table ID"=CONST(74059)) "MCH Master Maintenance Task".Code
                            ELSE IF ("Table ID"=CONST(74062)) "MCH Asset Maintenance Task"."Asset No.";
        }
        field(3;"No. 2";Code[20])
        {
            Caption = 'No. 2';
            DataClassification = CustomerContent;
            TableRelation = IF ("Table ID"=CONST(74062)) "MCH Asset Maintenance Task"."Task Code" WHERE ("Asset No."=FIELD("No."));
        }
        field(4;"Document Status";Option)
        {
            Caption = 'Document Status';
            OptionCaption = 'Request,Planned,Released,Finished';
            OptionMembers = Request,Planned,Released,Finished;
        }
        field(5;"Line No.";Integer)
        {
            BlankZero = true;
            Caption = 'Line No.';
            TableRelation = IF ("Table ID"=CONST(74043)) "MCH Work Order Line"."Line No." WHERE (Status=FIELD("Document Status"),
                                                                                                 "Work Order No."=FIELD("No."));
        }
        field(6;"Attachment Entry No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'Attachment Entry No.';
            Editable = false;
        }
        field(10;"File Name";Text[250])
        {
            Caption = 'File Name';
            NotBlank = true;

            trigger OnValidate()
            var
                AMDocAttachmentMgt: Codeunit "MCH AM Doc.Attachment Mgt.";
            begin
                if "File Name" = '' then
                  Error(EmptyFileNameErr);
                if AMDocAttachmentMgt.DocumentAttachmentIsDuplicateFile("Table ID","No.","No. 2","Document Status","Line No.","File Name","File Extension") = true then
                  Error(DuplicateErr);
            end;
        }
        field(11;"File Extension";Text[30])
        {
            Caption = 'File Extension';

            trigger OnValidate()
            begin
                case LowerCase("File Extension") of
                  'jpg','jpeg','bmp','png','tiff','tif','gif':
                    "File Type" := "File Type"::Image;
                  'pdf':
                    "File Type" := "File Type"::PDF;
                  'docx','doc':
                    "File Type" := "File Type"::Word;
                  'xlsx','xls':
                    "File Type" := "File Type"::Excel;
                  'pptx','ppt':
                    "File Type" := "File Type"::PowerPoint;
                  'msg':
                    "File Type" := "File Type"::Email;
                  'xml':
                    "File Type" := "File Type"::XML;
                  else
                    "File Type" := "File Type"::Other;
                end;
            end;
        }
        field(12;"File Type";Option)
        {
            Caption = 'File Type';
            OptionCaption = ' ,Image,PDF,Word,Excel,PowerPoint,Email,XML,Other';
            OptionMembers = " ",Image,PDF,Word,Excel,PowerPoint,Email,XML,Other;
        }
        field(13;Description;Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ("Attachment Entry No." = 0) then
                  Description := '';
            end;
        }
        field(15;"Attachment Content";Media)
        {
            Caption = 'Attachment Content';
        }
        field(20;"Attached By";Code[50])
        {
            Caption = 'Attached By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(21;"User Security ID";Guid)
        {
            Caption = 'User Security ID';
            Editable = false;
            TableRelation = User."User Security ID";
        }
        field(22;"Attached Date";DateTime)
        {
            Caption = 'Attached Date';
        }
        field(23;"Attached by (Full Name)";Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE ("User Security ID"=FIELD("User Security ID")));
            Caption = 'Attached by (Full Name)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50;"Table Caption";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Table),
                                                                           "Object ID"=FIELD("Table ID")));
            Caption = 'Table Caption';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Table ID","No.","No. 2","Document Status","Line No.","Attachment Entry No.")
        {
            Clustered = true;
        }
        key(Key2;"Attachment Entry No.")
        {
        }
        key(Key3;"Attached Date")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick;"No.","File Name","File Extension","File Type")
        {
        }
    }

    trigger OnInsert()
    begin
        //IF NOT "Attachment Content".HASVALUE THEN
        //  ERROR(NoDocumentAttachedErr);
        "Attached Date" := CurrentDateTime;
        "User Security ID" := UserSecurityId;
        "Attached By" := UserId;
    end;

    var
        NoDocumentAttachedErr: Label 'Please attach a document first.';
        EmptyFileNameErr: Label 'Please choose a file to attach.';
        DuplicateErr: Label 'This file is already attached. Please choose another file.';
}

