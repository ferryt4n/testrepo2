pageextension 74037 "MCH AM Resource Ledger Entries" extends "Resource Ledger Entries"
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
            field("MCH Maint. Team Code"; "MCH Maint. Team Code")
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
