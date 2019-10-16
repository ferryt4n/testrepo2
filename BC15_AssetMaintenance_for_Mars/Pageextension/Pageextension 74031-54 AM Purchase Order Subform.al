pageextension 74031 "MCH AM Purchase Order Subform" extends "Purchase Order Subform"
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

    actions
    {
        addlast("O&rder")
        {
            group(MCHShowWorkOrderGrp)
            {
                Caption = 'Maintenance';

                action(MCHShowWorkOrder)
                {
                    Caption = 'Work Order';
                    ToolTip = 'View the Work Order card for the Work Order No. specified on the line.';
                    ApplicationArea = Suite;
                    Image = Document;

                    trigger OnAction()
                    begin
                        MCHShowWorkOrder();
                    end;
                }
            }
        }
    }
}
