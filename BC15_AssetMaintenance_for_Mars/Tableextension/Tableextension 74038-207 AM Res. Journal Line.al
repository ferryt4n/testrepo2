tableextension 74038 "MCH AM Res. Journal Line" extends "Res. Journal Line"
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
        field(74035; "MCH Maint. Asset No."; Code[20])
        {
            Caption = 'Maint. Asset No.';
            DataClassification = CustomerContent;
            TableRelation = "MCH Maintenance Asset";
        }
        field(74039; "MCH Maint. Team Code"; Code[20])
        {
            Caption = 'MCH Maint. Team Code';
            DataClassification = CustomerContent;
            TableRelation = "MCH Maintenance Team";
        }
        field(74040; "MCH AM Ledger Entry No."; Integer)
        {
            BlankZero = true;
            Caption = 'AM Ledger Entry No.';
            DataClassification = CustomerContent;
        }
    }
}