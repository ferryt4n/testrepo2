codeunit 74055 "MCH AM Schedule Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        MaintUser: Record "MCH Asset Maintenance User";
        GlobalMaintAsset: Record "MCH Maintenance Asset";
        GlobalAssetMaintTask: Record "MCH Asset Maintenance Task";
        AssetUsageMonitor: Record "MCH Asset Usage Monitor";
        WorkOrderType: Record "MCH Work Order Type";
        MasterMaintTask: Record "MCH Master Maintenance Task";
        AssetMTFixedDate: Record "MCH Asset M. Task Fixed Date";
        AssetMTFixedUsage: Record "MCH Asset M. Task Fixed Usage";
        PlanningWkshLine: Record "MCH AM Planning Wksh. Line";
        ScheduleBuffer: Record "MCH Maint. Schedule Buffer" temporary;
        MaintUserMgt: Codeunit "MCH AM User Mgt.";
        MaintTaskMgt: Codeunit "MCH Maint. Task Mgt.";
        AMFunctions: Codeunit "MCH AM Functions";
        HasInitializedSetup: Boolean;
        CalledForScheduling: Boolean;
        CalledForForecast: Boolean;
        CalledForNextForecastOnly: Boolean;
        DoNotClearBufferPerAssetTask: Boolean;
        UserHasAssetRespGroupFilter: Boolean;
        PlanningStartDate: Date;
        PlanningEndDate: Date;
        MaxTaskRecurrence: Integer;
        CustomPlanningStartDate: Date;
        CustomPlanningEndDate: Date;
        CustomTaskRecurrenceLimit: Integer;
        TaskRecurrenceCounter: Integer;
        NextBufferEntryNo: Integer;
        HasReachedMaxTaskRecurrence: Boolean;
        SchedulePriority: Option;
        UserDefaultMaintLocationCode: Code[20];
        DefaultMaintLocationCode: Code[20];
        SkipTasksOnPlanningWksh: Boolean;
        LastScheduledDate: Date;
        LastCompletionDate: Date;
        LastScheduledUsage: Decimal;
        LastCompletionUsage: Decimal;
        CurrentUsage: Decimal;
        TriggerUsageValue: Decimal;
        NextPlannedDate: Date;
        NextPlannedUsage: Decimal;
        LeadTimeDays: Integer;
        LeadTimeDate: Date;
        Text001: Label 'You must specify the Starting Date.';
        Text002: Label 'You must specify the Ending Date.';
        Text003: Label 'The Starting Date cannot be later than the Ending Date.';
        Text004: Label 'Your setup does not allow processing of %1 %2 with %3 = %4.';
        WeekDayArray: array [7] of Boolean;
        BaseFixedMonthDayNo: Integer;
        Text005: Label 'The no. days in the period (%1 to %2) must not exceed %3.';

    [TryFunction]

    procedure CalcMaintTaskForSchedule(NewAssetMaintTask: Record "MCH Asset Maintenance Task")
    begin
        CalledForScheduling := true;
        InitializeSetup;
        CalcAssetMaintTaskSchedule(NewAssetMaintTask);
    end;

    [TryFunction]

    procedure CalcMaintTaskForForecast(NewAssetMaintTask: Record "MCH Asset Maintenance Task")
    var
        NewPlanningStartDate: Date;
        NewPlanningEndDate: Date;
    begin
        CalledForForecast := true;
        InitializeSetup;
        CalcAssetMaintTaskSchedule(NewAssetMaintTask);
    end;

    [TryFunction]

    procedure CalcMaintTaskForNextForecastOnly(NewAssetMaintTask: Record "MCH Asset Maintenance Task")
    var
        NewPlanningStartDate: Date;
        NewPlanningEndDate: Date;
    begin
        CalledForNextForecastOnly := true;
        InitializeSetup;
        CalcAssetMaintTaskSchedule(NewAssetMaintTask);
    end;

    local procedure CalcAssetMaintTaskSchedule(NewAssetMaintTask: Record "MCH Asset Maintenance Task")
    var
        Continue: Boolean;
    begin
        InitializeNewMaintTaskCalculation(NewAssetMaintTask);

        with GlobalAssetMaintTask do begin
          if ("Trigger Method" = "Trigger Method"::Manual) or Blocked or ("Effective Date" = 0D) then
            exit;

          if SkipTasksOnPlanningWksh then begin
            if not PlanningWkshLine.IsEmpty then
              exit;
          end;

          MasterMaintTask.Get("Task Code");
          if (MasterMaintTask.Status <> MasterMaintTask.Status::Active) then
            exit;
          if MasterMaintTask."Scheduling Work Order Type" = '' then
            WorkOrderType.Init
          else
            if WorkOrderType.Code <> MasterMaintTask."Scheduling Work Order Type" then
              WorkOrderType.Get(MasterMaintTask."Scheduling Work Order Type");
          if (WorkOrderType."Def. Work Order Priority" > WorkOrderType."Def. Work Order Priority"::" ") then
            SchedulePriority := WorkOrderType."Def. Work Order Priority" - 1
          else
            SchedulePriority := AMSetup."Def. Work Order Priority";

          // Precheck of Usage/Monitor
          if ("Trigger Method" in ["Trigger Method"::"Usage (Recurring)","Trigger Method"::"Fixed Usage"]) then begin
            if not CheckPrepareRecurrFixedUsageMaintTask then
              exit;
          end;

          CalcFields("Last Completion Date","Last Scheduled Date");
          LastCompletionDate := "Last Completion Date";
          LastScheduledDate := "Last Scheduled Date";
          LeadTimeDays := "Schedule Lead Time (Days)";

          case "Trigger Method" of
            "Trigger Method"::"Calendar (Recurring)":
              Continue := PrepareRecurringCalendar;
            "Trigger Method"::"Fixed Date":
              Continue := PrepareFixedDate;
            "Trigger Method"::"Usage (Recurring)":
              Continue := PrepareRecurringUsage;
            "Trigger Method"::"Fixed Usage":
              Continue := PrepareFixedUsage;
            else
              FieldError("Trigger Method");
          end;
          if (not Continue) or (NextPlannedDate = 0D) then
            exit;

          case "Trigger Method" of
            "Trigger Method"::"Calendar (Recurring)":
              ScheduleRecurringCalendar;
            "Trigger Method"::"Fixed Date":
              ScheduleFixedDate;
            "Trigger Method"::"Usage (Recurring)":
              ScheduleRecurringUsage;
            "Trigger Method"::"Fixed Usage":
              ScheduleFixedUsage;
          end;
        end;
    end;

    local procedure PrepareRecurringCalendar() Continue: Boolean
    var
        WorkOrderLine: Record "MCH Work Order Line";
    begin
        with GlobalAssetMaintTask do begin
          case MasterMaintTask."Recurring Trigger Calc. Method" of
            MasterMaintTask."Recurring Trigger Calc. Method"::"Fixed Schedule":
              begin
                NextPlannedDate := "Effective Date";
              end;
            MasterMaintTask."Recurring Trigger Calc. Method"::"Last Completion":
              begin
                if CalledForScheduling then begin
                  if not PlanningWkshLine.IsEmpty then
                    exit(false);
                end;
                // Skip if incomplete WO exists
                if HasDateIncompleteOngoingWorkOrder then
                  exit(false);
                if (LastCompletionDate <> 0D) and (LastCompletionDate >= "Effective Date") then
                  NextPlannedDate := LastCompletionDate
                else
                  NextPlannedDate := "Effective Date";
              end;
          end;
          BaseFixedMonthDayNo := Date2DMY(NextPlannedDate,1);

          if not GetNextRecurringCalendarDate then
            exit(false);

          if not DateIsInPeriod(NextPlannedDate,"Effective Date","Expiry Date") then
            exit(false);
          if not MaintTaskMgt.CheckMasterTaskSetup(MasterMaintTask) then
            exit(false);
          exit(true);
        end;
    end;

    local procedure ScheduleRecurringCalendar()
    var
        DoSchedule: Boolean;
    begin
        // Fixed Schedule: Can schedule multiple
        // Actual Completion: Schedule Max. One
        while true do begin
          if not DateIsInPeriod(LeadTimeDate,0D,PlanningEndDate) then
            exit;
          if not DateIsInPeriod(NextPlannedDate,GlobalAssetMaintTask."Effective Date",GlobalAssetMaintTask."Expiry Date") then
            exit;

          if (NextPlannedDate <= LastScheduledDate) or
             (NextPlannedDate < PlanningStartDate)
          then begin
            // skip to next loop
          end else begin
              DoSchedule := true;
              if CalledForScheduling then begin
                PlanningWkshLine.SetFilter("Starting Date",'>=%1',NextPlannedDate);
                DoSchedule := PlanningWkshLine.IsEmpty;
              end;
              if DoSchedule then
                InsertBuffer;
          end;

          if HasReachedMaxTaskRecurrence then
            exit;
          if not GetNextRecurringCalendarDate then
            exit;
        end;
    end;

    local procedure GetNextRecurringCalendarDate() OK: Boolean
    var
        xNextPlannedDate: Date;
    begin
        xNextPlannedDate := NextPlannedDate;
        with MasterMaintTask do begin
          case "Calendar Recurrence Type" of
            "Calendar Recurrence Type"::Daily :
              NextPlannedDate := FindNextCalendarDaily;
            "Calendar Recurrence Type"::Weekly :
              NextPlannedDate := FindNextCalendarWeekly;
            "Calendar Recurrence Type"::Monthly :
              NextPlannedDate := FindNextCalendarMonthly;
            "Calendar Recurrence Type"::Yearly :
              NextPlannedDate := FindNextCalendarYearly;
          end;
        end;
        if (NextPlannedDate <= xNextPlannedDate) then
          exit(false);

        LeadTimeDate := NextPlannedDate - LeadTimeDays;
        if LeadTimeDate <= xNextPlannedDate then
          LeadTimeDate := xNextPlannedDate + 1;
        if LeadTimeDate > NextPlannedDate then
          LeadTimeDate := NextPlannedDate;
        exit(true);
    end;

    local procedure FindNextCalendarDaily(): Date
    var
        DateFormulaTxt: Text;
    begin
        // BaseCalendar NOT yet implemented
        // Treating all as 'Day'
        DateFormulaTxt := StrSubstNo('<%1D>',MasterMaintTask."Cal. Daily Recur Every");
        exit(CalcDate(DateFormulaTxt,NextPlannedDate));
        /*
        WITH MasterMaintTask DO BEGIN
          CASE "Cal. Daily Type of Day" OF
            "Cal. Daily Type of Day"::Day : ;
            "Cal. Daily Type of Day"::"Working Day" : ;
            "Cal. Daily Type of Day"::"Nonworking Day" : ;
          END;
        END;
        */

    end;

    local procedure FindNextCalendarWeekly(): Date
    var
        Calendar: Record Date;
        DayNo: Integer;
        d: Integer;
        DateFormulaTxt: Text;
    begin
        Clear(WeekDayArray);
        with MasterMaintTask do begin
          WeekDayArray[1] := "Cal. Weekly on Monday";
          WeekDayArray[2] := "Cal. Weekly on Tuesday";
          WeekDayArray[3] := "Cal. Weekly on Wednesday";
          WeekDayArray[4] := "Cal. Weekly on Thursday";
          WeekDayArray[5] := "Cal. Weekly on Friday";
          WeekDayArray[6] := "Cal. Weekly on Saturday";
          WeekDayArray[7] := "Cal. Weekly on Sunday";
        end;
        Calendar.Reset;
        Calendar.Get(Calendar."Period Type"::Date,NextPlannedDate);
        DayNo := Calendar."Period No.";
        Calendar.SetRange("Period Type",Calendar."Period Type"::Date);

        // Any days left 2do this week?
        // Start is not a Sunday
        if (DayNo < 7) then begin
          for d := DayNo to 7 do begin
            Calendar.Next(1);
            if WeekDayArray[d] then
              exit(Calendar."Period Start");
          end;
        end;
        // Move search start to Monday in next "Recur Every" week
        DateFormulaTxt := StrSubstNo('<-CW+%1W>',MasterMaintTask."Cal. Weekly Recur Every");
        Calendar.Get(Calendar."Period Type"::Date,CalcDate(DateFormulaTxt,NextPlannedDate));
        for d := 1 to 7 do begin
          if WeekDayArray[d] then
            exit(Calendar."Period Start");
          Calendar.Next(1);
        end;
        Error('Unexpected error in FindNextCalendarWeekly(NextPlannedDate: %1). No date found.',NextPlannedDate);
    end;

    local procedure FindNextCalendarMonthly() NewDate: Date
    var
        Calendar: Record Date;
        MonthDayNo: Integer;
        MonthLastDayNo: Integer;
        SearchLoopNo: Integer;
        LoopNoStart: Integer;
        DateFormulaTxt: Text;
        TempDate: Date;
        PeriodFromDate: Date;
        PeriodToDate: Date;
        MatchingDate: Date;
        MatchCounter: Integer;
        FoundDayMatch: Boolean;
    begin
        with MasterMaintTask do begin
          case "Cal. Monthly Pattern" of
            "Cal. Monthly Pattern"::"Recurring Day of Month" :
              begin
                DateFormulaTxt := StrSubstNo('<%1M>',"Cal. Monthly Recur Every");
                NewDate := CalcDate(DateFormulaTxt,NextPlannedDate);
                // Adjust day no. of month to nearest Base
                if (BaseFixedMonthDayNo > 0) then begin
                  MonthDayNo := Date2DMY(NewDate,1);
                  if (MonthDayNo <> BaseFixedMonthDayNo) then begin
                    if (MonthDayNo > BaseFixedMonthDayNo) then begin
                      DateFormulaTxt := StrSubstNo('<-CM-1D+%1D>',BaseFixedMonthDayNo);
                    end else begin
                      MonthLastDayNo := Date2DMY(CalcDate('<CM>',NewDate),1);
                      if (MonthLastDayNo < BaseFixedMonthDayNo) then
                        DateFormulaTxt := StrSubstNo('<-CM-1D+%1D>',MonthLastDayNo)
                      else
                        DateFormulaTxt := StrSubstNo('<-CM-1D+%1D>',BaseFixedMonthDayNo);
                    end;
                    NewDate := CalcDate(DateFormulaTxt,NewDate);
                  end;
                end;
                exit(NewDate);
              end;

            "Cal. Monthly Pattern"::"Fixed Day of Month" :
              begin
                MonthDayNo := Date2DMY(NextPlannedDate,1);
                MonthLastDayNo := Date2DMY(CalcDate('<CM>',NextPlannedDate),1);

                if (MonthDayNo < "Cal. Monthly Fixed Day No.") then begin
                  // Schedule later this month
                  if ("Cal. Monthly Fixed Day No." <= MonthLastDayNo) then
                    DateFormulaTxt := StrSubstNo('<-CM-1D+%1D>',"Cal. Monthly Fixed Day No.")
                  else
                    DateFormulaTxt := '<CM>';

                  NewDate := CalcDate(DateFormulaTxt,NextPlannedDate);
                  if (NewDate > NextPlannedDate) then
                    exit(NewDate);
                end;

                // Go the next x month and find day no
                DateFormulaTxt := StrSubstNo('<-CM+%1M>',"Cal. Monthly Recur Every");
                TempDate := CalcDate(DateFormulaTxt,NextPlannedDate);
                MonthLastDayNo := Date2DMY(CalcDate('<CM>',TempDate),1);

                if ("Cal. Monthly Fixed Day No." <= MonthLastDayNo) then
                  DateFormulaTxt := StrSubstNo('<-CM-1D+%1D>',"Cal. Monthly Fixed Day No.")
                else
                  DateFormulaTxt := '<CM>';
                NewDate := CalcDate(DateFormulaTxt,TempDate);
                exit(NewDate);
              end;

            "Cal. Monthly Pattern"::"Relative Day of Month" :
              begin
                PeriodToDate := CalcDate('<CM>',NextPlannedDate);
                if (PeriodToDate > NextPlannedDate) then begin
                  PeriodFromDate := CalcDate('<-CM>',PeriodToDate);
                  LoopNoStart := 1;
                end else begin
                  DateFormulaTxt := StrSubstNo('<-CM+%1M>',"Cal. Monthly Recur Every");
                  PeriodFromDate := CalcDate(DateFormulaTxt,NextPlannedDate);
                  PeriodToDate := CalcDate('<CM>',PeriodFromDate);
                  LoopNoStart := 2;
                end;

                // Search remaining Current month or the Next x Month
                for SearchLoopNo := LoopNoStart to 2 do begin
                  MatchingDate := 0D;
                  NewDate := 0D;
                  MatchCounter := 0;
                  Calendar.Reset;
                  Calendar.SetRange("Period Type",Calendar."Period Type"::Date);
                  Calendar.Get(Calendar."Period Type"::Date,PeriodFromDate);
                  repeat
                    FoundDayMatch := false;
                    // BaseCalendar NOT yet implemented
                    // Treating "Working Day" and "Nonworking Day" as 'Day'
                    case "Cal. Type of Day" of
                      "Cal. Type of Day"::Day,
                      "Cal. Type of Day"::"Working Day",
                      "Cal. Type of Day"::"Nonworking Day" :
                        FoundDayMatch := true;
                      "Cal. Type of Day"::Monday :
                        FoundDayMatch := (Calendar."Period No." = 1);
                      "Cal. Type of Day"::Tuesday :
                        FoundDayMatch := (Calendar."Period No." = 2);
                      "Cal. Type of Day"::Wednesday :
                        FoundDayMatch := (Calendar."Period No." = 3);
                      "Cal. Type of Day"::Thursday :
                        FoundDayMatch := (Calendar."Period No." = 4);
                      "Cal. Type of Day"::Friday :
                        FoundDayMatch := (Calendar."Period No." = 5);
                      "Cal. Type of Day"::Saturday :
                        FoundDayMatch := (Calendar."Period No." = 6);
                      "Cal. Type of Day"::Sunday :
                        FoundDayMatch := (Calendar."Period No." = 7);
                    end;
                    if FoundDayMatch then begin
                      MatchCounter := MatchCounter + 1;
                      MatchingDate := Calendar."Period Start";
                    end;

                    case "Cal. Which Day in Month" of
                      "Cal. Which Day in Month"::First :
                        if (MatchCounter = 1) then
                          NewDate := MatchingDate;
                      "Cal. Which Day in Month"::Second :
                        if (MatchCounter = 2) then
                          NewDate := MatchingDate;
                      "Cal. Which Day in Month"::Third :
                        if (MatchCounter = 3) then
                          NewDate := MatchingDate;
                      "Cal. Which Day in Month"::Fourth :
                        if (MatchCounter = 4) then
                          NewDate := MatchingDate;
                    end;

                    Calendar.Next(1);
                  until (Calendar."Period Start" > PeriodToDate) or (NewDate <> 0D);

                  case "Cal. Which Day in Month" of
                    "Cal. Which Day in Month"::Last :
                    begin
                      if (MatchCounter > 0) then
                        NewDate := MatchingDate;
                    end;
                  end;
                  if (NewDate > NextPlannedDate) then
                    exit(NewDate);

                  // move dates to next x Month
                  DateFormulaTxt := StrSubstNo('<-CM+%1M>',"Cal. Monthly Recur Every");
                  PeriodFromDate := CalcDate(DateFormulaTxt,NextPlannedDate);
                  PeriodToDate := CalcDate('<CM>',PeriodFromDate);
                end;
              end;
          end;
          Error('Unexpected error in FindNextCalendarMonthly().\Asset: %1\Task: %2\NextPlannedDate: %3\NewDate: %4\No date found.',GlobalMaintAsset."No.",GlobalAssetMaintTask."Task Code",NextPlannedDate,NewDate);
        end;
    end;

    local procedure FindNextCalendarYearly() NewDate: Date
    var
        Calendar: Record Date;
        MonthDayNo: Integer;
        MonthLastDayNo: Integer;
        CurrentYear: Integer;
        RecurInMonthNo: Integer;
        SearchLoopNo: Integer;
        LoopNoStart: Integer;
        DateFormulaTxt: Text;
        TempDate: Date;
        PeriodFromDate: Date;
        PeriodToDate: Date;
        MatchingDate: Date;
        MatchCounter: Integer;
        FoundDayMatch: Boolean;
    begin
        with MasterMaintTask do begin
          case "Cal. Yearly Pattern" of
            "Cal. Yearly Pattern"::"Recurring Day of Month" :
              begin
                DateFormulaTxt := StrSubstNo('<%1Y>',"Cal. Yearly Recur Every");
                NewDate := CalcDate(DateFormulaTxt,NextPlannedDate);

                // Adjust day no. of month to nearest Base
                if (BaseFixedMonthDayNo > 0) then begin
                  MonthDayNo := Date2DMY(NewDate,1);
                  if (MonthDayNo <> BaseFixedMonthDayNo) then begin
                    if (MonthDayNo > BaseFixedMonthDayNo) then begin
                      DateFormulaTxt := StrSubstNo('<-CM-1D+%1D>',BaseFixedMonthDayNo);
                    end else begin
                      MonthLastDayNo := Date2DMY(CalcDate('<CM>',NewDate),1);
                      if (MonthLastDayNo < BaseFixedMonthDayNo) then
                        DateFormulaTxt := StrSubstNo('<-CM-1D+%1D>',MonthLastDayNo)
                      else
                        DateFormulaTxt := StrSubstNo('<-CM-1D+%1D>',BaseFixedMonthDayNo);
                    end;
                    NewDate := CalcDate(DateFormulaTxt,NewDate);
                  end;
                end;
                exit(NewDate);
              end;

            "Cal. Yearly Pattern"::"Fixed Day of Month" :
              begin
                RecurInMonthNo := "Cal. Yearly Month Name"; // January is optionvalue 1
                CurrentYear := Date2DMY(NextPlannedDate,3);

                // Check if can schedule day/month in Year of NextPlannedDate
                TempDate := DMY2Date("Cal. Yearly Mth. Fixed Day No.",RecurInMonthNo,CurrentYear);
                if (NextPlannedDate < TempDate) then
                  exit(TempDate);
                // Go the next x year
                TempDate := DMY2Date("Cal. Yearly Mth. Fixed Day No.",RecurInMonthNo,CurrentYear + "Cal. Yearly Recur Every");
                exit(TempDate);
              end;

            "Cal. Yearly Pattern"::"Relative Day of Month" :
              begin
                RecurInMonthNo := "Cal. Yearly Month Name"; // January is optionvalue 1
                CurrentYear := Date2DMY(NextPlannedDate,3);
                PeriodFromDate := DMY2Date(1,RecurInMonthNo,CurrentYear);
                PeriodToDate := CalcDate('<CM>',PeriodFromDate);

                if (PeriodToDate > NextPlannedDate) then begin
                  // Try this year
                  if (NextPlannedDate >= PeriodFromDate) then
                    PeriodFromDate := NextPlannedDate + 1;
                  LoopNoStart := 1;
                end else begin
                  PeriodFromDate := DMY2Date(1,RecurInMonthNo,CurrentYear + "Cal. Yearly Recur Every");
                  PeriodToDate := CalcDate('<CM>',PeriodFromDate);
                  LoopNoStart := 2;
                end;

                 // Search remaining Current month or the Next x Month
                for SearchLoopNo := LoopNoStart to 2 do begin
                  MatchingDate := 0D;
                  MatchCounter := 0;
                  Calendar.Reset;
                  Calendar.SetRange("Period Type",Calendar."Period Type"::Date);
                  Calendar.Get(Calendar."Period Type"::Date,PeriodFromDate);
                  repeat
                    FoundDayMatch := false;
                    // BaseCalendar NOT yet implemented
                    // Treating "Working Day" and "Nonworking Day" as 'Day'
                    case "Cal. Type of Day" of
                      "Cal. Type of Day"::Day,
                      "Cal. Type of Day"::"Working Day",
                      "Cal. Type of Day"::"Nonworking Day" :
                        FoundDayMatch := true;
                      "Cal. Type of Day"::Monday :
                        FoundDayMatch := (Calendar."Period No." = 1);
                      "Cal. Type of Day"::Tuesday :
                        FoundDayMatch := (Calendar."Period No." = 2);
                      "Cal. Type of Day"::Wednesday :
                        FoundDayMatch := (Calendar."Period No." = 3);
                      "Cal. Type of Day"::Thursday :
                        FoundDayMatch := (Calendar."Period No." = 4);
                      "Cal. Type of Day"::Friday :
                        FoundDayMatch := (Calendar."Period No." = 5);
                      "Cal. Type of Day"::Saturday :
                        FoundDayMatch := (Calendar."Period No." = 6);
                      "Cal. Type of Day"::Sunday :
                        FoundDayMatch := (Calendar."Period No." = 7);
                    end;
                    if FoundDayMatch then begin
                      MatchCounter := MatchCounter + 1;
                      MatchingDate := Calendar."Period Start";
                    end;
                    case "Cal. Which Day in Month" of
                      "Cal. Which Day in Month"::First :
                        if (MatchCounter = 1) then
                          exit(MatchingDate);
                      "Cal. Which Day in Month"::Second :
                        if (MatchCounter = 2) then
                          exit(MatchingDate);
                      "Cal. Which Day in Month"::Third :
                        if (MatchCounter = 3) then
                          exit(MatchingDate);
                      "Cal. Which Day in Month"::Fourth :
                        if (MatchCounter = 4) then
                          exit(MatchingDate);
                    end;
                    Calendar.Next(1);
                  until (Calendar."Period Start" > PeriodToDate);

                  case "Cal. Which Day in Month" of
                    "Cal. Which Day in Month"::Last :
                    begin
                      if (MatchCounter > 0) then
                        exit(MatchingDate);
                    end;
                  end;
                  // move dates to next x Year
                  PeriodFromDate := DMY2Date(1,RecurInMonthNo,CurrentYear + "Cal. Yearly Recur Every");
                  PeriodToDate := CalcDate('<CM>',PeriodFromDate);
                end;
              end;
          end;
          Error('Unexpected error in FindNextCalendarYearly(NextPlannedDate: %1). No date found.',NextPlannedDate);
        end;
    end;

    local procedure PrepareFixedDate() Continue: Boolean
    begin
        with GlobalAssetMaintTask do begin
          AssetMTFixedDate.Reset;
          AssetMTFixedDate.SetRange("Asset No.","Asset No.");
          AssetMTFixedDate.SetRange("Task Code","Task Code");
          AssetMTFixedDate.SetRange("Due Date",PlanningStartDate,PlanningEndDate + LeadTimeDays);
          if AssetMTFixedDate.FindSet then
            NextPlannedDate := AssetMTFixedDate."Due Date"
          else
            exit(false);
          exit(NextPlannedDate <> 0D);
        end;
    end;

    local procedure ScheduleFixedDate()
    var
        DoSchedule: Boolean;
    begin
        // Can schedule multiple
        while true do begin
          if NextPlannedDate > PlanningEndDate then begin
            exit;
          end else begin
            if (NextPlannedDate >= PlanningStartDate) and
               (NextPlannedDate > LastScheduledDate) and
               ((GlobalAssetMaintTask."Expiry Date" = 0D) or
                ((GlobalAssetMaintTask."Expiry Date" <> 0D) and (GlobalAssetMaintTask."Expiry Date" >= NextPlannedDate)))
            then begin
              DoSchedule := true;
              if CalledForScheduling then begin
                PlanningWkshLine.SetFilter("Starting Date",'>=%1',NextPlannedDate);
                DoSchedule := PlanningWkshLine.IsEmpty;
              end;
              if DoSchedule then
                InsertBuffer;
            end;
            if (AssetMTFixedDate.Next = 0) then
              exit;
            NextPlannedDate := AssetMTFixedDate."Due Date";
          end;
          if HasReachedMaxTaskRecurrence then
            exit;
        end;
    end;

    local procedure PrepareRecurringUsage() Continue: Boolean
    begin
        with GlobalAssetMaintTask do begin
          if (MasterMaintTask."Usage - Recur Every" <= 0) or
             ("Starting Value (Recurr. Usage)" > (CurrentUsage + "Usage Schedule-Ahead Tolerance")) or
             ("Expiry Value (Recurr. Usage)" <> 0) and (CurrentUsage > "Expiry Value (Recurr. Usage)")
          then
            exit(false);

          // Set usage recurr starting base value
          case MasterMaintTask."Recurring Trigger Calc. Method" of
            MasterMaintTask."Recurring Trigger Calc. Method"::"Fixed Schedule":
              begin
                NextPlannedUsage := "Starting Value (Recurr. Usage)";
              end;
            MasterMaintTask."Recurring Trigger Calc. Method"::"Last Completion":
              begin
                if CalledForScheduling then begin
                  if not PlanningWkshLine.IsEmpty then
                    exit(false);
                end;
                // Skip if incomplete WO exists
                if HasUsageIncompleteOngoingWorkOrder then
                  exit(false);
                if (LastCompletionUsage > 0) and (LastCompletionUsage >= "Starting Value (Recurr. Usage)") then
                  NextPlannedUsage := LastCompletionUsage
                else
                  NextPlannedUsage := "Starting Value (Recurr. Usage)";
              end;
            else
              exit(false);
          end;
          GetNextRecurringUsageValue;
          NextPlannedDate := WorkDate + LeadTimeDays;
          exit(true);
        end;
    end;

    local procedure ScheduleRecurringUsage()
    var
        PrevTriggerUsageValue: Decimal;
        PrevNextPlannedUsage: Decimal;
    begin
        // Schedule Max. One
        while true do begin
          if TriggerUsageValue > CurrentUsage then
            exit;
          PrevNextPlannedUsage := NextPlannedUsage;
          PrevTriggerUsageValue := TriggerUsageValue;

          GetNextRecurringUsageValue;

          if TriggerUsageValue > CurrentUsage then begin
            // Next level was too high. Use previous value
            NextPlannedUsage := PrevNextPlannedUsage;
            TriggerUsageValue := PrevTriggerUsageValue;

            // Check if already scheduled
            // Fixed schedule method
            if (MasterMaintTask."Recurring Trigger Calc. Method" =
                MasterMaintTask."Recurring Trigger Calc. Method"::"Fixed Schedule")
            then begin
              if (LastScheduledUsage < TriggerUsageValue) then
                InsertBuffer;
            end else begin
              // Actual schedule method
              if (LastScheduledUsage < TriggerUsageValue) and
                 (LastCompletionUsage < TriggerUsageValue)
              then
                InsertBuffer;
            end;
            exit;
          end;
          if HasReachedMaxTaskRecurrence then
            exit;
        end;
    end;

    local procedure GetNextRecurringUsageValue()
    begin
        NextPlannedUsage := NextPlannedUsage + MasterMaintTask."Usage - Recur Every";
        TriggerUsageValue := NextPlannedUsage - GlobalAssetMaintTask."Usage Schedule-Ahead Tolerance";
    end;

    local procedure PrepareFixedUsage() Continue: Boolean
    begin
        with GlobalAssetMaintTask do begin
          AssetMTFixedUsage.Reset;
          AssetMTFixedUsage.SetRange("Asset No.","Asset No.");
          AssetMTFixedUsage.SetRange("Task Code","Task Code");
          AssetMTFixedUsage.SetFilter("Usage Value",'>%1',LastScheduledUsage);
          if AssetMTFixedUsage.FindFirst then
            NextPlannedUsage := AssetMTFixedUsage."Usage Value"
          else
            NextPlannedUsage := 0;
          NextPlannedDate := WorkDate + LeadTimeDays;
          exit(NextPlannedUsage > 0);
        end;
    end;

    local procedure ScheduleFixedUsage()
    var
        LastValidMTFixedUsage: Record "MCH Asset M. Task Fixed Usage" temporary;
        LastValidFound: Boolean;
    begin
        // Schedule Max. One
        while true do begin
          TriggerUsageValue := NextPlannedUsage - GlobalAssetMaintTask."Usage Schedule-Ahead Tolerance";
          if (TriggerUsageValue <= CurrentUsage) then begin
            LastValidFound := true;
            LastValidMTFixedUsage := AssetMTFixedUsage;
          end;

          if (AssetMTFixedUsage.Next = 0) or
             ((AssetMTFixedUsage."Usage Value" - GlobalAssetMaintTask."Usage Schedule-Ahead Tolerance") > CurrentUsage)
          then begin
            if LastValidFound then begin
              AssetMTFixedUsage := LastValidMTFixedUsage;
              NextPlannedUsage := AssetMTFixedUsage."Usage Value";
              LeadTimeDays := GlobalAssetMaintTask."Schedule Lead Time (Days)";
              if NextPlannedUsage < CurrentUsage then
                LeadTimeDays := 0;
              NextPlannedDate := WorkDate + LeadTimeDays;

              InsertBuffer;
            end;
            exit;
          end;
          if HasReachedMaxTaskRecurrence then
            exit;
        end;
    end;

    local procedure CheckPrepareRecurrFixedUsageMaintTask() OK: Boolean
    begin
        with GlobalAssetMaintTask do begin
          if ("Usage Monitor Code" = '') then
            exit(false);
          AssetUsageMonitor.Reset;
          AssetUsageMonitor.Get("Asset No.","Usage Monitor Code");
          if not AssetUsageMonitor.IncludeInSchedule then
            exit(false);

          if CalledForScheduling then begin
            if not PlanningWkshLine.IsEmpty then
              exit(false);
          end;

          AssetUsageMonitor.CalcFields("Total Usage");
          CurrentUsage := AssetUsageMonitor."Total Usage";
          if CurrentUsage <= 0 then
            exit(false);
          CalcFields("Last Scheduled Usage Value","Last Completion Usage Value");
          LastScheduledUsage := "Last Scheduled Usage Value";
          LastCompletionUsage := "Last Completion Usage Value";
          exit(true);
        end;
    end;

    local procedure InsertBuffer()
    begin
        ScheduleBuffer.Init;
        NextBufferEntryNo := NextBufferEntryNo + 1;
        ScheduleBuffer."Entry No." := NextBufferEntryNo;
        ScheduleBuffer."Starting Date" := NextPlannedDate;
        ScheduleBuffer."Scheduled Date" := NextPlannedDate;
        ScheduleBuffer."Work Order Type" := WorkOrderType.Code;
        ScheduleBuffer.Priority := SchedulePriority;

        ScheduleBuffer."Work Order No." := '';
        ScheduleBuffer."Asset No." := GlobalMaintAsset."No.";
        ScheduleBuffer."Asset Description" := GlobalMaintAsset.Description;
        ScheduleBuffer."Asset Description 2" := GlobalMaintAsset."Description 2";
        ScheduleBuffer."Asset Category Code" := GlobalMaintAsset."Category Code";

        ScheduleBuffer."Responsibility Group Code" := GlobalMaintAsset."Responsibility Group Code";
        ScheduleBuffer."Maint. Location Code" := GlobalMaintAsset."Fixed Maint. Location Code";
        if ScheduleBuffer."Maint. Location Code" = '' then
          ScheduleBuffer."Maint. Location Code" := DefaultMaintLocationCode;
        if ScheduleBuffer."Maint. Location Code" = '' then
          ScheduleBuffer."Maint. Location Code" := UserDefaultMaintLocationCode;

        ScheduleBuffer."Task Code" := MasterMaintTask.Code;
        ScheduleBuffer."Task Description" := MasterMaintTask.Description;
        ScheduleBuffer."Task Description 2" := MasterMaintTask."Description 2";
        ScheduleBuffer."Trigger Method" := MasterMaintTask."Trigger Method";
        ScheduleBuffer."Trigger Description" := MasterMaintTask."Trigger Description";
        ScheduleBuffer."Recurr. Trigger Calc. Method" := MasterMaintTask."Recurring Trigger Calc. Method";
        ScheduleBuffer."Lead Time (Days)" := LeadTimeDays;
        ScheduleBuffer."Last Completion Date" := LastCompletionDate;
        ScheduleBuffer."Last Scheduled Date" := LastScheduledDate;

        case MasterMaintTask."Trigger Method" of
          MasterMaintTask."Trigger Method"::"Calendar (Recurring)",
          MasterMaintTask."Trigger Method"::"Fixed Date by Asset":
            begin
            end;
          MasterMaintTask."Trigger Method"::"Usage (Recurring)",
          MasterMaintTask."Trigger Method"::"Fixed Usage by Asset" :
            begin
              ScheduleBuffer."Usage Monitor Code" := GlobalAssetMaintTask."Usage Monitor Code";
              ScheduleBuffer."Usage Tolerance" := GlobalAssetMaintTask."Usage Schedule-Ahead Tolerance";
              ScheduleBuffer."Current Usage" := CurrentUsage;
              ScheduleBuffer."Last Actual Usage" := LastCompletionUsage;
              ScheduleBuffer."Last Scheduled Usage" := LastScheduledUsage;
              ScheduleBuffer."Scheduled Usage" := NextPlannedUsage;
            end;
        end;

        ScheduleBuffer.Insert;
        TaskRecurrenceCounter := TaskRecurrenceCounter + 1;
        HasReachedMaxTaskRecurrence := (TaskRecurrenceCounter >= MaxTaskRecurrence);
    end;

    local procedure InitializeNewMaintTaskCalculation(NewAssetMaintTask: Record "MCH Asset Maintenance Task")
    var
        NoRespGroupAccess: Boolean;
    begin
        if DoNotClearBufferPerAssetTask then begin
          ScheduleBuffer.Reset;
          if ScheduleBuffer.FindLast then
            NextBufferEntryNo := ScheduleBuffer."Entry No."
          else
            NextBufferEntryNo := 0;
        end else
          ClearScheduleBuffer;

        GlobalAssetMaintTask.Get(NewAssetMaintTask."Asset No.",NewAssetMaintTask."Task Code");
        GlobalMaintAsset.Get(GlobalAssetMaintTask."Asset No.");

        InitializeSetup;

        if CalledForScheduling or CalledForForecast then begin
          AMFunctions.CheckAssetMandatoryFields(GlobalMaintAsset);
          if UserHasAssetRespGroupFilter then begin
            if (GlobalMaintAsset."Responsibility Group Code" = '') then
              NoRespGroupAccess := true
            else
              NoRespGroupAccess := not MaintUserMgt.UserHasAccessToRespGroup(UserId,GlobalMaintAsset."Responsibility Group Code");
            if NoRespGroupAccess then
              Error(Text004,
                GlobalMaintAsset.TableCaption,GlobalMaintAsset."No.",
                GlobalMaintAsset.FieldCaption("Responsibility Group Code"),GlobalMaintAsset."Responsibility Group Code");
          end;
        end;

        HasReachedMaxTaskRecurrence := false;
        TaskRecurrenceCounter := 0;
        BaseFixedMonthDayNo := 0;

        NextPlannedDate := 0D;
        LeadTimeDays := 0;
        LeadTimeDate := 0D;

        CurrentUsage := 0;
        NextPlannedUsage := 0;
        TriggerUsageValue := 0;
        LastScheduledUsage := 0;
        LastCompletionUsage := 0;

        PlanningWkshLine.Reset;
        PlanningWkshLine.SetCurrentKey("Asset No.","Task Code","Starting Date");
        PlanningWkshLine.SetRange("Asset No.",GlobalMaintAsset."No.");
        PlanningWkshLine.SetRange("Task Code",GlobalAssetMaintTask."Task Code");
    end;

    local procedure InitializeSetup()
    var
        MaxPeriodDays: Integer;
    begin
        if HasInitializedSetup then
          exit;

        AMSetup.Get;
        if not MaintUserMgt.GetMaintenanceUser(UserId,MaintUser) then begin
          if CalledForScheduling then
            Error(GetLastErrorText);
        end else begin
          UserHasAssetRespGroupFilter := MaintUserMgt.UserHasAssetRespGroupFilter;
        end;
        UserDefaultMaintLocationCode := MaintUserMgt.GetDefaultMaintLocationCode;

        PlanningStartDate := CustomPlanningStartDate;
        PlanningEndDate := CustomPlanningEndDate;
        MaxTaskRecurrence := CustomTaskRecurrenceLimit;
        if (PlanningStartDate = 0D) then begin
          PlanningStartDate := WorkDate;
          PlanningEndDate := 0D;
        end;

        case true of
          CalledForScheduling:
            begin
              MaxPeriodDays := AMSetup."Max. Sched. Look Ahead (Days)";
              if (PlanningEndDate = 0D) then
                PlanningEndDate := PlanningStartDate + AMSetup."Def. Sched. Look Ahead (Days)" - 1;
              if (not (MaxTaskRecurrence in [1..AMSetup."Schedule Task Recurr. Limit"])) then
                MaxTaskRecurrence := AMSetup."Def. Sched. Task Recurr. Limit";
            end;
          CalledForForecast:
            begin
              MaxPeriodDays := AMSetup."Forecast Look Ahead (Days)";
              if (PlanningEndDate = 0D) then
                PlanningEndDate := PlanningStartDate + AMSetup."Def. FCast Look Ahead (Days)" - 1;
              if (not (MaxTaskRecurrence in [1..AMSetup."Forecast Task Recurr. Limit"])) then
                MaxTaskRecurrence := AMSetup."Def. FCast Task Recurr. Limit";
            end;
          CalledForNextForecastOnly:
            begin
              MaxPeriodDays := AMSetup."Forecast Look Ahead (Days)";
              if (PlanningEndDate = 0D) then
                PlanningEndDate := PlanningStartDate + AMSetup."Def. FCast Look Ahead (Days)" - 1;
              MaxTaskRecurrence := 1;
            end;
          else
            Error('Called from...?');
        end;

        if PlanningStartDate = 0D then
          Error(Text001);
        if PlanningEndDate = 0D then
          Error(Text002);
        if PlanningStartDate > PlanningEndDate then
          Error(Text003);
        if (PlanningEndDate - PlanningStartDate + 1) > MaxPeriodDays then
          Error(Text005,PlanningStartDate,PlanningEndDate,MaxPeriodDays);

        HasInitializedSetup := true;
    end;

    local procedure DateIsInPeriod(TheDate: Date;PeriodFromDate: Date;PeriodToDate: Date) OK: Boolean
    begin
        exit(
          (TheDate >= PeriodFromDate) and
          ((PeriodToDate = 0D) or
           ((PeriodToDate <> 0D) and (PeriodToDate >= TheDate))));
    end;


    procedure SetDoNotClearBufferPerAssetTask(Set: Boolean)
    begin
        DoNotClearBufferPerAssetTask := Set;
    end;


    procedure SetCustomCalcParameters(NewCustomPlanningStartDate: Date;NewCustomPlanningEndDate: Date;NewCustomTaskRecurrenceLimit: Integer;NewDefaultMaintLocationCode: Code[20];NewSkipTasksOnPlanningWksh: Boolean)
    begin
        CustomPlanningStartDate := NewCustomPlanningStartDate;
        CustomPlanningEndDate := NewCustomPlanningEndDate;
        CustomTaskRecurrenceLimit := NewCustomTaskRecurrenceLimit;
        DefaultMaintLocationCode := NewDefaultMaintLocationCode;
        SkipTasksOnPlanningWksh := NewSkipTasksOnPlanningWksh;
    end;


    procedure ClearScheduleBuffer()
    begin
        ScheduleBuffer.Reset;
        if not ScheduleBuffer.IsEmpty then
          ScheduleBuffer.DeleteAll;
        NextBufferEntryNo := 0;
    end;


    procedure ShareResultScheduleBuffer(var SharedScheduleBuffer: Record "MCH Maint. Schedule Buffer" temporary)
    begin
        ScheduleBuffer.Reset;
        SharedScheduleBuffer.Reset;
        SharedScheduleBuffer.Copy(ScheduleBuffer,true);
    end;


    procedure InitialiseCalcParameters(InitForScheduling: Boolean;ShiftForwardPeriodStartToWorkDate: Boolean;var NewStartingDate: Date;var NewEndingDate: Date;var NewTaskRecurrenceLimit: Integer;var NewDefMaintLocationCode: Code[20])
    var
        MaxPeriodDays: Integer;
        DefPeriodDays: Integer;
        MaxTaskRecurLimit: Integer;
        DefTaskRecurLimit: Integer;
        PeriodDays: Integer;
    begin
        AMSetup.Get;
        if AMSetup."Asset Fixed Maint. Loc. Mand." then
          NewDefMaintLocationCode := ''
        else begin
          if (NewDefMaintLocationCode = '') then begin
            MaintUserMgt.GetMaintenanceUser('',MaintUser);
            NewDefMaintLocationCode := MaintUser."Default Maint. Location Code";
          end;
        end;

        if InitForScheduling then begin
          MaxPeriodDays := AMSetup."Max. Sched. Look Ahead (Days)";
          DefPeriodDays := AMSetup."Def. Sched. Look Ahead (Days)";
          MaxTaskRecurLimit := AMSetup."Schedule Task Recurr. Limit";
          DefTaskRecurLimit := AMSetup."Def. Sched. Task Recurr. Limit";
        end else begin
          MaxPeriodDays := AMSetup."Forecast Look Ahead (Days)";
          DefPeriodDays := AMSetup."Def. FCast Look Ahead (Days)";
          MaxTaskRecurLimit := AMSetup."Forecast Task Recurr. Limit";
          DefTaskRecurLimit := AMSetup."Def. FCast Task Recurr. Limit";
        end;

        if (NewStartingDate = 0D) then begin
          NewStartingDate := WorkDate;
          NewEndingDate := 0D;
        end else begin
          if (NewEndingDate >= NewStartingDate) then
            PeriodDays := (NewEndingDate - NewStartingDate + 1);
        end;
        if (not (PeriodDays in [1..MaxPeriodDays])) then
          PeriodDays := DefPeriodDays;

        if ShiftForwardPeriodStartToWorkDate and (NewStartingDate < WorkDate) then
          NewStartingDate := WorkDate;
        NewEndingDate := NewStartingDate + PeriodDays - 1;

        if (not (NewTaskRecurrenceLimit in [1..MaxTaskRecurLimit])) then
          NewTaskRecurrenceLimit := DefTaskRecurLimit;
    end;
}

