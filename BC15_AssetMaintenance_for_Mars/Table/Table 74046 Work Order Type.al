table 74046 "MCH Work Order Type"
{
    Caption = 'Work Order Type';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Work Order Type List";
    LookupPageID = "MCH Work Order Type Lookup";

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
        field(5;Blocked;Boolean)
        {
            BlankZero = true;
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
        field(10;"Def. Work Order Priority";Option)
        {
            Caption = 'Def. Work Order Priority';
            OptionCaption = ' ,Very High,High,Medium,Low,Very Low';
            OptionMembers = " ","Very High",High,Medium,Low,"Very Low";
        }
        field(20;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(21;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
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

        DimMgt.DeleteDefaultDim(DATABASE::"MCH Work Order Type",Code);
    end;

    trigger OnInsert()
    begin
        DimMgt.UpdateDefaultDim(
          DATABASE::"MCH Work Order Type",Code,
          "Global Dimension 1 Code","Global Dimension 2 Code");
    end;

    trigger OnRename()
    begin
        DimMgt.RenameDefaultDim(DATABASE::"MCH Work Order Type",xRec.Code,Code);
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        AMFunctions: Codeunit "MCH AM Functions";


    procedure ValidateShortcutDimCode(FieldNumber: Integer;var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"MCH Work Order Type",Code,FieldNumber,ShortcutDimCode);
        Modify;
    end;
}

