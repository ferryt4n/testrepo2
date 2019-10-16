page 74164 "MCH WO Finished Budget Sub"
{
    Caption = 'Line Budget';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Budget Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "No.";
                ShowCaption = false;
                field("Work Order Line No.";"Work Order Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Visible = false;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Resource Work Type Code";"Resource Work Type Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Posted Qty. (Base)";"Posted Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Hours;Hours)
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
                field("Posted Hours";"Posted Hours")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Invoiced Qty. (Base)";"Invoiced Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Auto Created";"Auto Created")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(LineActionGroup)
            {
                Caption = 'Line';
                action(ShowCard)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    ToolTip = 'View detailed information about the type of record on the line.';

                    trigger OnAction()
                    var
                        AMFunction: Codeunit "MCH AM Functions";
                    begin
                        AMFunction.GeneralShowTypeAccCard(Type,"No.");
                    end;
                }
                action(AMLedgerEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Image = ServiceLedger;

                    trigger OnAction()
                    begin
                        ShowAMLedgEntries;
                    end;
                }
            }
        }
    }
}

