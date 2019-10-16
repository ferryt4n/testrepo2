table 74038 "MCH AM Comment Line"
{
    Caption = 'AM Comment Line';
    DrillDownPageID = "MCH Maint. Comment List";
    LookupPageID = "MCH Maint. Comment List";

    fields
    {
        field(1;"Table Name";Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'Maint. Asset,Spare Part,Cost,Team,Trade';
            OptionMembers = "Maint. Asset","Spare Part",Cost,Team,Trade;
        }
        field(2;"No.";Code[20])
        {
            Caption = 'No.';
            TableRelation = IF ("Table Name"=CONST("Maint. Asset")) "MCH Maintenance Asset"
                            ELSE IF ("Table Name"=CONST("Spare Part")) "MCH Maintenance Spare Part"
                            ELSE IF ("Table Name"=CONST(Cost)) "MCH Maintenance Cost"
                            ELSE IF ("Table Name"=CONST(Team)) "MCH Maintenance Team"
                            ELSE IF ("Table Name"=CONST(Trade)) "MCH Maintenance Trade";
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(4;Date;Date)
        {
            Caption = 'Date';
        }
        field(6;Comment;Text[80])
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
        field(12;"Modified By";Code[50])
        {
            Caption = 'Modified By';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(13;"Modified Date-Time";DateTime)
        {
            Caption = 'Modified Date-Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Table Name","No.","Line No.")
        {
            Clustered = true;
            SQLIndex = "No.","Line No.","Table Name";
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
        "Modified By" := UserId;
        "Modified Date-Time" := CurrentDateTime;
    end;


    procedure SetupNewLine()
    var
        MaintCommentLine: Record "MCH AM Comment Line";
    begin
        MaintCommentLine.SetRange("Table Name","Table Name");
        MaintCommentLine.SetRange("No.","No.");
        MaintCommentLine.SetRange(Date,WorkDate);
        if MaintCommentLine.IsEmpty then
          Date := WorkDate;
    end;
}

