page 74155 "MCH Sched-FCast Param. Setup"
{
    Caption = 'Calculation Settings';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                group(Control1101214011)
                {
                    ShowCaption = false;
                    Visible = ShowCalculationMode;
                    field(CalculationMode;CalculationMode)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Calculation Mode';
                        Editable = ShowCalculationMode;
                        Enabled = ShowCalculationMode;
                        Importance = Promoted;
                        OptionCaption = 'Forecast,Schedule Simulation';
                        Visible = ShowCalculationMode;
                    }
                }
                field(StartingDate;StartingDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Period Starting Date';
                    ShowMandatory = true;
                }
                field(EndingDate;EndingDate)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Period Ending Date';
                    ShowMandatory = true;
                }
                field(TaskRecurrenceLimit;TaskRecurrenceLimit)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Maint. Task Recurrence Limit';
                    MinValue = 1;
                    ToolTip = 'Specifies the maximum number of times (days) that a Recurring task can occur within the period.';
                }
                group(Control1101214007)
                {
                    ShowCaption = false;
                    Visible = ShowDefMaintLocation;
                    field(DefMaintLocationCode;DefMaintLocationCode)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Default Maint. Location Code';
                        Editable = ShowDefMaintLocation;
                        Enabled = ShowDefMaintLocation;
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
                field(Placeholder;Placeholder)
                {
                    ApplicationArea = Basic,Suite;
                    ShowCaption = false;
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
                          (CalculationMode = CalculationMode::"Schedule Simulation"),true,
                          StartingDate,EndingDate,TaskRecurrenceLimit,DefMaintLocationCode);
                    end;
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
        ShowDefMaintLocation := not AMSetup."Asset Fixed Maint. Loc. Mand.";
        ShowCalculationMode := not SetForScheduling;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::OK then begin
          if not CheckValues then begin
            Message(GetLastErrorText);
            exit(false);
          end;
        end;
    end;

    var
        AMSetup: Record "MCH Asset Maintenance Setup";
        AMScheduleMgt: Codeunit "MCH AM Schedule Mgt.";
        [InDataSet]
        ShowDefMaintLocation: Boolean;
        [InDataSet]
        ShowCalculationMode: Boolean;
        [InDataSet]
        SetForScheduling: Boolean;
        StartingDate: Date;
        EndingDate: Date;
        TaskRecurrenceLimit: Integer;
        DefMaintLocationCode: Code[20];
        CalculationMode: Option Forecast,"Schedule Simulation";
        ExcludeTasksOnPlanningWksh: Boolean;
        ResetToDefaultText: Label 'Reset to default values...';
        Placeholder: Label 'Placeholder';


    procedure SetValues(ParamForScheduling: Boolean;CurrCalculationMode: Option Forecast,"Schedule Simulation";CurrStartingDate: Date;CurrEndingDate: Date;CurrTaskRecurrenceLimit: Integer;CurrDefMaintLocationCode: Code[20];CurrExcludeTasksOnPlanningWksh: Boolean)
    begin
        SetForScheduling := ParamForScheduling;
        if SetForScheduling then
          CalculationMode := CalculationMode::"Schedule Simulation";

        CalculationMode := CurrCalculationMode;
        StartingDate := CurrStartingDate;
        EndingDate := CurrEndingDate;
        TaskRecurrenceLimit := CurrTaskRecurrenceLimit;
        DefMaintLocationCode := CurrDefMaintLocationCode;
        ExcludeTasksOnPlanningWksh := CurrExcludeTasksOnPlanningWksh;
    end;


    procedure GetValues(var NewCalculationMode: Option Forecast,"Schedule Simulation";var NewStartingDate: Date;var NewEndingDate: Date;var NewTaskRecurrenceLimit: Integer;var NewDefMaintLocationCode: Code[20];var NewExcludeTasksOnPlanningWksh: Boolean)
    begin
        NewCalculationMode := CalculationMode;
        NewStartingDate := StartingDate;
        NewEndingDate := EndingDate;
        NewTaskRecurrenceLimit := TaskRecurrenceLimit;
        NewDefMaintLocationCode := DefMaintLocationCode;
        NewExcludeTasksOnPlanningWksh := ExcludeTasksOnPlanningWksh;
    end;

    [TryFunction]
    local procedure CheckValues()
    var
        MaxPeriodDays: Integer;
        MaxTaskRecurrenceLimit: Integer;
        Text001: Label 'You must specify the Starting Date.';
        Text002: Label 'You must specify the Ending Date.';
        Text003: Label 'The Starting Date cannot be later than the Ending Date.';
        Text004: Label 'The Maint. Task Recurrence Limit must not exceed %1.';
        Text005: Label 'The no. days in the period (%1 to %2) must not exceed %3.';
    begin
        AMSetup.Get;
        if (CalculationMode = CalculationMode::"Schedule Simulation") then begin
          MaxPeriodDays := AMSetup."Max. Sched. Look Ahead (Days)";
          MaxTaskRecurrenceLimit := AMSetup."Schedule Task Recurr. Limit";
        end else begin
          MaxPeriodDays := AMSetup."Forecast Look Ahead (Days)";
          MaxTaskRecurrenceLimit := AMSetup."Forecast Task Recurr. Limit";
        end;

        if StartingDate = 0D then
          Error(Text001);
        if EndingDate = 0D then
          Error(Text002);
        if StartingDate > EndingDate then
          Error(Text003);
        if (TaskRecurrenceLimit > MaxTaskRecurrenceLimit) then
          Error(Text004,MaxTaskRecurrenceLimit);
        if (EndingDate - StartingDate + 1) > MaxPeriodDays then
          Error(Text005,StartingDate,EndingDate,MaxPeriodDays);
    end;
}

