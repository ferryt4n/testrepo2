table 74065 "MCH Usage Monitor Category"
{
    Caption = 'Usage Monitor Category';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Usage Monitor Categories";
    LookupPageID = "MCH Usage Monitor Categories";

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
        field(3;"No. of Monitors";Integer)
        {
            CalcFormula = Count("MCH Asset Usage Monitor" WHERE ("Category Code"=FIELD(Code)));
            Caption = 'No. of Monitors';
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

