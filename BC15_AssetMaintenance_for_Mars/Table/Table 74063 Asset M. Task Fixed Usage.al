table 74063 "MCH Asset M. Task Fixed Usage"
{
    Caption = 'Asset Maint. Task Fixed Usage';
    DataCaptionFields = "Asset No.","Task Code";
    LookupPageID = "MCH Asset MT FixedUsage Values";

    fields
    {
        field(1;"Asset No.";Code[20])
        {
            Caption = 'Asset No.';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "MCH Maintenance Asset";
        }
        field(2;"Task Code";Code[20])
        {
            Caption = 'Task Code';
            NotBlank = true;
            TableRelation = "MCH Asset Maintenance Task"."Task Code" WHERE ("Asset No."=FIELD("Asset No."));
        }
        field(3;"Usage Value";Decimal)
        {
            Caption = 'Usage Value';
            DecimalPlaces = 0:5;
            MinValue = 0;
            NotBlank = true;
        }
        field(10;Description;Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1;"Asset No.","Task Code","Usage Value")
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
        AssetMaintTask.TestField("Trigger Method",AssetMaintTask."Trigger Method"::"Fixed Usage");
    end;

    var
        AssetMaintTask: Record "MCH Asset Maintenance Task";
}

