table 74034 "MCH Maint. Asset Category"
{
    Caption = 'Maintenance Asset Category';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Maint. Asset Category List";
    LookupPageID = "MCH Maint. Asset Cat. Lookup";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(10;"No. of Assets";Integer)
        {
            CalcFormula = Count("MCH Maintenance Asset" WHERE ("Category Code"=FIELD(Code)));
            Caption = 'No. of Assets';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if (Code <> '') then
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);
    end;

    var
        AMFunctions: Codeunit "MCH AM Functions";
}

