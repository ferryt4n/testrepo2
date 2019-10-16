page 74104 "MCH Asset Usage Monitors"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Asset Usage Monitors';
    CardPageID = "MCH Asset Usage Monitor Card";
    DataCaptionFields = "Asset No.";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Usage Monitor";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Description;
                ShowCaption = false;
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
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
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Reading Type";"Reading Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of reading values to record: Meter: E.g. odometer balance-forward readings where usage is calculated based on the previous (date/time) registered reading. Transactional: E.g. fuel consumption.';
                }
                field("Master Monitor Status";"Master Monitor Status")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Description";"Asset Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Identifier Code";"Identifier Code")
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
                field("Asset Resp. Group Code";"Asset Resp. Group Code")
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
        area(navigation)
        {
            group("&Monitor")
            {
                Caption = '&Monitor';
                action(Asset)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset';
                    Image = ServiceItem;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "MCH Maintenance Asset Card";
                    RunPageLink = "No."=FIELD("Asset No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(ShowUsageTrendscape)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Trendscape';
                    Image = EntryStatistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.ShowTrendscape;
                    end;
                }
                action(ShowUsageEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Entries';
                    Image = CapacityLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ShortCutKey = 'Ctrl+F7';

                    trigger OnAction()
                    begin
                        Rec.ShowUsageEntries;
                    end;
                }
                action(MasterUsageMonitor)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Master Usage Monitor';
                    Image = Capacity;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    RunObject = Page "MCH Master Usage Monitor Card";
                    RunPageLink = Code=FIELD("Monitor Code");
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        StyleTxt := GetStyleTxt;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnAssetResponsibilityGroup(2);
    end;

    var
        [InDataSet]
        StyleTxt: Text;
}

