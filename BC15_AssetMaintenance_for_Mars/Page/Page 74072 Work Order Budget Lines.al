page 74072 "MCH Work Order Budget Lines"
{
    Caption = 'Work Order Budget Lines';
    DataCaptionFields = Status,"Work Order No.";
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Line';
    SourceTable = "MCH Work Order Budget Line";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "No.";
                ShowCaption = false;
                field("Work Order No.";"Work Order No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Line No.";"Work Order Line No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
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
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Hours;Hours)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posted Qty. (Base)";"Posted Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Invoiced Qty. (Base)";"Invoiced Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posted Hours";"Posted Hours")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Purch. Order Qty. Outst.";"Purch. Order Qty. Outst.")
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Resource Work Type Code";"Resource Work Type Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Auto Created";"Auto Created")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = 'Line';
                action("ShowEdit Budget")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show/Edit Budget';
                    Image = LedgerBudget;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        OpenBudgetPage(Status,"Work Order No.","Work Order Line No.");
                    end;
                }
                action("Show Work Order")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Work Order';
                    Image = "Order";
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        WorkOrder: Record "MCH Work Order Header";
                    begin
                        WorkOrder.Get(Status,"Work Order No.");
                        WorkOrder.ShowCard;
                    end;
                }
                action("AM Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entries';
                    Enabled = IsReleased OR IsFinished;
                    Image = ServiceLedger;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin
                        Rec.ShowAMLedgEntries;
                    end;
                }
                action("Purchase Lines")
                {
                    AccessByPermission = TableData "Purchase Line"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Lines';
                    Enabled = IsReleased;
                    Image = OrderList;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        Rec.ShowPurchaseLines;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IsReleased := (Status = Status::Released);
        IsFinished := (Status = Status::Finished);
    end;

    var
        [InDataSet]
        IsReleased: Boolean;
        [InDataSet]
        IsFinished: Boolean;
}

