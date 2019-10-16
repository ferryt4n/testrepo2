page 74071 "MCH Released WO Budget"
{
    AutoSplitKey = true;
    Caption = 'Work Order Budget';
    DataCaptionFields = Status,"Work Order No.";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    PopulateAllFields = true;
    PromotedActionCategories = 'New,Process,Report,Line,Functions';
    RefreshOnActivate = true;
    SourceTable = "MCH Work Order Budget Line";
    SourceTableView = WHERE(Status=CONST(Released));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                FreezeColumn = "No.";
                ShowCaption = false;
                field("Work Order Line No.";"Work Order Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Editable = EnableLineSelection;
                    Enabled = EnableLineSelection;
                    ShowMandatory = true;
                    Visible = EnableLineSelection;

                    trigger OnValidate()
                    begin
                        GetDescriptions;
                    end;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    Visible = EnableLineSelection;
                }
                field("Maint. Task Code";"Maint. Task Code")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    Visible = EnableLineSelection;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
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
                field("Resource Work Type Code";"Resource Work Type Code")
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
                    BlankZero = true;
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Visible = false;
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                    end;
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
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Visible = false;
                }
                field("Posted Qty. (Base)";"Posted Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posted Hours";"Posted Hours")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Invoiced Qty. (Base)";"Invoiced Qty. (Base)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Purch. Order Qty. Outst.";"Purch. Order Qty. Outst.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Purch. Order Amt. Outst.";"Purch. Order Amt. Outst.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Purch. Order Qty. Rcd.Not Inv.";"Purch. Order Qty. Rcd.Not Inv.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = VendorIsMandatory;
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
            group(Control1101214026)
            {
                ShowCaption = false;
                fixed(Control1101214025)
                {
                    ShowCaption = false;
                    group("Info - Asset No.")
                    {
                        Caption = 'Asset No.';
                        field("CurrentWorkOrderLine.""Asset No.""";CurrentWorkOrderLine."Asset No.")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Asset Description")
                    {
                        Caption = 'Asset Description';
                        field("CurrentWorkOrderLine.Description";CurrentWorkOrderLine.Description)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Task Code")
                    {
                        Caption = 'Task Code';
                        field("CurrentWorkOrderLine.""Task Code""";CurrentWorkOrderLine."Task Code")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                    group("Task Description")
                    {
                        Caption = 'Task Description';
                        field("CurrentWorkOrderLine.""Task Description""";CurrentWorkOrderLine."Task Description")
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
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
                action(ShowCard)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ShortCutKey = 'Shift+F7';
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
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        ShowAMLedgEntries;
                    end;
                }
                action(PurchaseLines)
                {
                    AccessByPermission = TableData "Purchase Line"=R;
                    ApplicationArea = Basic,Suite;
                    Caption = 'Purchase Lines';
                    Image = OrderList;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        ShowPurchaseLines;
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
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetDescriptions;
        VendorIsMandatory := IsVendorMandatory;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if xRec."Work Order Line No." <> 0 then
          Validate("Work Order Line No.",xRec."Work Order Line No.");
        if (xRec.Type > Type::" ") then
          Type := xRec.Type
        else
          Type := Type::Item;

        GetDescriptions;
    end;

    trigger OnOpenPage()
    var
        WOHeader2: Record "MCH Work Order Header";
        WorkOrderLine2: Record "MCH Work Order Line";
        SetPageEditable: Boolean;
    begin
        FilterGroup(2);
        if (GetFilter("Work Order No.") = '') then begin
          CurrPage.Editable(false);
        end else begin
          EnableLineSelection := (GetFilter("Work Order Line No.") = '');
        end;
        FilterGroup(0);
    end;

    var
        CurrentWorkOrderLine: Record "MCH Work Order Line";
        [InDataSet]
        VendorIsMandatory: Boolean;
        [InDataSet]
        EnableLineSelection: Boolean;

    local procedure GetDescriptions()
    begin
        if (CurrentWorkOrderLine.Status <> Status) or
           (CurrentWorkOrderLine."Work Order No." <> "Work Order No.") or
           (CurrentWorkOrderLine."Line No." <> "Work Order Line No.")
        then begin
          if not CurrentWorkOrderLine.Get(Status,"Work Order No.","Work Order Line No.") then
            CurrentWorkOrderLine.Init;
        end;
    end;
}

