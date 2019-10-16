codeunit 74033 "MCH Maint. Task Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        FixedDatesByAssetText: Label 'Fixed Dates';
        FixedUsageByAssetText: Label 'Fixed Usage';
        RecurrDailyDayType: Label 'Daily,Every %1,Every %1';
        RecurrDailyDayType2: Label 'Every %1 Days,Every %1 Working Days,Every %1 Nonworking Days';
        RecurrDailyText: Label 'Every %1';
        RecurrDailyText2: Label 'Every %1 %2';
        RecurrWeeklyText: Label 'Weekly on %1';
        RecurrWeeklyText2: Label 'Every %2 Weeks on %1';
        RecurrMonthlyDayNoText: Label 'Monthly on Day %1';
        RecurrMonthlyDayNoText2: Label 'Every %2 Months on Day %1';
        RecurrMonthlyAssetDateText: Label 'Monthly';
        RecurrMonthlyAssetDateText2: Label 'Every %1 Months';
        RecurrMonthlyDayRelativeText: Label 'Monthly on the %1 %2';
        RecurrMonthlyDayRelativeText2: Label 'Every %3 Months on the %1 %2';
        RecurrYearlyMonthAssetDateText: Label 'Yearly';
        RecurrYearlyMonthAssetDateText2: Label 'Every %1 Years';
        RecurrYearlyMonthDayNoText: Label 'Yearly on %1 %2';
        RecurrYearlyMonthDayNoText2: Label 'Every %3 Years on %1 %2';
        RecurrYearlyMonthDayRelativeText: Label 'Yearly on the %1 %2 of %3';
        RecurrYearlyMonthDayRelativeText2: Label 'Every %4 Years on the %1 %2 of %3';
        WeekdayNamesLong: Label 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
        WeekdayNamesShort: Label 'Mon,Tue,Wed,Thu,Fri,Sat,Sun';
        RecurrUsageText: Label 'Every %1 Units of Usage';
        TriggerDescriptionErrorText: Label 'ERROR: %1';

    [TryFunction]

    procedure CheckMasterTaskSetup(var MasterMaintTask: Record "MCH Master Maintenance Task")
    var
        Text001: Label 'The value of %1 is invalid (%2).';
    begin
        with MasterMaintTask do begin
          case "Trigger Method" of
            "Trigger Method"::"Calendar (Recurring)":
              CheckCalendarTriggerFields(MasterMaintTask);
            "Trigger Method"::"Usage (Recurring)":
              CheckUsageTriggerFields(MasterMaintTask);
            "Trigger Method"::Manual,
            "Trigger Method"::"Fixed Date by Asset",
            "Trigger Method"::"Fixed Usage by Asset" :
              ; // No checks
            else
              Error(Text001,FieldCaption("Trigger Method"),"Trigger Method");
          end;
        end;
    end;

    [TryFunction]

    procedure CheckUsageTriggerFields(var MasterMaintTask: Record "MCH Master Maintenance Task")
    var
        Text001: Label '%1 must be specified.';
    begin
        with MasterMaintTask do begin
          if ("Trigger Method" <> "Trigger Method"::"Usage (Recurring)") then begin
            exit;
          end;
          if ("Usage - Recur Every" <= 0) then
            Error(Text001,FieldCaption("Usage - Recur Every"));
        end;
    end;

    [TryFunction]

    procedure CheckCalendarTriggerFields(var MasterMaintTask: Record "MCH Master Maintenance Task")
    var
        Text001: Label 'No days of the week selected in %1 %2.';
        Text002: Label 'The number of days in %1 is %2.';
        Text003: Label 'The Day No. for February cannot be more than 28.';
        Text004: Label '%1 must be specified.';
        Text005: Label 'The value of %1 is invalid (%2).';
    begin
        with MasterMaintTask do begin
          if ("Trigger Method" <> "Trigger Method"::"Calendar (Recurring)") then begin
            exit;
          end;
          if ("Calendar Recurrence Type" = "Calendar Recurrence Type"::" ") then
            Error(Text004,FieldCaption("Calendar Recurrence Type"));

          case "Calendar Recurrence Type" of
            "Calendar Recurrence Type"::Daily :
              begin
                if ("Cal. Daily Recur Every" <= 0) then
                  Error(Text004,FieldCaption("Cal. Daily Recur Every"));
                CheckCalendarRecurEveryValue(MasterMaintTask,FieldCaption("Cal. Daily Recur Every"),"Cal. Daily Recur Every",false);
                if ("Cal. Daily Type of Day" = "Cal. Daily Type of Day"::" ") then
                  Error(Text004,FieldCaption("Cal. Daily Type of Day"));
              end;
            "Calendar Recurrence Type"::Weekly :
              begin
                if ("Cal. Weekly Recur Every" <= 0) then
                  Error(Text004,FieldCaption("Cal. Weekly Recur Every"));
                CheckCalendarRecurEveryValue(MasterMaintTask,FieldCaption("Cal. Weekly Recur Every"),"Cal. Weekly Recur Every",false);
                if not (
                  "Cal. Weekly on Monday" or "Cal. Weekly on Tuesday" or "Cal. Weekly on Wednesday" or "Cal. Weekly on Thursday" or
                  "Cal. Weekly on Friday" or "Cal. Weekly on Saturday" or "Cal. Weekly on Sunday")
                then
                  Error(Text001,TableCaption,Code);
              end;

            "Calendar Recurrence Type"::Monthly :
              begin
                if ("Cal. Monthly Pattern" = "Cal. Monthly Pattern"::" ") then
                  Error(Text004,FieldCaption("Cal. Monthly Pattern"));
                if ("Cal. Monthly Recur Every" <= 0) then
                  Error(Text004,FieldCaption("Cal. Monthly Recur Every"));
                CheckCalendarRecurEveryValue(MasterMaintTask,FieldCaption("Cal. Monthly Recur Every"),"Cal. Monthly Recur Every",false);

                case "Cal. Monthly Pattern" of
                  "Cal. Monthly Pattern"::"Recurring Day of Month" :
                    begin
                    end;
                  "Cal. Monthly Pattern"::"Fixed Day of Month" :
                    begin
                      if ("Cal. Monthly Fixed Day No." <= 0) then
                        Error(Text004,FieldCaption("Cal. Monthly Fixed Day No."));
                    end;
                  "Cal. Monthly Pattern"::"Relative Day of Month" :
                    begin
                      if ("Cal. Which Day in Month" = "Cal. Which Day in Month"::" ") then
                        Error(Text004,FieldCaption("Cal. Which Day in Month"));
                      if ("Cal. Type of Day" = "Cal. Type of Day"::" ") then
                        Error(Text004,FieldCaption("Cal. Type of Day"));
                    end;
                  else
                    Error(Text005,FieldCaption("Cal. Monthly Pattern"),"Cal. Monthly Pattern");
                end
              end;

            "Calendar Recurrence Type"::Yearly :
              begin
                if ("Cal. Yearly Pattern" = "Cal. Yearly Pattern"::" ") then
                  Error(Text004,FieldCaption("Cal. Yearly Pattern"));
                if ("Cal. Yearly Recur Every" <= 0) then
                  Error(Text004,FieldCaption("Cal. Yearly Recur Every"));

                CheckCalendarRecurEveryValue(MasterMaintTask,FieldCaption("Cal. Yearly Recur Every"),"Cal. Yearly Recur Every",false);
                if ("Cal. Yearly Pattern" in ["Cal. Yearly Pattern"::"Fixed Day of Month","Cal. Yearly Pattern"::"Relative Day of Month"]) then begin
                  case "Cal. Yearly Month Name" of
                    "Cal. Yearly Month Name"::January,
                    "Cal. Yearly Month Name"::March,
                    "Cal. Yearly Month Name"::May,
                    "Cal. Yearly Month Name"::July,
                    "Cal. Yearly Month Name"::August,
                    "Cal. Yearly Month Name"::October,
                    "Cal. Yearly Month Name"::December :
                      if ("Cal. Yearly Mth. Fixed Day No." > 31) then
                        Error(Text002,"Cal. Yearly Month Name",31);
                    "Cal. Yearly Month Name"::April,
                    "Cal. Yearly Month Name"::June,
                    "Cal. Yearly Month Name"::September,
                    "Cal. Yearly Month Name"::November :
                      if ("Cal. Yearly Mth. Fixed Day No." > 30) then
                        Error(Text002,"Cal. Yearly Month Name",30);
                    "Cal. Yearly Month Name"::February :
                      if ("Cal. Yearly Mth. Fixed Day No." > 28) then
                        Error(Text003);
                    else
                      Error(Text005,FieldCaption("Cal. Yearly Month Name"),"Cal. Yearly Month Name");
                  end;
                end;
                case "Cal. Yearly Pattern" of
                  "Cal. Yearly Pattern"::"Recurring Day of Month" :
                    begin
                    end;
                  "Cal. Yearly Pattern"::"Fixed Day of Month" :
                    begin
                      if ("Cal. Yearly Mth. Fixed Day No." <= 0) then
                        Error(Text004,FieldCaption("Cal. Yearly Mth. Fixed Day No."));
                    end;
                  "Cal. Yearly Pattern"::"Relative Day of Month" :
                    begin
                      if ("Cal. Which Day in Month" = "Cal. Which Day in Month"::" ") then
                        Error(Text004,FieldCaption("Cal. Which Day in Month"));
                      if ("Cal. Type of Day" = "Cal. Type of Day"::" ") then
                        Error(Text004,FieldCaption("Cal. Type of Day"));
                    end;
                  else
                    Error(Text005,FieldCaption("Cal. Yearly Pattern"),"Cal. Yearly Pattern");
                end;
              end;
            else
              Error(Text005,FieldCaption("Calendar Recurrence Type"),"Calendar Recurrence Type");
          end;
        end;
    end;


    procedure CheckCalendarRecurEveryValue(var MasterMaintTask: Record "MCH Master Maintenance Task";TheFieldCaption: Text;TheFieldValue: Integer;AllowZero: Boolean)
    var
        MinValue: Integer;
        MaxValue: Integer;
        ValueRangeErr: Label 'The value of %1 is invalid (%2). The value must be between %3 and %4.';
    begin
        if AllowZero then
          MinValue := 0
        else
          MinValue := 1;
        with MasterMaintTask do begin
          case TheFieldCaption of
            FieldCaption("Cal. Daily Recur Every") : MaxValue := 999;
            FieldCaption("Cal. Weekly Recur Every") : MaxValue := 99;
            FieldCaption("Cal. Monthly Recur Every") : MaxValue := 36;
            FieldCaption("Cal. Yearly Recur Every") : MaxValue := 5;
            else
              exit;
          end;
          if not (TheFieldValue in [MinValue..MaxValue]) then
            Error(ValueRangeErr,TheFieldCaption,TheFieldValue,MinValue,MaxValue);
        end;
    end;

    [TryFunction]

    procedure FindMasterMaintTaskTriggerDescription(var MasterMaintTask: Record "MCH Master Maintenance Task";var TriggerMethodDescription: Text)
    begin
        ComposeTriggerMethodDescription(MasterMaintTask,TriggerMethodDescription);
    end;

    [TryFunction]
    local procedure ComposeTriggerMethodDescription(var MasterMaintTask: Record "MCH Master Maintenance Task";var TriggerMethodDescription: Text)
    var
        DayArray: array [7] of Boolean;
        WeekdayList: Text;
        DayListShort: Text;
        DayListLong: Text;
        i: Integer;
        NoOfWeekdays: Integer;
    begin
        TriggerMethodDescription := '';
        if not CheckMasterTaskSetup(MasterMaintTask) then begin
          TriggerMethodDescription := StrSubstNo(TriggerDescriptionErrorText,GetLastErrorText);
          exit;
        end;

        with MasterMaintTask do begin
          case "Trigger Method" of
            "Trigger Method"::Manual:
              TriggerMethodDescription := Format("Trigger Method");
            "Trigger Method"::"Usage (Recurring)":
              TriggerMethodDescription := StrSubstNo(RecurrUsageText,"Usage - Recur Every");
            "Trigger Method"::"Fixed Date by Asset":
              TriggerMethodDescription := FixedDatesByAssetText;
            "Trigger Method"::"Fixed Usage by Asset":
              TriggerMethodDescription := FixedUsageByAssetText;
            "Trigger Method"::"Calendar (Recurring)":
              begin
                case "Calendar Recurrence Type" of
                  "Calendar Recurrence Type"::Daily :
                    begin
                      if ("Cal. Daily Recur Every" = 1) then
                        TriggerMethodDescription := StrSubstNo(SelectStr("Cal. Daily Type of Day",RecurrDailyDayType),"Cal. Daily Type of Day")
                      else
                        TriggerMethodDescription := StrSubstNo(SelectStr("Cal. Daily Type of Day",RecurrDailyDayType2),"Cal. Daily Recur Every");
                    end;
                  "Calendar Recurrence Type"::Weekly :
                    begin
                      DayArray[1] := "Cal. Weekly on Monday";
                      DayArray[2] := "Cal. Weekly on Tuesday";
                      DayArray[3] := "Cal. Weekly on Wednesday";
                      DayArray[4] := "Cal. Weekly on Thursday";
                      DayArray[5] := "Cal. Weekly on Friday";
                      DayArray[6] := "Cal. Weekly on Saturday";
                      DayArray[7] := "Cal. Weekly on Sunday";
                      for i := 1 to 7 do begin
                        if DayArray[i] then begin
                          NoOfWeekdays := NoOfWeekdays + 1;
                          DayListLong := StrSubstNo('%1, %2',DayListLong,SelectStr(i,WeekdayNamesLong));
                          DayListShort := StrSubstNo('%1, %2',DayListShort,SelectStr(i,WeekdayNamesShort));
                        end;
                      end;
                      if ("Cal. Weekly Recur Every" = 1) then begin
                        if (NoOfWeekdays < 4) then
                          WeekdayList := DayListLong
                        else
                          WeekdayList := DayListShort;
                        TriggerMethodDescription := StrSubstNo(RecurrWeeklyText,DelChr(WeekdayList,'<>',' ,'));
                      end else begin
                        if (NoOfWeekdays < 4) then
                          WeekdayList := DayListLong
                        else
                          WeekdayList := DayListShort;
                        TriggerMethodDescription := StrSubstNo(RecurrWeeklyText2,DelChr(WeekdayList,'<>',' ,'),"Cal. Weekly Recur Every");
                      end;
                    end;

                  "Calendar Recurrence Type"::Monthly :
                    begin
                      case "Cal. Monthly Pattern" of
                        "Cal. Monthly Pattern"::"Recurring Day of Month" :
                          begin
                            if ("Cal. Monthly Recur Every" = 1) then
                              TriggerMethodDescription := RecurrMonthlyAssetDateText
                            else
                              TriggerMethodDescription := StrSubstNo(RecurrMonthlyAssetDateText2,"Cal. Monthly Recur Every");
                          end;
                        "Cal. Monthly Pattern"::"Fixed Day of Month" :
                          begin
                            if ("Cal. Monthly Recur Every" = 1) then
                              TriggerMethodDescription := StrSubstNo(RecurrMonthlyDayNoText,"Cal. Monthly Fixed Day No.")
                            else
                              TriggerMethodDescription := StrSubstNo(RecurrMonthlyDayNoText2,"Cal. Monthly Fixed Day No.","Cal. Monthly Recur Every");
                          end;
                        "Cal. Monthly Pattern"::"Relative Day of Month" :
                          begin
                            if ("Cal. Monthly Recur Every" = 1) then
                              TriggerMethodDescription := StrSubstNo(RecurrMonthlyDayRelativeText,"Cal. Which Day in Month","Cal. Type of Day")
                            else
                              TriggerMethodDescription := StrSubstNo(RecurrMonthlyDayRelativeText2,"Cal. Which Day in Month","Cal. Type of Day","Cal. Monthly Recur Every");
                          end;
                      end
                    end;

                  "Calendar Recurrence Type"::Yearly :
                    begin
                      case "Cal. Yearly Pattern" of
                        "Cal. Yearly Pattern"::"Recurring Day of Month" :
                          begin
                            if ("Cal. Yearly Recur Every" = 1) then
                              TriggerMethodDescription := RecurrYearlyMonthAssetDateText
                            else
                              TriggerMethodDescription := StrSubstNo(RecurrYearlyMonthAssetDateText2,"Cal. Yearly Recur Every");
                          end;
                        "Cal. Yearly Pattern"::"Fixed Day of Month" :
                          begin
                            if ("Cal. Yearly Recur Every" = 1) then
                              TriggerMethodDescription := StrSubstNo(RecurrYearlyMonthDayNoText,"Cal. Yearly Month Name","Cal. Yearly Mth. Fixed Day No.")
                            else
                              TriggerMethodDescription := StrSubstNo(RecurrYearlyMonthDayNoText2,"Cal. Yearly Month Name","Cal. Yearly Mth. Fixed Day No.","Cal. Yearly Recur Every");
                          end;
                        "Cal. Yearly Pattern"::"Relative Day of Month" :
                          begin
                            if ("Cal. Yearly Recur Every" = 1) then
                              TriggerMethodDescription := StrSubstNo(RecurrYearlyMonthDayRelativeText,"Cal. Which Day in Month","Cal. Type of Day","Cal. Yearly Month Name")
                            else
                              TriggerMethodDescription := StrSubstNo(RecurrYearlyMonthDayRelativeText2,"Cal. Which Day in Month","Cal. Type of Day","Cal. Yearly Month Name","Cal. Yearly Recur Every");
                          end;
                      end;
                    end;
                end;
            end;
          end;
          TriggerMethodDescription := DelChr(TriggerMethodDescription,'<>',' ');
        end;
    end;


    procedure InitializeMasterMaintTaskTriggerFields(var MasterMaintTask: Record "MCH Master Maintenance Task")
    var
        Text001: Label 'The value of %1 is invalid (%2) in %3 %4.';
    begin
        with MasterMaintTask do begin
          case "Trigger Method" of
            "Trigger Method"::"Calendar (Recurring)":
              InitializeCalendarTriggerFields(MasterMaintTask);
            "Trigger Method"::"Usage (Recurring)":
              InitializeRecurUsageTriggerFields(MasterMaintTask);
            "Trigger Method"::Manual,
            "Trigger Method"::"Fixed Date by Asset",
            "Trigger Method"::"Fixed Usage by Asset" :
              begin
                "Recurring Trigger Calc. Method" := "Recurring Trigger Calc. Method"::" ";
              end;
            else
              Error(Text001,FieldCaption("Trigger Method"),"Trigger Method",TableCaption,Code);
          end;
        end;
    end;

    local procedure InitializeCalendarTriggerFields(var MasterMaintTask: Record "MCH Master Maintenance Task")
    begin
        with MasterMaintTask do begin
          if ("Trigger Method" <> "Trigger Method"::"Calendar (Recurring)") then
            exit;
          if not ("Recurring Trigger Calc. Method" in ["Recurring Trigger Calc. Method"::"Fixed Schedule","Recurring Trigger Calc. Method"::"Last Completion"]) then
            "Recurring Trigger Calc. Method" := "Recurring Trigger Calc. Method"::"Fixed Schedule";

          if not ("Calendar Recurrence Type" in ["Calendar Recurrence Type"::Daily.."Calendar Recurrence Type"::Yearly]) then
            "Calendar Recurrence Type" := "Calendar Recurrence Type"::Daily;

          if ("Cal. Which Day in Month" = "Cal. Which Day in Month"::" ") then
            "Cal. Which Day in Month" := "Cal. Which Day in Month"::First;
          if ("Cal. Type of Day" <> "Cal. Type of Day"::Day) then
            "Cal. Type of Day" := "Cal. Type of Day"::Day;

          if ("Cal. Daily Recur Every" = 0) then
            "Cal. Daily Recur Every" := 1;
          if ("Cal. Daily Type of Day" = "Cal. Daily Type of Day"::" ") then
            "Cal. Daily Type of Day" := "Cal. Daily Type of Day"::Day;

          if ("Cal. Weekly Recur Every" = 0) then
            "Cal. Weekly Recur Every" := 1;
          if not (
            "Cal. Weekly on Monday" or "Cal. Weekly on Tuesday" or "Cal. Weekly on Wednesday" or "Cal. Weekly on Thursday" or
            "Cal. Weekly on Friday" or "Cal. Weekly on Saturday" or "Cal. Weekly on Sunday")
          then
            "Cal. Weekly on Monday" := true;

          if ("Cal. Monthly Pattern" = "Cal. Monthly Pattern"::" ") then
            "Cal. Monthly Pattern" := "Cal. Monthly Pattern"::"Recurring Day of Month";
          if ("Cal. Monthly Recur Every" = 0) then
            "Cal. Monthly Recur Every" := 1;
          if ("Cal. Monthly Fixed Day No." = 0) then
            "Cal. Monthly Fixed Day No." := Date2DMY(WorkDate,1);

          if ("Cal. Yearly Pattern" = "Cal. Yearly Pattern"::" ") then
            "Cal. Yearly Pattern" := "Cal. Yearly Pattern"::"Recurring Day of Month";
          if ("Cal. Yearly Recur Every" = 0) then
            "Cal. Yearly Recur Every" := 1;
          if ("Cal. Yearly Month Name" = "Cal. Yearly Month Name"::" ") then
            "Cal. Yearly Month Name" := Date2DMY(WorkDate,2);
          if ("Cal. Yearly Mth. Fixed Day No." = 0) then
            "Cal. Yearly Mth. Fixed Day No." := Date2DMY(WorkDate,1);
        end;
    end;

    local procedure InitializeRecurUsageTriggerFields(var MasterMaintTask: Record "MCH Master Maintenance Task")
    begin
        with MasterMaintTask do begin
          if ("Trigger Method" <> "Trigger Method"::"Usage (Recurring)") then
            exit;
          if not ("Recurring Trigger Calc. Method" in ["Recurring Trigger Calc. Method"::"Fixed Schedule","Recurring Trigger Calc. Method"::"Last Completion"]) then
            "Recurring Trigger Calc. Method" := "Recurring Trigger Calc. Method"::"Fixed Schedule";
          if ("Usage - Recur Every" < 0) then
            "Usage - Recur Every" := 0;
        end;
    end;

    local procedure "FIELDS"(var MasterMaintTask: Record "MCH Master Maintenance Task")
    begin
        with MasterMaintTask do begin
        // General
          case "Calendar Recurrence Type" of
            "Calendar Recurrence Type"::" " : ;
            "Calendar Recurrence Type"::Daily : ;
            "Calendar Recurrence Type"::Weekly : ;
            "Calendar Recurrence Type"::Monthly : ;
            "Calendar Recurrence Type"::Yearly : ;
          end;

        // Daily
          "Cal. Daily Recur Every" := 0;
          case "Cal. Daily Type of Day" of
            "Cal. Daily Type of Day"::" " : ;
            "Cal. Daily Type of Day"::Day : ;
            "Cal. Daily Type of Day"::"Working Day" : ;
            "Cal. Daily Type of Day"::"Nonworking Day" : ;
          end;

        // Weekly
          "Cal. Weekly Recur Every" := 0;
          "Cal. Weekly on Monday" := false;
          "Cal. Weekly on Tuesday" := false;
          "Cal. Weekly on Wednesday" := false;
          "Cal. Weekly on Thursday" := false;
          "Cal. Weekly on Friday" := false;
          "Cal. Weekly on Saturday" := false;
          "Cal. Weekly on Sunday" := false;

        // Monthly
          case "Cal. Monthly Pattern" of
            "Cal. Monthly Pattern"::" " : ;
            "Cal. Monthly Pattern"::"Recurring Day of Month" : ;
            "Cal. Monthly Pattern"::"Fixed Day of Month" : ;
            "Cal. Monthly Pattern"::"Relative Day of Month" : ;
          end;

          // -Day No. and Relative
          "Cal. Monthly Recur Every" := 0;

          // -Day No.
          "Cal. Monthly Fixed Day No." := 0;

          // -Day Relative
          // Used by Monthly and Yearly
          case "Cal. Type of Day" of
            "Cal. Type of Day"::" " : ;
            "Cal. Type of Day"::Day : ;
            "Cal. Type of Day"::"Working Day" : ;
            "Cal. Type of Day"::"Nonworking Day" : ;
            "Cal. Type of Day"::Monday : ;
            "Cal. Type of Day"::Tuesday : ;
            "Cal. Type of Day"::Wednesday : ;
            "Cal. Type of Day"::Thursday : ;
            "Cal. Type of Day"::Friday : ;
            "Cal. Type of Day"::Saturday : ;
            "Cal. Type of Day"::Sunday : ;
          end;
          case "Cal. Which Day in Month" of
            "Cal. Which Day in Month"::" " : ;
            "Cal. Which Day in Month"::First : ;
            "Cal. Which Day in Month"::Second : ;
            "Cal. Which Day in Month"::Third : ;
            "Cal. Which Day in Month"::Fourth : ;
            "Cal. Which Day in Month"::Last : ;
          end;

        // Yearly
          case "Cal. Yearly Pattern" of
            "Cal. Yearly Pattern"::" " : ;
            "Cal. Yearly Pattern"::"Recurring Day of Month" : ;
            "Cal. Yearly Pattern"::"Fixed Day of Month" : ;
            "Cal. Yearly Pattern"::"Relative Day of Month" : ;
          end;

          // -Day No. and Relative
          "Cal. Yearly Recur Every" := 0;
          case "Cal. Yearly Month Name" of
            "Cal. Yearly Month Name"::" " : ;
            "Cal. Yearly Month Name"::January : ;
            "Cal. Yearly Month Name"::February : ;
            "Cal. Yearly Month Name"::March : ;
            "Cal. Yearly Month Name"::April : ;
            "Cal. Yearly Month Name"::May : ;
            "Cal. Yearly Month Name"::June : ;
            "Cal. Yearly Month Name"::July : ;
            "Cal. Yearly Month Name"::August : ;
            "Cal. Yearly Month Name"::September : ;
            "Cal. Yearly Month Name"::October : ;
            "Cal. Yearly Month Name"::November : ;
            "Cal. Yearly Month Name"::December : ;
          end;

          // -Day No.
            "Cal. Yearly Mth. Fixed Day No." := 0;

          // -Day Relative
          // Used by Monthly and Yearly
          case "Cal. Type of Day" of
            "Cal. Type of Day"::" " : ;
            "Cal. Type of Day"::Day : ;
            "Cal. Type of Day"::"Working Day" : ;
            "Cal. Type of Day"::"Nonworking Day" : ;
            "Cal. Type of Day"::Monday : ;
            "Cal. Type of Day"::Tuesday : ;
            "Cal. Type of Day"::Wednesday : ;
            "Cal. Type of Day"::Thursday : ;
            "Cal. Type of Day"::Friday : ;
            "Cal. Type of Day"::Saturday : ;
            "Cal. Type of Day"::Sunday : ;
          end;
          case "Cal. Which Day in Month" of
            "Cal. Which Day in Month"::" " : ;
            "Cal. Which Day in Month"::First : ;
            "Cal. Which Day in Month"::Second : ;
            "Cal. Which Day in Month"::Third : ;
            "Cal. Which Day in Month"::Fourth : ;
            "Cal. Which Day in Month"::Last : ;
          end;
        end;
    end;
}

