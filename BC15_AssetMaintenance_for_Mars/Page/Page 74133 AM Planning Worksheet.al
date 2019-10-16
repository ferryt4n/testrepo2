page 74133 "MCH AM Planning Worksheet"
{
    ApplicationArea = Basic,Suite;
    AutoSplitKey = true;
    Caption = 'Maintenance Planning Worksheet';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = Worksheet;
    PromotedActionCategories = 'New,Process,Report,Line,Functions';
    RefreshOnActivate = true;
    SaveValues = true;
    SourceTable = "MCH AM Planning Wksh. Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentWkshName;CurrentWkshName)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    AMJnlMgt.PlanningWkshLookupName(CurrentWkshName,Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    AMJnlMgt.PlanningWkshCheckName(CurrentWkshName,Rec);
                    CurrPage.SaveRecord;
                    AMJnlMgt.PlanningWkshSetName(CurrentWkshName,Rec);
                    CurrPage.Update(false);
                end;
            }
            repeater(Control1)
            {
                FreezeColumn = "Asset No.";
                ShowCaption = false;
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Scheduled Date";"Task Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
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
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field("Task Description";"Task Description")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Description 2";"Task Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Task Trigger Method";"Task Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Trigger Description";"Trigger Description")
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
                field("Recurr. Trigger Calc. Method";"Recurr. Trigger Calc. Method")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT IsRecurringTrigger;
                    Visible = false;
                }
                field("Usage Monitor Code";"Usage Monitor Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Scheduled Usage Value";"Task Scheduled Usage Value")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT EnableUsageMonitor;
                }
                field("Current Usage";"Current Usage")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT EnableUsageMonitor;
                }
                field("Usage Tolerance";"Usage Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT EnableUsageMonitor;
                    Visible = false;
                }
                field("Last Scheduled Usage";"Last Scheduled Usage")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT EnableUsageMonitor;
                }
                field("Last Completion Usage";"Last Completion Usage")
                {
                    ApplicationArea = Basic,Suite;
                    HideValue = NOT EnableUsageMonitor;
                }
                field("Lead Time (Days)";"Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Budgeted Cost Amount";"Budgeted Cost Amount")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    QuickEntry = false;
                }
                field("Budgeted Hours";"Budgeted Hours")
                {
                    ApplicationArea = Basic,Suite;
                    BlankZero = true;
                    QuickEntry = false;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Work Order Type";"Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Maint. Location Code";"Maint. Location Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Responsibility Group Code";"Responsibility Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                }
                field("Asset Category Code";"Asset Category Code")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Last Modified By";"Last Modified By")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Last Modified Date-Time";"Last Modified Date-Time")
                {
                    ApplicationArea = Basic,Suite;
                    QuickEntry = false;
                    Visible = false;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = 'Line';
                action(ShowAsset)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maint. Asset';
                    Image = ServiceItem;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    RunObject = Page "MCH Maintenance Asset Card";
                    RunPageLink = "No."=FIELD("Asset No.");
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    var
                        MaintAsset: Record "MCH Maintenance Asset";
                    begin
                        if MaintAsset.Get("Asset No.") then
                          MaintAsset.ShowCard;
                    end;
                }
                action(ShowMaintTask)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Maint. Task';
                    Image = ServiceTasks;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        AssetMaintTask: Record "MCH Asset Maintenance Task";
                    begin
                        if AssetMaintTask.Get("Asset No.","Task Code") then
                          AssetMaintTask.ShowCard;
                    end;
                }
            }
        }
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(CalcScheduledMaintenance)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Calc. Scheduled Maintenance';
                    Ellipsis = true;
                    Image = MachineCenterCalendar;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        CalcScheduledMaint: Report "MCH Calc Scheduled Maint.";
                    begin
                        CalcScheduledMaint.SetPlanningWorksheet(Rec);
                        CalcScheduledMaint.RunModal;
                    end;
                }
                action(CreateWorkOrders)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Create Work Orders';
                    Ellipsis = true;
                    Image = CreateDocument;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        CreateWorkOrdersPlanning: Report "MCH Plan. Wksh. - Create WOs";
                    begin
                        CreateWorkOrdersPlanning.SetWkshLine(Rec);
                        CreateWorkOrdersPlanning.RunModal;
                        CurrentWkshName := GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
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
    var
        JnlSelected: Boolean;
    begin
        if IsOpenedFromBatch then begin
          CurrentWkshName := "Journal Batch Name";
          AMJnlMgt.PlanningWkshOpenJnl(CurrentWkshName,Rec);
          exit;
        end;
        AMJnlMgt.PlanningWkshTemplateSelection(PAGE::"MCH AM Planning Worksheet",0,Rec,JnlSelected);
        if not JnlSelected then
          Error('');
        AMJnlMgt.PlanningWkshOpenJnl(CurrentWkshName,Rec);
        MaintUser.Get(UserId);
    end;

    var
        AMJnlMgt: Codeunit "MCH AM Journal Mgt.";
        MaintUser: Record "MCH Asset Maintenance User";
        CurrentWkshName: Code[10];
        [InDataSet]
        IsCalendarTrigger: Boolean;
        [InDataSet]
        IsFixedDateTrigger: Boolean;
        [InDataSet]
        IsRecurringTrigger: Boolean;
        [InDataSet]
        IsFixedUsageTrigger: Boolean;
        [InDataSet]
        EnableUsageMonitor: Boolean;

    local procedure EnableControls()
    begin
        IsCalendarTrigger := false;
        IsRecurringTrigger := false;
        IsFixedDateTrigger := false;
        IsFixedUsageTrigger := false;
        EnableUsageMonitor := false;

        case "Task Trigger Method" of
          "Task Trigger Method"::Manual:
            begin
              EnableUsageMonitor := ("Usage Monitor Code" <> '');
            end;
          "Task Trigger Method"::"Calendar (Recurring)":
            begin
              IsRecurringTrigger := true;
            end;
          "Task Trigger Method"::"Usage (Recurring)":
            begin
              IsRecurringTrigger := true;
              EnableUsageMonitor := true;
            end;
          "Task Trigger Method"::"Fixed Date":
            begin
              IsFixedDateTrigger := true;
            end;
          "Task Trigger Method"::"Fixed Usage":
            begin
              IsFixedUsageTrigger :=true;
              EnableUsageMonitor := true;
            end;
        end;
    end;
}

