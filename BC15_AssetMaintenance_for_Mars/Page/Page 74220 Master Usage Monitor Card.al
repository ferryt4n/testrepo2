page 74220 "MCH Master Usage Monitor Card"
{
    Caption = 'Master Usage Monitor';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Usage Monitor,Functions,History';
    RefreshOnActivate = true;
    SourceTable = "MCH Master Usage Monitor";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = EnableSetup;
                group(Control1101214010)
                {
                    ShowCaption = false;
                    field("Code";Code)
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                        StyleExpr = StyleTxt;
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
                        ShowMandatory = true;
                    }
                }
                group(Control1101214011)
                {
                    ShowCaption = false;
                    field("Reading Type";"Reading Type")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the type of reading values to record: Meter: E.g. odometer balance-forward readings where usage is calculated based on the previous (date/time) registered reading. Transactional: E.g. fuel consumption.';

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Category Code";"Category Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                    }
                    field("No. of Asset Usage Monitors";"No. of Asset Usage Monitors")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field(Status;Status)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        Importance = Promoted;
                        StyleExpr = StyleTxt;
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
            group("Reading Rules")
            {
                Caption = 'Reading Rules';
                Editable = EnableSetup;
                group("Allowed Value Range")
                {
                    Caption = 'Allowed Value Range';
                    field("Min. Allowed Reading Value";"Min. Allowed Reading Value")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Max. Allowed Reading Value";"Max. Allowed Reading Value")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                }
                group("Allowed Reading Dates")
                {
                    Caption = 'Allowed Reading Dates';
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
                }
                group("Value Adjustment")
                {
                    Caption = 'Value Adjustment';
                    field("Adj. Factor Before Rounding";"Adj. Factor Before Rounding")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Reading Rounding Direction";"Reading Rounding Direction")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Reading Rounding Precision";"Reading Rounding Precision")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Adj. Factor After Rounding";"Adj. Factor After Rounding")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101214022;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214023;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Set Status to Active")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to Active';
                Enabled = Status <> Status::Active;
                Image = ReleaseDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Change the status to Active. This will enable registring of usage and makes the monitor available on maintenance scheduling.';

                trigger OnAction()
                begin
                    SetStatus(Status::Active,true);
                end;
            }
            action("Set Status to Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to Setup';
                Enabled = Status <> Status::Setup;
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Change the status to edit the usage monitor setup. Asset usage cannot be registered with this status and the monitor is excluded on maintenance scheduling.';

                trigger OnAction()
                begin
                    SetStatus(Status::Setup,false);
                end;
            }
            action("Set Status to On Hold")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to On Hold';
                Enabled = Status <> Status::"On Hold";
                Image = Pause;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Change the status to On Hold. Usage cannot be registered with this status and the monitor is excluded on maintenance scheduling.';

                trigger OnAction()
                begin
                    SetStatus(Status::"On Hold",true);
                end;
            }
            action("Set Status to Blocked")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Set Status to Blocked';
                Enabled = Status <> Status::Blocked;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Change the status to Blocked. Usage cannot be registered with this status and the monitor is excluded on maintenance scheduling.';

                trigger OnAction()
                begin
                    SetStatus(Status::Blocked,true);
                end;
            }
            action(ManageAssetUsageMonitor)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Manage Asset Usage Monitors';
                Ellipsis = true;
                Image = SetupLines;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.BatchCreateMAUsageMonitors;
                end;
            }
        }
        area(navigation)
        {
            action(ShowAssetUsageMonitors)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Asset Usage Monitors';
                Image = Capacity;
                Promoted = true;
                PromotedCategory = Category4;
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
                PromotedCategory = Category6;
                PromotedOnly = true;
                RunObject = Page "MCH Usage Monitor Entries";
                RunPageLink = "Monitor Code"=FIELD(Code);
                RunPageView = SORTING("Asset No.","Monitor Code","Reading Date-Time","Reading Value");
                ShortCutKey = 'Ctrl+F7';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        StyleTxt := GetStyleTxt;
        EnableSetup := (Status = Status::Setup);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetRange(Status);
        EnableSetup := true;
        Status := Status::Setup;
    end;

    var
        [InDataSet]
        StyleTxt: Text;
        [InDataSet]
        EnableSetup: Boolean;
}

