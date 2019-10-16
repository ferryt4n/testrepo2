pageextension 74043 "MCH AM Purch. Return Order Sub" extends "Purchase Return Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("MCH Work Order No."; "MCH Work Order No.")
            {
                ApplicationArea = Basic, Suite;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("MCH WO Purchase Type"; "MCH WO Purchase Type")
            {
                ApplicationArea = Basic, Suite;

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("MCH WO Purchase Code"; "MCH WO Purchase Code")
            {
                ApplicationArea = Basic, Suite;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("MCH Work Order Line No."; "MCH Work Order Line No.")
            {
                ApplicationArea = Basic, Suite;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
            field("MCH WO Budget Line No."; "MCH WO Budget Line No.")
            {
                ApplicationArea = Basic, Suite;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }
    }
}
