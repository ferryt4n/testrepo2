table 74037 "MCH Maint. User-Asset Resp.Grp"
{
    Caption = 'Maint. User-Asset Responsibility Group';
    DataCaptionFields = "Resp. Group Code","Maint. User ID";
    DrillDownPageID = "MCH Maint.User-Asset Resp.Grps";
    LookupPageID = "MCH Maint.User-Asset Resp.Grps";
    PasteIsValid = false;

    fields
    {
        field(1;"Maint. User ID";Code[50])
        {
            Caption = 'Maint. User ID';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "MCH Asset Maintenance User";
        }
        field(2;"Resp. Group Code";Code[20])
        {
            Caption = 'Resp. Group Code';
            DataClassification = CustomerContent;
            NotBlank = true;
            TableRelation = "MCH Asset Responsibility Group";
        }
        field(5;"User Default";Boolean)
        {
            BlankZero = true;
            CalcFormula = Exist("MCH Asset Maintenance User" WHERE ("User ID"=FIELD("Maint. User ID"),
                                                                    "Default Resp. Group Code"=FIELD("Resp. Group Code")));
            Caption = 'User Default';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Resp. Group Description";Text[100])
        {
            CalcFormula = Lookup("MCH Asset Responsibility Group".Description WHERE (Code=FIELD("Resp. Group Code")));
            Caption = 'Resp. Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Maint. User ID","Resp. Group Code")
        {
            Clustered = true;
        }
        key(Key2;"Resp. Group Code")
        {
        }
    }

    fieldgroups
    {
    }
}

