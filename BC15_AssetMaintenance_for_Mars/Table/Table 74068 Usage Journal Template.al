table 74068 "MCH Usage Journal Template"
{
    Caption = 'Usage Journal Template';
    DataCaptionFields = Name,Description;
    DrillDownPageID = "MCH Usage Jnl. Templ. List";
    LookupPageID = "MCH Usage Jnl. Templ. List";

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
            OptionCaption = 'Usage';
            OptionMembers = Usage;

            trigger OnValidate()
            begin
                case Type of
                  Type::Usage:
                    begin
                      "Page ID" := PAGE::"MCH Usage Journal";
                    end;
                  else
                    "Page ID" := PAGE::"MCH Usage Journal";
                end;
            end;
        }
        field(14;"Page Caption";Text[250])
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
        MAUsageJnlLine.SetRange("Journal Template Name",Name);
        MAUsageJnlLine.DeleteAll(true);
        MAUsageJnlBatch.SetRange("Journal Template Name",Name);
        MAUsageJnlBatch.DeleteAll;
    end;

    trigger OnInsert()
    begin
        Validate("Page ID");
    end;

    var
        Text000: Label 'Only the %1 field can be filled in on recurring journals.';
        Text001: Label 'must not be %1';
        MAUsageJnlBatch: Record "MCH Usage Journal Batch";
        MAUsageJnlLine: Record "MCH Usage Journal Line";
}

