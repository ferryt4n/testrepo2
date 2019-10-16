pageextension 74044 "MCH AM Posted Rtrn Shpt Sub" extends "Posted Return Shipment Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("MCH Work Order No."; "MCH Work Order No.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("MCH WO Purchase Type"; "MCH WO Purchase Type")
            {
                ApplicationArea = Basic, Suite;
            }
            field("MCH WO Purchase Code"; "MCH WO Purchase Code")
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
        }
    }
}
