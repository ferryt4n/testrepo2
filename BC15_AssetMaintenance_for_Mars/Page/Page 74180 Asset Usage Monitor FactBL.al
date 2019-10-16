page 74180 "MCH Asset Usage Monitor FactBL"
{
    Caption = 'Usage Monitors';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "MCH Asset Usage Monitor";

    layout
    {
        area(content)
        {
            repeater(Control1101214001)
            {
                ShowCaption = false;
                field("Monitor Code";"Monitor Code")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                }
                field("Total Usage";"Total Usage")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Reading Date";"Last Reading Date")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowLastUsageEntry;
                    end;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                    ShowMandatory = true;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Master Monitor Status";"Master Monitor Status")
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Card)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Card';
                Enabled = EnableControls;
                Image = Capacity;
                RunObject = Page "MCH Asset Usage Monitor Card";
                RunPageMode = View;
                RunPageOnRec = true;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        EnableControls := false;
    end;

    var
        [InDataSet]
        EnableControls: Boolean;
}

