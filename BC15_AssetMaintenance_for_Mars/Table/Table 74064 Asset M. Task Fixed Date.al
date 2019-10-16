table 74064 "MCH Asset M. Task Fixed Date"
{
    Caption = 'Asset Maint. Task Fixed Date';
    DataCaptionFields = "Asset No.","Task Code";
    LookupPageID = "MCH Asset MT FixedDates";

    fields
    {
        field(2;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            NotBlank = true;
            TableRelation = "MCH Maintenance Asset";
        }
        field(3;"Task Code";Code[20])
        {
            Caption = 'Task Code';
            NotBlank = true;
            TableRelation = "MCH Asset Maintenance Task"."Task Code" WHERE ("Asset No."=FIELD("Asset No."));
        }
        field(4;"Due Date";Date)
        {
            Caption = 'Due Date';
            NotBlank = true;
        }
        field(10;Description;Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1;"Asset No.","Task Code","Due Date")
        {
            Clustered = true;
        }
        key(Key2;"Task Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Asset No.");
        TestField("Task Code");
        AssetMaintTask.Get("Asset No.","Task Code");
        AssetMaintTask.TestField("Trigger Method",AssetMaintTask."Trigger Method"::"Fixed Date");
    end;

    var
        AssetMaintTask: Record "MCH Asset Maintenance Task";
}

