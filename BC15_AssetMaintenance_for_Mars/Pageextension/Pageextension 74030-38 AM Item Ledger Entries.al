pageextension 74030 "MCH AM Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addbefore("Entry No.")
        {
            field("MCH Work Order No."; "MCH Work Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("MCH Maint. Asset No."; "MCH Maint. Asset No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("MCH Work Order Line No."; "MCH Work Order Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("MCH WO Budget Line No."; "MCH WO Budget Line No.")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            field("MCH WO Purchase Type"; "MCH WO Purchase Type")
            {
                ApplicationArea = Basic, Suite;
            }
            field("MCH WO Purchase Code"; "MCH WO Purchase Code")
            {
                ApplicationArea = Basic, Suite;
            }
            field("MCH AM Ledger Entry No."; "MCH AM Ledger Entry No.")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }
}