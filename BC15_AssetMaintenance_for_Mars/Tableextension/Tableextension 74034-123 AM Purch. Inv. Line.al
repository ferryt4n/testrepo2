tableextension 74034 "MCH AM Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {
        field(74030; "MCH Work Order No."; Code[20])
        {
            Caption = 'Work Order No.';
            DataClassification = CustomerContent;
            TableRelation = "MCH Work Order Header"."No." WHERE (Status = FILTER (Released | Finished));
        }
        field(74031; "MCH Work Order Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'Work Order Line No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("MCH Work Order No." = FILTER (<> '')) "MCH Work Order Line"."Line No." WHERE ("Work Order No." = FIELD ("MCH Work Order No."));
        }
        field(74032; "MCH WO Budget Line No."; Integer)
        {
            BlankZero = true;
            Caption = 'WO Budget Line No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("MCH Work Order No." = FILTER (<> ''),
                                "MCH Work Order Line No." = FILTER (<> 0)) "MCH Work Order Budget Line"."Line No." WHERE ("Work Order No." = FIELD ("MCH Work Order No."),
                                                                                                                      "Work Order Line No." = FIELD ("MCH Work Order Line No."))
            ELSE
            IF ("MCH Work Order No." = FILTER (<> '')) "MCH Work Order Budget Line"."Line No." WHERE ("Work Order No." = FIELD ("MCH Work Order No."));
        }
        field(74033; "MCH WO Purchase Type"; Option)
        {
            Caption = 'WO Purchase Type';
            DataClassification = CustomerContent;
            OptionCaption = ' ,Spare Part,Cost,Trade';
            OptionMembers = " ","Spare Part",Cost,Trade;
        }
        field(74034; "MCH WO Purchase Code"; Code[20])
        {
            Caption = 'WO Purchase Code';
            DataClassification = CustomerContent;
            TableRelation = IF ("MCH WO Purchase Type" = CONST ("Spare Part")) "MCH Maintenance Spare Part"
            ELSE
            IF ("MCH WO Purchase Type" = CONST (Cost)) "MCH Maintenance Cost"
            ELSE
            IF ("MCH WO Purchase Type" = CONST (Trade)) "MCH Maintenance Trade";
        }
    }

    keys
    {
        key(MCHAssetMaintenanceKey1; "MCH Work Order No.", "MCH WO Budget Line No.", "MCH Work Order Line No.")
        {
        }
    }
}