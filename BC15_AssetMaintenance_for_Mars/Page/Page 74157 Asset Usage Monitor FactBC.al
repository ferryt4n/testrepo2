page 74157 "MCH Asset Usage Monitor FactBC"
{
    Caption = 'Asset Usage Monitor - Details';
    Editable = false;
    PageType = CardPart;
    SourceTable = "MCH Asset Usage Monitor";

    layout
    {
        area(content)
        {
            group(Control1101214001)
            {
                ShowCaption = false;
                field("Monitor Code";"Monitor Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Reading Type";"Reading Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
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
                field("Last Reading Value";FindLastReadingValue)
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    Caption = 'Last Reading Value';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowLastUsageEntry;
                    end;
                }
                field("Total Usage";"Total Usage")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowUsageEntries;
                    end;
                }
            }
        }
    }

    actions
    {
    }
}

