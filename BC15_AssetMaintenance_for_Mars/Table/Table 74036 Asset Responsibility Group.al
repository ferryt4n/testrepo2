table 74036 "MCH Asset Responsibility Group"
{
    Caption = 'Asset Responsibility Group';
    DataCaptionFields = "Code",Description;
    DrillDownPageID = "MCH Asset Resp. Group List";
    LookupPageID = "MCH Asset Resp. Group Lookup";

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
        field(5;"Responsible User ID";Code[50])
        {
            Caption = 'Responsible User ID';
            DataClassification = CustomerContent;
            TableRelation = "MCH Asset Maintenance User";

            trigger OnValidate()
            begin
                if ("Responsible User ID" <> '') then begin
                  if not MaintUserMgt.UserHasAccessToRespGroup("Responsible User ID",Code) then
                    Error(Text001,FieldCaption("Responsible User ID"),"Responsible User ID",TableCaption,Code);
                end;
            end;
        }
        field(10;"No. of Assets";Integer)
        {
            BlankZero = true;
            CalcFormula = Count("MCH Maintenance Asset" WHERE ("Responsibility Group Code"=FIELD(Code)));
            Caption = 'No. of Assets';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;"No. of Users with Filter View";Integer)
        {
            BlankZero = true;
            CalcFormula = Count("MCH Maint. User-Asset Resp.Grp" WHERE ("Resp. Group Code"=FIELD(Code)));
            Caption = 'No. of Users with Filter View';
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
        fieldgroup(DropDown;"Code",Description,"Responsible User ID")
        {
        }
        fieldgroup(Brick;"Code",Description,"Responsible User ID")
        {
        }
    }

    trigger OnDelete()
    begin
        if (Code <> '') then begin
          AMFunctions.CheckIfRecordIsTableRelationReferenced(Rec);
        end;
    end;

    var
        AMFunctions: Codeunit "MCH AM Functions";
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        Text001: Label '%1 %2 is not setup to process for %3 %4.';


    procedure SetSecurityFilterOnResponsibilityGroup(FilterGrpNo: Integer)
    begin
        if MaintUserMgt.UserHasAssetRespGroupFilter then begin
          FilterGroup(FilterGrpNo);
          SetFilter(Code,MaintUserMgt.GetAssetRespGroupFilter);
          FilterGroup(0);
        end;
    end;
}

