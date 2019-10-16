page 74112 "MCH Maintenance Trade Lookup"
{
    Caption = 'Maintenance Trade List';
    Editable = false;
    PageType = List;
    SourceTable = "MCH Maintenance Trade";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Code";
                ShowCaption = false;
                field("Code";Code)
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
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the Item that represents the Maint. Trade as a labour time unit that is not tracked in inventory (Item Type = Service).';
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field(EffectiveVendorNo;FindEffectiveVendorNo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Vendor No.';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Vendor No. that will be used on purchasing.';
                }
                field(EffectiveUnitOfMeasure;FindEffectiveUnitOfMeasure)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Unit of Measure Code';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Purch. Unit of Measure that will be used on purchasing.';
                }
                field("Fixed Direct Unit Cost";"Fixed Direct Unit Cost")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a fixed default Direct Unit Cost. The item/vendor purchase price setup will be used if no value is specified.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(AdvancedView)
            {
                ApplicationArea = All;
                Caption = 'Advanced View';
                Image = SetupLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Open the List page showing all possible columns.';

                trigger OnAction()
                var
                    ListPage: Page "MCH Maintenance Trade List";
                begin
                    ListPage.SetRecord(Rec);
                    ListPage.LookupMode := true;
                    if ListPage.RunModal = ACTION::LookupOK then begin
                      ListPage.GetRecord(Rec);
                      CurrPage.Close;
                    end;
                end;
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        MaintTrade: Record "MCH Maintenance Trade";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(MaintTrade);
        exit(PageFilterHelper.GetSelectionFilterForTrade(MaintTrade));
    end;
}

