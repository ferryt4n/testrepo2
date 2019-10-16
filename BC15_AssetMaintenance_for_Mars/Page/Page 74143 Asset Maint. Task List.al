page 74143 "MCH Asset Maint. Task List"
{
    ApplicationArea = Basic,Suite;
    Caption = 'Asset Maintenance Task List';
    CardPageID = "MCH Asset Maint. Task Card";
    DataCaptionFields = "Asset No.","Task Code";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Task,Work Order,History,Functions';
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Maintenance Task";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Task Code";
                ShowCaption = false;
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = StyleTxt;
                }
                field("Master Task Description";"Master Task Description")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Trigger Method";"Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
                    StyleExpr = MasterStyleTxt;
                }
                field("Trigger Description";"Trigger Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    QuickEntry = false;
                    StyleExpr = MasterStyleTxt;
                }
                field("Category Code";"Category Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Effective Date";"Effective Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expiry Date";"Expiry Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Scheduled Date";"Last Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Completion Date";"Last Completion Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Usage Monitor Code";"Usage Monitor Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Current Usage Value";"Current Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Budgeted Cost Amount";"Budgeted Cost Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Budgeted Hours";"Budgeted Hours")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                }
                field("Expected Duration (Hours)";"Expected Duration (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Expected Downtime (Hours)";"Expected Downtime (Hours)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Ongoing Work Orders";"Ongoing Work Orders")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                }
                field("Ongoing Planning Worksheet";"Ongoing Planning Worksheet")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Master Task Status";"Master Task Status")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Importance = Promoted;
                    StyleExpr = MasterStyleTxt;
                }
                field("No. of Attachments";"No. of Attachments")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowDocumentAttachments;
                    end;
                }
                field("Recurring Trigger Calc. Method";"Recurring Trigger Calc. Method")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field("No. of Fixed Usage Values";"No. of Fixed Usage Values")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("First Fixed Usage Value";"First Fixed Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Fixed Usage Value";"Last Fixed Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("No. of Fixed Dates";"No. of Fixed Dates")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("First Fixed Date";"First Fixed Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Fixed Date";"Last Fixed Date")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Starting Value (Recurr. Usage)";"Starting Value (Recurr. Usage)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Expiry Value (Recurr. Usage)";"Expiry Value (Recurr. Usage)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Asset Description";"Asset Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = false;
                }
                field("Asset Resp. Group Code";"Asset Resp. Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created Date-Time";"Created Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Modified Date-Time";"Last Modified Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Last Modified By";"Last Modified By")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1101214006;"MCH Asset Maint. Task FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Task Code"=FIELD("Task Code");
            }
            part(Control1101214018;"MCH Asset MaintTask FCast Fact")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Task Code"=FIELD("Task Code");
            }
            part(Control1101214014;"MCH Master Maint.Task Dtl Fact")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Code=FIELD("Task Code");
            }
            part(Control1101214015;"MCH Asset Usage Monitor FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Monitor Code"=FIELD("Usage Monitor Code");
                Visible = HasUsageMonitor;
            }
            systempart(Control1101214003;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214002;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action1101214009)
            {
                action(PageFixedDates)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Fixed Maint. Dates';
                    Image = Calendar;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    Visible = IsFixedDateTrigger;

                    trigger OnAction()
                    begin
                        ShowFixedDates;
                    end;
                }
                action(PageFixedUsageValues)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Fixed Maint. Usage Values';
                    Image = Line;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    Visible = IsFixedUsageTrigger;

                    trigger OnAction()
                    begin
                        ShowFixedUsageValues;
                    end;
                }
                action(MaintAsset)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maint. Asset';
                    Image = ServiceItem;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ShowAsset;
                    end;
                }
                action(MasterMaintTask)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Master Maint. Task';
                    Image = Task;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ShowMasterMaintTask;
                    end;
                }
                action(MasterTaskBudget)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Master Task Budget';
                    Image = CostAccountingSetup;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    RunObject = Page "MCH Maint. Task Budget Lines";
                    RunPageLink = "Task Code"=FIELD("Task Code");
                }
                action(UsageMonitor)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Monitor';
                    Enabled = EnableUsageMonitor;
                    Image = Capacity;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    Visible = EnableUsageMonitor;

                    trigger OnAction()
                    begin
                        ShowAssetUsageMonitor;
                    end;
                }
                action(Attachments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ShowDocumentAttachments;
                    end;
                }
                action(AMLedgerEntryStatistics)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entry Statistics';
                    Image = EntryStatistics;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    RunObject = Page "MCH Maint. Asset Entry Stat.";
                    RunPageLink = "No."=FIELD("Asset No."),
                                  "Maint. Task Filter"=FIELD("Task Code");
                }
                action(AMLedgerEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger E&ntries';
                    Image = MaintenanceLedgerEntries;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    RunObject = Page "MCH AM Ledger Entries";
                    RunPageLink = "Asset No."=FIELD("Asset No."),
                                  "Maint. Task Code"=FIELD("Task Code");
                    RunPageView = SORTING("Asset No.","Maint. Task Code","Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action(UsageMonitorEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Monitor Entries';
                    Enabled = EnableUsageMonitor;
                    Image = CapacityLedger;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    Visible = EnableUsageMonitor;

                    trigger OnAction()
                    begin
                        ShowUsageMonitorEntries;
                    end;
                }
                action("Maintenance Forecast")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show Maint. Forecast';
                    Image = SuggestLines;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Rec.ShowMaintForecastOverview;
                    end;
                }
                action("Calculate Scheduled Maintenance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Calc. Scheduled Maintenance';
                    Ellipsis = true;
                    Image = MachineCenterCalendar;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        MaintAsset: Record "MCH Maintenance Asset";
                        AssetMaintTask: Record "MCH Asset Maintenance Task";
                        CalcScheduledMaint: Report "MCH Calc Scheduled Maint.";
                    begin
                        AssetMaintTask.Get("Asset No.","Task Code");
                        AssetMaintTask.SetRange("Task Code","Task Code");
                        MaintAsset.Get("Asset No.");
                        MaintAsset.SetRecFilter;
                        CalcScheduledMaint.SetTableView(MaintAsset);
                        CalcScheduledMaint.SetTableView(AssetMaintTask);
                        CalcScheduledMaint.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls;
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnAssetResponsibilityGroup(2);
    end;

    var
        [InDataSet]
        StyleTxt: Text;
        [InDataSet]
        MasterStyleTxt: Text;
        [InDataSet]
        IsCalendarTrigger: Boolean;
        [InDataSet]
        IsFixedDateTrigger: Boolean;
        [InDataSet]
        IsRecurringUsageTrigger: Boolean;
        [InDataSet]
        IsFixedUsageTrigger: Boolean;
        [InDataSet]
        EnableUsageMonitor: Boolean;
        [InDataSet]
        HasUsageMonitor: Boolean;


    procedure GetSelectionFilter(): Text
    var
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
    begin
        CurrPage.SetSelectionFilter(AssetMaintTask);
        exit(PageFilterHelper.GetSelectionFilterForAssetMaintTask(AssetMaintTask));
    end;

    local procedure EnableControls()
    begin
        StyleTxt := GetStyleTxt;
        MasterStyleTxt := GetMasterStyleTxt;

        IsCalendarTrigger := false;
        IsRecurringUsageTrigger := false;
        IsFixedDateTrigger := false;
        IsFixedUsageTrigger := false;
        EnableUsageMonitor := false;
        HasUsageMonitor := ("Usage Monitor Code" <> '');

        case "Trigger Method" of
          "Trigger Method"::Manual:
            begin
              EnableUsageMonitor := true;
            end;
          "Trigger Method"::"Calendar (Recurring)":
            begin
              IsCalendarTrigger := true;
            end;
          "Trigger Method"::"Usage (Recurring)":
            begin
              IsRecurringUsageTrigger := true;
              EnableUsageMonitor := true;
            end;
          "Trigger Method"::"Fixed Date":
            begin
              IsFixedDateTrigger := true;
            end;
          "Trigger Method"::"Fixed Usage":
            begin
              IsFixedUsageTrigger :=true;
              EnableUsageMonitor := true;
            end;
        end;
    end;
}

