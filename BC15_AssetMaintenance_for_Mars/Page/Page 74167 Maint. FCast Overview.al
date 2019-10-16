page 74167 "MCH Maint. FCast Overview"
{
    Caption = 'Maintenance Forecast Overview';
    DataCaptionExpression = ' ';
    DataCaptionFields = "Asset No.","Task Code","Starting Date";
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Setup,Line,Schedule';
    SaveValues = true;
    SourceTable = "MCH Maint. Schedule Buffer";
    SourceTableTemporary = true;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                Editable = false;
                group(SettingGroup)
                {
                    ShowCaption = false;
                    field(CalculationMode;CalculationMode)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Calculation Mode';
                        Importance = Promoted;
                        OptionCaption = 'Forecast,Schedule Simulation';
                    }
                    field(StartingDate;StartingDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Forecast Starting Date';
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            InitForecastParameters(false);
                            CurrPage.Update(false);
                        end;
                    }
                    field(EndingDate;EndingDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Forecast Ending Date';
                        Importance = Promoted;

                        trigger OnValidate()
                        begin
                            InitForecastParameters(false);
                            CurrPage.Update(false);
                        end;
                    }
                    field(TaskRecurrenceLimit;TaskRecurrenceLimit)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Maint. Task Recurrence Limit';
                        Importance = Promoted;
                        MinValue = 1;
                        ToolTip = 'Specifies the maximum number of times (days) that a Recurring task can occur within the period.';
                    }
                    group(Control1101214039)
                    {
                        ShowCaption = false;
                        Visible = ShowDefMaintLocation;
                        field(DefMaintLocationCode;DefMaintLocationCode)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Default Maint. Location Code';
                            Editable = ShowDefMaintLocation;
                            Enabled = ShowDefMaintLocation;
                            Importance = Promoted;
                            TableRelation = "MCH Maintenance Location";
                            ToolTip = 'Specifies a maintenance location that will used for assets that are setup without a Fixed Maint. Location Code.';
                        }
                    }
                }
                group(FilterGroup)
                {
                    ShowCaption = false;
                    field(ExcludeTasksOnPlanningWksh;ExcludeTasksOnPlanningWksh)
                    {
                        ApplicationArea = Basic,Suite;
                        BlankZero = true;
                        Caption = 'Exclude Tasks on Planning Worksheet';
                        Importance = Promoted;
                        ToolTip = 'Specifies if Maint. Tasks with one or more planning worksheet line shall be excluded in the calculation.';
                    }
                    field("Asset Filter";AssetFilter)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Asset Filter';
                        Editable = false;
                        Importance = Promoted;
                        MultiLine = true;
                        QuickEntry = false;

                        trigger OnAssistEdit()
                        begin
                            SelectAssetFilter;
                        end;
                    }
                    field("Maint. Task Filter";TaskFilter)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Maint. Task Filter';
                        Editable = false;
                        Importance = Promoted;
                        MultiLine = true;
                        QuickEntry = false;

                        trigger OnAssistEdit()
                        begin
                            SelectTaskFilter;
                        end;
                    }
                }
            }
            repeater("Repeater")
            {
                Caption = 'Repeater';
                Editable = false;
                FreezeColumn = "Starting Date";
                field("Asset No.";"Asset No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Task Code";"Task Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Description";"Asset Description")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Description 2";"Asset Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
                field("Work Order Type";"Work Order Type")
                {
                    ApplicationArea = Basic,Suite;
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
                field("Trigger Method";"Trigger Method")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Trigger Description";"Trigger Description")
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Completion Date";"Last Completion Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Scheduled Date";"Last Scheduled Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Lead Time (Days)";"Lead Time (Days)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Usage Monitor Code";"Usage Monitor Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Scheduled Usage";"Scheduled Usage")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Current Usage";"Current Usage")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Usage Tolerance";"Usage Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Actual Usage";"Last Actual Usage")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Last Scheduled Usage";"Last Scheduled Usage")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Asset Category Code";"Asset Category Code")
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
                }
                field("Recurr. Trigger Calc. Method";"Recurr. Trigger Calc. Method")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    Visible = false;
                }
            }
            group(Control1101214052)
            {
                Editable = false;
                Enabled = false;
                ShowCaption = false;
                Visible = false;
                field(AssetView;AssetView)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    HideValue = true;
                    ShowCaption = false;
                    Visible = false;
                }
                field(TaskView;TaskView)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    HideValue = true;
                    ShowCaption = false;
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
                action("Maint. Asset")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset';
                    Image = ServiceItem;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "MCH Maintenance Asset Card";
                    RunPageLink = "No."=FIELD("Asset No.");
                }
                action("Asset Maint. Task")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Asset Maint. Task';
                    Image = ServiceTasks;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    RunObject = Page "MCH Asset Maint. Task Card";
                    RunPageLink = "Asset No."=FIELD("Asset No."),
                                  "Task Code"=FIELD("Task Code");
                }
            }
        }
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(CalculateForecast)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Calculate Forecast';
                    Description = 'CalculateCalendar';
                    Image = CalculateSimulation;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    begin
                        CalcMaintForecast(true);
                    end;
                }
            }
            group(Setup)
            {
                Caption = 'Setup';
                action("Calculation Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Calculation Setup';
                    Ellipsis = true;
                    Image = Setup;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        RunSetup;
                    end;
                }
                action("Set Asset Filters")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Set Asset Filters';
                    Ellipsis = true;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        SelectAssetFilter;
                    end;
                }
                action("Clear Asset Filters")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Clear Asset Filters';
                    Ellipsis = true;
                    Image = ClearFilter;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ClearAssetFilter(true);
                    end;
                }
                action("Set Maint. Task Filters")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Set Maint. Task Filters';
                    Ellipsis = true;
                    Image = "Filter";
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        SelectTaskFilter;
                    end;
                }
                action("Clear Task Filters")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Clear Task Filters';
                    Ellipsis = true;
                    Image = ClearFilter;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ClearTaskFilter(true);
                    end;
                }
                action("Clear All Filters")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Clear All Filters';
                    Ellipsis = true;
                    Image = ClearFilter;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ClearAllFilters(true);
                    end;
                }
            }
            group(Schedule)
            {
                Caption = 'Schedule';
                Visible = NOT IsForecastMode;
                action("Calculate Scheduled Maintenance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Schedule Maintenance';
                    Ellipsis = true;
                    Enabled = NOT IsForecastMode;
                    Image = MachineCenterCalendar;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedOnly = true;
                    Visible = NOT IsForecastMode;

                    trigger OnAction()
                    var
                        MaintAsset: Record "MCH Maintenance Asset";
                        AssetMaintTask: Record "MCH Asset Maintenance Task";
                        CalcScheduledMaint: Report "MCH Calc Scheduled Maint.";
                    begin
                        if (AssetFilter <> '') then begin
                          MaintAsset.SetView(AssetView);
                          MaintAsset.SetCurrentKey("No.");
                        end;
                        if (TaskFilter <> '') then begin
                          AssetMaintTask.SetView(TaskView);
                          AssetMaintTask.SetCurrentKey("Asset No.","Task Code");
                        end;
                        CalcScheduledMaint.SetTableView(MaintAsset);
                        CalcScheduledMaint.SetTableView(AssetMaintTask);
                        CalcScheduledMaint.SetReportParameters(
                          StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode,ExcludeTasksOnPlanningWksh);

                        CalcScheduledMaint.RunModal;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        AMSetup.Get;
        ActualPageCaption := CurrPage.Caption;
        DeleteCalcResult;
        ShowDefMaintLocation := not AMSetup."Asset Fixed Maint. Loc. Mand.";

        InitForecastParameters(true);
        IsForecastMode := (CalculationMode = CalculationMode::Forecast);
        case true of
          CalledFromMaintAsset:
            begin
              ClearAllFilters(false);
              ShowForMaintAsset.SetRecFilter;
              AssetView := ShowForMaintAsset.GetView(false);
              AssetFilter := ShowForMaintAsset.GetFilters;
            end;
          CalledFromAssetMaintTask:
            begin
              ClearAllFilters(false);
              ShowForMaintAsset.SetRecFilter;
              AssetView := ShowForMaintAsset.GetView(false);
              AssetFilter := ShowForMaintAsset.GetFilters;

              ShowForAssetMaintTask.SetRecFilter;
              ShowForAssetMaintTask.SetRange("Asset No.");
              TaskView := ShowForAssetMaintTask.GetView(false);
              TaskFilter := ShowForAssetMaintTask.GetFilters;
            end;
        end;
        CalledFromMaintAsset := false;
        CalledFromAssetMaintTask := false;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        ShowForMaintAsset: Record "MCH Maintenance Asset";
        ShowForAssetMaintTask: Record "MCH Asset Maintenance Task";
        CalculationMode: Option Forecast,"Schedule Simulation";
        StartingDate: Date;
        EndingDate: Date;
        TaskRecurrenceLimit: Integer;
        DefMaintLocationCode: Code[20];
        ExcludeTasksOnPlanningWksh: Boolean;
        [InDataSet]
        AssetFilter: Text;
        AssetView: Text;
        [InDataSet]
        TaskFilter: Text;
        TaskView: Text;
        ClearAssetFilterQst: Label 'Do you want to Clear the Asset filters ?';
        ClearTaskFilterQst: Label 'Do you want to Clear the Task filters ?';
        ActualPageCaption: Text;
        [InDataSet]
        ShowDefMaintLocation: Boolean;
        [InDataSet]
        IsForecastMode: Boolean;
        CalledFromMaintAsset: Boolean;
        CalledFromAssetMaintTask: Boolean;
        ClearAllFilterQst: Label 'Do you want to Clear all filters ?';

    local procedure SelectAssetFilter() OK: Boolean
    var
        MaintAsset: Record "MCH Maintenance Asset";
        TempField: Record "Field" temporary;
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
        RecRef: RecordRef;
        TableFilterCaption: Text;
    begin
        TableFilterCaption := MaintAsset.TableCaption;
        MaintAsset.SetView(AssetView);
        RecRef.GetTable(MaintAsset);
        PageFilterHelper.BufferDefaultFilterPageField(TempField,RecRef.Number,MaintAsset.FieldNo("No."));
        PageFilterHelper.BufferDefaultFilterPageField(TempField,RecRef.Number,MaintAsset.FieldNo("Category Code"));
        PageFilterHelper.BufferDefaultFilterPageField(TempField,RecRef.Number,MaintAsset.FieldNo("Responsibility Group Code"));
        PageFilterHelper.BufferDefaultFilterPageField(TempField,RecRef.Number,MaintAsset.FieldNo("Fixed Maint. Location Code"));

        if PageFilterHelper.RunFilterPage(RecRef,TempField,TableFilterCaption) then begin
          AssetView := RecRef.GetView(false);
          AssetFilter := RecRef.GetFilters;
          DeleteCalcResult;
          exit(true);
        end else
          exit(false);
    end;

    local procedure SelectTaskFilter() OK: Boolean
    var
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        TempField: Record "Field" temporary;
        PageFilterHelper: Codeunit "MCH AM Page Filter Helper";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        TableFilterCaption: Text;
    begin
        TableFilterCaption := AssetMaintTask.TableCaption;
        AssetMaintTask.SetView(TaskView);
        RecRef.GetTable(AssetMaintTask);
        PageFilterHelper.BufferDefaultFilterPageField(TempField,RecRef.Number,AssetMaintTask.FieldNo("Task Code"));
        PageFilterHelper.BufferDefaultFilterPageField(TempField,RecRef.Number,AssetMaintTask.FieldNo("Category Code"));
        PageFilterHelper.BufferDefaultFilterPageField(TempField,RecRef.Number,AssetMaintTask.FieldNo("Trigger Method"));
        PageFilterHelper.BufferDefaultFilterPageField(TempField,RecRef.Number,AssetMaintTask.FieldNo("Usage Monitor Code"));

        if PageFilterHelper.RunFilterPage(RecRef,TempField,TableFilterCaption) then begin
          FieldRef := RecRef.Field(AssetMaintTask.FieldNo("Asset No."));
          FieldRef.SetRange;
          TaskView := RecRef.GetView(false);
          TaskFilter := RecRef.GetFilters;
          DeleteCalcResult;
          exit(true);
        end else
          exit(false);
    end;

    local procedure ClearAssetFilter(AskConfirm: Boolean)
    begin
        if (AssetView = '') then
          exit;
        if AskConfirm then begin
          if not Confirm(ClearAssetFilterQst,false) then
            exit;
        end;
        AssetFilter := '';
        AssetView := '';
        DeleteCalcResult;
    end;

    local procedure ClearTaskFilter(AskConfirm: Boolean)
    begin
        if (TaskView = '') then
          exit;
        if AskConfirm then begin
          if not Confirm(ClearTaskFilterQst,false) then
            exit;
        end;
        TaskFilter := '';
        TaskView := '';
        DeleteCalcResult;
    end;

    local procedure ClearAllFilters(AskConfirm: Boolean)
    begin
        if ((TaskView = '') and (AssetView = '')) then
          exit;
        if AskConfirm then begin
          if not Confirm(ClearAllFilterQst,false) then
            exit;
        end;
        ClearAssetFilter(false);
        ClearTaskFilter(false);
    end;

    local procedure InitForecastParameters(ResetToWorkdate: Boolean)
    var
        AMScheduleMgt: Codeunit "MCH AM Schedule Mgt.";
    begin
        AMScheduleMgt.InitialiseCalcParameters(
          (CalculationMode = CalculationMode::"Schedule Simulation"),ResetToWorkdate,
          StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode);

        CurrPage.Caption(StrSubstNo('%1  %2 - %3',ActualPageCaption,StartingDate,EndingDate));
    end;


    procedure InitPageFromMaintAsset(MaintAsset: Record "MCH Maintenance Asset")
    begin
        if MaintAsset.Find then begin
          CalledFromMaintAsset := true;
          ShowForMaintAsset := MaintAsset;
        end;
    end;


    procedure InitPageFromAssetMaintTask(AssetMaintTask: Record "MCH Asset Maintenance Task")
    begin
        if AssetMaintTask.Find then begin
          CalledFromAssetMaintTask := true;
          ShowForAssetMaintTask := AssetMaintTask;
          ShowForMaintAsset.Get(AssetMaintTask."Asset No.");
        end;
    end;

    local procedure RunSetup()
    var
        ParamSetup: Page "MCH Sched-FCast Param. Setup";
    begin
        ParamSetup.SetValues(
          false,CalculationMode,StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode,ExcludeTasksOnPlanningWksh);
        if ParamSetup.RunModal = ACTION::OK then begin
          ParamSetup.GetValues(CalculationMode,StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode,ExcludeTasksOnPlanningWksh);
          DeleteCalcResult;
          IsForecastMode := (CalculationMode = CalculationMode::Forecast);
          CurrPage.Update(false);
        end;
    end;

    local procedure DeleteCalcResult()
    begin
        Reset;
        if not IsEmpty then
          DeleteAll;
    end;

    local procedure CalcMaintForecast(ShowDialog: Boolean)
    var
        MaintAsset: Record "MCH Maintenance Asset";
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        AMScheduleMgt: Codeunit "MCH AM Schedule Mgt.";
        Continue: Boolean;
        Win: Dialog;
        CalcDialogText: Label 'Calculating maintenance forecast...\\Asset No. #1################\Task Code #2################';
        NoForecastMsg: Label 'No Maintenance Tasks found for the %1...';
    begin
        DeleteCalcResult;
        if (AssetFilter <> '') then begin
          MaintAsset.SetView(AssetView);
          MaintAsset.SetCurrentKey("No.");
        end;
        MaintAsset.SetSecurityFilterOnResponsibilityGroup(99);
        MaintAsset.SetRange(Blocked,false);

        if (TaskFilter <> '') then begin
          AssetMaintTask.SetView(TaskView);
          AssetMaintTask.SetCurrentKey("Asset No.","Task Code");
        end;
        AssetMaintTask.SetRange(Blocked,false);
        AssetMaintTask.FilterGroup(99);
        AssetMaintTask.SetFilter("Trigger Method",'<>%1',AssetMaintTask."Trigger Method"::Manual);
        AssetMaintTask.FilterGroup(99);

        AMScheduleMgt.ClearScheduleBuffer;
        AMScheduleMgt.SetCustomCalcParameters(
          StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode,ExcludeTasksOnPlanningWksh);
        AMScheduleMgt.SetDoNotClearBufferPerAssetTask(true);

        if MaintAsset.FindSet then begin
          if ShowDialog then
            Win.Open(CalcDialogText);
          repeat
            if ShowDialog then
              Win.Update(1,MaintAsset."No.");
            AssetMaintTask.SetRange("Asset No.",MaintAsset."No.");
            if AssetMaintTask.FindSet then begin
              repeat
                if ShowDialog then
                  Win.Update(2,AssetMaintTask."Task Code");

                case CalculationMode of
                  CalculationMode::Forecast:
                    AMScheduleMgt.CalcMaintTaskForForecast(AssetMaintTask);
                  CalculationMode::"Schedule Simulation":
                    AMScheduleMgt.CalcMaintTaskForSchedule(AssetMaintTask);
                end;
              until AssetMaintTask.Next = 0;
            end;
          until MaintAsset.Next = 0;
          if ShowDialog then
            Win.Close;
        end;

        AMScheduleMgt.ShareResultScheduleBuffer(Rec);
        if not FindFirst then
          if ShowDialog then
            Message(NoForecastMsg,CalculationMode);
    end;
}

