page 74221 "MCH Master Usage Monitors"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Master Usage Monitors';
    CardPageID = "MCH Master Usage Monitor Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "MCH Master Usage Monitor";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = Description;
                ShowCaption = false;
                field("Code";Code)
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
                    Visible = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
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
                    ToolTip = 'Specifies the type of reading values to record: Meter: E.g. odometer balance-forward readings where usage is calculated based on the previous (date/time) registered reading. Transactional: E.g. fuel consumption.';
                }
                field("No. of Asset Usage Monitors";"No. of Asset Usage Monitors")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Adj. Factor Before Rounding";"Adj. Factor Before Rounding")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Reading Rounding Direction";"Reading Rounding Direction")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Reading Rounding Precision";"Reading Rounding Precision")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Adj. Factor After Rounding";"Adj. Factor After Rounding")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Min. Allowed Reading Value";"Min. Allowed Reading Value")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Max. Allowed Reading Value";"Max. Allowed Reading Value")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Max. Allowed Aged Read. Days";"Max. Allowed Aged Read. Days")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the max. number of days in the past that reading dates are allowed. The earliest (aged) reading Date allowed is calculated based on either Working Date or System Date which you define in AM Setup.';
                }
                field("Max. Allowed Read-Ahead Days";"Max. Allowed Read-Ahead Days")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the max. number of days into the future that reading dates are allowed. The latest reading Date allowed is calculated based on either Working Date or System Date which you define in AM Setup.';
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
        area(factboxes)
        {
            systempart(Control1101214022;Links)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214023;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(ShowAssetUsageMonitors)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Asset Usage Monitors';
                Image = Capacity;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "MCH Asset Usage Monitors";
                RunPageLink = "Monitor Code"=FIELD(Code);
            }
            action(ShowUsageEntries)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Usage E&ntries';
                Image = CapacityLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                RunObject = Page "MCH Usage Monitor Entries";
                RunPageLink = "Monitor Code"=FIELD(Code);
                RunPageView = SORTING("Asset No.","Monitor Code","Reading Date-Time","Reading Value");
                ShortCutKey = 'Ctrl+F7';
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

