page 74033 "MCH Asset - Maint. Task Sub"
{
    Caption = 'Maintenance Tasks';
    CardPageID = "MCH Asset Maint. Task Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "MCH Asset Maintenance Task";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                FreezeColumn = "Task Code";
                ShowCaption = false;
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
                }
                field("Budgeted Hours";"Budgeted Hours")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("No. of Attachments";"No. of Attachments")
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
    }

    actions
    {
        area(processing)
        {
            group(Task)
            {
                Caption = 'Task';
                Image = Setup;
                action(PageFixedDates)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Fixed Maint. Dates';
                    Image = Calendar;
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
                    Visible = IsFixedUsageTrigger;

                    trigger OnAction()
                    begin
                        ShowFixedUsageValues;
                    end;
                }
                action(MasterMaintTask)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Master Maint. Task';
                    Image = Task;

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
                    RunObject = Page "MCH Maint. Task Budget Lines";
                    RunPageLink = "Task Code"=FIELD("Task Code");
                }
                action(UsageMonitor)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Monitor';
                    Enabled = HasUsageMonitor;
                    Image = Capacity;

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

                    trigger OnAction()
                    begin
                        ShowDocumentAttachments;
                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action(AMLedgerEntryStatistics)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "MCH Maint. Asset Entry Stat.";
                    RunPageLink = "No."=FIELD("Asset No."),
                                  "Maint. Task Filter"=FIELD("Task Code");
                }
                action(AMLedgerEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'AM Ledger E&ntries';
                    Image = MaintenanceLedgerEntries;
                    RunObject = Page "MCH AM Ledger Entries";
                    RunPageLink = "Asset No."=FIELD("Asset No."),
                                  "Maint. Task Code"=FIELD("Task Code");
                    RunPageView = SORTING("Asset No.","Maint. Task Code","Posting Date");
                }
                action(UsageMonitorEntries)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Usage Monitor Entries';
                    Enabled = HasUsageMonitor;
                    Image = CapacityLedger;

                    trigger OnAction()
                    begin
                        ShowUsageMonitorEntries;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnableControls;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
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

