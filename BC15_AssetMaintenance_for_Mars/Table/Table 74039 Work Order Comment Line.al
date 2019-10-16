table 74039 "MCH Work Order Comment Line"
{
    Caption = 'Work Order Comment Line';
    DataCaptionFields = "Table Subtype","Table Name","No.";
    DrillDownPageID = "MCH Work Order Comment List";
    LookupPageID = "MCH Work Order Comment List";

    fields
    {
        field(1;"Table Name";Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'Work Order,Work Order Line';
            OptionMembers = "Work Order","Work Order Line";
        }
        field(2;"Table Subtype";Option)
        {
            Caption = 'Table Subtype';
            OptionCaption = 'Request,Planned,Released,Finished';
            OptionMembers = Request,Planned,Released,Finished;
        }
        field(3;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table Name"=CONST("Work Order")) "MCH Work Order Header"."No." WHERE (Status=FIELD("Table Subtype"))
                            ELSE IF ("Table Name"=CONST("Work Order Line")) "MCH Work Order Line"."Work Order No." WHERE (Status=FIELD("Table Subtype"));
        }
        field(4;"Table Line No.";Integer)
        {
            Caption = 'Table Line No.';
        }
        field(5;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(6;Date;Date)
        {
            Caption = 'Date';
        }
        field(8;Comment;Text[80])
        {
            Caption = 'Comment';
        }
        field(10;"Created By";Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(11;"Created Date-Time";DateTime)
        {
            Caption = 'Created Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(12;"Last Modified By";Code[50])
        {
            Caption = 'Last Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(13;"Last Modified Date-Time";DateTime)
        {
            Caption = 'Last Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Table Name","Table Subtype","No.","Table Line No.","Line No.")
        {
            Clustered = true;
            SQLIndex = "No.","Table Name","Table Subtype","Line No.","Table Line No.";
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "Created By" := UserId;
        "Created Date-Time" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date-Time" := CurrentDateTime;
    end;


    procedure SetupNewLine()
    var
        WorkOrderCommentLine: Record "MCH Work Order Comment Line";
    begin
        WorkOrderCommentLine.SetRange("Table Name","Table Name");
        WorkOrderCommentLine.SetRange("Table Subtype","Table Subtype");
        WorkOrderCommentLine.SetRange("No.","No.");
        WorkOrderCommentLine.SetRange("Table Line No.","Table Line No.");
        WorkOrderCommentLine.SetRange(Date,WorkDate);
        if WorkOrderCommentLine.IsEmpty then
          Date := WorkDate;
    end;
}

