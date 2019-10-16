table 74051 "MCH Maint. Unit of Measure"
{
    Caption = 'Maint. Unit of Measure';
    DataCaptionFields = "Table Name","Code";
    LookupPageID = "MCH Maint. Units of Measure";

    fields
    {
        field(1;"Table Name";Option)
        {
            OptionCaption = 'Team';
            OptionMembers = Team;
        }
        field(2;"Code";Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
            TableRelation = IF ("Table Name"=CONST(Team)) "MCH Maintenance Team";
        }
        field(3;"Unit of Measure Code";Code[10])
        {
            Caption = 'Unit of Measure Code';
            NotBlank = true;
            TableRelation = IF ("Table Name"=CONST(Team)) "Unit of Measure".Code WHERE ("MCH Time Unit"=CONST(true));
        }
        field(4;"Qty. per Unit of Measure";Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            DecimalPlaces = 0:5;
            InitValue = 1;

            trigger OnValidate()
            begin
                if "Qty. per Unit of Measure" <= 0 then
                  FieldError("Qty. per Unit of Measure",Text001);
                case "Table Name" of
                  "Table Name"::Team :
                    if MaintTeam.Get(Code) then begin
                      if MaintTeam."Base Unit of Measure" = "Unit of Measure Code" then
                        TestField("Qty. per Unit of Measure",1);
                    end;
                end;
            end;
        }
        field(10;Description;Text[100])
        {
            CalcFormula = Lookup("Unit of Measure".Description WHERE (Code=FIELD("Unit of Measure Code")));
            Caption = 'Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Table Name","Code","Unit of Measure Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Unit of Measure Code",Description,"Qty. per Unit of Measure")
        {
        }
        fieldgroup(Brick;"Unit of Measure Code",Description,"Qty. per Unit of Measure")
        {
        }
    }

    trigger OnDelete()
    begin
        case "Table Name" of
          "Table Name"::Team :
            if MaintTeam.Get(Code) then begin
              if MaintTeam."Base Unit of Measure" = "Unit of Measure Code" then
                Error(Text002,TableCaption,Code,MaintTeam.TableCaption,Code,MaintTeam.FieldCaption("Base Unit of Measure"));
            end;
        end;
    end;

    var
        Text001: Label 'must be greater than 0';
        Text002: Label 'You cannot delete %1 %2 for %3 %4 because it is the %3''s %5.';
        MaintTeam: Record "MCH Maintenance Team";
}

