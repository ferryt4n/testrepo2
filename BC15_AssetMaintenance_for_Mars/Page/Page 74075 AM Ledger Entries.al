page 74075 "MCH AM Ledger Entries"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Asset Maintenance Ledger Entries';
    DataCaptionFields = "Work Order No.","Asset No.","Maint. Task Code";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Entry,Related Entries';
    SourceTable = "MCH Asset Maint. Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Asset No.";
                ShowCaption = false;
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posting Entry Type";"Posting Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document Line No.";"Document Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Work Order No.";"Work Order No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Line No.";"Work Order Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Work Order Budget Line No.";"Work Order Budget Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Description";"Asset Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field("Asset Category Code";"Asset Category Code")
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
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Variant Code";"Variant Code")
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
                field(Hours;Hours)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Qty. Invoiced";"Qty. Invoiced")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Cost Amount";"Cost Amount")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Qty. Invoiced (Base)";"Qty. Invoiced (Base)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Reason Code";"Reason Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Qty. per Unit of Measure";"Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Inventory Entry Type";"Inventory Entry Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Resource No. (Issue/Return)";"Resource No. (Issue/Return)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Type";"Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Location Code";"Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Task Code";"Maint. Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Dimension Set ID";"Dimension Set ID")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Posting Group";"Asset Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Item Ledger Entry No.";"Item Ledger Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Resource Ledger Entry No.";"Resource Ledger Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posted By";"Posted By")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posted Date-Time";"Posted Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Posted System Date";"Posted System Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field(Adjusted;Adjusted)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether the entry has been adjusted. The value in this field is set on Purchasing Invoicing or by the Adjust Cost - Item Entries batch job. The Adjusted check box is selected if applicable.';
                }
                field("Adjustment Date-Time";"Adjustment Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the time stamp of the last entry adjustment.';
                    Visible = false;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214006;Links)
            {
                ApplicationArea = Basic,Suite;
                Visible = false;
            }
            systempart(Control1101214005;Notes)
            {
                ApplicationArea = Basic,Suite;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Entry';
                Image = Entry;
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(SetDimensionFilter)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Set Dimension Filter';
                    Ellipsis = true;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Limit the entries according to the dimension filters that you specify. NOTE: If you use a high number of dimension combinations, this function may not work and can result in a message that the SQL server only supports a maximum of 2100 parameters.';

                    trigger OnAction()
                    begin
                        SetFilter("Dimension Set ID",DimensionSetIDFilter.LookupFilter);
                    end;
                }
            }
            group("Related Entries")
            {
                Caption = 'Related Entries';
                Image = Ledger;
                action("Resource Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Resource Ledger Entries';
                    Image = ResourceLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.ShowResourceLedgerEntries;
                    end;
                }
                action("Item Ledger Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Ledger Entries';
                    Image = ItemLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.ShowItemLedgerEntries;
                    end;
                }
                action("Value Entries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Value Entries';
                    Image = ValueLedger;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.ShowValueEntries;
                    end;
                }
            }
        }
        area(processing)
        {
            action(Navigate)
            {
                ApplicationArea = Basic,Suite;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Navigate.SetDoc("Posting Date","Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not CurrPage.LookupMode then
          if FindLast then ;
    end;

    var
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
}

