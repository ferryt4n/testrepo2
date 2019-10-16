page 74163 "MCH WO Released Budget Sub"
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
                field("Purch. Order Qty. Outst.";"Purch. Order Qty. Outst.")
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
                field("Vendor Name";"Vendor Name")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
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
            group(Line)
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
                group("Item Availability by")
                {
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action(ShowAvailByLocation)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Location';
                        Image = Warehouse;

                        trigger OnAction()
                        begin
                            ShowItemAvailability(2);
                        end;
                    }
                    action(ShowAvailByPeriod)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Period';
                        Image = Period;

                        trigger OnAction()
                        begin
                            ShowItemAvailability(0);
                        end;
                    }
                    action(ShowAvailByEvent)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Event';
                        Image = "Event";

                        trigger OnAction()
                        begin
                            ShowItemAvailability(4);
                        end;
                    }
                    action(ShowAvailByVariant)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Variant';
                        Image = ItemVariant;

                        trigger OnAction()
                        begin
                            ShowItemAvailability(1);
                        end;
                    }
                }
                action("Ongoing Purchase Lines")
                {
                    AccessByPermission = TableData "Purchase Line"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Ongoing Purchase Lines';
                    Image = List;
                    ToolTip = 'Open the list of ongoing purchase lines related to the work order.';

                    trigger OnAction()
                    begin
                        Rec.ShowPurchaseLines;
                    end;
                }
                action(AMLedgerEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Image = ServiceLedger;

                    trigger OnAction()
                    begin
                        Rec.ShowAMLedgEntries;
                    end;
                }
            }
        }
    }
}

