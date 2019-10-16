table 74089 "MCH Maint. Asset Posting Group"
{
    Caption = 'Maint. Asset Posting Group';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Maint. Asset Posting Grps";
    LookupPageID = "MCH Maint. Asset Posting Grps";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(10;"No. of Assets";Integer)
        {
            CalcFormula = Count("MCH Maintenance Asset" WHERE ("Posting Group"=FIELD(Code)));
            Caption = 'No. of Assets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"Used in AM Posting Setup";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH AM Posting Setup" WHERE ("Asset Posting Group"=FIELD(Code)));
            Caption = 'Used in AM Posting Setup';
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

