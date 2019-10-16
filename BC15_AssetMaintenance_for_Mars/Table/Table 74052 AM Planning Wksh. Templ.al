table 74052 "MCH AM Planning Wksh. Templ."
{
    Caption = 'Maint. Planning Wksh. Template';
    DrillDownPageID = "MCH AM Plan. Wksh. Templ. List";
    LookupPageID = "MCH AM Plan. Wksh. Templ. List";

    fields
    {
        field(1;Name;Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2;Description;Text[80])
        {
            Caption = 'Description';
        }
        field(6;"Page ID";Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE ("Object Type"=CONST(Page));

            trigger OnValidate()
            begin
                if "Page ID" = 0 then
                  Validate(Type);
            end;
        }
        field(9;Type;Option)
        {
            Caption = 'Type';
            OptionCaption = 'Planning';
            OptionMembers = Planning;

            trigger OnValidate()
            begin
                case Type of
                  Type::Planning:
                    "Page ID" :=  PAGE::"MCH AM Planning Worksheet";
                end;
            end;
        }
        field(16;"Page Caption";Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE ("Object Type"=CONST(Page),
                                                                           "Object ID"=FIELD("Page ID")));
            Caption = 'Page Caption';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        PlanningWkshLine.SetRange("Worksheet Template Name",Name);
        PlanningWkshLine.DeleteAll(true);
        PlanningWkshName.SetRange("Worksheet Template Name",Name);
        PlanningWkshName.DeleteAll;
    end;

    trigger OnInsert()
    begin
        Validate("Page ID");
    end;

    var
        PlanningWkshName: Record "MCH AM Planning Wksh. Name";
        PlanningWkshLine: Record "MCH AM Planning Wksh. Line";
}

