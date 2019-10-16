page 74142 "MCH Asset Maint. Task Card"
{
    Caption = 'Asset Maintenance Task Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Task,Work Order,History,Functions';
    RefreshOnActivate = true;
    SourceTable = "MCH Asset Maintenance Task";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                group(Control1101214050)
                {
                    ShowCaption = false;
                    field("Asset No.";"Asset No.")
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;
                    }
                    field("Task Code";"Task Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ShowMandatory = true;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AssetMaintTask: Record "MCH Asset Maintenance Task";
                            MasterMaintTask: Record "MCH Master Maintenance Task";
                            MasterMaintTaskLookup: Page "MCH Master Maint. Task Lookup";
                            [InDataSet]
                            InsertMode: Boolean;
                        begin
                            InsertMode := not AssetMaintTask.Get("Asset No.","Task Code");
                            MasterMaintTask.Code := "Task Code";
                            if (MasterMaintTask.Code <> '') then
                              MasterMaintTaskLookup.SetRecord(MasterMaintTask);
                            if InsertMode then begin
                              MasterMaintTask.SetCurrentKey(Status);
                              MasterMaintTask.SetFilter(Status,'%1|%2',MasterMaintTask.Status::"On Hold",MasterMaintTask.Status::Active);
                              MasterMaintTaskLookup.SetTableView(MasterMaintTask);
                              MasterMaintTaskLookup.LookupMode := true;
                              if MasterMaintTaskLookup.RunModal = ACTION::LookupOK then begin
                                if CurrPage.Editable then begin
                                  MasterMaintTaskLookup.GetRecord(MasterMaintTask);
                                  Text := MasterMaintTask.Code;
                                  exit(true);
                                end;
                              end;
                            end else begin
                              MasterMaintTaskLookup.Run;
                            end;
                            exit(false);
                        end;
                    }
                    field("Asset Description";"Asset Description")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        Importance = Additional;
                        QuickEntry = false;
                    }
                    field(Description;Description)
                    {
                        ApplicationArea = Basic,Suite;
                        StyleExpr = StyleTxt;
                    }
                    field("Category Code";"Category Code")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                    }
                    field("Trigger Method";"Trigger Method")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        StyleExpr = MasterStyleTxt;
                    }
                    field("Trigger Description";"Trigger Description")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        QuickEntry = false;
                        StyleExpr = MasterStyleTxt;
                    }
                    field("Master Task Description";"Master Task Description")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        Visible = false;
                    }
                    field("Created Date-Time";"Created Date-Time")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    field("Created By";"Created By")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    field("Last Modified Date-Time";"Last Modified Date-Time")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    field("Last Modified By";"Last Modified By")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                }
                group(Control1101214051)
                {
                    ShowCaption = false;
                    field("Effective Date";"Effective Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ShowMandatory = true;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Expiry Date";"Expiry Date")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Last Completion Date";"Last Completion Date")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                    }
                    field("Expected Duration (Hours)";"Expected Duration (Hours)")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    field("Expected Downtime (Hours)";"Expected Downtime (Hours)")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                    }
                    field("Budgeted Cost Amount";"Budgeted Cost Amount")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("Budgeted Hours";"Budgeted Hours")
                    {
                        ApplicationArea = Basic,Suite;
                    }
                    field("No. of Attachments";"No. of Attachments")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;

                        trigger OnDrillDown()
                        begin
                            ShowDocumentAttachments;
                        end;
                    }
                    field("Master Task Status";"Master Task Status")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        Importance = Promoted;
                        StyleExpr = MasterStyleTxt;
                    }
                    field(Blocked;Blocked)
                    {
                        ApplicationArea = Basic,Suite;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                }
            }
            group("Usage Monitor")
            {
                Caption = 'Usage Monitor';
                Visible = EnableUsageMonitor;
                field("Usage Monitor Code";"Usage Monitor Code")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = EnableUsageMonitor;
                    Importance = Promoted;
                    Visible = EnableUsageMonitor;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Current Usage Value";"Current Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    Visible = EnableUsageMonitor;
                }
                field("Last Completion Usage Value";"Last Completion Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Importance = Promoted;
                    Visible = EnableUsageMonitor;
                }
            }
            group("Calendar Schedule")
            {
                Editable = IsCalendarTrigger;
                Visible = IsCalendarTrigger;
                field(CalendarScheduleLeadTimeDays;"Schedule Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = IsCalendarTrigger;
                    HideValue = NOT IsCalendarTrigger;
                    Visible = IsCalendarTrigger;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(CalendarRecurTriggerCalcMethod;"Recurring Trigger Calc. Method")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = IsCalendarTrigger;
                }
                field(CalendarLastScheduledDate;"Last Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    HideValue = NOT IsCalendarTrigger;
                    Visible = IsCalendarTrigger;
                }
            }
            group("Fixed Date Schedule")
            {
                Enabled = IsFixedDateTrigger;
                Visible = IsFixedDateTrigger;
                field(FixedDateScheduleLeadTimeDays;"Schedule Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = IsFixedDateTrigger;
                    HideValue = NOT IsFixedDateTrigger;
                    Visible = IsFixedDateTrigger;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("FixedDateLastScheduled Date";"Last Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    HideValue = NOT IsFixedDateTrigger;
                    Visible = IsFixedDateTrigger;
                }
                group("Fixed Date Range")
                {
                    Visible = IsFixedDateTrigger;
                    field("No. of Fixed Dates";"No. of Fixed Dates")
                    {
                        ApplicationArea = Basic,Suite;
                        HideValue = NOT IsFixedDateTrigger;
                        Visible = IsFixedDateTrigger;

                        trigger OnDrillDown()
                        begin
                            ShowFixedDates;
                        end;
                    }
                    field("First Fixed Date";"First Fixed Date")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        Visible = IsFixedDateTrigger;
                    }
                    field("Last Fixed Date";"Last Fixed Date")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        Visible = IsFixedDateTrigger;
                    }
                }
            }
            group("Recurring Usage Schedule")
            {
                Visible = IsRecurringUsageTrigger;
                field(RecurUsageScheduleLeadTimeDays;"Schedule Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = IsRecurringUsageTrigger;
                    HideValue = NOT IsRecurringUsageTrigger;
                    Visible = IsRecurringUsageTrigger;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(RecurUsageScheduleAheadTolerance;"Usage Schedule-Ahead Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = IsRecurringUsageTrigger;
                    Enabled = IsRecurringUsageTrigger;
                    Visible = IsRecurringUsageTrigger;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(RecurUsageRecurTriggerCalcMethod;"Recurring Trigger Calc. Method")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = IsRecurringUsageTrigger;
                }
                field(RecurLastScheduledUsageValue;"Last Scheduled Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    HideValue = NOT IsRecurringUsageTrigger;
                    Visible = IsRecurringUsageTrigger;
                }
                field(RecurLastCompletionUsageValue;"Last Completion Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = IsRecurringUsageTrigger;
                }
                group("Recurring Usage Range")
                {
                    Visible = IsRecurringUsageTrigger;
                    field("Starting Value (Recurr. Usage)";"Starting Value (Recurr. Usage)")
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = IsRecurringUsageTrigger;
                        Enabled = IsRecurringUsageTrigger;
                        ShowMandatory = IsRecurringUsageTrigger;
                        Visible = IsRecurringUsageTrigger;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                    field("Expiry Value (Recurr. Usage)";"Expiry Value (Recurr. Usage)")
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = IsRecurringUsageTrigger;
                        Enabled = IsRecurringUsageTrigger;
                        Visible = IsRecurringUsageTrigger;

                        trigger OnValidate()
                        begin
                            CurrPage.Update;
                        end;
                    }
                }
            }
            group("Fixed Usage Schedule")
            {
                Visible = IsFixedUsageTrigger;
                field(FixedUsageScheduleLeadTimeDays;"Schedule Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = IsFixedUsageTrigger;
                    HideValue = NOT IsFixedUsageTrigger;
                    Importance = Promoted;
                    Visible = IsFixedUsageTrigger;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(FixedUsageScheduleAheadTolerance;"Usage Schedule-Ahead Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = IsFixedUsageTrigger;
                    Enabled = IsFixedUsageTrigger;
                    Visible = IsFixedUsageTrigger;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(FixedLastScheduledUsageValue;"Last Scheduled Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    HideValue = NOT IsFixedUsageTrigger;
                    Visible = IsFixedUsageTrigger;
                }
                field(FixedLastCompletionUsageValue;"Last Completion Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Visible = IsFixedUsageTrigger;
                }
                group("Fixed Usage Range")
                {
                    Visible = IsFixedUsageTrigger;
                    field("No. of Fixed Usage Values";"No. of Fixed Usage Values")
                    {
                        ApplicationArea = Basic,Suite;
                        HideValue = NOT IsFixedUsageTrigger;
                        Visible = IsFixedUsageTrigger;

                        trigger OnDrillDown()
                        begin
                            ShowFixedUsageValues;
                        end;
                    }
                    field("First Fixed Usage Value";"First Fixed Usage Value")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        Importance = Promoted;
                        Visible = IsFixedUsageTrigger;
                    }
                    field("Last Fixed Usage Value";"Last Fixed Usage Value")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        Importance = Promoted;
                        Visible = IsFixedUsageTrigger;
                    }
                }
            }
            part(FixedDateSubpage;"MCH Asset M.Task Fxd Date Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Task Code"=FIELD("Task Code");
                Visible = IsFixedDateTrigger;
            }
            part(FixedUsageSubpage;"MCH Asset M.Task Fxd Usage Sub")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Task Code"=FIELD("Task Code");
                Visible = IsFixedUsageTrigger;
            }
        }
        area(factboxes)
        {
            part(Control1101214047;"MCH Asset Maint. Task FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Task Code"=FIELD("Task Code");
            }
            part(Control1101214052;"MCH Asset MaintTask FCast Fact")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Task Code"=FIELD("Task Code");
            }
            part(Control1101214017;"MCH Master Maint.Task Dtl Fact")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = Code=FIELD("Task Code");
            }
            part(Control1101214049;"MCH Asset Usage Monitor FactBC")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Asset No."=FIELD("Asset No."),
                              "Monitor Code"=FIELD("Usage Monitor Code");
                Visible = HasUsageMonitor;
            }
            systempart(Control1101214002;Notes)
            {
                ApplicationArea = Basic,Suite;
            }
            systempart(Control1101214001;Links)
            {
                ApplicationArea = Basic,Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Action16004031)
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

    trigger OnAfterGetCurrRecord()
    begin
        EnableControls;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Effective Date" := WorkDate;
        EnableControls;
    end;

    trigger OnOpenPage()
    begin
        EnableControls;
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

    local procedure EnableControls()
    begin
        StyleTxt := GetStyleTxt;
        MasterStyleTxt :=GetMasterStyleTxt;

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

