page 74036 "MCH Asset - Usage Monitor Sub"
{
    Caption = 'Usage Monitors';
    CardPageID = "MCH Asset Usage Monitor Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "MCH Asset Usage Monitor";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Monitor Code";
                ShowCaption = false;
                field("Monitor Code";"Monitor Code")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                    Visible = false;
                }
                field("Total Usage";"Total Usage")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Usage at Date";"Usage at Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Reading Date";"Last Reading Date")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowLastUsageEntry;
                    end;
                }
                field(FindLastUsageValue;FindLastUsageValue)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last Usage Value';
                    DecimalPlaces = 0:5;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowLastUsageEntry;
                    end;
                }
                field(FindLastReadingValue;FindLastReadingValue)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Last Reading Value';
                    DecimalPlaces = 0:5;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowLastUsageEntry;
                    end;
                }
                field("Usage Net Change";"Usage Net Change")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Reading Type";"Reading Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Master Monitor Status";"Master Monitor Status")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Identifier Code";"Identifier Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Master Monitor Description";"Master Monitor Description")
                {
                    ApplicationArea = Basic,Suite;
                    Lookup = false;
                    Visible = false;
                }
                field("Next Calibration Date";"Next Calibration Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Calibration Date";"Last Calibration Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("First Reading Date";"First Reading Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowFirstUsageEntry;
                    end;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Modified By";"Last Modified By")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Modified Date-Time";"Last Modified Date-Time")
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
            group(History)
            {
                Caption = 'History';
                action(ShowUsageEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Entries';
                    Image = CapacityLedger;

                    trigger OnAction()
                    begin
                        Rec.ShowUsageEntries;
                    end;
                }
                action(ShowUsageTrendscape)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Trendscape';
                    Image = EntryStatistics;

                    trigger OnAction()
                    begin
                        Rec.ShowTrendscape;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetStyleTxt;
    end;

    var
        [InDataSet]
        StyleTxt: Text;
}

