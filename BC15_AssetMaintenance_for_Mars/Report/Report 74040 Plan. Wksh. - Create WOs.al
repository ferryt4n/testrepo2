report 74040 "MCH Plan. Wksh. - Create WOs"
{
    Caption = 'Planning Worksheet - Create Work Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem(PlanningWkshLine;"MCH AM Planning Wksh. Line")
        {
            DataItemTableView = SORTING("Worksheet Template Name","Journal Batch Name","Line No.");

            trigger OnAfterGetRecord()
            var
                RespGroupAccesErrMsg: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
            begin
                if "Asset No." = '' then
                  CurrReport.Skip;
                if ("Asset No." <> MaintAsset."No.") then begin
                  MaintAsset.Get("Asset No.");
                  MaintAsset.CheckMandatoryFields;
                  if UserHasAssetRespGroupFilter then begin
                    if not MaintUserMgt.UserHasAccessToRespGroup(UserId,MaintAsset."Responsibility Group Code") then
                      Error(RespGroupAccesErrMsg,
                        MaintAsset.TableCaption,MaintAsset."No.",
                        MaintAsset.FieldCaption("Responsibility Group Code"),MaintAsset."Responsibility Group Code");
                  end;
                end;
                if (MaintAsset."Responsibility Group Code" <> '') then
                  TestField("Responsibility Group Code",MaintAsset."Responsibility Group Code");
                if (MaintAsset."Fixed Maint. Location Code" <> '') then
                  TestField("Maint. Location Code",MaintAsset."Fixed Maint. Location Code");

                TestField("Task Code");
                TestField("Starting Date");
                TestField("Task Scheduled Date");

                AssetMaintTask.Get("Asset No.","Task Code");
                AssetMaintTask.TestField("Effective Date");
                AssetMaintTask.TestField(Blocked,false);

                MasterMaintTask.Get("Task Code");
                TestField("Task Trigger Method",MasterMaintTask."Trigger Method");
                if "Task Trigger Method" <> "Task Trigger Method"::Manual then
                  TestField("Task Scheduled Date");

                if "Task Trigger Method" in ["Task Trigger Method"::"Usage (Recurring)","Task Trigger Method"::"Fixed Usage"] then begin
                  TestField("Usage Monitor Code",AssetMaintTask."Usage Monitor Code");
                  TestField("Task Scheduled Usage Value");
                  AssetUsageMonitor.Get("Asset No.","Usage Monitor Code");
                  AssetUsageMonitor.TestField(Blocked,false);
                  MasterUsageMonitor.Get("Usage Monitor Code");
                  MasterUsageMonitor.TestField(Status,MasterUsageMonitor.Status::Active);
                end;

                if AMSetup."Work Order Type Mandatory" then
                  TestField("Work Order Type");
                if "Work Order Type" = '' then
                  WorkOrderType.Init
                else begin
                  if WorkOrderType.Code <> "Work Order Type" then begin
                    WorkOrderType.Get("Work Order Type");
                    WorkOrderType.TestField(Blocked,false);
                  end;
                end;

                InsertBuffer;
            end;

            trigger OnPostDataItem()
            begin
                GroupBuffer;
                CreateWorkOrders;
                DeleteAll(true);

                if GuiAllowed then
                  Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                CopyFilters(MaintWkshLine);
                LockTable;
                NoOfLines := Count;

                if GuiAllowed then
                  Window.Open(DialogTxt1 + DialogTxt2 + DialogTxt3);

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
                group("New Work Order")
                {
                    Caption = 'New Work Order';
                    field(NewOrderStatus;NewOrderStatus)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Status';
                    }
                    group(Control1101214009)
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
                    group(Control1101214007)
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
                    group(Control1101214006)
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
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            AMSetup.Get;
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
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        WorkOrder: Record "MCH Work Order Header";
    begin
        if (FirstWONo <> '') then begin
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

    trigger OnPreReport()
    var
        UserNotMaintUserErrMsg: Label 'Your must be setup as a Maintenance User.';
    begin
        if not MaintUserMgt.GetMaintenanceUser(UserId,MaintUser) then
          Error(UserNotMaintUserErrMsg);
        UserHasAssetRespGroupFilter := MaintUserMgt.UserHasAssetRespGroupFilter;

        case NewOrderStatus of
          NewOrderStatus::Planned:
            if not MaintUser."Change WO Status to Planned" then
              Error(UserWOCreateErrTxt,NewOrderStatus);
          NewOrderStatus::Released:
            if not MaintUser."Change WO Status to Released" then
              Error(UserWOCreateErrTxt,NewOrderStatus);
        end;

        MaintWkshTemplate.Get(MaintWkshLine."Worksheet Template Name");
        MaintWkshBatch.Get(MaintWkshLine."Worksheet Template Name",MaintWkshLine."Journal Batch Name");

        Buffer.Reset;
        Buffer.DeleteAll;
        ScheduleBuffer.Reset;
        ScheduleBuffer.DeleteAll;
        AMSetup.Get;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        MaintUser: Record "MCH Asset Maintenance User";
        MaintAsset: Record "MCH Maintenance Asset";
        MaintWkshTemplate: Record "MCH AM Planning Wksh. Templ.";
        MaintWkshBatch: Record "MCH AM Planning Wksh. Name";
        MaintWkshLine: Record "MCH AM Planning Wksh. Line";
        WorkOrderType: Record "MCH Work Order Type";
        AssetMaintTask: Record "MCH Asset Maintenance Task";
        MasterMaintTask: Record "MCH Master Maintenance Task";
        MasterUsageMonitor: Record "MCH Master Usage Monitor";
        AssetUsageMonitor: Record "MCH Asset Usage Monitor";
        Buffer: Record "MCH Maint. Schedule Buffer" temporary;
        ScheduleBuffer: Record "MCH Maint. Schedule Buffer" temporary;
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        Window: Dialog;
        UserHasAssetRespGroupFilter: Boolean;
        NoOfLines: Integer;
        LineCounter: Integer;
        NoWorkOrders: Integer;
        WorkOrderCounter: Integer;
        NewOrderStatus: Option Planned,Released;
        NextBufferEntryNo: Integer;
        Text000: Label 'Maintenance Schedule - %1';
        Text001: Label 'You must define a From Date.';
        Text002: Label 'You must define a Planning Date.';
        Text003: Label 'From Date is greater than Planning Date.';
        Text004: Label 'Create Planned Work Orders';
        Text005: Label 'Create Released Work Orders';
        Text006: Label 'Work Order No.';
        Text007: Label 'Test';
        Text008: Label 'Test Work Order No.';
        Text009: Label 'Copy to Planning Worksheet';
        Text010: Label 'You must enter Planning Wksh. Template and Name.';
        Text011: Label 'is invalid. Dates are incorrectly calculated';
        Text012: Label 'Calculating Maintenance Schedule...';
        Text013: Label 'Maintenance Asset #1######## @2@@@@@@@@@@@@@\';
        Text014: Label 'Grouping schedule @3@@@@@@@@@@@@@@@@@@@@@@@@\';
        Text015: Label 'Creating work orders #4######## @5@@@@@@@@@@@@@';
        Text016: Label 'Copying to worksheet @6@@@@@@@@@@@@@@@@@@@@@@@@';
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
        FirstWONo: Code[20];
        LastWONo: Code[20];
        ProgressMsgTxt: Label '%1 of %2';
        DialogTxt1: Label 'Reading lines  #1########\';
        DialogTxt2: Label 'Sorting schedule     #2########\';
        DialogTxt3: Label 'Creating work orders #3########';
        UserWOCreateErrTxt: Label 'You are not allowed to create %1 work orders.';


    procedure SetWkshLine(var NewMPWkshLine: Record "MCH AM Planning Wksh. Line")
    begin
        MaintWkshLine.Copy(NewMPWkshLine);
    end;

    local procedure InsertBuffer()
    begin
        NextBufferEntryNo := NextBufferEntryNo + 1;
        ScheduleBuffer.Init;
        ScheduleBuffer."Entry No." := NextBufferEntryNo;
        with PlanningWkshLine do begin
          ScheduleBuffer."Starting Date" := "Starting Date";
          ScheduleBuffer."Work Order Type" := "Work Order Type";
          ScheduleBuffer.Priority := Priority;
          ScheduleBuffer."Asset No." := "Asset No.";
          ScheduleBuffer."Task Code" := "Task Code";
          ScheduleBuffer."Scheduled Date" := "Task Scheduled Date";
          ScheduleBuffer."Maint. Location Code" := "Maint. Location Code";
          ScheduleBuffer."Responsibility Group Code" := "Responsibility Group Code";

          case "Task Trigger Method" of
            "Task Trigger Method"::"Calendar (Recurring)",
            "Task Trigger Method"::"Fixed Date" :
              ; // do nothing
            "Task Trigger Method"::"Usage (Recurring)",
            "Task Trigger Method"::"Fixed Usage":
              ScheduleBuffer."Scheduled Usage" := "Task Scheduled Usage Value";
          end;
        end;
        ScheduleBuffer.Insert;
        NoOfLines := NoOfLines + 1;
        if GuiAllowed then
          Window.Update(1,StrSubstNo(ProgressMsgTxt,LineCounter,NoOfLines));
    end;

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
        LineCounter := 0;

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
                ScheduleBuffer.SetRange("Starting Date",ScheduleBuffer."Starting Date");
                ScheduleBuffer.SetRange(Priority,ScheduleBuffer.Priority);
                ScheduleBuffer.SetRange("Work Order Type",ScheduleBuffer."Work Order Type");
                ScheduleBuffer.SetRange("Asset No.",ScheduleBuffer."Asset No.");
              end;
            AMSetup."Work Order Line Restriction"::"Same Resp. Group and Maint. Location":
              begin
                NextGroupNo := NextGroupNo + 1;
                NoWorkOrders := NoWorkOrders + 1;
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
            end;
            Buffer."Group No." := NextGroupNo;
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
            WorkOrderLine."Task Scheduled Date" := Buffer."Starting Date";
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
}

