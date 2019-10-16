pageextension 74032 "MCH AM Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        addlast(PurchDetailLine)
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
