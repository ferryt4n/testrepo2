report 74042 "MCH Calc Scheduled Maint."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Report/MCHCalcScheduledMaint.rdlc';
    AccessByPermission = TableData "MCH Work Order Header"=I;
    ApplicationArea = Basic,Suite;
    Caption = 'Calculate Scheduled Maintenance';
    UsageCategory = Tasks;

    dataset
    {
        dataitem(MaintAsset;"MCH Maintenance Asset")
        {
            DataItemTableView = SORTING("No.") WHERE(Blocked=CONST(false));
            RequestFilterFields = "No.","Category Code","Fixed Maint. Location Code","Responsibility Group Code";
            dataitem(AssetMaintTask;"MCH Asset Maintenance Task")
            {
                DataItemLink = "Asset No."=FIELD("No.");
                DataItemTableView = SORTING("Asset No.","Task Code") WHERE(Blocked=CONST(false),"Trigger Method"=FILTER(<>Manual));
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Task Code","Trigger Method","Usage Monitor Code";

                trigger OnAfterGetRecord()
                begin
                    AMScheduleMgt.CalcMaintTaskForSchedule(AssetMaintTask);
                end;

                trigger OnPostDataItem()
                begin
                    if GuiAllowed then
                      Window.Update(1,MaintAssetCounter);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                MaintAssetCounter := MaintAssetCounter + 1;
                if GuiAllowed then
                  Window.Update(1,"No.");
            end;

            trigger OnPreDataItem()
            begin
                SetSecurityFilterOnResponsibilityGroup(99);
            end;
        }
        dataitem(CompleteSchedule;"Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number=CONST(1));

            trigger OnAfterGetRecord()
            begin
                AMScheduleMgt.ShareResultScheduleBuffer(ScheduleBuffer);
                GroupBuffer;
                case ReportActionType of
                  ReportActionType::"Test - Print/Preview only": ;
                  ReportActionType::"Create Work Orders":
                    CreateWorkOrders;
                  ReportActionType::"Copy to Planning Worksheet":
                    CreatePlanningWorksheet;
                end;
                if GuiAllowed then
                  Window.Close;
            end;
        }
        dataitem(Buffer;"MCH Maint. Schedule Buffer")
        {
            DataItemTableView = SORTING("Entry No.");
            UseTemporary = true;
            column(ReportCaptionLbl;StrSubstNo(ReportCaptionLbl,CaptionText))
            {
            }
            column(CompanyName;COMPANYPROPERTY.DisplayName)
            {
            }
            column(ReportPageNoCaption;ReportPageNoCaption)
            {
            }
            column(PlanningStartingDate;StartingDate)
            {
            }
            column(PlanningStartingDateLbl;PlanningStartingDateLbl)
            {
            }
            column(PlanningEndingDate;EndingDate)
            {
            }
            column(PlanningEndingDateLbl;PlanningEndingDateLbl)
            {
            }
            column(CaptionFilter_PlanningWksh;StrSubstNo(PlanningWkshFilterCaption,PlanningWkshFilter))
            {
            }
            column(PlanningWkshFilter;PlanningWkshFilter)
            {
            }
            column(CaptionFilter_MaintAsset;MaintAsset.TableCaption + ': ' + MaintAssetFilter)
            {
            }
            column(MaintAssetFilter;MaintAssetFilter)
            {
            }
            column(CaptionFilter_AssetMaintTask;AssetMaintTask.TableCaption + ': ' + AssetMaintTaskFilter)
            {
            }
            column(AssetMaintTaskFilter;AssetMaintTaskFilter)
            {
            }
            column(Schedule_AssetNo;"Asset No.")
            {
            }
            column(Schedule_AssetNoLbl;FieldCaption("Asset No."))
            {
            }
            column(Schedule_AssetDescription;"Asset Description")
            {
            }
            column(Schedule_AssetDescriptionLbl;FieldCaption("Asset Description"))
            {
            }
            column(Schedule_TaskCode;"Task Code")
            {
            }
            column(Schedule_TaskCodeLbl;FieldCaption("Task Code"))
            {
            }
            column(Schedule_TaskDescription;"Task Description")
            {
            }
            column(Schedule_TaskDescriptionLbl;FieldCaption("Task Description"))
            {
            }
            column(Schedule_Priority;Format(Priority))
            {
            }
            column(Schedule_PriorityLbl;FieldCaption(Priority))
            {
            }
            column(Schedule_WorkOrderType;"Work Order Type")
            {
            }
            column(Schedule_WorkOrderTypeLbl;FieldCaption("Work Order Type"))
            {
            }
            column(Schedule_TriggerMethod;"Trigger Method")
            {
            }
            column(Schedule_TriggerMethodLbl;FieldCaption("Trigger Method"))
            {
            }
            column(Schedule_TriggerDescription;"Trigger Description")
            {
            }
            column(Schedule_TriggerDescriptionLbl;FieldCaption("Trigger Description"))
            {
            }
            column(Schedule_StartingDate;Format("Starting Date"))
            {
            }
            column(Schedule_StartingDateLbl;FieldCaption("Starting Date"))
            {
            }
            column(Schedule_LastCompletionDate;Format("Last Completion Date"))
            {
            }
            column(Schedule_LastCompletionDateLbl;FieldCaption("Last Completion Date"))
            {
            }
            column(Schedule_LastScheduledDate;Format("Last Scheduled Date"))
            {
            }
            column(Schedule_LastScheduledDateLbl;FieldCaption("Last Scheduled Date"))
            {
            }
            column(Schedule_UsageMonitorCode;"Usage Monitor Code")
            {
            }
            column(Schedule_UsageMonitorCodeLbl;FieldCaption("Usage Monitor Code"))
            {
            }
            column(Schedule_CurrentUsage;QtyToTxt("Current Usage","Usage Monitor Code"=''))
            {
            }
            column(Schedule_CurrentUsageLbl;FieldCaption("Current Usage"))
            {
            }
            column(Schedule_ScheduledUsage;QtyToTxt(Buffer."Scheduled Usage","Usage Monitor Code"=''))
            {
            }
            column(Schedule_ScheduledUsageLbl;FieldCaption("Scheduled Usage"))
            {
            }
            column(Schedule_LastScheduledUsage;QtyToTxt("Last Scheduled Usage","Usage Monitor Code"=''))
            {
            }
            column(Schedule_LastScheduledUsageLbl;FieldCaption("Last Scheduled Usage"))
            {
            }
            column(Schedule_LastActualUsage;QtyToTxt("Last Actual Usage","Usage Monitor Code"=''))
            {
            }
            column(Schedule_LastActualUsageLbl;FieldCaption("Last Actual Usage"))
            {
            }
            column(Schedule_MaintLocationCode;"Maint. Location Code")
            {
            }
            column(Schedule_MaintLocationCodeLbl;FieldCaption("Maint. Location Code"))
            {
            }
            column(Schedule_ResponsibilityGroupCode;"Responsibility Group Code")
            {
            }
            column(Schedule_ResponsibilityGroupCodeLbl;FieldCaption("Responsibility Group Code"))
            {
            }
            column(Schedule_WorkOrderNo;"Work Order No.")
            {
            }
            column(Schedule_WorkOrderNoLbl;WorkOrderNoCaptionText)
            {
            }
            column(Schedule_EntryNo;Buffer."Entry No.")
            {
            }

            trigger OnPreDataItem()
            begin
                if Buffer.IsEmpty then begin
                  if GuiAllowed then begin
                    Message(NothingToScheduleMsg);
                  end;
                  CurrReport.Quit;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ReportActionType;ReportActionType)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Action';
                        Importance = Promoted;
                        OptionCaption = 'Test - Print/Preview only,Create Work Orders,Copy to Planning Worksheet';

                        trigger OnValidate()
                        begin
                            SetRequestPageFieldsEnable;
                        end;
                    }
                    group(Schedule)
                    {
                        Caption = 'Schedule';
                        field(StartingDate;StartingDate)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Starting Date';
                            Importance = Promoted;
                            ShowMandatory = true;
                        }
                        field(EndingDate;EndingDate)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Ending Date';
                            Importance = Promoted;
                            ShowMandatory = true;
                        }
                        field(TaskRecurrenceLimit;TaskRecurrenceLimit)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Maint. Task Recurrence Limit';
                            Importance = Promoted;
                            MinValue = 1;
                            ToolTip = 'Specifies the maximum number of times (days) that a Recurring task can occur within the period.';
                        }
                        group(Control1101214006)
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
                        field(ExcludeTasksOnPlanningWksh;ExcludeTasksOnPlanningWksh)
                        {
                            ApplicationArea = Basic,Suite;
                            BlankZero = true;
                            Caption = 'Exclude Tasks on Planning Wksh.';
                            Importance = Promoted;
                            ToolTip = 'Specifies if Maint. Tasks with one or more planning worksheet line shall be excluded in the calculation.';
                        }
                        field(ResetToDefaultText;ResetToDefaultText)
                        {
                            ApplicationArea = Basic,Suite;
                            Editable = false;
                            QuickEntry = false;
                            ShowCaption = false;

                            trigger OnDrillDown()
                            begin
                                StartingDate := 0D;
                                TaskRecurrenceLimit := 0;
                                AMScheduleMgt.InitialiseCalcParameters(
                                  true,true,
                                  StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode);
                            end;
                        }
                    }
                    group("New Work Order")
                    {
                        Caption = 'New Work Order';
                        Editable = ShowWorkOrderOptions;
                        Visible = ShowWorkOrderOptions;
                        field(NewOrderStatus;NewOrderStatus)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Status';
                        }
                        group(Control1101214003)
                        {
                            ShowCaption = false;
                            Visible = EnableSingleLineOnly;
                            field(SingleLineOnlyDefWODescription;SingleLineOnlyDefWODescription)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Set Work Order Description';
                                Editable = EnableSingleLineOnly;
                                Visible = EnableSingleLineOnly;
                            }
                        }
                        group(Control1101214004)
                        {
                            ShowCaption = false;
                            Visible = EnableOneAssetOnly;
                            field(OneAssetOnlyDefWODescription;OneAssetOnlyDefWODescription)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Set Work Order Description';
                                Editable = EnableOneAssetOnly;
                                Visible = EnableOneAssetOnly;
                            }
                        }
                        group(Control1101214005)
                        {
                            ShowCaption = false;
                            Visible = EnableMultiLine;
                            field(MultiLineDefWODescription;MultiLineDefWODescription)
                            {
                                ApplicationArea = Basic,Suite;
                                Caption = 'Set Work Order Description';
                                Editable = EnableMultiLine;
                                Visible = EnableMultiLine;
                            }
                        }
                        field(FixedWorkOrderDescription;FixedWorkOrderDescription)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Fixed Text - Description';
                        }
                    }
                    group("Planning Worksheet")
                    {
                        Caption = 'Planning Worksheet';
                        Editable = ShowPlanningWkshOptions AND NOT IsCalledFromPlanningWorksheet;
                        Visible = ShowPlanningWkshOptions;
                        field(PlanningWkshTemplateName;PlanningWkshLine."Worksheet Template Name")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Template';
                            Editable = NOT IsCalledFromPlanningWorksheet;
                            QuickEntry = false;
                            ShowMandatory = true;
                            TableRelation = "MCH AM Planning Wksh. Templ.";
                        }
                        field(PlanningWkshBatchName;PlanningWkshLine."Journal Batch Name")
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Name';
                            Editable = NOT IsCalledFromPlanningWorksheet;
                            ShowMandatory = true;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                PlanningWkshLine.TestField("Worksheet Template Name");
                                PlanningWkshTemplate.Get(PlanningWkshLine."Worksheet Template Name");
                                PlanningWkshBatch.SetRange("Worksheet Template Name",PlanningWkshLine."Worksheet Template Name");
                                PlanningWkshBatch."Worksheet Template Name" := PlanningWkshLine."Worksheet Template Name";
                                PlanningWkshBatch.Name := PlanningWkshLine."Journal Batch Name";
                                if PAGE.RunModal(0,PlanningWkshBatch) = ACTION::LookupOK then begin
                                  PlanningWkshLine."Journal Batch Name" := PlanningWkshBatch.Name;
                                end;
                            end;

                            trigger OnValidate()
                            begin
                                if PlanningWkshLine."Journal Batch Name" <> '' then begin
                                  PlanningWkshLine.TestField("Worksheet Template Name");
                                  PlanningWkshBatch.Get(PlanningWkshLine."Worksheet Template Name",PlanningWkshLine."Journal Batch Name");
                                end;
                            end;
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            SetRequestPageFieldsEnable;
        end;

        trigger OnQueryClosePage(CloseAction: Action): Boolean
        begin
            if CloseAction <> ACTION::Cancel then begin
              if not CheckValues then begin
                Message(GetLastErrorText);
                exit(false);
              end;
            end;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        AMSetup.Get;
        ShowDefMaintLocation := not AMSetup."Asset Fixed Maint. Loc. Mand.";

        if GuiAllowed then begin
          ReportActionType := ReportActionType::"Test - Print/Preview only";
          AMScheduleMgt.InitialiseCalcParameters(
            true,true,StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode);
        end;
    end;

    trigger OnPostReport()
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if ScheduleCreated then begin
          case ReportActionType of
            ReportActionType::"Copy to Planning Worksheet":
              if not IsCalledFromPlanningWorksheet then begin
                PlanningWkshTemplate.Get(PlanningWkshBatch."Worksheet Template Name");
                PlanningWkshLine.FilterGroup(2);
                PlanningWkshLine.SetRange("Worksheet Template Name",PlanningWkshLine."Worksheet Template Name");
                PlanningWkshLine.SetRange("Journal Batch Name",PlanningWkshLine."Journal Batch Name");
                PlanningWkshLine.FilterGroup(2);
                if PlanningWkshLine.FindLast then ;
                PAGE.Run(PlanningWkshTemplate."Page ID",PlanningWkshLine);
              end;
            ReportActionType::"Create Work Orders":
              begin
                case NewOrderStatus of
                  NewOrderStatus::Planned:
                    WorkOrder.SetRange(Status,WorkOrder.Status::Planned);
                  NewOrderStatus::Released:
                    WorkOrder.SetRange(Status,WorkOrder.Status::Released);
                end;
                WorkOrder.SetRange("No.",FirstWONo,LastWONo);
                case WorkOrder.Count of
                  0: ;
                  1:
                    begin
                      WorkOrder.FindFirst;
                      WorkOrder.ShowCard;
                    end;
                  else begin
                    case NewOrderStatus of
                      NewOrderStatus::Planned:
                        PAGE.Run(PAGE::"MCH Planned Work Orders",WorkOrder);
                      NewOrderStatus::Released:
                        PAGE.Run(PAGE::"MCH Released Work Orders",WorkOrder);
                    end;
                  end;
                end;
              end;
          end;
        end;
    end;

    trigger OnPreReport()
    var
        UserNotMaintUserErrMsg: Label 'Your must be setup as a Maintenance User.';
        UserWOCreateErrTxt: Label 'You are not allowed to create %1 work orders.';
    begin
        CheckValues;
        AssetMaintTaskFilter := AssetMaintTask.GetFilters;
        MaintAssetFilter := MaintAsset.GetFilters;

        ScheduleBuffer.Reset;
        ScheduleBuffer.DeleteAll;
        ScheduleCreated := false;
        AMSetup.Get;
        if not MaintUserMgt.GetMaintenanceUser(UserId,MaintenanceUser) then
          Error(UserNotMaintUserErrMsg);

        case ReportActionType of
          ReportActionType::"Test - Print/Preview only":
            begin
              CaptionText := Text007;
              WorkOrderNoCaptionText := Text008;
              if GuiAllowed then
                Window.Open(Text013 + Text014);
            end;
          ReportActionType::"Create Work Orders":
            begin
              if NewOrderStatus = NewOrderStatus::Planned then begin
                CaptionText := Text004;
                if not MaintenanceUser."Change WO Status to Planned" then
                  Error(UserWOCreateErrTxt,NewOrderStatus);
              end else begin
                CaptionText := Text005;
                if not MaintenanceUser."Change WO Status to Released" then
                  Error(UserWOCreateErrTxt,NewOrderStatus);
              end;
              WorkOrderNoCaptionText := Text006;
              if GuiAllowed then
                 Window.Open(Text013 + Text014 + Text015);
            end;
          ReportActionType::"Copy to Planning Worksheet":
            begin
              if (PlanningWkshLine."Worksheet Template Name" = '') or
                 (PlanningWkshLine."Journal Batch Name" = '')
              then
                Error(Text010);
              PlanningWkshBatch.Get(PlanningWkshLine."Worksheet Template Name",PlanningWkshLine."Journal Batch Name");
              PlanningWkshBatch.SetRecFilter;
              PlanningWkshFilter := PlanningWkshBatch.GetFilters;

              CaptionText := Text009;
              if GuiAllowed then
                Window.Open(Text013 + Text014 + Text016);
            end;
        end;
        NoOfMaintAsset := MaintAsset.Count;

        Clear(AMScheduleMgt);
        AMScheduleMgt.SetDoNotClearBufferPerAssetTask(true);
        AMScheduleMgt.SetCustomCalcParameters(
          StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode,ExcludeTasksOnPlanningWksh);
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        MaintenanceUser: Record "MCH Asset Maintenance User";
        PlanningWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
        PlanningWkshBatch: Record "MCH AM Planning Wksh. Name";
        PlanningWkshLine: Record "MCH AM Planning Wksh. Line";
        ScheduleBuffer: Record "MCH Maint. Schedule Buffer" temporary;
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        AMScheduleMgt: Codeunit "MCH AM Schedule Mgt.";
        Window: Dialog;
        CaptionText: Text;
        NoOfMaintAsset: Integer;
        MaintAssetCounter: Integer;
        NoOfLines: Integer;
        LineCounter: Integer;
        NoWorkOrders: Integer;
        WorkOrderCounter: Integer;
        StartingDate: Date;
        EndingDate: Date;
        TaskRecurrenceLimit: Integer;
        DefMaintLocationCode: Code[20];
        ExcludeTasksOnPlanningWksh: Boolean;
        [InDataSet]
        ShowDefMaintLocation: Boolean;
        NewOrderStatus: Option Planned,Released;
        ReportActionType: Option "Test - Print/Preview only","Create Work Orders","Copy to Planning Worksheet";
        AssetMaintTaskFilter: Text;
        MaintAssetFilter: Text;
        PlanningWkshFilter: Text;
        NextBufferEntryNo: Integer;
        WorkOrderNoCaptionText: Text;
        ReportCaptionLbl: Label 'Scheduled Maintenance - %1';
        NothingToScheduleMsg: Label 'There are no maintenance tasks to schedule...';
        Text004: Label 'Create Planned Work Orders';
        Text005: Label 'Create Released Work Orders';
        Text006: Label 'Work Order No.';
        Text007: Label 'Test';
        Text008: Label 'Test Work Order No.';
        Text009: Label 'Copy to Planning Worksheet';
        Text010: Label 'You must specify a Planning Worksheet Template and Batch Name.';
        Text012: Label 'Calculating Scheduled Maintenance...';
        Text013: Label 'Maintenance Asset    #1########\';
        Text014: Label 'Sorting schedule     #2########\';
        Text015: Label 'Creating work orders #3########';
        Text016: Label 'Copying to worksheet #4########';
        [InDataSet]
        EnableSingleLineOnly: Boolean;
        [InDataSet]
        EnableOneAssetOnly: Boolean;
        [InDataSet]
        EnableMultiLine: Boolean;
        SingleLineOnlyDefWODescription: Option blank,"Fixed Text","Asset Description","Task Description";
        OneAssetOnlyDefWODescription: Option blank,"Fixed Text","Asset Description","First Line - Task Description","Last Line - Task Description";
        MultiLineDefWODescription: Option blank,"Fixed Text","First Line - Asset Description","First Line - Task Description","Last Line - Asset Description","Last Line - Task Description";
        FixedWorkOrderDescription: Text[100];
        ResetToDefaultText: Label 'Reset to default values...';
        ProgressMsgTxt: Label '%1 of %2';
        PlanningStartingDateLbl: Label 'Schedule Starting Date';
        PlanningEndingDateLbl: Label 'Schedule Ending Date';
        [InDataSet]
        ShowWorkOrderOptions: Boolean;
        [InDataSet]
        ShowPlanningWkshOptions: Boolean;
        ReportPageNoCaption: Label 'Page %1 of %2';
        PlanningWkshFilterCaption: Label 'Planning Worksheet : %1';
        [InDataSet]
        IsCalledFromPlanningWorksheet: Boolean;
        IsCalledWithReportParameters: Boolean;
        ScheduleCreated: Boolean;
        FirstWONo: Code[20];
        LastWONo: Code[20];

    local procedure GroupBuffer()
    var
        NextGroupNo: Integer;
        NextTestWorkOrderNo: Code[20];
    begin
        ScheduleBuffer.Reset;
        if ScheduleBuffer.IsEmpty then
          exit;
        NoOfLines := ScheduleBuffer.Count;
        NextBufferEntryNo := 0;
        if ReportActionType = ReportActionType::"Test - Print/Preview only" then
          NextTestWorkOrderNo := '0';

        case AMSetup."Work Order Line Restriction" of
          AMSetup."Work Order Line Restriction"::"Single Line Only":
            ScheduleBuffer.SetCurrentKey("Starting Date",Priority,"Work Order Type","Entry No.");
          AMSetup."Work Order Line Restriction"::"One Asset Only":
            ScheduleBuffer.SetCurrentKey("Starting Date",Priority,"Work Order Type","Asset No.");
          AMSetup."Work Order Line Restriction"::"Same Resp. Group and Maint. Location":
            ScheduleBuffer.SetCurrentKey("Starting Date",Priority,"Work Order Type","Responsibility Group Code","Maint. Location Code");
        end;

        // Primary grouping
        while ScheduleBuffer.Find('-') do begin
          // Set WO group filters
          case AMSetup."Work Order Line Restriction" of
            AMSetup."Work Order Line Restriction"::"Single Line Only":
              begin
              end;
            AMSetup."Work Order Line Restriction"::"One Asset Only":
              begin
                NextGroupNo := NextGroupNo + 1;
                NoWorkOrders := NoWorkOrders + 1;
                if ReportActionType = ReportActionType::"Test - Print/Preview only" then
                  NextTestWorkOrderNo := IncStr(NextTestWorkOrderNo);
                ScheduleBuffer.SetRange("Starting Date",ScheduleBuffer."Starting Date");
                ScheduleBuffer.SetRange(Priority,ScheduleBuffer.Priority);
                ScheduleBuffer.SetRange("Work Order Type",ScheduleBuffer."Work Order Type");
                ScheduleBuffer.SetRange("Asset No.",ScheduleBuffer."Asset No.");
              end;
            AMSetup."Work Order Line Restriction"::"Same Resp. Group and Maint. Location":
              begin
                NextGroupNo := NextGroupNo + 1;
                NoWorkOrders := NoWorkOrders + 1;
                if ReportActionType = ReportActionType::"Test - Print/Preview only" then
                  NextTestWorkOrderNo := IncStr(NextTestWorkOrderNo);
                ScheduleBuffer.SetRange("Starting Date",ScheduleBuffer."Starting Date");
                ScheduleBuffer.SetRange(Priority,ScheduleBuffer.Priority);
                ScheduleBuffer.SetRange("Work Order Type",ScheduleBuffer."Work Order Type");
                ScheduleBuffer.SetRange("Responsibility Group Code",ScheduleBuffer."Responsibility Group Code");
                ScheduleBuffer.SetRange("Maint. Location Code",ScheduleBuffer."Maint. Location Code");
              end;
          end;
          repeat
            Buffer := ScheduleBuffer;
            NextBufferEntryNo := NextBufferEntryNo + 1;
            Buffer."Entry No." := NextBufferEntryNo;
            if (AMSetup."Work Order Line Restriction" = AMSetup."Work Order Line Restriction"::"Single Line Only") then begin
              NextGroupNo := NextGroupNo + 1;
              NoWorkOrders := NoWorkOrders + 1;
              if ReportActionType = ReportActionType::"Test - Print/Preview only" then
                NextTestWorkOrderNo := IncStr(NextTestWorkOrderNo);
            end;
            Buffer."Group No." := NextGroupNo;
            Buffer."Work Order No." := NextTestWorkOrderNo;
            Buffer.Insert;
            ScheduleBuffer.Delete;

            LineCounter := LineCounter + 1;
            if GuiAllowed then
              Window.Update(2,StrSubstNo(ProgressMsgTxt,LineCounter,NoOfLines));
          until ScheduleBuffer.Next = 0;

          // Reset line WO group filters
          case AMSetup."Work Order Line Restriction" of
            AMSetup."Work Order Line Restriction"::"Single Line Only":
              begin
              end;
            AMSetup."Work Order Line Restriction"::"One Asset Only":
              begin
                ScheduleBuffer.SetRange("Starting Date");
                ScheduleBuffer.SetRange(Priority);
                ScheduleBuffer.SetRange("Work Order Type");
                ScheduleBuffer.SetRange("Asset No.");
              end;
            AMSetup."Work Order Line Restriction"::"Same Resp. Group and Maint. Location":
              begin
                ScheduleBuffer.SetRange("Starting Date");
                ScheduleBuffer.SetRange(Priority);
                ScheduleBuffer.SetRange("Work Order Type");
                ScheduleBuffer.SetRange("Responsibility Group Code");
                ScheduleBuffer.SetRange("Maint. Location Code");
              end;
          end;
        end;
    end;

    local procedure CreateWorkOrders()
    var
        WorkOrder: Record "MCH Work Order Header";
        WorkOrderLine: Record "MCH Work Order Line";
        FirstWorkOrderLine: Record "MCH Work Order Line";
        LastWorkOrderLine: Record "MCH Work Order Line";
        LastGroupNo: Integer;
        LineNo: Integer;
        IsFirstLine: Boolean;
    begin
        LastGroupNo := -1;
        if Buffer.FindSet then begin
          WorkOrderLine.LockTable;
          WorkOrder.LockTable;
          repeat
            if (LastGroupNo <> Buffer."Group No.") then begin
              if (WorkOrder."No." <> '') then
                SetWorkOrderDescription(FirstWorkOrderLine,LastWorkOrderLine);

              LastGroupNo := Buffer."Group No.";
              WorkOrder.Init;
              case NewOrderStatus of
                NewOrderStatus::Planned:
                  WorkOrder.Status := WorkOrder.Status::Planned;
                NewOrderStatus::Released:
                  WorkOrder.Status := WorkOrder.Status::Released;
              end;
              WorkOrder."No." := '';
              WorkOrder.Insert(true);
              WorkOrder.Validate("Work Order Type",Buffer."Work Order Type");
              WorkOrder.Validate("Starting Date",Buffer."Starting Date");
              WorkOrder.Validate("Expected Ending Date",WorkOrder."Ending Date");
              WorkOrder.Validate(Priority,Buffer.Priority);
              WorkOrder.Modify(true);
              LineNo := 0;
              IsFirstLine := true;
              LastWONo := WorkOrder."No.";
              if (FirstWONo = '') then
                FirstWONo := LastWONo;

              WorkOrderCounter := WorkOrderCounter + 1;
              if GuiAllowed then
                Window.Update(3,WorkOrder."No.");
            end;

            LineNo := LineNo + 10000;
            WorkOrderLine.Init;
            WorkOrderLine.Status := WorkOrder.Status;
            WorkOrderLine."Work Order No." := WorkOrder."No.";
            WorkOrderLine."Line No." := LineNo;
            WorkOrderLine.Insert(true);
            WorkOrderLine.Validate("Asset No.",Buffer."Asset No.");
            WorkOrderLine.Validate("Task Code",Buffer."Task Code");
            WorkOrderLine."Task Scheduled Date" := Buffer."Scheduled Date";
            WorkOrderLine."Task Scheduled Usage Value" := Buffer."Scheduled Usage";
            WorkOrderLine.Modify(true);

            if IsFirstLine then begin
              FirstWorkOrderLine := WorkOrderLine;
              IsFirstLine := false;
            end;
            LastWorkOrderLine := WorkOrderLine;

            Buffer."Work Order Status" := WorkOrder.Status;
            Buffer."Work Order No." := WorkOrder."No.";
            Buffer.Modify;
          until Buffer.Next = 0;
          SetWorkOrderDescription(FirstWorkOrderLine,LastWorkOrderLine);
          ScheduleCreated := true;
          Commit;
        end;
    end;

    local procedure SetWorkOrderDescription(FirstWorkOrderLine: Record "MCH Work Order Line";LastWorkOrderLine: Record "MCH Work Order Line")
    var
        WorkOrder: Record "MCH Work Order Header";
        NewWODescription: Text;
    begin
        case AMSetup."Work Order Line Restriction" of
          AMSetup."Work Order Line Restriction"::"Single Line Only":
            begin
              case SingleLineOnlyDefWODescription of
                SingleLineOnlyDefWODescription::blank:
                  exit;
                SingleLineOnlyDefWODescription::"Fixed Text":
                  NewWODescription := FixedWorkOrderDescription;
                SingleLineOnlyDefWODescription::"Asset Description":
                  NewWODescription := FirstWorkOrderLine.Description;
                SingleLineOnlyDefWODescription::"Task Description": ;
              end;
            end;
          AMSetup."Work Order Line Restriction"::"One Asset Only":
            begin
              case OneAssetOnlyDefWODescription of
                OneAssetOnlyDefWODescription::blank:
                  exit;
                OneAssetOnlyDefWODescription::"Fixed Text":
                  NewWODescription := FixedWorkOrderDescription;
                OneAssetOnlyDefWODescription::"Asset Description":
                  NewWODescription := FirstWorkOrderLine.Description;
                OneAssetOnlyDefWODescription::"First Line - Task Description":
                  NewWODescription := FirstWorkOrderLine."Task Description";
                OneAssetOnlyDefWODescription::"Last Line - Task Description":
                  NewWODescription := LastWorkOrderLine."Task Description";
              end;
            end;
          AMSetup."Work Order Line Restriction"::"Same Resp. Group and Maint. Location":
            begin
              case MultiLineDefWODescription of
                MultiLineDefWODescription::blank:
                  exit;
                MultiLineDefWODescription::"Fixed Text":
                  NewWODescription := FixedWorkOrderDescription;
                MultiLineDefWODescription::"First Line - Asset Description":
                  NewWODescription := FirstWorkOrderLine.Description;
                MultiLineDefWODescription::"First Line - Task Description":
                  NewWODescription := FirstWorkOrderLine."Task Description";
                MultiLineDefWODescription::"Last Line - Asset Description":
                  NewWODescription := LastWorkOrderLine.Description;
                MultiLineDefWODescription::"Last Line - Task Description":
                  NewWODescription := LastWorkOrderLine."Task Description";
              end;
            end;
        end;
        if (NewWODescription <> '') then begin
          WorkOrder.Get(FirstWorkOrderLine.Status,FirstWorkOrderLine."Work Order No.");
          WorkOrder.Description := NewWODescription;
          WorkOrder.Modify;
        end;
    end;

    local procedure CreatePlanningWorksheet()
    var
        LineNo: Integer;
    begin
        PlanningWkshLine.LockTable;
        PlanningWkshLine.Reset;
        PlanningWkshBatch.Get(PlanningWkshLine."Worksheet Template Name",PlanningWkshLine."Journal Batch Name");
        PlanningWkshLine.SetRange("Worksheet Template Name",PlanningWkshLine."Worksheet Template Name");
        PlanningWkshLine.SetRange("Journal Batch Name",PlanningWkshLine."Journal Batch Name");
        if PlanningWkshLine.FindLast then
          LineNo := PlanningWkshLine."Line No."
        else
          LineNo := 0;
        LineCounter := 0;
        if Buffer.FindSet then begin
          repeat
            LineNo := LineNo + 10000;
            PlanningWkshLine."Worksheet Template Name" := PlanningWkshLine."Worksheet Template Name";
            PlanningWkshLine."Journal Batch Name" := PlanningWkshLine."Journal Batch Name";
            PlanningWkshLine."Line No." := LineNo;
            PlanningWkshLine.Init;
            PlanningWkshLine.Validate("Asset No.",Buffer."Asset No.");
            PlanningWkshLine.Validate("Task Code",Buffer."Task Code");
            PlanningWkshLine.Validate("Work Order Type",Buffer."Work Order Type");
            PlanningWkshLine.Validate(Priority,Buffer.Priority);
            PlanningWkshLine.Validate("Starting Date",Buffer."Starting Date");
            PlanningWkshLine.Validate("Task Scheduled Date",Buffer."Scheduled Date");
            PlanningWkshLine.Validate("Task Scheduled Usage Value",Buffer."Scheduled Usage");
            PlanningWkshLine.Insert;

            LineCounter := LineCounter + 1;
            if GuiAllowed then
              Window.Update(4,StrSubstNo(ProgressMsgTxt,LineCounter,NoOfLines));
          until Buffer.Next = 0;
          ScheduleCreated := true;
          Commit;
        end;
    end;

    local procedure SetRequestPageFieldsEnable()
    begin
        AMSetup.Get;
        EnableMultiLine := false;
        EnableOneAssetOnly := false;
        EnableSingleLineOnly := false;
        case AMSetup."Work Order Line Restriction" of
          AMSetup."Work Order Line Restriction"::"Single Line Only":
            EnableSingleLineOnly := true;
          AMSetup."Work Order Line Restriction"::"One Asset Only":
            EnableOneAssetOnly := true;
          AMSetup."Work Order Line Restriction"::"Same Resp. Group and Maint. Location":
            EnableMultiLine := true;
        end;

        ShowWorkOrderOptions := false;
        ShowPlanningWkshOptions := false;

        case ReportActionType of
          ReportActionType::"Create Work Orders" :
            begin
              ShowWorkOrderOptions := true;
            end;
          ReportActionType::"Copy to Planning Worksheet" :
            begin
              ShowPlanningWkshOptions := true;
              if (PlanningWkshLine."Worksheet Template Name" = '') then begin
                PlanningWkshTemplate.Reset;
                PlanningWkshTemplate.SetRange(Type,PlanningWkshTemplate.Type::Planning);
                if PlanningWkshTemplate.FindFirst then
                  PlanningWkshLine."Worksheet Template Name" := PlanningWkshTemplate.Name;
                PlanningWkshTemplate.Reset;
              end;
              if (PlanningWkshLine."Journal Batch Name" = '') and (PlanningWkshLine."Worksheet Template Name" <> '') then begin
                PlanningWkshBatch.Reset;
                PlanningWkshBatch.SetRange("Worksheet Template Name",PlanningWkshLine."Worksheet Template Name");
                if PlanningWkshBatch.FindFirst then
                  PlanningWkshLine."Journal Batch Name" := PlanningWkshBatch."Worksheet Template Name";
              end;
            end;
        end;
    end;


    procedure SetPlanningWorksheet(var NewPlanningWkshLine: Record "MCH AM Planning Wksh. Line")
    begin
        PlanningWkshLine := NewPlanningWkshLine;
        IsCalledFromPlanningWorksheet := true;
    end;


    procedure SetReportParameters(NewStartingDate: Date;NewEndingDate: Date;NewTaskRecurrenceLimit: Integer;NewDefMaintLocationCode: Code[20];NewExcludeTasksOnPlanningWksh: Boolean)
    begin
        IsCalledWithReportParameters := true;
        StartingDate := NewStartingDate;
        EndingDate := NewEndingDate;
        TaskRecurrenceLimit := NewTaskRecurrenceLimit;
        DefMaintLocationCode := NewDefMaintLocationCode;
        ExcludeTasksOnPlanningWksh := NewExcludeTasksOnPlanningWksh;
    end;

    [TryFunction]
    local procedure CheckValues()
    var
        Text001: Label 'You must specify the Starting Date.';
        Text002: Label 'You must specify the Ending Date.';
        Text003: Label 'The Starting Date cannot be later than the Ending Date.';
        Text004: Label 'The Maint. Task Recurrence Limit must not exceed %1.';
        Text005: Label 'The no. days in the period (%1 to %2) must not exceed %3.';
    begin
        AMSetup.Get;
        if StartingDate = 0D then
          Error(Text001);
        if EndingDate = 0D then
          Error(Text002);
        if StartingDate > EndingDate then
          Error(Text003);
        if (TaskRecurrenceLimit > AMSetup."Schedule Task Recurr. Limit") then
          Error(Text004,AMSetup."Schedule Task Recurr. Limit");
        if (EndingDate - StartingDate + 1) > AMSetup."Forecast Look Ahead (Days)" then
          Error(Text005,StartingDate,EndingDate,AMSetup."Forecast Look Ahead (Days)");
    end;

    local procedure QtyToTxt(DecValue: Decimal;BlankIfZero: Boolean) DecAsText: Text
    begin
        if BlankIfZero and (DecValue = 0) then
          exit('')
        else
          exit(Format(DecValue));
    end;
}

