table 74061 "MCH Maintenance Task Category"
{
    Caption = 'Maintenance Task Category';
    DrillDownPageID = "MCH Maint. Task Categories";
    LookupPageID = "MCH Maint. Task Categories";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(2;Description;Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10;"No. of Master Tasks";Integer)
        {
            CalcFormula = Count("MCH Master Maintenance Task" WHERE ("Category Code"=FIELD(Code)));
            Caption = 'No. of Master Tasks';
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
        if (Code <> '') then begin
          CalcFields("No. of Master Tasks");
          if "No. of Master Tasks" > 0 then
            FieldError("No. of Master Tasks");
        end;
    end;
}

