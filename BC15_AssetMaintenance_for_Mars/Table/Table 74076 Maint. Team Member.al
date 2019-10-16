table 74076 "MCH Maint. Team Member"
{
    Caption = 'Maint. Team Member';
    DataCaptionFields = "Maint. Team Code";
    DrillDownPageID = "MCH Maint. Team Member List";
    LookupPageID = "MCH Maint. Team Member List";

    fields
    {
        field(1;"Maint. Team Code";Code[20])
        {
            Caption = 'Maint. Team Code';
            NotBlank = true;
            TableRelation = "MCH Maintenance Team";
        }
        field(3;"Resource No.";Code[20])
        {
            Caption = 'Resource No.';
            NotBlank = true;
            TableRelation = Resource;

            trigger OnValidate()
            begin
                Resource.Get("Resource No.");
                Resource.TestField("Base Unit of Measure");
                if AMFunctions.TestIfUOMTimeBased(Resource."Base Unit of Measure",false) then
                  "Unit of Measure Code" := Resource."Base Unit of Measure";
            end;
        }
        field(10;"Resource Name";Text[100])
        {
            CalcFormula = Lookup(Resource.Name WHERE ("No."=FIELD("Resource No.")));
            Caption = 'Resource Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Resource Unit of Measure".Code WHERE ("Resource No."=FIELD("Resource No."));

            trigger OnValidate()
            begin
                if ("Unit of Measure Code" <> '') then
                  AMFunctions.TestIfUOMTimeBased("Unit of Measure Code",true);
            end;
        }
        field(13;"Quantity per";Decimal)
        {
            Caption = 'Quantity per';
            DecimalPlaces = 0:5;
            InitValue = 1;
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1;"Maint. Team Code","Resource No.")
        {
            Clustered = true;
        }
        key(Key2;"Resource No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        MaintTeam.Get("Maint. Team Code");
    end;

    var
        MaintTeam: Record "MCH Maintenance Team";
        Resource: Record Resource;
        AMFunctions: Codeunit "MCH AM Functions";
}

