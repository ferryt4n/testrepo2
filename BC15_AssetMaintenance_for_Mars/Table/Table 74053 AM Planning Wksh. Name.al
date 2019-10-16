table 74053 "MCH AM Planning Wksh. Name"
{
    Caption = 'Maint. Planning Wksh. Name';
    DataCaptionFields = Name,Description;
    LookupPageID = "MCH AM Planning Wksh. Names";

    fields
    {
        field(1;"Worksheet Template Name";Code[10])
        {
            Caption = 'Worksheet Template Name';
            NotBlank = true;
            TableRelation = "MCH AM Planning Wksh. Templ.";
        }
        field(2;Name;Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3;Description;Text[100])
        {
            Caption = 'Description';
        }
        field(10;"Template Type";Option)
        {
            CalcFormula = Lookup("MCH AM Planning Wksh. Templ.".Type WHERE (Name=FIELD("Worksheet Template Name")));
            Caption = 'Template Type';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = 'Planning';
            OptionMembers = Planning;
        }
        field(20;"No. of Wksh. Lines";Integer)
        {
            CalcFormula = Count("MCH AM Planning Wksh. Line" WHERE ("Worksheet Template Name"=FIELD("Worksheet Template Name"),
                                                                    "Journal Batch Name"=FIELD(Name),
                                                                    "Asset No."=FILTER(<>'')));
            Caption = 'No. of Wksh. Lines';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Worksheet Template Name",Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PlanningWkshLine.SetRange("Worksheet Template Name","Worksheet Template Name");
        PlanningWkshLine.SetRange("Journal Batch Name",Name);
        PlanningWkshLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable;
        PlanningWkshTemplate.Get("Worksheet Template Name");
    end;

    trigger OnRename()
    begin
        PlanningWkshLine.SetRange("Worksheet Template Name",xRec."Worksheet Template Name");
        PlanningWkshLine.SetRange("Journal Batch Name",xRec.Name);
        while PlanningWkshLine.Find('-') do
          PlanningWkshLine.Rename("Worksheet Template Name",Name,PlanningWkshLine."Line No.");
    end;

    var
        PlanningWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
        PlanningWkshLine: Record "MCH AM Planning Wksh. Line";
}

